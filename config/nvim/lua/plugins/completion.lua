return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-vsnip",
            "rafamadriz/friendly-snippets",
            {
                "hrsh7th/vim-vsnip",
                init = function()
                    vim.g.vsnip_snippet_dir = vim.fn.expand("~/.vim/config/snippets") -- vscode snippets: $HOME/Library/ApplicationSupport/Code/User/snippets
                    vim.g.vsnip_filetypes = { zsh = { "sh" }, typescript = { "javascript" }, typescriptreact = { "javascript", "typescript" } }
                end,
            },
            {
                "windwp/nvim-autopairs",
                config = function()
                    local npairs = require("nvim-autopairs")
                    npairs.setup({ ignored_next_char = [=[[%w%%%'%[%"%.%(%{%/]]=], fast_wrap = { map = "<C-l>" } })
                    require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
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
                                    brackets[3][1] .. brackets[3][2]
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
                                    brackets[3][1] .. "  " .. brackets[3][2]
                                }, context)
                            end)
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
        },
        cond = require("states").small_file,
        config = function()
            local cmp = require("cmp")
            vim.o.pumblend = 8
            local cmp_kinds = {
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
            }
            cmp.setup({
                completion = { completeopt = "menuone,noselect" },
                snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
                window = {
                    completion = vim.tbl_extend("force", require("cmp").config.window.bordered({ border = "single" }), { col_offset = -4 }),
                    documentation = cmp.config.window.bordered({ border = "single" }),
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(_, vim_item)
                        vim_item.menu = vim_item.kind
                        vim_item.kind = cmp_kinds[vim_item.kind] or ""
                        return vim_item
                    end,
                },
                mapping = {
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        if vim.fn["vsnip#expandable"]() == 1 then
                            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand)", true, true, true), "")
                        elseif vim.fn.call("vsnip#jumpable", { 1 }) == 1 then
                            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "")
                        elseif require("neogen").jumpable() then
                            require("neogen").jump_next()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<Down>"] = cmp.mapping.select_next_item({ behavior = require("cmp.types").cmp.SelectBehavior.Select }),
                    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = require("cmp.types").cmp.SelectBehavior.Select }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn.call("vsnip#jumpable", { 1 }) == 1 then
                            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "")
                        elseif require("neogen").jumpable() then
                            require("neogen").jump_next()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
                            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "")
                        elseif require("neogen").jumpable(-1) then
                            require("neogen").jump_prev()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "vsnip" },
                    { name = "path" },
                    { name = "nvim_lua" },
                    {
                        name = "buffer",
                        option = {
                            get_bufnrs = function()
                                local buffers = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    buffers[vim.api.nvim_win_get_buf(win)] = true -- visible buffers only
                                end
                                return vim.tbl_filter(function(buffer)
                                    return vim.api.nvim_buf_get_offset(buffer, vim.api.nvim_buf_line_count(buffer)) < require("states").size_threshold
                                end, vim.tbl_keys(buffers))
                            end,
                        },
                    },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            })
        end,
    },
}
