local M = {}

local NIZ_NAME = "NIZ BT5.0" -- from `blueutil --connected`
local BUILTIN_KB_TYPE = 91   -- NIZ_KB_TYPE = 198

local connected = false

local function poll()
    hs.task.new("/opt/homebrew/bin/blueutil", function(_, out) -- every connected device is listed, so just check for the name
        local prevState = connected
        connected = (out or ""):find(NIZ_NAME, 1, true) ~= nil
        if connected ~= prevState then
            hs.alert.show("Built-in keyboard " .. (connected and "disabled — NIZ connected" or "enabled — NIZ disconnected"))
        end
    end, { "--connected" }):start()
end
M.poll = poll

function M.shouldSuppress(e)
    return connected and e:getProperty(hs.eventtap.event.properties.keyboardEventKeyboardType) == BUILTIN_KB_TYPE and (e:getProperty(hs.eventtap.event.properties.eventSourceUnixProcessID) or 0) == 0
end

return M
