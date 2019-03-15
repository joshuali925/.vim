" ==================== Settings ========================= {{{
let g:Theme = 1
let g:TrueColors = 1
let g:Completion = 1  " 0 = default, 1 = YouCompleteMe, 2 = deoplete, 3 = ncm2, 4 = mucomplete
let g:PythonPath = 'python'
let g:ExecCommand = g:PythonPath. ' %'
" }}}

" ===================== Plugins ========================= {{{
call plug#begin('~/.vim/plugged')
Plug 'skywind3000/quickmenu.vim', { 'on': [] }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'terryma/vim-multiple-cursors', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-f)'] }
Plug 'dahu/vim-fanfingtastic', { 'on': ['<Plug>fanfingtastic_f', '<Plug>fanfingtastic_t', '<Plug>fanfingtastic_F', '<Plug>fanfingtastic_T'] }
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gdiff'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
Plug 'tpope/vim-surround', { 'on': ['<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround', '<Plug>VgSurround'] }
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'sillybun/vim-autodoc', { 'on': [] }  "for lazy load
Plug 'Yggdroot/LeaderF'  "load on startup to record MRU
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-repeat'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'jiangmiao/auto-pairs'
Plug 'shougo/echodoc.vim'
Plug 'davidhalter/jedi-vim', { 'on': [] }
" Plug 'sheerun/vim-polyglot'
" Plug 'w0rp/ale'
if g:Completion > 0
    Plug 'sirver/ultisnips', { 'for': ['vim', 'c', 'cpp', 'java', 'python'] }
    Plug 'honza/vim-snippets', { 'for': ['vim', 'c', 'cpp', 'java', 'python'] }
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
    " lazy load doesn't seem to work
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'Shougo/neco-syntax'
    Plug 'ncm2/ncm2-syntax'
    Plug 'ncm2/ncm2-ultisnips', { 'for': ['vim', 'c', 'cpp', 'java', 'python'] }
    Plug 'ncm2/ncm2-jedi', { 'for': 'python' }
elseif g:Completion == 4
    Plug 'lifepillar/vim-mucomplete'
endif
call plug#end()
silent! call yankstack#setup()
" }}}

" ===================== Themes ========================== {{{
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
" 256-colors support g:Theme < 0
if g:Theme == -2
    set background=light
    colorscheme solarized
elseif g:Theme == -1
    set background=dark
    colorscheme one_modified
elseif g:Theme == 0
    set background=light
    colorscheme solarized8
elseif g:Theme == 1
    set background=light
    colorscheme solarized8_flat
elseif g:Theme == 2
    set background=dark
    colorscheme onedark
elseif g:Theme == 3
    set background=dark
    colorscheme solarized8
elseif g:Theme == 4
    set background=dark
    colorscheme molokai
endif
" }}}

" ====================== Shortcuts ====================== {{{
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
imap <F8> <Esc><F8>
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
nnoremap - $
vnoremap - $h
noremap <Down> gj
noremap <Up> gk
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
nnoremap <leader>h :WhichKey ';'<CR>
nnoremap <leader>l :nohlsearch <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <leader>m :call LoadQuickmenu()<CR>
nnoremap <leader>ta :Tabularize /
nnoremap <leader>tE :exec getline('.')<CR>``
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
" }}}

" ======================= Basics ======================== {{{
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
set foldmethod=marker
set foldlevel=99
set belloff=all
set history=500
set sessionoptions-=buffer
set undofile
set undolevels=1000
set undoreload=10000
set undodir=~/.cache/vim/undo
set tags=./.tags;,.tags
set viminfo+=n~/.cache/vim/viminfo
set encoding=utf-8
set timeoutlen=1500
set ttimeoutlen=40
set lazyredraw
set noswapfile
set nowritebackup
set nobackup
set statusline=%<[%{mode()}]\ %f\ %{GetPasteStatus()}%h%m%r%=%-14.(%c%V%)%l/%L\ %P
" }}}

