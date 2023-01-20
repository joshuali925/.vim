return {
    { "AndrewRadev/splitjoin.vim", keys = { "gS", "gJ" } },
    { "max397574/better-escape.nvim", event = "InsertEnter", opts = { mapping = { "jk", "kj" }, timeout = 200, clear_empty_lines = true } },
    { "unblevable/quick-scope", config = function() vim.g.qs_hi_priority = -1 end },
    {
        "phaazon/hop.nvim",
        keys = {
            { "'", "<Cmd>lua require('utils').command_without_quickscope('HopChar1')<CR>", mode = { "n", "x", "o" } },
            { "q", "<Cmd>lua require('utils').command_without_quickscope('HopWord')<CR>", mode = { "n", "x", "o" } },
            { "<leader>e", "<Cmd>lua require('utils').command_without_quickscope('HopWordCurrentLine')<CR>", mode = { "n", "x", "o" } },
            { "<leader>j", "<Cmd>lua require('utils').command_without_quickscope('HopLineAC')<CR>", mode = { "n", "x", "o" } },
            { "<leader>k", "<Cmd>lua require('utils').command_without_quickscope('HopLineBC')<CR>", mode = { "n", "x", "o" } },
        },
        config = function()
            require("hop").setup()
            vim.api.nvim_set_hl(0, "HopNextKey", { link = "HopNextKey1" })
            vim.api.nvim_set_hl(0, "HopNextKey2", { link = "HopNextKey1" })
        end,
    },
    {
        "kylechui/nvim-surround",
        keys = { "y", "c", "d", { "s", mode = "x" }, { "yss", "ysiw", remap = true }, { "yS", "ysg_", remap = true } },
        opts = { keymaps = { normal_cur = "<NOP>", normal_line = "<NOP>", normal_cur_line = "ysl", visual = "s", } },
    },
    {
        "machakann/vim-swap",
        keys = {
            { "ia", "<Plug>(swap-textobject-i)", mode = { "x", "o" } },
            { "aa", "<Plug>(swap-textobject-a)", mode = { "x", "o" } },
            { "g<", "<Plug>(swap-prev)" },
            { "g>", "<Plug>(swap-next)" },
            { "gs", "<Plug>(swap-interactive)", mode = { "n", "x" } },
        },
    },
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "x" } },
            { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "x" } },
            { "g<C-a>", "g<Plug>(dial-increment)", mode = { "x" } },
            { "g<C-x>", "g<Plug>(dial-decrement)", mode = { "x" } },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.binary,
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.constant.alias.bool,
                    augend.semver.alias.semver,
                    augend.date.alias["%m/%d/%Y"],
                    augend.date.alias["%m/%d/%y"],
                    augend.date.alias["%m/%d"],
                    augend.date.alias["%-m/%-d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.date.alias["%H:%M:%S"],
                    augend.date.alias["%H:%M"],
                    augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
                    augend.constant.new({ elements = { "prev", "next" }, word = true, cyclic = true, }),
                    augend.constant.new({ elements = { "_prev", "_next" }, word = false, cyclic = true, }),
                    augend.constant.new({ elements = { "prev_", "next_" }, word = false, cyclic = true, }),
                },
            })
        end
    },
    {
        "mg979/vim-visual-multi",
        keys = { { "<C-n>", "<Plug>(VM-Find-Under)" }, { "<C-n>", "<Plug>(VM-Find-Subword-Under)", mode = "x" }, "<leader><C-n>" },
        init = function()
            vim.g.VM_default_mappings = 0
            vim.g.VM_exit_on_1_cursor_left = 1
            vim.g.VM_maps = { -- <C-Down/Up> to add cursor
                ["Select All"] = "<leader><C-n>",
                ["Find Under"] = "<C-n>",
                ["Find Subword Under"] = "<C-n>",
                ["Remove Last Region"] = "<C-p>",
                ["Skip Region"] = "<C-x>",
                ["Switch Mode"] = "<C-c>",
                ["Add Cursor At Pos"] = "g<C-n>",
                ["Select Operator"] = "v",
                ["Case Conversion Menu"] = "s",
            }
            vim.api.nvim_create_augroup("VisualMultiRemapBS", {}) -- for nvim_autopairs: https://github.com/mg979/vim-visual-multi/issues/172
            vim.api.nvim_create_autocmd("User", {
                pattern = "visual_multi_exit",
                group = "VisualMultiRemapBS",
                callback = function()
                    vim.keymap.set("i", "<BS>", "v:lua.MPairs.autopairs_bs(" .. vim.fn.bufnr() .. ")", { buffer = true, expr = true, replace_keycodes = false })
                end,
            })
        end,
    },
}
