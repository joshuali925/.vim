" ==================== Settings =========================
let g:Theme = 2
let g:TrueColors = 1
let g:AllExtensions = 1
let g:Completion = 1  " Completion 0 = default, 1 = YouCompleteMe, 2 = deoplete, 3 = mucomplete
let g:PythonPath = '/usr/bin/python'
let g:ExecCommand = 'python %'

" ===================== Plugins =========================
call plug#begin('~/.config/nvim/plugged')
Plug 'Yggdroot/LeaderF', { 'do': './install.sh', 'on': 'LeaderfFile' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'terryma/vim-multiple-cursors', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-f)'] }
Plug 'dahu/vim-fanfingtastic', { 'on': ['<Plug>fanfingtastic_f', '<Plug>fanfingtastic_t', '<Plug>fanfingtastic_F', '<Plug>fanfingtastic_T'] }
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gdiff'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
Plug 'tpope/vim-surround', { 'on': ['<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround', '<Plug>VgSurround'] }
Plug 'tpope/vim-repeat'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'jiangmiao/auto-pairs'
Plug 'shougo/echodoc.vim'
" Plug 'sheerun/vim-polyglot'
if g:AllExtensions == 1
    " Plug 'ludovicchabant/vim-gutentags'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-surround'
    Plug 'w0rp/ale'
    set cursorline
    let g:ycm_semantic_triggers = { 'c,cpp,python,java': ['re!\w{2}'] }
else
    set statusline=%<[%{mode()}]\ %f\ %{GetPasteStatus()}%h%m%r%=%-14.(%c%V%)%l/%L\ %P
endif
if g:Completion > 0
    Plug 'sirver/ultisnips', { 'for': ['c', 'cpp', 'java', 'python'] }
    Plug 'honza/vim-snippets', { 'for': ['c', 'cpp', 'java', 'python'] }
endif
if g:Completion == 1
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer' }
elseif g:Completion == 2
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'Shougo/neco-syntax'
    Plug 'Shougo/neco-vim', { 'for': 'vim' }
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
elseif g:Completion == 3
    Plug 'lifepillar/vim-mucomplete'
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
endif
call plug#end()
if &runtimepath=~'yankstack' | call yankstack#setup() | endif

" ===================== Themes ==========================
if g:TrueColors == 1
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
else
    set t_Co=256
    let g:solarized_termcolors = 256
    highlight link EasyMotionTarget Search
    highlight link EasyMotionShade Comment
    highlight link EasyMotionTarget2First Search
    highlight link EasyMotionTarget2Second Search
endif
let g:airline#extensions#tabline#enabled = 1
" 256-colors support g:Theme < 0
if g:Theme == -2
    set background=light
    let g:airline_theme = 'solarized'
    colorscheme solarized
elseif g:Theme == -1
    set background=dark
    let g:airline_theme = 'onedark'
    colorscheme one
elseif g:Theme == 0
    set background=light
    let g:airline_theme = 'solarized'
    colorscheme solarized8
elseif g:Theme == 1
    set background=light
    let g:airline_theme = 'solarized'
    colorscheme solarized8_flat
elseif g:Theme == 2
    set background=dark
    let g:airline_theme = 'onedark'
    colorscheme one8
elseif g:Theme == 3
    set background=dark
    let g:airline_theme = 'solarized'
    colorscheme solarized8
elseif g:Theme == 4
    set background=dark
    let g:airline_theme = 'solarized'
    colorscheme molokai
endif

