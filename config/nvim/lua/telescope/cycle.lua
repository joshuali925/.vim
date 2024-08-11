-- https://github.com/nvim-telescope/telescope.nvim/issues/213#issuecomment-1362163115

local builtin = require("telescope.builtin")
local state = require("telescope.actions.state")

local pickers = {
    function(opts) builtin.buffers(vim.tbl_extend("keep", opts, { ignore_current_buffer = true, only_cwd = false, sort_mru = true })) end,
    function(opts) builtin.oldfiles(vim.tbl_extend("keep", opts, { only_cwd = true })) end,
    builtin.oldfiles,
}

local index = 0
local cycle = {}
function cycle.next(fallback)
    if vim.b.telescope_cycle ~= true then
        vim.api.nvim_feedkeys(fallback, "n", false)
        return
    end
    index = (index + 1) % #pickers
    pickers[index + 1]({ default_text = state.get_current_line() })
    vim.b.telescope_cycle = true
end

return setmetatable(cycle, {
    __call = function(opts)
        index = 0
        if #vim.tbl_filter(function(buf)
                return vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf })
            end, vim.api.nvim_list_bufs()) == 1 then
            index = 1
        end
        pickers[index + 1](opts)
        vim.b.telescope_cycle = true
    end
})
