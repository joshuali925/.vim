local M = {}

-- check current highlights
-- :S hi
-- :source $VIMRUNTIME/syntax/hitest.vim
M.theme_list = {
    [-1] = "tokyonight.nvim",
    [-2] = "gruvbox-flat.nvim",
    [-3] = "github-nvim-theme",
    [-4] = "vscode.nvim",
    [-5] = "neovim-ayu",
    [-6] = "nightfox.nvim",
    [0] = "github-nvim-theme",
    [1] = "tokyonight.nvim",
    [2] = "nightfox.nvim",
    [3] = "vscode.nvim",
    [4] = "neovim-ayu",
}
M.theme = M.theme_list[vim.g.theme_index]

local sidebars = { "qf", "terminal", "aerial", "Mundo", "NvimTree" }
local default_colors = {
    dim_primary = "#46617a",
    red = "#f7768e",
    purple = "#9d7cd8",
    grey = "#6f737b",
}
if vim.g.theme_index < 0 then
    default_colors.bg = "#22262e"
    default_colors.fg = "#abb2bf"
    default_colors.lightbg = "#2d3139"
    default_colors.lightbg2 = "#262a32"
    default_colors.primary = "#7aa2f7"
    default_colors.secondary = "#9ece6a"
    default_colors.yellow = "#e0af68"
    default_colors.orange = "#ff9e64"
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

local themes = {
    ["tokyonight.nvim"] = {
        colors = function()
            if vim.g.theme_index >= 0 then
                default_colors.bg = "#cccccc"
                default_colors.lightbg = "#bbbbbb"
                default_colors.lightbg2 = "#c3c3c3"
            end
            return default_colors
        end,
        config = function()
            vim.g.tokyonight_style = vim.g.theme_index < 0 and "storm" or "day"
            vim.g.tokyonight_italic_keywords = false
            vim.g.tokyonight_italic_comments = false
            vim.g.tokyonight_sidebars = sidebars
            vim.g.tokyonight_colors = { comment = "#717993" }
            vim.cmd("colorscheme tokyonight")
        end,
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
            vim.g.gruvbox_flat_style = "dark"
            vim.g.gruvbox_sidebars = sidebars
            vim.cmd("colorscheme gruvbox-flat")
            -- https://github.com/eddyekofo94/gruvbox-flat.nvim/issues/21
            vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#808080" })
            vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#7c6f64" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#ea6962" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#ea6962" })
            vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9da85f" })
            vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#9da85f" })
            vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9da85f" })
            vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#7daea3" })
            vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#7daea3" })
            vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#d4d4d4" })
            vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#d4d4d4" })
        end,
    },
    ["github-nvim-theme"] = {
        colors = function()
            if vim.g.theme_index < 0 then
                default_colors.primary = "#3b8eea"
                default_colors.secondary = "#23d18b"
            end
            return default_colors
        end,
        config = function()
            require("github-theme").setup({
                sidebars = sidebars,
                theme_style = vim.g.theme_index < 0 and "dimmed" or "light",
            })
        end,
    },
    ["vscode.nvim"] = {
        colors = function()
            if vim.g.theme_index < 0 then
                default_colors.primary = "#3b8eea"
                default_colors.secondary = "#23d18b"
            end
            return default_colors
        end,
        config = function()
            vim.g.vscode_style = (vim.g.theme_index < 0 and "dark" or "light")
            vim.cmd("colorscheme vscode")
            if vim.g.theme_index < 0 then
                vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#353535" })
            end
        end,
    },
    ["nightfox.nvim"] = {
        colors = function()
            default_colors.secondary = "#8bb19c"
            if vim.g.theme_index < 0 then
                default_colors.primary = "#7a9bd1"
            else
                default_colors.bg = "#ede8e2"
                default_colors.primary = "#65929d"
            end
            return default_colors
        end,
        config = function()
            vim.cmd("colorscheme " .. (vim.g.theme_index < 0 and "nordfox" or "dawnfox"))
        end,
    },
    ["neovim-ayu"] = {
        colors = function()
            default_colors.secondary = "#bae67e"
            if vim.g.theme_index < 0 then
                default_colors.primary = "#4cb9cf"
            else
                default_colors.primary = "#6ebfda"
            end
            return default_colors
        end,
        config = function()
            require("ayu").setup({ overrides = { Comment = { fg = "#69737d" } } })
            vim.cmd("colorscheme ayu-" .. (vim.g.theme_index < 0 and "mirage" or "light"))
            vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#30364f" })
            vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#30364f" })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#30364f" })
        end,
    },
}

function M.config()
    themes[M.theme].config()
end

function M.colors()
    return themes[M.theme].colors and themes[M.theme].colors() or default_colors
end

function M.switch(index)
    local states_file = vim.fn.stdpath("config") .. "/lua/states.lua"
    vim.cmd(('call writefile(["vim.g.theme_index = %s"] + readfile("%s")[1:], "%s")'):format(index, states_file, states_file))
    vim.g.theme_index = index
    vim.opt.background = index < 0 and "dark" or "light"
    vim.g.quickui_color_scheme = "papercol-" .. vim.o.background
    M.theme = M.theme_list[index]
    M.config()
    vim.notify("Restart to change theme to " .. M.theme .. ".")
end

return M
