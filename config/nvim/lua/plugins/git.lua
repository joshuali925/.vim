return {
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "[g", "<Cmd>lua require('gitsigns').nav_hunk('prev', {target='all'})<CR>" },
            { "]g", "<Cmd>lua require('gitsigns').nav_hunk('next', {target='all'})<CR>" },
            { "ig", "<Cmd>lua require('gitsigns.actions').select_hunk()<CR>", mode = { "o", "x" } },
            { "<leader>gd", "<Cmd>lua require('gitsigns').preview_hunk()<CR>" },
            { "<leader>gd", ":Gitsigns preview_hunk<CR>", mode = { "x" } }, -- range only works with `:` for gitsigns
            { "<leader>ga", "<Cmd>lua require('gitsigns').stage_hunk()<CR>" },
            { "<leader>ga", ":Gitsigns stage_hunk<CR>", mode = { "x" } },
            { "<leader>gu", "<Cmd>lua require('gitsigns').reset_hunk()<CR>" },
            { "<leader>gu", ":Gitsigns reset_hunk<CR>", mode = { "x" } },
            { "<leader>gb", "<Cmd>lua require('gitsigns').blame_line({full = true, ignore_whitespace = true})<CR>" },
        },
        config = function()
            require("gitsigns").setup({
                signs = { add = { text = "▎" }, change = { text = "░" }, delete = { text = "▏" }, topdelete = { text = "▔" }, changedelete = { text = "▒" } },
                update_debounce = 250,
                preview_config = { border = "rounded" },
                sign_priority = 13, -- higher priority than diagnostic signs
                diffthis = { split = "botright" },
                status_formatter = function(status) return status end,
            })
            vim.api.nvim_create_user_command("Gread", "lua require('gitsigns').reset_buffer()", {})        -- git checkout -- %
            vim.api.nvim_create_user_command("Gwrite", "lua require('gitsigns').stage_buffer()", {})       -- git add -- %
            vim.api.nvim_create_user_command("Greset", "lua require('gitsigns').reset_buffer_index()", {}) -- git reset -- %
        end,
    },
    { "esmuellert/codediff.nvim", dependencies = "MunifTanjim/nui.nvim", cmd = "CodeDiff", opts = { keymaps = { view = { next_file = "\\", prev_file = "<BS>" } } } },
    {
        "madmaxieee/unclash.nvim",
        keys = {
            { "[n", "<Cmd>lua require('unclash').prev_conflict()<CR>" },
            { "]n", "<Cmd>lua require('unclash').next_conflict()<CR>" },
            {
                "<leader>gc",
                function()
                    local actions = {
                        UnclashCurrent = "current",
                        UnclashCurrentMarker = "current",
                        UnclashBase = "base",
                        UnclashBaseMarker = "base",
                        UnclashIncoming = "incoming",
                        UnclashIncomingMarker = "incoming",
                    }
                    local mark = vim.iter(vim.inspect_pos().extmarks):find(function(mark) return mark.ns == "Unclash" and actions[mark.opts.hl_group] end)
                    if mark then
                        require("unclash").accept(actions[mark.opts.hl_group])
                    elseif vim.api.nvim_get_current_line():match("^=======") then
                        require("unclash").accept("both")
                    else
                        vim.cmd.Git({ args = { "commit", "--signoff" } }) -- mini.git command
                    end
                end,
            },
        },
    },
}
