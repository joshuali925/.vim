local M = {}

local states = require("states")
local timers = {}
local id = 1

local function is_empty(value)
    return value == nil or value == ""
end

local function do_action_over_motion(callback)
    local operatorfunc_save = vim.o.operatorfunc
    _G.operatorfunc_custom = function()
        local start = vim.api.nvim_buf_get_mark(0, "[")
        local finish = vim.api.nvim_buf_get_mark(0, "]")
        local lines = vim.api.nvim_buf_get_lines(0, start[1] - 1, finish[1], false)
        callback(lines)
        vim.o.operatorfunc = operatorfunc_save
        _G.operatorfunc_custom = nil
    end
    vim.o.operatorfunc = "v:lua.operatorfunc_custom"
end

-- terminate and rerun previous command in tmux first window top left pane
function M.restart_tmux_task()
    io.popen("tmux send-keys -t 1.0 -X cancel 2>/dev/null; tmux send-keys -t 1.0 c-c 2>/dev/null"):close()
    vim.schedule(function()
        vim.defer_fn(function()
            local handle = assert(io.popen("tmux send-keys -t 1.0 s-up enter 2>&1"))
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
        vim.cmd.QuickScopeToggle()
    end
    if type(command) == "string" then
        vim.cmd(command)
    else
        command()
    end
    if vim.g.qs_enable == 0 then
        vim.cmd.QuickScopeToggle()
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

function M.copy_with_osc_yank_script(str)
    local message = "[osc52] "
    if str:len() > 70000 then
        str = str:sub(1, 70000)
        message = message .. "String too large. "
    end
    local handle = assert(io.popen("y", "w"))
    handle:write(str)
    handle:flush()
    handle:close()
    print(message .. "Copied " .. str:len() .. " characters.")
end

function M.send_to_toggleterm()
    do_action_over_motion(function(lines)
        local current_window = vim.api.nvim_get_current_win()
        local b_line, b_col = unpack(vim.api.nvim_win_get_cursor(0))
        for _, cmd in ipairs(lines) do
            require("toggleterm").exec(cmd)
        end
        vim.api.nvim_set_current_win(current_window)
        vim.api.nvim_win_set_cursor(current_window, { b_line, b_col })
    end)
end

local lf_term, lf_height, lf_width
function M.toggle_lf()
    local curr_height = vim.o.lines - 7
    local curr_width = math.ceil(vim.o.columns * 9 / 10)
    if lf_term == nil or lf_height ~= curr_height or lf_width ~= curr_width then
        local lf_selection_path = os.tmpname()
        lf_term = require("toggleterm.terminal").Terminal:new({
            cmd = ('lf -last-dir-path="$HOME/.vim/tmp/lf_dir" -selection-path=%s %s'):format(lf_selection_path, vim.fn.expand("%")),
            direction = "float",
            float_opts = { height = curr_height, width = curr_width },
            on_close = function(_)
                local handle = io.open(lf_selection_path, "r")
                if handle ~= nil then
                    local files = {}
                    for line in handle:lines() do
                        table.insert(files, vim.fn.fnameescape(line));
                    end
                    handle:close()
                    os.remove(lf_selection_path)
                    vim.schedule(function()
                        vim.cmd.args(files)
                    end)
                end
            end,
        })
    end
    lf_term:toggle()
end

return M
