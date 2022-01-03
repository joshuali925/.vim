local M = {}
local g = vim.g
local fn = vim.fn

function M.project_nvim()
    require("project_nvim").setup {
        detection_methods = {"pattern", "lsp"},
        patterns = {".git", "gradlew", "Makefile", "package.json"}
    }
end

function M.nvim_autopairs()
    local npairs = require("nvim-autopairs")
    local cmp_npairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    npairs.setup {
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.%(%{%/] ]], "%s+", "")
    }
    cmp.event:on("confirm_done", cmp_npairs.on_confirm_done())
end

function M.vim_matchup()
    g.matchup_matchparen_offscreen = {}
    g.matchup_matchparen_deferred = 1
    g.matchup_matchparen_deferred_hide_delay = 300
    g.matchup_motion_override_Npercent = 0
end

function M.nvim_tree()
    g.nvim_tree_git_hl = 1
    g.nvim_tree_highlight_opened_files = 1
    local tree_cb = require("nvim-tree.config").nvim_tree_callback
    require("nvim-tree").setup {
        disable_netrw = false,
        diagnostics = {enable = true},
        view = {
            mappings = {
                list = {
                    {key = {"r"}, cb = tree_cb("refresh")},
                    {key = {"R"}, cb = tree_cb("rename")},
                    {key = {"?"}, cb = tree_cb("toggle_help")},
                    {key = {"C"}, cb = tree_cb("cd")},
                    {key = {"s"}, cb = tree_cb("split")},
                    {key = {"yy"}, cb = tree_cb("copy_absolute_path")},
                    {key = {"l"}, cb = tree_cb("edit")},
                    {key = {"h"}, cb = tree_cb("close_node")},
                    {key = {"-"}, cb = "<Cmd>normal! $<CR>"}
                }
            }
        }
    }
end

function M.gitsigns()
    require("gitsigns").setup {
        signs = {
            add = {text = "▎"},
            change = {text = "░"},
            delete = {text = "▏"},
            topdelete = {text = "▔"},
            changedelete = {text = "▒"}
        },
        keymaps = {
            ["n [g"] = '<Cmd>lua require("gitsigns").prev_hunk()<CR>',
            ["n ]g"] = '<Cmd>lua require("gitsigns").next_hunk()<CR>',
            ["o ig"] = ':<C-u>lua require("gitsigns.actions").select_hunk()<CR>',
            ["x ig"] = ':<C-u>lua require("gitsigns.actions").select_hunk()<CR>'
        },
        update_debounce = 150
    }
end

function M.kommentary()
    require("kommentary.config").configure_language(
        "typescriptreact",
        {
            hook_function = function()
                require("ts_context_commentstring.internal").update_commentstring()
            end
        }
    )
end

function M.rest_nvim()
    require("rest-nvim").setup({skip_ssl_verification = true})
    vim.cmd([[command! RestNvimPreviewCurl execute "normal \<Plug>RestNvimPreview" | sleep 100m | S 1,2messages]])
end

g.qs_filetype_blacklist = {
    "help",
    "man",
    "qf",
    "netrw",
    "packer",
    "alpha",
    "lsp-installer",
    "TelescopePrompt",
    "Mundo",
    "Outline",
    "NvimTree",
    "neoterm",
    "startuptime",
    "DiffviewFileHistory",
    "DiffviewFiles",
    "floggraph"
}
function M.quick_scope()
    g.qs_buftype_blacklist = {"terminal"}
    vim.cmd("highlight QuickScopePrimary guifg='" .. (g.theme_index < 0 and "#ffca6e" or "#bf8000") .. "'")
end

function M.mundo()
    g.mundo_preview_bottom = 1
    g.mundo_width = 30
end

function M.setup_neoterm()
    g.neoterm_default_mod = "belowright"
    g.neoterm_autoinsert = 1
end

function M.setup_csv_vim()
    g.csv_nomap_cr = 1
    g.csv_nomap_bs = 1
end

function M.neomake()
    g.neomake_info_sign = {text = "", texthl = "NeomakeInfoSign"}
    g.neomake_typescript_enabled_makers = {"eslint"}
    g.neomake_typescriptreact_enabled_makers = {"eslint"}
end

function M.setup_indent_blankline()
    -- TODO remove when this is fixed https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
    vim.opt.colorcolumn = "99999"
    g.indent_blankline_char = "▏"
    g.indent_blankline_show_first_indent_level = false
    g.indent_blankline_filetype_exclude = g.qs_filetype_blacklist
    g.indent_blankline_buftype_exclude = {"terminal"}
end

