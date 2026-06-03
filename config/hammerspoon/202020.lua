local M = {}

local WORK_SECONDS = 20 * 60
local BREAK_SECONDS = 20
local COUNTDOWN_SECONDS = 10
local SLEEP_GAP_THRESHOLD = 30 -- a tick gap larger than this implies system sleep

local paused = 0               -- 0 = running, 1 = manually paused, 2 = auto-paused on screen sharing
local deadline = hs.timer.secondsSinceEpoch() + WORK_SECONDS
local bar = hs.menubar.new(true, "202020")

local pausedRemaining = WORK_SECONDS
local function remaining()
    if paused ~= 0 then return math.max(0, math.floor(pausedRemaining + 0.5)) end
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
    if isPaused then -- draw two vertical bars for precise alignment
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
    if paused == 0 and rem > 0 and rem <= COUNTDOWN_SECONDS then
        bar:setIcon(renderIcon(rem, false, true), false)
    else
        bar:setIcon(renderIcon(minutesLeft(rem), paused ~= 0, false), false)
    end
end

local function togglePause(sharing)
    if sharing ~= nil and paused ~= (sharing and 0 or 2) then return false end -- sharing only matters if not paused and sharing, or auto-paused and stopped sharing
    if (sharing == nil and paused == 0) or sharing then
        pausedRemaining = math.max(0, deadline - hs.timer.secondsSinceEpoch())
        paused = sharing and 2 or 1
    else
        deadline = hs.timer.secondsSinceEpoch() + pausedRemaining
        paused = 0
    end
    refreshIcon()
    return true
end

local function resetTimer()
    deadline = hs.timer.secondsSinceEpoch() + WORK_SECONDS
    if paused ~= 0 then pausedRemaining = WORK_SECONDS end
    refreshIcon()
end

local function release(resource, method) if resource then resource[method](resource) end end

local overlays, overlayTimer, overlayTap, breakActive = {}, nil, nil, false
local function dismissBreak()
    if not breakActive then return end
    breakActive = false
    release(overlayTimer, "stop")
    release(overlayTap, "stop")
    overlayTimer, overlayTap = nil, nil
    for _, c in ipairs(overlays) do c:delete() end
    overlays = {}
    deadline = hs.timer.secondsSinceEpoch() + WORK_SECONDS -- next work interval starts after break ends
    refreshIcon()
end

local function showBreak()
    if breakActive then return end
    breakActive = true
    local left = BREAK_SECONDS
    local screen = hs.screen.primaryScreen()
    local frame = screen:fullFrame()
    local canvas = assert(hs.canvas.new(frame))
    canvas:level(hs.canvas.windowLevels.screenSaver)
    canvas:behaviorAsLabels({ "canJoinAllSpaces", "stationary" })
    canvas[1] = { type = "rectangle", action = "fill", fillColor = color(0, 0, 0) }
    canvas[2] = { type = "text", text = tostring(left), textColor = { white = 1 }, textSize = 180, textAlignment = "center", frame = { x = 0, y = frame.h / 2 - 120, w = frame.w, h = 220 } }
    canvas[3] = { type = "text", text = "press Esc or Space to skip", textColor = color(85, 85, 85), textSize = 14, textAlignment = "center", frame = { x = 0, y = frame.h / 2 + 170, w = frame.w, h = 30 } }
    canvas:show()
    overlays[#overlays + 1] = canvas
    overlayTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
        local code = e:getKeyCode()
        if code == hs.keycodes.map.escape or code == hs.keycodes.map.space then dismissBreak() end
    end):start()
    overlayTimer = hs.timer.doEvery(1, function()
        left = left - 1
        if left <= 0 then return dismissBreak() end
        for _, c in ipairs(overlays) do c:elementAttribute(2, "text", tostring(left)) end
    end)
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
    if paused == 0 and now >= deadline and not breakActive then
        lastKey = nil
        return showBreak()
    end
    local rem = remaining()
    local inCountdown = paused == 0 and rem > 0 and rem <= COUNTDOWN_SECONDS
    local key = inCountdown and ("c" .. rem) or ((paused ~= 0 and "p" or "n") .. minutesLeft(rem) .. (paused == 2 and "a" or ""))
    if key ~= lastKey then
        lastKey = key
        refreshIcon()
    end
end

local function checkScreenShare() -- check if macOS or Zoom recording is on
    hs.task.new("/usr/bin/pgrep", function(rc) togglePause(rc == 0) end, { "-f", "screencaptureui|CptHost" }):start()
end

local tickTimer = hs.timer.doEvery(1, tick)
local shareDetectTimer = hs.timer.doEvery(5, checkScreenShare)
local wakeWatcher = hs.caffeinate.watcher.new(function(ev)
    if ev == hs.caffeinate.watcher.systemDidWake then
        resetTimer()
    end
end):start()
local togglePausebind = hs.hotkey.bind({ "cmd", "alt" }, "c", togglePause)

if bar then
    bar:setMenu({
        { title = paused ~= 0 and "Resume" or "Pause", fn = function() togglePause() end },
        { title = "Break now", fn = showBreak },
        { title = "Reset timer", fn = resetTimer },
        { title = "-" },
        { title = "Quit", fn = function() M.stop() end },
    })
    refreshIcon()
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
