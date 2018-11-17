" ==================== Settings =========================
let g:Theme = 1
let g:TrueColors = 1
let g:AllExtensions = 1
" Completion 0 = default, 1 = YouCompleteMe, 2 = deoplete
let g:Completion = 1
let g:PythonPath = '/usr/bin/python'

" ===================== Plugins =========================
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gdiff'] }
Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
Plug 'tpope/vim-repeat'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'lfilho/cosco.vim', { 'on': 'CommaOrSemiColon' }
Plug 'jiangmiao/auto-pairs'
Plug 'chiel92/vim-autoformat', { 'on': 'Autoformat' }
Plug 'terryma/vim-multiple-cursors'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'dahu/vim-fanfingtastic'
Plug 'sheerun/vim-polyglot'
if g:AllExtensions == 1
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-surround'
    Plug 'easymotion/vim-easymotion'
    Plug 'w0rp/ale'
    set cursorline
else
    Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }
    " Plug 'liuchengxu/eleline.vim'
    set statusline=%<[%{mode()}]\ %f\ %{GetPasteStatus()}%h%m%r%=%-14.(%c%V%)%l/%L\ %P
endif
if g:Completion == 1
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer' }
    Plug 'sirver/ultisnips'
    Plug 'honza/vim-snippets'
elseif g:Completion == 2
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'Shougo/neco-vim'
    Plug 'Shougo/neco-syntax'
    Plug 'zchee/deoplete-jedi'
    Plug 'sirver/ultisnips'
    Plug 'honza/vim-snippets'
