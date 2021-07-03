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
        "vim-wordmotion",
        "vim-fanfingtastic",
        "vim-sandwich",
        "vim-sleuth"
    }
    loader(table.concat(plugins, " "))

    require("lsp")
    vim.cmd [[
    " for lsp-rooter.nvim to change directory
    silent! edit

    " for barbar
    highlight! link BufferVisible BufferInactive
    highlight! link BufferVisibleIndex BufferInactiveIndex
    highlight! link BufferVisibleMod BufferInactiveMod
    highlight! link BufferVisibleSign BufferInactiveSign
    highlight! link BufferVisibleTarget BufferInactiveTarget
    ]]
end

vim.defer_fn(lazyload, 80)
