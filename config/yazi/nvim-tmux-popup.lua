-- https://github.com/sxyazi/yazi/issues/2308#issuecomment-2657167974

vim.o.cmdheight = 0
vim.o.laststatus = 0
vim.o.shadafile = "NONE"
vim.api.nvim_set_hl(0, "Normal", { fg = "None", bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local args = vim.fn.argv()
        table.insert(args, 1, "yazi")
        vim.cmd.startinsert()
        vim.fn.termopen(args, { on_exit = function() vim.cmd.quit() end })
    end,
})
