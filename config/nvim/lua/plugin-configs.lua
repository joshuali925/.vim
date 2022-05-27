local M = {}

function M.nvim_autopairs()
    require("nvim-autopairs").setup({ ignored_next_char = [=[[%w%%%'%[%"%.%(%{%/]]=] })
    require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
end

function M.bufferline_nvim()
    require("bufferline").setup({
        -- options = { offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory" } } }, -- taking too much space
        highlights = { buffer_selected = { gui = "bold" } },
    })
end

function M.gitsigns()
    require("gitsigns").setup({
        signs = {
            add = { text = "▎" },
            change = { text = "░" },
            delete = { text = "▏" },
            topdelete = { text = "▔" },
            changedelete = { text = "▒" },
        },
        keymaps = {
            ["n [g"] = "<Cmd>lua require('gitsigns').prev_hunk()<CR>",
            ["n ]g"] = "<Cmd>lua require('gitsigns').next_hunk()<CR>",
            ["o ig"] = ":<C-u>lua require('gitsigns.actions').select_hunk()<CR>",
            ["x ig"] = ":<C-u>lua require('gitsigns.actions').select_hunk()<CR>",
        },
        update_debounce = 250,
        sign_priority = 11,
    })
end

function M.kommentary()
    require("kommentary.config").configure_language("default", {
        hook_function = function()
            require("ts_context_commentstring.internal").update_commentstring()
        end,
    })
    require("kommentary.config").configure_language("lua", { prefer_single_line_comments = true })
end

function M.rest_nvim()
    require("rest-nvim").setup({ skip_ssl_verification = true })
    vim.api.nvim_create_user_command("RestNvimPreviewCurl", [[execute "normal \<Plug>RestNvimPreview" | sleep 100m | S 1,2messages]], {})
end

vim.g.qs_filetype_blacklist = {
    "help",
    "man",
    "qf",
    "netrw",
    "packer",
    "alpha",
    "lsp-installer",
    "TelescopePrompt",
    "Mundo",
    "aerial",
    "NvimTree",
    "startuptime",
    "DiffviewFileHistory",
    "DiffviewFiles",
    "floggraph",
    "fugitiveblame",
} -- will only run on first require
vim.g.qs_buftype_blacklist = { "terminal" }
function M.quick_scope()
    local function highlight_quickscope()
        vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = vim.g.theme_index < 0 and "#ffbe6d" or "#bf8000" })
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = vim.g.theme_index < 0 and "#6eb9e6" or "#005e7d" })
    end

    vim.g.qs_hi_priority = -1
    vim.api.nvim_create_augroup("QuickScopeHighlight", {})
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", group = "QuickScopeHighlight", callback = highlight_quickscope })
    highlight_quickscope()
end

function M.mundo()
    vim.g.mundo_preview_bottom = 1
    vim.g.mundo_width = 30
end

function M.setup_markdown_preview_nvim()
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_preview_options = { disable_sync_scroll = 1 }
end

function M.setup_neoterm()
    vim.g.neoterm_default_mod = "belowright"
    vim.g.neoterm_automap_keys = ";tT"
    vim.g.neoterm_autoinsert = 1
    vim.g.neoterm_repl_command = {} -- bug?
end

function M.setup_csv_vim()
    vim.g.csv_nomap_cr = 1
    vim.g.csv_nomap_bs = 1
end

function M.indent_blankline()
    require("indent_blankline").setup({
        char = "▏",
        show_first_indent_level = false,
        filetype_exclude = vim.g.qs_filetype_blacklist,
        buftype_exclude = vim.g.qs_buftype_blacklist,
    })
end

function M.aerial_nvim()
    require("aerial").setup({
        filter_kind = {
            "Class",
            "Constant",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },
    })
end

function M.conflict_marker()
    vim.g.conflict_marker_enable_mappings = 0
    vim.g.conflict_marker_begin = "^<<<<<<< .*$"
    vim.g.conflict_marker_end = "^>>>>>>> .*$"
    vim.g.conflict_marker_highlight_group = ""
    if vim.g.theme_index < 0 then
        vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { bg = "#427266" })
        vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { bg = "#364f49" })
        vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { bg = "#3a4f67" })
        vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { bg = "#234a78" })
    else
        vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { bg = "#7ed9ae" })
        vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { bg = "#94ffcc" })
        vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { bg = "#b9d1fa" })
        vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { bg = "#86abeb" })
    end
end

function M.setup_vim_table_mode()
    vim.g.table_mode_tableize_map = ""
    vim.g.table_mode_motion_left_map = "<leader>th"
    vim.g.table_mode_motion_up_map = "<leader>tk"
    vim.g.table_mode_motion_down_map = "<leader>tj"
    vim.g.table_mode_motion_right_map = "<leader>tl"
    vim.g.table_mode_corner = "|" -- markdown compatible tablemode
end

function M.setup_vim_visual_multi()
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
        ["Add Cursor At Pos"] = "g<C-n>",
        ["Select Operator"] = "v",
        ["Case Conversion Menu"] = "s",
    }
    vim.api.nvim_create_augroup("VisualMultiRemapBS", {}) -- for nvim_autopairs: https://github.com/mg979/vim-visual-multi/issues/172
    vim.api.nvim_create_autocmd("User", {
        pattern = "visual_multi_exit",
        group = "VisualMultiRemapBS",
        callback = function() vim.keymap.set("i", "<BS>", "v:lua.MPairs.autopairs_bs(" .. vim.fn.bufnr() .. ")", { buffer = true, expr = true }) end,
    })
