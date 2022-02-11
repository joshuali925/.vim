" call plug#begin(expand('<sfile>:p:h'). '/plugged')
" Plug ''
" call plug#end()

let &t_ut = ''  " https://github.com/microsoft/terminal/issues/832
let &t_SI .= "\<Esc>[6 q"  " cursor shape
let &t_EI .= "\<Esc>[2 q"
set background=dark
syntax enable
filetype plugin indent on
colorscheme gruvbox_material
let $FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS. ' --layout=default --height=100% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

set backspace=eol,start,indent
set whichwrap=<,>,[,]
if has('mouse')
  set mouse=a
  set ttymouse=sgr
endif
set cursorline
set numberwidth=2
set number
set wrap
set linebreak
set showcmd
set showmatch
set noshowmode
set ruler
set showtabline=2
set laststatus=2
set wildmenu
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
set foldmethod=indent
set foldlevelstart=99
set history=1000
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.cache/vim/undo
set viminfo='1000,<50,s10,h,n~/.cache/vim/viminfo
set isfname-==
set path=.,,**5
set wildignore+=*/tmp/*,*/\.git/*,*/node_modules/*,*/venv/*,*/\.env/*
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
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --auto-hybrid-regex
set grepformat=%f:%l:%c:%m,%f:%l:%m
set statusline=%<[%{mode()}](%{fnamemodify(getcwd(),':t')})\ %{expand('%:~:.')}\ %{&paste?'[paste]':''}%h%m%r%=%-14.(%c/%{len(getline('.'))}%)\ %l/%L\ %P

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
  execute 'xnoremap a'. char. ' :<C-u>normal! F'. char. 'vt'. char. '<CR>'
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
nnoremap U :execute 'earlier '. v:count1. 'f'<CR>
xnoremap < <gv
xnoremap > >gv
nnoremap gp `[v`]
nnoremap gx :call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>
xnoremap gx :<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>
nnoremap zm :%foldclose<CR>
nnoremap cr :call funcs#edit_register()<CR>
nnoremap Z[ :1,.- bdelete<CR>
nnoremap Z] :.+,$ bdelete<CR>
nnoremap <C-c> :nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> redraw!<CR>
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
nmap <C-w><BS> :-tabmove<CR><C-w>
nmap <C-w>\ :+tabmove<CR><C-w>
nmap <C-n> <leader>ncgn
xmap <C-n> <leader>ncgn
nnoremap <C-o> :call <SID>EditCallback('lf', 0)<CR>
noremap <leader>p "0p
nnoremap <leader>P :registers<CR>:normal! "p<Left>
xnoremap <leader>P "0P
nnoremap <C-p> :call <SID>EditCallback('rg --files \| fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"', 1)<CR>
nmap <leader>fs <C-p>
nnoremap <leader>ff :vsplit **/*
nnoremap <leader>fb :buffers<CR>:buffer<Space>
nnoremap <leader>fm :call <SID>EditCallback('awk ''$1 == ">" {print $2}'' $HOME/.cache/vim/viminfo \| sed "s,^~/,$HOME/," \| grep -v "/vim/.*/doc/.*.txt\\|.*COMMIT_EDITMSG" \| perl -ne ''chomp(); if (-e $_) {print "$_\n"}'' \| fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"', 0)<CR>
nnoremap <leader>fM :browse oldfiles<CR>
nnoremap <leader>fg :GrepRegex<Space>
xnoremap <leader>fg :<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR>
nnoremap <leader>fj :GrepRegex \b<C-r><C-w>\b<CR>
xnoremap <leader>fj :<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>
nnoremap <leader>fL :call <SID>EditCallback('FZF_DEFAULT_COMMAND="rg --column --line-number --no-heading --color=always \"\"" fzf --multi --ansi --disabled --bind="change:reload:sleep 0.2; rg --column --line-number --no-heading --color=always {q} \|\| true" --delimiter=: --preview="bat --theme=Dracula --color=always {1} --highlight-line {2}" --preview-window="up,40\%,border-bottom,+{2}+3/3,~3"', 1)<CR>
nnoremap <leader>ft :call <SID>EditCallback('filetypes', 0)<CR>
nnoremap <leader>b :Vexplore<CR>
nnoremap <leader>n :let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
xnoremap <leader>s "xy:%s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\n', 'g')<CR>/gc<Left><Left><Left>
nnoremap <leader>l :call funcs#print_variable(0, 0)<CR>
xnoremap <leader>l :<C-u>call funcs#print_variable(1, 0)<CR>
nnoremap <leader>L :call funcs#print_variable(0, 1)<CR>
xnoremap <leader>L :<C-u>call funcs#print_variable(1, 1)<CR>
inoremap <leader>w <Esc>:update<CR>
nnoremap ;w :update<CR>
nnoremap <leader>W :wall<CR>
" map ;q separately from <leader>q for sudoedit to work
nnoremap ;q :quit<CR>
nnoremap <leader>q :call funcs#quit(0, 0)<CR>
nnoremap <leader>Q :call funcs#quit(0, 1)<CR>
nnoremap <leader>x :call funcs#quit(1, 0)<CR>
nnoremap <leader>X :call funcs#quit(1, 1)<CR>
nnoremap yoq :call <SID>ToggleQuickfix()<CR>
nnoremap <expr> yol empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'
cnoremap <expr> <Tab> '/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'
cnoremap <expr> <S-Tab> '/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'
cnoremap <expr> <C-@> '/?' =~ getcmdtype() ? '.\{-}' : '<C-@>'
cnoremap <expr> <C-Space> '/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>'
cnoremap <expr> <BS> '/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>'

