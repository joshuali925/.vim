-- https://raw.githubusercontent.com/boltlessengineer/smart-tab.nvim/main/lua/smart-tab.lua
-- commit: 50328a2f97896315a0e64654103576d9d90cca8a

local M = {}

---@class SmartTabConfig
---@field skips (string|fun(node_type: string):boolean)[]
---@field mapping string|boolean
local configs = {
    skips = { "string_content" },
    mapping = "<tab>",
}

local function check_bs()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(0, col):match("%S") == nil
end

---@param node_type string
local function should_skip(node_type)
    for _, skip in ipairs(configs.skips) do
        if type(skip) == "string" and skip == node_type then
            return true
        elseif type(skip) == "function" and skip(node_type) then
            return true
        end
    end
    return false
end

local function ts_smart_tab()
    local node_ok, node = pcall(vim.treesitter.get_node)
    if not node_ok then
        return false
    end
    while node and should_skip(node:type()) do
        node = node:parent()
    end
    if not node then
        return false
    end
    local row, col = node:end_()
    local ok = pcall(vim.api.nvim_win_set_cursor, 0, { row + 1, col })
    if not ok then
        ok = pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
    end
    return ok
end

---smart tab
---
---returns false if not moved
---@return boolean
function M.smart_tab()
    if check_bs() then
        return false
    end
    if not ts_smart_tab() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ea", true, true, true), "", true)
    end
    return true
end

return M
