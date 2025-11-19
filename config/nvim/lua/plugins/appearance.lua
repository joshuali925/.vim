local theme = require("themes").theme
return {
    { "folke/tokyonight.nvim", priority = 1000, enabled = theme == "tokyonight" },
    { "projekt0n/github-nvim-theme", priority = 1000, enabled = theme == "github" },
    { "Shatur/neovim-ayu", priority = 1000, enabled = theme == "ayu" },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, enabled = theme == "catppuccin" },
    { "EdenEast/nightfox.nvim", priority = 1000, enabled = theme == "nightfox" },
    { "rebelot/kanagawa.nvim", priority = 1000, enabled = theme == "kanagawa" },
    { "Mofiqul/vscode.nvim", priority = 1000, enabled = theme == "vscode" },
    {
        "folke/noice.nvim",
        event = "VeryLazy", -- VeryLazy causes flicker on startup, synchronized loading causes flicker on opening a file, delay loading causes small flicker to both
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
            require("scrollview").setup({
                excluded_filetypes = { "gitsigns-blame" },
                signs_on_startup = { "diagnostics", "search" },
                signs_max_per_row = 2,
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
        ft = "qf",
        opts = {
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
                { "<C-k>", "<C-w>p" },
                { "}", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Expand quickfix context" },
                { "{", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
                { "zf", "<Cmd>packadd cfilter<CR>:Cfilter! /test/<Left>", desc = "Remove items matching pattern" },
            },
            max_filename_width = function() return math.floor(math.min(95, vim.o.columns / 4)) end,
        },
    },
    {
        "akinsho/bufferline.nvim",
        event = "BufEnter", -- VimEnter/UIEnter breaks '+<line>' argument in command line nvim when 'line' is large
        init = function()   -- prevent text shift on bufferline load
            vim.o.showtabline = 2
            vim.o.tabline = " "
        end,
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
        opts = {
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
                        local clients = vim.tbl_filter(function(name) return not vim.tbl_contains({ "amazonq-completion" }, name) end, vim.tbl_map(function(client)
                            return client.name == "amazonq" and " " or client.name == "typos_lsp" and "󰼭 " or client.name
                        end, vim.lsp.get_clients({ bufnr = 0 })))
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
        },
    },
}