augroup AutoCommands
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd FileType * setlocal formatoptions=jql
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :call funcs#quit_netrw_and_dirs()<CR>| nmap <buffer> <leader>q q
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>
augroup END
command! -complete=command -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr('.'). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | elseif <q-args> != '' | redir @x | <args> | redir END | put x | endif | 1d
command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee % > /dev/null
command! -nargs=+ GrepRegex call s:Grep(0, 1, <q-args>)
command! -nargs=+ GrepNoRegex call s:Grep(0, 0, <q-args>)
command! -nargs=+ Ggrep call s:Grep(1, 1, <q-args>)
command! -nargs=+ GgrepNoRegex call s:Grep(1, 0, <q-args>)
command! Grt execute 'cd '. fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' '). ';'), ':h'))
command! DiffOrig execute 'diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype='. &filetype. ' | read ++edit # | 0d_ | diffthis'

let g:netrw_dirhistmax = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_liststyle = 3

function! s:ToggleQuickfix()
  for i in range(1, winnr('$'))
    if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction
function! s:Grep(git_grep, use_regex, pattern)
  " use execute so sudoedit will not complain
  execute 'Grt'
  let saved_grepprg = &grepprg
  let &grepprg = (a:git_grep ? 'git grep -n --ignore-case' : saved_grepprg). (a:use_regex ? '' : ' --fixed-strings')
  silent execute 'grep! -- "'. escape(a:pattern, '\#%$|"'). '"'
  let &grepprg = saved_grepprg
  redraw!
  copen
endfunction
let s:tail_on = 0
function! s:ToggleTail()
  if s:tail_on
    let &updatetime = s:updatetime_bak
    augroup TailAutoCommand
      autocmd!
    augroup END
  else
    let s:updatetime_bak = &updatetime
    set updatetime=1000
    augroup TailAutoCommand
      autocmd!
      autocmd CursorHold * checktime | call feedkeys('lh', 'n')
    augroup END
  endif
  let s:tail_on = !s:tail_on
  echo 'checktime loop '. (s:tail_on ? 'on' : 'off')
