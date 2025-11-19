-- https://github.com/sxyazi/yazi/issues/2308#issuecomment-2657167974

vim.o.cmdheight = 0
vim.o.laststatus = 0
vim.o.shadafile = "NONE"

vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_create_autocmd("BufEnter", {
    once = true,
    callback = function()
        vim.cmd.startinsert()
        vim.fn.termopen("yazi", { on_exit = function() vim.cmd.quit() end })
    end,
})
