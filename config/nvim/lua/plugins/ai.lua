return {
    {
        "supermaven-inc/supermaven-nvim",
        enabled = vim.env.VIM_AI == "supermaven",
        event = "InsertEnter",
        config = function()
            require("supermaven-nvim").setup({
                disable_keymaps = true,
                condition = function() return require("states").qs_disabled_filetypes[vim.o.filetype] == false end,
            })
            vim.keymap.set("i", "<Right>", function()
                local suggestion = require("supermaven-nvim.completion_preview")
                if suggestion.has_suggestion() then return suggestion.on_accept_suggestion() end
                vim.api.nvim_feedkeys(vim.keycode("<C-g>U<Right>"), "n", false) -- <C-g>U is for multicursor.nvim
            end)
        end,
    },
    {
        "coder/claudecode.nvim",
        enabled = vim.env.ANTHROPIC_MODEL ~= nil,
        dependencies = { "folke/snacks.nvim" },
        keys = {
            { "<leader>c", "<Cmd>ClaudeCode<CR>" },
            { "<leader>c", "<Cmd>ClaudeCodeSend<CR>", mode = "x" },
            { "<leader>c", "<Cmd>ClaudeCodeTreeAdd<CR>", ft = { "neo-tree", "minifiles" } },
        },
        opts = {
            terminal_cmd = 'AWS_PROFILE="bedrock-prod" node --no-warnings --enable-source-maps ~/.local/lib/node-packages/bin/claude',
            terminal = {
                split_width_percentage = 0.4,
                snacks_win_opts = {
                    keys = {
                        pick_buffer = {
                            "<C-p>",
                            function()
                                local channel = vim.bo.channel
                                local win = vim.api.nvim_get_current_win()
                                require("snacks.picker").buffers({
                                    confirm = function(picker, item)
                                        picker:close()
                                        vim.fn.chansend(channel, (" @%s "):format(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(item.buf), ":~:.")))
                                    end,
                                    on_close = function() vim.api.nvim_set_current_win(win) end,
                                })
                            end,
                            mode = "t",
                        },
                    },
                },
            },
        },
    },
    {
        "olimorris/codecompanion.nvim",
        enabled = vim.env.OPENAI_API_KEY ~= nil,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            { "ravitemer/mcphub.nvim", build = "npm install -g mcp-hub@latest", cmd = "MCPHub", opts = { auto_approve = true } },
        },
        keys = { { "<leader>h", "<Cmd>CodeCompanionChat Toggle<CR>" }, { "<leader>h", "<Cmd>CodeCompanionActions<CR>", mode = { "x" } } },
        config = function()
            require("codecompanion").setup({
                display = { action_palette = { provider = "snacks" } },
                adapters = {
                    http = {
                        my_openai = function()
                            return require("codecompanion.adapters").extend("openai_compatible", {
                                schema = { model = { default = vim.env.OPENAI_MODEL } },
                                env = { url = vim.env.OPENAI_API_BASE, chat_url = "/chat/completions" },
                            })
                        end,
                    },
                },
                strategies = {
                    chat = {
                        adapter = "my_openai",
                        keymaps = {
                            send = { modes = { n = "<leader>r", i = "<leader>r" } },
                            stop = { modes = { n = "<C-c>", i = "<C-c>" } },
                            close = { modes = { n = "<leader>x" } },
                            completion = { modes = { i = "<C-n>" } },
                            previous_chat = { modes = { n = "<BS>" } },
                            next_chat = { modes = { n = "\\" } },
                        },
                        slash_commands = { ["file"] = { opts = { provider = "snacks" } }, ["buffer"] = { opts = { provider = "snacks" } } },
                        opts = { completion_provider = "default" },
                    },
                    inline = { adapter = "my_openai" },
                },
                extensions = {
                    mcphub = { callback = "mcphub.extensions.codecompanion", opts = { show_result_in_chat = true, make_vars = true, make_slash_commands = true } },
                },
            })
            local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
            vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionChatCreated",
                group = group,
                command = "call nvim_buf_set_lines(0, 2, 2, v:false, ['#{buffer}{watch}', '@{insert_edit_into_file}']) | nnoremap <buffer> ]\\ <C-w>p<Cmd>CodeCompanionChat<CR>",
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionChatSubmitted",
                group = group,
                callback = function()
                    require("blink.cmp").hide()
                    vim.cmd.stopinsert()
                end,
            })
            vim.api.nvim_create_autocmd("User", { pattern = "CodeCompanionRequestStarted", group = group, callback = function() require("states").loading = true end })
            vim.api.nvim_create_autocmd("User", { pattern = "CodeCompanionRequestFinished", group = group, callback = function() require("states").loading = false end })
        end,
    },
}
