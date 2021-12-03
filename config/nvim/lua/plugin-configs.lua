local M = {}
local g = vim.g

function M.tokyonight()
    g.tokyonight_italic_keywords = false
    g.tokyonight_italic_comments = false
    g.tokyonight_sidebars = {"qf", "terminal", "Outline", "Mundo"}
    g.tokyonight_colors = {comment = "#717993"}
    vim.cmd("colorscheme tokyonight")
end

function M.filetype_nvim()
    require("filetype").setup {
        overrides = {
            extensions = {
                ejs = "html"
            }
        }
    }
end

function M.nvim_autopairs()
    local npairs = require("nvim-autopairs")
    local cmp_npairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    npairs.setup {
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.%(%{] ]], "%s+", "")
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
                    {key = {"h"}, cb = tree_cb("close_node")}
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
            noremap = true,
            ["n [g"] = {'<Cmd>lua require("gitsigns").prev_hunk()<CR>'},
            ["n ]g"] = {'<Cmd>lua require("gitsigns").next_hunk()<CR>'},
            ["o ig"] = ':<C-u>lua require("gitsigns.actions").select_hunk()<CR>',
            ["x ig"] = ':<C-u>lua require("gitsigns.actions").select_hunk()<CR>'
        },
        watch_index = {
            interval = 250
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

function M.nvim_miniyank()
    g.miniyank_maxitems = 200
    g.miniyank_filename = os.getenv("HOME") .. "/.cache/nvim/.miniyank.mpack"
end

function M.setup_vim_sandwich()
    g.sandwich_no_default_key_mappings = 1
    g.operator_sandwich_no_default_key_mappings = 1
end

function M.quick_scope()
    g.qs_filetype_blacklist = {
        "qf",
        "netrw",
        "startify",
        "TelescopePrompt",
        "Mundo",
        "Outline",
        "NvimTree",
        "neoterm",
        "DiffviewFileHistory",
        "DiffviewFiles",
        "floggraph"
    }
    g.qs_buftype_blacklist = {"terminal"}
    vim.cmd("highlight QuickScopePrimary guifg='#ffe9c2'")
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
    g.neomake_typescript_enabled_makers = {"eslint", "tsc"}
    g.neomake_typescriptreact_enabled_makers = {"eslint", "tsc"}
end

function M.setup_indent_blankline()
    -- TODO remove when this is fixed https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
    vim.opt.colorcolumn = "99999"
    g.indent_blankline_char = "▏"
    g.indent_blankline_show_first_indent_level = false
    g.indent_blankline_filetype_exclude = {"help", "man", "startify", "lsp-installer"}
    g.indent_blankline_buftype_exclude = {"terminal"}
end

function M.setup_symbols_outline()
    vim.g.symbols_outline = {
        auto_preview = false,
        relative_width = false,
        width = 30,
        keymaps = {
            close = "q",
            hover_symbol = "p",
            rename_symbol = "R"
        }
    }
end

function M.tmux_nvim()
    require("tmux").setup {
        navigation = {
            cycle_navigation = false
        }
    }
end

function M.conflict_marker()
    g.conflict_marker_enable_mappings = 0
    g.conflict_marker_begin = "^<<<<<<< .*$"
    g.conflict_marker_end = "^>>>>>>> .*$"
    g.conflict_marker_highlight_group = ""
    vim.cmd [[
        highlight ConflictMarkerBegin guibg=#427266
        highlight ConflictMarkerOurs guibg=#364f49
        highlight ConflictMarkerTheirs guibg=#3a4f67
        highlight ConflictMarkerEnd guibg=#234a78
    ]]
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
    require("bqf").setup(
        {
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
    )
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
                "--hidden"
            },
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    preview_height = 0.3
                }
            },
            file_ignore_patterns = {".git/", "node_modules/", "venv/"}
        },
        pickers = {
            file_browser = {theme = "dropdown"},
            filetypes = {theme = "dropdown"},
            registers = {theme = "dropdown"},
            commands = {theme = "dropdown"},
            builtin = {theme = "dropdown"}
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case"
            }
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
            "python"
        },
        highlight = {
            enable = true,
            disable = {},
            use_languagetree = true
        },
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
                goto_next_start = {
                    ["]]"] = "@function.outer"
                },
                goto_next_end = {
                    ["]["] = "@function.outer"
                },
                goto_previous_start = {
                    ["[["] = "@function.outer"
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer"
                }
            }
        },
        indent = {
            enable = true,
            disable = {"python"}
        },
        -- for nvim-ts-context-commentstring
        context_commentstring = {
            enable = true,
            enable_autocmd = false
        },
        -- for vim-matchup
        matchup = {
            enable = true
        }
    }
end

