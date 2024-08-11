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
        cmd = "Conform",
        config = function()
            require("conform").setup({
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
                    toml = { "taplo" },
                    ["_"] = { "trim_whitespace" },
                    config = function(bufnr)
                        if vim.fn.bufname(bufnr):match("^Caddyfile") ~= nil then return { "caddy" } end
                        return {}
                    end,
                },
                formatters = {
                    prettier = { options = { ft_parsers = { json = "json", jsonc = "json" } } },
                    caddy = { command = "caddy", args = { "fmt", "-" }, stdin = true },
                    taplo = { args = { "format", "--option", "inline_table_expand=false", "-" } },
                },
            })
            vim.api.nvim_create_user_command("Conform", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
                end
                require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 3000, range = range })
            end, { range = true })
        end,
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "pmizio/typescript-tools.nvim",
            {
                "Bekaboo/dropbar.nvim",
                keys = { { "<leader>e", "<Cmd>lua require('dropbar.api').pick()<CR>" } },
                init = function()
                    vim.ui.select = (function(overridden)
                        return function(...)
                            local present, menu = pcall(require, "dropbar.utils.menu")
                            vim.ui.select = present and menu.select or overridden
                            vim.ui.select(...)
                        end
                    end)(vim.ui.select)
                end,
                opts = {
                    general = {
                        enable = function(buf, win, _)
                            return vim.fn.win_gettype(win) == "" and vim.bo[buf].bt == "" and vim.fn.expand("%") ~= ""
                        end,
                    },
                    menu = {
                        keymaps = {
                            ["h"] = "<C-w>q",
                            ["l"] = function()
                                local utils = require("dropbar.utils")
                                local menu = utils.menu.get_current()
                                if not menu then return end
                                local cursor = vim.api.nvim_win_get_cursor(menu.win)
                                local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
                                if component then menu:click_on(component, nil, 1, "l") end
                            end,
                        },
                    },
                },
            },
        },
        cond = require("states").small_file, -- prevent LSP loading on keys for large file
        keys = {
            { "gd", "<Cmd>lua if require('lsp').is_active() then vim.lsp.buf.definition() else vim.cmd('normal! gd') end<CR>" },
            { "gD", vim.lsp.buf.type_definition },
            { "<leader>d", vim.lsp.buf.implementation },
            { "gr", vim.lsp.buf.references },
            { "<leader>a", "<Cmd>lua vim.lsp.buf.code_action()<CR>", mode = { "n", "x" } },
            { "gh", "<Cmd>lua if vim.diagnostic.open_float({ scope = 'cursor', border = 'single' }) == nil then vim.lsp.buf.hover() end<CR>" },
            { "<leader>R", "<Cmd>lua vim.lsp.buf.rename()<CR>" },
            { "[a", "<Cmd>lua vim.diagnostic.goto_prev({ float = { border = 'single' }, severity = vim.diagnostic.severity.ERROR })<CR>" },
            { "]a", "<Cmd>lua vim.diagnostic.goto_next({ float = { border = 'single' }, severity = vim.diagnostic.severity.ERROR })<CR>" },
            { "[A", "<Cmd>lua vim.diagnostic.goto_prev({ float = { border = 'single' } })<CR>" },
            { "]A", "<Cmd>lua vim.diagnostic.goto_next({ float = { border = 'single' } })<CR>" },
            { "g<C-k>", vim.lsp.buf.signature_help },
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
    { "nvim-treesitter/nvim-treesitter-context", keys = { { "yoC", "<Cmd>TSContextToggle<CR>" } }, opts = { enable = false, mode = "topline" } },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
        opts = {
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "comment",
                "json",
                "yaml",
                "markdown",
                "markdown_inline",
                "bash",
                "http",
                "html",
                "css",
                "javascript",
                "jsdoc",
                "typescript",
                "tsx",
                "python",
                "java",
                "kotlin",
            },
            highlight = {
                enable = true,
                disable = function(_, buf)
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    return ok and stats and stats.size > require("states").size_threshold
                end,
            },
            textobjects = {
                select = {
                    enable = true,
                    keymaps = {
                        ["if"] = "@call.inner",
                        ["af"] = "@call.outer",
                        ["iF"] = "@function.inner",
                        ["aF"] = "@function.outer",
                        ["ic"] = "@class.inner",
                        ["ac"] = "@class.outer",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = { ["]]"] = "@function.outer" },
                    goto_next_end = { ["]["] = "@function.outer", [")"] = "@parameter.inner" },
                    goto_previous_start = { ["[["] = "@function.outer", ["("] = "@parameter.inner" },
                    goto_previous_end = { ["[]"] = "@function.outer" },
                },
                swap = {
                    enable = true,
                    swap_next = { ["g>"] = "@parameter.inner" },
                    swap_previous = { ["g<"] = "@parameter.inner" },
                },
            },
            indent = { enable = true },
        },
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
    },
}