end

function M.nvim_bqf()
    require("bqf").setup({
        func_map = {
            prevfile = "",
            nextfile = "",
            pscrolldown = ",",
            pscrollup = ".",
            ptoggleitem = "P",
            ptoggleauto = "p",
        },
    })
end

function M.hop_nvim()
    require("hop").setup({})
    vim.api.nvim_set_hl(0, "HopNextKey", { link = "HopNextKey1" })
    vim.api.nvim_set_hl(0, "HopNextKey2", { link = "HopNextKey1" })
end

function M.nvim_neoclip_lua()
    -- persistent history needs libsqlite3
    --     requires = { "tami5/sqlite.lua", module = "sqlite" },
    require("neoclip").setup({
        -- enable_persistent_history = true,
        content_spec_column = true,
        on_paste = { set_reg = true },
        keys = { telescope = { n = { select = "y", paste = "<CR>", replay = "Q" } } },
    })
end

function M.alpha_nvim()
    local theme = require("alpha.themes.startify")
    theme.section.header.val = {
        [[    ⢀⣀⣀⡀          ⣀⣀⣀                       ⢀⣀⣀⡀                      ⣤⣤    ]],
        [[    ⣿⣿⣿⣿⣷⣄      ⣰⣿⠟⠛⢿⣷⡄                    ⣼⣿⠟⠛⠟                      ⣿⣿    ]],
        [[⢠   ⠙⠻⠿⢿⣿⣿⡆    ⢰⣿⡏   ⣿⣷⢸⣿⣴⠿⣿⣧ ⢠⣾⠟⢿⣦⡀⢸⣷⡼⠿⣿⣦ ⢿⣿⣄   ⣴⣿⠿⣿⣦ ⠰⠿⠿⢿⣷⡀⣿⣧⡾⠿⢠⣾⡿⠿⠇⣿⣿⡾⠿⣿⣦]],
        [[⣿⣶⣄⡀    ⠈⠻⡇ ⣶  ⢸⣿⡇   ⣿⣿⢸⣿⡇ ⢸⣿⡇⣿⣿⣤⣬⣿⡇⢸⣿⠁ ⢹⣿ ⠈⠛⢿⣷⣆⢰⣿⣧⣤⣼⣿⡇⢀⣤⣤⣼⣿⡇⣿⣿  ⣿⣿   ⣿⣿  ⣿⣿]],
        [[⠸⣿⣿⣿⣿⣷⣦    ⢀⡏  ⠈⣿⣧  ⢀⣿⡏⢸⣿⡇ ⢸⣿⡇⣿⣿⠉⠉⠉⠁⢸⣿  ⢸⣿    ⣻⣿⠸⣿⣏⠉⠉⠉⢱⣿⡟⠁⢸⣿⡇⣿⣿  ⣿⣿   ⣿⣿  ⣿⣿]],
        [[ ⠈⠻⢿⣿⡿⠏   ⣠⠟    ⠘⠿⣿⣾⡿⠟⠁⢸⣿⡟⢶⣿⠟ ⠘⠿⣷⣶⡾ ⠸⠿  ⠸⠿ ⠿⣷⣾⡿⠏ ⠙⢿⣶⣶⠾⠈⢿⣿⡶⠛⠿⠇⠿⠿  ⠘⠿⣷⣶⠇⠿⠿  ⠿⠿]],
        [[     ⣀⣀⣠⡴⠞⠁            ⢸⣿⡇                                                  ]],
        [[     ⠉⠁                ⠘⠛⠃                                                  ]],
    }
    theme.section.top_buttons.val = {}
    theme.section.bottom_buttons.val = {
        theme.button("!", "Git unstaged changes", ":args `Git ls-files --modified` | Git difftool<CR>"),
        theme.button("+", "Git diff HEAD", ":DiffviewOpen<CR>"),
        theme.button("*", "Git diff remote", ":execute 'DiffviewOpen @{upstream}..HEAD'<CR>"),
        theme.button("o", "Git log", ":Flog<CR>"),
        theme.button("\\", "Open quickui", ":call quickui#menu#open('normal')<CR>"),
        theme.button("f", "Find files", ":lua require('telescope.builtin').find_files({hidden = true})<CR>"),
        theme.button("m", "Find MRU", ":lua require('telescope.builtin').oldfiles()<CR>"),
        theme.button("c", "Edit vimrc", ":edit $MYVIMRC<CR>"),
        theme.button("s", "Profile startup time", ":StartupTime<CR>"),
        theme.button("E", "Load from previous session", ":silent SessionLoad<CR>"),
    }
    theme.mru_opts.ignore = function(path, ext)
        return string.find(path, "vim/.*/doc/.*%.txt") or string.find(path, "/.git/")
    end
    require("alpha").setup(theme.config)
    vim.api.nvim_create_augroup("AlphaAutoCommands", {})
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        group = "AlphaAutoCommands",
        callback = function()
            vim.b.RestoredCursor = 1 -- do not restore cursor position
            vim.keymap.set("n", "v", require("alpha").queue_press, { buffer = true }) -- TODO https://github.com/goolord/alpha-nvim/issues/92
            vim.keymap.set("n", "q", "len(getbufinfo({'buflisted':1})) == 0 ? '<Cmd>quit<CR>' : '<Cmd>Bdelete<CR>'", { buffer = true, expr = true })
            vim.keymap.set("n", "e", "<Cmd>enew<CR>", { buffer = true })
            vim.keymap.set("n", "i", "<Cmd>enew <bar> startinsert<CR>", { buffer = true })
        end,
    })
