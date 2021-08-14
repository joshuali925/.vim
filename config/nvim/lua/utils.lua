local M = {}
local api = vim.api

function M.map(mode, lhs, rhs, opts)
    opts = opts or {noremap = true}
    if mode == "" then -- to not map select mode for snippets
        api.nvim_set_keymap("n", lhs, rhs, opts)
        api.nvim_set_keymap("x", lhs, rhs, opts)
        api.nvim_set_keymap("o", lhs, rhs, opts)
    else
        api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end

function M.telescope_grep(use_regex, pattern)
    vim.cmd("ProjectRoot")
    require("telescope.builtin").grep_string(
        {cwd = cwd, path_display = {shorten = 5}, use_regex = use_regex, search = pattern}
    )
end

return M
