return {
    { "tpope/vim-sleuth", lazy = false, cond = require("states").small_file },
    { "tpope/vim-unimpaired", keys = { { "[", mode = { "n", "x", "o" } }, { "]", mode = { "n", "x", "o" } }, "=p", "yo" } },
    {
        "AckslD/nvim-neoclip.lua",
        event = "TextYankPost",
        -- dependencies = { "tami5/sqlite.lua" }, -- persistent history needs libsqlite3
        opts = {
            -- enable_persistent_history = true,
            content_spec_column = true,
            on_paste = { set_reg = true },
            keys = { telescope = { n = { select = "yy", paste = "<CR>", replay = "Q" } } },
        },
    },
    { "will133/vim-dirdiff", cmd = "DirDiff" },
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && yarn install",
        ft = "markdown",
        init = function()
            vim.g.mkdp_auto_close = 0
            vim.g.mkdp_preview_options = { disable_sync_scroll = 1 }
        end,
    },
    { "godlygeek/tabular", cmd = "Tabularize" },
    {
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeToggle", "TableModeRealign", "Tableize", "TableAddFormula", "TableEvalFormulaLine" },
        keys = { { "<leader>tm", "<Cmd>TableModeToggle<CR>" } },
        init = function()
            vim.g.table_mode_tableize_map = ""
            vim.g.table_mode_motion_left_map = "<leader>th"
            vim.g.table_mode_motion_up_map = "<leader>tk"
            vim.g.table_mode_motion_down_map = "<leader>tj"
            vim.g.table_mode_motion_right_map = "<leader>tl"
            vim.g.table_mode_corner = "|" -- markdown compatible tablemode
        end,
    },
    {
        "rest-nvim/rest.nvim",
        config = function()
            require("rest-nvim").setup({ skip_ssl_verification = true })
            vim.api.nvim_create_user_command("RestNvimPreviewCurl", [[execute "normal \<Plug>RestNvimPreview"]], {})
        end,
    },
}
