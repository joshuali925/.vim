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
    "alpha",
    "mason",
    "TelescopePrompt",
    "Mundo",
    "neo-tree",
    "DiffviewFileHistory",
    "DiffviewFiles",
    "floggraph",
    "fugitiveblame",
    "aerial",
}
vim.g.qs_buftype_blacklist = { "terminal" }

local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f")) -- buffer not initialized, read size from disk

return {
    untildone_count = 0,
    size_threshold = 1048576, -- 1MB
    small_file = fsize == nil or fsize < 1048576,
}
