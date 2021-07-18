local function lazyload()
    local fname = vim.fn.expand("%:p:f")
    local fsize = vim.fn.getfsize(fname)
    if fsize ~= nil and fsize > 6291456 then -- 6MB
        return
    end

    local loader = require("packer").loader
    local plugins = {
        "indent-blankline.nvim",
        "nvim-colorizer.lua",
        "plenary.nvim",
        "gitsigns.nvim",
        "conflict-marker.vim",
        "nvim-lspconfig",
        "nvim-treesitter",
        "lsp_signature.nvim",
        "nvim-lspinstall",
        "nvim-ts-context-commentstring",
        "lsp-rooter.nvim",
        "quick-scope",
        "vim-sandwich", -- cs/ds/ab doesn't work when loaded by keys
        "vim-sleuth"
    }
    loader(table.concat(plugins, " "))
    require("lsp")
    vim.cmd("silent! edit") -- for lsp and lsp-rooter.nvim
end

vim.schedule(function ()
    vim.defer_fn(lazyload, 80)
end)
