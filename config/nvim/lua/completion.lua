local cmp = require("cmp")

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
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
                vsnip = "[Vsnip]"
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
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn.call("vsnip#jumpable", {1}) == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "")
                else
                    fallback()
                end
            end,
            {"i", "s"}
        ),
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "")
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
        {name = "vsnip"}
    }
}
