local g = vim.g
local opt = vim.opt

-- need this PR to replace netrw https://github.com/kyazdani42/nvim-tree.lua/pull/288
g.netrw_dirhistmax = 0
g.netrw_banner = 0
g.netrw_browse_split = 4
g.netrw_winsize = 20
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
opt.showcmd = true
opt.showmatch = true
opt.showmode = false
opt.title = true
opt.ruler = true
opt.showtabline = 2
opt.laststatus = 2
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.diffopt = opt.diffopt + {"vertical"}
opt.splitright = true
opt.splitbelow = true
opt.hlsearch = true
opt.incsearch = true
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
opt.autoread = true
-- opt.autochdir = true
opt.hidden = true
opt.complete = {".", "w", "b", "u"}
opt.completeopt = {"menuone", "noselect"}
opt.shortmess = opt.shortmess + {c = true}
opt.shortmess = opt.shortmess - {S = true}
opt.nrformats = opt.nrformats - {"octal"}
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.signcolumn = "yes"
opt.startofline = false
opt.display = "lastline"
opt.virtualedit = "block"
opt.previewheight = 7
opt.foldmethod = "indent"
opt.foldlevelstart = 99
opt.jumpoptions = "stack"
opt.belloff = "all"
opt.history = 1000
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
opt.undolevels = 1000
opt.undoreload = 10000
opt.path = {".", "", "**5"}
opt.list = true
opt.listchars = {tab = "» ", nbsp = "␣", trail = "•"}
opt.fillchars = {vert = "│"}
opt.encoding = "utf-8"
opt.timeout = true
opt.timeoutlen = 1500
opt.ttimeoutlen = 40
opt.updatetime = 300
opt.synmaxcol = 1000
opt.lazyredraw = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.wildcharm = 26 -- <C-z>
opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
