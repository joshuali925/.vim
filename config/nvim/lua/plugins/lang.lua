return {
    { "MTDL9/vim-log-highlighting", ft = "log" },
    {
        "chrisbra/csv.vim",
        cmd = "CSVWhatColumn",
        init = function()
            vim.g.csv_nomap_cr = 1
            vim.g.csv_nomap_bs = 1
        end,
        config = function() vim.o.filetype = "csv" end,
    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "jose-elias-alvarez/typescript.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            {
                "glepnir/lspsaga.nvim",
                keys = { { "<leader>v", "<Cmd>Lspsaga outline<CR>" } },
                opts = {
                    ui = { winblend = 8 },
                    diagnostic = { on_insert = false },
                    lightbulb = { enable = false, sign_priority = 6, virtual_text = false },
                    code_action = { keys = { quit = "<Esc>" } },
                    rename = { quit = "<Esc>", in_select = false, whole_project = false },
                    show_outline = { jump_key = "<CR>" },
                    outline = { keys = { jump = "<CR>" } },
                    callhierarchy = { show_detail = true, keys = { jump = "<CR>", quit = "<Esc>" } },
                    symbol_in_winbar = { separator = "  " },
                },
            },
        },
        cond = require("states").small_file, -- prevent LSP loading on keys for large file
        keys = {
            { "gd", "<Cmd>lua if require('lsp').is_active() then vim.lsp.buf.definition() else vim.cmd('normal! gd') end<CR>" },
            { "gD", vim.lsp.buf.type_definition },
            { "<leader>d", vim.lsp.buf.implementation },
            { "gr", vim.lsp.buf.references },
            { "<leader>a", "<Cmd>Lspsaga code_action<CR>", mode = { "n", "x" } },
            { "gh", "<Cmd>lua if vim.diagnostic.open_float({scope = 'cursor', border = 'single'}) == nil then vim.lsp.buf.hover() end<CR>" },
            { "<leader>R", "<Cmd>Lspsaga rename<CR>" },
            { "[a", "<Cmd>Lspsaga diagnostic_jump_prev<CR>" },
            { "]a", "<Cmd>Lspsaga diagnostic_jump_next<CR>" },
            { "[A", "<Cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>" },
            { "]A", "<Cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>" },
            { "<C-k>", vim.lsp.buf.signature_help, mode = "i" },
        },
        config = function() require("lsp").init() end,
    },
    { "danymat/neogen", config = true },
    { "windwp/nvim-ts-autotag", ft = { "html", "javascript", "javascriptreact", "typescriptreact" }, config = true },
    {
        "RRethy/vim-illuminate",
        keys = {
            { "[m", "<Cmd>lua require('illuminate').goto_prev_reference()<CR>" },
            { "]m", "<Cmd>lua require('illuminate').goto_next_reference()<CR>" },
        },
        config = function()
            require("illuminate").configure({ filetypes_denylist = vim.g.qs_filetype_blacklist })
            vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "LspReferenceText" })
            vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "LspReferenceRead" })
            vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "LspReferenceWrite" })
        end,
    },
    {
        "b3nj5m1n/kommentary",
        dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
        keys = {
            { "gc", "<Plug>kommentary_motion_default" },
            { "gcc", "<Plug>kommentary_line_default" },
            { "gc", "<Plug>kommentary_visual_default<Esc>", mode = "x" },
            { "gc", ":<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>", mode = "o" },
        },
        init = function() vim.g.kommentary_create_default_mappings = false end,
        config = function()
            require("kommentary.config").configure_language("default", {
                hook_function = function() require("ts_context_commentstring.internal").update_commentstring() end,
            })
            require("kommentary.config").configure_language("lua", { prefer_single_line_comments = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        opts = {
            ensure_installed = {
                "lua",
                "vim",
                "json",
                "yaml",
                "markdown",
                "markdown_inline",
                "bash",
                "http",
                "html",
                "css",
                "javascript",
                "typescript",
                "tsx",
                "python",
                "java",
                "kotlin",
            },
            highlight = {
                enable = true,
                disable = function(_, buf)
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    return ok and stats and stats.size > 1048576
                end,
            },
            textobjects = {
                select = {
                    enable = true,
                    keymaps = { ["if"] = "@function.inner",["aF"] = "@function.outer",["ic"] = "@class.inner",["ac"] = "@class.outer" },
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
        },
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
    },
}
