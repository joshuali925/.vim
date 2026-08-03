local M = {}

local DAY_START_HOUR = 4
local LEARNING_STEPS = { 60, 10 * 60 }
local RELEARNING_STEPS = { 10 * 60 }
local MAX_INTERVAL = 36500
local LEARN_AHEAD_SECS = 20 * 60
local LEARNING_FUZZ_SECS = 5 * 60

local W = {
    [0] = 0.212,
    [1] = 1.2931,
    [2] = 2.3065,
    [3] = 8.2956,
    [4] = 6.4133,
    [5] = 0.8334,
    [6] = 3.0194,
    [7] = 0.001,
    [8] = 1.8722,
    [9] = 0.1666,
    [10] = 0.796,
    [11] = 1.4835,
    [12] = 0.0614,
    [13] = 0.2629,
    [14] = 1.6483,
    [15] = 0.6014,
    [16] = 1.8729,
    [17] = 0.5425,
    [18] = 0.0912,
    [19] = 0.0658,
    [20] = 0.1542,
}

local RATING = { again = 1, hard = 2, good = 3, easy = 4 }
local STATE = { new = "new", learning = "learning", review = "review", relearning = "relearning" }
local FUZZ_RANGES = { { start = 2.5, stop = 7.0, factor = 0.15 }, { start = 7.0, stop = 20.0, factor = 0.10 }, { start = 20.0, stop = math.huge, factor = 0.05 } }

local function fuzz_delta(interval)
    if interval < 2.5 then return 0 end
    local delta = 1.0
    for _, r in ipairs(FUZZ_RANGES) do
        delta = delta + r.factor * math.max(0, math.min(interval, r.stop) - r.start)
    end
    return delta
end

local function with_review_fuzz(interval, random)
    interval = math.min(interval, MAX_INTERVAL)
    local delta = fuzz_delta(interval)
    local lower = math.min(MAX_INTERVAL, math.max(1, math.floor(interval - delta + 0.5)))
    local upper = math.min(MAX_INTERVAL, math.max(lower, math.floor(interval + delta + 0.5)))
    return random(lower, upper)
end

local function civil_day_number(y, m, d)
    y = y - ((m <= 2) and 1 or 0)
    local era = math.floor(y / 400)
    local yoe = y - era * 400
    local mp = m + ((m > 2) and -3 or 9)
    local doy = math.floor((153 * mp + 2) / 5) + d - 1
    return era * 146097 + yoe * 365 + math.floor(yoe / 4) - math.floor(yoe / 100) + doy
end

local function study_date(now)
    local date = os.date("*t", math.floor(now / 1000))
    if date.hour < DAY_START_HOUR then
        date.day = date.day - 1
        date = os.date("*t", os.time(date))
    end
    return date
end

local function study_day_number(now)
    local d = study_date(now)
    return civil_day_number(d.year, d.month, d.day)
end

local function review_due(now, offset)
    local d = study_date(now)
    d.day, d.hour, d.min, d.sec = d.day + (offset or 0), DAY_START_HOUR, 0, 0
    return os.time(d) * 1000
end

local function elapsed_study_days(now, last)
    if not last or last == 0 then return 0 end
    return math.max(0, study_day_number(now) - study_day_number(last))
end

local DECAY = -W[20]
local FACTOR = 0.9 ^ (1 / DECAY) - 1

local function clamp_difficulty(d) return math.min(math.max(d, 1), 10) end
local function clamp_stability(s) return math.max(s, 0.001) end
local function retrievability(s, elapsed) return (1 + (FACTOR * elapsed) / s) ^ DECAY end
local function initial_stability(rating) return clamp_stability(W[rating - 1]) end
local function raw_difficulty(rating) return W[4] - math.exp(W[5] * (rating - 1)) + 1 end
local function initial_difficulty(rating) return clamp_difficulty(raw_difficulty(rating)) end

