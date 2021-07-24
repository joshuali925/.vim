if vim.fn.glob(vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua") == "" then
    require("plugins").compile()
else
    vim.cmd [[
        command! PackerInstall lua require('plugins').install()
        command! PackerUpdate lua require('plugins').update()
        command! PackerSync lua require('plugins').sync()
        command! PackerClean lua require('plugins').clean()
        command! PackerCompile lua require('plugins').compile()
        command! PackerStatus lua require('plugins').status()
    ]]
end
