local curr_theme = require("themes").theme
local config_theme = require("themes").config

return {
    { "folke/tokyonight.nvim",       lazy = curr_theme ~= "tokyonight.nvim",   config = config_theme },
    { "projekt0n/github-nvim-theme", lazy = curr_theme ~= "github-nvim-theme", config = config_theme },
    { "Mofiqul/vscode.nvim",         lazy = curr_theme ~= "vscode.nvim",       config = config_theme },
    { "Shatur/neovim-ayu",           lazy = curr_theme ~= "neovim-ayu",        config = config_theme },
    { "catppuccin/nvim",             lazy = curr_theme ~= "catppuccin",        config = config_theme, name = "catppuccin" },
    { "kyazdani42/nvim-web-devicons" },
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
    { "dstein64/nvim-scrollview", config = true }, -- TODO try lewis6991/satellite.nvim or petertriho/nvim-scrollbar if https://github.com/petertriho/nvim-scrollbar/issues/6 is fixed
    {
        "uga-rosa/ccc.nvim",
        cmd = "CccHighlighterEnable",
        config = function()
            local ccc = require("ccc")
            ccc.setup({ highlighter = { auto_enable = true }, mappings = { ["<Tab>"] = ccc.mapping.toggle_input_mode } })
        end,
    },
    {
        "akinsho/bufferline.nvim",
        event = "VimEnter",
        keys = {
            { "<BS>",      "<Cmd>BufferLineCyclePrev<CR>" },
            { "\\",        "<Cmd>BufferLineCycleNext<CR>" },
            { "<C-w><BS>", "<Cmd>BufferLineMovePrev<CR><C-w>", remap = true },
            { "<C-w>\\",   "<Cmd>BufferLineMoveNext<CR><C-w>", remap = true },
            { "Z[",        "<Cmd>BufferLineCloseLeft<CR>" },
            { "Z]",        "<Cmd>BufferLineCloseRight<CR>" },
        },
        opts = {
            -- options = { offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory" } } }, -- taking too much space
            highlights = { buffer_selected = { bold = true, italic = false } },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function()
            require("lualine").setup({
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { function() return "" end },
                    lualine_b = {
                        { "filetype", colored = true,      icon_only = true, padding = { left = 1, right = 0 } },
                        { "filename", file_status = false, path = 1 },
                    },
                    lualine_c = {
                        function() return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end,
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
                                    local spinners = { "", "", "", "" }
                                    local ms = math.floor(vim.loop.hrtime() / 120000000) -- 120ms
                                    local frame = ms % #spinners
                                    return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
                                end
                                return ""
                            end,
                            color = "String",
                        }
                    },
                    lualine_x = {
                        "searchcount",
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
                                return string.format("%s %s/%s", col < 10 and " " .. col or col, vim.fn.line("."), vim.fn.line("$"))
                            end,
                            icon = "",
                            padding = { left = 0, right = 1 },
                        },
                    }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        { "filetype", colored = true,      icon_only = true, padding = { left = 1, right = 0 } },
                        { "filename", file_status = false, path = 1,         color = "Normal" },
                    },
                    lualine_x = { { "location", color = "Normal" } },
                    lualine_y = {},
                    lualine_z = {}
                },
                extensions = { "quickfix", "toggleterm" }
            })
        end,
    },
}