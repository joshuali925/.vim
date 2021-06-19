require("options") --     lua/options.lua     ginit.vim
require("mappings") --    lua/mappings.lua
require("plugins") --     lua/plugins.lua     lua/plugin-configs.lua
require("lazyload") --    lua/lazyload.lua    lua/lsp.lua              lua/completion.lua

vim.fn["init#setup"]() -- autoload/init.vim   autoload/funcs.vim

-- vim: iskeyword=\S
