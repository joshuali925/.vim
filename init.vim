" ===================== Plugins =========================
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'lfilho/cosco.vim', { 'on': 'CommaOrSemiColon' }
Plug 'jiangmiao/auto-pairs'
Plug 'chiel92/vim-autoformat', { 'on': 'Autoformat' }
Plug 'terryma/vim-multiple-cursors'
Plug 'majutsushi/tagbar'
Plug 'skywind3000/asyncrun.vim'
Plug 'w0rp/ale', { 'for': 'python' }
Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer' }
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()

" ===================== Themes ==========================
set t_Co=256
set background=dark
colorscheme one
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='onedark'

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
nnoremap <F4> :let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'<CR>
nnoremap <F5> :TagbarToggle<CR>
nnoremap <F6> :call ToggleDiff()<CR>
nnoremap <F7> :call ToggleFold()<CR>
imap <F12> <C-o><F12>
nnoremap <F12> :call TogglePaste()<CR>
nnoremap 0 ^
nnoremap - $
nnoremap H :wincmd h<CR>
nnoremap J :wincmd j<CR>
nnoremap K :wincmd k<CR>
nnoremap L :wincmd l<CR>
vnoremap < <gv
vnoremap > >gv
nnoremap Y y$
nnoremap , ;
nnoremap ;, ,
nmap <leader>f <Plug>(easymotion-bd-w)
nmap <leader>F <Plug>(easymotion-bd-f)
inoremap ;; <Esc>:CommaOrSemiColon<CR>$
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
inoremap <CR> <CR><Space><BS>
nnoremap <C-j> J
inoremap <C-c> <C-o>:stopinsert<CR>
nnoremap <C-c> :AsyncStop!<CR>
inoremap <C-l> <C-o>:stopinsert<CR>
vnoremap <C-l> <Esc>
nnoremap <C-l> :nohlsearch <bar> let @/='QwQ'<CR><C-l>
nnoremap <C-b> :NERDTreeToggle<CR>
imap <C-f> <Esc><C-f>
nnoremap <C-f> :Autoformat<CR>
imap <C-g> <Esc><C-g>
nnoremap <C-g> :%s/\(\n\n\)\n\+/\1/<CR>
inoremap <C-j> <C-o>A
inoremap <C-b> <C-o>b
inoremap <C-e> <C-o>e
inoremap <M-o> <Esc>o
imap <leader>r <F11>
nmap <leader>r <F11>
vnoremap <leader>j gj
vnoremap <leader>k gk
nnoremap <leader>j gj
nnoremap <leader>k gk
inoremap <leader>( <C-o>:stopinsert<CR>xEp
inoremap <leader>) <C-o>:stopinsert<CR>x$p
inoremap <leader>w <C-o>:stopinsert <bar> w!<CR>
nnoremap <leader>w :w!<CR>
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
let g:EfficientMode = 0
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax enable
set backspace=eol,start,indent
set mouse=nv
set numberwidth=2
set number
if g:EfficientMode == 0
    set relativenumber
    set cursorline
    " set cursorcolumn
endif
augroup LineNum_NoAutoComment_RestorePos_AutoSource
    autocmd!
    if g:EfficientMode == 0
        autocmd FocusGained,InsertLeave * if &buftype != 'terminal' | set relativenumber | endif
        autocmd FocusLost,InsertEnter * if &buftype != 'terminal' | set norelativenumber | endif
    endif
    autocmd FileType * setlocal formatoptions-=cro
    autocmd FileType python inoremap <buffer> # X<C-h>#<Space>
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
set autochdir
set wrap
set linebreak
set showcmd
set showmatch
set showmode
set title
set ruler
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
set undodir=$HOME/.cache/vim/undo
set undolevels=1000
set undoreload=10000
set lazyredraw
set noswapfile
set nowritebackup
set nobackup
let g:netrw_dirhistmax=0

" =================== Compare ===========================
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
let g:FoldMethod = 0
function! ToggleFold()
    if g:FoldMethod == 0
        exec 'normal! zM'
    else
        exec 'normal! zR'
    endif
    let g:FoldMethod = 1 - g:FoldMethod
endfunction

" ======================= Paste =========================
function! TogglePaste()
    if &paste
        set nopaste number relativenumber
        set mouse=nv
    else
        set paste nonumber norelativenumber
        set mouse=
    endif
    silent exec '!ALEToggleBuffer'
endfunction

