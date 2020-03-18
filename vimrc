" ==================== Settings ========================= {{{
let g:Theme = -4
let g:Completion = 2  " 0: mucomplete, 1: YCM, 2: coc
let g:PythonPath = 'python3'
let g:ExecCommand = ''
" }}}

" ===================== Plugins ========================= {{{
call plug#begin(fnamemodify(expand('$MYVIMRC'), ':p:h'). '/plugged')  " ~/.vim/plugged or ~/vimfiles/plugged or ~/.config/nvim/plugged
Plug 'mhinz/vim-startify'
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
Plug 'skywind3000/vim-quickui', { 'on': [] }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeTabsToggle' }
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeTabsToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'dhruvasagar/vim-table-mode', { 'on': ['TableModeToggle', 'TableModeRealign', 'Tableize', 'TableAddFormula', 'TableEvalFormulaLine'] }
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'mg979/vim-visual-multi', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-f)'] }
Plug 'dahu/vim-fanfingtastic', { 'on': ['<Plug>fanfingtastic_f', '<Plug>fanfingtastic_t', '<Plug>fanfingtastic_F', '<Plug>fanfingtastic_T'] }
Plug 'tpope/vim-fugitive', { 'on': ['Git', 'Gdiffsplit', 'Gclog', 'Gread'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }  " load on startup to record MRU
Plug 'christoomey/vim-tmux-navigator', { 'on': ['TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': 'markdown' }  " load on insert doesn't work
Plug 'tmsvg/pear-tree'  " lazy load breaks <CR>
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'chaoren/vim-wordmotion'
Plug 'markonm/traces.vim'
Plug 'maxbrunsfeld/vim-yankstack'
if g:Completion >= 0
    Plug 'shougo/echodoc.vim', { 'on': [] }
    Plug 'sirver/ultisnips', { 'on': [] }
    Plug 'honza/vim-snippets', { 'on': [] }
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
    augroup LazyLoadCompletion
        autocmd!
        autocmd InsertEnter * call plug#load('echodoc.vim') | call plug#load('ultisnips') | call plug#load('vim-snippets') | autocmd! LazyLoadCompletion
    augroup END
    if g:Completion == 0
        Plug 'lifepillar/vim-mucomplete'
    elseif g:Completion == 1
        Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --ts-completer --java-completer' }
    elseif g:Completion == 2
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
    endif
endif
call plug#end()
silent! call yankstack#setup()
runtime macros/sandwich/keymap/surround.vim
" }}}

" ====================== Themes ========================= {{{
set guioptions=Mgt  " set before filetype and syntax
filetype plugin indent on
syntax enable
set termguicolors  " load theme after filetype and syntax
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"  " truecolor
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI.="\<Esc>[6 q"  " cursor shape
let &t_SR.="\<Esc>[4 q"
let &t_EI.="\<Esc>[2 q"
let s:theme_list = {}  " g:Theme < 0 for dark themes
let s:theme_list[0] = 'solarized8_flat'
let s:theme_list[1] = 'PaperColor'
let s:theme_list[2] = 'github'
let s:theme_list[3] = 'one'
let s:theme_list[4] = 'two-firewatch'
let s:theme_list[5] = 'ayu'
let s:theme_list[6] = 'material'
let s:theme_list[7] = 'gruvbox'
let s:theme_list[-1] = 'onedark'
let s:theme_list[-2] = 'material'
let s:theme_list[-3] = 'ayu'
let s:theme_list[-4] = 'dracula'
let s:theme_list[-5] = 'nord'
let s:theme_list[-6] = 'forest-night'
let s:theme_list[-7] = 'gruvbox'
let s:theme_list[-8] = 'two-firewatch'
let s:theme_list[-9] = 'molokai'
let g:material_terminal_italics = 1
function! LoadColorscheme(index)
    let g:material_theme_style = a:index < 0 ? 'palenight' : 'lighter'
    let g:ayucolor = a:index < 0 ? 'mirage' : 'light'
    execute 'set background='. (a:index < 0 ? 'dark' : 'light')
    execute 'colorscheme '. get(s:theme_list, a:index, 'desert')
    if exists('*QuickThemeChange')  " this is to fix vim-quickui issue #8
        call QuickThemeChange(a:index < 0 ? 'papercol' : 'solarized')
    endif
endfunction
call LoadColorscheme(g:Theme)
" }}}

" ======================= Basics ======================== {{{
set backspace=eol,start,indent
set whichwrap+=<,>,[,]
set mouse=a
set cursorline
set numberwidth=2
set number
set wrap
set linebreak
set showcmd
set showmatch
set noshowmode
set title
set ruler
set showtabline=2
set laststatus=2
set wildmenu
set wildmode=longest:full,full
set diffopt+=vertical
set splitright
set splitbelow
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set textwidth=0
set autoread
set autochdir
set hidden
set complete-=i
set completeopt=menuone
set shortmess+=c
set nrformats-=octal
set scrolloff=2
set nostartofline
set display=lastline
set previewheight=7
set foldmethod=indent
set foldlevelstart=99
set belloff=all
set history=500
set sessionoptions-=buffer
set undofile
set undolevels=1000
set undoreload=10000
set undodir=~/.cache/vim/undo
set tags=./.tags;,.tags
set path=**
set encoding=utf-8
set timeoutlen=1500
set ttimeoutlen=40
set synmaxcol=500
set lazyredraw
set noswapfile
set nobackup
set nowritebackup
set statusline=%<[%{mode()}]\ %F\ %{&paste?'[paste]':''}%h%m%r%=%-14.(%c/%{len(getline('.'))}%)\ %l/%L\ %P
" }}}

" ====================== Mappings ======================= {{{
let mapleader=';'
nmap <leader>1 <F1>
nmap <leader>2 <F2>
nmap <leader>3 <F3>
nmap <leader>4 <F4>
nmap <leader>5 <F5>
nmap <leader>6 <F6>
nmap <leader>7 <F7>
nmap <leader>8 <F8>
nmap <leader>9 <F9>
nmap <leader>0 <F10>
nmap <leader>- <F11>
nmap <leader>= <F12>
imap <F1> <Esc><F1>
xmap <F1> :<C-u>call LoadQuickUI(0)<CR>gv<F1>
nmap <F1> :call LoadQuickUI(0)<CR><F1>
imap <F2> <Esc><F2>
nnoremap <F2> gT
imap <F3> <Esc><F3>
nnoremap <F3> gt
nnoremap <F4> *N
xnoremap <F4> y/\V<C-r>"<CR>N
imap <F10> <Esc><F10>
nnoremap <F10> :wall <bar> execute '!clear && '. GetRunCommand()<CR>
imap <F11> <Esc><F11>
nnoremap <F11> :wall <bar> execute 'AsyncRun '. GetRunCommand()<CR>
imap <F12> <Esc><F12>
nnoremap <F12> :wall <bar> call RunShellCommand(GetRunCommand())<CR>
imap <Space> <Plug>(PearTreeSpace)
map f <Plug>fanfingtastic_f
map t <Plug>fanfingtastic_t
map F <Plug>fanfingtastic_F
map T <Plug>fanfingtastic_T
map , <Plug>fanfingtastic_;
map ;, <Plug>fanfingtastic_,
map ? <Plug>(easymotion-bd-f)
nmap S <Plug>(easymotion-bd-w)
map  gc <Plug>Commentary
nmap gcc <Plug>CommentaryLine
xmap i <Plug>(textobj-sandwich-query-i)
xmap a <Plug>(textobj-sandwich-query-a)
omap i <Plug>(textobj-sandwich-query-i)
omap a <Plug>(textobj-sandwich-query-a)
xmap ib <Plug>(textobj-sandwich-auto-i)
xmap ab <Plug>(textobj-sandwich-auto-a)
omap ib <Plug>(textobj-sandwich-auto-i)
omap ab <Plug>(textobj-sandwich-auto-a)
xmap is <Plug>(textobj-sandwich-literal-query-i)
xmap as <Plug>(textobj-sandwich-literal-query-a)
omap is <Plug>(textobj-sandwich-literal-query-i)
omap as <Plug>(textobj-sandwich-literal-query-a)
omap ia <Plug>(swap-textobject-i)
xmap ia <Plug>(swap-textobject-i)
omap aa <Plug>(swap-textobject-a)
xmap aa <Plug>(swap-textobject-a)
" for yankstack, do NOT use nnoremap for Y y$
nmap Y y$
noremap 0 ^
noremap ^ 0
noremap - $
xnoremap - $h
noremap <Home> g^
noremap <End> g$
noremap <Down> gj
noremap <Up> gk
inoremap <Home> <C-o>g^
inoremap <End> <C-o>g$
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
xnoremap @q :normal @q<CR>
xnoremap @@ :normal @@<CR>
nnoremap Q q:
xnoremap < <gv
xnoremap > >gv
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
nnoremap cc cc<Space><BS>
nnoremap gf <C-w>gf
nnoremap gp `[v`]
nnoremap yp "0p
nnoremap yP "0P
nnoremap cr :call EditRegister()<CR>
nnoremap K :call LoadQuickUI(1)<CR>
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [t :tprevious<CR>
nnoremap ]t :tnext<CR>
nnoremap [e :m .-2<CR>==
nnoremap ]e :m .+1<CR>==
xnoremap [e :m '<-2<CR>gv=gv
xnoremap ]e :m '>+1<CR>gv=gv
nmap [<Space> O<Esc>
nmap ]<Space> o<Esc>
xnoremap " c"<C-r><C-p>""<Esc>
xnoremap ' c'<C-r><C-p>"'<Esc>
xnoremap ` c`<C-r><C-p>"`<Esc>
xnoremap ( c(<C-r><C-p>")<Esc>
xnoremap [ c[<C-r><C-p>"]<Esc>
xnoremap { c{<C-r><C-p>"}<Esc>
xnoremap <Space> c<Space><C-r><C-p>"<Space><Esc>
nnoremap <silent> <C-c> :nohlsearch <bar> silent! AsyncStop!<CR>
inoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
nnoremap <C-b> :NERDTreeTabsToggle<CR>
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-f> :call LoadAutoformat()<CR><C-f>
imap <C-f> <Esc>:call LoadAutoformat()<CR>V<C-f>A
xmap <C-f> :<C-u>call LoadAutoformat()<CR>gv<C-f>
nmap <C-n> :call LoadVisualMulti()<CR><C-n>
xmap <C-n> :<C-u>call LoadVisualMulti()<CR>gv<C-n>
nmap <leader><C-n> :call LoadVisualMulti()<CR><leader><C-n>
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
imap <leader>r <Esc><leader>r
nmap <leader>r <F11>
nnoremap <leader><F2> :-tabmove<CR>
nnoremap <leader><F3> :+tabmove<CR>
nnoremap <leader>ff :LeaderfFile<CR>
nnoremap <leader>fm :LeaderfMru<CR>
nnoremap <leader>fb :Leaderf! buffer<CR>
nnoremap <leader>fu :LeaderfFunctionAll<CR>
nnoremap <leader>fg :LeaderfRgInteractive<CR>
nnoremap <leader>fG :LeaderfRgRecall<CR>
nnoremap <leader>fl :LeaderfLineAll<CR>
nnoremap <leader>fL :Leaderf rg -S<CR>
nnoremap <leader>fa :LeaderfSelf<CR>
nnoremap <leader>fs :vertical sfind \c*
nnoremap <leader>ft :Vista!!<CR>
nnoremap <leader>k K
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>h :WhichKey ';'<CR>
nnoremap <leader>l :nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <leader>s :call PrintCurrVars(0)<CR>
xnoremap <leader>s :call PrintCurrVars(1)<CR>$
nnoremap <leader>tm :TableModeToggle<CR>
nnoremap <leader>tE :execute getline('.')<CR>``
inoremap <leader>w <Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :write !sudo tee %<CR>
nnoremap <leader>Q :mksession! ~/.cache/vim/session.vim <bar> wqall!<CR>
nnoremap <leader>L :silent source ~/.cache/vim/session.vim<CR>
nnoremap <leader>q :quit<CR>
xnoremap <leader>q <Esc>:quit<CR>
nnoremap <leader>vim :tabedit $MYVIMRC<CR>
cnoremap <expr> <Space> '/?' =~ getcmdtype() ? '.\{-}' : '<Space>'
" }}}

" ====================== Autocmd ======================== {{{
augroup AutoCommands
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g'\"" | endif  " restore last edit position
    autocmd BufWritePost $MYVIMRC source $MYVIMRC  " auto source vimrc when write
    autocmd FileType vim setlocal foldmethod=marker  " use triple curly brackets for fold instead of indentation
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent execute '!~/.vim/bin/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> :edit! <bar> :redraw!<CR>
    autocmd FileType python set nosmartindent | syntax keyword pythonSelf self | highlight def link pythonSelf Special  " fix python comment indentation, highlight keyword self
    autocmd FileType * setlocal formatoptions=jql
augroup END
" }}}

" ===================== Lazy load ======================= {{{
function! LoadAutoformat()
    let g:formatters_python = ['yapf']
    nnoremap <C-f> :Autoformat<CR>
    inoremap <C-f> <Esc>V:'<,'>Autoformat<CR>A
    xnoremap <C-f> :'<,'>Autoformat<CR>$
    call plug#load('vim-autoformat')
endfunction
function! LoadVisualMulti()
    let g:VM_default_mappings = 0
    let g:VM_exit_on_1_cursor_left = 1
    let g:VM_maps = {}
    let g:VM_maps['Select All'] = '<leader><C-n>'
    let g:VM_maps['Find Under'] = '<C-n>'
    let g:VM_maps['Find Subword Under'] = '<C-n>'
    let g:VM_maps['Remove Last Region'] = '<C-p>'
    let g:VM_maps['Skip Region'] = '<C-x>'
    let g:VM_maps['Switch Mode'] = '<C-c>'
    let g:VM_maps['Case Setting'] = ''
    nmap <C-n> <Plug>(VM-Find-Under)
    xmap <C-n> <Plug>(VM-Find-Subword-Under)
    call plug#load('vim-visual-multi')
endfunction
function! LoadQuickUI(open_menu)
    nnoremap <F1> :call quickui#menu#open('normal')<CR>
    xnoremap <F1> :<C-u>call quickui#menu#open('visual')<CR>
    nnoremap K :call OpenQuickUIContextMenu()<CR>
    let g:quickui_color_scheme = g:Theme < 0 ? 'papercol' : 'solarized'
    let g:quickui_show_tip = 1
    let g:quickui_border_style = 2
    call plug#load('vim-quickui')
    call quickui#menu#switch('normal')
    call quickui#menu#reset()
    call quickui#menu#install("&Actions", [
                \ ['Insert &Line', 'execute "normal! o\<Space>\<BS>\<Esc>55i=" | execute "Commentary"', 'Insert a dividing line'],
                \ ['Insert &Time', "put=strftime('%x %X')", 'Insert MM/dd/yyyy hh:mm:ss tt'],
                \ ['--', ''],
                \ ['Git &Status', 'Git', 'Git status'],
                \ ['Git &Diff', 'Gdiffsplit', 'Diff current file with last committed version'],
                \ ['&Git File History', '0Gclog', 'Browse previously committed version of current file'],
                \ ['--', ''],
                \ ['&Word Count', 'call feedkeys("g\<C-g>")', 'Show document details'],
                \ ['&Trim Spaces', 'keeppatterns %s/\s\+$//e | execute "normal! ``"', 'Remove trailing spaces'],
                \ ['--', ''],
                \ ['Open &Buffers', 'call quickui#tools#list_buffer("vsplit")'],
                \ ['Open &Functions', 'call quickui#tools#list_function()'],
                \ ['--', ''],
                \ ['Edit &Vimrc', 'tabedit $MYVIMRC'],
                \ ])
    call quickui#menu#install("To&ggle", [
                \ ['&Netrw', 'Lexplore', 'Toggle Vim Netrw'],
                \ ['&Undo Tree', 'UndotreeToggle', 'Toggle Undotree'],
                \ ['&Vista', 'Vista!!', 'Toggle Vista'],
                \ ['&Markdown Preview', 'execute "normal \<Plug>MarkdownPreviewToggle"', 'Toggle markdown preview'],
                \ ['Set &Diff %{&diff ? "Off" :"On"}', 'execute &diff ? "windo diffoff" : "windo diffthis"', 'Toggle diff in current window'],
                \ ['Set &Fold %{&foldlevel ? "On" :"Off"}', 'execute &foldlevel ? "normal! zM" : "normal! zR"', 'Toggle fold by indent'],
                \ ['Set &Wrap %{&wrap ? "Off" :"On"}', 'set wrap!', 'Toggle wrap lines'],
                \ ['Set &Paste %{&paste ? "Off" :"On"}', 'execute &paste ? "set nopaste number mouse=nv signcolumn=auto" : "set paste nonumber norelativenumber mouse= signcolumn=no"', 'Toggle paste mode (shift alt drag to select and copy)'],
                \ ['Set &Spelling %{&spell ? "Off" :"On"}', 'set spell!', 'Toggle spell checker (z= to auto correct current word)'],
                \ ['Set Pre&view %{&completeopt=~"preview" ? "Off" :"On"}', 'execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"', 'Toggle function preview'],
                \ ['Set Cursorli&ne %{&cursorline ? "Off" :"On"}', 'set cursorline!', 'Toggle cursorline'],
                \ ['Set Cursor&column %{&cursorcolumn ? "Off" :"On"}', 'set cursorcolumn!', 'Toggle cursorcolumn'],
                \ ['Set %{&background=~"dark" ? "Light" :"Dark"} The&me', 'let &background = &background=="dark" ? "light" : "dark"', 'Toggle background color'],
                \ ])
    call quickui#menu#install("Ta&bular", [
                \ ['Align Using = (delimiter fixed)', 'Tabularize /=\zs', 'Tabularize /=\zs'],
                \ ['Align Using , (delimiter fixed)', 'Tabularize /,\zs', 'Tabularize /,\zs'],
                \ ['Align Using # (delimiter fixed)', 'Tabularize /#\zs', 'Tabularize /#\zs'],
                \ ['Align Using : (delimiter fixed)', 'Tabularize /:\zs', 'Tabularize /:\zs'],
                \ ['--', ''],
                \ ['Align Using = (delimiter centered)', 'Tabularize /=', 'Tabularize /='],
                \ ['Align Using , (delimiter centered)', 'Tabularize /,', 'Tabularize /,'],
                \ ['Align Using # (delimiter centered)', 'Tabularize /#', 'Tabularize /#'],
                \ ['Align Using : (delimiter centered)', 'Tabularize /:', 'Tabularize /:'],
                \ ])
    call quickui#menu#install("Table &Mode", [
                \ ['Table &Mode', 'TableModeToggle', 'Toggle TableMode'],
                \ ['&Reformat Table', 'TableModeRealign', 'Reformat table'],
                \ ['&Format to Table', 'Tableize', 'Format to table, use <leader>T to set delimiter'],
                \ ['Delete Row', 'execute "normal \<Plug>(table-mode-delete-row)"', 'Delete row'],
                \ ['&Delete Column', 'execute "normal \<Plug>(table-mode-delete-column)"', 'Delete column'],
                \ ['Show Cell &Position', 'execute "normal \<Plug>(table-mode-echo-cell)"', 'Show cell index number'],
                \ ['--', ''],
                \ ['&Add Formula', 'TableAddFormula', 'Add formula to current cell, i.e. Sum(r1,c1:r2,c2)'],
                \ ['&Evaluate Formula', 'TableEvalFormulaLine', 'Evaluate formula'],
                \ ])
    let l:quickui_theme_list = []
    let l:background_color = '(Dark) &'
    for index in sort(keys(s:theme_list))
        if index == 0
            call add(l:quickui_theme_list, ['--', ''])
            let l:background_color = '(Light) &'
        endif
        call add(l:quickui_theme_list, [l:background_color. s:theme_list[index], "execute 'silent !sed --in-place \"2 s/let g:Theme = .*/let g:Theme = ". index. '/" '. $MYVIMRC. "' | call LoadColorscheme(". index. ')'])  " add sed --follow-symlinks to redirect neovim init.vim symlink to vimrc
    endfor
    call quickui#menu#install("&Theme", l:quickui_theme_list)
    call quickui#menu#switch('visual')
    call quickui#menu#reset()
    call quickui#menu#install("&Tabular", [
                \ ['Align Using = (delimiter fixed)', "'<,'>Tabularize /=\\zs", "'<,'>Tabularize /=\\zs"],
                \ ['Align Using , (delimiter fixed)', "'<,'>Tabularize /,\\zs", "'<,'>Tabularize /,\\zs"],
                \ ['Align Using # (delimiter fixed)', "'<,'>Tabularize /#\\zs", "'<,'>Tabularize /#\\zs"],
                \ ['Align Using : (delimiter fixed)', "'<,'>Tabularize /:\\zs", "'<,'>Tabularize /:\\zs"],
                \ ['--', ''],
                \ ['Align Using = (delimiter centered)', "'<,'>Tabularize /=", "'<,'>Tabularize /="],
                \ ['Align Using , (delimiter centered)', "'<,'>Tabularize /,", "'<,'>Tabularize /,"],
                \ ['Align Using # (delimiter centered)', "'<,'>Tabularize /#", "'<,'>Tabularize /#"],
                \ ['Align Using : (delimiter centered)', "'<,'>Tabularize /:", "'<,'>Tabularize /:"],
                \ ['--', ''],
                \ ['Sort Asc', "'<,'>sort", 'Sort in ascending order (sort)'],
                \ ['Sort Desc', "'<,'>sort!", 'Sort in descending order (sort!)'],
                \ ['Sort Num Asc', "'<,'>sort n", 'Sort numerically in ascending order (sort n)'],
                \ ['Sort Num Desc', "'<,'>sort! n", 'Sort numerically in descending order (sort! n)'],
                \ ])
    call quickui#menu#install("Table &Mode", [
                \ ['Reformat Table', "'<,'>TableModeRealign", 'Reformat table'],
                \ ['Format to Table', "'<,'>Tableize", 'Format to table, use <leader>T to set delimiter'],
                \ ])
    if a:open_menu == 1
        call OpenQuickUIContextMenu()
    endif
