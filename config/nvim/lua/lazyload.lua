local function lazyload()
    local loader = require("packer").loader
    local fname = vim.fn.expand("%:p:f")
    local fsize = vim.fn.getfsize(fname)
    if fsize == nil or fsize < 0 then
        fsize = 1
    end
    if fsize > 6291456 then -- 6MB
        return
    end

    local plugins = {
        "indent-blankline.nvim",
        "nvim-colorizer.lua",
        "plenary.nvim",
        "vim-rhubarb",
        "gitsigns.nvim",
        "conflict-marker.vim",
        "nvim-treesitter",
        "nvim-lspconfig",
        "lsp_signature.nvim",
        "nvim-lspinstall",
        "nvim-ts-context-commentstring",
        "lsp-rooter.nvim",
        "vim-indent-object",
        "quick-scope",
        "vim-fanfingtastic",
        "vim-sandwich",
        "vim-sleuth"
    }
    loader(table.concat(plugins, " "))

    require("lsp")
end

vim.defer_fn(lazyload, 80)
