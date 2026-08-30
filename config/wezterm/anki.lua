local M = {}

local DAY_START_HOUR = 4
local LEARNING_STEPS = { 60, 10 * 60 }
local RELEARNING_STEPS = { 10 * 60 }
local MAX_INTERVAL = 36500
local LEARN_AHEAD_SECS = 20 * 60
local LEARNING_FUZZ_SECS = 5 * 60
local S_MIN, S_MAX, D_MIN, D_MAX = 0.001, 36500, 1, 10
local INIT_S_MAX = 100
local TARGET_RETENTION = 0.9
local OPTIMIZE_INTERVAL_MS = 7 * 24 * 60 * 60 * 1000

local DEFAULT_W = {
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

local function clamp(x, lo, hi) return math.min(math.max(x, lo), hi) end
local function decay_of(w) return -w[20] end
local function factor_of(w) return 0.9 ^ (1 / decay_of(w)) - 1 end
local function retrievability(w, s, elapsed) return (1 + factor_of(w) * elapsed / s) ^ decay_of(w) end
local function initial_stability(w, rating) return clamp(w[rating - 1], S_MIN, S_MAX) end
local function raw_difficulty(w, rating) return w[4] - math.exp(w[5] * (rating - 1)) + 1 end
local function initial_difficulty(w, rating) return clamp(raw_difficulty(w, rating), D_MIN, D_MAX) end

local function next_difficulty(w, difficulty, rating)
    local damped = difficulty + ((10 - difficulty) * -(w[6] * (rating - 3))) / 9
    return clamp(w[7] * raw_difficulty(w, 4) + (1 - w[7]) * damped, D_MIN, D_MAX)
end

local function next_forget_stability(w, d, s, r)
    local long_term = w[11] * d ^ -w[12] * ((s + 1) ^ w[13] - 1) * math.exp((1 - r) * w[14])
    return math.min(long_term, s / math.exp(w[17] * w[18]))
end

local function next_recall_stability(w, d, s, r, rating)
    local hard = (rating == RATING.hard) and w[15] or 1
    local easy = (rating == RATING.easy) and w[16] or 1
    return s * (1 + math.exp(w[8]) * (11 - d) * s ^ -w[9] * (math.exp((1 - r) * w[10]) - 1) * hard * easy)
end

local function short_term_stability(w, s, rating)
    local inc = math.exp(w[17] * (rating - 3 + w[18])) * s ^ -w[19]
    if rating >= RATING.hard then inc = math.max(inc, 1) end
    return s * inc
end

local function step_state(w, s, d, delta_t, rating, is_first)
    if is_first then return initial_stability(w, rating), initial_difficulty(w, rating) end
    s, d = clamp(s, S_MIN, S_MAX), clamp(d, D_MIN, D_MAX)
    local new_s
    if delta_t <= 0 then
        new_s = short_term_stability(w, s, rating)
    elseif rating == RATING.again then
        new_s = next_forget_stability(w, d, s, retrievability(w, s, delta_t))
    else
        new_s = next_recall_stability(w, d, s, retrievability(w, s, delta_t), rating)
    end
    return clamp(new_s, S_MIN, S_MAX), next_difficulty(w, d, rating)
end

local function next_interval(w, stability)
    return stability / factor_of(w) * (TARGET_RETENTION ^ (1 / decay_of(w)) - 1)
end

local function learning_hard_delay(steps, step)
    if step > 0 then return steps[step + 1] or steps[#steps] end
    if #steps >= 2 then return (steps[1] + steps[2]) / 2 end
    return steps[1] * 1.5
end

local function with_learning_fuzz(delay, random)
    return delay + random(0, math.min(LEARNING_FUZZ_SECS, math.floor(delay / 2)))
end

local function update_memory(card, rating, now, w)
    local is_first = not card.stability or not card.difficulty
    local delta_t = is_first and 0 or elapsed_study_days(now, card.last)
    card.stability, card.difficulty = step_state(w, card.stability or 0, card.difficulty or 0, delta_t, rating, is_first)
end

local function schedule(card, rating, now, w, random)
    update_memory(card, rating, now, w)
    card.reps = (card.reps or 0) + 1
    card.last, card.updatedAt = now, now

    if card.state == STATE.review then
        card.step = 0
        if rating == RATING.again then
            card.lapses = (card.lapses or 0) + 1
            card.state, card.due = STATE.relearning, now + RELEARNING_STEPS[1] * 1000
        else
            card.interval = with_review_fuzz(next_interval(w, card.stability), random)
            card.state, card.due = STATE.review, review_due(now, card.interval)
        end
        return
    end

    local from_new = card.state == STATE.new
    local steps = (card.state == STATE.relearning) and RELEARNING_STEPS or LEARNING_STEPS
    local step = math.max(0, tonumber(card.step) or 0)

    if rating == RATING.easy or (rating == RATING.good and step >= #steps - 1) then
        card.state, card.step = STATE.review, 0
        card.interval = with_review_fuzz(next_interval(w, card.stability), random)
        card.due = review_due(now, card.interval)
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
end

local function trim(s) return tostring(s or ""):match("^%s*(.-)%s*$") end
local function key_of(front) return trim(front) end
local function card_key(card) return key_of(card.front) end

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
    "front", "back", "reps", "lapses", "stability", "difficulty",
    "interval", "due", "last", "updatedAt", "learned", "state", "step",
}
local CSV_HEADER_LINE = table.concat(CSV_HEADER, ",")

local function csv_field(s)
    return '"' .. tostring(s == nil and "" or s):gsub('"', '""') .. '"'
end

local function card_csv_row(card)
    return table.concat({
        csv_field(card.front), csv_field(card.back),
        card.reps or 0, card.lapses or 0, card.stability or "", card.difficulty or "",
        card.interval or 0, card.due or "", card.last or 0, card.updatedAt or "",
        card.learned and 1 or 0, card.state or STATE.new, card.step or 0,
    }, ",")
end

local function row_to_card(r, now)
    return {
        front = r[1],
        back = r[2] or "",
        reps = tonumber(r[3]) or 0,
        lapses = tonumber(r[4]) or 0,
        stability = tonumber(r[5]),
        difficulty = tonumber(r[6]),
        interval = tonumber(r[7]) or 0,
        due = tonumber(r[8]) or now,
        last = tonumber(r[9]) or 0,
        updatedAt = tonumber(r[10]) or now,
        learned = r[11] == "1" or r[11] == "true",
        state = STATE[trim(r[12])] or STATE.new,
        step = tonumber(r[13]) or 0,
    }
end

local function day_shuffle_key(key, day)
    local hash = (2166136261 + day) % 4294967296
    for i = 1, #key do
        hash = (hash * 65599 + key:byte(i)) % 4294967296
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
        optimizer = opts.optimizer,
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

function Deck:revlog_path() return self.dir .. "/revlog.csv" end

function Deck:params_path() return self.dir .. "/params.txt" end

function Deck:optimized_at_path() return self.dir .. "/optimized_at.txt" end

local REVLOG_HEADER = "key,timestamp,rating,delta_t,state"

function Deck:load_weights()
    local s = read_file(self:params_path())
    if not s then return DEFAULT_W end
    local w, i = {}, 0
    for num in s:gmatch("[-+]?[0-9]*%.?[0-9]+[eE]?[-+]?[0-9]*") do
        w[i], i = tonumber(num), i + 1
    end
    return i == 21 and w or DEFAULT_W
end

function Deck:maybe_optimize(now)
    if not self.optimizer then return end
    local last = tonumber(read_file(self:optimized_at_path()) or "") or 0
    if now - last < OPTIMIZE_INTERVAL_MS then return end
    if pcall(self.optimizer, self.dir) then
        self:write_file(self:optimized_at_path(), tostring(now) .. "\n")
    end
end

function Deck:log_review(card, rating, now, delta_t, state)
    local line = table.concat({ csv_field(card.key or card_key(card)), now, rating, delta_t, state or STATE.new }, ",")
    local path, prefix, size = self:revlog_path(), REVLOG_HEADER .. "\n", 0
    local probe = io.open(path, "r")
    if probe then
        size = probe:seek("end")
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
        if not f then return end
    end
    f:write(prefix .. line .. "\n")
    f:close()
    self.revlog_undo_size = size
end

function Deck:undo_revlog()
    local target = self.revlog_undo_size
    self.revlog_undo_size = nil
    if not target then return end
    local content = read_file(self:revlog_path())
    if content then self:write_file(self:revlog_path(), content:sub(1, target)) end
end

function Deck:retention()
    local rows = parse_csv(read_file(self:revlog_path()) or "")
    local pass, total = 0, 0
    local start = (rows[1] and rows[1][1] == "key") and 2 or 1
    for i = start, #rows do
        local r = rows[i]
        local rating, delta_t = tonumber(r[3]), tonumber(r[4])
        if rating and delta_t and delta_t > 0 and trim(r[5]) == STATE.review then
            total = total + 1
            if rating > 1 then pass = pass + 1 end
        end
    end
    if total == 0 then return nil end
    return pass / total, total
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
                local key = key_of(row[1])
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
        if row and row[1] and row[1] ~= "" and key_of(row[1]) == key then
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
    self.weights = self:load_weights()
    self:maybe_optimize(now)
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
    if not self.revealed then return card.front or "" end
    return string.format("%s  %s", card.front or "", card.back or "")
end

function Deck:card_text()
    local card = self:current()
    if not card then return nil end
    return string.format("%s: %s", card.front or "", card.back or "")
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
        local is_first = not card.stability or not card.difficulty
        local delta_t = is_first and 0 or elapsed_study_days(now, card.last)
        self:log_review(card, rating, now, delta_t, card.state)
        schedule(card, rating, now, self.weights or DEFAULT_W, self.random)
        if card.state == STATE.review and (card.interval or 0) > 365 then
            card.learned = true
        end
    else
        self.revlog_undo_size = nil
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
    self:undo_revlog()
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

local PARAMS_STDDEV = {
    [0] = 6.43,
    [1] = 9.66,
    [2] = 17.58,
    [3] = 27.85,
    [4] = 0.57,
    [5] = 0.28,
    [6] = 0.6,
    [7] = 0.12,
    [8] = 0.39,
    [9] = 0.18,
    [10] = 0.33,
    [11] = 0.3,
    [12] = 0.09,
    [13] = 0.16,
    [14] = 0.57,
    [15] = 0.25,
    [16] = 1.03,
    [17] = 0.31,
    [18] = 0.32,
    [19] = 0.14,
    [20] = 0.27,
}

local PARAM_CLAMP = {
    [0] = { S_MIN, INIT_S_MAX },
    [1] = { S_MIN, INIT_S_MAX },
    [2] = { S_MIN, INIT_S_MAX },
    [3] = { S_MIN, INIT_S_MAX },
    [4] = { D_MIN, D_MAX },
    [5] = { 0.001, 4 },
    [6] = { 0.001, 4 },
    [7] = { 0.001, 0.75 },
    [8] = { 0, 4.5 },
    [9] = { 0, 0.8 },
    [10] = { 0.001, 3.5 },
    [11] = { 0.001, 5 },
    [12] = { 0.001, 0.25 },
    [13] = { 0.001, 0.9 },
    [14] = { 0, 4 },
    [15] = { 0, 1 },
    [16] = { 1, 6 },
    [17] = { 0, 2 },
    [18] = { 0, 2 },
    [19] = { 0.01, 0.8 },
    [20] = { 0.1, 0.8 },
}

local function clip_weights(w)
    for i = 0, 20 do w[i] = clamp(w[i], PARAM_CLAMP[i][1], PARAM_CLAMP[i][2]) end
    return w
end

local function load_revlog_sequences(path)
    local rows = parse_csv(read_file(path) or "")
    local start = (rows[1] and rows[1][1] == "key") and 2 or 1
    local seqs, order = {}, {}
    for i = start, #rows do
        local r = rows[i]
        local key, rating, delta_t = r[1], tonumber(r[3]), tonumber(r[4])
        if key and key ~= "" and rating and delta_t then
            if not seqs[key] then
                seqs[key] = {}
                order[#order + 1] = key
            end
            local s = seqs[key]
            s[#s + 1] = { rating = rating, delta_t = math.max(0, delta_t), ts = tonumber(r[2]) or 0 }
        end
    end
    local list = {}
    for _, key in ipairs(order) do list[#list + 1] = seqs[key] end
    return list
end

local function item_pred(w, item)
    local reviews, s, d = item.card, 0, 0
    for k = 1, item.upto - 1 do
        local rv = reviews[k]
        s, d = step_state(w, s, d, k == 1 and 0 or rv.delta_t, rv.rating, k == 1)
    end
    return retrievability(w, s, reviews[item.upto].delta_t)
end

local function smooth_and_fill(rating_stability, rating_count)
    for r in pairs(rating_stability) do
        if not rating_count[r] then rating_stability[r] = nil end
    end
    for _, pair in ipairs({ { 1, 2 }, { 2, 3 }, { 3, 4 }, { 1, 3 }, { 2, 4 }, { 1, 4 } }) do
        local sr, br = pair[1], pair[2]
        local sv, bv = rating_stability[sr], rating_stability[br]
        if sv and bv and sv > bv then
            if rating_count[sr] > rating_count[br] then rating_stability[br] = sv else rating_stability[sr] = bv end
        end
    end
    local w1, w2 = 0.41, 0.54
    local default = { DEFAULT_W[0], DEFAULT_W[1], DEFAULT_W[2], DEFAULT_W[3] }
    local rs = { rating_stability[1], rating_stability[2], rating_stability[3], rating_stability[4] }
    local present = {}
    for r = 1, 4 do if rs[r] then present[#present + 1] = r end end
    local cnt = #present
    if cnt == 0 then return nil end
    if cnt == 1 then
        local factor = rs[present[1]] / default[present[1]]
        for i = 1, 4 do rs[i] = default[i] * factor end
    elseif cnt == 2 then
        local denom = w1 + w2 - w1 * w2
        if not rs[1] and not rs[2] then
            rs[2] = rs[3] ^ (1 / (1 - w2)) * rs[4] ^ (1 - 1 / (1 - w2))
            rs[1] = rs[2] ^ (1 / w1) * rs[3] ^ (1 - 1 / w1)
        elseif not rs[1] and not rs[3] then
            rs[3] = rs[2] ^ (1 - w2) * rs[4] ^ w2
            rs[1] = rs[2] ^ (1 / w1) * rs[3] ^ (1 - 1 / w1)
        elseif not rs[1] and not rs[4] then
            rs[4] = rs[2] ^ (1 - 1 / w2) * rs[3] ^ (1 / w2)
            rs[1] = rs[2] ^ (1 / w1) * rs[3] ^ (1 - 1 / w1)
        elseif not rs[2] and not rs[3] then
            rs[2] = rs[1] ^ (w1 / denom) * rs[4] ^ (1 - w1 / denom)
            rs[3] = rs[1] ^ (1 - w2 / denom) * rs[4] ^ (w2 / denom)
        elseif not rs[2] and not rs[4] then
            rs[2] = rs[1] ^ w1 * rs[3] ^ (1 - w1)
            rs[4] = rs[2] ^ (1 - 1 / w2) * rs[3] ^ (1 / w2)
        elseif not rs[3] and not rs[4] then
            rs[3] = rs[1] ^ (1 - 1 / (1 - w1)) * rs[2] ^ (1 / (1 - w1))
            rs[4] = rs[2] ^ (1 - 1 / w2) * rs[3] ^ (1 / w2)
        end
    elseif cnt == 3 then
        if not rs[1] then
            rs[1] = rs[2] ^ (1 / w1) * rs[3] ^ (1 - 1 / w1)
        elseif not rs[2] then
            rs[2] = rs[1] ^ w1 * rs[3] ^ (1 - w1)
        elseif not rs[3] then
            rs[3] = rs[2] ^ (1 - w2) * rs[4] ^ w2
        elseif not rs[4] then
            rs[4] = rs[2] ^ (1 - 1 / w2) * rs[3] ^ (1 / w2)
        end
    end
    for i = 1, 4 do rs[i] = clamp(rs[i], S_MIN, INIT_S_MAX) end
    return rs
end

local function pretrain_stability(seqs, average_recall)
    local groups = {}
    for _, seq in ipairs(seqs) do
        local lt, first_lt = 0, nil
        for _, rv in ipairs(seq) do
            if rv.delta_t > 0 then
                lt = lt + 1
                first_lt = first_lt or rv
            end
        end
        local first_rating = seq[1] and seq[1].rating
        if lt == 1 and first_rating and first_rating >= 1 and first_rating <= 4 then
            groups[first_rating] = groups[first_rating] or {}
            local g = groups[first_rating]
            g[first_lt.delta_t] = g[first_lt.delta_t] or { n = 0, pass = 0 }
            g[first_lt.delta_t].n = g[first_lt.delta_t].n + 1
            if first_lt.rating > 1 then g[first_lt.delta_t].pass = g[first_lt.delta_t].pass + 1 end
        end
    end

    local decay = -DEFAULT_W[20]
    local factor = 0.9 ^ (1 / decay) - 1
    local function pfc(t, s) return (t / s * factor + 1) ^ decay end
    local function grp_loss(data, s0, default_s0)
        local ll = 0
        for _, pt in ipairs(data) do
            local y = clamp(pfc(pt.delta_t, s0), 1e-9, 1 - 1e-9)
            ll = ll - (pt.recall * math.log(y) + (1 - pt.recall) * math.log(1 - y)) * pt.count
        end
        return ll + math.abs(s0 - default_s0) / 16
    end

    local rating_stability, rating_count = {}, {}
    for rating, g in pairs(groups) do
        local data, total = {}, 0
        for delta_t, c in pairs(g) do
            local real = c.pass / c.n
            data[#data + 1] = { delta_t = delta_t, recall = (real * c.n + average_recall) / (c.n + 1), count = c.n }
            total = total + c.n
        end
        rating_count[rating] = total
        local default_s0 = DEFAULT_W[rating - 1]
        local low, high = S_MIN, INIT_S_MAX
        for _ = 1, 1000 do
            if high - low <= 1e-9 then break end
            local mid1, mid2 = low + (high - low) / 3, high - (high - low) / 3
            if grp_loss(data, mid1, default_s0) < grp_loss(data, mid2, default_s0) then high = mid2 else low = mid1 end
        end
        rating_stability[rating] = (low + high) / 2
    end
    return smooth_and_fill(rating_stability, rating_count)
end

local function train_weights(items, init_w, epochs, lr, gamma)
    local w, m, v = {}, {}, {}
    for i = 0, 20 do w[i], m[i], v[i] = init_w[i], 0, 0 end
    clip_weights(w)
    local total = #items
    local b1, b2, eps, t = 0.9, 0.999, 1e-8, 0
    local function batch_loss(bw, from, to)
        local loss, wsum = 0, 0
        for i = from, to do
            local it = items[i]
            local p = clamp(item_pred(bw, it), 1e-6, 1 - 1e-6)
            loss = loss + (it.label * math.log(p) + (1 - it.label) * math.log(1 - p)) * it.weight
            wsum = wsum + it.weight
        end
        local reg = 0
        for i = 0, 20 do
            local diff = bw[i] - DEFAULT_W[i]
            reg = reg + diff * diff / (PARAMS_STDDEV[i] * PARAMS_STDDEV[i])
        end
        return -loss / wsum + reg * gamma * (to - from + 1) / total
    end
    for _ = 1, epochs do
        local from = 1
        while from <= total do
            local to = math.min(from + 511, total)
            t = t + 1
            local grad = {}
            for i = 0, 20 do
                local orig = w[i]
                local h = math.max(1e-4, math.abs(orig) * 1e-3)
                w[i] = orig + h
                local lp = batch_loss(w, from, to)
                w[i] = orig - h
                local lm = batch_loss(w, from, to)
                w[i] = orig
                grad[i] = (lp - lm) / (2 * h)
            end
            for i = 0, 20 do
                m[i] = b1 * m[i] + (1 - b1) * grad[i]
                v[i] = b2 * v[i] + (1 - b2) * grad[i] * grad[i]
                w[i] = w[i] - lr * (m[i] / (1 - b1 ^ t)) / (math.sqrt(v[i] / (1 - b2 ^ t)) + eps)
            end
            clip_weights(w)
            from = to + 1
        end
    end
    return w
end

function M.optimize(dir, opts)
    opts = opts or {}
    local deck = M.new({ dir = dir })
    local seqs = load_revlog_sequences(deck:revlog_path())
    local items = {}
    for _, seq in ipairs(seqs) do
        for upto = 2, #seq do
            if seq[upto].delta_t > 0 then
                items[#items + 1] = { card = seq, upto = upto, label = seq[upto].rating > 1 and 1 or 0, ts = seq[upto].ts }
            end
        end
    end
    if #items == 0 then return nil, "no long-term reviews to train on yet" end
    table.sort(items, function(a, b) return a.ts < b.ts end)
    local n, passes = #items, 0
    for i, it in ipairs(items) do
        it.weight = 0.25 + 0.75 * (((i - 1) / n) ^ 3)
        passes = passes + it.label
    end

    local init_w = {}
    for i = 0, 20 do init_w[i] = DEFAULT_W[i] end
    local s0 = pretrain_stability(seqs, passes / n)
    if s0 then for i = 1, 4 do init_w[i - 1] = s0[i] end end

    local w = (n >= 64) and train_weights(items, init_w, opts.epochs or 5, opts.learning_rate or 0.04, opts.gamma or 1.0) or init_w

    local parts = {}
    for i = 0, 20 do parts[#parts + 1] = string.format("%.8g", w[i]) end
    if not deck:write_file(deck:params_path(), table.concat(parts, " ") .. "\n") then return nil, "failed to write params" end
    return w, n
end

if not package.loaded["wezterm"] and not package.preload["wezterm"] then
    if arg and arg[1] == "optimize" then
        local dir = arg[2] or ((os.getenv("HOME") or ".") .. "/.local/share/anki")
        local w, info = M.optimize(dir)
        if not w then
            io.stderr:write("optimize: " .. tostring(info) .. "\n")
            os.exit(1)
        end
        io.write(("optimized FSRS parameters on %d reviews -> %s/params.txt\n"):format(info, dir))
        os.exit(0)
    elseif arg and arg[1] == "retention" then
        local deck = M.new({ dir = arg[2] or ((os.getenv("HOME") or ".") .. "/.local/share/anki") })
        local r, total = deck:retention()
        io.write(r and ("true retention: %.1f%% over %d reviews\n"):format(r * 100, total) or "no review-state reviews logged yet\n")
        os.exit(0)
    end
    return M
end

local wezterm = require("wezterm")

-- GLOBAL survives config reloads; session does not, so undo history is lost on reload.
local session

local function load_deck()
    if session then return session end
    local deck = M.new({
        dir = wezterm.home_dir .. "/.local/share/anki",
        mkdir = function(dir) wezterm.run_child_process({ "mkdir", "-p", dir }) end,
        optimizer = function(dir)
            wezterm.background_child_process({
                os.getenv("SHELL") or "/bin/sh", "-lc", 'exec nvim -l "$0" optimize "$1"',
                wezterm.home_dir .. "/.vim/config/wezterm/anki.lua", dir,
            })
        end,
    })
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

function M.copy_binding()
    return wezterm.action_callback(function(window, pane)
        window:perform_action(wezterm.action.ActivateKeyTable({ name = "anki_grade", one_shot = false, replace_current = true, until_unknown = true }), pane)
        local deck = load_deck()
        local text = deck:card_text()
        publish(deck)
        if text then window:copy_to_clipboard(text) end
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
