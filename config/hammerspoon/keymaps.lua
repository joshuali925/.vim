local WS = "com.amazon.workspaces"
local MOONLIGHT = "com.moonlight-stream.Moonlight"
local RDC = "com.microsoft.rdc.macos"
local TERM = "com.github.wez.wezterm"
local EDGE = "com.microsoft.edgemac"
local CHROME = "com.google.Chrome"

local INSERT = 114
local CUSTOM_MARK = 0xC0DE -- random hardcoded value to avoid recursive triggering

local nizPlum = require("niz-plum")

local function send(key, mods, rawFlags)
    local e = hs.eventtap.event.newKeyEvent(mods or {}, key, true)
    if rawFlags then e:rawFlags(rawFlags) end
    e:setProperty(hs.eventtap.event.properties.eventSourceUserData, CUSTOM_MARK)
    e:post()
    e = hs.eventtap.event.newKeyEvent(mods or {}, key, false)
    if rawFlags then e:rawFlags(rawFlags) end
    e:setProperty(hs.eventtap.event.properties.eventSourceUserData, CUSTOM_MARK)
    e:post()
    return true
end

local function sendList(list)
    for _, s in ipairs(list) do send(s[1], s[2]) end
    return true
end

local function sendRightOpt(key, withShift) -- need right option because left option is meta in wezterm
    local RALT_FLAGS = hs.eventtap.event.rawFlagMasks.alternate | hs.eventtap.event.rawFlagMasks.deviceRightAlternate
    return send(key, nil, withShift and RALT_FLAGS | hs.eventtap.event.rawFlagMasks.shift or RALT_FLAGS)
end

local function sendSystemKey(key)
    hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
    return true
end

local FN_ROW = {
    [hs.keycodes.map.f1] = "BRIGHTNESS_DOWN",
    [hs.keycodes.map.f2] = "BRIGHTNESS_UP",
    [hs.keycodes.map.f7] = "PREVIOUS",
    [hs.keycodes.map.f8] = "PLAY",
    [hs.keycodes.map.f9] = "NEXT",
    [hs.keycodes.map.f10] = "MUTE",
    [hs.keycodes.map.f11] = "SOUND_DOWN",
    [hs.keycodes.map.f12] = "SOUND_UP",
}

local keycodeToName = {}
for name, code in pairs(hs.keycodes.map) do if type(code) == "number" and keycodeToName[code] == nil then keycodeToName[code] = name end end

local _cachedApp
local function getFrontAppBundleId()
    if _cachedApp == nil then
        local application = hs.application.frontmostApplication()
        _cachedApp = application and application:bundleID() or ""
    end
    return _cachedApp
end

local function inApps(...)
    local app = getFrontAppBundleId()
    for i = 1, select("#", ...) do if app == select(i, ...) then return true end end
    return false
end