" ====================== Autocmd ======================== {{{
augroup RestoreCursor_AutoSource_Format_PyComment_InsertColon_HighlightSelf
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exec "normal! g'\"zz" | endif
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent exec '!~/.vim/others/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> :edit! <bar> :redraw!<CR>
    autocmd FileType * setlocal formatoptions=jql
    autocmd FileType python inoremap <buffer> # <Space><C-h>#<Space>
    autocmd FileType c,cpp,java inoremap <buffer> ;; <C-o>$;
    autocmd FileType python inoremap <buffer> ;; <C-o>$:
    autocmd FileType python syntax keyword pythonSelf self | highlight def link pythonSelf Special
augroup END
" }}}

" ====================== LazyLoad ======================= {{{
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
function! LoadJedi()
    let g:jedi#auto_initialization = 1
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#completions_enabled = 0
    let g:jedi#documentation_command = 'K'
    let g:jedi#rename_command = '<leader>R'
    let g:jedi#goto_command = '<leader>d'
    let g:jedi#usages_command = '<leader>a'
    call plug#load('jedi-vim')
endfunction
function! LoadRecordParameter()
    call plug#load('vim-autodoc')
    RecordParameter
endfunction
function! LoadQuickmenu()
    nnoremap <leader>m :call quickmenu#toggle(0)<CR>
    call plug#load('quickmenu.vim')
    let g:quickmenu_options = "HL"
    call g:quickmenu#reset()
    call g:quickmenu#header('QvQ')
    call g:quickmenu#append('# Actions', '')
    call g:quickmenu#append('Insert Comment Line', 'call InsertCommentLine()')
    call g:quickmenu#append('Insert Time', "put=strftime('%x %X')")
    call g:quickmenu#append('Git Diff', 'Gdiff', 'use fugitive Gdiff on current document')
    call g:quickmenu#append('Git Status', 'Gstatus', 'use fugitive Gstatus on current document')
    call g:quickmenu#append('Record Python Parameter', 'call LoadRecordParameter()', '', 'python')
    call g:quickmenu#append('Load Jedi', 'call LoadJedi()', '', 'python')
    call g:quickmenu#append('# Toggle', '')
    call g:quickmenu#append('NERDTree', 'NERDTreeToggle')
    call g:quickmenu#append('Undo Tree', 'UndotreeToggle')
    call g:quickmenu#append('Tagbar', 'TagbarToggle')
    call g:quickmenu#append('Table Mode', 'TableModeToggle')
    call g:quickmenu#append('Diff %{g:DiffOn==1? "[x]" :"[ ]"}', 'call ToggleDiff()')
    call g:quickmenu#append('Fold %{g:FoldOn==1? "[x]" :"[ ]"}', 'call ToggleFold()')
    call g:quickmenu#append('Paste %{&paste? "[x]" :"[ ]"}', 'call TogglePaste()')
    call g:quickmenu#append('Preview %{g:PreviewOn==1? "[x]" :"[ ]"}', 'call TogglePreview()')
    call g:quickmenu#toggle(0)
endfunction
" }}}

" ================= Insert Comment Line ================= {{{
function! InsertCommentLine()
    exec 'normal! o'
    exec 'normal! 55i='
    exec 'Commentary'
endfunction
" }}}

" ======================= Macro ========================= {{{
function! ExecuteMacroOverVisualRange()
    echo '@'.getcmdline()
    exec ":'<,'>normal @".nr2char(getchar())
endfunction
function! EditRegister() abort
    let r = nr2char(getchar())
    call feedkeys("q:ilet @". r. " = \<c-r>\<c-r>=string(@". r. ")\<cr>\<esc>0f'", 'n')
endfunction
" }}}

" ======================== Diff ========================= {{{
let g:DiffOn = 0
function! ToggleDiff()
    if g:DiffOn == 0
        exec 'windo diffthis'
    else
        exec 'windo diffoff'
    endif
    let g:DiffOn = 1 - g:DiffOn
endfunction
" }}}

" ===================== Fold code ======================= {{{
let g:FoldOn = 0
function! ToggleFold()
    if g:FoldOn == 0
        exec 'normal! zM'
    else
        exec 'normal! zR'
    endif
    let g:FoldOn = 1 - g:FoldOn
endfunction
" }}}

" ======================= Paste ========================= {{{
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
" }}}

" ======================= Preview ======================= {{{
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
" }}}

