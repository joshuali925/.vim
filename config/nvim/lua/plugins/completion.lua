return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({ ignored_next_char = [=[[%w%%%'%[%"%.%(%{%/]]=], fast_wrap = { map = "<C-l>" } })
            local Rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")
            local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
            npairs.add_rules({
                Rule(" ", " ")
                    :with_pair(function(opts)
                        local pair = opts.line:sub(opts.col - 1, opts.col)
                        return vim.tbl_contains({
                            brackets[1][1] .. brackets[1][2],
                            brackets[2][1] .. brackets[2][2],
                            brackets[3][1] .. brackets[3][2],
                        }, pair)
                    end)
                    :with_move(cond.none())
                    :with_cr(cond.none())
                    :with_del(function(opts)
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        local context = opts.line:sub(col - 1, col + 2)
                        return vim.tbl_contains({
                            brackets[1][1] .. "  " .. brackets[1][2],
                            brackets[2][1] .. "  " .. brackets[2][2],
                            brackets[3][1] .. "  " .. brackets[3][2],
                        }, context)
                    end),
            })
            for _, bracket in ipairs(brackets) do
                Rule("", " " .. bracket[2])
                    :with_pair(cond.none())
                    :with_move(function(opts) return opts.char == bracket[2] end)
                    :with_cr(cond.none())
                    :with_del(cond.none())
                    :use_key(bracket[2])
            end
        end,
    },
    {
        "monkoose/neocodeium",
        event = "InsertEnter",
        enabled = vim.env.ENABLE_CODEIUM ~= nil,
        config = function()
            vim.keymap.set("i", "<Right>", function()
                if require("neocodeium").visible() then return require("neocodeium").accept() end
                vim.api.nvim_feedkeys(vim.keycode("<Right>"), "n", false)
            end)
            vim.keymap.set("i", "<Down>", function()
                if require("neocodeium").visible() then return require("neocodeium").cycle(1) end
                vim.api.nvim_feedkeys(vim.keycode("<Down>"), "n", false)
            end)
            vim.keymap.set("i", "<Up>", function()
                if require("neocodeium").visible() then return require("neocodeium").cycle(-1) end
                vim.api.nvim_feedkeys(vim.keycode("<Up>"), "n", false)
            end)
            require("neocodeium").setup({ filetypes = require("states").qs_disabled_filetypes, silent = true, debounce = true })
        end,
    },
    {
        "saghen/blink.cmp",
        version = "*",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = require("states").small_file,
        dependencies = {
            "rafamadriz/friendly-snippets",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                config = function() -- vscode snippets: $HOME/Library/ApplicationSupport/Code/User/snippets
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.expand("~/.vim/config/snippets") } })
                end,
            },
        },
        opts = {
            snippets = {
                expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
                active = function(filter)
                    if filter and filter.direction then return require("luasnip").jumpable(filter.direction) end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction) require("luasnip").jump(direction) end,
            },
            sources = { default = { "lsp", "path", "luasnip", "buffer" } },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 150 },
                list = { selection = function(ctx) return ctx.mode == "cmdline" and "auto_insert" or "preselect" end },
            },
            keymap = {
                preset = "enter",
                ["<C-space>"] = { function(cmp) cmp.show({ providers = { "lsp" } }) end },
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<C-k>"] = {
                    function(cmp)
                        if cmp.snippet_active() then return cmp.snippet_forward() end
                        return cmp.select_and_accept()
                    end,
                    "fallback",
                },
                cmdline = {
                    preset = "default",
                    ["<Tab>"] = { function(cmp) if vim.fn.getcmdtype() == ":" then return cmp.select_next() end end, "fallback" },
                    ["<S-Tab>"] = { function(cmp) if vim.fn.getcmdtype() == ":" then return cmp.select_prev() end end, "fallback" },
                },
            },
            appearance = {
                kind_icons = {
                    Text = " ", -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-codicons-to-the-menu
                    Method = " ",
                    Function = " ",
                    Constructor = " ",
                    Field = " ",
                    Variable = " ",
                    Class = " ",
                    Interface = " ",
                    Module = " ",
                    Property = " ",
                    Unit = " ",
                    Value = " ",
                    Enum = " ",
                    Keyword = " ",
                    Snippet = " ",
                    Color = " ",
                    File = " ",
                    Reference = " ",
                    Folder = " ",
                    EnumMember = " ",
                    Constant = " ",
                    Struct = " ",
                    Event = " ",
                    Operator = " ",
                    TypeParameter = " ",
                },
            },
        },
    },
}
