local M = {}
local theme_index = vim.g.theme_index or -1

-- check current highlights
-- :S hi
-- :source $VIMRUNTIME/syntax/hitest.vim
M.theme_list = {
    [ -1] = "tokyonight.nvim",
    [ -2] = "github-nvim-theme",
    [ -3] = "visual_studio_code",
    [ -4] = "neovim-ayu",
    [ -5] = "catppuccin",
    [0] = "tokyonight.nvim",
    [1] = "github-nvim-theme",
    [2] = "visual_studio_code",
    [3] = "neovim-ayu",
    [4] = "catppuccin",
}
M.theme = M.theme_list[theme_index]

local sidebars = { "qf", "terminal", "lspsagaoutline", "Mundo", "NvimTree" }
local themes = {
    ["tokyonight.nvim"] = {
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
        config = function()
            require("github-theme").setup({
                sidebars = sidebars,
                theme_style = theme_index < 0 and "dimmed" or "light",
            })
            vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = theme_index < 0 and "#4d5462" or "#bbbbbb" })
        end,
    },
    ["visual_studio_code"] = {
        config = function()
            require("visual_studio_code").setup({ mode = theme_index < 0 and "dark" or "light" })
            if theme_index < 0 then
                vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#353535" })
                vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#4a4a4a" })
                require("visual_studio_code.utils").hl.set("CursorLine", { bg = "#282828"})
            end
        end,
    },
    ["neovim-ayu"] = {
        config = function()
            require("ayu").setup({ overrides = { Comment = { fg = "#69737d" } } })
            vim.cmd.colorscheme("ayu-" .. (theme_index < 0 and "mirage" or "light"))
            vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#30364f" })
            vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#30364f" })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#30364f" })
        end,
    },
    ["catppuccin"] = {
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