endfunction
function! OpenQuickUIContextMenu()
    let l:quickui_content = []
    if &filetype == 'python'
        call add(l:quickui_content, ['Jedi Do&cumentation', 'call jedi#show_documentation()', 'Jedi documentation'])
        call add(l:quickui_content, ['Jedi &Goto', 'call jedi#goto()', 'Jedi goto'])
        call add(l:quickui_content, ['Jedi Definition', 'call jedi#goto_definitions()', 'Jedi definition'])
        call add(l:quickui_content, ['Jedi Assignments', 'call jedi#goto_assignments()', 'Jedi assignments'])
        call add(l:quickui_content, ['Jedi Stubs', 'call jedi#goto_stubs()', 'Jedi stubs'])
        call add(l:quickui_content, ['Jedi Re&ferences', 'call jedi#usages()', 'Jedi references'])
        call add(l:quickui_content, ['Jedi Rena&me', 'call jedi#rename()', 'Jedi rename'])
        call add(l:quickui_content, ['--', ''])
    endif
    if g:Completion == 1
        call add(l:quickui_content, ['&Documentation', 'YcmCompleter GetDoc', 'YouCompleteMe documentation'])
        call add(l:quickui_content, ['D&efinition', 'YcmCompleter GoToDefinitionElseDeclaration', 'YouCompleteMe definition'])
        call add(l:quickui_content, ['&Type Definition', 'YcmCompleter GetType', 'YouCompleteMe type definition'])
        call add(l:quickui_content, ['&References', 'YcmCompleter GoToReferences', 'YouCompleteMe references'])
        call add(l:quickui_content, ['&Implementation', 'YcmCompleter GoToImplementation', 'YouCompleteMe implementation'])
        call add(l:quickui_content, ['--', ''])
        call add(l:quickui_content, ['&Fix', 'YcmCompleter FixIt', 'YouCompleteMe fix'])
        call add(l:quickui_content, ['&Organize Imports', 'YcmCompleter OrganizeImports', 'YouCompleteMe organize imports'])
    elseif g:Completion == 2
        call add(l:quickui_content, ['&Documentation', 'call CocAction("doHover")', 'Coc documentation'])
        call add(l:quickui_content, ['D&efinition', 'execute "normal \<Plug>(coc-definition)"', 'Coc definition'])
        call add(l:quickui_content, ['&Type Definition', 'execute "normal \<Plug>(coc-type-definition)"', 'Coc type definition'])
        call add(l:quickui_content, ['&References', 'execute "normal \<Plug>(coc-references)"', 'Coc references'])
        call add(l:quickui_content, ['&Implementation', 'execute "normal \<Plug>(coc-implementation)"', 'Coc implementation'])
        call add(l:quickui_content, ['--', ''])
        call add(l:quickui_content, ['Re&name', 'execute "normal \<Plug>(coc-rename)"', 'Coc rename'])
        call add(l:quickui_content, ['&Fix', 'execute "normal \<Plug>(coc-fix-current)"', 'Coc fix'])
    endif
    call add(l:quickui_content, ['--', ''])
    call add(l:quickui_content, ['&Built-in Docs', 'execute "normal! K"', 'Use normal! K for help'])
    call quickui#context#open(l:quickui_content, {'index': g:quickui#context#cursor})
