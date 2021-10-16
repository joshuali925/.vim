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
                local plugins = {
                    "nvim-treesitter",
                    "nvim-treesitter-textobjects",
                    "nvim-lsp-installer"
                }
                loader(table.concat(plugins, " "))
            end,
            30
        )
        vim.defer_fn(
            function()
                local plugins = {
                    "indent-blankline.nvim",
                    "plenary.nvim",
                    "gitsigns.nvim",
                    "conflict-marker.vim",
                    "vim-sleuth",
                    "quick-scope",
                    "vim-wordmotion", -- motions/text objects sometimes don't work if loaded on keys
                    "vim-sandwich",
                    "vim-fanfingtastic",
                    "vim-matchup"
                }
                loader(table.concat(plugins, " "))
            end,
            100
        )
        vim.defer_fn(
            function()
                local plugins = {
                    "nvim-lspconfig", -- load after lsp-installer so it activates automatically
                    "nvim-ts-context-commentstring",
                    "project.nvim"
                }
                loader(table.concat(plugins, " "))
                vim.cmd("silent! ProjectRoot") -- run again in case no lsp active
            end,
            200
        )
    end
)
