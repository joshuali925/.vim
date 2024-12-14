local M = {}
local theme_index = vim.g.theme_index or -1

-- check current highlights
-- :S hi
-- :source $VIMRUNTIME/syntax/hitest.vim
M.theme_list = {
    [-1] = "tokyonight",
    [-2] = "catppuccin",
    [-3] = "github",
    [-4] = "kanagawa",
    [-5] = "ayu",
    [-6] = "nightfox",
    [-7] = "newpaper",
    [0] = "tokyonight",
    [1] = "nightfox",
    [2] = "github",
    [3] = "kanagawa",
    [4] = "ayu",
    [5] = "catppuccin",
    [6] = "newpaper",
}
M.theme = M.theme_list[theme_index]

local sidebars = { "qf", "terminal", "Mundo", "neo-tree" }
local themes = {
    ["tokyonight"] = {
        setup = function()
            require("tokyonight").setup({
                style = theme_index < 0 and "storm" or "day",
                styles = { comments = { italic = false }, keywords = { italic = false } },
                day_brightness = 0.2,
                on_colors = function(c)
                    c.comment = "#717993"
                end,
                on_highlights = function(hl, c)
                    hl.LineNr = { fg = c.git.ignore }
                    hl.DiagnosticUnnecessary = { fg = c.comment }
                    hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
                    hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
                    hl.TelescopePromptNormal = { bg = c.bg_highlight }
                    hl.TelescopePromptBorder = { bg = c.bg_highlight, fg = c.bg_highlight }
                    hl.TelescopePromptTitle = { bg = c.blue, fg = c.bg_highlight, bold = true }
                    hl.TelescopePreviewTitle = { bg = c.green, fg = c.bg_highlight, bold = true }
                    hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
                end,
            })
            vim.cmd.colorscheme("tokyonight")
            vim.api.nvim_set_hl(0, "CmpItemKindVariable", { link = "CmpItemKindFunction" })
        end,
    },
    ["github"] = {
        setup = function()
            require("github-theme").setup({ options = { darken = { sidebars = { list = sidebars } } } })
            vim.cmd.colorscheme("github_" .. (theme_index < 0 and "dark_dimmed" or "light_high_contrast"))
        end,
    },
    ["ayu"] = {
        setup = function()
            require("ayu").setup({ overrides = { Comment = { fg = "#69737d" } } })
            vim.cmd.colorscheme("ayu-" .. (theme_index < 0 and "mirage" or "light"))
        end,
    },
    ["catppuccin"] = {
        setup = function()
            require("catppuccin").setup({
                flavour = (theme_index < 0 and "macchiato" or "latte"),
                custom_highlights = { Comment = { fg = "#717993" } },
                no_italic = true,
                integrations = {
                    native_lsp = {
                        underlines = { errors = { "undercurl" }, hints = { "undercurl" }, warnings = { "undercurl" }, information = { "undercurl" } },
                    },
                    telescope = { style = "nvchad" },
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    ["nightfox"] = {
        setup = function()
            require("nightfox").setup({
                palettes = { dayfox = { bg1 = "#f2ede7", bg3 = "#ece6df" } },
                groups = { dayfox = { LspReferenceText = { bg = "#e3dacf" }, LspReferenceRead = { bg = "#e3dacf" }, LspReferenceWrite = { bg = "#e3dacf" } } },
            })
            vim.cmd.colorscheme(theme_index < 0 and "carbonfox" or "dayfox")
        end,
    },
    ["kanagawa"] = {
        setup = function()
            require("kanagawa").setup({ compile = true })
            vim.cmd.colorscheme("kanagawa")
        end,
    },
    ["newpaper"] = {
        setup = function()
            require("newpaper").setup({ style = theme_index < 0 and "dark" or "light" })
        end,
    },
}

local function highlight_plugins()
    if theme_index < 0 then
        vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#3b4261" })
        vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#4f5778" })
        vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = "#ffbe6d" })
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = "#6eb9e6" })
    else
        vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#d4d7d9" })
        vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#c4c8cc" })
        vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = "#916100" })
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = "#005e7d" })
    end
    vim.api.nvim_set_hl(0, "QuickBG", { link = "CursorLine" })               -- quickui
    vim.api.nvim_set_hl(0, "NeoCodeiumSuggestion", { link = "LspCodeLens" }) -- neocodeium
    vim.g.quickui_color_scheme = "papercol-" .. vim.o.background
end

function M.setup()
    vim.o.background = theme_index < 0 and "dark" or "light"
    themes[M.theme].setup()
    highlight_plugins() -- autocmd might not trigger for some colorschemes
end

function M.switch(index)
    local states_file = vim.fn.stdpath("config") .. "/lua/states.lua"
    vim.cmd.call(("writefile(['vim.g.theme_index = %s'] + readfile('%s')[1:], '%s')"):format(index, states_file, states_file))
    vim.g.theme_index = index
    theme_index = index
    M.theme = M.theme_list[index]
    pcall(M.setup) -- ignore errors because the select theme plugin might not be enabled
    pcall(M.setup) -- some plugins like bufferline need a second config call
    vim.notify("Restart to change theme to " .. M.theme .. ".", vim.log.levels.INFO, { annote = "Theme" })
end

return M