end

function M.nvim_tree()
    local tree_cb = require("nvim-tree.config").nvim_tree_callback
    require("nvim-tree").setup({
        hijack_cursor = true,
        hijack_netrw = false,
        git = { ignore = false },
        actions = { open_file = { resize_window = false } },
        renderer = { highlight_git = true },
        view = {
            mappings = {
                list = {
                    { key = { "?" }, cb = tree_cb("toggle_help") },
                    { key = { "i" }, cb = tree_cb("toggle_ignored") },
                    { key = { "r" }, cb = tree_cb("refresh") },
                    { key = { "R" }, cb = tree_cb("rename") },
                    { key = { "x" }, cb = tree_cb("remove") },
                    { key = { "d" }, cb = tree_cb("cut") },
                    { key = { "y" }, cb = tree_cb("copy") },
                    { key = { "yy" }, cb = tree_cb("copy_absolute_path") },
                    { key = { "C" }, cb = tree_cb("cd") },
                    { key = { "s" }, cb = tree_cb("split") },
                    { key = { "h" }, cb = tree_cb("close_node") },
                    { key = { "l" }, cb = tree_cb("edit") },
                    { key = { "zM" }, cb = tree_cb("collapse_all") },
                    { key = { "zR" }, cb = tree_cb("expand_all") },
                    { key = { "[g" }, cb = tree_cb("prev_git_item") },
                    { key = { "]g" }, cb = tree_cb("next_git_item") },
                    { key = { "q" }, cb = "<Cmd>execute 'NvimTreeResize '. winwidth(0) <bar> NvimTreeClose<CR>" },
                    { key = { "<Left>" }, cb = "<Cmd>normal! zh<CR>" },
                    { key = { "<Right>" }, cb = "<Cmd>normal! zl<CR>" },
                    { key = { "H" }, cb = "<Cmd>normal! H<CR>" },
                    { key = { "-" }, cb = "<Cmd>normal! $<CR>" },
                },
            },
        },
    })
end

function M.telescope()
    local actions = require("telescope.actions")
    -- TODO https://github.com/nvim-telescope/telescope.nvim/issues/416
    require("telescope").setup({
        defaults = {
            mappings = {
                n = {
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    [","] = actions.preview_scrolling_down,
                    ["."] = actions.preview_scrolling_up,
                    ["o"] = actions.select_default,
                    ["q"] = actions.close,
                },
                i = {
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<Esc>"] = actions.close,
                    ["<C-u>"] = function() vim.cmd("stopinsert") end,
                },
            },
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--auto-hybrid-regex",
            },
            prompt_prefix = "   ",
            selection_caret = "  ",
            layout_strategy = "vertical",
            layout_config = { vertical = { preview_height = 0.3 } },
            file_ignore_patterns = { ".git/", "node_modules/", "venv/", "vim/.*/doc/.*%.txt" },
            dynamic_preview_title = true,
        },
        pickers = {
            filetypes = { theme = "dropdown" },
            registers = { theme = "dropdown" },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    })
    require("telescope").load_extension("fzf")
end

function M.nvim_treesitter()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "lua",
            "vim",
            "json",
            "yaml",
            "markdown",
            "bash",
            "http",
            "html", -- TODO https://github.com/nvim-treesitter/nvim-treesitter/issues/1788
            "css",
            "javascript",
            "typescript",
            "tsx",
            "python",
            "java",
        },
        highlight = { enable = true, disable = {} },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["if"] = "@function.inner",
                    ["af"] = "@function.outer",
                    ["ic"] = "@class.inner",
                    ["ac"] = "@class.outer",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = { ["]]"] = "@function.outer" },
                goto_next_end = { ["]["] = "@function.outer" },
                goto_previous_start = { ["[["] = "@function.outer" },
                goto_previous_end = { ["[]"] = "@function.outer" },
            },
        },
        indent = { enable = true, disable = { "python", "java" } },
        context_commentstring = { enable = true, enable_autocmd = false }, -- for nvim-ts-context-commentstring
    })
end

