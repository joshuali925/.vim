return {
    { "unblevable/quick-scope", config = function() vim.g.qs_hi_priority = -1 end },
    { "Wansmer/treesj", keys = { { "gS", "<Cmd>TSJSplit<CR>" }, { "gJ", "<Cmd>TSJJoin<CR>" } }, opts = { use_default_keymaps = false, max_join_length = 999 } },
    {
        "kylechui/nvim-surround",
        keys = { "ys", "cs", "ds", { "s", mode = "x" }, { "yss", "ysiw", remap = true }, { "yS", "ysg_", remap = true } },
        opts = { keymaps = { normal_cur = "<NOP>", normal_line = "<NOP>", normal_cur_line = "ysl", visual = "s", } },
    },
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "x" } },
            { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "x" } },
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
                    augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true, }),
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
            vim.g.VM_maps = {
                -- <C-Down/Up> to add cursor
                ["Select All"] = "<leader><C-n>",
                ["Find Under"] = "<C-n>",
                ["Find Subword Under"] = "<C-n>",
                ["Remove Last Region"] = "<C-p>",
                ["Skip Region"] = "<C-x>",
                ["Switch Mode"] = "<C-c>",
                ["Add Cursor At Pos"] = "<C-LeftMouse>", -- click to move to position first, then ctrl-click to add cursor
                ["Select Operator"] = "v",
                ["Case Conversion Menu"] = "s",
                ["I BS"] = "", -- for nvim-autopairs: https://github.com/mg979/vim-visual-multi/issues/172
            }
        end,
    },
    {
        "HakonHarnes/img-clip.nvim",
        enabled = vim.env.SSH_CLIENT == nil,
        keys = { { "<leader>p", "<ESC><Cmd>PasteImage<CR>", mode = "i" } },
        opts = { default = { use_cursor_in_template = false, insert_mode_after_paste = false, relative_to_current_file = true } },
    },
}
