vim.g.theme_index = -1
-- keep theme_index at the top for substitution

if vim.env.LIGHT_THEME == "1" and vim.g.theme_index < 0 then
    vim.g.theme_index = 1
end

vim.g.qs_filetype_blacklist = {
    "help",
    "man",
    "qf",
    "netrw",
    "lazy",
    "mason",
    "neo-tree",
    "DiffviewFileHistory",
    "DiffviewFiles",
    "floggraph",
    "git",
    "fugitiveblame",
    "dropbar_menu",
    "minifiles",
    "nui_input",
    "noice",
    "snacks_dashboard",
    "snacks_picker_input",
    "snacks_picker_list",
}
vim.g.qs_buftype_blacklist = { "terminal" }

local qs_disabled_filetypes = {}
for _, ft in ipairs(vim.g.qs_filetype_blacklist) do
    qs_disabled_filetypes[ft] = false
end

local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0)) -- buffer not initialized, read size from disk

M = {}
M.loading = false
M.size_threshold = 1048576 -- 1MB
M.small_file = fsize == nil or fsize < 1048576
M.qs_disabled_filetypes = qs_disabled_filetypes

function M.load_overrides()
    if vim.fn.has("win32") == 1 then vim.g.termshell = "nu" end
    vim.paste = (function(overridden) -- break undo before pasting in insert mode, :h vim.paste()
        return function(lines, phase)
            if phase == -1 and vim.fn.mode() == "i" and not vim.o.paste then
                vim.o.undolevels = vim.o.undolevels -- resetting undolevels breaks undo
            end
            overridden(lines, phase)
        end
    end)(vim.paste)
    if vim.env.SSH_CLIENT ~= nil then -- ssh session
        vim.g.clipboard = {           -- in Windows Terminal -> ssh -> nvim, osc52 doesn't automatically enable
            name = "osc52",
            copy = { ["+"] = require("vim.ui.clipboard.osc52").copy("+"), ["*"] = require("vim.ui.clipboard.osc52").copy("*") },
            paste = { ["+"] = require("vim.ui.clipboard.osc52").paste("+"), ["*"] = require("vim.ui.clipboard.osc52").paste("*") },
        }
        vim.keymap.set("n", "gx", "<Cmd>let @+=expand('<cfile>') <bar> lua vim.notify(vim.fn.expand('<cfile>'), vim.log.levels.INFO, { title = 'Link copied' })<CR>")
    elseif vim.fn.has("wsl") == 1 then
        vim.g.clipboard = {
            name = "WslClipboard",
            copy = { ["+"] = "clip.exe", ["*"] = "clip.exe" },
            paste = {
                ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
        }
    end
end

M.spin = (function()
    local frames = { "⠋ ", "⠙ ", "⠹ ", "⠸ ", "⠼ ", "⠴ ", "⠦ ", "⠧ ", "⠇ ", "⠏ " }
    local i = 0
    return function()
        if not M.loading then return "" end
        i = i % #frames + 1
        return frames[i]
    end
end)()

return M