function M.feline_nvim()
    local lsp = require("feline.providers.lsp")
    local colors = require("themes").colors()
    local mode_colors = {
        n = colors.primary,
        i = colors.secondary,
        v = colors.purple,
        V = colors.purple,
        [string.char(22)] = colors.purple, -- ^V
        c = colors.yellow,
        s = colors.orange,
        S = colors.orange,
        [string.char(19)] = colors.orange, -- ^S
        R = colors.orange,
        Rv = colors.orange,
        t = colors.red,
    }
    local function checkwidth() return vim.api.nvim_win_get_width(0) > 60 end

    local components = { active = { {}, {}, {} }, inactive = { {}, {}, {} } }
    components.active[1][1] = {
        provider = "  ",
        hl = function() return { fg = colors.lightbg, bg = mode_colors[vim.fn.mode()] or colors.primary } end,
        right_sep = { str = " ", hl = function() return { fg = mode_colors[vim.fn.mode()] or colors.primary, bg = colors.lightbg } end },
    }
    components.active[1][2] = {
        provider = function() return " " .. vim.fn.expand("%:~:.") .. " " end,
        icon = function()
            local icon, color = require("nvim-web-devicons").get_icon_color(vim.fn.expand("%:t"), vim.fn.expand("%:e"))
            return { str = icon or " ", hl = { fg = color or colors.primary } }
        end,
        hl = { fg = colors.fg, bg = colors.lightbg },
        right_sep = { str = " ", hl = { fg = colors.lightbg, bg = colors.lightbg2 } },
    }
    components.active[1][3] = {
        provider = function() return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " " end,
        hl = { fg = colors.grey, bg = colors.lightbg2 },
        right_sep = { str = " ", hi = { fg = colors.lightbg2 } },
    }
    components.active[1][4] = {
        provider = function()
            local flags = ""
            if vim.o.readonly then
                flags = flags .. "[RO]"
            end
            if vim.o.paste then
                flags = flags .. "[paste]"
            end
            if vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8" then
                flags = flags .. "[fenc: " .. vim.bo.fileencoding .. "]"
            end
            if vim.bo.fileformat ~= "unix" then
                flags = flags .. "[ff: " .. vim.bo.fileformat .. "]"
            end
            if #flags > 0 then
                return " " .. flags .. " "
            end
            return ""
        end,
        hl = { fg = colors.grey },
    }
    components.active[1][5] = {
        provider = "git_diff_added",
        enabled = checkwidth,
        hl = { fg = colors.grey },
        icon = "  ",
    }
    components.active[1][6] = {
        provider = "git_diff_changed",
        enabled = checkwidth,
        hl = { fg = colors.grey },
        icon = "  ",
    }
    components.active[1][7] = {
        provider = "git_diff_removed",
        enabled = checkwidth,
        hl = { fg = colors.grey },
        icon = "  ",
    }
    components.active[1][8] = {
        provider = "diagnostic_errors",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR) end,
        hl = { fg = colors.red },
        icon = "  ",
    }
    components.active[1][9] = {
        provider = "diagnostic_warnings",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.WARN) end,
        hl = { fg = colors.yellow },
        icon = "  ",
    }
    components.active[1][10] = {
        provider = "diagnostic_hints",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.HINT) end,
        hl = { fg = colors.grey },
        icon = "  ",
    }
    components.active[1][11] = {
        provider = "diagnostic_info",
        enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.INFO) end,
        hl = { fg = colors.secondary },
        icon = "  ",
    }
    components.active[2][1] = {
        provider = function()
            local lsp_progress = vim.lsp.util.get_progress_messages()[1]
            if lsp_progress then
                local title = lsp_progress.title or ""
                local percentage = lsp_progress.percentage or 0
                local msg = lsp_progress.message or ""
                if percentage > 70 then
                    return string.format(" %%<%s %s %s (%s%%%%) ", "", title, msg, percentage)
                end
                local spinners = { "", "", "", "" }
                local ms = math.floor(vim.loop.hrtime() / 120000000) -- 120ms
                local frame = ms % #spinners
                return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
            end
            return ""
        end,
        enabled = checkwidth,
        hl = { fg = colors.secondary },
    }
    components.active[3][1] = { provider = "lsp_client_names", enabled = checkwidth, hl = { fg = colors.grey } }
    components.active[3][2] = { provider = " ", hl = { fg = colors.lightbg } }
    components.active[3][3] = {
        provider = "git_branch",
        enabled = checkwidth,
        hl = { fg = colors.grey, bg = colors.lightbg },
        icon = " ",
    }
    components.active[3][4] = { provider = " ", hl = { fg = colors.primary, bg = colors.lightbg } }
    components.active[3][5] = {
        provider = function()
            local untildone_count = require("states").untildone_count
            if untildone_count > 0 then
                return untildone_count == 1 and "ﯩ " or untildone_count .. " "
            else
                return " "
            end
        end,
        hl = { fg = colors.lightbg, bg = colors.primary },
    }
    components.active[3][6] = {
        provider = function()
            local col = vim.fn.col(".")
            return (col < 10 and "  " or " ") .. col
        end,
        hl = { fg = colors.secondary, bg = colors.lightbg },
    }
    components.active[3][7] = {
        provider = function() return string.format(" %s/%s", vim.fn.line("."), vim.fn.line("$")) end,
        hl = { fg = colors.primary, bg = colors.lightbg },
    }
    components.inactive[1][1] = {
        provider = "  ",
        hl = { fg = colors.lightbg, bg = colors.dim_primary },
        right_sep = { str = " ", hl = { fg = colors.dim_primary, bg = colors.lightbg } },
    }
    components.inactive[1][2] = components.active[1][2]
    components.inactive[3][1] = {
        provider = function() return string.format("%s/%s", vim.fn.line("."), vim.fn.line("$")) end,
        hl = { fg = colors.dim_primary },
    }
    require("feline").setup({ theme = { fg = colors.fg, bg = colors.bg }, components = components })
end