function M.setup_symbols_outline()
    g.symbols_outline = {
        auto_preview = false,
        relative_width = false,
        width = 30,
        keymaps = {close = "q", hover_symbol = "p", rename_symbol = "R"}
    }
end

function M.conflict_marker()
    g.conflict_marker_enable_mappings = 0
    g.conflict_marker_begin = "^<<<<<<< .*$"
    g.conflict_marker_end = "^>>>>>>> .*$"
    g.conflict_marker_highlight_group = ""
    if g.theme_index < 0 then
        vim.cmd [[
            highlight ConflictMarkerBegin guibg=#427266
            highlight ConflictMarkerOurs guibg=#364f49
            highlight ConflictMarkerTheirs guibg=#3a4f67
            highlight ConflictMarkerEnd guibg=#234a78
        ]]
    else
        vim.cmd [[
            highlight ConflictMarkerBegin guibg=#7ed9ae
            highlight ConflictMarkerOurs guibg=#94ffcc
            highlight ConflictMarkerTheirs guibg=#b9d1fa
            highlight ConflictMarkerEnd guibg=#86abeb
        ]]
    end
end

function M.setup_vim_table_mode()
    g.table_mode_tableize_map = ""
    g.table_mode_motion_left_map = "<leader>th"
    g.table_mode_motion_up_map = "<leader>tk"
    g.table_mode_motion_down_map = "<leader>tj"
    g.table_mode_motion_right_map = "<leader>tl"
    g.table_mode_corner = "|" -- markdown compatible tablemode
end

function M.setup_vim_visual_multi()
    g.VM_default_mappings = 0
    g.VM_exit_on_1_cursor_left = 1
    g.VM_maps = {
        -- <C-Down/Up> to add cursor
        ["Select All"] = "<leader><C-n>",
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Remove Last Region"] = "<C-p>",
        ["Skip Region"] = "<C-x>",
        ["Switch Mode"] = "<C-c>",
        ["Add Cursor At Pos"] = "g<C-n>",
        ["Select Operator"] = "v",
        ["Case Conversion Menu"] = "s"
    }
end

function M.nvim_bqf()
    require("bqf").setup {
        auto_resize_height = false,
        func_map = {
            prevfile = "",
            nextfile = "",
            pscrolldown = "J",
            pscrollup = "K",
            ptoggleitem = "P",
            ptoggleauto = "p"
        }
    }
end

function M.hop_nvim()
    require("hop").setup({})
    vim.cmd("highlight! link HopNextKey HopNextKey1")
    vim.cmd("highlight! link HopNextKey2 HopNextKey1")
end

function M.wilder_nvim()
    -- https://github.com/gelguy/wilder.nvim/issues/52
    vim.cmd [[
        call wilder#setup({'modes': [':']})
        call wilder#set_option('use_python_remote_plugin', 0)
        call wilder#set_option('pipeline', [
                \   wilder#branch(
                \     wilder#cmdline_pipeline({ 'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter(), 'debounce': 50 }),
                \   ),
                \ ])
        call wilder#set_option('renderer', wilder#renderer_mux({
                \ ':': wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
                \   'border': 'rounded',
                \   'empty_message': 0,
                \   'highlighter': wilder#lua_fzy_highlighter(),
                \   'highlights': { 'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}]) },
                \   'winblend': 8,
                \   'left': [' ', wilder#popupmenu_devicons()],
                \   'right': [' ', wilder#popupmenu_scrollbar()],
                \   'apply_incsearch_fix': 0,
                \ })),
                \ 'substitute': 0
                \ }))
    ]]
end

