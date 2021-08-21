" call plug#begin(expand('<sfile>:p:h'). '/plugged')
" Plug ''
" call plug#end()

let &t_SI .= "\<Esc>[6 q"  " cursor shape
let &t_EI .= "\<Esc>[2 q"
set background=dark
syntax enable
filetype plugin indent on
colorscheme gruvbox_material

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
set splitright
set splitbelow
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=2
set shiftwidth=2
set shiftround
set textwidth=0
set autoread
set hidden
set complete=.,w,b,u
set completeopt=menuone
set shortmess+=c
set shortmess-=S
set nrformats-=octal
set scrolloff=2
set sidescrolloff=5
set nostartofline
set display=lastline
set virtualedit+=block
set previewheight=7
set history=1000
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.cache/vim/undo
set viminfo+=n~/.cache/vim/viminfo
set isfname-==
set path=.,,**5
set wildignore+=*/tmp/*,*/\.git/*,*/node_modules/*,*/venv/*,*/\.env/*
set list
set listchars=tab:»\ ,nbsp:␣
set fillchars=vert:│
set encoding=utf-8
set timeout
set timeoutlen=1500
set ttimeoutlen=40
set synmaxcol=1000
set lazyredraw
set noswapfile
set nobackup
set nowritebackup
set wildcharm=<C-z>
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
set grepformat=%f:%l:%c:%m,%f:%l:%m
set statusline=%<[%{mode()}](%{fnamemodify(getcwd(),':t')})\ %F\ %{&paste?'[paste]':''}%h%m%r%=%-14.(%c/%{len(getline('.'))}%)\ %l/%L\ %P

let mapleader=';'
nnoremap <BS> :bprevious<CR>
nnoremap \ :bnext<CR>
nnoremap [\ :tabedit<CR>
nnoremap ]\ :enew<CR>
noremap , ;
noremap ;, ,
for char in [ '<Space>', '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '=', '&' ]
  execute 'xnoremap i'. char. ' :<C-u>normal! T'. char. 'vt'. char. '<CR>'
  execute 'onoremap i'. char. ' :normal vi'. char. '<CR>'
  execute 'xnoremap a'. char. ' :<C-u>normal! T'. char. 'vf'. char. '<CR>'
  execute 'onoremap a'. char. ' :normal va'. char. '<CR>'
endfor
xnoremap il ^og_
onoremap <silent> il :normal vil<CR>
xnoremap al 0o$
onoremap <silent> al :normal val<CR>
noremap <expr> 0 funcs#home()
noremap ^ 0
noremap - $
xnoremap - g_
noremap g- g$
noremap <Home> g^
noremap <End> g$
noremap <Down> gj
noremap <Up> gk
inoremap <Home> <C-o>g^
inoremap <End> <C-o>g$
inoremap <C-_> <C-o>u
nnoremap Q q
xnoremap @q :normal! @q<CR>
xnoremap @@ :normal! @@<CR>
nnoremap _ <C-o>
nnoremap + <C-i>
nnoremap Y y$
xnoremap < <gv
xnoremap > >gv
nnoremap gp `[v`]
nnoremap gx :call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>
xnoremap gx :<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>
nnoremap cr :call funcs#edit_register()<CR>
nnoremap Z[ :1,.- bdelete<CR>
nnoremap Z] :.+,$ bdelete<CR>
nnoremap <C-c> :nohlsearch<CR>:echo<CR>
inoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nnoremap <C-o> :call <SID>EditCallback('lf', 0)<CR>
noremap <leader>p "0p
nnoremap <leader>P :registers<CR>:normal! "p<Left>
xnoremap <leader>P "0P
nnoremap <C-p> :call <SID>EditCallback('rg --files \| fzf --multi', 1)<CR>
nnoremap <leader>fs :vsplit **/*
nnoremap <leader>fb :buffers<CR>:buffer<Space>
nnoremap <leader>fm :call <SID>EditCallback('cat $HOME/.cache/vim/viminfo \| awk ''$1 == ">" {print $2}'' \| sed "s,^~,$HOME," \| xargs ls -1 2>/dev/null \| fzf --multi', 0)<CR>
nnoremap <leader>fM :browse oldfiles<CR>
nnoremap <leader>fg :Grt<CR>:silent grep! "" <bar> redraw! <bar> copen<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
xnoremap <leader>fg :<C-u>Grt<CR>:silent grep! "<C-r>=funcs#get_visual_selection()<CR>" <bar> redraw! <bar> copen<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap <leader>fj :Grt<CR>:silent grep! "\b<C-r><C-w>\b" <bar> redraw! <bar> copen<CR>
xnoremap <leader>fj :<C-u>Grt<CR>:silent grep! "<C-r>=funcs#get_visual_selection()<CR>" <bar> redraw! <bar> copen<CR>
nnoremap <leader>b :Vexplore<CR>
nnoremap <leader>n :let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/='\V'. substitute(escape(@x, '\'), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
xnoremap <leader>s "xy:%s/<C-r>x/<C-r>x/gc<Left><Left><Left>
nnoremap <leader>l :call funcs#print_curr_vars(0, 0)<CR>
xnoremap <leader>l :<C-u>call funcs#print_curr_vars(1, 0)<CR>
nnoremap <leader>L :call funcs#print_curr_vars(0, 1)<CR>
xnoremap <leader>L :<C-u>call funcs#print_curr_vars(1, 1)<CR>
inoremap <leader>w <Esc>:update<CR>
" do not use <leader> for sudo to work
nnoremap ;w :update<CR>
nnoremap <leader>W :wall<CR>
nnoremap ;q :quit<CR>
nnoremap <leader>Q :call funcs#quit(0, 1)<CR>
nnoremap <leader>x :call funcs#quit(1, 0)<CR>
nnoremap <leader>X :call funcs#quit(0, 1)<CR>
nnoremap yoq :call <SID>ToggleQuickfix()<CR>
nnoremap <expr> yol empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'
cnoremap <expr> <Tab> '/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'
cnoremap <expr> <S-Tab> '/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'
cnoremap <expr> <C-@> '/?' =~ getcmdtype() ? '.\{-}' : '<C-@>'
cnoremap <expr> <C-Space> '/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>'
cnoremap <expr> <BS> '/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>'

augroup AutoCommands
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif  " restore last edit position
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd FileType * setlocal formatoptions=jql
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :bdelete<CR>
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>
augroup END
command! -complete=shellcmd -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr('.'). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | execute 'read !'. <q-args> | 1d
command! W write !sudo tee % > /dev/null
command! -nargs=? -bang Ggrep call s:GitGrep(<f-args>)
command! -bar Grt execute 'cd '. fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' '). ';'), ':h'))

