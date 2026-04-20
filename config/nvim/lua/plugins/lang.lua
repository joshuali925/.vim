return {
    {
        "hat0uma/csvview.nvim",
        install = false,
        cmd = { "CsvViewToggle" },
        config = function()
            vim.opt_local.wrap = false
            require("csvview").setup({
                view = { display_mode = "border" },
                keymaps = {
                    textobject_field_inner = { "ia", mode = { "o", "x" } },
                    textobject_field_outer = { "aa", mode = { "o", "x" } },
                    jump_next_field_end = { "<Tab>", mode = { "n", "x" } },
                    jump_prev_field_end = { "<S-Tab>", mode = { "n", "x" } },
                },
            })
        end,
    },
    {
        "mistweaverco/kulala.nvim",
        install = false,
        init = function()
            vim.api.nvim_create_augroup("KulalaAutoCommands", {})
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "http",
                group = "KulalaAutoCommands",
                callback = function(e)
                    vim.keymap.set("n", "{", "<Cmd>lua require('kulala').jump_prev()<CR>", { buffer = e.buf })
                    vim.keymap.set("n", "}", "<Cmd>lua require('kulala').jump_next()<CR>", { buffer = e.buf })
                end,
            })
        end,
        config = function()
            require("kulala").setup({
                default_view = "headers_body",
                additional_curl_options = { "--insecure" },
                ui = { max_response_size = require("states").size_threshold * 5 },
            })
            vim.api.nvim_create_user_command("KulalaCopyCurl", "lua require('kulala').copy()", {})
        end,
    },
    { "brianhuster/live-preview.nvim", install = false, cmd = { "LivePreview" }, config = function() require("livepreview.config").set({ address = "0.0.0.0" }) end },
    {
        "danymat/neogen",
        install = false,
        keys = { { "n", "<leader>ge", "<Cmd>lua require('neogen').generate()<CR>" } },
        cmd = { "Neogen" },
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
        "stevearc/conform.nvim",
        install = false,
        cmd = { "Conform" },
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
                    jsonc = { "prettier" },
                    json5 = { "prettier" },
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
        install = false,
        keys = { { "n", "yoc", "<Cmd>TSContext toggle<CR>" } },
        init = function() vim.keymap.set("n", "yoC", "<Cmd>setlocal cursorline!<CR>") end,
        config = function() require("treesitter-context").setup({ enable = false, mode = "topline" }) end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("pack").load({ "mason.nvim" })
            require("mason-registry").refresh()
            if not require("mason-registry").is_installed("tree-sitter-cli") then
                local done = false
                require("mason-registry").get_package("tree-sitter-cli"):install():once("closed", function() done = true end)
                vim.wait(60000, function() return done end, 100)
            end
            require("pack").load({ "nvim-treesitter" })
            vim.cmd.TSUpdate()
        end,
        config = function()
            vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime") -- add queries (indents, folds) for built-in parsers
            local installed = vim.list.unique(                                                                   -- built-in parsers (~/.local/lib/nvim/lib/nvim/parser), no need to install again
                vim.list_extend(require("nvim-treesitter").get_installed(), { "c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc" })
            )
            local to_install = vim.tbl_filter(function(lang) return not vim.tbl_contains(installed, lang) end, { "jsdoc" }) -- parsers that won't be installed on demand
            if #to_install > 0 then
                vim.list_extend(installed, to_install)
                require("nvim-treesitter").install(to_install)
            end
            local available = { kulala_http = true }
            for _, lang in ipairs(require("nvim-treesitter").get_available()) do available[lang] = true end
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
                callback = function(event)
                    local lang = vim.treesitter.language.get_lang(event.match)
                    if not available[lang] then return end
                    local ts_toggle = function(enable)
                        if enable == nil then enable = not vim.treesitter.highlighter.active[event.buf] end
                        vim.treesitter[enable and "start" or "stop"](event.buf, enable and lang or nil)
                        vim.bo[event.buf].indentexpr = enable and "v:lua.require('nvim-treesitter').indentexpr()" or ""
                    end
                    vim.keymap.set("n", "yot", ts_toggle, { buffer = event.buf })
                    if vim.tbl_contains(installed, lang) then return ts_toggle(true) end
                    table.insert(installed, lang)
                    require("nvim-treesitter").install(lang):await(function(err) if not err and vim.api.nvim_buf_is_loaded(event.buf) then ts_toggle(true) end end)
                end,
            })
        end,
    },
    {
        "mason-org/mason.nvim",
        build = function()
            require("pack").load({ "mason.nvim" })
            vim.cmd.MasonUpdate()
        end,
        cmd = { "Mason", "MasonInstall" },
        config = function() require("mason").setup({ ui = { border = "rounded" } }) end,
    },
    { "neovim/nvim-lspconfig" },
    { "mfussenegger/nvim-jdtls", install = false },
    {
        "Bekaboo/dropbar.nvim",
        keys = { { "n", "<leader>e", "<Cmd>lua require('dropbar.api').pick()<CR>" } },
        init = function()
            vim.ui.select = (function(overridden)
                return function(...)
                    local present, menu = pcall(require, "dropbar.utils.menu")
                    vim.ui.select = present and menu.select or overridden
                    vim.ui.select(...)
                end
            end)(vim.ui.select)
        end,
        config = function()
            require("dropbar").setup({
                bar = {
                    enable = function(buf, win, _)
                        return vim.fn.win_gettype(win) == "" and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "http" -- breaks visual selection in kulala http
                    end,
                },
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
            })
        end,
    },
}
