-- https://github.com/sxyazi/yazi/issues/2308#issuecomment-2657167974

vim.loader.enable()
vim.g.loaded_remote_plugins = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.o.cmdheight = 0
vim.o.laststatus = 0
vim.o.shortmess = vim.o.shortmess .. "I"
vim.o.loadplugins = false
vim.o.shadafile = "NONE"
vim.o.swapfile = false

vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_create_autocmd("BufEnter", {
    once = true,
    callback = function()
        vim.cmd.startinsert()
        vim.fn.jobstart({ "yazi", "--cwd-file=" .. vim.env.HOME .. "/.vim/tmp/last_result" }, { term = true, on_exit = function() vim.cmd.quit() end })
    end,
})
