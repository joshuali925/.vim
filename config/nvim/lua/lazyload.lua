local function lazyload()
    local loader = require("packer").loader

    vim.cmd [[
    " for barbar
    highlight! link BufferVisible BufferInactive
    highlight! link BufferVisibleIndex BufferInactiveIndex
    highlight! link BufferVisibleMod BufferInactiveMod
    highlight! link BufferVisibleSign BufferInactiveSign
    highlight! link BufferVisibleTarget BufferInactiveTarget
    ]]

    if not vim.g.IsFileSmall then
        return
    end

    local plugins = {
        "indent-blankline.nvim",
        "nvim-colorizer.lua",
        "plenary.nvim",
        "vim-rhubarb",
        "gitsigns.nvim",
        "conflict-marker.vim",
        "nvim-lspconfig",
        "lsp_signature.nvim",
        "nvim-lspinstall",
        "nvim-ts-context-commentstring",
        "lsp-rooter.nvim",
        "vim-indent-object",
        "quick-scope",
        "vim-wordmotion",
        "vim-fanfingtastic",
        "vim-sleuth"
    }
    loader(table.concat(plugins, " "))

    require("lsp")

    local saved_view = vim.fn.winsaveview()
    vim.cmd("silent! edit") -- for lsp and lsp-rooter.nvim
    vim.fn.winrestview(saved_view)
end

vim.defer_fn(lazyload, 80)