let g:netrw_dirhistmax = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_liststyle = 3

function! s:EditCallback(cmd, cd_git_root) abort
  if a:cd_git_root == 1
    let l:git_root = fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' '). ';'), ':h'))
    execute 'cd '. l:git_root
  endif
  let l:tempfile = tempname()
  if a:cmd == 'lf'
    execute 'silent !lf -last-dir-path="$HOME/.cache/lf_dir" -selection-path='. fnameescape(l:tempfile). ' "'. expand('%'). '"'
  else
    execute 'silent !'. a:cmd. ' > '. fnameescape(l:tempfile)
  endif
  try
    if filereadable(l:tempfile)
      for l:filename in readfile(l:tempfile)
        execute 'edit '. (a:cd_git_root == 1 ? l:git_root. '/' : '') . l:filename
      endfor
    endif
    redraw!
  finally
    call delete(l:tempfile)
  endtry
endfunction
function! s:ToggleQuickfix()
  for i in range(1, winnr('$'))
    if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction
function! s:GitGrep(...)
  let l:saved_grepprg = &grepprg
  set grepprg=git\ grep\ --ignore-case\ -n\ $*
  let l:cmd = 'grep!'
  for i in a:000
    let l:cmd = l:cmd . ' ' . i
  endfor
  silent execute l:cmd
  let &grepprg = l:saved_grepprg
  redraw!
  copen
endfun
call fpc#init()
set omnifunc=syntaxcomplete#Complete
set completefunc=funcs#complete_word
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : funcs#simple_complete()
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
inoremap <expr> <Down> pumvisible() ? '<C-n>' : '<C-o>gj'
inoremap <expr> <Up> pumvisible() ? '<C-p>' : '<C-o>gk'

nnoremap yow :setlocal wrap!<CR>
nnoremap yos :setlocal spell!<CR>
nnoremap <expr> yop &paste ? ':setlocal nopaste<CR>' : ':setlocal paste <bar> startinsert<CR>'
nnoremap yon :setlocal number!<CR>
nnoremap yor :setlocal relativenumber!<CR>
nnoremap you :setlocal cursorline!<CR>
nnoremap yoc :setlocal cursorcolumn!<CR>
nnoremap yox :setlocal cursorline! cursorcolumn!<CR>
nnoremap [<Space> mxO<Esc>`x
nnoremap ]<Space> mxo<Esc>`x
nnoremap [p O<C-r>"<Esc>
nnoremap ]p o<C-r>"<Esc>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [<C-q> :cpfile<CR>
nnoremap ]<C-q> :cnfile<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>
nnoremap [<C-l> :lpfile<CR>
nnoremap ]<C-l> :lnfile<CR>

nnoremap <expr> gc plugins#commentary#go()
nnoremap <expr> gcc plugins#commentary#go(). '_'
xnoremap <expr> gc plugins#commentary#go()
onoremap <silent> gc :<C-U>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>
onoremap <silent> aI :<C-u>cal plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
onoremap <silent> iI :<C-u>cal plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> aI :<C-u>cal plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
xnoremap <silent> iI :<C-u>cal plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ai :<C-u>cal plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
onoremap <silent> ii :<C-u>cal plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> ai :<C-u>cal plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
xnoremap <silent> ii :<C-u>cal plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
nnoremap <silent> <expr> <leader>y plugins#oscyank#OSCYankOperator('')
nmap <leader>yy V<leader>y
nmap <leader>Y <leader>y$
xnoremap <silent> <expr> <leader>y plugins#oscyank#OSCYankOperator('')
