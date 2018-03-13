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
Plug 'chun-yang/auto-pairs'
Plug 'chiel92/vim-autoformat', { 'on': 'Autoformat' }
Plug 'terryma/vim-multiple-cursors'
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
nnoremap 0 ^
nnoremap - $
vnoremap < <gv
vnoremap > >gv
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
nnoremap <F4> *
imap <F12> <C-o><F12>
nnoremap <F12> :set paste! <bar> set number! <bar> set relativenumber!<CR>
inoremap <C-c> <C-o>:stopinsert<CR>
inoremap <C-l> <C-o>:stopinsert<CR>
nnoremap <C-l> :nohlsearch <bar> let @/="QwQ"<CR><C-l>
nnoremap <C-b> :NERDTreeToggle<CR>
imap <C-f> <C-o><C-f>
nnoremap <C-f> :Autoformat<CR>
imap <C-g> <C-o><C-g>
nnoremap <C-g> :%s/\(\n\n\)\n\+/\1/<CR>
inoremap ;; <Esc>:CommaOrSemiColon<CR>$
inoremap <C-j> <C-o>A
inoremap <C-b> <C-o>b
inoremap <C-w> <C-o>w
inoremap <C-e> <C-o>e
nmap f <Plug>(easymotion-bd-w)
nmap F <Plug>(easymotion-bd-f)
nnoremap <leader>u :earlier 10s<CR>
nnoremap <leader>w :w!<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>com o<Esc>55i=<Esc>:Commentary<CR>

" ======================= Basics ========================
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax enable
set mouse=nv
set cursorline
set cursorcolumn
set backspace=eol,start,indent
set numberwidth=4
set number relativenumber
augroup linenum_currdir_comment_restorePos
    autocmd!
    autocmd FocusGained,InsertLeave * if &buftype != 'terminal' | set relativenumber | endif
    autocmd FocusLost,InsertEnter * if &buftype != 'terminal' | set norelativenumber | endif
    " autocmd BufEnter * if &buftype != 'terminal' | lcd %:p:h | endif
    autocmd FileType * setlocal formatoptions-=cro
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
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
" set scrolloff=50
set autoread
set history=500
set lazyredraw
set noswapfile
set nowb
set nobackup
let g:netrw_dirhistmax=0

set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set hlsearch
set incsearch
set ignorecase
set smartcase

nnoremap <leader>vim :tabedit $MYVIMRC<CR>
augroup auto_source
    autocmd!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

" =================== Compare ===========================
let g:DiffOn = 0
nnoremap <F6> :call ToggleDiff()<CR>
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
nnoremap <F5> :call ToggleFold()<CR>
function! ToggleFold()
    if g:FoldMethod == 0
        exec "normal! zM"
    else
        exec "normal! zR"
    endif
    let g:FoldMethod = 1 - g:FoldMethod
endfunction

" ======================= Format ========================
autocmd FileType c,java nnoremap <buffer> <C-f> :update <bar> silent exec "!~/.vim/astyle % --style=k/r -T4ncpUHk1A2 > /dev/null" <bar> :edit! <bar> :redraw!<CR>
let g:formatters_python = ['yapf']

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
        exec 'wincmd j | wincmd c'
    endif
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap nocursorline nocursorcolumn
    silent exec '0f | file [Output] | resize '. (winheight(0) * 4/5)
    nnoremap <buffer> <Space> :q<CR>
    nnoremap <buffer> t :wincmd T<CR>
    nnoremap <buffer> w :set wrap!<CR>
    call setline(1, 'Run: '. expanded_cmdline)
    call setline(2, substitute(getline(1), '.', '=', 'g'))
    exec '$read !'. expanded_cmdline
    setlocal nomodifiable
    exec 'wincmd k | wincmd j | wincmd k'
endfunction
imap <F10> <Esc><F10>
imap <F11> <Esc><F11>
augroup run_code
    autocmd!
    autocmd FileType python nnoremap <buffer> <F10> :update <bar> exec '!python %'. b:args<CR>
    autocmd FileType c nnoremap <buffer> <F10> :update <bar> exec '!gcc % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType java nnoremap <buffer> <F10> :update <bar> exec '!javac % && java %<'. b:args<CR>
    autocmd FileType python nnoremap <buffer> <F11> :update <bar> call RunShellCommand('python %'. b:args)<CR>
    autocmd FileType c nnoremap <buffer> <F11> :update <bar> call RunShellCommand('gcc % -o %< -g && ./%<'. b:args)<CR>
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
let g:ctrlp_show_hidden = 1
let g:EasyMotion_smartcase = 1

" ================== YouCompleteMe ======================
set completeopt=menuone,menu,longest
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>f :YcmCompleter FixIt<CR>
let g:ycm_global_ycm_extra_conf='~/.config/nvim/plugged/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
" also add to .ycm_extra_conf.py:
" '-isystem',
" '/usr/include',
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_key_list_stop_completion = ['<C-x>']
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsJumpForwardTrigger="<TAB>"
let g:UltiSnipsJumpBackwardTrigger="<S-TAB>"

" =================== Terminal ==========================
tnoremap <C-k> <C-\><C-n>:wincmd k<CR>
tnoremap <Esc> <C-\><C-n>
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
