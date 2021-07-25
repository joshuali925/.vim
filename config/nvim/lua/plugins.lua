local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.glob(install_path) == "" then
    vim.cmd("silent !git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
vim.cmd("packadd packer.nvim")

local function get_config(name)
    return ("require('plugin-configs').%s()"):format(name)
end

return require("packer").startup(
    {
        config = {
            auto_clean = false,
            opt_default = true,
            display = {
                open_fn = require("packer.util").float
            },
            profile = {
                enable = false
            }
        },
        function(use)
            use {"wbthomason/packer.nvim"}

            -- appearance
            use {
                "glepnir/zephyr-nvim",
                event = "VimEnter",
                config = function()
                    require("zephyr")
                end
            }
            use {"akinsho/nvim-bufferline.lua", event = "VimEnter", config = get_config("nvim_bufferline")}
            use {"glepnir/galaxyline.nvim", event = "VimEnter", config = get_config("galaxyline")}
            use {
                "lukas-reineke/indent-blankline.nvim",
                config = get_config("indent_blankline")
            }
            use {
                "norcalli/nvim-colorizer.lua",
                config = function()
                    require("colorizer").setup({}, {rgb_fn = true})
                end
            }

            -- ui
            use {
                "kassio/neoterm",
                cmd = {"T", "Ttoggle", "Tnew"},
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
            use {"simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", setup = get_config("setup_symbols_outline")}
            use {"simnalamburt/vim-mundo", cmd = "MundoToggle", config = get_config("mundo")}
            use {"kyazdani42/nvim-tree.lua", cmd = "NvimTreeToggle", config = get_config("nvim_tree")}
            use {
                "mhinz/vim-startify",
                cmd = "Startify",
                cond = function()
                    return vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1
                end,
                config = get_config("startify")
            }
            use {
                "nvim-telescope/telescope.nvim",
                requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
                module = "telescope",
                cmd = "Telescope",
                config = get_config("telescope")
            }
            use {"nvim-telescope/telescope-github.nvim", opt = false}
            use {"nvim-telescope/telescope-fzf-native.nvim", opt = false, run = "make"}

            -- git
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
            use {"tpope/vim-rhubarb", cmd = "GBrowse"}
            use {"rbong/vim-flog", cmd = {"Flog", "Flogsplit"}}
            use {
                "lewis6991/gitsigns.nvim",
                requires = {"nvim-lua/plenary.nvim"},
                config = get_config("gitsigns")
            }
            use {
                "rhysd/conflict-marker.vim",
                config = get_config("conflict_marker")
            }
            use {"sindrets/diffview.nvim", cmd = "DiffviewOpen"}

            -- lang
            use {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                requires = {"nvim-treesitter/nvim-treesitter-textobjects"}
            }
            use {"nvim-treesitter/playground", cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"}}
            use {"kabouzeid/nvim-lspinstall"}
            use {
                "neovim/nvim-lspconfig",
                after = {"nvim-lspinstall", "lsp_signature.nvim"},
                config = function()
                    require("lsp")
                end
            }
            use {
                "glepnir/lspsaga.nvim",
                module = "lspsaga",
                config = get_config("lspsaga")
            }
            use {"ray-x/lsp_signature.nvim"}
            use {
                "onsails/lspkind-nvim",
                event = "InsertEnter",
                config = function()
                    require("lspkind").init({symbol_map = {Enum = "", Field = ""}})
                end
            }
            use {
                "hrsh7th/nvim-compe",
                event = "InsertEnter",
                config = function()
                    require("completion")
                end
            }
            use {"hrsh7th/vim-vsnip", event = "InsertEnter"}
            use {"rafamadriz/friendly-snippets", event = "InsertEnter"}
            use {
                "folke/trouble.nvim",
                cmd = "TroubleToggle",
                config = function()
                    require("trouble").setup()
                end
            }
            use {"sbdchd/neoformat", cmd = "Neoformat"}
            use {
                "b3nj5m1n/kommentary",
                requires = {"JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-lspconfig"},
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
                after = "nvim-lspconfig",
                config = function()
                    require("lsp-rooter").setup()
                end
            }
            use {"udalov/kotlin-vim", ft = "kotlin"}

            -- editing
            use {"Krasjet/auto.pairs", event = "InsertEnter", config = get_config("auto_pairs")}
            use {
                "joshuali925/vim-indent-object",
                keys = {
                    {"o", "ii"},
                    {"o", "ai"},
                    {"x", "ii"},
                    {"x", "ai"},
                    {"o", "iI"},
                    {"o", "aI"},
                    {"x", "iI"},
                    {"x", "aI"}
                }
            }
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
            use {"unblevable/quick-scope", config = get_config("quick_scope")}
            use {"dahu/vim-fanfingtastic"}
            use {"chaoren/vim-wordmotion", setup = [[vim.g.wordmotion_nomap = 1]]}
            use {"machakann/vim-sandwich", setup = get_config("setup_vim_sandwich")}
            use {"machakann/vim-swap", keys = "<Plug>(swap-"}
            use {"AndrewRadev/splitjoin.vim", keys = {{"n", "gS"}, {"n", "gJ"}}}

            -- misc
            use {"tpope/vim-sleuth"}
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
            use {"kyazdani42/nvim-web-devicons", opt = false}

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
