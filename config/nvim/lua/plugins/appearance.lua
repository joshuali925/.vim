local theme = require("themes").theme -- this happens before shada loads, so vim.g.UPPER_CASE_VAR can't be used
return {
    { "folke/tokyonight.nvim", lazy = (theme ~= "tokyonight"), install = (theme == "tokyonight") },
    { "projekt0n/github-nvim-theme", lazy = (theme ~= "github"), install = (theme == "github") },
    { "Shatur/neovim-ayu", lazy = (theme ~= "ayu"), install = (theme == "ayu") },
    { "catppuccin/nvim", name = "catppuccin", lazy = (theme ~= "catppuccin"), install = (theme == "catppuccin") },
    { "EdenEast/nightfox.nvim", lazy = (theme ~= "nightfox"), install = (theme == "nightfox") },
    { "rebelot/kanagawa.nvim", lazy = (theme ~= "kanagawa"), install = (theme == "kanagawa") },
    { "Mofiqul/vscode.nvim", lazy = (theme ~= "vscode"), install = (theme == "vscode") },
    {
        "dstein64/nvim-scrollview",
        config = function()
            require("scrollview").setup({
                excluded_filetypes = { "gitsigns-blame" },
                signs_on_startup = { "diagnostics", "search" },
                signs_max_per_row = 2,
                hide_on_text_intersect = true,
                winblend_gui = 50,
                diagnostics_error_symbol = "═",
                diagnostics_warn_symbol = "═",
                diagnostics_hint_symbol = "═",
                diagnostics_info_symbol = "═",
            })
            require("scrollview.contrib.gitsigns").setup()
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        install = false,
        event = { "FileType qf" },
        config = function()
            require("bqf").setup({
                func_map = {
                    prevfile = "",         -- to filter: :g/pattern/lua require('bqf.qfwin.handler').signToggle(1)
                    nextfile = "",         -- press zn to create new list with marked items
                    pscrolldown = "<C-f>", -- press zN to create new list excluding marked items
                    pscrollup = "<C-b>",   -- press < and > to switch between lists
                    ptoggleitem = "",      -- press z<Tab> to clear marks
                    ptoggleauto = "yop",
                    split = "",
                    vsplit = "",
                    tab = "",
                    tabb = "",
                    fzffilter = "",
                },
            })
        end,
    },
    {
        "stevearc/quicker.nvim",
        install = false,
        event = { "FileType qf" },
        keys = {
            { "n", "yoq", function() require("quicker").toggle() end, { desc = "Toggle quickfix" } },
            { "n", "yol", function() require("quicker").toggle({ loclist = true }) end, { desc = "Toggle loclist" } },
        },
        config = function()
            require("quicker").setup({
                keys = {
                    { "}", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Expand quickfix context" },
                    { "{", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
                    { "zf", "<Cmd>packadd cfilter<CR>:Cfilter! /test/<Left>", desc = "Remove items matching pattern" },
                },
                max_filename_width = function() return math.floor(math.min(95, vim.o.columns / 4)) end,
            })
        end,
    },
    {
        "akinsho/bufferline.nvim",
        event = { "BufEnter" }, -- defer load breaks snacks.nvim dashboard detection
        init = function()       -- prevent text shift during bufferline's internal load
            vim.o.showtabline = 2
            vim.o.tabline = " "
        end,
        keys = {
            { "n", "<BS>", "<Cmd>keepjumps BufferLineCyclePrev<CR>" },
            { "n", "\\", "<Cmd>keepjumps BufferLineCycleNext<CR>" },
            { "n", "<C-w><BS>", "<Cmd>execute 'BufferLineMovePrev' | redraw!<CR><C-w>", { remap = true } },
            { "n", "<C-w>\\", "<Cmd>execute 'BufferLineMoveNext' | redraw!<CR><C-w>", { remap = true } },
            { "n", "Z[", "<Cmd>BufferLineCloseLeft<CR>" },
            { "n", "Z]", "<Cmd>BufferLineCloseRight<CR>" },
        },
        config = function()
            require("bufferline").setup({ highlights = { buffer_selected = { bold = true, italic = false } } })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { statusline = { "snacks_dashboard" } },
                },
                sections = {
                    lualine_a = { function() return "" end },
                    lualine_b = {
                        { "filetype", colored = true, icon_only = true, padding = { left = 1, right = 0 } },
                        { "filename", file_status = false, path = 1 },
                    },
                    lualine_c = {
                        function() return " " .. vim.fn.fnamemodify(assert(vim.uv.cwd()), ":t") end,
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
                        {
                            "diff",
                            symbols = { added = " ", modified = " ", removed = " " },
                            source = function()
                                local status = vim.b.gitsigns_status
                                if status then
                                    status.modified = status.changed
                                    return status
                                end
                            end,
                        },
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
                        function()
                            local clients = vim.tbl_map(function(client) return client.name == "typos_lsp" and "󰼭 " or client.name end, vim.lsp.get_clients({ bufnr = 0 }))
                            return #clients > 0 and table.concat(clients, " ") or ""
                        end,
                    },
                    lualine_y = { { function() return " " .. vim.b.gitsigns_status.head end, padding = { left = 0, right = 1 } } },
                    lualine_z = {
                        { "searchcount", padding = { left = 0, right = 1 } },
                        {
                            function()
                                local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                                return (vim.o.expandtab and " " or " ") .. (vim.o.shiftwidth > 0 and vim.o.shiftwidth or vim.o.tabstop) .. "  " .. (col < 10 and " " .. col or col)
                            end,
                            padding = 0,
                        },
                        { "%l/%L" },
                    },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        { "filetype", colored = true, icon_only = true, padding = { left = 1, right = 0 } },
                        { "filename", file_status = false, path = 1, color = "Normal" },
                    },
                    lualine_x = { { "%l/%L", color = "Normal" } },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },
}
