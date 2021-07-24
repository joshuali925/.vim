local M = {}
local do_sy_tbl = {}

local function init()
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
    require("nvim-treesitter.configs").setup(config)
    local parsers = require("nvim-treesitter.parsers")
    local hl_disabled = config.highlight.disable
    for lang in pairs(parsers.list) do
        if not vim.tbl_contains(hl_disabled, lang) then
            do_sy_tbl[lang] = true
        end
    end
end

function M.hijack_synset()
    local ft = vim.fn.expand("<amatch>")
    if not do_sy_tbl[ft] then
        vim.opt.syntax = ft
    end
end

init()

return M
