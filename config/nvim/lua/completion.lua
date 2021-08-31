local cmp = require("cmp")

cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
            vim_item.menu =
                ({
                buffer = "[Buffer]",
                nvim_lua = "[Lua]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]"
            })[entry.source.name]
            return vim_item
        end
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping(
            function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n")
                elseif require("luasnip").jumpable(1) then -- not always accurate, put after pumvisible condition
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-next", true, true, true), "")
                else
                    fallback()
                end
            end,
            {"i", "s"}
        ),
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n")
                elseif require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                else
                    fallback()
                end
            end,
            {"i", "s"}
        )
    },
    sources = {
        {name = "buffer"},
        {name = "path"},
        {name = "nvim_lua"},
        {name = "nvim_lsp"},
        {name = "luasnip"}
    }
}
