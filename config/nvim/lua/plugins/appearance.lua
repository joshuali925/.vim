local curr_theme = require("themes").theme
local config_theme = require("themes").config

return {
    { "folke/tokyonight.nvim", lazy = curr_theme ~= "tokyonight.nvim", config = config_theme },
    { "projekt0n/github-nvim-theme", lazy = curr_theme ~= "github-nvim-theme", config = config_theme },
    { "Mofiqul/vscode.nvim", lazy = curr_theme ~= "vscode.nvim", config = config_theme },
    { "Shatur/neovim-ayu", lazy = curr_theme ~= "neovim-ayu", config = config_theme },
    { "catppuccin/nvim", name = "catppuccin", lazy = curr_theme ~= "catppuccin", config = config_theme },
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
            { "<BS>", "<Cmd>BufferLineCyclePrev<CR>" },
            { "\\", "<Cmd>BufferLineCycleNext<CR>" },
            { "<C-w><BS>", "<Cmd>BufferLineMovePrev<CR><C-w>", remap = true },
            { "<C-w>\\", "<Cmd>BufferLineMoveNext<CR><C-w>", remap = true },
            { "Z[", "<Cmd>BufferLineCloseLeft<CR>" },
            { "Z]", "<Cmd>BufferLineCloseRight<CR>" },
        },
        opts = {
            -- options = { offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory" } } }, -- taking too much space
            highlights = { buffer_selected = { bold = true, italic = false } },
        },
    },
    {
        "feline-nvim/feline.nvim",
        event = "VimEnter",
        config = function()
            local lsp = require("feline.providers.lsp")
            local colors = require("themes").colors()
            local mode_colors = {
                n = colors.primary,
                i = colors.secondary,
                v = colors.purple,
                V = colors.purple,
                [string.char(22)] = colors.purple, -- ^V
                c = colors.yellow,
                s = colors.orange,
                S = colors.orange,
                [string.char(19)] = colors.orange, -- ^S
                R = colors.orange,
                Rv = colors.orange,
                t = colors.red,
            }
            local function checkwidth() return vim.api.nvim_win_get_width(0) > 60 end

            local components = { active = { {}, {}, {} }, inactive = { {}, {}, {} } }
            components.active[1][1] = {
                provider = "  ",
                hl = function() return { fg = colors.lightbg, bg = mode_colors[vim.fn.mode()] or colors.primary } end,
                right_sep = { str = " ", hl = function() return { fg = mode_colors[vim.fn.mode()] or colors.primary, bg = colors.lightbg } end },
            }
            components.active[1][2] = {
                provider = function() return " " .. vim.fn.expand("%:~:.") .. " " end,
                icon = function()
                    local icon, color = require("nvim-web-devicons").get_icon_color(vim.fn.expand("%:t"), vim.fn.expand("%:e"))
                    return { str = icon or " ", hl = { fg = color or colors.primary } }
                end,
                hl = { fg = colors.fg, bg = colors.lightbg },
                right_sep = { str = " ", hl = { fg = colors.lightbg, bg = colors.lightbg2 } },
            }
            components.active[1][3] = {
                provider = function() return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " " end,
                hl = { fg = colors.grey, bg = colors.lightbg2 },
                right_sep = { str = " ", hi = { fg = colors.lightbg2 } },
            }
            components.active[1][4] = {
                provider = function()
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
                hl = { fg = colors.grey },
            }
            components.active[1][5] = {
                provider = "git_diff_added",
                enabled = checkwidth,
                hl = { fg = colors.grey },
                icon = "  ",
            }
            components.active[1][6] = {
                provider = "git_diff_changed",
                enabled = checkwidth,
                hl = { fg = colors.grey },
                icon = "  ",
            }
            components.active[1][7] = {
                provider = "git_diff_removed",
                enabled = checkwidth,
                hl = { fg = colors.grey },
                icon = "  ",
            }
            components.active[1][8] = {
                provider = "diagnostic_errors",
                enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR) end,
                hl = { fg = colors.red },
                icon = "  ",
            }
            components.active[1][9] = {
                provider = "diagnostic_warnings",
                enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.WARN) end,
                hl = { fg = colors.yellow },
                icon = "  ",
            }
            components.active[1][10] = {
                provider = "diagnostic_hints",
                enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.HINT) end,
                hl = { fg = colors.grey },
                icon = "  ",
            }
            components.active[1][11] = {
                provider = "diagnostic_info",
                enabled = function() return lsp.diagnostics_exist(vim.diagnostic.severity.INFO) end,
                hl = { fg = colors.secondary },
                icon = "  ",
            }
            components.active[2][1] = {
                provider = function()
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
                enabled = checkwidth,
                hl = { fg = colors.secondary },
            }
            components.active[3][1] = { provider = "search_count", hl = { fg = colors.secondary }, right_sep = { str = " " } }
            components.active[3][2] = { provider = "macro", hl = { fg = colors.orange }, right_sep = { str = " " } }
            components.active[3][3] = { provider = "lsp_client_names", enabled = checkwidth, hl = { fg = colors.grey } }
            components.active[3][4] = {
                provider = "git_branch",
                enabled = checkwidth,
                hl = { fg = colors.grey, bg = colors.lightbg },
                icon = " ",
                left_sep = { str = " ", hl = { fg = colors.lightbg } },
            }
            components.active[3][5] = {
                provider = function()
                    local untildone_count = require("states").untildone_count
                    if untildone_count > 0 then
                        return untildone_count == 1 and "ﯩ " or untildone_count .. " "
                    else
                        return " "
                    end
                end,
                hl = { fg = colors.lightbg, bg = colors.primary },
                left_sep = { str = " ", hl = { fg = colors.primary, bg = colors.lightbg } },
            }
            components.active[3][6] = {
                provider = function()
                    local col = vim.fn.col(".")
                    return (col < 10 and "  " or " ") .. col
                end,
                hl = { fg = colors.secondary, bg = colors.lightbg },
            }
            components.active[3][7] = {
                provider = function() return string.format(" %s/%s", vim.fn.line("."), vim.fn.line("$")) end,
                hl = { fg = colors.primary, bg = colors.lightbg },
            }
            components.inactive[1][1] = {
                provider = "  ",
                hl = { fg = colors.lightbg, bg = colors.dim_primary },
                right_sep = { str = " ", hl = { fg = colors.dim_primary, bg = colors.lightbg } },
            }
            components.inactive[1][2] = components.active[1][2]
            components.inactive[3][1] = {
                provider = function() return string.format("%s/%s", vim.fn.line("."), vim.fn.line("$")) end,
                hl = { fg = colors.dim_primary },
            }
            require("feline").setup({ theme = { fg = colors.fg, bg = colors.bg }, components = components })
            require("feline").winbar.setup()
        end,
    },
}
