local M = {}

local function send_lines_to_terminal(lines)
    local channel = vim.bo[require("snacks.terminal").get().buf].channel
    for _, cmd in ipairs(lines) do
        vim.fn.chansend(channel, cmd .. "\n")
    end
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

function M.send_to_terminal() do_action_over_motion(send_lines_to_terminal) end

function M.send_selection_to_terminal() send_lines_to_terminal({ M.get_visual_selection() }) end

function M.term_exec(cmd, opts)
    local terminal = require("snacks.terminal").get(nil, opts)
    vim.fn.chansend(vim.bo[terminal.buf].channel, cmd .. "\n")
    return terminal
end

function M.get_visual_selection()
    return table.concat(vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), { type = vim.fn.visualmode() }), "\n")
end

function M.base64_decode(str)
    local decoded = vim.base64.decode(str)
    local ok, lines = pcall(vim.fn.split, decoded, "\n")
    return ok and lines or { decoded }
end

function M.command_without_quickscope(command)
    if vim.g.qs_enable == 1 then vim.cmd.QuickScopeToggle() end
    if type(command) == "string" then vim.cmd(command) else command() end
    if vim.g.qs_enable == 0 then vim.cmd.QuickScopeToggle() end
end

function M.delete_comments(start_line, end_line) -- https://gist.github.com/kelvinauta/bf812108f3b68fa73de58e873c309805
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local parser = vim.treesitter.get_parser(bufnr, lang)
    local tree = assert(parser):parse()[1]
    local root = tree:root()
    local query = vim.treesitter.query.parse(lang, "(comment) @comment")
    local ranges = {}
    local affected_lines = {}
    for _, node in query:iter_captures(root, bufnr, start_line and (start_line - 1) or 0, end_line or -1) do
        local r = { node:range() }
        table.insert(ranges, r)
        for line = r[1], r[3] do affected_lines[line] = true end
    end
    table.sort(ranges, function(a, b)
        if a[1] == b[1] then return a[2] < b[2] end
        return a[1] > b[1]
    end)
    for _, r in ipairs(ranges) do vim.api.nvim_buf_set_text(bufnr, r[1], r[2], r[3], r[4], {}) end
    local lines_to_delete = {}
    for line in pairs(affected_lines) do
        local content = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
        if content and content:match("^%s*$") then
            table.insert(lines_to_delete, line)
        elseif content then
            local trimmed = content:gsub("%s+$", "")
            if trimmed ~= content then vim.api.nvim_buf_set_lines(bufnr, line, line + 1, false, { trimmed }) end
        end
    end
    table.sort(lines_to_delete, function(a, b) return a > b end)
    for _, line in ipairs(lines_to_delete) do vim.api.nvim_buf_set_lines(bufnr, line, line + 1, false, {}) end
end

function M.pick_filetypes(opts)
    opts = opts or {}
    require("snacks.picker")(vim.tbl_extend("force", {
        title = "filetypes",
        format = "text",
        items = vim.tbl_map(function(val) return { text = vim.fn.fnamemodify(val, ":t:r") } end, vim.fn.globpath(vim.o.runtimepath, "syntax/*.vim", false, true)),
        layout = { preset = "vscode" },
        confirm = function(picker, item)
            picker:close()
            if item then vim.o.filetype = item.text end
        end,
    }, opts))
end

function M.file_manager()
    local curr = vim.fn.expand("%")
    local selection_path = vim.fn.tempname() -- os.tmpname() creates the empty file when called
    local exit_path = vim.env.HOME .. "/.vim/tmp/last_result"
    os.remove(exit_path)
    local cmd = ([[yazi --cwd-file="%s" --chooser-file="%s" "%s"]]):format(exit_path, selection_path, curr ~= "" and curr or ".")
    local terminal = require("snacks.terminal").open(cmd, { auto_close = false, win = { height = 0.9, width = 0.9 } })
    local buf = terminal.buf -- terminal.buf is not available in TermClose callback
    local want_lazygit = false
    vim.keymap.set("t", "<C-o>", function()
        want_lazygit = true
        vim.fn.jobstop(vim.bo[buf].channel)
        terminal:close()
    end, { buffer = buf })
    vim.api.nvim_create_autocmd("TermClose", {
        once = true,
        callback = function(e)
            if e.buf ~= buf then return end -- <buffer=buf> doesn't work due to snacks.win's autocmd
            if want_lazygit then
                return vim.schedule(function()
                    local file = io.open(exit_path, "r")
                    local cwd = file and file:read("*l") or "."
                    if file then file:close() end
                    require("snacks.lazygit").open({ cwd = cwd, win = { height = 0.9, width = 0.9 } })
                end)
            end
            terminal:close() -- close here instead of snacks.terminal auto_close to avoid error message
            local file = io.open(selection_path, "r")
            if file ~= nil then
                local files = {}
                for line in file:lines() do table.insert(files, vim.fn.fnameescape((line:gsub("^.-://.-/", "")))) end -- https://github.com/sxyazi/yazi/issues/3510
                file:close()
                os.remove(selection_path)
                if #files > 0 then vim.schedule(function() vim.cmd.args(files) end) end
            end
        end,
    })
end

return M
