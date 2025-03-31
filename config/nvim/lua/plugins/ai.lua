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
        "augmentcode/augment.vim",
        enabled = vim.env.VIM_AI == "augment",
        event = "InsertEnter",
        cmd = "Augment",
        keys = { { "<leader>h", "<Cmd>Augment chat<CR>", mode = { "n", "x" } }, { "<leader>H", "<Cmd>Augment chat-toggle<CR>", mode = { "n", "x" } } },
        init = function()
            vim.g.augment_disable_tab_mapping = true
            -- vim.g.augment_workspace_folders = { vim.uv.cwd() }
        end,
        config = function() vim.keymap.set("i", "<Right>", function() vim.fn["augment#Accept"](vim.keycode("<C-g>U<Right>")) end) end,
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
                            local name = get_name(e.buf)
                            if name and files[name] == nil then
                                vim.fn.chansend(channel, ("/add %s\n"):format(name))
                                files[name] = true
                            end
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