endfunction
" }}}

" ====================== Functions ====================== {{{
function! EditRegister() abort
    let l:r = nr2char(getchar())
    call feedkeys("q:ilet @". l:r. " = \<C-r>\<C-r>=string(@". l:r. ")\<CR>\<Esc>0f'", 'n')
endfunction
function! PrintCurrVars(visual)
    let l:new_line = "normal! o\<Space>\<BS>"
    if a:visual  " print selection
        let l:vars = [getline('.')[getpos("'<")[2] - 1:getpos("'>")[2] - 1]]
    elseif getline('.') =~ '[^a-zA-Z0-9_,\[\]. ]\|[a-zA-Z0-9_\]]\s\+\w'  " print variable under cursor if not in comma separated form
        let l:vars = [expand('<cword>')]
    else  " print variables on current line separated by commas
        let l:vars = split(substitute(getline('.'), ' ', '', 'ge'), ',')
        let l:new_line = "normal! cc\<Space>\<BS>"
    endif
    let l:print = {}
    let l:print['python'] = "print(f'". join(map(copy(l:vars), "v:val. ': {'. v:val. '}'"), ' | '). "')"
    let l:print['javascript'] = 'console.log(`'. join(map(copy(l:vars), "v:val. ': ${'. v:val. '}'"), ' | '). '`)'
    if has_key(l:print, &filetype)
        execute l:new_line
        call append(line('.'), l:print[&filetype])
        normal! J
    endif
