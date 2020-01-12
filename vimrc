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
Plug 'skywind3000/quickmenu.vim', { 'on': [] }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeTabsToggle' }
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeTabsToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'mg979/vim-visual-multi', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-f)'] }
Plug 'dahu/vim-fanfingtastic', { 'on': ['<Plug>fanfingtastic_f', '<Plug>fanfingtastic_t', '<Plug>fanfingtastic_F', '<Plug>fanfingtastic_T'] }
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gdiffsplit'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }  " load on startup to record MRU
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
    Plug 'davidhalter/jedi-vim', { 'on': [] }
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
let s:theme_list = {}  " g:Theme < 0 for dark themes, will load when calling LoadColorscheme(g:Theme)
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
let g:material_theme_style = g:Theme < 0 ? 'palenight' : 'lighter'
let g:ayucolor = g:Theme < 0 ? 'mirage' : 'light'
" }}}

" ======================= Basics ======================== {{{
if &compatible | set nocompatible | endif
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
vmap <F1> :<C-u>call LoadQuickmenu()<CR>gv<F1>
nmap <F1> :call LoadQuickmenu()<CR><F1>
imap <F2> <Esc><F2>
nnoremap <F2> gT
imap <F3> <Esc><F3>
nnoremap <F3> gt
nnoremap <F4> *N
imap <F10> <Esc><F10>
nnoremap <F10> :wall <bar> execute '!clear && '. GetRunCommand()<CR>
imap <F11> <Esc><F11>
nnoremap <F11> :wall <bar> execute 'AsyncRun '. GetRunCommand()<CR>
imap <F12> <Esc><F12>
nnoremap <F12> :wall <bar> call RunShellCommand(''. GetRunCommand())<CR>
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
omap ia <Plug>(swap-textobject-i)
xmap ia <Plug>(swap-textobject-i)
omap aa <Plug>(swap-textobject-a)
xmap aa <Plug>(swap-textobject-a)
" for yankstack, do NOT use nnoremap for Y y$
nmap Y y$
noremap 0 ^
noremap ^ 0
noremap - $
vnoremap - $h
noremap <Home> g^
noremap <End> g$
noremap <Down> gj
noremap <Up> gk
xnoremap @q :normal @q<CR>
xnoremap @@ :normal @@<CR>
nnoremap Q q:
vnoremap < <gv
vnoremap > >gv
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
nnoremap cc cc<Space><BS>
nnoremap gf <C-w>gf
nnoremap gp `[v`]
nnoremap yp "0p
nnoremap yP "0P
nnoremap cr :call EditRegister()<CR>
nnoremap K :call ShowDocs()<CR>
vnoremap " c"<C-r><C-p>""<Esc>
vnoremap ' c'<C-r><C-p>"'<Esc>
vnoremap ` c`<C-r><C-p>"`<Esc>
vnoremap ( c(<C-r><C-p>")<Esc>
vnoremap [ c[<C-r><C-p>"]<Esc>
vnoremap { c{<C-r><C-p>"}<Esc>
vnoremap <Space> c<Space><C-r><C-p>"<Space><Esc>
nnoremap <C-c> :nohlsearch <bar> silent! AsyncStop!<CR>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
nnoremap <C-b> :NERDTreeTabsToggle<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-f> :call LoadAutoformat()<CR><C-f>
imap <C-f> <Esc>:call LoadAutoformat()<CR>V<C-f>A
vmap <C-f> :<C-u>call LoadAutoformat()<CR>gv<C-f>
nmap <C-n> :call LoadVisualMulti()<CR><C-n>
xmap <C-n> :<C-u>call LoadVisualMulti()<CR>gv<C-n>
nmap <leader><C-n> :call LoadVisualMulti()<CR><leader><C-n>
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nmap <leader>o o<Esc>
nmap <leader>O O<Esc>
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
nnoremap <leader>ft :TagbarToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>h :WhichKey ';'<CR>
nnoremap <leader>l :nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <leader>s :call PrintCurrVars(0)<CR>
vnoremap <leader>s :call PrintCurrVars(1)<CR>$
nnoremap <leader>tm :TableModeToggle<CR>
nnoremap <leader>tE :execute getline('.')<CR>``
inoremap <leader>w <Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :write !sudo tee %<CR>
nnoremap <leader>Q :mksession! ~/.cache/vim/session.vim <bar> wqall!<CR>
nnoremap <leader>L :silent source ~/.cache/vim/session.vim<CR>
nnoremap <leader>q :quit<CR>
vnoremap <leader>q <Esc>:quit<CR>
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
    vnoremap <C-f> :'<,'>Autoformat<CR>$
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
function! ShowDocs()
    if &filetype == 'python'
        let g:jedi#auto_initialization = 1
        let g:jedi#auto_vim_configuration = 0
        let g:jedi#completions_enabled = 0
        let g:jedi#show_call_signatures = '2'
        let g:jedi#documentation_command = 'K'
        let g:jedi#rename_command = '<leader>R'
        let g:jedi#goto_command = '<leader>d'
        let g:jedi#usages_command = '<leader>a'
        let g:jedi#goto_stubs_command = ''
        call plug#load('jedi-vim')
        call jedi#show_documentation()
    else
        normal! K
    endif
endfunction
function! LoadQuickmenu()
    nnoremap <F1> :call quickmenu#toggle(0) <bar> set showcmd<CR>
    vnoremap <F1> :<C-u>call quickmenu#toggle(2) <bar> set showcmd<CR>
    call plug#load('quickmenu.vim')
    let g:quickmenu_options = 'HL'
    call g:quickmenu#reset()
    call g:quickmenu#current(0)
    call g:quickmenu#header('QvQ')
    call g:quickmenu#append('# Actions', '')
    call g:quickmenu#append('Insert Line', 'execute "normal! o\<Space>\<BS>\<Esc>55i=" | execute "Commentary"', 'Insert a dividing line')
    call g:quickmenu#append('Insert Time', "put=strftime('%x %X')", 'Insert MM/dd/yyyy hh:mm:ss tt')
    call g:quickmenu#append('Git Diff', 'Gdiffsplit', 'Fugitive git diff')
    call g:quickmenu#append('Git Status', 'Gstatus', 'Fugitive git status')
    call g:quickmenu#append('Word Count', 'call feedkeys("g\<C-g>")', 'Show document details')
    call g:quickmenu#append('Trim Spaces', 'keeppatterns %s/\s\+$//e | execute "normal! ``"', 'Remove trailing spaces')
    call g:quickmenu#append('Tabular Menu', 'call g:quickmenu#toggle(1)', 'Use Tabular to align selected text')
    call g:quickmenu#append('Themes', 'call g:quickmenu#toggle(3)', 'Change vim colorscheme (let g:Theme = <idx> must be the second line of $MYVIMRC)')
    call g:quickmenu#append('# Toggle', '')
    call g:quickmenu#append('NERDTree', 'NERDTreeTabsToggle', 'Toggle NERDTree')
    call g:quickmenu#append('Netrw', 'Lexplore', 'Toggle Vim Netrw')
    call g:quickmenu#append('Undo Tree', 'UndotreeToggle', 'Toggle Undotree')
    call g:quickmenu#append('Tagbar', 'TagbarToggle', 'Toggle Tagbar')
    call g:quickmenu#append('Table Mode', 'TableModeToggle', 'Toggle TableMode')
    call g:quickmenu#append('Markdown Preview', 'execute "normal \<Plug>MarkdownPreviewToggle"', 'Toggle markdown preview')
    call g:quickmenu#append('Diff %{&diff ? "[x]" :"[ ]"}', 'execute &diff ? "windo diffoff" : "windo diffthis"', 'Toggle diff in current window')
    call g:quickmenu#append('Fold %{&foldlevel ? "[ ]" :"[x]"}', 'execute &foldlevel ? "normal! zM" : "normal! zR"', 'Toggle fold by indent')
    call g:quickmenu#append('Wrap %{&wrap? "[x]" :"[ ]"}', 'set wrap!', 'Toggle wrap lines')
    call g:quickmenu#append('Paste %{&paste ? "[x]" :"[ ]"}', 'execute &paste ? "set nopaste number mouse=nv signcolumn=auto" : "set paste nonumber norelativenumber mouse= signcolumn=no"', 'Toggle paste mode (shift alt drag to select and copy)')
    call g:quickmenu#append('Spelling %{&spell ? "[x]" :"[ ]"}', 'set spell!', 'Toggle spell checker (z= to auto correct current word)')
    call g:quickmenu#append('Preview %{&completeopt=~"preview" ? "[x]" :"[ ]"}', 'execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"', 'Toggle function preview')
    call g:quickmenu#append('Dark Theme %{&background=~"dark" ? "[x]" :"[ ]"}', 'let &background = &background=="dark" ? "light" : "dark"', 'Toggle background color')
    call g:quickmenu#current(1)
    call g:quickmenu#header('Tabular Normal Mode')
    call g:quickmenu#append('# Fixed Delimiter', '')
    call g:quickmenu#append('Align Using =', 'Tabularize /=\zs', 'Tabularize /=\zs')
    call g:quickmenu#append('Align Using ,', 'Tabularize /,\zs', 'Tabularize /,\zs')
    call g:quickmenu#append('Align Using |', 'Tabularize /|\zs', 'Tabularize /|\zs')
    call g:quickmenu#append('Align Using :', 'Tabularize /:\zs', 'Tabularize /:\zs')
    call g:quickmenu#append('# Center Delimiter', '')
    call g:quickmenu#append('Align Using =', 'Tabularize /=', 'Tabularize /=')
    call g:quickmenu#append('Align Using ,', 'Tabularize /,', 'Tabularize /,')
    call g:quickmenu#append('Align Using |', 'Tabularize /|', 'Tabularize /|')
    call g:quickmenu#append('Align Using :', 'Tabularize /:', 'Tabularize /:')
    call g:quickmenu#current(2)
    call g:quickmenu#header('Tabular Visual Mode')
    call g:quickmenu#append('# Fixed Delimiter', '')
    call g:quickmenu#append('Align Using =', "'<,'>Tabularize /=\\zs", "'<,'>Tabularize /=\\zs")
    call g:quickmenu#append('Align Using ,', "'<,'>Tabularize /,\\zs", "'<,'>Tabularize /,\\zs")
    call g:quickmenu#append('Align Using |', "'<,'>Tabularize /|\\zs", "'<,'>Tabularize /|\\zs")
    call g:quickmenu#append('Align Using :', "'<,'>Tabularize /:\\zs", "'<,'>Tabularize /:\\zs")
    call g:quickmenu#append('# Center Delimiter', '')
    call g:quickmenu#append('Align Using =', "'<,'>Tabularize /=", "'<,'>Tabularize /=")
    call g:quickmenu#append('Align Using ,', "'<,'>Tabularize /,", "'<,'>Tabularize /,")
    call g:quickmenu#append('Align Using |', "'<,'>Tabularize /|", "'<,'>Tabularize /|")
    call g:quickmenu#append('Align Using :', "'<,'>Tabularize /:", "'<,'>Tabularize /:")
    call g:quickmenu#append('# Sort', '')
    call g:quickmenu#append('Sort Asc', "'<,'>sort", 'Sort in ascending order (sort)')
    call g:quickmenu#append('Sort Desc', "'<,'>sort!", 'Sort in descending order (sort!)')
    call g:quickmenu#append('Sort Num Asc', "'<,'>sort n", 'Sort numerically in ascending order (sort n)')
    call g:quickmenu#append('Sort Num Desc', "'<,'>sort! n", 'Sort numerically in descending order (sort! n)')
    call g:quickmenu#current(3)
    call g:quickmenu#header('Themes')
    call g:quickmenu#append('# Dark', '')
    for idx in sort(keys(s:theme_list))
        if idx == 0
            call g:quickmenu#append('# Light', '')
        endif
        call g:quickmenu#append(s:theme_list[idx], "execute 'silent! !sed -i \"2 s/let g:Theme = .*/let g:Theme = ". idx. "/\" ". $MYVIMRC. "' | call LoadColorscheme(". idx. ')')
    endfor
endfunction
" }}}

" ====================== Functions ====================== {{{
function! LoadColorscheme(idx)
    execute 'set background='. (a:idx < 0 ? 'dark' : 'light')
    execute 'colorscheme '. get(s:theme_list, a:idx, 'desert')
endfunction
call LoadColorscheme(g:Theme)
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
let g:NERDTreeWinSize = 23
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
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
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_width = 25
let g:tagbar_singleclick = 1
let g:tagbar_iconchars = [ '+', '-' ]
let g:table_mode_tableize_map = ''
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
let g:table_mode_corner = '|'  " markdown compatible tablemode
let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'css', 'html', 'python', 'java', 'c']  " should work without plugins
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
imap <expr> <CR> pumvisible() ? "\<Esc>a" : "\<C-g>u\<Plug>(PearTreeExpand)\<Space>\<BS>"
if g:Completion == 0  " mucomplete
    set omnifunc=syntaxcomplete#Complete
    set completeopt+=noselect
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#chains = {'default': ['path', 'ulti', 'keyn', 'omni', 'file']}
elseif g:Completion == 1  " YCM
    inoremap <expr> <C-e> pumvisible() ? "\<C-e>\<Esc>a" : "\<C-x>"
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
    let g:ycm_global_ycm_extra_conf = '~/.vim/others/.ycm_extra_conf.py'
    let g:echodoc#enable_force_overwrite = 1
    function! YcmOnDeleteChar()
        return pumvisible() ? "\<C-y>" : ""
    endfunction
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
    nnoremap K :call <SID>show_documentation()<CR>
    nmap <leader>a <Plug>(coc-fix-current)
    nmap <leader>R <Plug>(coc-rename)
    nmap <leader>d <Plug>(coc-definition)
    nmap gy <Plug>(coc-type-definition)
    nmap gi <Plug>(coc-implementation)
    nmap gr <Plug>(coc-references)
    imap <C-k> <Plug>(coc-snippets-expand)
    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'
    function! s:show_documentation()
        if index(['vim','help'], &filetype) >= 0
            execute 'help '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction
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
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    nnoremap <leader>to :execute 'split <bar> resize'. (winheight(0) * 2/5). ' <bar> terminal'<CR>
    nnoremap <leader>tO :terminal<CR>
    nnoremap <leader>th :split <bar> terminal<CR>
    nnoremap <leader>tv :vsplit <bar> terminal<CR>
    nnoremap <leader>tt :tabedit <bar> terminal<CR>
    nnoremap <leader>te V:call SendToNvimTerminal()<CR>$
    vnoremap <leader>te <Esc>:call SendToNvimTerminal()<CR>
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
    tnoremap <C-h> <C-w>h
    tnoremap <C-j> <C-w>j
    tnoremap <C-k> <C-w>k
    tnoremap <C-l> <C-w>l
    nnoremap <leader>to :execute 'terminal ++close ++rows='. winheight(0) * 2/5<CR>
    nnoremap <leader>tO :terminal ++curwin ++close<CR>
    nnoremap <leader>th :terminal ++close<CR>
    nnoremap <leader>tv :vertical terminal ++close<CR>
    nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
    nnoremap <leader>te V:call SendToTerminal()<CR>$
    vnoremap <leader>te <Esc>:call SendToTerminal()<CR>
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
    vnoremap <C-c> "+y<Esc>
    if has('gui_running')
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
