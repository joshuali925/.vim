return {
    { "unblevable/quick-scope", config = function() vim.g.qs_hi_priority = -1 end },
    { "Wansmer/treesj", keys = { { "gS", "<Cmd>TSJSplit<CR>" }, { "gJ", "<Cmd>TSJJoin<CR>" } }, opts = { use_default_keymaps = false, max_join_length = 999 } },
    {
        "kylechui/nvim-surround",
        keys = { "ys", "cs", "ds", { "s", mode = "x" }, { "s<CR>", "gS<Space>", mode = "x", remap = true }, { "yss", "ysiw", remap = true }, { "yS", "ysg_", remap = true } },
        opts = {
            keymaps = { normal_cur = "<NOP>", normal_line = "<NOP>", normal_cur_line = "ysl", visual = "s" },
            surrounds = {
                ["j"] = { add = function() return { { "JSON.stringify(" }, { ")" } } end },
                ["J"] = { add = function() return { { "JSON.stringify(" }, { ", null, 2)" } } end },
                ["l"] = { add = function() return { { "console.log('❗', " }, { ")" } } end },
                ["v"] = { add = function() return { { "${" }, { "}" } } end },
                ["i"] = { -- modified to make right delimiter optional. ref https://github.com/kylechui/nvim-surround/blob/ae298105122c87bbe0a36b1ad20b06d417c0433e/lua/nvim-surround/config.lua#L96
                    add = function()
                        local left_delimiter = require("nvim-surround.input").get_input("Enter the left delimiter: ")
                        local right_delimiter = left_delimiter and left_delimiter ~= "" and require("nvim-surround.input").get_input("Enter the right delimiter: ")
                        if left_delimiter then return { { left_delimiter }, { right_delimiter ~= "" and right_delimiter or left_delimiter } } end
                    end,
                    find = function() end,
                    delete = function() end,
                },
            },
        },
    },
    {
        "monaqa/dial.nvim",
        keys = { { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "x" } } },
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
                    augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
                },
            })
        end,
    },
    {
        "jake-stewart/multicursor.nvim",
        keys = {
            { "<C-n>", "<Cmd>lua require('multicursor-nvim').matchAddCursor(1)<CR>", mode = { "n", "x" } },
            {
                "<leader><C-n>",
                function()
                    require("multicursor-nvim").clearCursors()
                    require("multicursor-nvim").matchAllAddCursors()
                end,
                mode = { "n", "x" },
            },
            {
                "<C-p>",
                function()
                    if require("multicursor-nvim").hasCursors() then
                        require("multicursor-nvim").deleteCursor()
                    elseif not vim.fn.mode():match("^n.*") then
                        vim.cmd.execute([["normal! \<Esc>"]])
                        require("snacks.picker").files({ on_show = function() vim.cmd.stopinsert() end, pattern = require("utils").get_visual_selection() })
                    else
                        require("snacks.picker").smart()
                    end
                end,
                mode = { "n", "x" },
            },
            { "<C-Down>", "<Cmd>lua require('multicursor-nvim').lineAddCursor(1)<CR>", mode = { "n", "x" } },
            { "<C-Up>", "<Cmd>lua require('multicursor-nvim').lineAddCursor(-1)<CR>", mode = { "n", "x" } },
            { "<C-Leftmouse>", "<Cmd>lua require('multicursor-nvim').handleMouse()<CR>" },
            { "<C-LeftDrag>", "<Cmd>lua require('multicursor-nvim').handleMouseDrag()<CR>" },
            { "<leader>gv", "<Cmd>lua require('multicursor-nvim').restoreCursors()<CR>" },
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
}