function M.alpha_nvim()
    local alpha = require("alpha")
    local theme = require("alpha.themes.startify")
    if g.theme_index < 0 then
        theme.section.header.val = {
            [[⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⣿⣿⣿⣿⣿⡿⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⣿⢧⣶⡉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ⢹⣿⣿⣿⣿⠃ ⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⡏⣼⣿⣿⠄⠈⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ⠘⠛⠛⠛⠛ ⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⠐⢋⣤⣤⢦⣤⡀   ⠈⠛⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⢁⠤⡀    ⡠⢄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⠏⣰⡾⠉  ⢸⡇  ⣀⣀⣀  ⣀⣀⣉⡉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣭⣭⣿⠃  ⠉     ⠈⠁ ⢩⣭⣭⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿ ⣿⣇⡀ ⢀⣸⡇⣰⠿⠉⠉⠉⣷⡄⢹⣿⢟⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠋   ⢀⣠⣤⣄⣤⣀⣀   ⠙⣿⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⡄⠈⠻⢿⣶⡿⠋⢸⣿    ⣿⡇⢘⣯⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟  ⢠⡴⠚⢿⣿⢛⣉⣻⣿⢟⡛⢦⡀ ⠈⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⣤⡀  ⢰⣦⠜⢿⣦⣤⣤⣾⠋⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟  ⣰⡯⠶⣿⠟⣛⢻⣿⣋⣙⣿⡿⠚⢿⣆ ⠘⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⣿⡿⠂ ⠈⠁  ⠉⠉⢉⣁⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ⢠⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿  ⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⡿⠁    ⠘⢶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ⢠⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⡇      ⠈⠛⠛⠛⠛⠙⢻⣿⣿⣿⢫⡒⡂⡠⠌⣽⣿⣿⣿⣿⣿⣿⣄⢸⣿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⢀⣾⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⣷⣤⣤⣀⣀⣀⣠⣤⣤⣤⣤⣤⣤⣿⣿⣿⣿⣄⣀⣂⣑⣥⣿⣿⣿⣿⣿⣿⣿⣿⣾⠃   ⠙⣿⣿⣿⣿⣿⠃   ⢸⣾⣿⣿⣿⣿⣿⣿]],
            [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠛⠁⠄⠂⠄⠄⡿⠿⠿⠿⠇⠄⠂⠄⠄⠾⠿⠿⣿⣿⣿⣿⣿]]
        }
    else
        theme.section.header.val = {
            [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
            [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
            [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
            [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
            [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
            [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]
        }
    end
    theme.section.top_buttons.val = {}
    theme.section.bottom_buttons.val = {
        theme.button("!", "Git diff unstaged", ":args `Git ls-files --modified` | Git difftool<CR>"),
        theme.button("+", "Git diff HEAD", ":DiffviewOpen<CR>"),
        theme.button(
            "*",
            "Git diff remote",
            ":execute 'DiffviewOpen '. trim(system('git rev-parse --abbrev-ref --symbolic-full-name @{u}')). '..HEAD'<CR>"
        ),
        theme.button("o", "Git log", ":Flog<CR>"),
        theme.button("\\", "Open quickui", ":call quickui#menu#open('normal')<CR>"),
        theme.button("f", "Find files", ":lua require('telescope.builtin').find_files({hidden = true})<CR>"),
        theme.button(
            "m",
            "Find MRU",
            ":lua require('telescope.builtin').oldfiles({include_current_session = true})<CR>"
        ),
        theme.button("c", "Edit vimrc", ":edit $MYVIMRC<CR>"),
        theme.button("s", "Profile startup time", ":StartupTime<CR>"),
        theme.button("E", "Load from previous session", ":silent LoadSession<CR>")
    }
    theme.mru_opts.ignore = function(path, ext)
        return string.find(path, "COMMIT_EDITMSG") or string.find(path, [[vim/.*/doc/.*%.txt]])
    end
    alpha.setup(theme.opts)
    -- https://github.com/goolord/alpha-nvim/issues/67
    vim.cmd [[
        augroup AlphaAutoCommands
            autocmd FileType alpha nnoremap <buffer> v <Cmd>lua require('alpha').queue_press()<CR>| nnoremap <buffer> <expr> q len(getbufinfo({'buflisted':1})) == 0 ? '<Cmd>quit<CR>' : '<Cmd>Bdelete<CR>'| nnoremap <buffer> e <Cmd>enew<CR>| nnoremap <buffer> i <Cmd>enew <bar> startinsert<CR>
        augroup END
    ]]
end

function M.telescope()
    local actions = require("telescope.actions")
    require("telescope").setup {
        defaults = {
            mappings = {
                i = {
                    ["<Esc>"] = actions.close,
                    ["<C-u>"] = function()
                        vim.cmd("stopinsert")
                    end
                }
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
                "--auto-hybrid-regex"
            },
            layout_strategy = "vertical",
            layout_config = {vertical = {preview_height = 0.3}},
            file_ignore_patterns = {".git/", "node_modules/", "venv/", "vim/.*/doc/.*%.txt"}
        },
        pickers = {
            file_browser = {theme = "dropdown"},
            filetypes = {theme = "dropdown"},
            registers = {theme = "dropdown"},
            commands = {theme = "dropdown"},
            builtin = {theme = "dropdown"}
        },
        extensions = {
            fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case"}
        }
    }
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("projects")
end

function M.nvim_treesitter()
    require("nvim-treesitter.configs").setup {
        ensure_installed = {
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
            "bash",
            "lua",
            "vim",
            "json",
            "yaml",
            "http",
            "python",
            "java"
        },
        highlight = {enable = true, disable = {}, use_languagetree = true},
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["if"] = "@function.inner",
                    ["af"] = "@function.outer",
                    ["ic"] = "@class.inner",
                    ["ac"] = "@class.outer"
                }
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {["]]"] = "@function.outer"},
                goto_next_end = {["]["] = "@function.outer"},
                goto_previous_start = {["[["] = "@function.outer"},
                goto_previous_end = {["[]"] = "@function.outer"}
            }
        },
        indent = {enable = true, disable = {"python", "java"}},
        context_commentstring = {enable = true, enable_autocmd = false}, -- for nvim-ts-context-commentstring
        matchup = {enable = true} -- for vim-matchup
    }
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
        t = colors.red
    }
    local function checkwidth(winid)
        return vim.api.nvim_win_get_width(winid) > 60
    end
    local components = {active = {{}, {}, {}}, inactive = {{}}}
    components.active[1][1] = {
        provider = "  ",
        hl = function()
            return {fg = colors.lightbg, bg = mode_colors[fn.mode()] or colors.primary}
        end,
        right_sep = {
            str = " ",
            hl = function()
                return {fg = mode_colors[fn.mode()] or colors.primary, bg = colors.lightbg}
            end
        }
    }
    components.active[1][2] = {
        provider = function()
            return " " .. fn.expand("%:~:.") .. " "
        end,
        icon = function()
            local icon, color = require("nvim-web-devicons").get_icon_color(fn.expand("%:t"), fn.expand("%:e"))
            return {str = icon or " ", hl = {fg = color or colors.primary}}
        end,
        hl = {fg = colors.fg, bg = colors.lightbg},
        right_sep = {str = " ", hl = {fg = colors.lightbg, bg = colors.lightbg2}}
    }
    components.active[1][3] = {
        provider = function()
            local dir_name = fn.fnamemodify(fn.getcwd(), ":t")
            return "  " .. dir_name .. " "
        end,
        hl = {fg = colors.grey, bg = colors.lightbg2},
        right_sep = {str = " ", hi = {fg = colors.lightbg2}}
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
            if #flags > 0 then
                return " " .. flags .. " "
            end
            return ""
        end,
        hl = {fg = colors.grey}
    }
    components.active[1][5] = {
        provider = "git_diff_added",
        enabled = checkwidth,
        hl = {fg = colors.grey},
        icon = "  "
    }
    components.active[1][6] = {
        provider = "git_diff_changed",
        enabled = checkwidth,
        hl = {fg = colors.grey},
        icon = "  "
    }
    components.active[1][7] = {
        provider = "git_diff_removed",
        enabled = checkwidth,
        hl = {fg = colors.grey},
        icon = "  "
    }
    components.active[1][8] = {
        provider = "diagnostic_errors",
        enabled = function()
            return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR)
        end,
        hl = {fg = colors.red},
        icon = "  "
    }
    components.active[1][9] = {
        provider = "diagnostic_warnings",
        enabled = function()
            return lsp.diagnostics_exist(vim.diagnostic.severity.WARN)
        end,
        hl = {fg = colors.yellow},
        icon = "  "
    }
    components.active[1][10] = {
        provider = "diagnostic_hints",
        enabled = function()
            return lsp.diagnostics_exist(vim.diagnostic.severity.HINT)
        end,
        hl = {fg = colors.grey},
        icon = "  "
    }
    components.active[1][11] = {
        provider = "diagnostic_info",
        enabled = function()
            return lsp.diagnostics_exist(vim.diagnostic.severity.INFO)
        end,
        hl = {fg = colors.secondary},
        icon = "  "
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
                local spinners = {"", "", "", ""}
                local ms = math.floor(vim.loop.hrtime() / 120000000) -- 120ms
                local frame = ms % #spinners
                return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
            end
            return ""
        end,
        enabled = checkwidth,
        hl = {fg = colors.secondary}
    }
    components.active[3][1] = {provider = "lsp_client_names", enabled = checkwidth, hl = {fg = colors.grey}}
    components.active[3][2] = {provider = " ", hl = {fg = colors.lightbg}}
    components.active[3][3] = {
        provider = "git_branch",
        enabled = checkwidth,
        hl = {fg = colors.grey, bg = colors.lightbg},
        icon = " "
    }
    components.active[3][4] = {provider = " ", hl = {fg = colors.primary, bg = colors.lightbg}}
    components.active[3][5] = {
        provider = function()
            return g.untildone_count == 0 and " " or "ﯩ "
        end,
        hl = {fg = colors.lightbg, bg = colors.primary}
    }
    components.active[3][6] = {
        provider = function()
            local col = fn.col(".")
            return (col < 10 and "  " or " ") .. col
        end,
        hl = {fg = colors.secondary, bg = colors.lightbg}
    }
    components.active[3][7] = {
        provider = function()
            return string.format(" %s/%s", fn.line("."), fn.line("$"))
        end,
        hl = {fg = colors.primary, bg = colors.lightbg}
    }
    components.inactive[1][1] = {
        provider = "  ",
        hl = {fg = colors.lightbg, bg = colors.dim_primary},
        right_sep = {str = " ", hl = {fg = colors.dim_primary, bg = colors.lightbg}}
    }
    components.inactive[1][2] = components.active[1][2]
    require("feline").setup({theme = {fg = colors.fg, bg = colors.bg}, components = components})
