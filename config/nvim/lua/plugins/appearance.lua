return {
    { "folke/tokyonight.nvim", priority = 1000 },
    { "projekt0n/github-nvim-theme", priority = 1000 },
    { "askfiy/visual_studio_code", priority = 1000 },
    { "Shatur/neovim-ayu", priority = 1000 },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "EdenEast/nightfox.nvim", priority = 1000 },
    { "nvim-tree/nvim-web-devicons" },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            char = "▏",
            context_char = "▏",
            show_current_context = true,
            filetype_exclude = vim.g.qs_filetype_blacklist,
            buftype_exclude = vim.g.qs_buftype_blacklist,
        },
    },
    { "dstein64/nvim-scrollview", opts = { signs_max_per_row = 2, signs_column = 1 } }, -- TODO try lewis6991/satellite.nvim or petertriho/nvim-scrollbar if https://github.com/petertriho/nvim-scrollbar/issues/6 is fixed
    {
        "akinsho/bufferline.nvim",
        event = "BufEnter", -- VimEnter/UIEnter breaks '+<line>' argument in command line nvim when 'line' is large
        keys = {
            { "<BS>", "<Cmd>BufferLineCyclePrev<CR>" },
            { "\\", "<Cmd>BufferLineCycleNext<CR>" },
            { "<C-w><BS>", ":BufferLineMovePrev<CR><C-w>", remap = true },
            { "<C-w>\\", ":BufferLineMoveNext<CR><C-w>", remap = true },
            { "Z[", "<Cmd>BufferLineCloseLeft<CR>" },
            { "Z]", "<Cmd>BufferLineCloseRight<CR>" },
        },
        opts = { highlights = { buffer_selected = { bold = true, italic = false } } },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "BufEnter",
        config = function()
            if require("themes").theme == "visual_studio_code" then
                return
            end
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
                        function() return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end,
                        function()
                            local flags = ""
                            if vim.o.readonly then
                                flags = flags .. "[RO]"
                            end
                            if vim.o.paste then
                                flags = flags .. "[paste]"
                            end
                            if vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8" then
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
                        { "diff", symbols = { added = "  ", modified = "  ", removed = "  " } },
                        "diagnostics",
                        {
                            function()
                                local lsp_progress = vim.lsp.util.get_progress_messages()[1]
                                if lsp_progress then
                                    local title = lsp_progress.title or ""
                                    local percentage = lsp_progress.percentage or 0
                                    local msg = lsp_progress.message or ""
                                    if percentage > 70 then
                                        return string.format(" %%<%s %s %s (%s%%%%) ", "", title, msg, percentage)
                                    end
                                    local spinners = { "󰪞 ", "󰪟 ", "󰪠 ", "󰪡 ", "󰪢 ", "󰪣 ", "󰪤 ", "󰪥" }
                                    local ms = math.floor(vim.loop.hrtime() / 120000000) -- 120ms
                                    local frame = ms % #spinners
                                    return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
                                end
                                return ""
                            end,
                            color = "String",
                        },
                    },
                    lualine_x = {
                        "%S",
                        {
                            function()
                                local reg = vim.fn.reg_recording()
                                return reg == "" and "" or "recording @" .. reg -- TODO https://github.com/neovim/neovim/issues/19193
                            end,
                            color = "Constant",
                        },
                        { "searchcount", color = "String" },
                        function()
                            local clients = {}
                            for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                                clients[#clients + 1] = client.name
                            end
                            return #clients == 0 and "" or " " .. table.concat(clients, " ")
                        end,
                    },
                    lualine_y = { { "branch", padding = { left = 0, right = 1 } } },
                    lualine_z = {
                        {
                            function()
                                local col = vim.fn.col(".")
                                return string.format(
                                    "%s %s %s/%s",
                                    states.untildone_count == 0 and "" or " " .. states.untildone_count,
                                    col < 10 and " " .. col or col,
                                    vim.fn.line("."),
                                    vim.fn.line("$")
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
                                return string.format("%s/%s", vim.fn.line("."), vim.fn.line("$"))
                            end,
                            color = "Normal",
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = { "nvim-tree", "aerial", "fugitive", "mundo" },
            })
        end,
    },
}
