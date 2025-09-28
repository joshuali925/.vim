return {
    { "eandrju/cellular-automaton.nvim", cmd = "CellularAutomaton", enabled = false },
    { "NMAC427/guess-indent.nvim", lazy = false, opts = { filetype_exclude = vim.g.qs_filetype_blacklist } },
    { "nvim-lua/plenary.nvim" },
    { "tpope/vim-unimpaired", keys = { { "[", mode = { "n", "x", "o" } }, { "]", mode = { "n", "x", "o" } }, "=p", "yo" } },
    { "will133/vim-dirdiff", cmd = "DirDiff" },
    { "jbyuki/venn.nvim", cmd = "VBox" },
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
        "mistweaverco/kulala.nvim",
        init = function()
            vim.api.nvim_create_augroup("KulalaAutoCommands", {})
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "http",
                group = "KulalaAutoCommands",
                callback = function(ev)
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
        "folke/snacks.nvim", -- or https://github.com/dmtrKovalenko/fff.nvim
        priority = 1000,
        lazy = false,
        keys = {
            { "[m", "<Cmd>lua require('snacks.words').jump(-vim.v.count1, true)<CR>" },
            { "]m", "<Cmd>lua require('snacks.words').jump(vim.v.count1, true)<CR>" },
            { "<leader>gr", "<Cmd>lua require('snacks.gitbrowse').open({ open = vim.env.SSH_CLIENT ~= nil and function(url) vim.fn.setreg('+', url) end or nil })<CR>", mode = { "n", "x" } },
            { "<leader>B", "<Cmd>lua require('snacks.explorer').reveal()<CR>" },
            { "q", "<Cmd>lua require('snacks.picker').buffers()<CR>" },
            { "<leader><C-p>", function()
                require("snacks.picker").resume()
                vim.schedule(vim.cmd.stopinsert)
            end },
            { "<leader>fm", "<Cmd>lua require('snacks.picker').recent()<CR>" },
            { "<leader>f'", "<Cmd>lua require('snacks.picker').jumps()<CR>" },
            { "<leader>fb", "<Cmd>lua require('snacks.picker').grep_buffers()<CR>" },
            { "<leader>fb", ":<C-u>lua require('snacks.picker').grep_buffers({regex = false, live = false, on_show = function() vim.cmd.stopinsert() end, search = require('utils').get_visual_selection()})<CR>", mode = "x" },
            { "<leader>fu", "<Cmd>lua require('snacks.picker')[require('lsp').is_active() and 'lsp_symbols' or 'treesitter']()<CR>" },
            { "<leader>fg", ":RgRegex " },
            { "<leader>fg", ":<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR>", mode = "x" },
            { "<leader>fj", "<Cmd>lua require('snacks.picker').grep_word({args = {'--word-regexp'}})<CR>" },
            { "<leader>fj", "<Cmd>lua require('snacks.picker').grep_word()<CR>", mode = "x" },
            { "<leader>f!", "<Cmd>lua require('snacks.picker').git_status()<CR>" },
            { "<leader>fq", "<Cmd>lua require('snacks.picker').qflist()<CR>" },
            { "<leader>fl", "<Cmd>lua require('snacks.picker').lines()<CR>" },
            { "<leader>fL", "<Cmd>lua require('snacks.picker').loclist()<CR>" },
            { "<leader>fa", "<Cmd>lua require('snacks.picker').commands()<CR>" },
            { "<leader>fz", "<Cmd>lua require('snacks.picker').projects()<CR>" },
            { "<leader>ff", "<Cmd>lua require('snacks.picker').pickers()<CR>" },
            { "<leader>f/", "<Cmd>lua require('snacks.picker').grep()<CR>" },
            { "<leader>fr", "<Cmd>lua require('snacks.picker').registers()<CR>" },
            { "<leader>f:", "<Cmd>lua require('snacks.picker').command_history()<CR>" },
            { "<leader>u", "<Cmd>lua require('snacks.picker').undo()<CR>" },
            { "<leader>ft", "<Cmd>lua require('utils').pick_filetypes()<CR>" },
            { "<leader>fy", "<Cmd>lua require('clips').pick()<CR>" },
            { "<leader>fy", '"xdh<leader>fy', mode = "x", remap = true },
            { "mf", "<Cmd>lua require('bookmarks').pick()<CR>" },
            { "mF", "<Cmd>lua require('bookmarks').pick({filter = {cwd = false}})<CR>" },
            { "<C-o>", "<Cmd>lua require('utils').file_manager()<CR>" },
            { "<C-b>", "<Cmd>lua require('snacks.terminal').toggle(vim.g.termshell, { win = { position = 'bottom' } })<CR>", mode = { "n", "t" } },
            { "<leader>to", "<Cmd>lua require('snacks.terminal').open(vim.g.termshell, { win = { position = 'bottom' }, cwd = vim.fn.expand('%:p:h') })<CR>" },
            { "<leader>tv", "<Cmd>lua require('snacks.terminal').open(vim.g.termshell, { win = { position = 'right' } })<CR>" },
            { "<leader>te", "<Cmd>lua require('utils').send_to_terminal()<CR>g@" },
            { "<leader>tee", "<leader>te_", remap = true },
            { "<leader>te", ":<C-u>lua require('utils').send_selection_to_terminal()<CR>", mode = { "x" } },
            { "<leader>gB", "<Cmd>lua require('snacks.git').blame_line()<CR>" },
        },
        opts = {
            bigfile = { enabled = true, line_length = 5000 },
            quickfile = { enabled = true },
            statuscolumn = { enabled = false, left = { "sign" }, git = { patterns = { "MiniDiffSign" } } },
            words = { enabled = true },
            terminal = { auto_insert = false, win = { height = 0.3, width = 0.5 } },
            input = { enabled = true, win = { width = 25, relative = "cursor", row = 1 } },
            indent = {
                enabled = true,
                animate = { enabled = false },
                indent = { char = "▏" },
                scope = { char = "▏" },
                filter = function(buf) return vim.bo[buf].buftype == "" and require("states").qs_disabled_filetypes[vim.bo[buf].filetype] ~= false end,
            },
            dashboard = {
                enabled = true,
                preset = {
                    header = table.concat({ -- https://textart.sh/, https://dom111.github.io/image-to-ansi/
                        [[  ██  ████████  ██                        ]],
                        [[  ████████████████                        ]],
                        [[  ██████████████████                      ]],
                        [[████  ████  ██████████                    ]],
                        [[████████████████████████                  ]],
                        [[██████    ██████████████████              ]],
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
                        { icon = " ", key = "e", desc = "New File", action = ":enew", hidden = true },
                        { icon = " ", key = "i", desc = "Insert", action = ":enew | startinsert", hidden = true },
                        { icon = "󰙅 ", key = "b", desc = "Open file tree", action = ":lua require('neo-tree.command').execute({reveal_force_cwd = true})" },
                        { icon = " ", key = "f", desc = "Find files", action = ":lua require('snacks.picker').files()" },
                        { icon = " ", key = "m", desc = "Find MRU (CWD only: 'M')", action = ":lua require('snacks.picker').recent()" },
                        { icon = " ", key = "M", desc = "Find MRU in CWD", action = ":lua require('snacks.picker').recent({filter = {cwd = true}})", hidden = true },
                        { icon = " ", key = "z", desc = "Find projects", action = ":lua require('snacks.picker').projects()" },
                        { icon = " ", key = "'", desc = "Find bookmarks", action = ":lua require('bookmarks').pick()" },
                        { icon = "󰘬 ", key = "!", desc = "Git changed files", action = ":lua require('snacks.picker').git_status()" },
                        { icon = " ", key = "d", desc = "Git diff", action = ":DiffviewOpen" },
                        { icon = " ", key = "+", desc = "Git diff remote", action = ":DiffviewOpen @{upstream}..HEAD" },
                        { icon = "󰍜 ", key = "\\", desc = "Open quickui", action = ":Lazy load vim-quickui | call quickui#menu#open('normal')" },
                        { icon = "󰒲 ", key = "p", desc = "Open Lazy (update: 'u', profile: 'P')", action = ":Lazy" },
                        { icon = "󰄉 ", key = "P", desc = "Open Lazy profile", action = ":Lazy profile", hidden = true },
                        { icon = "󰚰 ", key = "u", desc = "Update plugins", action = ":Lazy update", hidden = true },
                        { icon = " ", key = "s", desc = "Open Mason", action = ":Mason" },
                        { icon = "󰑓 ", key = "r", desc = "Load session", action = ":call feedkeys(':SessionLoad', 'n')" },
                        { icon = " ", key = "c", desc = "Edit vimrc", action = ":edit $MYVIMRC" },
                        { icon = " ", key = "q", desc = "Quit", action = ":quit", hidden = true },
                    },
                },
                sections = {
                    { section = "header" },
                    { icon = " ", title = "Recent files (current directory)", section = "recent_files", cwd = true, indent = 2, limit = 5, padding = 1 },
                    { icon = " ", title = "Recent files", section = "recent_files", indent = 2, limit = 5 },
                    { pane = 2, section = "keys", gap = 1, padding = 1 },
                    { pane = 2, section = "startup", padding = 1 },
                    { pane = 2, icon = " ", title = "Projects", section = "projects", limit = 3, indent = 2 },
                },
            },
            explorer = {},
            picker = {
                ui_select = false,
                formatters = { file = { filename_first = true, truncate = 80 } },
                layout = { preset = "dropdown" },
                sources = {
                    files = { hidden = true, layout = { preset = "vscode" } },
                    smart = { hidden = true, layout = { preset = "vscode" }, filter = { cwd = true } },
                    buffers = { current = false, layout = { preset = "vscode" } },
                    recent = { matcher = { frecency = false }, layout = { preset = "vscode" } },
                    commands = { layout = { preset = "vscode" } },
                    projects = { layout = { preset = "vscode" } },
                    pickers = { layout = { preset = "vscode" } },
                    grep = { hidden = true, layout = { layout = { row = 2, width = 0.8, height = 0.9 } } },
                    grep_word = { hidden = true, layout = { layout = { row = 2, width = 0.8, height = 0.9 } }, on_show = function() vim.cmd.stopinsert() end },
                    grep_buffers = { layout = { layout = { row = 2, width = 0.8, height = 0.9 } } },
                    git_status = { on_show = function() vim.cmd.stopinsert() end },
                    jumps = { on_show = function() vim.cmd.stopinsert() end },
                    undo = { layout = { preset = "default" }, on_show = function() vim.cmd.stopinsert() end },
                    explorer = {
                        hidden = true,
                        ignored = true,
                        follow_file = false,
                        win = {
                            input = { keys = { ["<Esc>"] = { "toggle_focus", mode = { "i", "n" } }, ["jk"] = { "toggle_focus", mode = { "i", "n" } } } },
                            list = {
                                keys = {
                                    ["<Esc>"] = "",
                                    ["-"] = "explorer_up",
                                    ["x"] = "explorer_del",
                                    ["r"] = "explorer_update",
                                    ["R"] = "explorer_rename",
                                    ["d"] = "select_and_next",
                                    ["p"] = "explorer_move",
                                    ["C"] = "explorer_focus",
                                    ["<C-b>"] = "terminal",
                                    ["<C-p>"] = "picker_files",
                                    ["<leader>f/"] = "picker_grep",
                                },
                            },
                        },
                    },
                },
                win = {
                    input = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "i", "n" } },
                            [","] = "preview_scroll_down",
                            ["."] = "preview_scroll_up",
                            ["<C-s>"] = { "toggle_live", mode = { "i", "n" } },
                            ["`"] = { "toggle_ignored", mode = { "i", "n" } },
                        },
                    },
                },
            },
        },
    },
    {
        "nvim-mini/mini.nvim", -- loaded when icons are used
        keys = {
            { "'", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>j", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.line_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>k", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.word_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>o", "<Cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)<CR>" },
            { "g<", "cxiacxiNa", remap = true },
            { "g>", "cxiacxiPa", remap = true },
            { "<leader>gc", "<Cmd>Git commit --signoff<CR>" },
            { "<leader>fd", "<Cmd>lua require('mini.pick').builtin.files()<CR>" },
            {
                "<leader>fd",
                function()                                -- https://github.com/nvim-mini/mini.nvim/issues/513#issuecomment-1762785125
                    vim.cmd.execute([["normal! \<Esc>"]]) -- escape visual mode to update '< and '> marks
                    local prompt = require("utils").get_visual_selection()
                    vim.schedule(function() require("mini.pick").set_picker_query(vim.split(prompt, "")) end)
                    require("mini.pick").builtin.files()
                end,
                mode = { "x" },
            },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                package.loaded["nvim-web-devicons"] = {}
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        config = function()
            vim.defer_fn(function()
                require("mini.extra").setup()
                local ui_select_orig = vim.ui.select -- https://github.com/nvim-mini/mini.nvim/commit/a447cccd085a28b30ec55c24211cd49813295aa8
                require("mini.pick").setup()
                vim.ui.select = ui_select_orig
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
                vim.api.nvim_create_user_command("Git", function(opts)
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = "git",
                        callback = function(args)
                            if vim.api.nvim_buf_get_name(args.buf):match("^minigit://") then
                                vim.keymap.set("n", "<CR>", function() require("mini.git").show_at_cursor() end, { buffer = args.buf })
                            end
                        end,
                    })
                    require("mini.git").setup()
                    vim.cmd.Git({ args = opts.fargs })
                end, { bang = true, nargs = "+" })
                vim.api.nvim_create_autocmd("User", {
                    pattern = "MiniFilesActionRename",
                    callback = function(e) require("snacks.rename").on_rename_file(e.data.from, e.data.to) end,
                })
            end, 200)
        end,
    },
}
