return {
    { "nvim-lua/plenary.nvim", install = false },
    { "MunifTanjim/nui.nvim", install = false },
    { "eandrju/cellular-automaton.nvim", install = false, cmd = { "CellularAutomaton" } },
    { "NMAC427/guess-indent.nvim", lazy = false, config = function() require("guess-indent").setup({ filetype_exclude = vim.g.qs_filetype_blacklist }) end },
    { "tpope/vim-unimpaired", keys = { { { "n", "x", "o" }, "[" }, { { "n", "x", "o" }, "]" }, { "n", "=p" }, { "n", "yo" } } },
    {
        "dhruvasagar/vim-table-mode", -- alternative: https://github.com/numEricL/table.vim
        install = false,
        cmd = { "TableModeToggle", "TableModeRealign", "Tableize", "TableAddFormula", "TableEvalFormulaLine" },
        keys = { { "n", "<leader>tm", "<Cmd>TableModeToggle<CR>" } },
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
        "folke/snacks.nvim",
        lazy = false,
        keys = {
            { "n", "[m", "<Cmd>lua require('snacks.words').jump(-vim.v.count1, true)<CR>" },
            { "n", "]m", "<Cmd>lua require('snacks.words').jump(vim.v.count1, true)<CR>" },
            { { "n", "x" }, "<leader>gr", "<Cmd>lua require('snacks.gitbrowse').open({ open = vim.env.SSH_CLIENT ~= nil and function(url) vim.fn.setreg('+', url) end or nil })<CR>" },
            { "n", "<leader>B", "<Cmd>lua require('snacks.explorer').reveal()<CR>" },
            { "n", "q", "<Cmd>lua require('snacks.picker').buffers()<CR>" },
            { "n", "<leader><C-p>", function()
                require("snacks.picker").resume()
                vim.defer_fn(vim.cmd.stopinsert, 100)
            end },
            { "n", "<leader>fm", "<Cmd>lua require('snacks.picker').recent()<CR>" },
            { "n", "<leader>f'", "<Cmd>lua require('snacks.picker').jumps()<CR>" },
            { "n", "<leader>fb", "<Cmd>lua require('snacks.picker').grep_buffers()<CR>" },
            { "x", "<leader>fb", ":<C-u>lua require('snacks.picker').grep_buffers({regex = false, live = false, on_show = function() vim.cmd.stopinsert() end, search = require('utils').get_visual_selection()})<CR>" },
            { "n", "<leader>fu", "<Cmd>lua require('snacks.picker')[require('lsp').is_active() and 'lsp_symbols' or 'treesitter']()<CR>" },
            { "n", "<leader>fg", ":RgRegex " },
            { "x", "<leader>fg", ":<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR>" },
            { "n", "<leader>fj", "<Cmd>lua require('snacks.picker').grep_word()<CR>" },
            { "x", "<leader>fj", "<Cmd>lua require('snacks.picker').grep_word({args = {}})<CR>" },
            { "n", "<leader>fs", "<Cmd>lua require('snacks.picker').git_status({on_show = function() vim.cmd.stopinsert() end})<CR>" },
            { "n", "<leader>f!", "<Cmd>lua require('snacks.picker').git_diff()<CR>" },
            { "n", "<leader>fq", "<Cmd>lua require('snacks.picker').qflist()<CR>" },
            { "n", "<leader>fl", "<Cmd>lua require('snacks.picker').lines()<CR>" },
            { "n", "<leader>fL", "<Cmd>lua require('snacks.picker').loclist()<CR>" },
            { "n", "<leader>fa", "<Cmd>lua require('snacks.picker').commands()<CR>" },
            { "n", "<leader>fz", "<Cmd>lua require('snacks.picker').projects()<CR>" },
            { "n", "<leader>ff", "<Cmd>lua require('snacks.picker').pickers()<CR>" },
            { "n", "<leader>f/", "<Cmd>lua require('snacks.picker').grep()<CR>" },
            { "n", "<leader>fr", "<Cmd>lua require('snacks.picker').registers()<CR>" },
            { "n", "<leader>f:", "<Cmd>lua require('snacks.picker').command_history()<CR>" },
            { "n", "<leader>u", "<Cmd>lua require('snacks.picker').undo()<CR>" },
            { "n", "<leader>ft", "<Cmd>lua require('utils').pick_filetypes()<CR>" },
            { "n", "<leader>fy", "<Cmd>lua require('clips').pick()<CR>" },
            { "x", "<leader>fy", '"xdh<leader>fy', { remap = true } },
            { "n", "mf", "<Cmd>lua require('bookmarks').pick()<CR>" },
            { "n", "mF", "<Cmd>lua require('bookmarks').pick({filter = {cwd = false}})<CR>" },
            { "n", "<C-o>", "<Cmd>lua require('utils').file_manager()<CR>" },
            { { "n", "t" }, "<C-b>", "<Cmd>lua require('snacks.terminal').toggle(vim.g.termshell, { win = { position = 'bottom' } })<CR>" },
            { "n", "<leader>to", "<Cmd>lua require('snacks.terminal').open(vim.g.termshell, { win = { position = 'bottom' }, cwd = vim.fn.expand('%:p:h') })<CR>" },
            { "n", "<leader>tv", "<Cmd>lua require('snacks.terminal').open(vim.g.termshell, { win = { position = 'right' } })<CR>" },
            { "n", "<leader>te", "<Cmd>lua require('utils').send_to_terminal()<CR>g@" },
            { "n", "<leader>tee", "<leader>te_", { remap = true } },
            { "x", "<leader>te", ":<C-u>lua require('utils').send_selection_to_terminal()<CR>" },
            { "n", "<leader>gB", "<Cmd>lua require('snacks.git').blame_line()<CR>" },
        },
        config = function()
            require("snacks").setup({
                bigfile = { enabled = true, line_length = 5000 },
                quickfile = { enabled = false },
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
                            { icon = "󰙅 ", key = "b", desc = "Open file tree", action = ":Neotree reveal_force_cwd" },
                            { icon = " ", key = "f", desc = "Find files", action = ":lua require('snacks.picker').files()" },
                            { icon = " ", key = "m", desc = "Find MRU (CWD only: 'M')", action = ":lua require('snacks.picker').recent()" },
                            { icon = " ", key = "M", desc = "Find MRU in CWD", action = ":lua require('snacks.picker').recent({filter = {cwd = true}})", hidden = true },
                            { icon = " ", key = "z", desc = "Find projects", action = ":lua require('snacks.picker').projects()" },
                            { icon = " ", key = "'", desc = "Find bookmarks", action = ":lua require('bookmarks').pick()" },
                            { icon = "󰘬 ", key = "s", desc = "Git changed files (open: !)", action = ":lua require('snacks.picker').git_status()" },
                            { icon = "󰘬 ", key = "!", desc = "Open git changed files", action = ":argadd `git diff --name-only --diff-filter=d @` | bnext", hidden = true },
                            { icon = " ", key = "d", desc = "Git diff", action = ":CodeDiff" },
                            { icon = " ", key = "+", desc = "Git diff remote", action = ":CodeDiff @{upstream}..HEAD" },
                            { icon = "󰍜 ", key = "\\", desc = "Open quickui", action = ":lua require('pack').load({'vim-quickui'}); vim.fn['quickui#menu#open']('normal')" },
                            { icon = "󰏖 ", key = "p", desc = "List plugins (update: 'u')", action = ":lua require('pack').list()" },
                            { icon = "󰚰 ", key = "u", desc = "Update plugins", action = ":lua vim.pack.update()", hidden = true },
                            { icon = " ", key = "S", desc = "Open Mason", action = ":Mason" },
                            { icon = " ", key = "d", desc = "Open Dockyard", action = ":Dockyard" },
                            { icon = "󰑓 ", key = "r", desc = "Load session", action = ":call feedkeys(':SessionLoad', 'n')" },
                            { icon = " ", key = "c", desc = "Edit vimrc", action = ":edit ~/.vim/config/nvim/init.lua" },
                            { icon = " ", key = "q", desc = "Quit", action = ":quit", hidden = true },
                        },
                    },
                    sections = {
                        { section = "header" },
                        { icon = " ", title = "Recent files (current directory)", section = "recent_files", cwd = true, indent = 2, limit = 5, padding = 1 },
                        { icon = " ", title = "Recent files", section = "recent_files", indent = 2, limit = 5 },
                        { pane = 2, section = "keys", gap = 1, padding = 1 },
                        { pane = 2, icon = " ", title = "Projects", section = "projects", limit = 3, indent = 2 },
                    },
                },
                explorer = {},
                picker = {
                    ui_select = false,
                    formatters = { file = { filename_first = true, truncate = 80 } },
                    preview = function(ctx)
                        if ctx.item.file and not ctx.item.preview_title then ctx.item.preview_title = ctx.item.file end
                        return require("snacks.picker.preview").file(ctx)
                    end,
                    sources = {
                        files = { hidden = true, layout = { preset = "vscode" } },
                        smart = { hidden = true, layout = { preset = "vscode" }, filter = { cwd = true } }, -- alternative: https://github.com/dtormoen/neural-open.nvim
                        buffers = { current = false, layout = { preset = "vscode" } },
                        recent = { matcher = { frecency = false }, layout = { preset = "vscode" } },
                        commands = { layout = { preset = "vscode" } },
                        projects = { layout = { preset = "vscode" } },
                        pickers = { layout = { preset = "vscode" } },
                        gh_issue = { layout = { preset = "ivy_split" } },
                        gh_pr = { layout = { preset = "ivy_split" } },
                        git_diff = { on_show = function() vim.cmd.stopinsert() end },
                        git_log_file = {
                            layout = { preset = "sidebar" },
                            confirm = function(picker, item)
                                picker:close()
                                if item and item.commit then vim.cmd.CodeDiff({ args = { "file", item.commit .. "^", item.commit } }) end
                            end,
                            on_show = function() vim.cmd.stopinsert() end,
                        },
                        grep = { hidden = true, layout = { preset = "dropdown", layout = { row = 2, width = 0.8, height = 0.9 } } },
                        grep_word = { hidden = true, layout = { preset = "dropdown", layout = { row = 2, width = 0.8, height = 0.9 } }, on_show = function() vim.cmd.stopinsert() end },
                        grep_buffers = { layout = { layout = { preset = "dropdown", row = 2, width = 0.8, height = 0.9 } } },
                        jumps = { on_show = function() vim.cmd.stopinsert() end },
                        undo = { on_show = function() vim.cmd.stopinsert() end },
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
                                ["<C-l>"] = "focus_preview",
                                ["<C-s>"] = { "toggle_live", mode = { "i", "n" } },
                                ["`"] = { "toggle_ignored", mode = { "i", "n" } },
                            },
                        },
                    },
                },
                lazygit = { config = { os = { edit = '[ -z "\"$NVIM\"" ] && (nvim -- {{filename}}) || (nvim --server "\"$NVIM\"" --remote-send "\"q\"" && nvim --server "\"$NVIM\"" --remote {{filename}})' } } }, -- https://github.com/folke/snacks.nvim/discussions/87#discussioncomment-12302614
            })
        end,
    },
    {
        "nvim-mini/mini.nvim",
        event = { "UIEnter" },
        keys = {
            { { "n", "x", "o" }, "'", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)<CR>" },
            { { "n", "x", "o" }, "<leader>j", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.line_start) end)<CR>" },
            { { "n", "x", "o" }, "<leader>k", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.word_start) end)<CR>" },
            { "n", "<leader>o", "<Cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), false)<CR>" },
            { "n", "g<", "cxiacxiPag", { remap = true } },
            { "n", "g>", "cxiacxiNag", { remap = true } },
            { "n", "<leader>fd", "<Cmd>lua require('mini.pick').builtin.files()<CR>" },
            {
                "x",
                "<leader>fd",
                function()                                -- https://github.com/nvim-mini/mini.nvim/issues/513#issuecomment-1762785125
                    vim.cmd.execute([["normal! \<Esc>"]]) -- escape visual mode to update '< and '> marks
                    local prompt = require("utils").get_visual_selection()
                    vim.schedule(function() require("mini.pick").set_picker_query(vim.split(prompt, "")) end)
                    require("mini.pick").builtin.files()
                end,
            },
        },
        config = function()
            require("mini.icons").mock_nvim_web_devicons()
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
                require("mini.align").setup({ mappings = { start = "", start_with_preview = "gl" } }) -- p to remove gap before delimiter
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
