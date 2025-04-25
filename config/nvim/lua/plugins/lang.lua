return {
    { "MTDL9/vim-log-highlighting", ft = "log" },
    {
        "hat0uma/csvview.nvim",
        cmd = "CsvViewToggle",
        config = function()
            vim.opt_local.wrap = false
            vim.fn.setreg("/", ",")
            require("csvview").setup({ view = { display_mode = "border" } })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        enabled = vim.env.SSH_CLIENT == nil,
        build = "cd app && yarn install",
        cmd = "MarkdownPreview",
        init = function()
            vim.g.mkdp_auto_close = 0
            vim.g.mkdp_preview_options = { disable_sync_scroll = 1 }
        end,
        config = function() vim.cmd.doautocmd("FileType") end, -- trigger autocmd to define MarkdownPreview command for buffer
    },
    {
        "danymat/neogen",
        keys = { { "<leader>ge", "<Cmd>lua require('neogen').generate()<CR>" } },
        cmd = "Neogen",
        config = function()
            vim.keymap.set("i", "<Tab>", function()
                if require("neogen").jumpable() then return require("neogen").jump_next() end
                vim.api.nvim_feedkeys(vim.keycode("<Tab>"), "n", false)
            end)
            vim.keymap.set("i", "<S-Tab>", function()
                if require("neogen").jumpable(-1) then return require("neogen").jump_prev() end
                vim.api.nvim_feedkeys(vim.keycode("<S-Tab>"), "n", false)
            end)
            vim.keymap.set("i", "<C-k>", function()
                if require("neogen").jumpable() then return require("neogen").jump_next() end
                vim.lsp.buf.signature_help()
            end)
            require("neogen").setup()
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
                    awk = { "gawk" },
                    _ = { "trim_whitespace", lsp_format = "last" },
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
                require("conform").format({ async = false, timeout_ms = 3000, range = range })
            end, { range = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        cmd = "TSContextToggle", -- treesitter-context throws errors when loaded on keys
        init = function()
            vim.keymap.set("n", "yoC", "<Cmd>TSContextToggle<CR>")
        end,
        opts = { enable = false, mode = "topline" },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
        opts = {
            auto_install = true,
            ensure_installed = { "markdown_inline", "jsdoc" },
            ignore_install = { "tmux" },
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
    { "mason-org/mason.nvim", build = ":MasonUpdate", cmd = { "Mason", "MasonInstall" }, opts = { ui = { border = "rounded" } } },
    { "neovim/nvim-lspconfig" },
    { "pmizio/typescript-tools.nvim", dependencies = "neovim/nvim-lspconfig" },
    { "mfussenegger/nvim-jdtls" },
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
            bar = { enable = function(buf, win, _) return vim.fn.win_gettype(win) == "" and vim.bo[buf].bt == "" end },
            menu = {
                win_configs = { border = "single" },
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
                    ["o"] = function()
                        local utils = require("dropbar.utils")
                        local menu = utils.menu.get_current()
                        if not menu then return end
                        local cursor = vim.api.nvim_win_get_cursor(menu.win)
                        local component = menu.entries[cursor[1]]:next_clickable(cursor[2])
                        if component then menu:click_on(component, nil, 1, "l") end
                    end,
                },
            },
        },
    },
}
