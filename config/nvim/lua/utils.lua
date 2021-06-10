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

function M.dump(tbl, indent)
    if type(tbl) ~= "table" then
        print(tostring(tbl))
        return
    end
    if not indent then
        indent = 0
    end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            M.debug(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end

return M
