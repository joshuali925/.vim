set nocompatible
set viminfo=
set noswapfile
set nobackup
set nowritebackup
let mapleader=';'

noremap , ;
noremap ;, ,
noremap 0 ^
noremap ^ 0
nnoremap - $
vnoremap - $h
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <Home> g^
noremap <End> g$
noremap <Down> gj
noremap <Up> gk
nnoremap Y y$
nnoremap gp `[v`]
nnoremap ZZ :wq<CR>
nnoremap ZQ :q!<CR>
vnoremap < <gv
vnoremap > >gv
nnoremap <BS> gT
nnoremap \ gt
nnoremap [b gT
nnoremap ]b gt
nnoremap [<Space> O<Esc>
nnoremap ]<Space> o<Esc>
nnoremap [p O<C-r>"<Esc>
nnoremap ]p o<C-r>"<Esc>
nnoremap <C-c> /qwe<CR>:<CR>
nnoremap <leader>n *N
vnoremap <leader>n y/<C-r>"<CR>N
noremap <leader>y "+y
noremap <leader>p "0p
noremap <leader>P "0P
inoremap <leader>w <Esc>:write<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
