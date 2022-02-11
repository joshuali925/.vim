local M = {}

local states = require("states")
local timers = {}
local id = 1

local function is_empty(value)
    return value == nil or value == ""
end

-- terminate and rerun previous command in tmux first window top left pane
function M.restart_tmux_task()
    io.popen("tmux send-keys -t 1.0 -X cancel 2>/dev/null; tmux send-keys -t 1.0 c-c 2>/dev/null"):close()
    vim.schedule(function()
        vim.defer_fn(function()
            local handle = io.popen("tmux send-keys -t 1.0 s-up enter 2>&1")
            local result = handle:read("*a")
            handle:close()
            if result ~= "" then
                vim.notify(result, "ERROR", { title = "Restarting tmux task" })
            end
        end, 500)
    end)
end

function M.untildone(command, should_restart_tmux_task, message)
    if not is_empty(should_restart_tmux_task) then
        M.restart_tmux_task()
    end

    if is_empty(command) then
        for i, timer in pairs(timers) do
            if pcall(timer.close, timer) then
                states.untildone_count = states.untildone_count - 1
                table.remove(timers, i)
            end
        end
        vim.notify("Current number of jobs: " .. states.untildone_count, "INFO", { title = "All loop stopped" })
        return
    end

    local timer = vim.loop.new_timer()
    local timer_id = id
    id = id + 1
    timers[timer_id] = timer
    states.untildone_count = states.untildone_count + 1
    vim.notify(command, "INFO", { title = "Loop started" })
    timer:start(1000, 1000, function()
        local handle = io.popen(command .. " 2>&1; echo $?")
        local result = handle:read("*a")
        handle:close()
        if result:match(".*%D(%d+)") == "0" then
            states.untildone_count = states.untildone_count - 1
            vim.notify(message or "Command succeeded", "INFO", { title = "Loop stopped", icon = "" })
            timer:close()
            table.remove(timers, timer_id)
        end
    end)
end

function M.command_without_quickscope(command)
    if vim.g.qs_enable == 1 then
        vim.cmd("QuickScopeToggle")
    end
    vim.cmd(command)
    if vim.g.qs_enable == 0 then
        vim.cmd("QuickScopeToggle")
    end
end

return M