" ======================= Format ========================
augroup Format
    autocmd!
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent exec '!~/.vim/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> :edit! <bar> :redraw!<CR>
augroup END
let g:formatters_python = ['yapf']
set omnifunc=syntaxcomplete#Complete
" autocmd FileType python set omnifunc=python3complete#Complete
let g:ale_python_flake8_args = '--ignore=E501'
let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_flake8_options = '--ignore=E501'

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
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(cmdline)
    let expanded_cmdline = a:cmdline
    let expanded_cmdline = substitute(expanded_cmdline, './%<', './'. fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%<', fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%', fnameescape(expand('%')), '')
    if bufexists('[Output]') > 0
        exec 'wincmd j'
        setlocal modifiable
        exec '%d'
    else
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap nocursorline nocursorcolumn
        silent exec '0f | file [Output] | resize '. (winheight(0) * 4/5)
        nnoremap <buffer> <Space> :q<CR>
        nnoremap <buffer> t :wincmd T<CR>
        nnoremap <buffer> w :set wrap!<CR>
    endif
    call setline(1, 'Run: '. expanded_cmdline)
    call setline(2, substitute(getline(1), '.', '=', 'g'))
    exec '$read !'. expanded_cmdline
    setlocal nomodifiable
    exec 'wincmd k | wincmd j | wincmd k'
endfunction
imap <F10> <Esc><F10>
imap <F11> <Esc><F11>
let g:asyncrun_open = 12
augroup RunCode
    autocmd!
    " autocmd FileType python nnoremap <buffer> <F10> :update <bar> exec '!clear && python %'. b:args<CR>
    " autocmd FileType c nnoremap <buffer> <F10> :update <bar> exec '!clear && gcc % -o %< -g && ./%<'. b:args<CR>
    " autocmd FileType cpp nnoremap <buffer> <F10> :update <bar> exec '!clear && g++ % -o %< -g && ./%<'. b:args<CR>
    " autocmd FileType java nnoremap <buffer> <F10> :update <bar> exec '!clear && javac % && java %<'. b:args<CR>
    autocmd FileType python nnoremap <buffer> <F10> :update <bar> exec 'AsyncRun -raw python %'. b:args<CR>
    autocmd FileType c nnoremap <buffer> <F10> :update <bar> exec 'AsyncRun gcc % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType cpp nnoremap <buffer> <F10> :update <bar> exec 'AsyncRun g++ % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType java nnoremap <buffer> <F10> :update <bar> exec 'AsyncRun javac % && java %<'. b:args<CR>
    autocmd FileType python nnoremap <buffer> <F11> :update <bar> call RunShellCommand('python %'. b:args)<CR>
    autocmd FileType c nnoremap <buffer> <F11> :update <bar> call RunShellCommand('gcc % -o %< -g && ./%<'. b:args)<CR>
    autocmd FileType cpp nnoremap <buffer> <F11> :update <bar> call RunShellCommand('g++ % -o %< -g && ./%<'. b:args)<CR>
    autocmd FileType java nnoremap <buffer> <F11> :update <bar> call RunShellCommand('javac % && java %<'. b:args)<CR>
augroup END

" ============== NERDTree, ctrlp, motion ================
let NERDTreeWinSize = 23
let NERDTreeShowHidden = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*
let g:ctrlp_custom_ignore = '\v[\/]\.(tmp|git|oh-my-zsh|plugged|config|local|cache)$'
let g:ctrlp_cache_dir = '~/.cache/ctrlp'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_show_hidden = 1
let g:EasyMotion_smartcase = 1

" ================== YouCompleteMe ======================
set completeopt=menuone
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>a :YcmCompleter FixIt<CR>
let g:ycm_global_ycm_extra_conf='~/.config/nvim/plugged/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
" also add to .ycm_extra_conf.py:
" '-isystem',
" '/usr/include',
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_key_list_stop_completion = ['<C-x>']
let g:UltiSnipsExpandTrigger='<C-k>'
let g:UltiSnipsJumpForwardTrigger='<TAB>'
let g:UltiSnipsJumpBackwardTrigger='<S-TAB>'

" =================== Terminal ==========================
tnoremap <C-k> <C-\><C-n>:wincmd k<CR>
tnoremap <Esc> <C-\><C-n>
tmap <F1> <C-\><C-n><F1>
tmap <F2> <C-\><C-n><F2>
tmap <F3> <C-\><C-n><F3>
nnoremap <silent> <F9> :tabedit <bar> set nonumber norelativenumber nocursorline nocursorcolumn <bar> terminal<CR>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
nnoremap <C-k> :call ToggleTerm()<CR>
function! ToggleTerm()
    if bufwinnr('term://*') > 0
        exec 'wincmd j | startinsert'
    else
        exec 'split | set nonumber norelativenumber nocursorline nocursorcolumn | resize'. (winheight(0) * 2/5). ' | terminal'
    endif
endfunction
