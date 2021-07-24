local fname = vim.fn.expand("%:p:f")
local fsize = vim.fn.getfsize(fname)
if fsize ~= nil and fsize > 6291456 then -- 6MB
    return
end

vim.schedule(
    function()
        local loader = require("packer").loader
        vim.defer_fn(
            function()
                vim.cmd("syntax enable")
                require("treesitter")
                vim.cmd [[
                    unlet g:did_load_filetypes
                    autocmd! syntaxset
                    autocmd syntaxset FileType * lua require('treesitter').hijack_synset()
                    filetype on
                    doautoall filetypedetect BufRead
                    augroup FormatOptions
                        autocmd!
                        autocmd FileType * setlocal formatoptions=jql
                    augroup END
                ]]
                loader("nvim-lspinstall lsp_signature.nvim")
            end,
            30
        )
        vim.defer_fn(
            function()
                local plugins = {
                    "indent-blankline.nvim",
                    "nvim-colorizer.lua",
                    "plenary.nvim",
                    "gitsigns.nvim",
                    "conflict-marker.vim",
                    "vim-sleuth",
                    "quick-scope",
                    "vim-wordmotion", -- motions/text objects sometimes don't work if loaded on keys
                    "vim-sandwich",
                    "vim-fanfingtastic"
                }
                loader(table.concat(plugins, " "))
            end,
            100
        )
        vim.defer_fn(
            function()
                local plugins = {
                    "nvim-lspconfig", -- load after lspinstall so activates automatically
                    "nvim-ts-context-commentstring",
                    "lsp-rooter.nvim"
                }
                loader(table.concat(plugins, " "))
            end,
            200
        )
    end
)
