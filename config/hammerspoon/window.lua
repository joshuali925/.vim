local M = {}

hs.window.animationDuration = 0

local RATIOS = { 0.5, 1 / 3, 2 / 3 }
local MIN_W, MIN_H = 200, 150

local cycle = { id = nil, side = nil, step = 0, frame = nil }

local function framesEqual(a, b) return math.abs(a.x - b.x) < 2 and math.abs(a.y - b.y) < 2 and math.abs(a.w - b.w) < 2 and math.abs(a.h - b.h) < 2 end

local function place(win, f)
    local max = win:screen():frame()
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

M.maximize = withWin(function(win) win:setFrame(win:screen():frame()) end)
M.center = withWin(function(win) win:centerOnScreen(nil, true) end)
M.moveDisplay = withWin(function(win, dir) win:moveToScreen(win:screen()[dir](win:screen()), true, true) end)
M.resizeBy = withWin(function(win, delta)
    local f = win:frame()
    place(win, { x = f.x - delta / 2, y = f.y - delta / 2, w = f.w + delta, h = f.h + delta })
end)

return M
