vim.g.theme_index = -1
-- keep theme_index at the top for substitution

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
    "NvimTree",
    "DiffviewFileHistory",
    "DiffviewFiles",
    "floggraph",
    "fugitiveblame",
    "lspsagaoutline",
    "lspsagafinder",
}
vim.g.qs_buftype_blacklist = { "terminal" }

local one_mb = 1048576
local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f")) -- buffer not initialized, read size from disk

return {
    untildone_count = 0,
    size_threshold = one_mb,
    small_file = fsize == nil or fsize < one_mb,
}
