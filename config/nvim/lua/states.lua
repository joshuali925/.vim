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
    "TelescopePrompt",
    "Mundo",
    "neo-tree",
    "DiffviewFileHistory",
    "DiffviewFiles",
    "floggraph",
    "git",
    "fugitiveblame",
    "dropbar_menu",
    "minifiles",
    "noice",
    "snacks_dashboard",
}
vim.g.qs_buftype_blacklist = { "terminal" }

local qs_disabled_filetypes = { ["."] = false }
for _, ft in ipairs(vim.g.qs_filetype_blacklist) do
    qs_disabled_filetypes[ft] = false
end

local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f")) -- buffer not initialized, read size from disk

return {
    untildone_count = 0,
    size_threshold = 1048576, -- 1MB
    small_file = fsize == nil or fsize < 1048576,
    qs_disabled_filetypes = qs_disabled_filetypes,
}
