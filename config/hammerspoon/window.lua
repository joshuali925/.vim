local M = {}

hs.window.animationDuration = 0

local RATIOS = { 0.5, 1 / 3, 2 / 3 }
local MIN_W, MIN_H = 200, 150

local cycle = { id = nil, side = nil, step = 0, frame = nil }
local original = {}

local function saveOriginal(win)
    local id = win:id()
    if original[id] == nil then
        for oid in pairs(original) do if not hs.window.get(oid) then original[oid] = nil end end
        original[id] = win:frame()
    end
end

local function framesEqual(a, b) return math.abs(a.x - b.x) < 2 and math.abs(a.y - b.y) < 2 and math.abs(a.w - b.w) < 2 and math.abs(a.h - b.h) < 2 end

local function place(win, f, max)
    max = max or win:screen():frame()
    f.w = math.min(math.max(f.w, MIN_W), max.w)
    f.h = math.min(math.max(f.h, MIN_H), max.h)
    f.x = math.min(math.max(f.x, max.x), max.x + max.w - f.w)
    f.y = math.min(math.max(f.y, max.y), max.y + max.h - f.h)
    win:setFrame(f)
end

local function withWin(fn)
    return function(...)
        local win = hs.window.focusedWindow()
        if not win then return end
        fn(win, ...)
        cycle.id = nil
    end
end

function M.snap(side)
    local win = hs.window.focusedWindow()
    if not win then return end
    saveOriginal(win)

    local max = win:screen():frame()
    local repeated = cycle.id == win:id() and cycle.side == side and cycle.frame and framesEqual(win:frame(), cycle.frame)
    local step = repeated and (cycle.step % #RATIOS) + 1 or 1
    local ratio = RATIOS[step]

    local f = { x = max.x, y = max.y, w = max.w, h = max.h }
    if side == "left" or side == "right" then
        f.w = max.w * ratio
        if side == "right" then f.x = max.x + max.w - f.w end
    else
        f.h = max.h * ratio
        if side == "down" then f.y = max.y + max.h - f.h end
    end

    place(win, f)
    cycle.id, cycle.side, cycle.step, cycle.frame = win:id(), side, step, win:frame()
end

function M.maximize()
    local win = hs.window.focusedWindow()
    if not win then return end
    saveOriginal(win)
    win:setFrame(win:screen():frame())
    cycle.id = nil
end

local RESTORE_STEPS = { "restore", "up", "down" }
function M.restore()
    local win = hs.window.focusedWindow()
    if not win then return end
    saveOriginal(win)

    local max = win:screen():frame()
    local repeated = cycle.id == win:id() and cycle.side == "restore" and cycle.frame and framesEqual(win:frame(), cycle.frame)
    local step = repeated and (cycle.step % #RESTORE_STEPS) + 1 or 1

    if RESTORE_STEPS[step] == "restore" then
        place(win, original[win:id()])
    else
        local f = { x = max.x, y = max.y, w = max.w, h = max.h / 2 }
        if RESTORE_STEPS[step] == "down" then f.y = max.y + max.h - f.h end
        place(win, f)
    end

    cycle.id, cycle.side, cycle.step, cycle.frame = win:id(), "restore", step, win:frame()
end

M.center = withWin(function(win) win:centerOnScreen(nil, true) end)
M.moveDisplay = withWin(function(win, dir)
    local from = win:screen()
    local to = from[dir](from)
    if not to then return end
    local a, b, f = from:frame(), to:frame(), win:frame()
    local maxW, maxH = f.w >= a.w, f.h >= a.h
    local w, h = f.w, f.h
    if maxW and maxH then
        w, h = b.w, b.h
    elseif maxH then
        w, h = f.w * b.h / f.h, b.h
    elseif maxW then
        w, h = b.w, f.h * b.w / f.w
    end
    local target = { x = b.x + (f.x - a.x) / a.w * b.w, y = b.y + (f.y - a.y) / a.h * b.h, w = w, h = h }
    place(win, target, b)
    place(win, target, b) -- mac limitation, resize need to be applied after moving window
end)
M.resizeBy = withWin(function(win, delta)
    local f = win:frame()
    place(win, { x = f.x - delta / 2, y = f.y - delta / 2, w = f.w + delta, h = f.h + delta })
end)

return M