" ====================== Shortcuts ======================
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
nnoremap <F1> :wincmd w<CR>
imap <F2> <Esc><F2>
nnoremap <F2> gT
imap <F3> <Esc><F3>
nnoremap <F3> gt
nnoremap <F4> *N
nnoremap <F5> :TagbarToggle<CR>
nnoremap <F6> :call ToggleDiff()<CR>
nnoremap <F7> :call ToggleFold()<CR>
imap <F8> <Esc><F8>
nnoremap <F8> :call TogglePaste()<CR>
imap <F9> <Esc><F9>a
nnoremap <F9> :call TogglePreview()<CR>
map f <Plug>fanfingtastic_f
map t <Plug>fanfingtastic_t
map F <Plug>fanfingtastic_F
map T <Plug>fanfingtastic_T
map , <Plug>fanfingtastic_;
map ;, <Plug>fanfingtastic_,
map  gc <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap S <Plug>(easymotion-bd-w)
map <leader>f <Plug>(easymotion-bd-f)
nmap ds <Plug>Dsurround
nmap cs <Plug>Csurround
nmap cS <Plug>CSurround
nmap ys <Plug>Ysurround
nmap yS <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
xmap S <Plug>VSurround
xmap gS <Plug>VgSurround
nmap Y y$
noremap 0 ^
noremap - $
noremap J gj
noremap K gk
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
nnoremap Q @q
nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
inoremap <CR> <CR><Space><BS>
nnoremap gf <C-w>gf
nnoremap gp `[v`]
vnoremap " c"<C-r><C-p>""<Esc>
vnoremap ' c'<C-r><C-p>"'<Esc>
vnoremap ( c(<C-r><C-p>")<Esc>
vnoremap [ c[<C-r><C-p>"]<Esc>
vnoremap { c{<C-r><C-p>"}<Esc>
vnoremap <Space> c<Space><C-r><C-p>"<Space><Esc>
nnoremap cr :call EditRegister()<CR>
nnoremap <C-]> <C-w>}
inoremap <C-d> <C-o>dd
nnoremap <C-c> :nohlsearch <bar> silent! AsyncStop!<CR>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-p> :LeaderfFile<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-g> :%s/\(\n\n\)\n\+/\1/<CR><C-l>
nmap <C-f> :call LoadAutoformat()<CR><C-f>
imap <C-f> <Esc>:call LoadAutoformat()<CR>V<C-f>A
vmap <C-f> :call LoadAutoformat()<CR>gv<C-f>
nmap <C-n> :call LoadMultipleCursors()<CR><C-n>
xmap <C-n> :call LoadMultipleCursors()<CR>gv<C-n>
nmap <leader><C-n> :call LoadMultipleCursors()<CR><leader><C-n>
xmap <leader><C-n> :call LoadMultipleCursors()<CR>gv<leader><C-n>
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nmap <leader>o o<Esc>
nmap <leader>O O<Esc>
nnoremap <leader>h :call ToggleFileSplit()<CR>
nnoremap <leader>j J
nnoremap <leader>k K
nnoremap <leader>l :nohlsearch <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <leader>T :Tabularize /
inoremap <leader>w <Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :w !sudo tee %<CR>
nnoremap <leader>Q :mksession! ~/.cache/vim/session.vim <bar> wqa!<CR>
nnoremap <leader>L :silent source ~/.cache/vim/session.vim<CR>
nnoremap <leader>q :q<CR>
vnoremap <leader>q <Esc>:q<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>vim :tabedit $MYVIMRC<CR>
nnoremap <leader>vcom o<Esc>55i=<Esc>:Commentary<CR>
nnoremap <leader>vtime :put=strftime('%x %X')<CR>

" ======================= Basics ========================
filetype plugin indent on
syntax enable
let &t_SI.="\e[6 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[2 q"
if &compatible | set nocompatible | endif
set backspace=eol,start,indent
set mouse=a
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
set textwidth=0
set autoread
set autochdir
set completeopt=menuone
set scrolloff=3
set previewheight=7
set foldmethod=indent
set foldlevel=99
set history=500
set sessionoptions-=buffer
set undofile
set undolevels=1000
set undoreload=10000
set undodir=~/.cache/vim/undo
set tags=./.tags;,.tags
set timeoutlen=1500
set ttimeoutlen=40
set lazyredraw
set noswapfile
set nowritebackup
set nobackup
" built in :Lexplore<CR> settings
let g:netrw_dirhistmax=0
let g:netrw_banner=0
let g:netrw_browse_split=2
let g:netrw_winsize=20
let g:netrw_liststyle=3

" ====================== Autocmd ========================
augroup RestoreCursor_AutoSource_Format_PyComment_InsertColon
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exec "normal! g'\"zz" | endif
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent exec '!~/.vim/others/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> :edit! <bar> :redraw!<CR>
    autocmd FileType * setlocal formatoptions=jql
    autocmd FileType python inoremap <buffer> # <Space><C-h>#<Space>
    autocmd FileType c,cpp,java inoremap <buffer> ;; <C-o>$;
    autocmd FileType python inoremap <buffer> ;; <C-o>$:
augroup END

" ====================== LazyLoad =======================
function! LoadAutoformat()
    nnoremap <C-f> :Autoformat<CR>
    inoremap <C-f> <Esc>V:'<,'>Autoformat<CR>A
    vnoremap <C-f> :'<,'>Autoformat<CR>$
    call plug#load('vim-autoformat')
endfunction
function! LoadMultipleCursors()
    nnoremap <C-n> :call multiple_cursors#new("n", 1)<CR>
    xnoremap <C-n> :<C-u>call multiple_cursors#new("v", 0)<CR>
    nnoremap <leader><C-n> :call multiple_cursors#select_all("n", 1)<CR>
    xnoremap <leader><C-n> :<C-u>call multiple_cursors#select_all("v", 0)<CR>
    call plug#load('vim-multiple-cursors')
endfunction

" ======================== Macro ========================
function! ExecuteMacroOverVisualRange()
    echo '@'.getcmdline()
    exec ":'<,'>normal @".nr2char(getchar())
endfunction
function! EditRegister() abort
    let r = nr2char(getchar())
    call feedkeys("q:ilet @". r. " = \<c-r>\<c-r>=string(@". r. ")\<cr>\<esc>0f'", 'n')
endfunction

" ======================== Diff =========================
let g:DiffOn = 0
function! ToggleDiff()
    if g:DiffOn == 0
        exec 'windo diffthis'
    else
        exec 'windo diffoff'
    endif
    let g:DiffOn = 1 - g:DiffOn
endfunction

" ====================== Fold code ======================
let g:FoldOn = 0
function! ToggleFold()
    if g:FoldOn == 0
        exec 'normal! zM'
    else
        exec 'normal! zR'
    endif
    let g:FoldOn = 1 - g:FoldOn
endfunction

" ======================= Paste =========================
" shift alt drag to select and copy
function! TogglePaste()
    if &paste
        set nopaste number mouse=nv signcolumn=auto
    else
        set paste nonumber norelativenumber mouse= signcolumn=no
    endif
endfunction
function! GetPasteStatus()
    if &paste
        return '[paste]'
    else
        return ''
    endif
endfunction

" ======================= Preview =======================
let g:PreviewOn = 0
function! TogglePreview()
    if g:PreviewOn == 0
        set completeopt+=preview
        echo 'Preview on'
    else
        set completeopt-=preview
        exec 'pclose'
        echo 'Preview off'
    endif
    let g:PreviewOn = 1 - g:PreviewOn
endfunction

" =================== Toggle split ======================
function! ToggleFileSplit()
    exec 'wincmd w'
    let b_name = bufname('%')
    while (b_name=~'NERD_tree' || b_name=~'NetrwTreeListing' || b_name=~'__Tagbar__' || b_name=~'!/bin/' || b_name=~'LeaderF' || getwinvar(0,'&syntax')=='qf' || &pvw)
        exec 'wincmd w'
        let b_name = bufname('%')
    endwhile
endfunction

" =================== Other plugins =====================
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_flake8_options = '--ignore=W291,W293,W391,E261,E302,E305,E501'
let g:asyncrun_open = 12
let g:EasyMotion_smartcase = 1
let g:formatters_python = ['yapf']
let NERDTreeWinSize = 23
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:multi_cursor_select_all_word_key = '<leader><C-n>'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,*/node_modules/*
let g:Lf_WildIgnore = { 'dir':['tmp','.git','.oh-my-zsh','.autojump','plugged','node_modules','.local','*cache*'],'file':[] }
let g:Lf_ShortcutF = '<C-p>'
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_ReverseOrder = 1
" <C-p>: 2<C-p>=mru, 2<C-f>=function, 4<C-p>=grep, type keyword and enter, 4<C-f>=grep current keyword
let g:Lf_CommandMap = { '<C-]>':['<C-v>'],'<C-j>':['<DOWN>'],'<C-k>':['<UP>'],'<TAB>':['<TAB>','<C-p>','<C-f>'] }
let g:Lf_NormalMap = { 'File': [['<C-p>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfMru<CR>'],
            \               ['<C-f>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfFunction<CR>']],
            \       'Mru': [['<C-p>', ':exec g:Lf_py "fileExplManager.quit()"<CR>:AsyncRun! grep -n -R  .<Left><Left>'],
            \               ['<C-f>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfFile<CR>']],
            \  'Function': [['<C-p>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfFile<CR>'],
            \               ['<C-f>', ':exec g:Lf_py "fileExplManager.quit()"<CR>:AsyncRun! grep -n -R <cword> .<CR>']] }
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_width = 25
let g:tagbar_singleclick = 1
let g:tagbar_iconchars = [ '+', '-' ]
let g:gutentags_project_root = ['.project', '.root']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_cache_dir = expand('~/.cache/vim')
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q', '--c++-kinds=+px', '--c-kinds=+px']
let g:echodoc_enable_at_startup = 1

" ==================== Execute code =====================
autocmd FileType * let b:args = ''
command! -complete=file -nargs=* SetArgs call SetArgs(<q-args>)
function! SetArgs(cmdline)
    if a:cmdline == ''
        let b:args = ''
    else
        let b:args = ' '. a:cmdline
    endif
endfunction
let g:OutputCount = 1
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(cmdline)
    let expanded_cmdline = substitute(a:cmdline, './%<', './'. fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%<', fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%', fnameescape(expand('%')), '')
    let curr_bufnr = bufwinnr('%')
    let win_left = winnr('$')
    while win_left>1 && bufname('%')!~'[Output_'
        exec 'wincmd w'
        let win_left = win_left - 1
    endwhile
    if bufname('%') =~ '[Output_'
        setlocal modifiable
        exec '%d'
    else
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap nocursorline nocursorcolumn
        silent exec '0f | file [Output_'. g:OutputCount. '] | resize '. (winheight(0) * 4/5)
        let g:OutputCount = g:OutputCount + 1
        nnoremap <buffer> q :q<CR>
        nnoremap <buffer> w :set wrap!<CR>
    endif
    call setline(1, 'Run: '. expanded_cmdline)
    call setline(2, substitute(getline(1), '.', '=', 'g'))
    exec '$read !'. expanded_cmdline
    setlocal nomodifiable
    exec curr_bufnr. 'wincmd w'
endfunction
imap <F10> <Esc><F10>
imap <F11> <Esc><F11>
imap <F12> <Esc><F12>
imap <leader>r <Esc><leader>r
nmap <leader>r :wall <bar> exec 'AsyncRun '. g:ExecCommand<CR>
augroup RunCode
    autocmd!
    autocmd FileType c nnoremap <buffer> <F10> :update <bar> exec '!clear && gcc % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType cpp nnoremap <buffer> <F10> :update <bar> exec '!clear && g++ % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType java nnoremap <buffer> <F10> :update <bar> exec '!clear && javac % && java %<'. b:args<CR>
    autocmd FileType python nnoremap <buffer> <F10> :update <bar> exec '!clear && '. g:PythonPath. ' %'. b:args<CR>
    autocmd FileType c nnoremap <buffer> <F11> :update <bar> exec 'AsyncRun gcc % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType cpp nnoremap <buffer> <F11> :update <bar> exec 'AsyncRun g++ % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType java nnoremap <buffer> <F11> :update <bar> exec 'AsyncRun javac % && java %<'. b:args<CR>
    autocmd FileType python nnoremap <buffer> <F11> :update <bar> exec 'AsyncRun -raw '. g:PythonPath. ' %'. b:args<CR>
    autocmd FileType c nnoremap <buffer> <F12> :update <bar> call RunShellCommand('gcc % -o %< -g && ./%<'. b:args)<CR>
    autocmd FileType cpp nnoremap <buffer> <F12> :update <bar> call RunShellCommand('g++ % -o %< -g && ./%<'. b:args)<CR>
    autocmd FileType java nnoremap <buffer> <F12> :update <bar> call RunShellCommand('javac % && java %<'. b:args)<CR>
    autocmd FileType python nnoremap <buffer> <F12> :update <bar> call RunShellCommand(g:PythonPath. ' %'. b:args)<CR>
augroup END

" ==================== AutoComplete =====================
" let g:ycm_path_to_python_interpreter='' " for ycmd, don't change
let g:ycm_python_binary_path=g:PythonPath " for JediHTTP
let g:deoplete#sources#jedi#python_path=g:PythonPath
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<TAB>'
let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
function! SimpleComplete()
    if pumvisible()
        return "\<C-n>"
    endif
    let column = col('.')
    let line = getline('.')
    if !(column>1 && strpart(line, column-2, 3)=~'^\w')
        let pre_char = line[column-2]
        if pre_char == '.'
            return "\<C-x>\<C-o>\<C-p>"
        elseif pre_char == '/'
            return "\<C-x>\<C-f>\<C-p>"
        else
            return "\<TAB>"
        endif
    endif
    let substr = matchstr(strpart(line, -1, column+1), "[^ \t]*$")
    let has_slash = match(substr, '\/') != -1
    if has_slash
        return "\<C-x>\<C-f>"
    else
        return "\<C-n>"
    endif
endfunction
" use <C-@> in vim, <C-Space> in nvim for ctrl space
if g:Completion == 0
    set omnifunc=syntaxcomplete#Complete
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : SimpleComplete()
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-d>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    imap <expr> <C-c> pumvisible() ? "\<C-y>\<C-c>" : "\<C-c>"
elseif g:Completion == 1
    inoremap <expr> <CR> pumvisible() ? "\<Esc>a" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>\<Esc>a" : "\<C-x>"
    nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <leader>a :YcmCompleter FixIt<CR>
    " let g:ycm_show_diagnostics_ui = 0
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    " for c include files, add to .ycm_extra_conf.py
    " '-isystem',
    " '/path/to/include'
    let g:ycm_global_ycm_extra_conf = '~/.vim/others/.ycm_extra_conf.py'
    let g:echodoc#enable_force_overwrite = 1
elseif g:Completion == 2
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-d>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? deoplete#close_popup() : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    let g:deoplete#enable_at_startup = 1
elseif g:Completion == 3
    set completeopt+=noselect
    set shortmess+=c
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#chains = {}
    let g:mucomplete#chains.default = ['path', 'ulti', 'keyn', 'omni', 'file']
    let g:jedi#rename_command = '<leader>R'
endif

" =================== Terminal ==========================
tmap <F1> <C-\><C-n><F1>
tmap <F2> <C-\><C-n><F2>
tmap <F3> <C-\><C-n><F3>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-k> <C-\><C-n><C-w>5k
nnoremap <C-k> :call ToggleTerm()<CR>
" nnoremap <silent> <F9> :tabedit <bar> set nonumber norelativenumber nocursorline nocursorcolumn <bar> terminal<CR>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
function! ToggleTerm()
    if bufwinnr('term://*') > 0
        exec 'wincmd j | startinsert'
    else
        exec 'split | set nonumber norelativenumber nocursorline nocursorcolumn | resize'. (winheight(0) * 2/5). ' | terminal'
        exec 'startinsert'
    endif
endfunction
