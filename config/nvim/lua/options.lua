local g = vim.g
local opt = vim.opt

g.did_load_filetypes = 1
vim.cmd("syntax off")
g.loaded_matchparen = 1
g.loaded_matchit = 1
g.loaded_2html_plugin = 1
g.loaded_remote_plugins = 1
g.loaded_tutor_mode_plugin = 1

g.mapleader = ";"
-- need this PR to replace netrw https://github.com/kyazdani42/nvim-tree.lua/pull/288
g.netrw_dirhistmax = 0
g.netrw_banner = 0
g.netrw_liststyle = 3
g.markdown_fenced_languages = {"javascript", "js=javascript", "css", "html", "python", "java", "c", "bash=sh"}

opt.whichwrap = "b,s,<,>,[,]"
opt.termguicolors = true
opt.mouse = "a"
opt.cursorline = true
opt.numberwidth = 2
opt.number = true
opt.wrap = true
opt.linebreak = true
opt.showmatch = true
opt.showmode = false
opt.title = true
opt.showtabline = 2
opt.diffopt = opt.diffopt + {"vertical", "indent-heuristic", "algorithm:patience"}
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.autoindent = true
opt.smarttab = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.textwidth = 0
opt.hidden = true
opt.complete = {".", "w", "b", "u"}
opt.completeopt = {"menuone", "noselect"}
opt.completefunc = "funcs#complete_word"
opt.shortmess = opt.shortmess + {c = true}
opt.shortmess = opt.shortmess - {S = true}
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.signcolumn = "yes"
opt.virtualedit = "block"
opt.previewheight = 7
opt.foldmethod = "indent"
opt.foldlevelstart = 99
opt.jumpoptions = "stack"
opt.history = 5000
opt.undofile = true
opt.undodir = vim.env.HOME .. "/.cache/nvim/undo"
opt.undolevels = 1000
opt.undoreload = 10000
opt.isfname = opt.isfname - {"="}
opt.path = {".", "", "**5"}
opt.list = true
opt.listchars = {tab = "» ", nbsp = "␣", trail = "•"}
opt.fillchars = {vert = "│"}
opt.timeoutlen = 1500
opt.ttimeoutlen = 40
opt.updatetime = 300
opt.synmaxcol = 1000
opt.lazyredraw = true
opt.swapfile = false
opt.writebackup = false
opt.wildcharm = 26 -- <C-z>
opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
opt.inccommand = "nosplit"
opt.cedit = "<C-x>"

vim.paste =
    (function(overridden)
    return function(lines, phase)
        if (phase == -1 or phase == 1) and vim.fn.mode() == "i" then
            vim.cmd("let &undolevels = &undolevels") -- resetting undolevels breaks undo
        end
        overridden(lines, phase)
    end
end)(vim.paste)
