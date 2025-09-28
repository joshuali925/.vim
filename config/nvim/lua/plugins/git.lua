return {
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "[g", "<Cmd>lua require('gitsigns').nav_hunk('prev', {target='all'})<CR>" },
            { "]g", "<Cmd>lua require('gitsigns').nav_hunk('next', {target='all'})<CR>" },
            { "ig", ":<C-u>lua require('gitsigns.actions').select_hunk()<CR>", mode = { "o", "x" } },
            { "<leader>gd", "<Cmd>lua require('gitsigns').preview_hunk()<CR>" },
            { "<leader>ga", "<Cmd>lua require('gitsigns').stage_hunk()<CR>" },
            { "<leader>gu", "<Cmd>lua require('gitsigns').reset_hunk()<CR>" },
            { "<leader>gb", "<Cmd>lua require('gitsigns').blame_line({full = true, ignore_whitespace = true})<CR>", mode = { "n", "x" } },
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
            vim.api.nvim_create_user_command("Gread", "lua require('gitsigns').reset_buffer()", {})
            vim.api.nvim_create_user_command("Gwrite", "lua require('gitsigns').stage_buffer()", {})
            vim.api.nvim_create_user_command("Greset", "lua require('gitsigns').reset_buffer_index()", {})
        end,
    },
    { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" }, opts = { view = { merge_tool = { layout = "diff1_plain" } } } },
    {
        "akinsho/git-conflict.nvim",
        config = function()
            require("git-conflict").setup({ default_mappings = false, default_commands = false })
            vim.api.nvim_create_autocmd("User", {
                pattern = "GitConflictDetected",
                callback = function(e)
                    -- TODO https://github.com/akinsho/git-conflict.nvim/issues/48#issuecomment-2131531276
                    vim.keymap.set("n", "<leader>gc", function()
                        local actions = {
                            GitConflictCurrent = "ours",
                            GitConflictCurrentLabel = "ours",
                            GitConflictAncestor = "base",
                            GitConflictAncestorLabel = "base",
                            GitConflictIncoming = "theirs",
                            GitConflictIncomingLabel = "theirs",
                        }
                        local line = vim.api.nvim_get_current_line()
                        if line:match("=======") then
                            require("git-conflict").choose("both")
                            return
                        end
                        if line:match(">>>>>>>") then
                            local cursor_pos = vim.api.nvim_win_get_cursor(0)
                            vim.api.nvim_win_set_cursor(0, { cursor_pos[1] - 1, cursor_pos[2] })
                            require("git-conflict").choose("theirs")
                            return
                        end
                        local mark = vim.iter(vim.inspect_pos().extmarks):find(
                            function(mark) return mark.ns == "git-conflict" and actions[mark.opts.hl_group] end
                        )
                        if not mark then
                            vim.notify("No conflict under cursor", vim.log.levels.WARN)
                            return
                        end
                        require("git-conflict").choose(actions[mark.opts.hl_group])
                    end, { buffer = e.buf })
                    vim.keymap.set("n", "<leader>gC", "<Cmd>lua require('git-conflict').choose('none')<CR>", { buffer = e.buf })
                end,
            })
        end,
    },
}
