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
        local handle = assert(io.popen(command .. " 2>&1; echo $?"))
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

function M.get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    if next(lines) == nil then
        return nil
    end
    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    return table.concat(lines, "\n")
end

function M.copy_selection_with_osc_yank_script()
    local str = assert(M.get_visual_selection())
    local handle = assert(io.popen("y", "w"))
    handle:write(str)
    handle:flush()
    handle:close()
    vim.notify("Copied " .. str:len() .. " characters")
end

return M
