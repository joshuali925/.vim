return {
    {
        "monkoose/neocodeium",
        enabled = vim.env.ENABLE_CODEIUM ~= nil,
        event = "InsertEnter",
        config = function()
            vim.keymap.set("i", "<Right>", function()
                if require("neocodeium").visible() then return require("neocodeium").accept() end
                vim.api.nvim_feedkeys(vim.keycode("<Right>"), "n", false)
            end)
            vim.keymap.set("i", "<Down>", function()
                if require("neocodeium").visible() then return require("neocodeium").cycle(1) end
                vim.api.nvim_feedkeys(vim.keycode("<Down>"), "n", false)
            end)
            vim.keymap.set("i", "<Up>", function()
                if require("neocodeium").visible() then return require("neocodeium").cycle(-1) end
                vim.api.nvim_feedkeys(vim.keycode("<Up>"), "n", false)
            end)
            require("neocodeium").setup({ filetypes = require("states").qs_disabled_filetypes, silent = true, debounce = true })
        end,
    },
    {
        "milanglacier/minuet-ai.nvim",
        enabled = vim.env.ENABLE_MINUET ~= nil and vim.env.OPENAI_API_BASE ~= nil,
        event = "VeryLazy",
        opts = {
            n_completions = 1,
            add_single_line_entry = false,
            cmp = { enable_auto_complete = false },
            blink = { enable_auto_complete = false },
            provider = "openai_compatible",
            provider_options = {
                openai_compatible = {
                    api_key = "OPENAI_API_KEY",
                    name = "my_openai",
                    end_point = ("%s/chat/completions"):format(vim.env.OPENAI_API_BASE),
                    stream = true,
                    model = "anthropic.claude-3-5-haiku-20241022-v1:0",
                },
            },
            virtualtext = {
                auto_trigger_ft = { "*" },
                auto_trigger_ignore_ft = vim.g.qs_filetype_blacklist,
                keymap = { accept = "<Right>", accept_line = "<A-a>", prev = "<Up>", next = "<Down>", dismiss = "<A-e>" },
            },
        },
    },
    { "joshuavial/aider.nvim", enabled = vim.env.OPENAI_API_KEY ~= nil, keys = { { "<leader>i", "<Cmd>AiderOpen<CR>" } }, opts = { default_bindings = false } },
    {
        "olimorris/codecompanion.nvim",
        enabled = vim.env.OPENAI_API_KEY ~= nil,
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
        keys = { { "<leader>h", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "x" } } },
        opts = {
            strategies = {
                chat = {
                    adapter = "my_openai",
                    keymaps = {
                        send = { modes = { n = "<CR>", i = "<CR>" } },
                        completion = { modes = { i = "<C-n>" } },
                    },
                },
                inline = { adapter = "my_openai" },
            },
            adapters = {
                my_openai = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        schema = { model = { default = "anthropic.claude-3-5-sonnet-20241022-v2:0" } },
                        env = {
                            url = vim.env.OPENAI_API_BASE,
                            api_key = vim.env.OPENAI_API_KEY,
                            chat_url = "/chat/completions",
                        },
                    })
                end,
            },
        },
    },
}