function M.nvim_cmp()
    local cmp = require("cmp")
    -- vim.o.pumblend = 8
    -- local cmp_kinds = {
    --     Text = "", Method = "", Function = "", Constructor = "", Field = "ﰠ",
    --     Variable = "", Class = "ﴯ", Interface = "", Module = "", Property = "ﰠ",
    --     Unit = "塞", Value = "", Enum = "", Keyword = "", Snippet = "",
    --     Color = "", File = "", Reference = "", Folder = "", EnumMember = "",
    --     Constant = "", Struct = "פּ", Event = "", Operator = "", TypeParameter = "",
    -- }
    local cmp_kinds = { -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-codicons-to-the-menu
        Text = " ", Method = " ", Function = " ", Constructor = " ", Field = " ",
        Variable = " ", Class = " ", Interface = " ", Module = " ", Property = " ",
        Unit = " ", Value = " ", Enum = " ", Keyword = " ", Snippet = " ",
        Color = " ", File = " ", Reference = " ", Folder = " ", EnumMember = " ",
        Constant = " ", Struct = " ", Event = " ", Operator = " ", TypeParameter = " ",
    }
    cmp.setup({
        completion = { completeopt = "menuone,noselect" },
        snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
        window = { completion = cmp.config.window.bordered({ border = "single" }), documentation = cmp.config.window.bordered({ border = "single" }) },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(_, vim_item)
                vim_item.menu = vim_item.kind
                vim_item.kind = cmp_kinds[vim_item.kind] or ""
                return vim_item
            end,
        },
        mapping = {
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-k>"] = cmp.mapping(function(fallback)
                if vim.fn.call("vsnip#jumpable", { 1 }) == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "")
                elseif require("neogen").jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Cmd>lua require('neogen').jump_next()<CR>", true, true, true), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<Down>"] = cmp.mapping.select_next_item({ behavior = require("cmp.types").cmp.SelectBehavior.Select }),
            ["<Up>"] = cmp.mapping.select_prev_item({ behavior = require("cmp.types").cmp.SelectBehavior.Select }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn.call("vsnip#jumpable", { 1 }) == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "")
                elseif require("neogen").jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Cmd>lua require('neogen').jump_next()<CR>", true, true, true), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "")
                elseif require("neogen").jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Cmd>lua require('neogen').jump_prev()<CR>", true, true, true), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "vsnip" },
            { name = "path" },
            { name = "nvim_lua" },
            {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        local buffers = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            buffers[vim.api.nvim_win_get_buf(win)] = true -- visible buffers only
                        end
                        return vim.tbl_filter(function(buffer)
                            return vim.api.nvim_buf_get_offset(buffer, vim.api.nvim_buf_line_count(buffer)) < 1048576 -- 1MB
                        end, vim.tbl_keys(buffers))
                    end
                }
            },
        },
    })
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } })
    })
end

function M.open_quickui_context_menu()
    local content = {
        { "Docu&mentation", "lua vim.lsp.buf.hover()", "Show documentation" },
        { "&Signautre", "lua vim.lsp.buf.signature_help()", "Show function signature help" },
        { "Implementation", "lua vim.lsp.buf.implementation()", "Go to implementation" },
        { "Declaration", "lua vim.lsp.buf.declaration()", "Go to declaration" },
        { "Type definition", "lua vim.lsp.buf.type_definition()", "Go to type definition" },
        { "Hover diagnostic", "lua vim.diagnostic.open_float(0, {scope = 'line', border = 'single'})", "Show diagnostic of current line" },
        { "G&enerate doc", "lua require('neogen').generate()", "Generate annotations with neogen" },
        { "--", "" },
        { "Git hunk &diff", "lua require('gitsigns').preview_hunk()", "Git preview hunk" },
        { "Git hunk &undo", "lua require('gitsigns').reset_hunk()", "Git undo hunk" },
        { "Git hunk &add", "lua require('gitsigns').stage_hunk()", "Git stage hunk" },
        { "Git hunk reset", "lua require('gitsigns').undo_stage_hunk()", "Git undo stage hunk" },
        { "Git buffer reset", "lua require('gitsigns').reset_buffer_index()", "Git reset buffer index" },
        { "Git &blame", "lua require('gitsigns').blame_line({full = true})", "Git blame of current line" },
        { "Git &remote", [[execute "lua require('packer').loader('vim-rhubarb vim-fugitive')" | if $SSH_CLIENT == "" | .GBrowse | else | let @x=split(execute(".GBrowse!"), "\n")[-1] | execute "OSCYankReg x" | endif]], "Open remote url in browser, or copy to clipboard if over ssh" },
        { "--", "" },
    }
    local conflict_state = vim.fn["funcs#get_conflict_state"]()
    if conflict_state ~= "" then
        table.insert(content, { "Git &conflict get", "ConflictMarker" .. conflict_state, "Get change from " .. conflict_state })
        table.insert(content, { "Git conflict get all", "ConflictMarkerBoth", "Get change from both" })
        table.insert(content, { "Git conflict remove", "ConflictMarkerNone", "Remove conflict" })
        table.insert(content, { "--", "" })
    end
    table.insert(content, { "Built-in d&ocs", 'execute "normal! K"', "Open vim built in help" })
    vim.fn["quickui#context#open"](content, { index = vim.g["quickui#context#cursor"] or -1 })