" =================== Other plugins ===================== {{{
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
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,*/node_modules/*,*/venv/*,*/\.env/*
let g:Lf_WildIgnore = { 'dir':['tmp','.git','.oh-my-zsh','plugged','node_modules','venv','.env','.local','*cache*'],'file':[] }
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
let g:echodoc_enable_at_startup = 1
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
" }}}

" ==================== Execute code ===================== {{{
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
" }}}

" ==================== AutoComplete ===================== {{{
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
if g:Completion == 0  " default
    set omnifunc=syntaxcomplete#Complete
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : SimpleComplete()
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-d>"
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    imap <expr> <C-c> pumvisible() ? "\<C-y>\<C-c>" : "\<C-c>"
elseif g:Completion == 1  " YouCompleteMe
    inoremap <expr> <CR> pumvisible() ? "\<Esc>a" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>\<Esc>a" : "\<C-x>"
    nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <leader>a :YcmCompleter FixIt<CR>
    " let g:ycm_show_diagnostics_ui = 0
    " let g:ycm_semantic_triggers = { 'c,cpp,python,java': ['re!\w{2}'] }  "auto semantic complete
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    " for c include files, add to .ycm_extra_conf.py
    " '-isystem',
    " '/path/to/include'
    let g:ycm_global_ycm_extra_conf = '~/.vim/others/.ycm_extra_conf.py'
    let g:echodoc#enable_force_overwrite = 1
elseif g:Completion == 2  " deoplete
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-d>"
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? deoplete#close_popup() : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    let g:deoplete#enable_at_startup = 1
elseif g:Completion == 3  " ncm2
    set completeopt+=noinsert,noselect
    augroup ncm2
        autocmd!
        autocmd BufEnter * call ncm2#enable_for_buffer()
    augroup end
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
elseif g:Completion == 4  " mucomplete
    set completeopt+=noselect
    set shortmess+=c
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#chains = {}
    let g:mucomplete#chains.default = ['path', 'ulti', 'keyn', 'omni', 'file']
endif
" }}}

" ====================== Terminal ======================= {{{
" do not tmap <Esc> in vim 8
tnoremap <F1> <C-w><C-w>
tnoremap <F2> <C-\><C-n>gT
tnoremap <F3> <C-\><C-n>gt
tnoremap <C-u> <C-\><C-n>
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
tnoremap <leader>to <C-w>5k
nnoremap <leader>to :call ToggleTerm()<CR>
nnoremap <leader>tO :term ++curwin<CR>
nnoremap <leader>te V:call SendToTerminal()<CR>$
vnoremap <leader>te <Esc>:call SendToTerminal()<CR>
function! ToggleTerm()
    let term_winnr = bufwinnr('!/bin/bash')
    if term_winnr < 1
        let term_winnr = bufwinnr('!/bin/zsh')
    endif
    if term_winnr < 1
        let term_winnr = bufwinnr('!zsh')
    endif
    if term_winnr < 1
        exec 'botright new | set nonumber norelativenumber nocursorline nocursorcolumn | resize'. (winheight(0) * 2/5). ' | terminal ++curwin ++close'
    else
        exec '5wincmd j'
        let status = term_getstatus(bufnr('%'))
        if status == ''
            exec term_winnr. 'wincmd w'
            let status = term_getstatus(bufnr('%'))
        endif
        if status == 'running,normal'
            exec 'normal a'
        endif
    endif
endfunction
function! SendToTerminal()
    let buff_n = term_list()
    if len(buff_n) > 0
        let buff_n = buff_n[0]
        let lines = getline(getpos("'<")[1], getpos("'>")[1])
        for l in lines
            call term_sendkeys(buff_n, l. "\<CR>")
            sleep 10m
        endfor
    endif
endfunction
" }}}

" ================== Windows settings =================== {{{
" first manually create %UserProfile%/.cache/vim/undo directory
" plugins are installed to %UserProfile%/.vim
if has('win32')
    vnoremap <C-c> "+y<Esc>
    noremap <leader>W :silent exec '!sudo /c gvim "%:p"'<CR>
    let &t_SI=""
    let &t_SR=""
    let &t_EI=""
    if has('gui_running')
        nnoremap <leader>L :silent exec '!venv & gvim "%:p"'<CR>:q<CR>
        set guifont=Consolas:h11:cANSI
        set guioptions=grt!
        set guicursor+=a:blinkon0
        if &columns < 85
            set lines=25
            set columns=85
        endif
    endif
endif
" }}}
