local M = {}

local WORK_SECONDS = 20 * 60
local BREAK_SECONDS = 20
local COUNTDOWN_SECONDS = 10
local SLEEP_GAP_THRESHOLD = 30 -- a tick gap larger than this implies system sleep
local STARTUP_BAR_DELAY = 4.0
local STARTUP_PROGRESS = {
    { time = 0.0, value = 0.00 },
    { time = STARTUP_BAR_DELAY, value = 0.00 },
    { time = 5.2, value = 0.03 },
    { time = 5.6, value = 0.14 },
    { time = 7.0, value = 0.22 },
    { time = 8.5, value = 0.32 },
    { time = 10.0, value = 0.44 },
    { time = 11.5, value = 0.53 },
    { time = 13.0, value = 0.60 },
    { time = 14.5, value = 0.69 },
    { time = 16.0, value = 0.78 },
    { time = 17.2, value = 0.85 },
    { time = 18.0, value = 0.92 },
    { time = 19.2, value = 0.98 },
    { time = BREAK_SECONDS, value = 1.00 },
}

local RUNNING, MANUAL, AUTO = 0, 1, 2
local paused = RUNNING
local deadline, bar

local pausedRemaining = WORK_SECONDS
local function remaining()
    if paused ~= RUNNING then return math.max(0, math.floor(pausedRemaining + 0.5)) end
    return math.max(0, math.floor(deadline - hs.timer.secondsSinceEpoch() + 0.5))
end

local function minutesLeft(seconds) return math.max(1, math.floor((seconds + 59) / 60)) end
local function color(r, g, b) return { red = r / 255, green = g / 255, blue = b / 255, alpha = 1 } end

