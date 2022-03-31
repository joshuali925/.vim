syntax enable
set nocompatible
set backspace=eol,start,indent
set display=lastline
set encoding=utf-8
set lazyredraw
set noswapfile
set nobackup
set nowritebackup
set paste
set hlsearch
set ignorecase
set smartcase
set expandtab
set softtabstop=2
set shiftwidth=2

noremap , ;
noremap ;, ,
nnoremap ;w :update<CR>
nnoremap ;q :quit<CR>
nnoremap <C-c> :nohlsearch<CR>

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee % > /dev/null
