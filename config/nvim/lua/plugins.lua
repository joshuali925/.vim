local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.glob(install_path) == "" then
    vim.cmd("silent !git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
vim.cmd("packadd packer.nvim")

local function get_config(name)
    return ('require("plugin-configs").%s()'):format(name)
end

return require("packer").startup(
    {
        config = {
            auto_clean = false,
            display = {
                opt_default = true,
                open_fn = require("packer.util").float
            },
            profile = {
                enable = false
            }
        },
        function(use)
            use {"wbthomason/packer.nvim", setup = ""}

            -- appearance
            use {
                "glepnir/zephyr-nvim",
                opt = false,
                config = function()
                    require("zephyr")
                end
            }
            use {"romgrk/barbar.nvim", opt = false, config = get_config("barbar")}
            use {"glepnir/galaxyline.nvim", opt = false, config = get_config("galaxyline")}
            use {
                "lukas-reineke/indent-blankline.nvim",
                opt = true,
                branch = "lua",
                config = get_config("indent_blankline")
            }
            use {
                "norcalli/nvim-colorizer.lua",
                opt = true,
                config = function()
                    require("colorizer").setup()
                end
            }

            -- ui
            use {
                "kassio/neoterm",
                cmd = {"Ttoggle", "Tnew"},
                keys = "<Plug>(neoterm-repl-send",
                setup = get_config("setup_neoterm")
            }
            use {
                "skywind3000/vim-quickui",
                fn = "quickui#*",
                setup = get_config("setup_vim_quickui"),
                config = get_config("vim_quickui")
            }
            use {"skywind3000/asyncrun.vim", cmd = "AsyncRun", config = [[vim.g.asyncrun_open = 12]]}
            use {"liuchengxu/vista.vim", cmd = "Vista", setup = [[vim.g.vista_default_executive = 'nvim_lsp']]}
            use {"simnalamburt/vim-mundo", cmd = "MundoToggle", config = get_config("mundo")}
            use {"kyazdani42/nvim-tree.lua", cmd = "NvimTreeToggle", config = get_config("nvim_tree")}
            use {"mhinz/vim-startify", opt = false, config = get_config("startify")}
            use {
                "nvim-telescope/telescope.nvim",
                requires = {
                    {"nvim-lua/popup.nvim"},
                    {"nvim-lua/plenary.nvim", opt = true},
                    {"nvim-telescope/telescope-github.nvim"},
                    {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
                },
                module = "telescope",
                cmd = "Telescope",
                config = get_config("telescope")
            }

            -- git
            use {"tpope/vim-rhubarb", opt = true}
            use {
                "tpope/vim-fugitive",
                fn = "fugitive#*",
                cmd = {
                    "Git",
                    "Gcd",
                    "GBrowse",
                    "Ggrep",
                    "Glgrep",
                    "Gdiffsplit",
                    "Gread",
                    "Gwrite",
                    "Gedit",
                    "Gclog"
                }
            }
            use {
                "lewis6991/gitsigns.nvim",
                requires = {"nvim-lua/plenary.nvim", opt = true},
                opt = true,
                config = get_config("gitsigns")
            }
            use {
                "rhysd/conflict-marker.vim",
                opt = true,
                config = get_config("conflict_marker")
            }
            use {"sindrets/diffview.nvim", cmd = "DiffviewOpen"}

            -- lang
            use {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                opt = true,
                requires = "nvim-treesitter/nvim-treesitter-textobjects",
                config = get_config("treesitter")
            }
            use {"neovim/nvim-lspconfig", opt = true}
            use {
                "glepnir/lspsaga.nvim",
                module = "lspsaga",
                config = function()
                    require("lspsaga").init_lsp_saga {
                        use_saga_diagnostic_sign = false,
                        finder_action_keys = {
                            open = "<CR>",
                            vsplit = "s",
                            split = "i",
                            quit = {"<Esc>", "q"},
                            scroll_down = "<NOP>",
                            scroll_up = "<NOP>"
                        },
                        code_action_keys = {
                            quit = {"<Esc>", "q"},
                            exec = "<CR>"
                        }
                    }
                end
            }
            use {"ray-x/lsp_signature.nvim", opt = true}
            use {
                "onsails/lspkind-nvim",
                event = "InsertEnter",
                config = function()
                    require("lspkind").init({symbol_map = {Enum = "", Field = ""}})
                end
            }
            use {"hrsh7th/vim-vsnip", event = "InsertEnter"}
            use {"rafamadriz/friendly-snippets", event = "InsertEnter"}
            use {
                "hrsh7th/nvim-compe",
                event = "InsertEnter",
                after = {"vim-vsnip", "friendly-snippets"},
                config = function()
                    require("completion")
                end
            }
            use {
                "folke/trouble.nvim",
                cmd = "TroubleToggle",
                requires = "kyazdani42/nvim-web-devicons",
                config = function()
                    require("trouble").setup()
                end
            }
            use {"sbdchd/neoformat", cmd = "Neoformat"}
            use {"kabouzeid/nvim-lspinstall", opt = true}
            use {"JoosepAlviste/nvim-ts-context-commentstring", opt = true}
            use {
                "b3nj5m1n/kommentary",
                requires = "JoosepAlviste/nvim-ts-context-commentstring",
                keys = "<Plug>kommentary_",
                setup = [[vim.g.kommentary_create_default_mappings = false]],
                config = get_config("kommentary")
            }
            use {
                "windwp/nvim-ts-autotag",
                ft = {"html", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue"},
                config = function()
                    require("nvim-ts-autotag").setup()
                end
            }
            use {"MTDL9/vim-log-highlighting", event = "BufNewFile,BufRead *.log"}
            use {
                "ahmedkhalf/lsp-rooter.nvim",
                opt = true,
                config = function()
                    require("lsp-rooter").setup()
                end
            }
            use {"udalov/kotlin-vim", ft = "kotlin"}

            -- editing
            use {"Krasjet/auto.pairs", event = "InsertEnter", config = get_config("auto_pairs")}
            use {"joshuali925/vim-indent-object", opt = true}
            use {"terryma/vim-expand-region", keys = "<Plug>(expand_region_"}
            use {
                "mg979/vim-visual-multi",
                fn = "vm#*",
                keys = {"<Plug>(VM-", {"n", "<leader><C-n>"}},
                setup = get_config("setup_vim_visual_multi")
            }
            use {
                "phaazon/hop.nvim",
                cmd = {"HopWord", "HopChar1", "HopLine"},
                config = function()
                    require("hop").setup({})
                end
            }
            use {"unblevable/quick-scope", opt = true, config = get_config("quick_scope")}
            use {"dahu/vim-fanfingtastic", opt = true}
            use {"chaoren/vim-wordmotion", keys = "<Plug>WordMotion", setup = [[vim.g.wordmotion_nomap = 1]]}
            use {"machakann/vim-sandwich", opt = true, setup = get_config("setup_vim_sandwich")}
            use {"machakann/vim-swap", keys = "<Plug>(swap-"}
            use {"AndrewRadev/splitjoin.vim", keys = {{"n", "gS"}, {"n", "gJ"}}}

            -- misc
            use {"tpope/vim-sleuth", opt = true}
            use {"tpope/vim-repeat", opt = false}
            use {
                "tpope/vim-unimpaired",
                keys = {
                    {"n", "["},
                    {"x", "["},
                    {"o", "["},
                    {"n", "]"},
                    {"x", "]"},
                    {"o", "]"},
                    {"n", "=p"},
                    {"n", "yo"}
                }
            }
            use {"jdhao/better-escape.vim", event = "InsertEnter"}
            use {"ojroques/vim-oscyank", cmd = {"OSCYank", "OSCYankReg"}}
            use {
                "bfredl/nvim-miniyank",
                event = "TextYankPost",
                fn = "miniyank#*",
                keys = "<Plug>(miniyank-",
                config = get_config("nvim_miniyank")
            }
            use {"aserowy/tmux.nvim", module = "tmux", config = get_config("tmux_nvim")}

            -- tools
            use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}
            use {"will133/vim-dirdiff", cmd = "DirDiff"}
            use {
                "iamcco/markdown-preview.nvim",
                run = "cd app && yarn install",
                ft = "markdown",
                setup = [[vim.g.mkdp_auto_close = 0]]
            }
            use {"godlygeek/tabular", cmd = "Tabularize"}
            use {
                "dhruvasagar/vim-table-mode",
                cmd = {"TableModeToggle", "TableModeRealign", "Tableize", "TableAddFormula", "TableEvalFormulaLine"},
                setup = get_config("setup_vim_table_mode")
            }
        end
    }
)
