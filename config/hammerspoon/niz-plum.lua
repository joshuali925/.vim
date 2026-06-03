local M = {}

local NIZ_NAME = "NIZ BT5.0" -- from `system_profiler SPBluetoothDataType`
local BUILTIN_KB_TYPE = 91   -- NIZ_KB_TYPE = 198
local POLL_INTERVAL = 5

local connected = false

local function poll()
    hs.task.new("/usr/sbin/system_profiler", function(_, out)
        local matched = out:match("(.-)Not Connected:") or out
        local prevState = connected
        connected = matched:find(NIZ_NAME, 1, true) ~= nil
        if connected ~= prevState then
            hs.alert.show("Built-in keyboard " .. (connected and "disabled — NIZ connected" or "enabled — NIZ disconnected"))
        end
    end, { "SPBluetoothDataType" }):start()
end

function M.shouldSuppress(e)
    return connected and e:getProperty(hs.eventtap.event.properties.keyboardEventKeyboardType) == BUILTIN_KB_TYPE and (e:getProperty(hs.eventtap.event.properties.eventSourceUnixProcessID) or 0) == 0
end

NizPollTimer = hs.timer.doEvery(POLL_INTERVAL, poll):start()
poll()

return M