function M.galaxyline()
    local gl = require("galaxyline")
    local gls = gl.section
    local condition = require("galaxyline.condition")
    local fileinfo = require("galaxyline.providers.fileinfo")
    gl.short_line_list = {"NvimTree"}
    local colors = {
        bg = "#22262e",
        fg = "#abb2bf",
        green = "#9ece6a",
        red = "#f7768e",
        lightbg = "#2d3139",
        lightbg2 = "#262a32",
        blue = "#7aa2f7",
        darkblue = "#46617a",
        yellow = "#e0af68",
        orange = "#ff9e64",
        purple = "#9d7cd8",
        grey = "#6f737b"
    }
    local function checkwidth()
        return vim.fn.winwidth(0) > 60
    end
    gls.left[1] = {
        ViMode = {
            provider = function()
                local mode_color = {
                    n = colors.blue,
                    i = colors.green,
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
                local color = mode_color[vim.fn.mode()] or colors.blue
                vim.api.nvim_command("highlight GalaxyViMode guibg=" .. color)
                vim.api.nvim_command("highlight GalaxyViModeSeparator guifg=" .. color)
                return "   "
            end,
            highlight = {colors.lightbg, "GalaxyViMode"}
        }
    }
    gls.left[2] = {
        ViModeSeparator = {
            provider = function()
                return "  "
            end,
            highlight = {"GalaxyViModeSeparator", colors.lightbg}
        }
    }
    gls.left[3] = {
        FileIcon = {
            provider = "FileIcon",
            condition = condition.buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.lightbg}
        }
    }
    gls.left[4] = {
        FileName = {
            -- TODO update when https://github.com/glepnir/galaxyline.nvim/pull/154 is merged
            provider = function()
                return vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.") .. " "
            end,
            condition = condition.buffer_not_empty,
            highlight = {colors.fg, colors.lightbg},
            separator = " ",
            separator_highlight = {colors.lightbg, colors.lightbg2}
        }
    }
    gls.left[5] = {
        CurrentDir = {
            provider = function()
                local dir_name = vim.fn.fnamemodify(vim.loop.cwd(), ":t")
                return "  " .. dir_name .. " "
            end,
            highlight = {colors.grey, colors.lightbg2},
            separator = " ",
            separator_highlight = {colors.lightbg2, colors.bg}
        }
    }
    gls.left[6] = {
        FileFlags = {
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
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.left[7] = {
        DiffAdd = {
            provider = "DiffAdd",
            condition = checkwidth,
            icon = "  ",
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.left[8] = {
        DiffModified = {
            provider = "DiffModified",
            condition = checkwidth,
            icon = "  ",
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.left[9] = {
        DiffRemove = {
            provider = "DiffRemove",
            condition = checkwidth,
            icon = "  ",
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.left[10] = {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = "  ",
            highlight = {colors.red, colors.bg}
        }
    }
    gls.left[11] = {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = "  ",
            highlight = {colors.yellow, colors.bg}
        }
    }
    gls.right[1] = {
        LspStatus = {
            provider = function()
                local clients = vim.lsp.buf_get_clients()
                if next(clients) ~= nil then
                    return "  " .. " active "
                else
                    return ""
                end
            end,
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.right[2] = {
        GitIcon = {
            provider = function()
                return " "
            end,
            highlight = {colors.grey, colors.lightbg},
            separator = "",
            separator_highlight = {colors.lightbg, colors.bg}
        }
    }
    gls.right[3] = {
        GitBranch = {
            provider = "GitBranch",
            highlight = {colors.grey, colors.lightbg}
        }
    }
    gls.right[4] = {
        PosIcon = {
            provider = function()
                return " "
            end,
            separator = " ",
            separator_highlight = {colors.blue, colors.lightbg},
            highlight = {colors.lightbg, colors.blue}
        }
    }
    gls.right[5] = {
        ColumnPos = {
            provider = function()
                local col = vim.fn.col(".")
                local padding = col < 10 and " " or ""
                return "  " .. padding .. col
            end,
            highlight = {colors.green, colors.lightbg}
        }
    }
    gls.right[6] = {
        LinePos = {
            provider = function()
                return "  " .. vim.fn.line(".") .. "/" .. vim.fn.line("$")
            end,
            highlight = {colors.blue, colors.lightbg}
        }
    }
    gls.short_line_left[1] = {
        Inactive = {
            provider = function()
                return "   "
            end,
            highlight = {colors.lightbg, colors.darkblue},
            separator = "  ",
            separator_highlight = {colors.darkblue, colors.lightbg}
        }
    }
    gls.short_line_left[2] = gls.left[3]
    gls.short_line_left[3] = gls.left[4]
end

function M.startify()
    function _G.webDevIcons(path)
        local filename = vim.fn.fnamemodify(path, ":t")
        local extension = vim.fn.fnamemodify(path, ":e")
        return require("nvim-web-devicons").get_icon(filename, extension, {default = true})
    end
    vim.cmd [[
        function! StartifyEntryFormat() abort
            return 'v:lua.webDevIcons(absolute_path). " ". entry_path'
        endfunction
    ]]
    g.startify_session_dir = "~/.cache/nvim/sessions"
    g.startify_enable_special = 0
    g.startify_fortune_use_unicode = 1
    g.startify_commands = {
        {["!"] = {"Git diff unstaged", ":args `Git ls-files --modified` | Git difftool"}},
        {["+"] = {"Git diff HEAD", "DiffviewOpen"}},
        {
            ["*"] = {
                "Git diff remote",
                "execute 'DiffviewOpen '. trim(system('git rev-parse --abbrev-ref --symbolic-full-name @{u}')). '..HEAD'"
            }
        },
        {o = {"Git log", "Flog"}},
        {["\\"] = {"Open quickui", "call quickui#menu#open('normal')"}},
        {f = {"Find files", "lua require('telescope.builtin').find_files({hidden = true})"}},
        {m = {"Find MRU", "lua require('telescope.builtin').oldfiles({include_current_session = true})"}},
        {c = {"Edit vimrc", "edit $MYVIMRC"}},
        {s = {"Profile startup time", "StartupTime"}},
        {D = {"Delete session", "SDelete!"}}
    }
    g.startify_lists = {
        {type = "files", header = {"   MRU"}},
        {type = "dir", header = {"   MRU " .. vim.loop.cwd()}},
        {type = "commands", header = {"   Commands"}},
        {type = "sessions", header = {"   Sessions"}}
    }
end

function M.nvim_cmp()
    local cmp = require("cmp")
    cmp.setup {
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
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
                    elseif vim.fn.call("vsnip#jumpable", {1}) == 1 then
                        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "")
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
                    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
                        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "")
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            )
        },
        sources = {
            {name = "buffer"},
            {name = "path"},
            {name = "nvim_lua"},
            {name = "nvim_lsp"},
            {name = "vsnip"}
        }
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
    local conflict_state = vim.fn["funcs#get_conflict_state"]()
    if conflict_state ~= "" then
        table.insert(
            content,
            {"Git &conflict get", "ConflictMarker" .. conflict_state, "Get change from " .. conflict_state}
        )
        table.insert(content, {"Git conflict get all", "ConflictMarkerBoth", "Get change from both"})
        table.insert(content, {"Git conflict remove", "ConflictMarkerNone", "Remove conflict"})
        table.insert(content, {"--", ""})
    end
    table.insert(content, {"Built-in d&ocs", 'execute "normal! K"', "Vim built in help"})
    vim.fn["quickui#context#open"](content, {index = vim.g["quickui#context#cursor"] or -1})
end

function M.setup_vim_quickui()
    g.quickui_color_scheme = "papercol-dark"
    g.quickui_show_tip = 1
    g.quickui_border_style = 2
end

function M.vim_quickui()
    vim.fn["quickui#menu#switch"]("normal")
    vim.fn["quickui#menu#reset"]()
    vim.fn["quickui#menu#install"](
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
                "Clear search and refresh screen"
            },
            {"--", ""},
            {"Open &Startify", [[execute "PackerLoad! vim-startify" | Startify]], "Open vim-startify"},
            {
                "Save sessi&on",
                [[execute "PackerLoad! vim-startify" | SSave!]],
                "Save as a new session using vim-startify"
            },
            {"Delete session", [[execute "PackerLoad! vim-startify" | SDelete!]], "Delete a session using vim-startify"},
            {"--", ""},
            {"Edit Vimr&c", [[edit $MYVIMRC]]},
            {
                "Open in &VSCode",
                [[execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!]]
            }
        }
    )
    vim.fn["quickui#menu#install"](
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
            {"Git &root", [[Gcd]], "Change current directory to git root"},
            {
                "GitHub &issues",
                [[lua require('telescope').extensions.gh.issues()]],
                "Fuzzy search issues with Telescope"
            }
        }
    )
    vim.fn["quickui#menu#install"](
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
            }
        }
    )
    vim.fn["quickui#menu#install"](
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
            {"CSV arrange column", [[1,$CSVArrangeColumn!]], "Align csv columns"},
            {"CSV to table", [[CSVTabularize]], "Convert csv to table"}
        }
    )
    vim.fn["quickui#menu#install"](
        "L&SP",
        {
            {
                "Workspace &diagnostics",
                [[call v:lua.quickfix_all_diagnostics() | copen]],
                "Show workspace diagnostics in quickfix"
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
                [[lua vim.lsp.buf.add_workspace_folder()]],
                "Show folders in workspace for LSP"
            },
            {
                "Add folder to workspace",
                [[lua vim.lsp.buf.remove_workspace_folder()]],
                "Add folder to workspace for LSP"
            },
            {
                "Remove folder from workspace",
                [[lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))]],
                "Remove folder from workspace for LSP"
            }
        }
    )
    vim.fn["quickui#menu#switch"]("visual")
    vim.fn["quickui#menu#reset"]()
    vim.fn["quickui#menu#install"](
        "&Actions",
        {
            {"OSC &yank", [[OSCYank]], "Use ANSI OSC52 sequence to copy from remote SSH sessions"}
        }
    )
    vim.fn["quickui#menu#install"](
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
    vim.fn["quickui#menu#install"](
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
