return {
    { "unblevable/quick-scope", config = function() vim.g.qs_hi_priority = -1 end },
    { "Wansmer/treesj", keys = { { "gS", "<Cmd>TSJSplit<CR>" }, { "gJ", "<Cmd>TSJJoin<CR>" } }, opts = { use_default_keymaps = false, max_join_length = 999 } },
    {
        "kylechui/nvim-surround",
        keys = { "ys", "cs", "ds", { "s", mode = "x" }, { "yss", "ysiw", remap = true }, { "yS", "ysg_", remap = true } },
        opts = {
            keymaps = { normal_cur = "<NOP>", normal_line = "<NOP>", normal_cur_line = "ysl", visual = "s" },
            surrounds = {
                ["j"] = { add = function() return { { "JSON.stringify(" }, { ")" } } end },
                ["J"] = { add = function() return { { "JSON.stringify(" }, { ", null, 2)" } } end },
                ["l"] = { add = function() return { { "console.log('❗', " }, { ")" } } end },
                ["v"] = { add = function() return { { "${" }, { "}" } } end },
            },
        },
    },
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
    {
        "monaqa/dial.nvim",
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.binary,
                    augend.integer.alias.decimal,
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
                    augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true }),
                    augend.constant.new({ elements = { "prev", "next" }, word = true, cyclic = true }),
                    augend.constant.new({ elements = { "_prev", "_next" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "prev_", "next_" }, word = false, cyclic = true }),
                },
            })
        end,
    },
    {
        "jake-stewart/multicursor.nvim",
        keys = {
            { "<C-n>", "<Cmd>lua require('multicursor-nvim').matchAddCursor(1)<CR>", mode = { "n", "x" } },
            { "<leader><C-n>", "<Cmd>lua require('multicursor-nvim').deleteCursor()<CR>", mode = { "n", "x" } },
            { "<C-Down>", "<Cmd>lua require('multicursor-nvim').lineAddCursor(1)<CR>", mode = { "n", "x" } },
            { "<C-Leftmouse>", "<Cmd>lua require('multicursor-nvim').handleMouse()<CR>" },
            { "<leader>gv", "<Cmd>lua require('multicursor-nvim').restoreCursors()<CR>" },
            {
                "<C-a>",
                function()
                    if require("multicursor-nvim").hasCursors() then
                        require("multicursor-nvim").clearCursors()
                        require("multicursor-nvim").matchAllAddCursors()
                    else
                        local isNormal = vim.fn.mode():match("^n.*")
                        require("dial.map").manipulate("increment", isNormal and "normal" or "visual")
                        if not isNormal then vim.cmd.normal({ "gv", bang = true }) end
                    end
                end,
                mode = { "n", "x" },
            },
            {
                "<C-x>",
                function()
                    if require("multicursor-nvim").hasCursors() then
                        require("multicursor-nvim").matchSkipCursor(1)
                    else
                        local isNormal = vim.fn.mode():match("^n.*")
                        require("dial.map").manipulate("decrement", isNormal and "normal" or "visual")
                        if not isNormal then vim.cmd.normal({ "gv", bang = true }) end
                    end
                end,
                mode = { "n", "x" },
            },
            {
                "<Tab>",
                function()
                    if require("multicursor-nvim").hasCursors() then
                        require("multicursor-nvim").nextCursor()
                    else
                        vim.api.nvim_feedkeys(vim.keycode("<Tab>"), "n", false)
                    end
                end,
                mode = { "n", "x" },
            },
            {
                "<S-Tab>",
                function()
                    if require("multicursor-nvim").hasCursors() then
                        require("multicursor-nvim").prevCursor()
                    else
                        vim.api.nvim_feedkeys(vim.keycode("<S-Tab>"), "n", false)
                    end
                end,
                mode = { "n", "x" },
            },
            { "<Esc>", function()
                if not require("multicursor-nvim").cursorsEnabled() then
                    require("multicursor-nvim").enableCursors()
                elseif require("multicursor-nvim").hasCursors() then
                    require("multicursor-nvim").clearCursors()
                end
            end },
        },
        config = true,
    },
    {
        "HakonHarnes/img-clip.nvim",
        enabled = vim.env.SSH_CLIENT == nil,
        keys = { { "<leader>p", "<Esc><Cmd>PasteImage<CR>", mode = "i" } },
        opts = { default = { use_cursor_in_template = false, insert_mode_after_paste = false, relative_to_current_file = true } },
    },
}
