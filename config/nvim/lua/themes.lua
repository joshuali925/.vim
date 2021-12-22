local M = {}
local g = vim.g

M.theme_list = {
    [-1] = "tokyonight.nvim",
    [-2] = "gruvbox-flat.nvim",
    [-3] = "github-nvim-theme",
    [-4] = "vscode.nvim",
    [-5] = "catppuccin",
    [0] = "github-nvim-theme",
    [1] = "tokyonight.nvim"
}
M.theme = M.theme_list[g.theme_index]

local sidebars = {"qf", "terminal", "Outline", "Mundo"}
local default_colors = {
    bg = "#22262e",
    fg = "#abb2bf",
    lightbg = "#2d3139",
    lightbg2 = "#262a32",
    primary = "#7aa2f7",
    secondary = "#9ece6a",
    dim_primary = "#46617a",
    red = "#f7768e",
    yellow = "#e0af68",
    orange = "#ff9e64",
    purple = "#9d7cd8",
    grey = "#6f737b"
}

local themes = {
    ["tokyonight.nvim"] = {
        colors = function()
            return default_colors
        end,
        config = function()
            g.tokyonight_style = g.theme_index < 0 and "storm" or "day"
            g.tokyonight_italic_keywords = false
            g.tokyonight_italic_comments = false
            g.tokyonight_sidebars = sidebars
            g.tokyonight_colors = {comment = "#717993"}
            if g.theme_index >= 0 then
                default_colors.bg = "#cccccc"
                default_colors.fg = "#484e54"
                default_colors.lightbg = "#bbbbbb"
                default_colors.lightbg2 = "#c3c3c3"
                default_colors.primary = "#0366d6"
                default_colors.secondary = "#22863a"
                default_colors.yellow = "#b08800"
                default_colors.orange = "#d18616"
            end
            vim.cmd("colorscheme tokyonight")
        end
    },
    ["gruvbox-flat.nvim"] = {
        colors = function()
            default_colors.bg = "#242400"
            default_colors.primary = "#7daea3"
            default_colors.secondary = "#a9b665"
            default_colors.dim_primary = "#5c6e6a"
            return default_colors
        end,
        config = function()
            g.gruvbox_flat_style = "dark"
            g.gruvbox_sidebars = sidebars
            vim.cmd("colorscheme gruvbox-flat")
        end
    },
    ["github-nvim-theme"] = {
        colors = function()
            if g.theme_index < 0 then
                default_colors.primary = "#3b8eea"
                default_colors.secondary = "#23d18b"
            else
                default_colors.bg = "#eeeeee"
                default_colors.fg = "#484e54"
                default_colors.lightbg = "#cccccc"
                default_colors.lightbg2 = "#dddddd"
                default_colors.primary = "#0366d6"
                default_colors.secondary = "#22863a"
                default_colors.yellow = "#b08800"
                default_colors.orange = "#d18616"
            end
            return default_colors
        end,
        config = function()
            require("github-theme").setup {
                sidebars = sidebars,
                theme_style = g.theme_index < 0 and "dimmed" or "light_default"
            }
        end
    },
    ["vscode.nvim"] = {
        colors = function()
            default_colors.primary = "#3b8eea"
            default_colors.secondary = "#23d18b"
            return default_colors
        end,
        config = function()
            g.vscode_style = "dark"
            vim.cmd("colorscheme vscode")
            vim.cmd("highlight IndentBlanklineChar gui=nocombine guifg=#353535")
        end
    },
    ["catppuccin"] = {
        colors = function()
            default_colors.primary = "#a8b8eb"
            default_colors.secondary = "#bbe2b2"
            return default_colors
        end,
        config = function()
            require("catppuccin").setup {
                term_colors = true,
                integrations = {
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {errors = "NONE", hints = "NONE", warnings = "NONE", information = "NONE"}
                    },
                    gitsigns = true,
                    telescope = true,
                    nvimtree = {enabled = true, show_root = true},
                    indent_blankline = {enabled = true, colored_indent_levels = true},
                    bufferline = true,
                    markdown = false,
                    hop = true
                }
            }
            vim.cmd("colorscheme catppuccin")
        end
    }
}

function M.config()
    themes[M.theme].config()
end

function M.colors()
    return themes[M.theme].colors()
end

return M