local function next_difficulty(difficulty, rating)
    local damped = difficulty + ((10 - difficulty) * -(W[6] * (rating - 3))) / 9
    return clamp_difficulty(W[7] * raw_difficulty(4) + (1 - W[7]) * damped)
end

local function next_forget_stability(d, s, r)
    local long_term = W[11] * d ^ -W[12] * ((s + 1) ^ W[13] - 1) * math.exp((1 - r) * W[14])
    return math.min(long_term, s / math.exp(W[17] * W[18]))
end

local function next_recall_stability(d, s, r, rating)
    local hard = (rating == RATING.hard) and W[15] or 1
    local easy = (rating == RATING.easy) and W[16] or 1
    return s * (1 + math.exp(W[8]) * (11 - d) * s ^ -W[9] * (math.exp((1 - r) * W[10]) - 1) * hard * easy)
end

local function short_term_stability(s, rating)
    local inc = math.exp(W[17] * (rating - 3 + W[18])) * s ^ -W[19]
    if rating >= RATING.hard then inc = math.max(inc, 1) end
    return clamp_stability(s * inc)
end

local function learning_hard_delay(steps, step)
    if step > 0 then return steps[step + 1] or steps[#steps] end
    if #steps >= 2 then return (steps[1] + steps[2]) / 2 end
    return steps[1] * 1.5
end

local function with_learning_fuzz(delay, random)
    return delay + random(0, math.min(LEARNING_FUZZ_SECS, math.floor(delay / 2)))
end

local function graduate(card, rating, now, from_new, random)
    card.state, card.step = STATE.review, 0
    if from_new or not card.stability or not card.difficulty then
        card.stability = initial_stability(rating)
        card.difficulty = initial_difficulty(rating)
    end
    card.interval = with_review_fuzz(card.stability, random)
    card.due, card.last, card.updatedAt = review_due(now, card.interval), now, now
end

local function schedule_learning(card, rating, now, random)
    local from_new = card.state == STATE.new
    local steps = (card.state == STATE.relearning) and RELEARNING_STEPS or LEARNING_STEPS
    local step = math.max(0, tonumber(card.step) or 0)

    card.reps = (card.reps or 0) + 1

    if rating == RATING.easy or (rating == RATING.good and step >= #steps - 1) then
        graduate(card, rating, now, from_new, random)
        return
    end

    if from_new then card.state = STATE.learning end
    local next_step, delay
    if rating == RATING.again then
        next_step, delay = 0, steps[1]
    elseif rating == RATING.hard then
        next_step, delay = step, learning_hard_delay(steps, step)
    else
        next_step, delay = step + 1, steps[step + 2]
    end
    card.step = next_step
    card.due = now + math.floor(with_learning_fuzz(delay, random) * 1000)
    card.last, card.updatedAt = now, now
end

local function schedule_review(card, rating, now, random)
    local stability, difficulty = tonumber(card.stability), tonumber(card.difficulty)

    if not stability or not difficulty or not card.last or card.last == 0 then
        stability, difficulty = initial_stability(rating), initial_difficulty(rating)
    else
        local elapsed_days = elapsed_study_days(now, card.last)
        if elapsed_days < 1 then
            stability = short_term_stability(stability, rating)
        else
            local r = retrievability(stability, elapsed_days)
            stability = clamp_stability((rating == RATING.again)
                and next_forget_stability(difficulty, stability, r)
                or next_recall_stability(difficulty, stability, r, rating))
        end
        difficulty = next_difficulty(difficulty, rating)
    end

    card.stability, card.difficulty = stability, difficulty
    card.reps = (card.reps or 0) + 1
    card.last, card.updatedAt = now, now
    card.step = 0

    if rating == RATING.again then
        card.lapses = (card.lapses or 0) + 1
        card.state, card.due = STATE.relearning, now + RELEARNING_STEPS[1] * 1000
        return
    end
    card.interval = with_review_fuzz(stability, random)
    card.state, card.due = STATE.review, review_due(now, card.interval)
end

local function schedule(card, rating, now, random)
    if card.state == STATE.review then
        schedule_review(card, rating, now, random)
    else
        schedule_learning(card, rating, now, random)
    end
end

local function trim(s) return tostring(s or ""):match("^%s*(.-)%s*$") end
local function key_of(word, reading) return trim(word) .. "|" .. trim(reading) end
local function card_key(card) return key_of(card.word, card.reading) end

local function parse_csv(text)
    local rows, record, buf, nb, in_quotes = {}, {}, {}, 0, false
    local i, n = 1, #text
    local function push_field()
        record[#record + 1] = table.concat(buf, "", 1, nb)
        nb = 0
    end
    while i <= n do
        if in_quotes then
            local q = text:find('"', i, true)
            if not q then
                nb = nb + 1; buf[nb] = text:sub(i)
                i = n + 1
            else
                if q > i then
                    nb = nb + 1; buf[nb] = text:sub(i, q - 1)
                end
                if text:byte(q + 1) == 34 then
                    nb = nb + 1; buf[nb] = '"'
                    i = q + 2
                else
                    in_quotes = false
                    i = q + 1
                end
            end
        else
            local s, _, ch = text:find('([",\n\r])', i)
            if not s then
                nb = nb + 1; buf[nb] = text:sub(i)
                i = n + 1
            else
                if s > i then
                    nb = nb + 1; buf[nb] = text:sub(i, s - 1)
                end
                if ch == '"' then
                    if nb == 0 then
                        in_quotes = true
                    else
                        nb = nb + 1; buf[nb] = '"'
                    end
                elseif ch == "," then
                    push_field()
                elseif ch == "\n" then
                    push_field()
                    rows[#rows + 1] = record
                    record = {}
                end
                i = s + 1
            end
        end
    end
    if nb > 0 or #record > 0 then
        push_field()
        rows[#rows + 1] = record
    end
    return rows
end

local CSV_HEADER = {
    "word", "reading", "meaning", "reps", "lapses", "stability", "difficulty",
    "interval", "due", "last", "updatedAt", "learned", "state", "step",
}
local CSV_HEADER_LINE = table.concat(CSV_HEADER, ",")

local function csv_field(s)
    return '"' .. tostring(s == nil and "" or s):gsub('"', '""') .. '"'
end

local function card_csv_row(card)
    return table.concat({
        csv_field(card.word), csv_field(card.reading), csv_field(card.meaning),
        card.reps or 0, card.lapses or 0, card.stability or "", card.difficulty or "",
        card.interval or 0, card.due or "", card.last or 0, card.updatedAt or "",
        card.learned and 1 or 0, card.state or STATE.new, card.step or 0,
    }, ",")
end

local function row_to_card(r, now)
    return {
        word = r[1],
        reading = r[2] or "",
        meaning = r[3] or "",
        reps = tonumber(r[4]) or 0,
        lapses = tonumber(r[5]) or 0,
        stability = tonumber(r[6]),
        difficulty = tonumber(r[7]),
        interval = tonumber(r[8]) or 0,
        due = tonumber(r[9]) or now,
        last = tonumber(r[10]) or 0,
        updatedAt = tonumber(r[11]) or now,
        learned = r[12] == "1" or r[12] == "true",
        state = STATE[trim(r[13])] or STATE.new,
        step = tonumber(r[14]) or 0,
    }
end

local function day_shuffle_key(key, day)
    local hash = 2166136261 ~ (day & 0xffffffff)
    for i = 1, #key do
        hash = (hash ~ key:byte(i)) & 0xffffffff
        hash = (hash * 16777619) & 0xffffffff
    end
    return hash
end

local Deck = {}
Deck.__index = Deck

function M.new(opts)
    return setmetatable({
        dir = opts.dir,
        now = opts.now or function() return os.time() * 1000 end,
        random = opts.random or math.random,
        mkdir = opts.mkdir or function(dir)
            os.execute("mkdir -p '" .. dir:gsub("'", [['\'']]) .. "'")
        end,
        cards = {},
        order = {},
        revealed = false,
        archived_keys = {},
    }, Deck)
end

function Deck:vocab_path() return self.dir .. "/vocab.csv" end

function Deck:learned_path() return self.dir .. "/learned.csv" end

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local s = f:read("*a")
    f:close()
    return s
end

function Deck:write_file(path, s)
    local tmp = path .. ".tmp"
    local f = io.open(tmp, "w")
    if not f then
        self.mkdir(self.dir)
        f = io.open(tmp, "w")
        if not f then return false end
    end
    f:write(s)
    f:close()
    return os.rename(tmp, path)
end

local function card_rows(csv)
    local rows = parse_csv(csv or "")
    local n = #rows
    local i = (rows[1] and trim(rows[1][1]) == CSV_HEADER[1]) and 1 or 0
    return function()
        while i < n do
            i = i + 1
            local row = rows[i]
            if row[1] and row[1] ~= "" then
                local key = key_of(row[1], row[2])
                -- Invalid UTF-8 cannot be assigned to wezterm.GLOBAL, and the error
                -- would surface as a dead key with a frozen status bar.
                if utf8.len(key) then return row, key end
            end
        end
    end
end

local function merge_rows(csv, order, cards, now)
    for row, key in card_rows(csv) do
        if not cards[key] then
            order[#order + 1] = key
            cards[key] = row_to_card(row, now)
            cards[key].key = key
        end
    end
    return order, cards
end

function Deck:load_vocab(now)
    self.written_csv = read_file(self:vocab_path())
    return merge_rows(self.written_csv, {}, {}, now)
end

function Deck:load_archived_keys()
    local keys = {}
    for _, key in card_rows(read_file(self:learned_path())) do keys[key] = true end
    return keys
end

function Deck:append_learned()
    local pending, pending_keys = {}, {}
    for _, key in ipairs(self.order) do
        local card = self.cards[key]
        if card and card.learned and not self.archived_keys[key] and not pending_keys[key] then
            pending[#pending + 1] = card_csv_row(card)
            pending_keys[key] = true
        end
    end
    if #pending == 0 then return true end

    local path = self:learned_path()
    local prefix = CSV_HEADER_LINE .. "\n"
    local probe = io.open(path, "r")
    if probe then
        local size = probe:seek("end")
        if size > 0 then
            probe:seek("set", size - 1)
            prefix = probe:read(1) == "\n" and "" or "\n"
        end
        probe:close()
    end

    local f = io.open(path, "a")
    if not f then
        self.mkdir(self.dir)
        f = io.open(path, "a")
        if not f then return false end
    end
    f:write(prefix .. table.concat(pending, "\n") .. "\n")
    f:close()
    for key in pairs(pending_keys) do self.archived_keys[key] = true end
    return true
end

function Deck:remove_archived(key)
    local csv = read_file(self:learned_path())
    if not csv then
        self.archived_keys[key] = nil
        return true
    end

    local lines, removed = {}, false
    for line in (csv:gsub("\n$", "")):gmatch("[^\n]*") do
        local row = parse_csv(line)[1]
        if row and row[1] and row[1] ~= "" and key_of(row[1], row[2]) == key then
            removed = true
        else
            lines[#lines + 1] = line
        end
    end
    if not removed then
        self.archived_keys[key] = nil
        return true
    end

    local ok = self:write_file(self:learned_path(), table.concat(lines, "\n") .. "\n")
    if ok then self.archived_keys[key] = nil end
    return ok
end

function Deck:reconcile_vocab()
    local csv = read_file(self:vocab_path())
    if not csv or csv == self.written_csv then return end
    merge_rows(csv, self.order, self.cards, self.now())
end

function Deck:save()
    self:reconcile_vocab()
    self:append_learned()
    local lines = { CSV_HEADER_LINE }
    for _, k in ipairs(self.order) do
        local c = self.cards[k]
        if c and (not c.learned or not self.archived_keys[k]) then
            c.row = c.row or card_csv_row(c)
            lines[#lines + 1] = c.row
        end
    end
    local csv = table.concat(lines, "\n") .. "\n"
    local ok = self:write_file(self:vocab_path(), csv)
    if ok then self.written_csv = csv end
    return ok
end

local function shuffle_hash(card, day)
    if card.hash_day ~= day then
        card.hash_day, card.hash = day, day_shuffle_key(card.key or card_key(card), day)
    end
    return card.hash
end

local function before(a, b, day)
    if (a.due or 0) ~= (b.due or 0) then return (a.due or 0) < (b.due or 0) end
    if (a.shown or 0) ~= (b.shown or 0) then return (a.shown or 0) < (b.shown or 0) end
    local a_hash, b_hash = shuffle_hash(a, day), shuffle_hash(b, day)
    if a_hash ~= b_hash then return a_hash < b_hash end
    return (a.key or card_key(a)) < (b.key or card_key(b))
end

function Deck:pick(now)
    local day = study_day_number(now)
    local learn_cutoff = now + LEARN_AHEAD_SECS * 1000
    local learning, learning_ahead, review, new
    local next_due

    for _, key in ipairs(self.order) do
        local card = self.cards[key]
        if card and not card.learned then
            if (card.due or 0) > now and (not next_due or card.due < next_due) then
                next_due = card.due
            end
            if card.state == STATE.new then
                if not new or before(card, new, day) then new = card end
            elseif card.state == STATE.learning or card.state == STATE.relearning then
                if (card.due or 0) <= now then
                    if not learning or before(card, learning, day) then learning = card end
                elseif (card.due or 0) <= learn_cutoff then
                    if not learning_ahead or before(card, learning_ahead, day) then learning_ahead = card end
                end
            elseif card.state == STATE.review and (card.due or 0) <= now then
                if not review or before(card, review, day) then review = card end
            end
        end
    end

    return learning or review or new or learning_ahead, next_due
end

function Deck:select_next(now)
    local chosen
    chosen, self.next_due = self:pick(now or self.now())
    self.current_key = chosen and (chosen.key or card_key(chosen)) or nil
    self.revealed = false
end

function Deck:current()
    if self.current_key and self.cards[self.current_key] then
        return self.cards[self.current_key]
    end
    self:select_next()
    return self.current_key and self.cards[self.current_key] or nil
end

function Deck:setup()
    local now = self.now()
    self.order, self.cards = self:load_vocab(now)
    self.archived_keys = self:load_archived_keys()
    self.undo_entry = nil
    self.last_key = nil
    for key, card in pairs(self.cards) do
        if card.learned and not self.archived_keys[key] then
            self:save()
            break
        end
    end
    self:select_next(now)
    return self
end

local function format_wait(ms)
    local minutes = math.ceil(ms / (60 * 1000))
    if minutes < 60 then return string.format("%dm", minutes) end
    local hours = math.floor(minutes / 60)
    if hours < 24 then
        if minutes % 60 == 0 then return string.format("%dh", hours) end
        return string.format("%dh%dm", hours, minutes % 60)
    end
    local days = math.floor(hours / 24)
    if hours % 24 == 0 then return string.format("%dd", days) end
    return string.format("%dd%dh", days, hours % 24)
end

function Deck:label()
    local card = self:current()
    if not card then
        if not self.next_due then return nil end
        return format_wait(math.max(0, self.next_due - self.now()))
    end
    if not self.revealed then return card.word or "" end
    return string.format("%s  %s · %s", card.word or "", card.reading or "", card.meaning or "")
end

function Deck:export()
    local shown = {}
    for key, card in pairs(self.cards) do
        if card.shown then shown[key] = card.shown end
    end
    return {
        current_key = self.current_key,
        revealed = self.revealed,
        last_key = self.last_key,
        shown_count = self.shown_count,
        shown = shown,
    }
end

function Deck:import(state)
    if not state then return end
    self.last_key = state.last_key
    self.shown_count = tonumber(state.shown_count) or 0
    if type(state.shown) == "table" then
        for key, n in pairs(state.shown) do
            local card, shown = self.cards[key], tonumber(n)
            if card and shown then card.shown = shown end
        end
    end
    if state.current_key and self.cards[state.current_key] then
        self.current_key = state.current_key
        self.revealed = state.revealed or false
    else
        self:select_next()
    end
end

function Deck:reveal()
    if not self:current() or self.revealed then return false end
    self.revealed = true
    return true
end

function Deck:push_undo(card)
    local copy = {}
    for k, v in pairs(card) do copy[k] = v end
    self.undo_entry = {
        card_key = card_key(card),
        card = copy,
        current_key = self.current_key,
        revealed = self.revealed,
        last_key = self.last_key,
    }
end

function Deck:answer(rating)
    local card = self:current()
    if not card then return false end
    local now = self.now()
    self:push_undo(card)
    if rating then
        schedule(card, rating, now, self.random)
    else
        card.learned, card.updatedAt = true, now
    end
    self.shown_count = (self.shown_count or 0) + 1
    card.shown = self.shown_count
    card.row = nil
    self.last_key = card.key or card_key(card)
    self:save()
    self:select_next(now)
    return true
end

function Deck:undo()
    local previous = self.undo_entry
    if not previous then return false end
    if not previous.card.learned and self.archived_keys[previous.card_key] then
        self:remove_archived(previous.card_key)
    end
    previous.card.row = nil
    self.cards[previous.card_key] = previous.card
    self.current_key = previous.current_key
    self.revealed = previous.revealed
    self.last_key = previous.last_key
    self.undo_entry = nil
    self:save()
    return true
end

function Deck:reveal_or_grade(grade)
    if not self:current() then return false end
    if not self.revealed then return self:reveal() end
    local rating = RATING[grade]
    return rating and self:answer(rating) or false
end

function Deck:reveal_or_mark_learned()
    if not self:current() then return false end
    if not self.revealed then return self:reveal() end
    return self:answer(nil)
end

if not package.loaded["wezterm"] and not package.preload["wezterm"] then return M end

local wezterm = require("wezterm")

-- GLOBAL survives config reloads; session does not, so undo history is lost on reload.
local session

local function load_deck()
    if session then return session end
    local deck = M.new({ dir = wezterm.home_dir .. "/.local/share/anki", mkdir = function(dir) wezterm.run_child_process({ "mkdir", "-p", dir }) end })
    deck:setup()
    deck:import(wezterm.GLOBAL.anki)
    session = deck
    return session
end

local function publish(deck)
    local label = deck:label() or " "
    local state = deck:export()
    state.label = label
    if not deck.current_key then state.next_due = deck.next_due end
    wezterm.GLOBAL.anki = state
    return label
end

function M.binding(method, ...)
    local args = { ... }
    return wezterm.action_callback(function(window)
        window:perform_action(wezterm.action.ActivateKeyTable({ name = "anki_grade", one_shot = false, replace_current = true, until_unknown = true }), window:active_pane())
        local deck = load_deck()
        local changed = deck[method](deck, table.unpack(args))
        publish(deck)
        if changed then wezterm.emit("update-status", window, window:active_pane()) end
    end)
end

function M.setup()
    math.randomseed(os.time())
    session = nil
    publish(load_deck())
end

function M.component()
    local state = wezterm.GLOBAL.anki
    if not state or not state.label then return publish(load_deck()) end
    if not state.next_due then return state.label end
    local remaining = state.next_due - os.time() * 1000
    if remaining <= 0 then return publish(load_deck()) end
    return format_wait(remaining)
end

return M
