-- https://github.com/nvim-telescope/telescope.nvim/issues/213#issuecomment-1362163115

local builtin = require("telescope.builtin")
local state = require("telescope.actions.state")

local pickers = {
    mru = {
        function(opts) builtin.buffers(vim.tbl_extend("keep", opts, { ignore_current_buffer = true, only_cwd = false, sort_mru = true })) end,
        function(opts) builtin.oldfiles(vim.tbl_extend("keep", opts, { only_cwd = true, prompt_title = "Oldfiles (current directory)" })) end,
        function(opts) builtin.oldfiles(vim.tbl_extend("keep", opts, { prompt_title = "Oldfiles (global)" })) end,
    },
    smart_open = {
        function(opts) require("telescope").extensions.smart_open.smart_open(vim.tbl_extend("keep", opts, { cwd_only = true })) end,
        function(opts) require("telescope").extensions.smart_open.smart_open(vim.tbl_extend("keep", opts, { prompt_title = "Search Files (global)" })) end,
    },
}

local index = 0
local cycle = {}
function cycle.next(fallback)
    if vim.b.telescope_cycle_type == nil then
        vim.api.nvim_feedkeys(fallback, "n", false)
        return
    end
    local type = vim.b.telescope_cycle_type
    index = (index + 1) % #pickers[type]
    pickers[type][index + 1]({ default_text = state.get_current_line() })
    vim.b.telescope_cycle_type = type
end

return setmetatable(cycle, {
    __call = function(_, type, opts)
        index = 0
        if type == "mru" and #vim.tbl_filter(function(buf)
                return vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf })
            end, vim.api.nvim_list_bufs()) == 1 then
            index = 1
        end
        pickers[type][index + 1](opts or {})
        vim.b.telescope_cycle_type = type
    end,
})
