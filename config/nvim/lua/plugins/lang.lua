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
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                less = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                python = { "black" },
                java = { "google-java-format" },
                kotlin = { "ktlint" },
                ["_"] = { "trim_whitespace" },
                config = function(bufnr)
                    if vim.fn.bufname(bufnr):match("Caddyfile$") ~= nil then return { "caddy" } end
                    return {}
                end,
            },
            formatters = {
                prettier = { options = { ft_parsers = { json = "json", jsonc = "json" } } },
                caddy = { command = "caddy", args = { "fmt", "-" }, stdin = true },
            },
        },
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "pmizio/typescript-tools.nvim",
            {
                "nvimdev/lspsaga.nvim", -- TODO nvim 0.10 https://github.com/Bekaboo/dropbar.nvim
                opts = {
                    ui = { winblend = 8 },
                    diagnostic = { on_insert = false },
                    lightbulb = { enable = false, sign_priority = 6, virtual_text = false },
                    code_action = { keys = { quit = "<Esc>" }, show_server_name = true },
                    rename = { quit = "<Esc>", in_select = false },
                    outline = { keys = { expand_or_jump = "<CR>" } },
                    callhierarchy = { show_detail = true, keys = { jump = "<CR>", quit = "<Esc>" } },
                },
            },
            {
                "j-hui/fidget.nvim",
                config = function()
                    require("fidget").setup({ integration = { ["nvim-tree"] = { enable = false } } })
                    vim.api.nvim_create_user_command("Notifications", "lua require('fidget.notification').show_history()", {})
                end
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
    {
        "stevearc/aerial.nvim",
        keys = { { "<leader>v", "<Cmd>AerialToggle<CR>" }, { "<leader>V", "<Cmd>AerialNavToggle<CR>" } },
        opts = {
            keymaps = {
                ["v"] = function()
                    require("aerial.actions").close.callback()
                    require("aerial").nav_open()
                end,
            },
            nav = { preview = true, keymaps = { ["q"] = "actions.close" } },
        },
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
        init = function()
            vim.g.kommentary_create_default_mappings = false
            vim.g.skip_ts_context_commentstring_module = true -- skip backwards compatibility routines and speed up loading, https://github.com/JoosepAlviste/nvim-ts-context-commentstring/blob/5b02387b28a79c61b7d406c2a33d4db1d8454f53/README.md?plain=1#L40
        end,
        config = function()
            require("ts_context_commentstring").setup({ enable_autocmd = false })
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
                    return ok and stats and stats.size > require("states").size_threshold
                end,
            },
            textobjects = {
                select = {
                    enable = true,
                    keymaps = { ["iF"] = "@function.inner", ["aF"] = "@function.outer", ["ic"] = "@class.inner", ["ac"] = "@class.outer" },
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
            indent = { enable = true },
        },
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
    },
}