endfunction
" }}}

" =================== Other plugins ===================== {{{
let g:asyncrun_open = 12
let g:EasyMotion_smartcase = 1
let g:undotree_WindowLayout = 2
let g:NERDTreeWinSize = 23
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable  = "▷"
let g:NERDTreeDirArrowCollapsible = "◢"
let g:netrw_dirhistmax = 0  " built in :Lexplore<CR> settings, replaced by NERDTree
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
set wildignore+=*/tmp/*,*/\.git/*,*/\.oh-my-zsh/*,*/node_modules/*,*/venv/*,*/\.env/*  " do NOT wildignore plugged
let g:Lf_WildIgnore = { 'dir':['tmp','.git','.oh-my-zsh','plugged','node_modules','venv','.env','.local','.idea','*cache*'],'file':[] }
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_UseCache = 0
let g:Lf_ReverseOrder = 1
let g:Lf_ShortcutF = '<C-p>'
let g:Lf_CommandMap = { '<C-]>':['<C-v>'],'<C-j>':['<DOWN>'],'<C-k>':['<UP>'],'<TAB>':['<TAB>','<C-p>','<C-f>'] }
let g:Lf_NormalMap = { 'File': [['u', ':LeaderfFile ..<CR>']] }
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Aa'
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:table_mode_tableize_map = ''
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
let g:table_mode_corner = '|'  " markdown compatible tablemode
let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'css', 'html', 'python', 'java', 'c', 'bash=sh']  " should work without plugins
" }}}

" ==================== Execute code ===================== {{{
command! -complete=file -nargs=* SetArgs let b:args = <q-args> == '' ? '' : ' '. <q-args>  " :SetArgs <args...><CR>, all execution will use args
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
let g:OutputCount = 1
function! RunShellCommand(command)
    let l:expanded_command = substitute(a:command, './%<', './'. fnameescape(expand('%<')), '')
    let l:expanded_command = substitute(l:expanded_command, '%<', fnameescape(expand('%<')), '')
    let l:expanded_command = substitute(l:expanded_command, '%', fnameescape(expand('%')), '')
    let l:curr_bufnr = bufwinnr('%')
    let l:win_left = winnr('$')
    while l:win_left > 1 && bufname('%') !~ '[Output_'
        execute 'wincmd w'
        let l:win_left = l:win_left - 1
    endwhile
    if bufname('%') =~ '[Output_'
        setlocal modifiable
        execute '%d'
    else
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap nocursorline nocursorcolumn
        silent execute '0f | file [Output_'. g:OutputCount. '] | resize '. (winheight(0) * 4/5)
        let g:OutputCount = g:OutputCount + 1
    endif
    call setline(1, 'Run: '. l:expanded_command)
    call setline(2, substitute(getline(1), '.', '=', 'g'))
    execute '$read !'. l:expanded_command
    setlocal nomodifiable
    execute l:curr_bufnr. 'wincmd w'
endfunction
function! GetRunCommand()
    let l:run_command = {}
    let l:run_command['python'] = g:PythonPath. ' %'
    let l:run_command['c'] = 'gcc % -o %< -g && ./%<'
    let l:run_command['cpp'] = 'g++ % -o %< -g && ./%<'
    let l:run_command['java'] = 'javac % && java %<'
    let l:run_command['javascript'] = 'node %'
    return get(l:run_command, &filetype, ''). (exists('b:args') ? b:args : '')
endfunction
if g:ExecCommand != ''
    nnoremap <leader>r :wall <bar> execute g:ExecCommand<CR>
endif
" }}}

" ==================== Auto complete ==================== {{{
" let g:ycm_path_to_python_interpreter=''  " for ycmd, don't modify
let g:ycm_python_binary_path=g:PythonPath  " for JediHTTP, comment out if venv doesn't work
let g:echodoc_enable_at_startup = 1
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<TAB>'
let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = '2'
let g:jedi#documentation_command = '<leader>k'
let g:jedi#goto_command = '<leader>d'
let g:jedi#rename_command = '<leader>R'
let g:jedi#goto_stubs_command = ''
imap <expr> <CR> pumvisible() ? "\<Esc>a" : "\<C-g>u\<Plug>(PearTreeExpand)\<Space>\<BS>"
if g:Completion == 0  " mucomplete
    set omnifunc=syntaxcomplete#Complete
    set completeopt+=noselect
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#chains = {'default': ['path', 'ulti', 'keyn', 'omni', 'file']}
elseif g:Completion == 1  " YCM
    inoremap <expr> <C-e> pumvisible() ? "\<C-e>\<Esc>a" : "\<C-e>"
    nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <leader>a :YcmCompleter FixIt<CR>
    " let g:ycm_show_diagnostics_ui = 0
    " let g:ycm_semantic_triggers = { 'c,cpp,python,java,javscript': ['re!\w{2}'] }  " auto semantic complete, can be slow
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    " for c include files, add to .ycm_extra_conf.py
    " '-isystem',
    " '/path/to/include'
    let g:ycm_global_ycm_extra_conf = '~/.vim/config/.ycm_extra_conf.py'
    let g:echodoc#enable_force_overwrite = 1
elseif g:Completion == 2  " coc
    let g:coc_global_extensions = ['coc-git', 'coc-snippets', 'coc-highlight', 'coc-tsserver', 'coc-html', 'coc-css', 'coc-emmet', 'coc-python']
    " to manually install extensions, run :CocInstall coc-git coc-...
    " or run cd ~/.config/coc/extensions && yarn add coc-..., yarn cannot be cmdtest
    set updatetime=300
    set signcolumn=yes
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <C-@> coc#refresh()
    inoremap <expr> <C-Space> coc#refresh()
    xmap <C-f> <Plug>(coc-format-selected)
    nnoremap <C-f> :call CocAction('format')<CR>
    nmap <leader>d <Plug>(coc-definition)
    nmap <leader>R <Plug>(coc-rename)
    nmap <leader>a <Plug>(coc-fix-current)
    imap <C-k> <Plug>(coc-snippets-expand)
    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'
endif
" }}}

" ====================== Terminal ======================= {{{
if has('nvim')
    let loaded_matchit = 1  " disable matchit
    " let g:python_host_prog = '/usr/bin/python2.7'
    let g:python3_host_prog = '/usr/bin/python3.6'
    let g:loaded_python_provider = 1
    " let g:loaded_python3_provider = 1
    tnoremap <F2> <C-\><C-n>gT
    tnoremap <F3> <C-\><C-n>gt
    tnoremap <C-u> <C-\><C-n>
    tnoremap <Esc> <C-\><C-n>
    tnoremap <silent> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
    tnoremap <silent> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
    tnoremap <silent> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
    tnoremap <silent> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
    nnoremap <leader>to :execute 'split <bar> resize'. (winheight(0) * 2/5). ' <bar> terminal'<CR>
    nnoremap <leader>tO :terminal<CR>
    nnoremap <leader>th :split <bar> terminal<CR>
    nnoremap <leader>tv :vsplit <bar> terminal<CR>
    nnoremap <leader>tt :tabedit <bar> terminal<CR>
    nnoremap <leader>te V:call SendToNvimTerminal()<CR>$
    xnoremap <leader>te <Esc>:call SendToNvimTerminal()<CR>
    augroup NvimTerminal
        autocmd!
        autocmd TermOpen * set nonumber norelativenumber signcolumn=no | startinsert
        autocmd TermClose * quit
        autocmd BufEnter term://* startinsert
    augroup END
    function! SendToNvimTerminal()
        let l:job_id = -1
        for l:buff_n in tabpagebuflist()
            if nvim_buf_get_name(l:buff_n) =~ 'term://'
                let l:job_id = nvim_buf_get_var(l:buff_n, 'terminal_job_id')  " sends to last opened terminal in current tab
                break
            endif
        endfor
        if l:job_id > 0
            let l:lines = getline(getpos("'<")[1], getpos("'>")[1])
            let l:indent = match(l:lines[0], '[^ \t]')  " remove unnecessary indentation if first line is indented
            for l:line in l:lines
                call jobsend(l:job_id, (match(l:line, '[^ \t]') ? l:line[l:indent:] : l:line). "\n")
            endfor
        endif
    endfunction
else
    set viminfo+=n~/.cache/vim/viminfo
    " do not tmap <Esc> in vim 8
    tnoremap <F2> <C-w>gT
    tnoremap <F3> <C-w>gt
    tnoremap <C-u> <C-\><C-n>
    tnoremap <silent> <C-h> <C-w>:TmuxNavigateLeft<CR>
    tnoremap <silent> <C-j> <C-w>:TmuxNavigateDown<CR>
    tnoremap <silent> <C-k> <C-w>:TmuxNavigateUp<CR>
    tnoremap <silent> <C-l> <C-w>:TmuxNavigateRight<CR>
    nnoremap <leader>to :execute 'terminal ++close ++rows='. winheight(0) * 2/5<CR>
    nnoremap <leader>tO :terminal ++curwin ++close<CR>
    nnoremap <leader>th :terminal ++close<CR>
    nnoremap <leader>tv :vertical terminal ++close<CR>
    nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
    nnoremap <leader>te V:call SendToTerminal()<CR>$
    xnoremap <leader>te <Esc>:call SendToTerminal()<CR>
    function! SendToTerminal()
        let l:buff_n = term_list()
        if len(l:buff_n) > 0
            let l:buff_n = l:buff_n[0]  " sends to most recently opened terminal
            let l:lines = getline(getpos("'<")[1], getpos("'>")[1])
            let l:indent = match(l:lines[0], '[^ \t]')  " remove unnecessary indentation if first line is indented
            for l:line in l:lines
                call term_sendkeys(l:buff_n, (match(l:line, '[^ \t]') ? l:line[l:indent:] : l:line). "\<CR>")
                sleep 10m
            endfor
        endif
    endfunction
endif
" }}}

" ================== Windows settings =================== {{{
if has('win32')
    let &t_SI=""
    let &t_SR=""
    let &t_EI=""
    xnoremap <C-c> "+y<Esc>
    if has('gui_running')
        set pythonthreedll=python37.dll  " if using python3.8, set to python38.dll
        let g:gVimPath = substitute($VIMRUNTIME. '\gvim', '\', '\\\\', 'g'). ' '
        function! ActivatePyEnv(environment)
            if a:environment == ''
                silent execute '!venv & '. g:gVimPath. expand('%:p')
            else
                silent execute '!activate '. a:environment. ' & '. g:gVimPath. expand('%:p')
            endif
        endfunction
        command! -nargs=* Activate call ActivatePyEnv(<q-args>) <bar> quit
        nnoremap <leader>W :silent execute '!sudo /c '. g:gVimPath. '"%:p"'<CR>
        nnoremap <leader><C-r> :silent execute '!'. g:gVimPath. '"%:p"' <bar> quit<CR>
        set guicursor+=a:blinkon0
        set guifont=Consolas_NF:h11:cANSI
        if &columns < 85 && &lines < 30
            set lines=25
            set columns=90
        endif
    endif
endif
" }}}
