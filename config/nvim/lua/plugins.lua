local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.glob(install_path) == "" then
    vim.cmd("silent !git clone https://github.com/wbthomason/packer.nvim --depth=1 " .. install_path)
end
vim.cmd("packadd packer.nvim")

return require("packer").startup(
    {
        config = {
            opt_default = true,
            -- https://github.com/wbthomason/packer.nvim/issues/456
            -- max_jobs = 10, -- this fixes above issue but breaks plugin installing in headless nvim
            display = {open_fn = require("packer.util").float},
            profile = {enable = false},
            compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua" -- impatient.nvim
        },
        function(use)
            local function conf(name)
                return ("require('plugin-configs').%s()"):format(name)
            end
            use {"wbthomason/packer.nvim"}

            -- appearance
            use {
                "folke/tokyonight.nvim",
                cond = "require('themes').theme == 'tokyonight.nvim'",
                event = "BufEnter",
                config = "require('themes').config()"
            }
            use {
                "eddyekofo94/gruvbox-flat.nvim",
                cond = "require('themes').theme == 'gruvbox-flat.nvim'",
                event = "BufEnter",
                config = "require('themes').config()"
            }
            use {
                "projekt0n/github-nvim-theme",
                cond = "require('themes').theme == 'github-nvim-theme'",
                event = "BufEnter",
                config = "require('themes').config()"
            }
            use {
                "catppuccin/nvim",
                as = "catppuccin",
                cond = "require('themes').theme == 'catppuccin'",
                event = "BufEnter",
                config = "require('themes').config()"
            }
            use {
                "Mofiqul/vscode.nvim",
                cond = "require('themes').theme == 'vscode.nvim'",
                event = "BufEnter",
                config = "require('themes').config()"
            }
            use {
                "akinsho/nvim-bufferline.lua",
                event = "VimEnter",
                config = function()
                    require("bufferline").setup({highlights = {buffer_selected = {gui = "bold"}}})
                end
            }
            use {"feline-nvim/feline.nvim", event = "VimEnter", config = conf("feline_nvim")}
            use {"lukas-reineke/indent-blankline.nvim", setup = conf("setup_indent_blankline")}
            use {
                "DarwinSenior/nvim-colorizer.lua",
                cmd = "ColorizerAttachToBuffer",
                config = function()
                    require("colorizer").setup({}, {RGB = false, rgb_fn = true, mode = "virtualtext"})
                end
            }

            -- ui
            use {
                "kassio/neoterm",
                cmd = {"T", "Ttoggle", "Tnew"},
                keys = "<Plug>(neoterm-repl-send",
                setup = conf("setup_neoterm")
            }
            use {
                "skywind3000/vim-quickui",
                fn = "quickui#*",
                setup = conf("setup_vim_quickui"),
                config = conf("vim_quickui")
            }
            use {"skywind3000/asyncrun.vim", cmd = "AsyncRun", config = "vim.g.asyncrun_open = 12"}
            use {"simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", setup = conf("setup_symbols_outline")}
            use {"simnalamburt/vim-mundo", cmd = "MundoToggle", config = conf("mundo")}
            use {"kyazdani42/nvim-tree.lua", cmd = "NvimTreeToggle", config = conf("nvim_tree")}
            use {
                "goolord/alpha-nvim",
                cond = function()
                    return vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1
                end,
                event = "VimEnter",
                config = conf("alpha_nvim")
            }
            use {
                "nvim-telescope/telescope.nvim",
                requires = {
                    {"nvim-lua/popup.nvim"},
                    {"nvim-lua/plenary.nvim"},
                    {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
                },
                wants = {"popup.nvim", "plenary.nvim", "telescope-fzf-native.nvim"},
                module = "telescope",
                config = conf("telescope")
            }
            use {"kevinhwang91/nvim-bqf", ft = "qf", config = conf("nvim_bqf")}
            use {"rcarriga/nvim-notify"}
            use {
                "gelguy/wilder.nvim",
                requires = {"romgrk/fzy-lua-native"},
                event = "CmdlineEnter",
                config = conf("wilder_nvim")
            }

            -- git
            use {
                "tpope/vim-fugitive",
                fn = "fugitive#*",
                requires = {"tpope/vim-rhubarb"},
                cmd = {"Git", "Ggrep", "Glgrep", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gclog"}
            }
            use {"rbong/vim-flog", cmd = {"Flog", "Flogsplit"}}
            use {"lewis6991/gitsigns.nvim", config = conf("gitsigns")}
            use {"rhysd/conflict-marker.vim", config = conf("conflict_marker")}
            use {"sindrets/diffview.nvim", cmd = {"DiffviewOpen", "DiffviewFileHistory"}}

            -- lang
            use {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                requires = {"nvim-treesitter/nvim-treesitter-textobjects"},
                config = conf("nvim_treesitter")
            }
            use {"nvim-treesitter/playground", cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"}}
            use {"williamboman/nvim-lsp-installer"}
            use {"neovim/nvim-lspconfig", after = "nvim-lsp-installer", config = "require('lsp')"}
            use {"weilbith/nvim-code-action-menu", cmd = "CodeActionMenu"}
            use {"onsails/lspkind-nvim", event = "InsertEnter"}
            use {"hrsh7th/nvim-cmp", after = "lspkind-nvim", config = conf("nvim_cmp")}
            use {"hrsh7th/cmp-buffer", after = "nvim-cmp"}
            use {"hrsh7th/cmp-path", after = "nvim-cmp"}
            use {"hrsh7th/cmp-nvim-lua", after = "nvim-cmp"}
            use {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp"}
            use {"hrsh7th/cmp-vsnip", after = "nvim-cmp"}
            use {"rafamadriz/friendly-snippets", after = "nvim-cmp"}
            use {"hrsh7th/vim-vsnip", after = "friendly-snippets"}
            use {"sbdchd/neoformat", cmd = "Neoformat"}
            use {
                "b3nj5m1n/kommentary",
                requires = {"JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter"},
                keys = "<Plug>kommentary_",
                setup = "vim.g.kommentary_create_default_mappings = false",
                config = conf("kommentary")
            }
            use {
                "windwp/nvim-ts-autotag",
                ft = {"html", "javascript", "javascriptreact", "typescriptreact"},
                wants = "nvim-treesitter",
                config = "require('nvim-ts-autotag').setup()"
            }
            use {"neomake/neomake", cmd = "Neomake", config = conf("neomake")}
            use {"MTDL9/vim-log-highlighting", event = "BufNewFile,BufRead *.log"}
            use {"udalov/kotlin-vim", ft = "kotlin"}
            use {"chrisbra/csv.vim", setup = conf("setup_csv_vim"), cmd = "CSVWhatColumn"}

            -- editing
            use {"windwp/nvim-autopairs", after = "nvim-cmp", config = conf("nvim_autopairs")}
            use {
                "mg979/vim-visual-multi",
                fn = "vm#*",
                keys = {"<Plug>(VM-", {"n", "<leader><C-n>"}},
                setup = conf("setup_vim_visual_multi")
            }
            use {
                "phaazon/hop.nvim",
                cmd = {"HopWord", "HopChar1", "HopLineAC", "HopLineBC", "HopWordCurrentLine"},
                config = conf("hop_nvim")
            }
            use {"unblevable/quick-scope", config = conf("quick_scope")}
            use {"dahu/vim-fanfingtastic"}
            use {"chaoren/vim-wordmotion", setup = "vim.g.wordmotion_nomap = 1"}
            use {"machakann/vim-sandwich", setup = "vim.g.operator_sandwich_no_default_key_mappings = 1"}
            use {"machakann/vim-swap", keys = "<Plug>(swap-"}
            use {"AndrewRadev/splitjoin.vim", keys = {{"n", "gS"}, {"n", "gJ"}}}

            -- misc
            use {"lewis6991/impatient.nvim", opt = false}
            use {"ahmedkhalf/project.nvim", opt = false, config = conf("project_nvim")}
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
            use {"moll/vim-bbye", cmd = "Bdelete"}
            use {"andymass/vim-matchup", config = conf("vim_matchup")}
            use {"ojroques/vim-oscyank", cmd = {"OSCYank", "OSCYankReg"}}
            use {
                "bfredl/nvim-miniyank",
                event = "TextYankPost",
                fn = "miniyank#*",
                keys = "<Plug>(miniyank-",
                config = "vim.g.miniyank_maxitems = 200"
            }
            use {
                "aserowy/tmux.nvim",
                module = "tmux",
                config = function()
                    require("tmux").setup({navigation = {cycle_navigation = false}})
                end
            }
            use {"kyazdani42/nvim-web-devicons", opt = false}

            -- tools
            use {"dstein64/vim-startuptime", cmd = "StartupTime"}
            use {"will133/vim-dirdiff", cmd = "DirDiff"}
            use {
                "iamcco/markdown-preview.nvim",
                run = "cd app && yarn install",
                ft = "markdown",
                setup = "vim.g.mkdp_auto_close = 0"
            }
            use {"godlygeek/tabular", cmd = "Tabularize"}
            use {
                "dhruvasagar/vim-table-mode",
                cmd = {"TableModeToggle", "TableModeRealign", "Tableize", "TableAddFormula", "TableEvalFormulaLine"},
                setup = conf("setup_vim_table_mode")
            }
            use {"NTBBloodbath/rest.nvim", module = "rest-nvim", config = conf("rest_nvim")}
        end
    }
)
