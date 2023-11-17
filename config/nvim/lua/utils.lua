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
                vim.notify(result, vim.log.levels.ERROR, { title = "Restarting tmux task" })
            end
        end, 500)
    end)
end

function M.untildone(command, should_restart_tmux_task, message)
    if not is_empty(should_restart_tmux_task) then
        M.restart_tmux_task()
    end

    if is_empty(command) then
        local jobs = #timers
        for i, timer in pairs(timers) do
            if pcall(timer.close, timer) then
                states.untildone_count = states.untildone_count - 1
                table.remove(timers, i)
            end
        end
        vim.notify("Number of jobs stoped: " .. jobs - #timers .. "\nNumber of jobs running: " .. #timers,
            vim.log.levels.INFO, { title = "All loop stopped" })
        return
    end

    local timer = vim.loop.new_timer()
    local timer_id = id
    id = id + 1
    timers[timer_id] = timer
    states.untildone_count = states.untildone_count + 1
    vim.notify(command, vim.log.levels.INFO, { title = "Loop started" })
    timer:start(1000, 1000, function()
        local handle = assert(io.popen(command .. " 2>&1; echo $?"))
        local result = handle:read("*a")
        handle:close()
        if result:match(".*%D(%d+)") == "0" then
            states.untildone_count = states.untildone_count - 1
            vim.notify(message or "Command succeeded", vim.log.levels.INFO, { title = "Loop stopped", icon = "" })
            timer:close()
            table.remove(timers, timer_id)
        end
    end)
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

-- TODO use built-in osc52 for nvim >= 0.10
function M.copy_with_osc_yank_script(str)
    local message = ""
    if str:len() > 70000 then
        str = str:sub(1, 70000)
        message = "String too large. "
    end
    local handle = assert(io.popen("y", "w"))
    handle:write(str)
    handle:flush()
    handle:close()
    vim.notify(message .. "Copied " .. str:len() .. " characters.", vim.log.levels.INFO, { title = "osc52" })
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

function M.git_change_base(commit)
    require("lazy").load({ plugins = "vim-flog" })
    vim.cmd.Git({ args = { "difftool --name-status " .. commit }, bang = true })
    require("gitsigns").change_base(commit, true)
end

function M.toggle_venn()
    vim.b.venn_enabled = vim.b.venn_enabled == nil and true or nil
    if vim.b.venn_enabled then
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "x", "v", ":VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "v", "<C-v>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<C-v>", "v", { noremap = true })
    else
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "x", "v")
        vim.api.nvim_buf_del_keymap(0, "n", "v")
        vim.api.nvim_buf_del_keymap(0, "n", "<C-v>")
    end
    vim.o.virtualedit = vim.b.venn_enabled and "all" or "block"
    vim.cmd("IBL" .. (vim.b.venn_enabled and "Disable" or "Enable"))
    vim.notify("Venn.nvim " .. (vim.b.venn_enabled and "enabled" or "disabled"))
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

local function term_with_edit_callback(cmd, height, width, border)
    local selection_path = os.tmpname()
    return require("toggleterm.terminal").Terminal:new({
        cmd = cmd:format(vim.fn.fnameescape(selection_path)),
        direction = "float",
        float_opts = { height = height, width = width, border = border or "curved" },
        on_close = function(_)
            local handle = io.open(selection_path, "r")
            if handle ~= nil then
                local files = {}
                for line in handle:lines() do
                    table.insert(files, vim.fn.fnameescape(line));
                end
                handle:close()
                os.remove(selection_path)
                vim.schedule(function()
                    vim.cmd.args(files)
                end)
            end
        end,
    })
end

local lf_term, fzf_term, prev_height, prev_width
function M.lf()
    local height = vim.o.lines - 7
    local width = math.ceil(vim.o.columns * 9 / 10)
    if lf_term == nil or prev_height ~= height or prev_width ~= width then
        local cmd = ([[lf -last-dir-path="$HOME/.vim/tmp/lf_dir" -selection-path="%s" "%s"]]):format("%s", vim.fn.expand("%"))
        lf_term = term_with_edit_callback(cmd, height, width)
    end
    lf_term:toggle()
end

function M.fzf(visual)
    local height = vim.o.lines - 6
    local width = math.ceil(vim.o.columns * 9 / 10)
    if visual or fzf_term == nil or prev_height ~= height or prev_width ~= width then
        local cmd = ([[%s | FZF_DEFAULT_OPTS="%s %s" fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}" ]]):format(vim.env.FZF_CTRL_T_COMMAND, vim.env.FZF_DEFAULT_OPTS .. " --layout=default --bind=tab:toggle-out,shift-tab:toggle-in --height=100%", vim.env.FZF_CTRL_T_OPTS):gsub("`", "\\`"):gsub("%%", "%%%%") .. (visual and "--query " .. M.get_visual_selection() .. " > %s" or "> %s")
        fzf_term = term_with_edit_callback(cmd, height, width, "none")
    end
    fzf_term:toggle()
end

return M
