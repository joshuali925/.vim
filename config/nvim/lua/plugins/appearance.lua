local theme = require("themes").theme
return {
    { "folke/tokyonight.nvim", priority = 1000, enabled = theme == "tokyonight" },
    { "projekt0n/github-nvim-theme", priority = 1000, enabled = theme == "github" },
    { "Shatur/neovim-ayu", priority = 1000, enabled = theme == "ayu" },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, enabled = theme == "catppuccin" },
    { "EdenEast/nightfox.nvim", priority = 1000, enabled = theme == "nightfox" },
    { "rebelot/kanagawa.nvim", priority = 1000, enabled = theme == "kanagawa" },
    { "yorik1984/newpaper.nvim", priority = 1000, enabled = theme == "newpaper" },
    {
        "folke/noice.nvim",
        event = "VeryLazy", -- delay loading causes screen to flicker on startup
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = { bottom_search = true, command_palette = true, long_message_to_split = true, lsp_doc_border = true },
            views = { mini = { timeout = 3500 } },
        },
    },
    {
        "dstein64/nvim-scrollview",
        config = function()
            require("scrollview").setup({ signs_on_startup = { "diagnostics", "search" }, signs_max_per_row = 2, winblend_gui = 50 })
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        opts = {
            func_map = {
                prevfile = "",         -- to filter: :g/pattern/lua require('bqf.qfwin.handler').signToggle(1)
                nextfile = "",         -- press zn to create new list with marked items
                pscrolldown = "<C-,>", -- press zN to create new list excluding marked items
                pscrollup = "<C-.>",   -- press < and > to switch between lists
                ptoggleitem = "",      -- press z<Tab> to clear marks
                ptoggleauto = "<C-p>",
                vsplit = "",
                tab = "",
                tabb = "",
            },
        },
    },
    {
        "stevearc/quicker.nvim",
        event = "FileType qf",
        keys = {
            { "yoq", function() require("quicker").toggle() end, desc = "Toggle quickfix" },
            { "yol", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle loclist" },
        },
        opts = {
            keys = {
                { "}", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Expand quickfix context" },
                { "{", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
            },
        },
    },
    {
        "akinsho/bufferline.nvim",
        event = "BufEnter", -- VimEnter/UIEnter breaks '+<line>' argument in command line nvim when 'line' is large
        keys = {
            { "<BS>", "<Cmd>keepjumps BufferLineCyclePrev<CR>" },
            { "\\", "<Cmd>keepjumps BufferLineCycleNext<CR>" },
            { "<C-w><BS>", ":BufferLineMovePrev<CR><Cmd>redraw!<CR><C-w>", remap = true },
            { "<C-w>\\", ":BufferLineMoveNext<CR><Cmd>redraw!<CR><C-w>", remap = true },
            { "Z[", "<Cmd>BufferLineCloseLeft<CR>" },
            { "Z]", "<Cmd>BufferLineCloseRight<CR>" },
        },
        opts = { highlights = { buffer_selected = { bold = true, italic = false } } },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local states = require("states")
            require("lualine").setup({
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { function() return "󰀘" end },
                    lualine_b = {
                        { "filetype", colored = true, icon_only = true, padding = { left = 1, right = 0 } },
                        { "filename", file_status = false, path = 1 },
                    },
                    lualine_c = {
                        function() return " " .. vim.uv.cwd():match("^.+/(.+)$") end,
                        function()
                            local flags = ""
                            if vim.o.readonly then
                                flags = flags .. "[RO]"
                            end
                            if vim.bo.fileencoding ~= "utf-8" and vim.bo.fileencoding ~= "" then
                                flags = flags .. "[fileencoding: " .. vim.bo.fileencoding .. "]"
                            end
                            if vim.bo.fileformat ~= "unix" then
                                flags = flags .. "[fileformat: " .. vim.bo.fileformat .. "]"
                            end
                            if #flags > 0 then
                                return " " .. flags .. " "
                            end
                            return ""
                        end,
                        { "diff", symbols = { added = " ", modified = " ", removed = " " } },
                        "diagnostics",
                    },
                    lualine_x = {
                        "%S",
                        {
                            function()
                                local reg = vim.fn.reg_recording()
                                return reg == "" and "" or "recording @" .. reg
                            end,
                            color = "Constant",
                        },
                        { "searchcount", color = "String" },
                        function()
                            local clients = vim.tbl_map(function(client) return client.name end, vim.lsp.get_clients({ bufnr = 0 }))
                            local icon = #clients > 0 and " " or ""
                            if package.loaded["neocodeium"] ~= nil then
                                local serverstatus = require("neocodeium").get_status() -- https://www.reddit.com/r/neovim/comments/1fc34na/comment/lm5wr1j
                                if serverstatus == 0 then
                                    icon = " " -- Connected
                                elseif serverstatus == 1 then
                                    icon = "󰣻 " -- Connection Error
                                elseif serverstatus == 2 then
                                    icon = "󰣽 " -- Disconnected
                                else
                                    icon = "󰣼 " -- Unknown
                                end
                            end
                            return icon .. table.concat(clients, " ")
                        end,
                    },
                    lualine_y = { { "branch", padding = { left = 0, right = 1 } } },
                    lualine_z = {
                        {
                            function()
                                local cursor = vim.api.nvim_win_get_cursor(0)
                                local col = cursor[2] + 1
                                return string.format(
                                    "%s %s %s %s/%s",
                                    (vim.o.expandtab and " " or " ") .. vim.o.shiftwidth,
                                    states.untildone_count == 0 and "󰉡" or " " .. states.untildone_count,
                                    col < 10 and " " .. col or col,
                                    cursor[1],
                                    vim.api.nvim_buf_line_count(0)
                                )
                            end,
                            padding = { left = 0, right = 1 },
                        },
                    },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        { "filetype", colored = true, icon_only = true, padding = { left = 1, right = 0 } },
                        { "filename", file_status = false, path = 1, color = "Normal" },
                    },
                    lualine_x = {
                        {
                            function()
                                return string.format("%s/%s", vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_buf_line_count(0))
                            end,
                            color = "Normal",
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = { "fugitive", "mundo" },
            })
        end,
    },
}