end

function M.nvim_cmp()
    local cmp = require("cmp")
    cmp.setup {
        snippet = {
            expand = function(args)
                fn["vsnip#anonymous"](args.body)
            end
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
                vim_item.menu =
                    ({
                    buffer = "[Buffer]",
                    nvim_lua = "[Lua]",
                    nvim_lsp = "[LSP]",
                    vsnip = "[Vsnip]"
                })[entry.source.name]
                return vim_item
            end
        },
        mapping = {
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif fn.call("vsnip#jumpable", {1}) == 1 then
                        fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "")
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            ),
            ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif fn.call("vsnip#jumpable", {-1}) == 1 then
                        fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "")
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            )
        },
        sources = {{name = "buffer"}, {name = "path"}, {name = "nvim_lua"}, {name = "nvim_lsp"}, {name = "vsnip"}}
    }
end

function _G.quickui_context_menu()
    local content = {
        {"Docu&mentation", "lua vim.lsp.buf.hover()", "Show documentation"},
        {"&Signautre", "lua vim.lsp.buf.signature_help()", "Show function signature help"},
        {"Implementation", "lua vim.lsp.buf.implementation()", "Go to implementation"},
        {"Declaration", "lua vim.lsp.buf.declaration()", "Go to declaration"},
        {"Type definition", "lua vim.lsp.buf.type_definition()", "Go to type definition"},
        {
            "Hover diagnostic",
            "lua vim.lsp.diagnostic.show_line_diagnostics({border='rounded'})",
            "Show diagnostic of current line"
        },
        {"--", ""},
        {"Git hunk &diff", "lua require('gitsigns').preview_hunk()", "Git preview hunk"},
        {"Git hunk &undo", "lua require('gitsigns').reset_hunk()", "Git undo hunk"},
        {"Git hunk &add", "lua require('gitsigns').stage_hunk()", "Git stage hunk"},
        {"Git hunk reset", "lua require('gitsigns').undo_stage_hunk()", "Git undo stage hunk"},
        {"Git &blame", "lua require('gitsigns').blame_line({full = true})", "Git blame of current line"},
        {
            "Git &remote",
            [[execute "lua require('packer').loader('vim-rhubarb vim-fugitive')" | if $SSH_CLIENT == "" | .GBrowse | else | let @x=split(execute(".GBrowse!"), "\n")[-1] | execute "OSCYankReg x" | endif]],
            "Open remote url in browser, or copy to clipboard if over ssh"
        },
        {"--", ""}
    }
    local conflict_state = fn["funcs#get_conflict_state"]()
    if conflict_state ~= "" then
        table.insert(
            content,
            {"Git &conflict get", "ConflictMarker" .. conflict_state, "Get change from " .. conflict_state}
        )
        table.insert(content, {"Git conflict get all", "ConflictMarkerBoth", "Get change from both"})
        table.insert(content, {"Git conflict remove", "ConflictMarkerNone", "Remove conflict"})
        table.insert(content, {"--", ""})
    end
    table.insert(content, {"Built-in d&ocs", 'execute "normal! K"', "Open vim built in help"})
    fn["quickui#context#open"](content, {index = g["quickui#context#cursor"] or -1})
