local aider_cmd = nil
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
                    my_openai = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            schema = { model = { default = vim.env.AIDER_MODEL } },
                            env = { url = vim.env.OPENAI_API_BASE, chat_url = "/chat/completions" },
                        })
                    end,
                },
                strategies = {
                    chat = {
                        adapter = "my_openai",
                        keymaps = {
                            send = { modes = { n = "<leader>r", i = "<leader>r" } },
                            stop = { modes = { n = "<C-c>", i = "<C-c>" } },
                            close = { modes = { n = "<leader>x", i = "<Nop>" } },
                            completion = { modes = { i = "<C-n>" } },
                        },
                        slash_commands = { ["file"] = { opts = { provider = "snacks" } }, ["buffer"] = { opts = { provider = "snacks" } } },
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
                command = "call nvim_buf_set_lines(0, 2, 2, v:false, ['#buffer']) | nnoremap <buffer> ]\\ <Cmd>CodeCompanionChat<CR>",
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionChatSubmitted",
                group = group,
                callback = function()
                    require("blink.cmp").hide()
                    vim.cmd.stopinsert()
                end,
            })
        end,
    },
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>i",
                function()
                    if aider_cmd then return require("snacks.terminal").toggle(aider_cmd, { win = { position = "right" } }) end
                    vim.env.AWS_ACCESS_KEY_ID = nil
                    vim.env.AWS_SECRET_ACCESS_KEY = nil
                    vim.env.AWS_SESSION_TOKEN = nil
                    vim.env.AWS_PROFILE = "bedrock"
                    local function get_name(buf)
                        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
                            local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
                            if name ~= "" and name:find("^/") == nil and name:find("^%w+://") == nil then return name end
                        end
                    end
                    local files = {}
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        local name = get_name(buf)
                        if name then files[name] = true end
                    end
                    aider_cmd = vim.list_extend({ "aider" }, vim.tbl_keys(files))
                    local terminal = require("snacks.terminal").toggle(aider_cmd, { win = { position = "right" } })
                    local buf = terminal.buf
                    local channel = vim.bo[buf].channel
                    vim.keymap.set("t", "<C-b>", function()
                        local aider_win = vim.api.nvim_get_current_win()
                        require("snacks.picker").buffers({
                            confirm = function(picker, item)
                                picker:close()
                                vim.fn.chansend(channel, (" `%s` "):format(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(item.buf), ":t:r")))
                                vim.api.nvim_set_current_win(aider_win)
                                vim.schedule(vim.cmd.startinsert)
                            end,
                        })
                    end, { buffer = buf })
                    vim.keymap.set("t", "<C-p>", function()
                        local aider_win = vim.api.nvim_get_current_win()
                        vim.cmd.wincmd("p")
                        require("snacks.picker")[require("lsp").is_active() and "lsp_symbols" or "treesitter"]({
                            confirm = function(picker, item)
                                picker:close()
                                vim.fn.chansend(channel, (" `%s` "):format(item.name))
                                vim.api.nvim_set_current_win(aider_win)
                                vim.schedule(vim.cmd.startinsert)
                            end,
                        })
                    end, { buffer = buf })
                    vim.api.nvim_create_augroup("Aider", {})
                    vim.api.nvim_create_autocmd("BufEnter", { group = "Aider", buffer = buf, command = "startinsert" })
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
                            vim.schedule(function() -- wrap in schedule to run after buflisted when opening with mini.nvim
                                local name = get_name(e.buf)
                                if name and files[name] == nil then
                                    vim.fn.chansend(channel, ("/add %s\n"):format(name))
                                    files[name] = true
                                end
                            end)
                        end,
                    })
                    vim.api.nvim_create_autocmd("TermClose", {
                        group = "Aider",
                        callback = function(e)
                            if e.buf ~= buf then return end
                            vim.api.nvim_del_augroup_by_name("Aider")
                            files = nil
                            aider_cmd = nil
                        end,
                    })
                end,
            },
        },
    },
}
