return {
    {
        "rbong/vim-flog",
        dependencies = {
            "tpope/vim-fugitive",
            "tpope/vim-rhubarb",
            {
                "ja-he/heat.nvim",
                opts = { colors = { [1] = { value = 0, color = { 0, 0, 0 } }, [2] = { value = 0.95, color = { 1, 1, 1 } }, [3] = { value = 1, color = { 1, 1, 0.6 } } } },
            },
        },
        ft = "gitcommit", -- issue number omni-completion, does not work if cloned with url.replacement.insteadOf
        cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gclog", "Flog" },
        keys = {
            { "<leader>gf", "<Cmd>.Flogsplit<CR>" },
            { "<leader>gf", ":Flogsplit<CR>", mode = { "x" } },
            { "<leader>gr", [[<Cmd>if $SSH_CLIENT == "" | .GBrowse | else | let @+=split(execute(".GBrowse!"), "\n")[-1] | endif<CR>]] },
            { "<leader>gr", [[:<C-u>if $SSH_CLIENT == "" | '<,'>GBrowse | else | let @+=split(execute("'<,'>GBrowse!"), "\n")[-1] | endif<CR>]], mode = { "x" } },
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
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "[g", "<Cmd>lua require('gitsigns').prev_hunk()<CR>" },
            { "]g", "<Cmd>lua require('gitsigns').next_hunk()<CR>" },
            { "ig", ":<C-u>lua require('gitsigns.actions').select_hunk()<CR>", mode = { "o", "x" } },
            { "<leader>gd", "<Cmd>lua require('gitsigns').preview_hunk()<CR>" },
            { "<leader>ga", "<Cmd>lua require('gitsigns').stage_hunk()<CR>" },
            { "<leader>gu", "<Cmd>lua require('gitsigns').reset_hunk()<CR>" },
            { "<leader>gU", "<Cmd>lua require('gitsigns').undo_stage_hunk()<CR>" },
            { "<leader>gb", "<Cmd>lua require('gitsigns').blame_line({full = true, ignore_whitespace = true})<CR>" },
        },
        opts = {
            signs = { add = { text = "▎" }, change = { text = "░" }, delete = { text = "▏" }, topdelete = { text = "▔" }, changedelete = { text = "▒" } },
            update_debounce = 250,
            sign_priority = 13, -- higher priority than diagnostic signs
        },
    },
    {
        "rhysd/conflict-marker.vim",
        config = function()
            vim.g.conflict_marker_enable_mappings = 0
            vim.g.conflict_marker_begin = "^<<<<<<< .*$"
            vim.g.conflict_marker_common_ancestors = "^||||||| .*$"
            vim.g.conflict_marker_end = "^>>>>>>> .*$"
            vim.g.conflict_marker_highlight_group = ""
            vim.cmd.doautocmd("BufReadPost") -- refresh highlights when delay loaded after treesitter
        end,
    },
    { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },
}
