return {
    {
        "rbong/vim-flog",
        dependencies = { "tpope/vim-fugitive", "tpope/vim-rhubarb" },
        ft = "gitcommit", -- issue number omni-completion, does not work if cloned with url.replacement.insteadOf
        cmd = { "Git", "Gcd", "Ggrep", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gclog", "Flog", "Flogsplit" },
        config = function() vim.g.fugitive_summary_format = "%d %s (%cr) <%an>" end,
    },
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "[g", "<Cmd>lua require('gitsigns').prev_hunk()<CR>" },
            { "]g", "<Cmd>lua require('gitsigns').next_hunk()<CR>" },
            { "ig", ":<C-u>lua require('gitsigns.actions').select_hunk()<CR>", mode = { "o", "x" } },
        },
        opts = {
            signs = { add = { text = "▎" }, change = { text = "░" }, delete = { text = "▏" }, topdelete = { text = "▔" }, changedelete = { text = "▒" } },
            update_debounce = 250,
            sign_priority = 11, -- higher priority than diagnostic signs
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
