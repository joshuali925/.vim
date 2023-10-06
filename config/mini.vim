syntax enable
set nocompatible
set backspace=eol,start,indent
set hlsearch
set ignorecase
set smartcase
set expandtab
set softtabstop=2
set shiftwidth=2
set display=lastline
set encoding=utf-8
set timeout
set timeoutlen=1500
set ttimeoutlen=40
set lazyredraw
set noswapfile
set nobackup
set nowritebackup

set paste

noremap , ;
noremap ;, ,
nnoremap ;w :update<CR>
nnoremap ;q :quit<CR>
nnoremap <C-c> :nohlsearch<CR>

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee % > /dev/null
command! CountSearch %s///gn
