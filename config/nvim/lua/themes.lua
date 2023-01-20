local M = {}
local theme_index = vim.g.theme_index or -1

-- check current highlights
-- :S hi
-- :source $VIMRUNTIME/syntax/hitest.vim
M.theme_list = {
    [-1] = "tokyonight.nvim",
    [-2] = "github-nvim-theme",
    [-3] = "vscode.nvim",
    [-4] = "neovim-ayu",
    [-5] = "catppuccin",
    [0] = "tokyonight.nvim",
    [1] = "github-nvim-theme",
    [2] = "vscode.nvim",
    [3] = "neovim-ayu",
    [4] = "catppuccin",
}
M.theme = M.theme_list[theme_index]

local sidebars = { "qf", "terminal", "lspsagaoutline", "Mundo", "NvimTree" }
local default_colors = {
    dim_primary = "#46617a",
    red = "#f7768e",
    purple = "#9d7cd8",
    grey = "#6f737b",
}
if theme_index < 0 then
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
            if theme_index >= 0 then
                default_colors.bg = "#cccccc"
                default_colors.lightbg = "#bbbbbb"
                default_colors.lightbg2 = "#c3c3c3"
            end
            return default_colors
        end,
        config = function()
            require("tokyonight").setup({
                style = theme_index < 0 and "storm" or "day",
                styles = { comments = "NONE", keywords = "NONE" },
                sidebars = sidebars,
                on_colors = function(colors)
                    colors.comment = "#717993"
                end,
            })
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    ["github-nvim-theme"] = {
        colors = function()
            if theme_index < 0 then
                default_colors.primary = "#3b8eea"
                default_colors.secondary = "#23d18b"
            end
            return default_colors
        end,
        config = function()
            require("github-theme").setup({
                sidebars = sidebars,
                theme_style = theme_index < 0 and "dimmed" or "light",
            })
            vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = theme_index < 0 and "#4d5462" or "#bbbbbb" })
        end,
    },
    ["vscode.nvim"] = {
        colors = function()
            if theme_index < 0 then
                default_colors.primary = "#3b8eea"
                default_colors.secondary = "#23d18b"
            end
            return default_colors
        end,
        config = function()
            vim.cmd.colorscheme("vscode")
            if theme_index < 0 then
                vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#353535" })
                vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#4a4a4a" })
            end
        end,
    },
    ["neovim-ayu"] = {
        colors = function()
            default_colors.secondary = "#bae67e"
            if theme_index < 0 then
                default_colors.primary = "#4cb9cf"
            else
                default_colors.primary = "#6ebfda"
            end
            return default_colors
        end,
        config = function()
            require("ayu").setup({ overrides = { Comment = { fg = "#69737d" } } })
            vim.cmd.colorscheme("ayu-" .. (theme_index < 0 and "mirage" or "light"))
            vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#30364f" })
            vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#30364f" })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#30364f" })
        end,
    },
    ["catppuccin"] = {
        colors = function()
            default_colors.secondary = "#bbe2b2"
            if theme_index < 0 then
                default_colors.primary = "#a8b8eb"
            else
                default_colors.primary = "#1e66f5"
            end
            return default_colors
        end,
        config = function()
            require("catppuccin").setup({
                flavour = (theme_index < 0 and "macchiato" or "latte"),
                custom_highlights = { Comment = { fg = "#717993" } },
                integrations = {
                    native_lsp = {
                        underlines = { errors = { "undercurl" }, hints = { "undercurl" }, warnings = { "undercurl" }, information = { "undercurl" } },
                    },
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}

local function highlight_plugins()
    if theme_index < 0 then
        vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#3b4261" })
        vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#4f5778" })
        vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { bg = "#427266" })
        vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { bg = "#364f49" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestors", { bg = "#383838" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestorsHunk", { bg = "#282828" })
        vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { bg = "#3a4f67" })
        vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { bg = "#234a78" })
        vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = "#ffbe6d" })
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = "#6eb9e6" })
    else
        vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#d4d7d9" })
        vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#c4c8cc" })
        vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { bg = "#7ed9ae" })
        vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { bg = "#94ffcc" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestors", { bg = "#bfbfbf" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestorsHunk", { bg = "#e5e5e5" })
        vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { bg = "#b9d1fa" })
        vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { bg = "#86abeb" })
        vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = "#bf8000" })
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = "#005e7d" })
    end
end

function M.config()
    vim.o.background = theme_index < 0 and "dark" or "light"
    vim.g.quickui_color_scheme = "papercol-" .. vim.o.background
    vim.api.nvim_create_augroup("PluginsHighlights", {})
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", group = "PluginsHighlights", callback = highlight_plugins })
    themes[M.theme].config()
end

function M.colors()
    return themes[M.theme].colors and themes[M.theme].colors() or default_colors
end

function M.switch(index)
    local states_file = vim.fn.stdpath("config") .. "/lua/states.lua"
    vim.cmd.call(('writefile(["vim.g.theme_index = %s"] + readfile("%s")[1:], "%s")'):format(index, states_file, states_file))
    vim.g.theme_index = index
    theme_index = index
    M.theme = M.theme_list[index]
    require("lazy").load({ plugins = M.theme })
    M.config()
    vim.notify("Restart to change theme to " .. M.theme .. ".", "INFO", { title = "Theme" })
end

return M