end

function M.setup_vim_quickui()
    g.quickui_color_scheme = g.theme_index < 0 and "papercol-dark" or "papercol-light"
    g.quickui_show_tip = 1
    g.quickui_border_style = 2
end

function M.vim_quickui()
    fn["quickui#menu#switch"]("normal")
    fn["quickui#menu#reset"]()
    fn["quickui#menu#install"](
        "&Actions",
        {
            {
                "Insert line",
                [[execute "lua require('packer').loader('kommentary')" | execute "normal! o\<Space>\<BS>\<Esc>55a=" | execute "normal \<Plug>kommentary_line_default"]],
                "Insert a dividing line"
            },
            {"Insert time", [[put=strftime('%x %X')]], "Insert MM/dd/yyyy hh:mm:ss tt"},
            {"&Trim spaces", [[keeppatterns %s/\s\+$//e | silent! execute "normal! ``"]], "Remove trailing spaces"},
            {
                "Re&indent",
                [[let g:temp = getcurpos() | Sleuth | execute "normal! gg=G" | call setpos('.', g:temp)]],
                "Recalculate indent with Sleuth and reindent whole file"
            },
            {"Ded&up lines", [[%!awk '\!x[$0]++']], "Remove duplicated lines and preserve order"},
            {
                "Calculate line &=",
                [[let @x = getline(".")[max([0, matchend(getline("."), ".*=")]):] | execute "normal! A = \<C-r>=\<C-r>x\<CR>"]],
                'Calculate expression from previous "=" or current line'
            },
            {"--", ""},
            {"&Word count", [[call feedkeys("g\<C-g>")]], "Show document details"},
            {
                "Cou&nt occurrences",
                [[keeppatterns %s///gn | silent! execute "normal! ``"]],
                "Count occurrences of current search pattern"
            },
            {
                "Search in &buffers",
                [[execute "cexpr [] | bufdo vimgrepadd //g %" | copen]],
                "Grep current search pattern in all buffers, add to quickfix"
            },
            {
                "&Diff unsaved",
                [[execute "diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype=". &filetype. " | read ++edit # | 0d_ | diffthis"]],
                "Diff current buffer with file on disk (similar to DiffOrig command)"
            },
            {"--", ""},
            {"Move tab left &-", [[-tabmove]]},
            {"Move tab right &+", [[+tabmove]]},
            {
                "&Refresh screen",
                [[execute "ColorizerAttachToBuffer" | execute "nohlsearch | syntax sync fromstart | diffupdate | let @/=\"QWQ\" | normal! \<C-l>"]],
                "Clear search, refresh screen and colorizer"
            },
            {"--", ""},
            {"Open &Alpha", [[execute "lua require('packer').loader('alpha-nvim', true)" | Alpha]], "Open Alpha"},
            {"Save session", [[SaveSession]], "Save session to .cache/nvim/session.vim, will overwrite"},
            {"Load session", [[LoadSession]], "Load session from .cache/nvim/session.vim"},
            {"--", ""},
            {"Edit Vimr&c", [[edit $MYVIMRC]]},
            {
                "Open in &VSCode",
                [[execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!]]
            }
        }
    )
    fn["quickui#menu#install"](
        "&Git",
        {
            {"Git &status", [[Git]], "Git status"},
            {"Git checko&ut file", [[Gread]], "Checkout current file and load as unsaved buffer"},
            {"Git &blame", [[Git blame]], "Git blame of current file"},
            {"Git &diff", [[Gdiffsplit]], "Diff current file with last staged version"},
            {"Git diff H&EAD", [[Gdiffsplit HEAD]], "Diff current file with last committed version"},
            {
                "Git &file history",
                [[vsplit | execute "lua require('packer').loader('vim-fugitive')" | 0Gclog]],
                "Browse previously committed versions of current file"
            },
            {
                "Diffview file history",
                [[DiffviewFileHistory -f -a]],
                "Browse previously committed versions of current file with Diffview"
            },
            {"--", ""},
            {"Git &changes", [[Git! difftool]], "Load unstaged changes of files into quickfix"},
            {
                "Git Diff&view",
                [[DiffviewOpen]],
                "Diff files with HEAD, use :DiffviewOpen ref..ref<CR> to speficy commits"
            },
            {"Git l&og", [[Flog]], "Show git logs with vim-flog"},
            {
                "Git search &all",
                [[call feedkeys(":Git log --all --full-history --name-status -S \"\"\<Left>", "n")]],
                'Search a string in all committed versions of files, command: git log -p --all -S "<pattern>" --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>'
            },
            {
                "Git gre&p all",
                [[call feedkeys(":Git log --all --full-history --name-status -i -G \"\"\<Left>", "n")]],
                'Search a regex in all committed versions of files, command: git log -p --all -i -G "<pattern>" --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>'
            },
            {
                "Git fi&nd files all",
                [[call feedkeys(":Git log --all --full-history --name-status -- \"**\"\<Left>\<Left>", "n")]],
                "Grep file names in all commits"
            },
            {"--", ""},
            {"Git &root", [[Grt]], "Change current directory to git root"}
        }
    )
    fn["quickui#menu#install"](
        "&Toggle",
        {
            {
                'Quickfix             %{empty(filter(getwininfo(), "v:val.quickfix")) ? "[ ]" : "[x]"}',
                [[execute empty(filter(getwininfo(), "v:val.quickfix")) ? "copen" : "cclose"]]
            },
            {
                'Location list        %{empty(filter(getwininfo(), "v:val.loclist")) ? "[ ]" : "[x]"}',
                [[execute empty(filter(getwininfo(), "v:val.loclist")) ? "lopen" : "lclose"]]
            },
            {
                'Set &diff             %{&diff ? "[x]" : "[ ]"}',
                [[execute &diff ? "windo diffoff" : "windo diffthis"]],
                "Toggle diff in current window"
            },
            {
                'Set scr&ollbind       %{&scrollbind ? "[x]" : "[ ]"}',
                [[execute &scrollbind ? "windo set noscrollbind" : "windo set scrollbind"]],
                "Toggle scrollbind in current window"
            },
            {'Set &wrap             %{&wrap ? "[x]" : "[ ]"}', [[set wrap!]], "Toggle wrap lines"},
            {
                'Set &paste            %{&paste ? "[x]" : "[ ]"}',
                [[execute &paste ? "set nopaste number mouse=a signcolumn=yes" : "set paste nonumber norelativenumber mouse= signcolumn=no"]],
                "Toggle paste mode (shift alt drag to select and copy)"
            },
            {
                'Set &spelling         %{&spell ? "[x]" : "[ ]"}',
                [[set spell!]],
                "Toggle spell checker (z= to auto correct current word)"
            },
            {
                'Set &virtualedit      %{&virtualedit=~#"all" ? "[x]" : "[ ]"}',
                [[execute &virtualedit=~#"all" ? "set virtualedit-=all" : "set virtualedit+=all"]],
                "Toggle virtualedit"
            },
            {
                'Set previ&ew          %{&completeopt=~"preview" ? "[x]" : "[ ]"}',
                [[execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"]],
                "Toggle function preview"
            },
            {'Set &cursorline       %{&cursorline ? "[x]" : "[ ]"}', [[set cursorline!]], "Toggle cursorline"},
            {'Set cursorcol&umn     %{&cursorcolumn ? "[x]" : "[ ]"}', [[set cursorcolumn!]], "Toggle cursorcolumn"},
            {
                'Set light &background %{&background=~"light" ? "[x]" : "[ ]"}',
                [[let &background = &background=="dark" ? "light" : "dark"]],
                "Toggle background color"
            },
            {"--", ""},
            {"Toggle wilder", [[call wilder#toggle()]], "Toggle wilder.nvim command line completion"}
        }
    )
    fn["quickui#menu#install"](
        "Ta&bles",
        {
            {"Table &mode", [[TableModeToggle]], "Toggle TableMode"},
            {"&Reformat table", [[TableModeRealign]], "Reformat table"},
            {"&Format to table", [[Tableize]], "Format to table, use <leader>T to set delimiter"},
            {"Delete row", [[execute "normal \<Plug>(table-mode-delete-row)"]], "Delete row"},
            {"Delete column", [[execute "normal \<Plug>(table-mode-delete-column)"]], "Delete column"},
            {"Show cell &position", [[execute "normal \<Plug>(table-mode-echo-cell)"]], "Show cell index number"},
            {"--", ""},
            {"&Add formula", [[TableAddFormula]], "Add formula to current cell, i.e. Sum(r1,c1:r2,c2)"},
            {"&Evaluate formula", [[TableEvalFormulaLine]], "Evaluate formula"},
            {"--", ""},
            {"Align using = (delimiter fixed)", [[Tabularize /=\zs]], [[Tabularize /=\zs]]},
            {"Align using , (delimiter fixed)", [[Tabularize /,\zs]], [[Tabularize /,\zs]]},
            {"Align using # (delimiter fixed)", [[Tabularize /\#\zs]], [[Tabularize /\#\zs]]},
            {"Align using : (delimiter fixed)", [[Tabularize /:\zs]], [[Tabularize /:\zs]]},
            {"--", ""},
            {"Align using = (delimiter aligned)", [[Tabularize /=]], "Tabularize /="},
            {"Align using , (delimiter aligned)", [[Tabularize /,]], "Tabularize /,"},
            {"Align using # (delimiter aligned)", [[Tabularize /\#]], "Tabularize /\\#"},
            {"Align using : (delimiter aligned)", [[Tabularize /:]], "Tabularize /:"},
            {"--", ""},
            {"&CSV show column", [[CSVWhatColumn!]], "Show column title under cursor"},
            {
                "CSV arrange column",
                [[execute "lua require('packer').loader('csv.vim')" | 1,$CSVArrangeColumn!]],
                "Align csv columns"
            },
            {
                "CSV to table",
                [[execute "lua require('packer').loader('csv.vim')" | CSVTabularize]],
                "Convert csv to table"
            }
        }
    )
    fn["quickui#menu#install"](
        "L&SP",
        {
            {
                "Workspace &diagnostics",
                [[call v:lua.quickfix_all_diagnostics() | copen]],
                "Show workspace diagnostics in quickfix"
            },
            {
                "Workspace warnings and errors",
                [[call v:lua.quickfix_all_diagnostics(2) | copen]],
                "Show workspace diagnostics with severity >= 2 in quickfix"
            },
            {
                "Document diagnostics",
                [[lua vim.lsp.diagnostic.setloclist()]],
                "Show current file diagnostics in quickfix"
            },
            {"&Toggle diagnostics", [[call v:lua.toggle_diagnostics()]], "Toggle lsp diagnostics"},
            {"--", ""},
            {
                "&Show folders in workspace",
                [[lua vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))]],
                "Show folders in workspace for LSP"
            },
            {
                "Add folder to workspace",
                [[lua vim.lsp.buf.add_workspace_folder()]],
                "Add folder to workspace for LSP"
            },
            {
                "Remove folder from workspace",
                [[lua vim.lsp.buf.remove_workspace_folder()]],
                "Remove folder from workspace for LSP"
            }
        }
    )
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
            table.insert(quickui_theme_list, {"--", ""})
            category = "(Light) "
        end
        local hint_pos = vim.regex("\\c[^" .. used_chars .. "]"):match_str(theme)
        local display = theme
        if hint_pos ~= nil then
            used_chars = used_chars .. theme:sub(hint_pos + 1, hint_pos + 1)
            display = theme:sub(1, hint_pos) .. "&" .. theme:sub(hint_pos + 1)
        end
        table.insert(
            quickui_theme_list,
            {
                category .. display,
                ([[execute 'call writefile(["vim.g.theme_index = %s"], "%s/lua/current-theme.lua")' | lua vim.notify("Restart nvim to change to %s")]]):format(
                    index,
                    fn.stdpath("config"),
                    theme
                )
            }
        )
    end
    fn["quickui#menu#install"]("&Colors", quickui_theme_list)
    fn["quickui#menu#switch"]("visual")
    fn["quickui#menu#reset"]()
    fn["quickui#menu#install"](
        "&Actions",
        {
            {"OSC &yank", [[OSCYank]], "Use ANSI OSC52 sequence to copy from remote SSH sessions"}
        }
    )
    fn["quickui#menu#install"](
        "&Git",
        {
            {"Git &file history", [[vsplit | '<,'>Gclog]], "Browse previously committed versions of selected range"},
            {
                "Git l&og",
                [[execute "lua require('packer').loader('vim-flog')" | '<,'>Flogsplit]],
                "Show git log of selected range with vim-flog"
            },
            {"--", ""},
            {
                "Git open &remote",
                [[execute "lua require('packer').loader('vim-rhubarb vim-fugitive')" | if $SSH_CLIENT == "1" | '<,'>GBrowse | else | let @x=split(execute("'<,'>GBrowse!"), "\n")[-1] | execute "OSCYankReg x" | endif]],
                "Open remote url in browser"
            }
        }
    )
    fn["quickui#menu#install"](
        "Ta&bles",
        {
            {"Reformat table", [['<,'>TableModeRealign]], "Reformat table"},
            {"Format to table", [['<,'>Tableize]], "Format to table, use <leader>T to set delimiter"},
            {"--", ""},
            {"Align using = (delimiter fixed)", [['<,'>Tabularize /=\zs]], "'<,'>Tabularize /=\\zs"},
            {"Align using , (delimiter fixed)", [['<,'>Tabularize /,\zs]], "'<,'>Tabularize /,\\zs"},
            {"Align using # (delimiter fixed)", [['<,'>Tabularize /\#\zs]], "'<,'>Tabularize /\\#\\zs"},
            {"Align using : (delimiter fixed)", [['<,'>Tabularize /:\zs]], "'<,'>Tabularize /:\\zs"},
            {"--", ""},
            {"Align using = (delimiter aligned)", [['<,'>Tabularize /=]], "'<,'>Tabularize /="},
            {"Align using , (delimiter aligned)", [['<,'>Tabularize /,]], "'<,'>Tabularize /,"},
            {"Align using # (delimiter aligned)", [['<,'>Tabularize /\#]], "'<,'>Tabularize /\\#"},
            {"Align using : (delimiter aligned)", [['<,'>Tabularize /:]], "'<,'>Tabularize /:"},
            {"--", ""},
            {"Sort asc", [['<,'>sort]], "Sort in ascending order (sort)"},
            {"Sort desc", [['<,'>sort!]], "Sort in descending order (sort!)"},
            {"Sort num asc", [['<,'>sort n]], "Sort numerically in ascending order (sort n)"},
            {"Sort num desc", [['<,'>sort! n]], "Sort numerically in descending order (sort! n)"}
        }
    )
end

return M
