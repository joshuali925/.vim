local fname = vim.fn.expand("%:p:f")
local fsize = vim.fn.getfsize(fname)
if fsize ~= nil and fsize > 6291456 then -- 6MB
    return
end

local loader = require("packer").loader
vim.notify = function(...)
    loader("nvim-notify")
    vim.notify = require("notify")
    vim.notify(...)
end

vim.schedule(
    function()
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
                    "vim-indent-object",
                    "vim-fanfingtastic",
                    "vim-matchup"
                }
                loader(table.concat(plugins, " "))
            end,
            100
        )
    end
)