local function renderIcon(value, isPaused, counting)
    local size = 64
    local bg = counting and color(40, 40, 40) or color(0, 150, 220)
    local fg = (counting and not isPaused) and color(255, 150, 40) or color(255, 255, 255)
    local canvas = assert(hs.canvas.new({ x = 0, y = 0, w = size, h = size }))
    canvas[1] = { type = "oval", action = "fill", fillColor = bg, frame = { x = 2, y = 2, w = size - 4, h = size - 4 } }
    if isPaused then
        local barW, barH, gap = 9, 28, 8
        local x0 = (size - (barW * 2 + gap)) / 2
        local y0 = (size - barH) / 2
        for i = 0, 1 do canvas[#canvas + 1] = { type = "rectangle", action = "fill", fillColor = fg, roundedRectRadii = { xRadius = 2, yRadius = 2 }, frame = { x = x0 + i * (barW + gap), y = y0, w = barW, h = barH } } end
    else
        local text = tostring(value)
        canvas[2] = { type = "text", text = text, textColor = fg, textSize = #text <= 2 and 34 or 28, textAlignment = "center", frame = { x = 0, y = 0, w = size, h = size } }
        local textH = canvas:minimumTextSize(2, text).h
        canvas:elementAttribute(2, "frame", { x = 0, y = (size - textH) / 2, w = size, h = textH })
    end
    local image = canvas:imageFromCanvas():setSize({ w = 22, h = 22 })
    canvas:delete()
    return image
end

local function refreshIcon()
    if not bar then return end
    local rem = remaining()
    if paused == RUNNING and rem > 0 and rem <= COUNTDOWN_SECONDS then
        bar:setIcon(renderIcon(rem, false, true), false)
    else
        bar:setIcon(renderIcon(minutesLeft(rem), paused ~= RUNNING, false), false)
    end
end

local function togglePause(sharing)
    if sharing ~= nil and paused ~= (sharing and RUNNING or AUTO) then return false end
    if (sharing == nil and paused == RUNNING) or sharing then
        pausedRemaining = math.max(0, deadline - hs.timer.secondsSinceEpoch())
        paused = sharing and AUTO or MANUAL
    else
        deadline = hs.timer.secondsSinceEpoch() + pausedRemaining
        paused = RUNNING
    end
    refreshIcon()
    return true
end

local function resetTimer()
    deadline = hs.timer.secondsSinceEpoch() + WORK_SECONDS
    if paused ~= RUNNING then pausedRemaining = WORK_SECONDS end
    refreshIcon()
end

local function release(resource, method) if resource then resource[method](resource) end end

local function startupProgressAt(elapsed)
    for i = 2, #STARTUP_PROGRESS do
        local previous = STARTUP_PROGRESS[i - 1]
        local current = STARTUP_PROGRESS[i]
        if elapsed <= current.time then
            local position = (elapsed - previous.time) / (current.time - previous.time)
            return previous.value + (current.value - previous.value) * position
        end
    end
    return 1
end

local overlays, overlayTimer, breakTimer, overlayTap, breakActive = {}, nil, nil, nil, false
local function dismissBreak()
    if not breakActive then return false end
    breakActive = false
    release(overlayTimer, "stop")
    release(breakTimer, "stop")
    release(overlayTap, "stop")
    overlayTimer, breakTimer, overlayTap = nil, nil, nil
    for _, c in ipairs(overlays) do c:delete() end
    overlays = {}
    deadline = hs.timer.secondsSinceEpoch() + WORK_SECONDS -- next work interval starts after break ends
    refreshIcon()
    return true
end

local function showBreak()
    if breakActive then return end
    breakActive = true
    local screen = hs.screen.primaryScreen()
    local frame = screen:fullFrame()
    local canvas = assert(hs.canvas.new(frame))
    local logoCenterY = frame.h * 0.5
    local barWidth, barHeight, barBorder = 236, 8, 1
    local barX = (frame.w - barWidth) / 2
    local barY = frame.h * 0.904 - barHeight / 2
    local fillX, fillY = barX + barBorder, barY + barBorder
    local fillWidth, fillHeight = barWidth - barBorder * 2, barHeight - barBorder * 2
    local logo = assert(hs.image.imageFromURL(
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyMSAyOSI+CiAgPGcgZmlsbD0iI2ZmZiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCAyOSkgc2NhbGUoMSAtMSkiPgogICAgPHBhdGggZD0iTTE0LjA4MTg0IDI0LjU0ODI1QzE0LjkyNjYxIDI1LjYwNTMgMTUuNTAwNDEgMjcuMDI0ODUgMTUuMzQ4MjcgMjguNDc0ODVDMTQuMTEyMjcgMjguNDEzOTUgMTIuNjAzODYgMjcuNjU4NSAxMS43MzAxMiAyNi42MDE0NUMxMC45NDYyMSAyNS42OTUyIDEwLjI1MjE0IDI0LjIxNjIgMTAuNDMzMjYgMjIuODI3MUMxMS44MTk5NSAyMi43MDUzIDEzLjIwNjY1IDIzLjUyMTY1IDE0LjA4MTg0IDI0LjU0ODI1WiIvPgogICAgPHBhdGggZD0iTTE1LjMzMjc3IDIyLjU1NTIzQzEzLjMxNzIxIDIyLjY3NTU4IDExLjYwNDQ5IDIxLjQxMTE4IDEwLjY0MDkgMjEuNDExMThDOS42Nzg3NjggMjEuNDExMTggOC4yMDUxMzUgMjIuNDk0MzMgNi42MDk3ODYgMjIuNDY1MzNDNC41MzYyNjcgMjIuNDM0ODggMi42MTA1NDYgMjEuMjYxODMgMS41NTg1NzIgMTkuMzk0MjNDLTAuNjA3NjgzMyAxNS42NTkwMyAwLjk4NjIxNjcgMTAuMTE4NTggMy4wOTE2MTQgNy4wNzY0OEM0LjExNDYwOCA1LjU3MjgzIDUuMzQ3NzA3IDMuOTE1NDggNi45NzA1ODcgMy45NzQ5M0M4LjUwNjUyNyA0LjAzNTgzIDkuMTA3ODYyIDQuOTY5NjMgMTAuOTcyNzIgNC45Njk2M0MxMi44MzYxNCA0Ljk2OTYzIDEzLjM3ODA2IDMuOTc0OTMgMTUuMDAwOTQgNC4wMDUzOEMxNi42ODYxMyA0LjAzNTgzIDE3LjczOTU1IDUuNTEwNDggMTguNzYyNTUgNy4wMTcwM0MxOS45MzQ3OSA4LjczMjM4IDIwLjQxNTg2IDEwLjM4ODI4IDIwLjQ0NjI5IDEwLjQ3OTYzQzIwLjQxNTg2IDEwLjUxMDA4IDE3LjE5NzYzIDExLjc0NTQ4IDE3LjE2ODY1IDE1LjQ0ODc4QzE3LjEzODIyIDE4LjU1MDMzIDE5LjY5NDI2IDIwLjAyNDk4IDE5LjgxNDUyIDIwLjExNzc4QzE4LjM3MTMyIDIyLjI1MzYzIDE2LjExNTIzIDIyLjQ5NDMzIDE1LjMzMjc3IDIyLjU1NTIzWiIvPgogIDwvZz4KPC9zdmc+Cg=="))

    canvas:level(hs.canvas.windowLevels.screenSaver)
    canvas:behaviorAsLabels({ "canJoinAllSpaces", "stationary" })
    canvas[1] = { type = "rectangle", action = "fill", fillColor = color(0, 0, 0) }
    canvas[2] = { type = "image", image = logo, imageAlpha = 0.9, imageScaling = "scaleProportionally", frame = { x = (frame.w - 84) / 2, y = logoCenterY - 58, w = 84, h = 116 } }
    canvas[3] = { type = "rectangle", action = "skip", fillColor = { white = 0.20 }, roundedRectRadii = { xRadius = 4, yRadius = 4 }, frame = { x = barX, y = barY, w = barWidth, h = barHeight } }
    canvas[4] = { type = "rectangle", action = "skip", fillColor = { white = 0.13 }, roundedRectRadii = { xRadius = 3, yRadius = 3 }, frame = { x = fillX, y = fillY, w = fillWidth, h = fillHeight } }
    canvas[5] = { type = "rectangle", action = "skip", fillColor = { white = 0.80 }, roundedRectRadii = { xRadius = 3, yRadius = 3 }, frame = { x = fillX, y = fillY, w = 0, h = fillHeight } }
    canvas:show()
    overlays[#overlays + 1] = canvas
    overlayTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
        local code = e:getKeyCode()
        if code == hs.keycodes.map.escape or code == hs.keycodes.map.space then return dismissBreak() end
    end):start()

    local startedAt = hs.timer.secondsSinceEpoch()
    local progressBarVisible = false
    overlayTimer = hs.timer.doEvery(1 / 30, function()
        local elapsed = hs.timer.secondsSinceEpoch() - startedAt
        if elapsed < STARTUP_BAR_DELAY then return end
        local progress = startupProgressAt(elapsed)
        for _, c in ipairs(overlays) do
            if not progressBarVisible then
                c:elementAttribute(3, "action", "fill")
                c:elementAttribute(4, "action", "fill")
                c:elementAttribute(5, "action", "fill")
            end
            c:elementAttribute(5, "frame", { x = fillX, y = fillY, w = fillWidth * progress, h = fillHeight })
        end
        progressBarVisible = true
    end)
    breakTimer = hs.timer.doAfter(BREAK_SECONDS, dismissBreak)
end

local lastKey, lastTick = nil, hs.timer.secondsSinceEpoch()
local function tick()
    local now = hs.timer.secondsSinceEpoch()
    local gap = now - lastTick
    lastTick = now
    if gap > SLEEP_GAP_THRESHOLD then
        lastKey = nil
        return resetTimer()
    end
    if paused == RUNNING and now >= deadline and not breakActive then
        lastKey = nil
        return showBreak()
    end
    local rem = remaining()
    local inCountdown = paused == RUNNING and rem > 0 and rem <= COUNTDOWN_SECONDS
    local key = inCountdown and ("c" .. rem) or ((paused ~= RUNNING and "p" or "n") .. minutesLeft(rem) .. (paused == AUTO and "a" or ""))
    if key ~= lastKey then
        lastKey = key
        refreshIcon()
    end
end

local inMeeting = false
function M.inMeeting() return inMeeting end

local nizPlum = require("niz-plum")
local function poll()
    hs.task.new("/usr/bin/pgrep", function(rc)
        inMeeting = (rc == 0)
        togglePause(rc == 0)
    end, { "-f", "screencaptureui|CptHost" }):start()
    nizPlum.poll()
end

local tickTimer, shareDetectTimer, wakeWatcher, togglePausebind

function M.init()
    deadline = hs.timer.secondsSinceEpoch() + WORK_SECONDS
    bar = hs.menubar.new(true, "202020")
    tickTimer = hs.timer.doEvery(1, tick)
    shareDetectTimer = hs.timer.doEvery(11, poll)
    poll()
    wakeWatcher = hs.caffeinate.watcher.new(function(ev)
        if ev == hs.caffeinate.watcher.systemDidWake then resetTimer() end
    end):start()
    togglePausebind = hs.hotkey.bind({ "cmd", "alt" }, "c", togglePause)
    if bar then
        bar:setMenu({
            { title = paused ~= RUNNING and "Resume" or "Pause", fn = function() togglePause() end },
            { title = "Break now", fn = showBreak },
            { title = "Reset timer", fn = resetTimer },
            { title = "-" },
            { title = "Quit", fn = function() M.stop() end },
        })
        refreshIcon()
    end
end

function M.stop()
    dismissBreak()
    release(tickTimer, "stop")
    release(shareDetectTimer, "stop")
    release(wakeWatcher, "stop")
    release(togglePausebind, "delete")
    release(bar, "delete")
    tickTimer, shareDetectTimer, wakeWatcher, togglePausebind, bar = nil, nil, nil, nil, nil
end

return M
