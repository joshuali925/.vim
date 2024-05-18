return {
    { "NMAC427/guess-indent.nvim", lazy = false, opts = { filetype_exclude = vim.g.qs_filetype_blacklist } },
    { "LunarVim/bigfile.nvim", lazy = false, opts = { filesize = 3 } }, -- pteroctopus/faster.nvim will disable treesitter globally
    { "tpope/vim-unimpaired", keys = { { "[", mode = { "n", "x", "o" } }, { "]", mode = { "n", "x", "o" } }, "=p", "yo" } },
    {
        "gbprod/yanky.nvim",
        event = "TextYankPost",
        keys = {
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
            { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
            { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
            { "[P", "<Plug>(YankyPutIndentBeforeLinewise)" },
            { "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
            { "]P", "<Plug>(YankyPutIndentAfterLinewise)" },
            { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" },
            { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" },
            { ">p", "<Plug>(YankyPutIndentAfterShiftRight)" },
            { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" },
            { "=p", "<Plug>(YankyPutAfterFilter)" },
            { "=P", "<Plug>(YankyPutBeforeFilter)" },
            { "<leader>p", "<Plug>(YankyCycleForward)" },
            { "<leader>P", "<Plug>(YankyCycleBackward)" },
        },
        opts = { ring = { history_length = 500 }, system_clipboard = { sync_with_ring = false }, highlight = { on_yank = false, timer = 300 } },
    },
    { "will133/vim-dirdiff", cmd = "DirDiff" },
    {
        "iamcco/markdown-preview.nvim",
        enabled = vim.env.SSH_CLIENT == nil,
        build = "cd app && yarn install",
        cmd = "MarkdownPreview",
        init = function()
            vim.g.mkdp_auto_close = 0
            vim.g.mkdp_preview_options = { disable_sync_scroll = 1 }
        end,
        config = function() vim.cmd.doautocmd("FileType") end -- trigger autocmd to defined MarkdownPreview command for buffer
    },
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
    { "jbyuki/venn.nvim", cmd = "VBox" },
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        dependencies = { "vhyrro/luarocks.nvim", config = true }, -- https://github.com/vhyrro/luarocks.nvim?tab=readme-ov-file#requirements, needs lua-devel and libcurl-devel
        config = function() require("rest-nvim").setup({ skip_ssl_verification = true }) end,
    },
    {
        "echasnovski/mini.nvim",
        keys = {
            { "'", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>j", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.line_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>k", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.word_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>o", "<Cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)<CR>" },
            { "g<", "cxiacxiNag", remap = true },
            { "g>", "cxiaviao<C-c>cxinag", remap = true },
            { "ma", "<Cmd>lua require('mini.visits').add_label()<CR>" },
            { "mf", function()
                require("mini.extra").pickers.visit_labels({}, {
                    mappings = {
                        remove = {
                            char = "<C-d>",
                            func = function()
                                require("mini.visits").remove_label(require("mini.pick").get_picker_matches().current)
                                require("mini.pick").stop()
                                vim.cmd.normal("mf")
                            end,
                        }
                    },
                })
            end },
            { "<Tab>", function()
                local curr = vim.fn.expand("%:p")
                require("mini.extra").pickers.visit_paths({ filter = function(path) return path.path ~= curr end })
            end },
        },
        config = function()
            require("mini.extra").setup()
            require("mini.bufremove").setup()
            require("mini.jump2d").setup({ mappings = { start_jumping = "" } })
            require("mini.files").setup({ mappings = { go_in = "L", go_in_plus = "l", show_help = "?", reveal_cwd = "<leader>b", synchronize = "<leader>w" } })
            require("mini.move").setup({ mappings = { left = "", right = "", down = "<C-,>", up = "<C-.>", line_left = "", line_right = "", line_down = "<C-,>", line_up = "<C-.>" } })
            require("mini.hipatterns").setup({
                highlighters = {
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
                    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
                },
            })
            require("mini.align").setup({ mappings = { start = "", start_with_preview = "gl" } })
            require("mini.splitjoin").setup({ mappings = { toggle = "gs" } })
            require("mini.ai").setup({
                mappings = { around_next = "aN", inside_next = "iN", around_last = "aP", inside_last = "iP" },
                custom_textobjects = { n = require("mini.extra").gen_ai_spec.number() },
            })
            require("mini.operators").setup({ exchange = { prefix = "" }, multiply = { prefix = "" }, replace = { prefix = "" }, sort = { prefix = "" } })
            require("mini.operators").make_mappings("exchange", { textobject = "cx", line = "cxx", selection = "X" })
            require("mini.operators").make_mappings("replace", { textobject = "cp", line = "", selection = "" })
            require("mini.pick").setup()
            require("mini.visits").setup()
        end,
    },
}
