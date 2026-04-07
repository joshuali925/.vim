return {
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "n", "[g", "<Cmd>lua require('gitsigns').nav_hunk('prev', {target='all'})<CR>" },
            { "n", "]g", "<Cmd>lua require('gitsigns').nav_hunk('next', {target='all'})<CR>" },
            { { "o", "x" }, "ig", "<Cmd>lua require('gitsigns.actions').select_hunk()<CR>" },
            { "n", "<leader>gd", "<Cmd>lua require('gitsigns').preview_hunk()<CR>" },
            { "x", "<leader>gd", ":Gitsigns preview_hunk<CR>" }, -- range only works with `:` for gitsigns
            { "n", "<leader>ga", "<Cmd>lua require('gitsigns').stage_hunk()<CR>" },
            { "x", "<leader>ga", ":Gitsigns stage_hunk<CR>" },
            { "n", "<leader>gu", "<Cmd>lua require('gitsigns').reset_hunk()<CR>" },
            { "x", "<leader>gu", ":Gitsigns reset_hunk<CR>" },
            { "n", "<leader>gb", "<Cmd>lua require('gitsigns').blame_line({full = true, ignore_whitespace = true})<CR>" },
        },
        config = function()
            require("gitsigns").setup({
                attach_to_untracked = true,
                signs = { add = { text = "▎" }, change = { text = "░" }, delete = { text = "▏" }, topdelete = { text = "▔" }, changedelete = { text = "▒" } },
                update_debounce = 250,
                preview_config = { border = "rounded" },
                sign_priority = 13, -- higher priority than diagnostic signs
                diffthis = { split = "botright" },
                status_formatter = function(status) return status end,
            })
            vim.api.nvim_create_user_command("Gread", function(opts)
                if opts.args == "" then return require("gitsigns").reset_buffer() end
                local result = vim.system({ "git", "show", opts.args .. ":" .. vim.fn.expand("%:.") }, { text = true }):wait()
                if result.code ~= 0 then return vim.notify("Gread: " .. result.stderr, vim.log.levels.ERROR) end
                local lines = vim.split(result.stdout, "\n", { plain = true })
                if lines[#lines] == "" then lines[#lines] = nil else vim.bo.eol = false end
                vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
            end, {
                nargs = "?",
                complete = function(arglead)
                    return vim.tbl_filter(function(x) return vim.startswith(x, arglead) end, vim.split(vim.system({ "git", "rev-parse", "--symbolic", "--branches", "--tags", "--remotes" }, { text = true }):wait().stdout, "\n", { plain = true, trimempty = true }))
                end,
            })                                                                                             -- git checkout -- %
            vim.api.nvim_create_user_command("Gwrite", "lua require('gitsigns').stage_buffer()", {})       -- git add -- %
            vim.api.nvim_create_user_command("Greset", "lua require('gitsigns').reset_buffer_index()", {}) -- git reset -- %
            vim.api.nvim_create_user_command(                                                              -- git diff <ref> -- %
                "Gdiffsplit",
                "tab sbuffer | lua require('gitsigns').diffthis(<q-args>, {split = 'aboveleft'}, function() vim.wo[vim.fn.win_getid(vim.fn.winnr('#'))].winbar = '%f' end)",
                { nargs = "*" }
            )
        end,
    },
    {
        "esmuellert/codediff.nvim",
        install = false,
        cmd = { "CodeDiff" },
        config = function()
            require("codediff").setup({
                diff = { layout = "inline", compute_moves = true, ignore_trim_whitespace = true },
                explorer = { view_mode = "tree" },
                keymaps = { view = { next_hunk = "]g", prev_hunk = "[g", next_file = "\\", prev_file = "<BS>", toggle_stage = "=" }, explorer = { toggle_view_mode = "`" } },
            })
        end,
    },
    {
        "madmaxieee/unclash.nvim",
        keys = {
            { "n", "[n", "<Cmd>lua require('unclash').prev_conflict()<CR>" },
            { "n", "]n", "<Cmd>lua require('unclash').next_conflict()<CR>" },
            {
                "n",
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
