return {
    { "NMAC427/guess-indent.nvim", lazy = false, opts = { filetype_exclude = vim.g.qs_filetype_blacklist } },
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
        config = function() vim.cmd.doautocmd("FileType") end, -- trigger autocmd to defined MarkdownPreview command for buffer
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
        "mistweaverco/kulala.nvim", -- TODO mistweaverco/kulala-ls
        init = function()
            vim.api.nvim_create_augroup("KulalaAutoCommands", {})
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "http",
                group = "KulalaAutoCommands",
                callback = function(ev)
                    vim.o.commentstring = "# %s"
                    vim.keymap.set("n", "{", "<Cmd>lua require('kulala').jump_prev()<CR>", { buffer = ev.buf })
                    vim.keymap.set("n", "}", "<Cmd>lua require('kulala').jump_next()<CR>", { buffer = ev.buf })
                end,
            })
        end,
        config = function()
            require("kulala").setup({ default_view = "headers_body", additional_curl_options = { "--insecure" } })
            vim.api.nvim_create_user_command("KulalaCopyCurl", "lua require('kulala').copy()", {})
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            { "[m", "<Cmd>lua require('snacks.words').jump(-1, true)<CR>" },
            { "]m", "<Cmd>lua require('snacks.words').jump(1, true)<CR>" },
            { "<leader>gr", "<Cmd>lua require('snacks.gitbrowse').open({ open = vim.env.SSH_CLIENT ~= nil and function(url) vim.fn.setreg('+', url) end or nil })<CR>", mode = { "n", "x" } },
        },
        opts = {
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            statuscolumn = { enabled = false, left = { "sign" }, git = { patterns = { "MiniDiffSign" } } },
            words = { enabled = true, debounce = 150 },
            dashboard = {
                enabled = true,
                preset = {
                    header = table.concat({ -- https://textart.sh/, https://dom111.github.io/image-to-ansi/
                        [[  ██  ████████  ██                        ]],
                        [[  ████████████████                        ]],
                        [[  ██████████████████           ／l、      ]],
                        [[████  ████  ██████████       （ﾟ､ ｡７     ]],
                        [[████████████████████████       l  ~ヽ     ]],
                        [[██████    ██████████████████   じしf_,)ノ ]],
                        [[██  ██  ████  ████████████████████████████]],
                        [[████        ████████████████████████      ]],
                        [[████████████████████████████████████      ]],
                        [[████████████████████████████████████      ]],
                        [[████████████████████████████████████      ]],
                        [[████████████████████████████████████      ]],
                        [[██████████████████████████████████        ]],
                        [[  ████████████████████████████████        ]],
                        [[  ████    ████        ████    ████        ]],
                        [[  ████    ████        ████    ████        ]],
                        [[  ██      ██          ██      ██          ]],
                    }, "\n"),
                    keys = {
                        { icon = " ", key = "e", desc = "New File", action = ":enew" },
                        { icon = " ", key = "i", desc = "Insert", action = ":enew | startinsert" },
                        { icon = " ", key = "f", desc = "Find files", action = ":lua require('telescope.builtin').fd({hidden = true})" },
                        { icon = " ", key = "m", desc = "Find MRU", action = ":lua require('telescope.builtin').oldfiles()" },
                        { icon = " ", key = "M", desc = "Find MRU in CWD", action = ":lua require('telescope.builtin').oldfiles({only_cwd = true})" },
                        { icon = " ", key = "'", desc = "Find bookmarks", action = ":lua require('telescope').extensions.bookmarks.bookmarks({initial_mode = 'normal'})" },
                        { icon = "󰘬 ", key = "!", desc = "Git changed files", action = ":lua require('telescope.builtin').git_status({initial_mode = 'normal'})" },
                        { icon = " ", key = "?", desc = "Git diff", action = ":DiffviewOpen" },
                        { icon = " ", key = "+", desc = "Git diff remote", action = ":DiffviewOpen @{upstream}..HEAD" },
                        { icon = " ", key = "~", desc = "Git conflicts", action = ":Git mergetool" },
                        { icon = " ", key = "o", desc = "Git log", action = ":Flog" },
                        { icon = "󰍜 ", key = "\\", desc = "Open quickui", action = ":Lazy load vim-quickui | call quickui#menu#open('normal')" },
                        { icon = "󰒲 ", key = "p", desc = "Open Lazy UI", action = ":Lazy" },
                        { icon = "󰄉 ", key = "P", desc = "Open Lazy profile", action = ":Lazy profile" },
                        { icon = " ", key = "s", desc = "Open Mason UI", action = ":Mason" },
                        { icon = "󰑓 ", key = "r", desc = "Load session", action = ":call feedkeys(':SessionLoad', 'n')" },
                        { icon = " ", key = "c", desc = "Edit vimrc", action = ":edit $MYVIMRC" },
                        { icon = " ", key = "q", desc = "Quit", action = ":quit" },
                    },
                },
                sections = {
                    { section = "header" },
                    { icon = " ", title = "Recent files (current directory)", section = "recent_files", cwd = true, indent = 2, limit = 7, padding = 1 },
                    { icon = " ", title = "Recent files", section = "recent_files", indent = 2, limit = 3, padding = 1 },
                    { icon = " ", title = "Projects", section = "projects", limit = 3, indent = 2 },
                    { pane = 2, section = "keys", gap = 1, padding = 1 },
                    { pane = 2, section = "startup" },
                },
            },
        },
    },
    {
        "echasnovski/mini.nvim", -- loaded when icons are used
        keys = {
            { "'", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>j", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.line_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>k", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.word_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>o", "<Cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)<CR>" },
            { "g<", "cxiacxiNag", remap = true },
            { "g>", "cxiaviao<C-c>cxinag", remap = true },
            { "<leader>gd", "<Cmd>lua require('mini.diff').toggle_overlay()<CR>" },
            { "<leader>ga", "<leader>gAig", remap = true },
            { "<leader>gu", "<leader>gUig", remap = true },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                package.loaded["nvim-web-devicons"] = {}
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
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
                custom_textobjects = {
                    b = { { "%b()", "%b[]", "%b{}", "%b''", '%b""', "%b``", "%b<>" }, "^.().*().$" },
                    n = require("mini.extra").gen_ai_spec.number(),
                    ["'"] = false,
                    ['"'] = false,
                    ["`"] = false,
                    ["("] = false,
                    [")"] = false,
                    ["{"] = false,
                    ["}"] = false,
                },
            })
            require("mini.operators").setup({ exchange = { prefix = "" }, multiply = { prefix = "" }, replace = { prefix = "" }, sort = { prefix = "" } })
            require("mini.operators").make_mappings("exchange", { textobject = "cx", line = "cxx", selection = "X" })
            require("mini.operators").make_mappings("replace", { textobject = "cp", line = "", selection = "" })
            require("mini.diff").setup({
                view = { style = "sign", signs = { add = "▎", change = "░", delete = "▏" } },
                mappings = { apply = "<leader>gA", reset = "<leader>gU", textobject = "ig", goto_first = "[G", goto_prev = "[g", goto_next = "]g", goto_last = "]G" },
                options = { wrap_goto = true },
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesActionRename",
                callback = function(event)
                    require("snacks.rename").on_rename_file(event.data.from, event.data.to)
                end,
            })
        end,
    },
}
