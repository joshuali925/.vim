local M = {}
local treesitter_hl_enabled = {}

function M.init()
    local config = {
        ensure_installed = {
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
            "bash",
            "lua",
            "json",
            "yaml",
            "python"
        },
        highlight = {
            enable = true,
            disable = {},
            use_languagetree = true
        },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["if"] = "@function.inner",
                    ["af"] = "@function.outer",
                    ["ic"] = "@class.inner",
                    ["ac"] = "@class.outer"
                }
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]]"] = "@function.outer"
                },
                goto_next_end = {
                    ["]["] = "@function.outer"
                },
                goto_previous_start = {
                    ["[["] = "@function.outer"
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer"
                }
            }
        },
        indent = {
            enable = true,
            disable = {"python"}
        },
        -- for nvim-ts-context-commentstring
        context_commentstring = {
            enable = true,
            enable_autocmd = false
        }
    }
    vim.cmd("packadd nvim-treesitter")
    vim.cmd("packadd nvim-treesitter-textobjects")
    local present, treesitter = pcall(require, "nvim-treesitter.configs")
    if present then
        treesitter.setup(config)
        local parsers = config.ensure_installed
        local hl_disabled = config.highlight.disable
        for _, lang in ipairs(parsers) do
            if not vim.tbl_contains(hl_disabled, lang) then
                treesitter_hl_enabled[lang] = true
            end
        end
    end
end

function M.hijack_synset()
    local ft = vim.fn.expand("<amatch>")
    if not treesitter_hl_enabled[ft] then
        vim.opt.syntax = ft
    end
end

return M
