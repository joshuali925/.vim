return {
    {
        "rbong/vim-flog",
        dependencies = {
            "tpope/vim-fugitive",
            "tpope/vim-rhubarb",
            {
                "ja-he/heat.nvim",
                opts = { colors = { [1] = { value = 0, color = { 0, 0, 0 } }, [2] = { value = 0.95, color = { 0.7, 0.7, 0.7 } }, [3] = { value = 1, color = { 1, 1, 0.7 } } } },
            },
        },
        ft = "gitcommit", -- issue number omni-completion, does not work if cloned with url.replacement.insteadOf
        cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gclog", "Flog" },
        keys = {
            { "<leader>gf", "<Cmd>.Flogsplit<CR>" },
            { "<leader>gf", ":Flogsplit<CR>", mode = { "x" } },
            { "<leader>gb", "<Cmd>0,.Git blame<CR>" },
            { "<leader>gr", [[<Cmd>if $SSH_CLIENT == "" | .GBrowse | else | let @+=split(execute(".GBrowse!"), "\n")[-1] | endif<CR>]] },
            { "<leader>gr", [[:<C-u>if $SSH_CLIENT == "" | '<,'>GBrowse | else | let @+=split(execute("'<,'>GBrowse!"), "\n")[-1] | endif<CR>]], mode = { "x" } },
            { "<leader>gc", "<Cmd>Git commit --signoff<CR>" },
        },
        config = function()
            vim.g.fugitive_summary_format = "%d %s (%cr) <%an>"
            vim.keymap.set("ca", "git", "<C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'Git' : 'git')<CR>")
            vim.api.nvim_create_autocmd("User", {
                pattern = "FugitiveIndex",
                group = "AutoCommands",
                callback = function() vim.keymap.set("n", "dt", ":Gtabedit <Plug><cfile><bar>Gdiffsplit! @<CR>", { silent = true, buffer = true }) end,
            })
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
                end
            })
        end,
    },
}