endfunction
function! s:EditCallback(cmd, cd_git_root) abort
  if a:cd_git_root == 1
    execute 'Grt'
  endif
  let sink = 'edit '
  let tempfile = tempname()
  if a:cmd == 'lf'
    execute 'silent !lf -last-dir-path="$HOME/.cache/lf_dir" -selection-path='. fnameescape(tempfile). ' "'. expand('%'). '"'
  elseif a:cmd == 'filetypes'
    let sink = 'set filetype='
    let $FZFTEMP = join(sort(map(split(globpath(&rtp, 'syntax/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')), '\n')
    execute 'silent !echo -e $FZFTEMP | fzf > '. fnameescape(tempfile)
    let $FZFTEMP = ''  " cannot unlet environment variables in 7.4
  else
    execute 'silent !'. a:cmd. ' > '. fnameescape(tempfile)
  endif
  try
    if filereadable(tempfile)
      for line in readfile(tempfile)
        if sink == 'edit ' && line =~ ':\d'
          let args = split(line, ':')
          execute 'edit +'. args[1]. ' '. args[0]
        else
          execute sink. line
        endif
      endfor
    endif
    redraw!
  finally
    call delete(tempfile)
  endtry
endfunction
call fpc#init()
set omnifunc=syntaxcomplete#Complete
set completefunc=funcs#complete_word
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : funcs#simple_complete()
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
inoremap <expr> <Down> pumvisible() ? '<C-n>' : '<C-o>gj'
inoremap <expr> <Up> pumvisible() ? '<C-p>' : '<C-o>gk'

nnoremap <leader>ac :edit $MYVIMRC<CR>
nnoremap <expr> yow ':setlocal '. (&wrap ? 'no' : ''). 'wrap<CR>'
nnoremap <expr> yos ':setlocal '. (&spell ? 'no' : ''). 'spell<CR>'
nnoremap <expr> yon ':setlocal '. (&number ? 'no' : ''). 'number<CR>'
nnoremap <expr> yor ':setlocal '. (&relativenumber ? 'no' : ''). 'relativenumber<CR>'
nnoremap <expr> you ':setlocal '. (&cursorline ? 'no' : ''). 'cursorline<CR>'
nnoremap <expr> yoc ':setlocal '. (&cursorcolumn ? 'no' : ''). 'cursorcolumn<CR>'
nnoremap yox :setlocal cursorline! cursorcolumn!<CR>
nnoremap <expr> yov ':setlocal virtualedit='. (&virtualedit == 'block' ? 'all' : 'block'). '<CR>'
nnoremap <expr> yod &diff ? ':diffoff<CR>' : ':diffthis<CR>'
nnoremap <expr> yop &paste ? ':setlocal nopaste<CR>' : ':setlocal paste<CR>o'
nnoremap yoF :call <SID>ToggleTail()<CR>
nnoremap <expr> [<Space> 'mx'. v:count1. 'O<Esc>`x'
nnoremap <expr> ]<Space> 'mx'. v:count1. 'o<Esc>`x'
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
onoremap <silent> gc :<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>
xnoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> v :<C-u>call plugins#expand_region#next('v', '+')<CR>
xnoremap <silent> <BS> :<C-u>call plugins#expand_region#next('v', '-')<CR>
call funcs#map_copy_with_osc_yank_script()

if has('terminal')
  augroup VimTerminal
    autocmd!
    autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no
  augroup END
  tnoremap <C-u> <C-\><C-n>
  tnoremap <C-h> <C-w>h
  tnoremap <C-j> <C-w>j
  tnoremap <C-k> <C-w>k
  tnoremap <C-l> <C-w>l
  nnoremap <leader>to :execute 'terminal ++close ++rows='. min([15, &lines * 2/5])<CR>
  nmap <C-b> <leader>to
  nnoremap <leader>tO :terminal ++curwin ++noclose<CR>
  nnoremap <leader>th :terminal ++close<CR>
  nnoremap <leader>tv :vertical terminal ++close<CR>
  nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
  call funcs#map_vim_send_terminal()
endif
