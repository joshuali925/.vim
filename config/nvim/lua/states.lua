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
    "noice",
    "snacks_dashboard",
    "snacks_picker_input",
    "snacks_picker_list",
}
vim.g.qs_buftype_blacklist = { "terminal" }

local qs_disabled_filetypes = { ["."] = false } -- neocodeium has "." = false
for _, ft in ipairs(vim.g.qs_filetype_blacklist) do
    qs_disabled_filetypes[ft] = false
end

local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0)) -- buffer not initialized, read size from disk

return {
    size_threshold = 1048576, -- 1MB
    small_file = fsize == nil or fsize < 1048576,
    qs_disabled_filetypes = qs_disabled_filetypes,
}
