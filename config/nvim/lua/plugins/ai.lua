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
        "coder/claudecode.nvim", -- TODO try https://github.com/carlos-algms/agentic.nvim
        enabled = vim.uv.fs_stat(vim.env.HOME .. "/.claude.json") ~= nil,
        dependencies = "folke/snacks.nvim",
        keys = {
            { "<leader>c", "<Cmd>ClaudeCode<CR>" },
            { "<leader>c", "<Cmd>ClaudeCodeSend<CR>", mode = "x" },
            { "<leader>c", "<Cmd>ClaudeCodeTreeAdd<CR>", ft = { "neo-tree", "minifiles" } },
        },
        opts = {
            terminal_cmd = "claude --allow-dangerously-skip-permissions",
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
                                    confirm = function(picker)
                                        local items = picker:selected({ fallback = true })
                                        picker:close()
                                        vim.fn.chansend(channel, " " .. table.concat(vim.tbl_map(function(item)
                                            return ("@%s"):format(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(item.buf), ":~:."))
                                        end, items), " ") .. " ")
                                    end,
                                    on_close = function()
                                        vim.api.nvim_set_current_win(win)
                                        vim.schedule(vim.cmd.startinsert)
                                    end,
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