local function flagsToMods(flags)
    local m = {}
    if flags.cmd then m[#m + 1] = "cmd" end
    if flags.alt then m[#m + 1] = "alt" end
    if flags.ctrl then m[#m + 1] = "ctrl" end
    if flags.shift then m[#m + 1] = "shift" end
    if flags.fn then m[#m + 1] = "fn" end
    return m
end

local function hyper(key, flags)
    -- Navigation
    if key == "n" then return send("tab", { "ctrl", "shift" }) end
    if key == "m" then return send("tab", { "ctrl" }) end
    if key == "q" then return send("pagedown") end
    if key == "r" then return send(flags.cmd and "5" or "pageup", flags.cmd and { "cmd", "shift" }) end -- cmd: screenshot
    if key == "h" then return send("left", flags.cmd and { "shift" }) end
    if key == "j" then return send("down", flags.cmd and { "shift" }) end
    if key == "k" then return send("up", flags.cmd and { "shift" }) end
    if key == "l" then return send("right", flags.cmd and { "shift" }) end
    if key == "e" then
        if inApps(TERM) then return send("right", { "ctrl" }) end
        return send("right", flags.cmd and { "alt", "shift" } or { "alt" })
    end
    if key == "b" then
        if inApps(TERM) then return send("left", { "ctrl" }) end
        return send("left", flags.cmd and { "alt", "shift" } or { "alt" })
    end
    if key == ";" then
        if inApps(TERM, RDC) then return send("home") end
        return send("left", flags.cmd and { "cmd", "shift" } or { "cmd" })
    end
    if key == "'" or key == "return" then -- enter as end for silakka54
        if inApps(TERM, RDC) then return send("end") end
        return send("right", flags.cmd and { "cmd", "shift" } or { "cmd" })
    end
    if key == "g" then
        if inApps(WS, RDC, MOONLIGHT) then return send(flags.alt and "home" or "end", { "ctrl" }) end
        return send(flags.cmd and "up" or "down", { "cmd" })
    end

    -- Controls
    if key == "y" then
        if inApps(WS, RDC, MOONLIGHT) then return send(INSERT, { "ctrl" }) end -- Windows copy
        if flags.cmd then return sendList({ { "right", { "cmd" } }, { "left", { "cmd", "shift" } }, { "c", { "cmd" } }, { "right" } }) else return send("c", { "cmd" }) end
    end
    if key == "p" then -- cmd-p: paste without formatting
        if inApps(WS, RDC, MOONLIGHT) then return send(INSERT, { "shift" }) end
        if flags.cmd then return send("v", { "cmd", "shift", "alt" }) else return send("v", { "cmd" }) end
    end
    if key == "v" then return send("c", { "cmd", "shift" }) end -- maccy
    if key == "u" then
        if inApps(TERM) then return send("/", { "ctrl" }) end
        if flags.cmd then return send("z", { "cmd", "shift" }) else return send("z", { "cmd" }) end
    end
    if key == "z" then return send("s", flags.cmd and { "cmd", "alt" } or { "cmd" }) end
    if key == "/" then return send("f", { "cmd" }) end

    -- Deletion
    if key == "w" then
        if inApps(TERM) then return send("w", { "ctrl" }) end
        if flags.cmd then return sendList({ { "right", { "cmd" } }, { "down", { "shift" } }, { "left", { "cmd", "shift" } }, { "delete" } }) else return send("delete", { "alt" }) end
    end
    if key == "d" then
        if inApps(TERM) then return sendList({ { "end" }, { "u", { "ctrl" } } }) end
        if flags.cmd then return sendList({ { "right", { "cmd" } }, { "left", { "cmd", "shift" } }, { "delete" } }) end
        return sendList({ { "right", { "cmd" } }, { "left", { "cmd", "shift" } }, { "left", { "cmd", "shift" } }, { "left", { "shift" } }, { "delete" }, { "right" }, { "right", { "cmd" } } })
    end
    if key == "x" then if flags.cmd then return send("forwarddelete") else return sendList({ { "c", { "cmd" } }, { "forwarddelete" } }) end end -- cut or delete
    if key == "delete" then return sendList({ { "right", { "alt" } }, { "delete", { "alt" } } }) end                                            -- delete word

    -- Editing
    if key == "o" then if flags.cmd then return sendList({ { "left", { "cmd" } }, { "return" }, { "up" } }) else return sendList({ { "right", { "cmd" } }, { "return" } }) end end
    if key == "9" then
        if flags.cmd then return sendList({ { "x", { "cmd" } }, { "'", { "shift" } }, { "v", { "cmd" } }, { "'", { "shift" } } }) end -- wrap ""
        return sendList({ { "x", { "cmd" } }, { "9", { "shift" } }, { "v", { "cmd" } }, { "0", { "shift" } } })                       -- wrap ()
    end
    if key == "0" and flags.cmd then return sendList({ { "x", { "cmd" } }, { "'" }, { "v", { "cmd" } }, { "'" } }) end                -- wrap ''

    -- Applications
    if key == "t" then return sendList({ { "t", { "cmd", "alt" } }, { "left", { "alt" } }, { "right", { "alt", "shift" } }, { "t", { "cmd", "alt" } } }) end -- dictionary

    -- Window Operations
    if key == "1" then return hs.eventtap.otherClick(hs.mouse.absolutePosition(), nil, 0) end -- left click
    if key == "2" then return hs.eventtap.otherClick(hs.mouse.absolutePosition(), nil, 2) end -- middle click
    if key == "3" then return hs.eventtap.otherClick(hs.mouse.absolutePosition(), nil, 1) end -- right click
    if key == "," then return hs.eventtap.otherClick(hs.mouse.absolutePosition(), nil, 3) end -- back
    if key == "." then return hs.eventtap.otherClick(hs.mouse.absolutePosition(), nil, 4) end -- forward
    if key == "c" then return send("`", flags.cmd and { "cmd", "shift" } or { "cmd" }) end    -- switch window
    if key == "tab" and flags.ctrl then return send("tab", { "ctrl", "shift" }) end           -- use capslock as shift in ctrl-shift-tab for silakka54
end

local hyperActive, hyperUsed, hyperDownAt = false, false, 0
local upActive, upUsed, upDownAt = false, false, 0

local function keyHandler(e)
    if e:getProperty(hs.eventtap.event.properties.eventSourceUserData) == CUSTOM_MARK then return false end
    if nizPlum.shouldSuppress(e) then return true end -- block built-in keyboard while Niz Plum 66 is connected
    _cachedApp = nil
    local type, code, flags = e:getType(), e:getKeyCode(), e:getFlags()

    if code == hs.keycodes.map.f18 then -- super capslock
        if type == hs.eventtap.event.types.keyDown then
            if e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) == 1 then return true end
            hyperActive, hyperUsed, hyperDownAt = true, false, hs.timer.secondsSinceEpoch()
        elseif type == hs.eventtap.event.types.keyUp then
            hyperActive = false
            if not hyperUsed and (hs.timer.secondsSinceEpoch() - hyperDownAt) < 0.3 then send("escape") end -- tapping capslock within 300ms sends escape
        end
        return true
    end
    if hyperActive then
        if type == hs.eventtap.event.types.keyDown then
            hyperUsed = true
            local name = keycodeToName[code]
            if name then hyper(name, flags) end
        end
        return true
    end

    if FN_ROW[code] and not flags.cmd and not flags.alt and not flags.ctrl and not flags.shift then -- always use media keys for function keys
        if type == hs.eventtap.event.types.keyDown then sendSystemKey(FN_ROW[code]) end
        return true
    end

    if e:getProperty(hs.eventtap.event.properties.keyboardEventKeyboardType) == 198 then -- Niz Plum 66
        if code == hs.keycodes.map.escape then                                           -- swap keys
            if type == hs.eventtap.event.types.keyDown then send("`", flagsToMods(flags)) end
            return true
        elseif code == hs.keycodes.map["`"] then
            if type == hs.eventtap.event.types.keyDown then send("delete", flagsToMods(flags)) end
            return true
        elseif code == hs.keycodes.map.up and not flags.cmd and not flags.alt and not flags.ctrl and not flags.shift then -- up as shift
            if type == hs.eventtap.event.types.keyDown then
                if e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) == 1 then return true end
                upActive, upUsed, upDownAt = true, false, hs.timer.secondsSinceEpoch()
            elseif type == hs.eventtap.event.types.keyUp then
                upActive = false
                if not upUsed and (hs.timer.secondsSinceEpoch() - upDownAt) < 0.3 then send("up") end
            end
            return true
        elseif upActive and type == hs.eventtap.event.types.keyDown then
            upUsed = true
            local name = keycodeToName[code]
            if name then send(name, hs.fnutils.concat(flagsToMods(flags), { "shift" })) end
            return name ~= nil
        end
    end

    if type ~= hs.eventtap.event.types.keyDown then return false end
    local name = keycodeToName[code]

    -- Application Specific
    if name == "tab" and flags.cmd and flags.ctrl and not flags.alt then return send("tab", { "cmd", "shift" }) end -- use capslock as shift in cmd-shift-tab for silakka54
    if name and ((flags.cmd and not flags.alt) or (flags.alt and not flags.cmd)) and inApps(WS, MOONLIGHT) then     -- swap cmd and opt on windows
        return send(name, flagsToMods({ ctrl = flags.ctrl, shift = flags.shift, [flags.cmd and "alt" or "cmd"] = true }))
    end
    if flags.cmd and not flags.alt and not flags.ctrl and not flags.shift and inApps(EDGE, CHROME) then -- browser shortcuts
        if name == "h" then return send("y", { "cmd" }) end
        if name == "j" then return send("j", { "cmd", "shift" }) end
    end

    -- De-CapsLock
    if flags.ctrl and not flags.cmd and not flags.alt then -- fix ctrl-backspace/delete/left/right
        if (name == "delete" or name == "forwarddelete") and not flags.shift and not inApps(RDC) then return sendRightOpt(name) end
        if (name == "left" or name == "right") and not inApps(TERM, RDC) then return sendRightOpt(name, flags.shift) end
    end

    return false
end

local function flagsHandler(e)
    if e:getProperty(hs.eventtap.event.properties.eventSourceUserData) == CUSTOM_MARK then return false end
    if nizPlum.shouldSuppress(e) then return true end -- block built-in keyboard while Niz Plum 66 is connected
    if hyperActive then hyperUsed = true end          -- any modifier interrupts capslock tap
    return false
end

-- Window Management
hs.hotkey.bind({ "alt" }, "up", function() require("window").maximize() end)
hs.hotkey.bind({ "alt" }, "left", function() require("window").snap("left") end)
hs.hotkey.bind({ "alt" }, "right", function() require("window").snap("right") end)
local vHalf = "up"
hs.hotkey.bind({ "alt" }, "down", function()
    vHalf = vHalf == "down" and "up" or "down"
    require("window").snap(vHalf)
end)
hs.hotkey.bind({ "cmd", "alt" }, "left", function() require("window").moveDisplay("previous") end)
hs.hotkey.bind({ "cmd", "alt" }, "right", function() require("window").moveDisplay("next") end)
hs.hotkey.bind({ "cmd", "alt" }, "m", function() require("window").center() end)
hs.hotkey.bind({ "cmd", "alt" }, "9", function() require("window").resizeBy(-10) end)
hs.hotkey.bind({ "cmd", "alt" }, "0", function() require("window").resizeBy(10) end)

-- Application Switcher
local function sh(cmd) return function() hs.execute(cmd, true) end end
hs.hotkey.bind({ "cmd" }, "`", sh([[pgrep 'Slack' && open -a 'Slack']]))
hs.hotkey.bind({ "cmd", "alt" }, "`", sh([[(pgrep zoom.us && open -a zoom.us) || open -a WeChat]]))
hs.hotkey.bind({ "cmd" }, "1", sh([[(pgrep Chrome && open -a 'Google Chrome') || (pgrep 'Microsoft Edge' && open -a 'Microsoft Edge') || (pgrep Orion && open -a 'Orion')]]))
hs.hotkey.bind({ "cmd", "alt" }, "1", sh([[(pgrep Orion && open -a 'Orion') || (pgrep 'Microsoft Outlook' && open -a 'Microsoft Outlook')]]))
hs.hotkey.bind({ "cmd" }, "2", sh([[ps -p $(pgrep '^Code$|idea|jetbrains_client' | head -1) -o comm= | grep -m1 -o '.*\.app' | xargs -r -I@ open -a '@']]))
hs.hotkey.bind({ "cmd", "alt" }, "2", sh([[pgrep 'Microsoft Outlook' && open -a 'Microsoft Outlook']]))
hs.hotkey.bind({ "cmd" }, "3", sh([[open -a 'WezTerm']]))
hs.hotkey.bind({ "cmd" }, "4", sh([[open -a 'Notes']]))

local function capsLockToF18() hs.execute([[hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}']]) end
capsLockToF18()
HsUsbWatcher = hs.usb.watcher.new(capsLockToF18):start() -- garbage collected variables will revert the effect, keep global references
HsWakeWatcher = hs.caffeinate.watcher.new(function(ev) if ev == hs.caffeinate.watcher.systemDidWake then capsLockToF18() end end):start()
HsKeyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, keyHandler):start()
HsFlagsTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, flagsHandler):start()
