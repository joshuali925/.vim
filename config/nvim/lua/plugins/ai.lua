local aiderCmd = nil
return {
    {
        "supermaven-inc/supermaven-nvim",
        enabled = vim.env.ENABLE_SUPERMAVEN ~= nil,
        event = "InsertEnter",
        config = function()
            require("supermaven-nvim").setup({
                disable_keymaps = true,
                condition = function() return require("states").qs_disabled_filetypes[vim.o.filetype] == false end,
            })
            vim.keymap.set("i", "<Right>", function()
                local suggestion = require("supermaven-nvim.completion_preview")
                if suggestion.has_suggestion() then return suggestion.on_accept_suggestion() end
                vim.api.nvim_feedkeys(vim.keycode("<C-g>U<Right>"), "n", false) -- for multicursor.nvim
            end)
        end,
    },
    {
        "monkoose/neocodeium",
        enabled = vim.env.ENABLE_CODEIUM ~= nil,
        event = "InsertEnter",
        config = function()
            vim.keymap.set("i", "<Right>", function()
                if require("neocodeium").visible() then return require("neocodeium").accept() end
                vim.api.nvim_feedkeys(vim.keycode("<C-g>U<Right>"), "n", false) -- for multicursor.nvim
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
        event = "VeryLazy", -- InsertEnter isn't working
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
                    model = vim.env.AIDER_WEAK_MODEL,
                },
            },
            virtualtext = {
                auto_trigger_ft = { "*" },
                auto_trigger_ignore_ft = vim.g.qs_filetype_blacklist,
                keymap = { accept = "<Right>", accept_line = "<A-a>", prev = "<Up>", next = "<Down>", dismiss = "<A-e>" },
            },
        },
    },
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>i",
                function()
                    if aiderCmd then return require("snacks.terminal").toggle(aiderCmd, { win = { position = "right" } }) end
                    vim.env.AWS_PROFILE = "bedrock"
                    local function get_name(buf)
                        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
                            local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
                            if name ~= "" then return name end
                        end
                    end
                    local files = {}
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        local name = get_name(buf)
                        if name then files[name] = true end
                    end
                    aiderCmd = vim.list_extend({ "aider" }, vim.tbl_keys(files))
                    local terminal = require("snacks.terminal").toggle(aiderCmd, { win = { position = "right" } })
                    local buf = terminal.buf
                    local channel = vim.bo[buf].channel
                    vim.api.nvim_create_augroup("Aider", {})
                    vim.api.nvim_create_autocmd("BufDelete", {
                        group = "Aider",
                        callback = function(e)
                            local name = get_name(e.buf)
                            if name and files[name] ~= nil then
                                vim.fn.chansend(channel, ("/drop %s\n"):format(name))
                                files[name] = nil
                            end
                        end,
                    })
                    vim.api.nvim_create_autocmd("BufReadPost", {
                        group = "Aider",
                        callback = function(e)
                            local name = get_name(e.buf)
                            if name and files[name] == nil then
                                vim.fn.chansend(channel, ("/add %s\n"):format(name))
                                files[name] = true
                            end
                        end,
                    })
                    vim.api.nvim_create_autocmd("TermClose", {
                        group = "Aider",
                        callback = function(ev)
                            if ev.buf ~= buf then return end
                            vim.api.nvim_del_augroup_by_name("Aider")
                            files = nil
                            aiderCmd = nil
                        end,
                    })
                end,
            },
        },
    },
    {
        "olimorris/codecompanion.nvim",
        enabled = vim.env.OPENAI_API_KEY ~= nil,
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
        keys = { { "<leader>h", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "x" } } },
        opts = {
            strategies = {
                chat = {
                    adapter = "my_openai",
                    keymaps = { send = { modes = { n = "<leader>r", i = "<leader>r" } }, completion = { modes = { i = "<C-n>" } } },
                    slash_commands = { ["file"] = { opts = { provider = "snacks" } }, ["buffer"] = { opts = { provider = "snacks" } } },
                },
                inline = { adapter = "my_openai" },
            },
            adapters = {
                my_openai = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        schema = { model = { default = vim.env.AIDER_MODEL } },
                        env = { url = vim.env.OPENAI_API_BASE, chat_url = "/chat/completions" },
                    })
                end,
            },
        },
    },
}