endif
call plug#end()

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
imap <F8> <C-o><F8>
nnoremap <F8> :call TogglePaste()<CR>
imap <F9> <ESC><F9>a
nnoremap <F9> :call TogglePreview()<CR>
nmap , <Plug>fanfingtastic_;
nmap ;, <Plug>fanfingtastic_,
nnoremap 0 ^
nnoremap - $
nnoremap J gj
vnoremap J gj
nnoremap K gk
vnoremap K gk
nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv
nnoremap Y y$
inoremap ;; <Esc>:CommaOrSemiColon<CR>$
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
nnoremap Q @q
nnoremap gf <C-w>gf
nnoremap gn *
nnoremap gN *NN
nnoremap gcc :Commentary<CR>
vnoremap gcc :Commentary<CR>
vnoremap " c"<C-r><C-p>""<Esc>
vnoremap ' c'<C-r><C-p>"'<Esc>
vnoremap ( c(<C-r><C-p>")<Esc>
vnoremap [ c[<C-r><C-p>"]<Esc>
vnoremap { c[<C-r><C-p>"}<Esc>
inoremap <CR> <CR><Space><BS>
inoremap <M-o> <Esc>o
inoremap <C-d> <C-o>dd
nnoremap <C-c> :silent! AsyncStop!<CR>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
inoremap <C-l> <C-o>:stopinsert<CR>
vnoremap <C-l> <Esc>
nnoremap <C-l> :nohlsearch <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <C-b> :NERDTreeToggle<CR>
imap <C-f> <Esc>V<C-f>a
nnoremap <C-f> :Autoformat<CR>
vnoremap <C-f> :'<,'>Autoformat<CR>$
nmap <C-g> :%s/\(\n\n\)\n\+/\1/<CR><C-l>
nnoremap <C-p> :CtrlP<CR>
nnoremap <C-j> :call ToggleFileSplit()<CR>
nmap <leader>f <Plug>(easymotion-bd-w)
nmap <leader>F <Plug>(easymotion-bd-f)
nnoremap <leader>j J
nnoremap <leader>k K
nnoremap <leader>T :Tabularize /
inoremap <leader>w <ESC>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :w !sudo tee %<CR>
nnoremap <leader>Q :mksession! ~/.cache/vim/session.vim <bar> wqa!<CR>
nnoremap <leader>L :silent source ~/.cache/vim/session.vim<CR>
nnoremap <leader>q :q<CR>
vnoremap <leader>q <Esc>:q<CR>
nnoremap <leader>u :earlier 10s<CR>
nnoremap <leader>p "0p
nnoremap <leader>P "0P
nnoremap <leader>com o<Esc>55i=<Esc>:Commentary<CR>
nnoremap <leader>vim :tabedit $MYVIMRC<CR>

" ======================= Basics ========================
filetype plugin indent on
syntax enable
let &t_SI.="\e[6 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[2 q"
set nocompatible
set backspace=eol,start,indent
set mouse=nv
set numberwidth=2
set number
set autochdir
set wrap
set linebreak
set showcmd
set showmatch
set showmode
set title
set ruler
set showtabline=2
set laststatus=2
set wildmenu
set splitright
set splitbelow
set scrolloff=3
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
set autoread
set history=500
set sessionoptions-=buffer
set undofile
set undodir=~/.cache/vim/undo
set undolevels=1000
set undoreload=10000
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
augroup RestoreCursor_AutoSource_Format_PythonComment
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent exec '!~/.vim/others/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> :edit! <bar> :redraw!<CR>
    autocmd FileType * setlocal formatoptions-=cro
    autocmd FileType python inoremap <buffer> # <Space><C-h>#<Space>
augroup END

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
set foldmethod=indent
set foldlevel=99
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
        return "[paste]"
    else
        return ""
    endif
endfunction

" ======================= Preview =======================
set previewheight=7
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
    while b_name=~'NERD_tree' || b_name=~'NetrwTreeListing' || b_name=~'__Tagbar__' || b_name=~'!/bin/'
        exec 'wincmd w'
        let b_name = bufname('%')
    endwhile
endfunction

" =================== Other plugins =====================
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'normal'
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
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,*/node_modules/*
let g:ctrlp_custom_ignore = '\v[\/](tmp|.git|.oh-my-zsh|plugged|node_modules|.config|.local|.cache)$'
let g:ctrlp_cache_dir = '~/.cache/ctrlp'
let g:ctrlp_show_hidden = 1
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_width = 25
let g:tagbar_singleclick = 1
let g:tagbar_iconchars = [ '+', '-' ]

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
imap <leader>r <F11>
nmap <leader>r <F11>
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
set completeopt=menuone
" let g:ycm_path_to_python_interpreter='' " for ycmd, don't change
let g:ycm_python_binary_path=g:PythonPath " for JediHTTP
let g:deoplete#sources#jedi#python_path=g:PythonPath
function! SimpleComplete()
    if pumvisible()
        return "\<C-n>"
    endif
    let column = col('.')
    let line = getline('.')
    if !(column>1 && strpart(line, column-2, 3)=~'^\w')
        let pre = line[column-2]
        if pre == '.'
            return "\<C-x>\<C-o>\<C-p>"
        elseif pre == '/'
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
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    imap <expr> <C-c> pumvisible() ? "\<C-y>\<C-c>" : "\<C-c>"
elseif g:Completion == 1
    inoremap <expr> <CR> pumvisible() ? "\<ESC>a" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>\<ESC>a" : "\<C-x>"
    nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <leader>a :YcmCompleter FixIt<CR>
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_semantic_triggers = { 'c,cpp,python,java': ['re!\w{2}'] }
    " copy ~/.vim/others/.ycm_extra_conf.py over, also add
    " '-isystem',
    " '/path/to/include'
    let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    let g:UltiSnipsExpandTrigger = '<C-k>'
    let g:UltiSnipsJumpForwardTrigger = '<TAB>'
    let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
elseif g:Completion == 2
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-d>"
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? deoplete#close_popup() : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    let g:deoplete#enable_at_startup = 1
    let g:UltiSnipsExpandTrigger = '<C-k>'
    let g:UltiSnipsJumpForwardTrigger = '<TAB>'
    let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
endif

" =================== Terminal ==========================
" do not tmap <ESC> in vim 8
tnoremap <F1> <C-w><C-w>
tnoremap <F2> <C-\><C-n>gT
tnoremap <F3> <C-\><C-n>gt
tnoremap <C-u> <C-\><C-n>
tnoremap <C-d> <C-d><C-\><C-n>:q!<CR>
tnoremap <C-k> <C-w>5k
nnoremap <C-k> :call ToggleTerm()<CR>
nnoremap <leader>t V:call SendToTerminal()<CR>$
vnoremap <leader>t <ESC>:call SendToTerminal()<CR>
function! ToggleTerm()
    let term_winnr = bufwinnr('!/bin/*')
    if term_winnr > 0
        exec term_winnr. 'wincmd w'
        if term_getstatus(bufnr('%')) == 'running,normal'
            exec 'normal a'
        endif
    else
        exec 'split | set nonumber norelativenumber nocursorline nocursorcolumn | resize'. (winheight(0) * 2/5). ' | term ++curwin'
    endif
endfunction
function! SendToTerminal()
    let buff_n = term_list()
    if len(buff_n) > 0
        let buff_n = buff_n[0]
        let lines = getline(getpos("'<")[1], getpos("'>")[1])
        for l in lines
            if l!='' || len(lines)==1
                call term_sendkeys(buff_n, l. "\<CR>")
                sleep 10m
            endif
        endfor
    endif
endfunction
