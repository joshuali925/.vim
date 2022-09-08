local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.glob(install_path) == "" then
    Packer_bootstrap = vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })

end
vim.cmd("packadd packer.nvim")

return require("packer").startup({
    config = {
        opt_default = true,
        -- TODO https://github.com/wbthomason/packer.nvim/issues/456
        max_jobs = vim.g.packer_max_jobs, -- default nil is unlimited, setting to 50 fixes above issue but breaks plugin installing in headless nvim
        display = { open_fn = require("packer.util").float },
        profile = { enable = false },
        compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua", -- impatient.nvim
    },
    function(use)
        local function conf(name)
            return ("require('plugin-configs').%s()"):format(name)
        end

        use({ "wbthomason/packer.nvim" })

        -- appearance
        use({ "folke/tokyonight.nvim", cond = "require('themes').theme == 'tokyonight.nvim'", config = "require('themes').config()" })
        use({ "eddyekofo94/gruvbox-flat.nvim", cond = "require('themes').theme == 'gruvbox-flat.nvim'", config = "require('themes').config()" })
        use({ "projekt0n/github-nvim-theme", cond = "require('themes').theme == 'github-nvim-theme'", config = "require('themes').config()" })
        use({ "Mofiqul/vscode.nvim", cond = "require('themes').theme == 'vscode.nvim'", config = "require('themes').config()" })
        use({ "Shatur/neovim-ayu", cond = "require('themes').theme == 'neovim-ayu'", config = "require('themes').config()" })
        use({ "catppuccin/nvim", as = "catppuccin", cond = "require('themes').theme == 'catppuccin'", config = "require('themes').config()" })
        use({ "EdenEast/nightfox.nvim", cond = "require('themes').theme == 'nightfox.nvim'", config = "require('themes').config()" })
        use({ "akinsho/bufferline.nvim", event = "VimEnter", config = conf("bufferline_nvim") })
        use({ "feline-nvim/feline.nvim", event = "VimEnter", config = conf("feline_nvim") })
        use({ "lukas-reineke/indent-blankline.nvim", config = conf("indent_blankline") })
        -- TODO try lewis6991/satellite.nvim or petertriho/nvim-scrollbar if https://github.com/petertriho/nvim-scrollbar/issues/6 is fixed
        use({ "dstein64/nvim-scrollview", config = "require('scrollview').setup()" })
        use({
            "NvChad/nvim-colorizer.lua",
            cmd = "ColorizerAttachToBuffer",
            config = function() require("colorizer").setup({}, { RGB = false, rgb_fn = true, mode = "virtualtext" }) end,
        })

        -- ui
        use({
            "akinsho/toggleterm.nvim",
            module = "toggleterm",
            cmd = { "ToggleTerm", "TermExec", "ToggleTermSendCurrentLine", "ToggleTermSendVisualSelection" },
            config = conf("toggleterm_nvim"),
        })
        use({ "skywind3000/vim-quickui", fn = "quickui#*", setup = conf("setup_vim_quickui"), config = conf("vim_quickui") })
        use({ "skywind3000/asyncrun.vim", cmd = "AsyncRun", config = "vim.g.asyncrun_open = 12" })
        use({ "simnalamburt/vim-mundo", cmd = "MundoToggle", config = conf("mundo") })
        use({ "goolord/alpha-nvim", cond = "vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1", config = conf("alpha_nvim") })
        use({
            "nvim-telescope/telescope.nvim",
            requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", run = "make" } },
            module = "telescope",
            config = conf("telescope"),
        })
        use({ "kevinhwang91/nvim-bqf", ft = "qf", config = conf("nvim_bqf") })
        use({ "rcarriga/nvim-notify" })
        use({ "kyazdani42/nvim-tree.lua", cmd = { "NvimTreeFindFile", "NvimTreeOpen" }, config = conf("nvim_tree") })

        -- git
        use({
            "rbong/vim-flog",
            requires = { "tpope/vim-fugitive", "tpope/vim-rhubarb" },
            fn = "fugitive#*",
            event = "BufNewFile,BufRead *.git/{COMMIT,ISSUE,PULLREQ,RELEASE}_EDITMSG", -- issue number omni-completion
            cmd = { "Git", "Ggrep", "Glgrep", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gclog", "Flog", "Flogsplit" }, -- GBrowse loaded on demand won't include line number
        })
        use({ "lewis6991/gitsigns.nvim", config = conf("gitsigns") })
        use({ "rhysd/conflict-marker.vim", config = conf("conflict_marker") })
        use({ "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } })

        -- lang
        use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", requires = "nvim-treesitter/nvim-treesitter-textobjects", config = conf("nvim_treesitter") })
        use({ "williamboman/mason.nvim" })
        use({ "williamboman/mason-lspconfig.nvim", after = "mason.nvim" })
        use({ "neovim/nvim-lspconfig", after = "mason-lspconfig.nvim" })
        use({ "jose-elias-alvarez/null-ls.nvim", after = "nvim-lspconfig", config = "require('lsp').init()" })
        use({ "glepnir/lspsaga.nvim", cmd = "Lspsaga", module = "lspsaga", config = conf("lspsaga_nvim") })
        use({
            "b3nj5m1n/kommentary",
            requires = { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
            keys = "<Plug>kommentary_",
            setup = "vim.g.kommentary_create_default_mappings = false",
            config = conf("kommentary"),
        })
        use({ "windwp/nvim-ts-autotag", ft = { "html", "javascript", "javascriptreact", "typescriptreact" }, config = "require('nvim-ts-autotag').setup()" })
        use({ "RRethy/vim-illuminate", config = conf("vim_illuminate") })
        use({ "danymat/neogen", module = "neogen", config = "require('neogen').setup({})" })
        use({ "MTDL9/vim-log-highlighting", ft = "log" })
        use({ "udalov/kotlin-vim", ft = "kotlin" })
        use({ "chrisbra/csv.vim", setup = conf("setup_csv_vim"), cmd = "CSVWhatColumn" })

        -- completion
        use({ "hrsh7th/nvim-cmp", event = { "InsertEnter", "CmdlineEnter" }, cond = "require('states').small_file", config = conf("nvim_cmp") })
        use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
        use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
        use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
        use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
        use({ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" })
        use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
        use({ "hrsh7th/cmp-vsnip", after = "nvim-cmp" })
        use({ "rafamadriz/friendly-snippets", after = "nvim-cmp" }) -- vscode snippets: $HOME/Library/ApplicationSupport/Code/User/snippets
        use({ "hrsh7th/vim-vsnip", after = "friendly-snippets", setup = "vim.g.vsnip_snippet_dir = vim.fn.expand('~/.vim/config/snippets')" })
        use({ "windwp/nvim-autopairs", after = "nvim-cmp", config = conf("nvim_autopairs") })

        -- editing
        use({ "mg979/vim-visual-multi", fn = "vm#*", keys = { "<Plug>(VM-", { "n", "<leader><C-n>" } }, setup = conf("setup_vim_visual_multi") })
        use({ "phaazon/hop.nvim", cmd = { "HopWord", "HopChar1", "HopLineAC", "HopLineBC", "HopWordCurrentLine" }, config = conf("hop_nvim") })
        use({ "unblevable/quick-scope", config = conf("quick_scope") }) -- TODO https://github.com/jinh0/eyeliner.nvim/issues/5
        use({ "dahu/vim-fanfingtastic" })
        use({ "chaoren/vim-wordmotion", setup = "vim.g.wordmotion_nomap = 1" })
        use({ "machakann/vim-sandwich", setup = "vim.g.operator_sandwich_no_default_key_mappings = 1" })
        use({ "machakann/vim-swap", keys = "<Plug>(swap-" })
        use({ "AndrewRadev/splitjoin.vim", keys = { { "n", "gS" }, { "n", "gJ" } } })

        -- misc
        use({ "kyazdani42/nvim-web-devicons", opt = false })
        use({ "lewis6991/impatient.nvim", opt = false })
        use({ "tpope/vim-sleuth" })
        use({ "tpope/vim-unimpaired", keys = { "[", "]", { "n", "=p" }, { "n", "yo" } } })
        use({ "moll/vim-bbye", cmd = "Bdelete" })
        use({ "AckslD/nvim-neoclip.lua", event = "TextYankPost", config = conf("nvim_neoclip_lua") })
        use({ "aserowy/tmux.nvim", module = "tmux", config = function() require("tmux").setup({ navigation = { cycle_navigation = false } }) end })

        -- tools
        use({ "dstein64/vim-startuptime", cmd = "StartupTime" })
        use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install", ft = "markdown", setup = conf("setup_markdown_preview_nvim") })
        use({ "godlygeek/tabular", cmd = "Tabularize" })
        use({
            "dhruvasagar/vim-table-mode",
            cmd = { "TableModeToggle", "TableModeRealign", "Tableize", "TableAddFormula", "TableEvalFormulaLine" },
            setup = conf("setup_vim_table_mode"),
        })
        use({ "rest-nvim/rest.nvim", module = "rest-nvim", config = conf("rest_nvim") })
        use({ "will133/vim-dirdiff", cmd = "DirDiff" })

        if Packer_bootstrap then require("packer").sync() end
    end,
})
