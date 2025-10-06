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
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    if not ok then return vim.notify("No parser for " .. ft, vim.log.levels.WARN) end
    local tree = assert(parser):parse()[1]
    local root = tree:root()
    local query = vim.treesitter.query.parse(lang, "(comment) @comment")
    local ranges = {}
    for _, node in query:iter_captures(root, bufnr, start_line and (start_line - 1) or 0, end_line or -1) do
        table.insert(ranges, { node:range() })
    end
    table.sort(ranges, function(a, b)
        if a[1] == b[1] then return a[2] < b[2] end
        return a[1] > b[1]
    end)
    for _, r in ipairs(ranges) do vim.api.nvim_buf_set_text(bufnr, r[1], r[2], r[3], r[4], {}) end
end

function M.toggle_venn()
    vim.b.venn_enabled = vim.b.venn_enabled == nil and true or nil
    if vim.b.venn_enabled then
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "x", "v", ":VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "v", "<C-v>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<C-v>", "v", { noremap = true, silent = true })
    else
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "x", "v")
        vim.api.nvim_buf_del_keymap(0, "n", "v")
        vim.api.nvim_buf_del_keymap(0, "n", "<C-v>")
    end
    vim.wo.virtualedit = vim.b.venn_enabled and "all" or "block"
    require("snacks").indent[vim.b.venn_enabled and "disable" or "enable"]()
    vim.notify("Venn.nvim " .. (vim.b.venn_enabled and "enabled" or "disabled"))
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
    local selection_path = os.tmpname()
    local cmd = ([[yazi --cwd-file="$HOME/.vim/tmp/last_result" --chooser-file="%s" "%s"]]):format(selection_path, curr ~= "" and curr or ".")
    local terminal = require("snacks.terminal").open(cmd, { win = { height = 0.9, width = 0.9 } })
    local buf = terminal.buf                         -- terminal.buf is not available in TermClose callback
    vim.keymap.set("t", "<C-o>", function()
        local error = require("snacks.notify").error -- to suppress error
        require("snacks.notify").error = function() end
        terminal:close()
        require("snacks.notify").error = error
        require("snacks.lazygit").open({ win = { height = 0.9, width = 0.9 } })
    end, { buffer = buf })
    vim.api.nvim_create_autocmd("TermClose", {
        once = true,
        callback = function(ev)
            if ev.buf ~= buf then return end -- <buffer=buf> doesn't work due to snacks.win's autocmd
            local file = io.open(selection_path, "r")
            if file ~= nil then
                local files = {}
                for line in file:lines() do table.insert(files, vim.fn.fnameescape(line)) end
                file:close()
                os.remove(selection_path)
                vim.schedule(function() vim.cmd.args(files) end)
            end
        end,
    })
end

return M