end

function M.setup_vim_quickui()
    vim.g.quickui_color_scheme = vim.g.theme_index < 0 and "papercol-dark" or "papercol-light"
    vim.g.quickui_show_tip = 1
    vim.g.quickui_border_style = 2
end

function M.vim_quickui()
    vim.fn["quickui#menu#switch"]("normal")
    vim.fn["quickui#menu#reset"]()
    vim.fn["quickui#menu#install"]("&Actions", {
        { "Insert line", [[execute "lua require('packer').loader('kommentary')" | execute "normal! o\<Space>\<BS>\<Esc>55a=" | execute "normal \<Plug>kommentary_line_default"]], "Insert a dividing line" },
        { "Insert time", [[put=strftime('%x %X')]], "Insert MM/dd/yyyy hh:mm:ss tt" },
        { "&Trim spaces", [[keeppatterns %s/\s\+$//e | silent! execute "normal! ``"]], "Remove trailing spaces" },
        { "Re&indent", [[let g:temp = getcurpos() | Sleuth | execute "normal! gg=G" | call setpos('.', g:temp)]], "Recalculate indent with Sleuth and reindent whole file" },
        { "Ded&up lines", [[%!awk '\!x[$0]++']], "Remove duplicated lines and preserve order" },
        { "Du&plicated lines", [[sort | let @/ = '\C^\(.*\)$\n\1$' | set hlsearch]], "Sort and show duplicated lines" },
        { "Calculate line &=", [[let @x = getline(".")[max([0, matchend(getline("."), ".*=")]):] | execute "normal! A = \<C-r>=\<C-r>x\<CR>"]], 'Calculate expression from previous "=" or current line' },
        { "--", "" },
        { "&Word count", [[call feedkeys("g\<C-g>")]], "Show document details" },
        { "Cou&nt occurrences", [[keeppatterns %s///gn | silent! execute "normal! ``"]], "Count occurrences of current search pattern (:%s/pattern//gn)" },
        { "Search in &buffers", [[execute "cexpr [] | bufdo vimgrepadd //g %" | copen]], "Grep current search pattern in all buffers, add to quickfix" },
        { "&Diff unsaved", [[execute "diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype=". &filetype. " | read ++edit # | 0d_ | diffthis"]], "Diff current buffer with file on disk (similar to DiffOrig command)" },
        { "--", "" },
        { "Move tab left &-", [[-tabmove]] },
        { "Move tab right &+", [[+tabmove]] },
        { "&Refresh screen", [[execute "ScrollViewRefresh | ColorizerAttachToBuffer" | execute "nohlsearch | syntax sync fromstart | diffupdate | let @/=\"QWQ\" | normal! \<C-l>"]], "Clear search, refresh screen, scrollbar and colorizer" },
        { "--", "" },
        { "Open &Alpha", [[execute "lua require('packer').loader('alpha-nvim', true)" | Alpha]], "Open Alpha" },
        { "Save session", [[SessionSave]], "Save session to .cache/nvim/session.vim, will overwrite" },
        { "Load session", [[SessionLoad]], "Load session from .cache/nvim/session.vim" },
        { "--", "" },
        { "Edit Vimr&c", [[edit $MYVIMRC]] },
        { "Open in &VSCode", [[execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!]] },
    })
    vim.fn["quickui#menu#install"]("&Git", {
        { "Git checko&ut", [[Gread]], "Checkout current file from index and load as unsaved buffer (Gread)" },
        { "Git checkout HEAD", [[Gread HEAD:%]], "Checkout current file from HEAD and load as unsaved buffer (Gread HEAD:%)" },
        { "Git &blame", [[Git blame]], "Git blame of current file" },
        { "Git &toggle deleted", [[lua require("gitsigns").toggle_deleted()]], "Show deleted lines with gitsigns" },
        { "Git &diff", [[Gdiffsplit]], "Diff current file with last staged version (Gdiffsplit)" },
        { "Git diff H&EAD", [[Gdiffsplit HEAD]], "Diff current file with last committed version (Gdiffsplit HEAD)" },
        { "Git &file history", [[vsplit | execute "lua require('packer').loader('vim-fugitive')" | 0Gclog]], "Browse previously committed versions of current file" },
        { "Diffview file history", [[DiffviewFileHistory -f -a]], "Browse previously committed versions of current file (DiffviewFileHistory -f -a)" },
        { "--", "" },
        { "Git &status", [[Git]], "Git status" },
        { "Git unstaged &changes", [[Git! difftool]], "Load unstaged changes into quickfix (Git! difftool)" },
        { "Git HEAD changes", [[Git! difftool HEAD]], "Load changes from HEAD into quickfix (Git! difftool HEAD)" },
        { "Diff&view HEAD", [[DiffviewOpen]], "Diff files with HEAD, use :DiffviewOpen ref..ref<CR> to speficy commits" },
        { "Git l&og", [[Flog]], "Show git logs with vim-flog" },
        { "--", "" },
        { "Git search &all", [[call feedkeys(":Git log --all --full-history --name-status -S \"\"\<Left>", "n")]], 'Search a string in all committed versions of files, command: git log -p --all -S "<pattern>" --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>' },
        { "Git gre&p all", [[call feedkeys(":Git log --all --full-history --name-status -i -G \"\"\<Left>", "n")]], 'Search a regex in all committed versions of files, command: git log -p --all -i -G "<pattern>" --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>' },
        { "Git fi&nd files all", [[call feedkeys(":Git log --all --full-history --name-status -- \"**\"\<Left>\<Left>", "n")]], "Grep file names in all commits" },
        { "Git root", [[Grt]], "Change current directory to git root" },
        { "Cd current file", [[if expand("%") == '' | cd $PWD | else | cd %:p:h | endif]], "Change current directory to current file" },
    })
    vim.fn["quickui#menu#install"]("&Toggle", {
        { 'Quickfix             %{empty(filter(getwininfo(), "v:val.quickfix")) ? "[ ]" : "[x]"}', [[execute empty(filter(getwininfo(), "v:val.quickfix")) ? "copen" : "cclose"]] },
        { 'Location list        %{empty(filter(getwininfo(), "v:val.loclist")) ? "[ ]" : "[x]"}', [[execute empty(filter(getwininfo(), "v:val.loclist")) ? "lopen" : "lclose"]] },
        { 'Set &diff             %{&diff ? "[x]" : "[ ]"}', [[execute &diff ? "windo diffoff" : "windo diffthis"]], "Toggle diff in current window" },
        { 'Set scr&ollbind       %{&scrollbind ? "[x]" : "[ ]"}', [[execute &scrollbind ? "windo set noscrollbind" : "windo set scrollbind"]], "Toggle scrollbind in current window" },
        { 'Set &wrap             %{&wrap ? "[x]" : "[ ]"}', [[set wrap!]], "Toggle wrap lines" },
        { 'Set &paste            %{&paste ? "[x]" : "[ ]"}', [[execute &paste ? "set nopaste number mouse=a signcolumn=yes" : "set paste nonumber norelativenumber mouse= signcolumn=no"]], "Toggle paste mode (shift alt drag to select and copy)" },
        { 'Set &spelling         %{&spell ? "[x]" : "[ ]"}', [[set spell!]], "Toggle spell checker (z= to auto correct current word)" },
        { 'Set &virtualedit      %{&virtualedit=~#"all" ? "[x]" : "[ ]"}', [[execute &virtualedit=~#"all" ? "set virtualedit-=all" : "set virtualedit+=all"]], "Toggle virtualedit" },
        { 'Set previ&ew          %{&completeopt=~"preview" ? "[x]" : "[ ]"}', [[execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"]], "Toggle function preview" },
        { 'Set &cursorline       %{&cursorline ? "[x]" : "[ ]"}', [[set cursorline!]], "Toggle cursorline" },
        { 'Set cursorcol&umn     %{&cursorcolumn ? "[x]" : "[ ]"}', [[set cursorcolumn!]], "Toggle cursorcolumn" },
        { 'Set light &background %{&background=~"light" ? "[x]" : "[ ]"}', [[let &background = &background=="dark" ? "light" : "dark"]], "Toggle background color" },
        { "--", "" },
        { "Rooter", [[lua require("rooter").toggle()]], "Toggle automatically change root directory" },
    })
    vim.fn["quickui#menu#install"]("Ta&bles", {
        { "Table &mode", [[TableModeToggle]], "Toggle TableMode" },
        { "&Reformat table", [[TableModeRealign]], "Reformat table" },
        { "&Format to table", [[Tableize]], "Format to table, use <leader>T to set delimiter" },
        { "Delete row", [[execute "normal \<Plug>(table-mode-delete-row)"]], "Delete row" },
        { "Delete column", [[execute "normal \<Plug>(table-mode-delete-column)"]], "Delete column" },
        { "Show cell &position", [[execute "normal \<Plug>(table-mode-echo-cell)"]], "Show cell index number" },
        { "--", "" },
        { "&Add formula", [[TableAddFormula]], "Add formula to current cell, i.e. Sum(r1,c1:r2,c2)" },
        { "&Evaluate formula", [[TableEvalFormulaLine]], "Evaluate formula" },
        { "--", "" },
        { "Align using = (delimiter fixed)", [[Tabularize /=\zs]], [[Tabularize /=\zs]] },
        { "Align using , (delimiter fixed)", [[Tabularize /,\zs]], [[Tabularize /,\zs]] },
        { "Align using # (delimiter fixed)", [[Tabularize /\#\zs]], [[Tabularize /\#\zs]] },
        { "Align using : (delimiter fixed)", [[Tabularize /:\zs]], [[Tabularize /:\zs]] },
        { "--", "" },
        { "Align using = (delimiter aligned)", [[Tabularize /=]], "Tabularize /=" },
        { "Align using , (delimiter aligned)", [[Tabularize /,]], "Tabularize /," },
        { "Align using # (delimiter aligned)", [[Tabularize /\#]], "Tabularize /\\#" },
        { "Align using : (delimiter aligned)", [[Tabularize /:]], "Tabularize /:" },
        { "--", "" },
        { "&CSV show column", [[CSVWhatColumn!]], "Show column title under cursor" },
        { "CSV arrange column", [[execute "lua require('packer').loader('csv.vim')" | 1,$CSVArrangeColumn!]], "Align csv columns" },
        { "CSV to table", [[execute "lua require('packer').loader('csv.vim')" | CSVTabularize]], "Convert csv to table" },
    })
    vim.fn["quickui#menu#install"]("L&SP", {
        { "Workspace &diagnostics", [[lua require("lsp").quickfix_all_diagnostics()]], "Show workspace diagnostics in quickfix" },
        { "Workspace warnings and errors", [[lua require("lsp").quickfix_all_diagnostics(vim.diagnostic.severity.WARN)]], "Show workspace warnings and errors in quickfix" },
        { "&Toggle diagnostics", [[lua require("lsp").toggle_diagnostics()]], "Toggle lsp diagnostics" },
        { "--", "" },
        { "&Show folders in workspace", [[lua vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))]], "Show folders in workspace for LSP" },
        { "Add folder to workspace", [[lua vim.lsp.buf.add_workspace_folder()]], "Add folder to workspace for LSP" },
        { "Remove folder from workspace", [[lua vim.lsp.buf.remove_workspace_folder()]], "Remove folder from workspace for LSP" },
    })
    local quickui_theme_list = {}
    local used_chars = "hjklqg"
    local category = "(Dark) "
    local theme_list = require("themes").theme_list
    local keys = {}
    for index in pairs(theme_list) do
        table.insert(keys, index)
    end
    table.sort(keys)
    local len_negative = math.abs(keys[1])
    for i = 1, len_negative / 2 do -- reverse negative keys
        keys[i], keys[len_negative - i + 1] = keys[len_negative - i + 1], keys[i]
    end
    for _, index in ipairs(keys) do
        local theme = theme_list[index]
        if index == 0 then
            table.insert(quickui_theme_list, { "--", "" })
            category = "(Light) "
        end
        local hint_pos = vim.regex("\\c[^" .. used_chars .. "]"):match_str(theme)
        local display = theme
        if hint_pos ~= nil then
            used_chars = used_chars .. theme:sub(hint_pos + 1, hint_pos + 1)
            display = theme:sub(1, hint_pos) .. "&" .. theme:sub(hint_pos + 1)
        end
        table.insert(quickui_theme_list, { category .. display, string.format("lua require('themes').switch(%s)", index) })
    end
    vim.fn["quickui#menu#install"]("&Colors", quickui_theme_list)
    vim.fn["quickui#menu#switch"]("visual")
    vim.fn["quickui#menu#reset"]()
    vim.fn["quickui#menu#install"]("&Actions", {
        { "OSC &yank", [[OSCYank]], "Use ANSI OSC52 sequence to copy from remote SSH sessions" },
        { "Base64 &encode", [[let @x = system('base64 | tr -d "\r\n"', funcs#get_visual_selection()) | S put x]], "Use base64 to encode selected text" },
        { "Base64 &decode", [[let @x = system('base64 --decode', funcs#get_visual_selection()) | S put x]], "Use base64 to decode selected text" },
    })
    vim.fn["quickui#menu#install"]("&Git", {
        { "Git &file history", [[vsplit | '<,'>Gclog]], "Browse previously committed versions of selected range" },
        { "Git l&og", [[execute "lua require('packer').loader('vim-flog')" | '<,'>Flogsplit]], "Show git log of selected range with vim-flog" },
        { "--", "" },
        { "Git open &remote", [[execute "lua require('packer').loader('vim-rhubarb vim-fugitive')" | if $SSH_CLIENT == "1" | '<,'>GBrowse | else | let @x=split(execute("'<,'>GBrowse!"), "\n")[-1] | execute "OSCYankReg x" | endif]], "Open remote url in browser" },
    })
    vim.fn["quickui#menu#install"]("Ta&bles", {
        { "Reformat table", [['<,'>TableModeRealign]], "Reformat table" },
        { "Format to table", [['<,'>Tableize]], "Format to table, use <leader>T to set delimiter" },
        { "--", "" },
        { "Align using = (delimiter fixed)", [['<,'>Tabularize /=\zs]], "'<,'>Tabularize /=\\zs" },
        { "Align using , (delimiter fixed)", [['<,'>Tabularize /,\zs]], "'<,'>Tabularize /,\\zs" },
        { "Align using # (delimiter fixed)", [['<,'>Tabularize /\#\zs]], "'<,'>Tabularize /\\#\\zs" },
        { "Align using : (delimiter fixed)", [['<,'>Tabularize /:\zs]], "'<,'>Tabularize /:\\zs" },
        { "--", "" },
        { "Align using = (delimiter aligned)", [['<,'>Tabularize /=]], "'<,'>Tabularize /=" },
        { "Align using , (delimiter aligned)", [['<,'>Tabularize /,]], "'<,'>Tabularize /," },
        { "Align using # (delimiter aligned)", [['<,'>Tabularize /\#]], "'<,'>Tabularize /\\#" },
        { "Align using : (delimiter aligned)", [['<,'>Tabularize /:]], "'<,'>Tabularize /:" },
        { "--", "" },
        { "Sort asc", [['<,'>sort]], "Sort in ascending order (sort)" },
        { "Sort desc", [['<,'>sort!]], "Sort in descending order (sort!)" },
        { "Sort num asc", [['<,'>sort n]], "Sort numerically in ascending order (sort n)" },
        { "Sort num desc", [['<,'>sort! n]], "Sort numerically in descending order (sort! n)" },
    })
end

return M
