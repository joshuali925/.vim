if vim.fn.glob(vim.fn.stdpath("config") .. "/lua/packer_compiled.lua") == "" then
    require("plugins").compile()
else
    vim.cmd [[
        command! PackerInstall lua require('plugins').install()
        command! PackerUpdate lua require('plugins').update()
        command! PackerSync lua require('plugins').sync()
        command! PackerClean lua require('plugins').clean()
        command! PackerCompile lua require('plugins').compile()
        command! PackerStatus lua require('plugins').status()
        command! -bang -nargs=+ -complete=customlist,v:lua.require('packer').loader_complete PackerLoad lua require('packer').loader(<f-args>, '<bang>' == '!')
    ]]
    require("packer_compiled")
end
