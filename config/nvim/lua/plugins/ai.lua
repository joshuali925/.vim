return {
    {
        "awslabs/amazonq.nvim",
        enabled = vim.env.Q_SSO_URL ~= nil,
        cmd = "AmazonQ",
        event = "InsertEnter",
        keys = { { "<leader>h", function() vim.api.nvim_feedkeys(vim.keycode(":AmazonQ"), "", false) end, mode = { "n", "x" } } },
        config = function()
            require("amazonq").setup({
                ssoStartUrl = vim.env.Q_SSO_URL,
                filetypes = {
                    "amazonq", "bash", "java", "python", "typescript", "javascript", "csharp",
                    "ruby", "kotlin", "sh", "sql", "c", "cpp", "go", "rust", "lua", "typescriptreact",
                },
                on_chat_open = function()
                    vim.cmd("vertical botright split")
                    vim.schedule(function()
                        vim.bo.buflisted = false
                        vim.opt_local.number = false
                    end)
                end,
            })
            vim.cmd.doautocmd("BufReadPost")
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
            terminal_cmd = "AWS_PROFILE=bedrock-prod claude --allow-dangerously-skip-permissions",
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
}
