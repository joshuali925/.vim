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
                -- https://github.com/kevinhwang91/dotfiles/blob/da97fbe354931d440b0ff12215de67a8233ce319/nvim/init.lua#L499
                vim.cmd("syntax enable")
                require("treesitter").init()
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
                    "popup.nvim",
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
                    "project.nvim"
                }
                loader(table.concat(plugins, " "))
                vim.cmd("ProjectRoot") -- run again in case no lsp active
            end,
            200
        )
    end
)
