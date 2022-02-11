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

noremap , ;
noremap ;, ,
nnoremap ;w :update<CR>
nnoremap ;q :quit<CR>

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee % > /dev/null
