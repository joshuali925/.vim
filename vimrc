" if empty(glob('~/.vim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/HEAD/plug.vim
" endif
" call plug#begin(expand('<sfile>:p:h'). '/plugged')
" Plug ''
" call plug#end()

let &t_ut = ''  " https://github.com/microsoft/terminal/issues/832
let &t_SI .= "\<Esc>[6 q"  " cursor shape
let &t_EI .= "\<Esc>[2 q"
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " https://github.com/vim/vim/issues/3608#issuecomment-438487463
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set t_Co=256
  set termguicolors
endif
syntax enable
filetype plugin indent on
colorscheme ayu
let g:netrw_dirhistmax = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:markdown_fenced_languages = [ 'javascript', 'js=javascript', 'css', 'html', 'python', 'java', 'c', 'bash=sh' ]
let $FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS. ' --layout=default --bind=tab:toggle-out,shift-tab:toggle-in --height=100% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

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
set autoread
set hidden
set complete=.,w,b,u
" do not set noselect or noinsert for 7.4 compatibility
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
" ignore errors for sudoedit
silent! set foldmethod=indent
silent! set foldlevelstart=99
set history=1000
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.cache/vim/undo
set viminfo='1000,<50,s10,h,n~/.cache/vim/viminfo
set isfname-==
set path=.,,**5
set wildignore+=*/tmp/*,*/\.git/*,*/node_modules/*,*/venv/*
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
set statusline=%<[%{mode()}](%{fnamemodify(getcwd(),':t')})\ %{expand('%:~:.')}\ %{&paste?'[paste]':''}%h%m%r%=%-14.(col\ %c%)%l/%L\ %P

let mapleader=';'
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
xnoremap ae GoggV
onoremap <silent> ae :normal vae<CR>
xnoremap af iw%
onoremap <silent> af :normal vaf<CR>
nnoremap <BS> :bprevious<CR>
nnoremap \ :bnext<CR>
nnoremap [\ :tab sbuffer<CR>
nnoremap ]\ :enew<CR>
nnoremap [<BS> :new<CR>
nnoremap ]<BS> :vnew<CR>
nnoremap <silent> <C-]> :call funcs#ctags()<CR>
noremap , ;
noremap ;, ,
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
nmap zh zhz
nmap zl zlz
nnoremap <C-c> :nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> redraw!<CR>
inoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
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
imap <leader>r <Esc><leader>r
nnoremap <leader>r :execute funcs#get_run_command()<CR>
nnoremap <C-p> :call <SID>EditCallback($FZF_CTRL_T_COMMAND. ' \| FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"', 1)<CR>
nmap <leader>fs <C-p>
nnoremap <leader>ff :vsplit **/*
nnoremap <leader>fb :buffers<CR>:buffer<Space>
nnoremap <leader>fm :call <SID>EditCallback('awk ''$1 == ">" {print $2}'' $HOME/.cache/vim/viminfo \| sed "s,^~/,$HOME/," \| grep -v "/vim/.*/doc/.*.txt\\|.*COMMIT_EDITMSG\\|^'. expand('%:p'). '$" \| while IFS= read -r file; do test -f "$file" && echo "$file"; done \| fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"', 0)<CR>
nnoremap <leader>fM :browse oldfiles<CR>
nnoremap <leader>fg :GrepRegex<Space>
xnoremap <leader>fg :<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR>
nnoremap <leader>fj :GrepRegex \b<C-r><C-w>\b<CR>
xnoremap <leader>fj :<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>
nnoremap <leader>fL :call <SID>EditCallback('FZF_DEFAULT_COMMAND="rg --column --line-number --no-heading --color=always \"\"" fzf --multi --ansi --disabled --bind="change:reload:sleep 0.2; rg --column --line-number --no-heading --color=always {q} \|\| true" --delimiter=: --preview="bat --theme=Dracula --color=always {1} --highlight-line {2}" --preview-window="up,40\%,border-bottom,+{2}+3/3,~3"', 1)<CR>
nnoremap <leader>ft :call <SID>EditCallback('filetypes', 0)<CR>
" Vexplore for 7.4 compatibility
nnoremap <expr> <leader>b exists(':Lexplore') ? ':Lexplore<CR>' : ':Vexplore<CR>'
nnoremap <leader>n :let @/ = '\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/ = substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
xnoremap <leader>s "xy:%s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\n', 'g')<CR>/gc<Left><Left><Left>
nmap <leader>c <leader>ncgn
xmap <leader>c <leader>ncgn
nnoremap <leader>l :call funcs#print_variable(0, 0)<CR>
xnoremap <leader>l :<C-u>call funcs#print_variable(1, 0)<CR>
nnoremap <leader>L :call funcs#print_variable(0, 1)<CR>
xnoremap <leader>L :<C-u>call funcs#print_variable(1, 1)<CR>
inoremap <leader>w <Esc>:update<CR>
nnoremap ;w :update<CR>
nnoremap <leader>W :wall<CR>
" map ;q separately from <leader>q for sudoedit to work
nnoremap ;q :quit<CR>
nnoremap <silent> <leader>q :call funcs#quit(0, 0)<CR>
nnoremap <silent> <leader>Q :call funcs#quit(0, 1)<CR>
nnoremap <silent> <leader>x :call funcs#quit(1, 0)<CR>
nnoremap <silent> <leader>X :call funcs#quit(1, 1)<CR>
nnoremap yoq :call <SID>ToggleQuickfix()<CR>
nnoremap <expr> yol empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'
cnoremap <expr> <Tab> '/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'
cnoremap <expr> <S-Tab> '/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'
cnoremap <expr> <C-@> '/?' =~ getcmdtype() ? '.\{-}' : '<C-@>'
cnoremap <expr> <C-Space> '/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>'
cnoremap <expr> <BS> '/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>'

augroup AutoCommands
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd FileType * setlocal formatoptions=jql
  " cd in netrw to change working directory
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nmap <buffer> C gn| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :call funcs#quit_netrw_and_dirs()<CR>| nmap <buffer> <leader>q q
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>
augroup END
command! -complete=command -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr('.'). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | elseif <q-args> != '' | redir @x | <args> | redir END | put x | endif | 1d
command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee % > /dev/null
command! -nargs=+ GrepRegex call s:Grep(0, 1, <q-args>)
command! -nargs=+ GrepNoRegex call s:Grep(0, 0, <q-args>)
command! -nargs=+ Ggrep call s:Grep(1, 1, <q-args>)
command! -nargs=+ GgrepNoRegex call s:Grep(1, 0, <q-args>)
command! Grt execute 'cd '. fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' '). ';'), ':h'))
command! -nargs=* Gdiff execute 'Grt' | execute 'diffthis | vnew | setlocal buftype=nofile bufhidden=wipe filetype='. &filetype. ' | file !git\ show\ <args>:'. expand('%:~:.'). ' | silent read !git show <args>:'. expand('%:~:.') | 0d_ | diffthis
command! -nargs=* Gblame call setbufvar(winbufnr(popup_atcursor(systemlist('cd '. shellescape(fnamemodify(resolve(expand('%:p')), ':h')). ' && git log --no-merges -n 1 -L '. shellescape(line('v'). ','. line('.'). ':'. resolve(expand('%:p')))), { 'padding': [1,1,1,1], 'pos': 'botleft', 'wrap': 0 })), '&filetype', 'git')
command! DiffOrig execute 'diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype='. &filetype. ' | read ++edit # | 0d_ | diffthis'
command! TrimTrailingSpaces keeppatterns %s/\s\+$//e | silent! execute 'normal! ``'

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
    let $fzftemp = join(sort(map(split(globpath(&rtp, 'syntax/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')), '\n')
    execute 'silent !echo -e $fzftemp | fzf > '. fnameescape(tempfile)
    let $fzftemp = ''  " cannot unlet environment variables in 7.4
  else
    execute 'silent !'. a:cmd. ' > '. fnameescape(tempfile)
  endif
  try
    if filereadable(tempfile)
      for line in readfile(tempfile)
        if sink == 'edit ' && line =~ ':\d'
          let args = split(line, ':')
          execute 'edit +'. args[1]. ' '. escape(args[0], '%#')
        else
          execute sink. escape(line, '%#')
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
nnoremap [t :tprevious<CR>
nnoremap ]t :tnext<CR>
nnoremap [T :tfirst<CR>
nnoremap ]T :tlast<CR>
nnoremap [<C-t> :ptprevious<CR>
nnoremap ]<C-t> :ptnext<CR>

nnoremap <silent> <C-h> :call plugins#tmux_navigator#navigate('h')<CR>
nnoremap <silent> <C-j> :call plugins#tmux_navigator#navigate('j')<CR>
nnoremap <silent> <C-k> :call plugins#tmux_navigator#navigate('k')<CR>
nnoremap <silent> <C-l> :call plugins#tmux_navigator#navigate('l')<CR>
nnoremap <expr> gc plugins#commentary#go()
nnoremap <expr> gcc plugins#commentary#go(). '_'
xnoremap <expr> gc plugins#commentary#go()
onoremap <silent> gc :<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>
xnoremap <silent> v :<C-u>call plugins#expand_region#next('v', '+')<CR>
xnoremap <silent> <BS> :<C-u>call plugins#expand_region#next('v', '-')<CR>
nnoremap <silent> ds :<C-u>call plugins#surround#dosurround(plugins#surround#inputtarget())<CR>
nnoremap <silent> cs :<C-u>call plugins#surround#changesurround()<CR>
nnoremap <silent> cS :<C-u>call plugins#surround#changesurround(1)<CR>
nmap yss ysiw
nnoremap <expr> ySs plugins#surround#opfunc2('setup'). '_'
nnoremap <expr> ySS plugins#surround#opfunc2('setup'). '_'
nnoremap <expr> ys plugins#surround#opfunc('setup')
nmap yS ysg_
xnoremap <silent> s :<C-u>call plugins#surround#opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
xnoremap <silent> gS :<C-u>call plugins#surround#opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)<CR>
xnoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
call funcs#map_copy_with_osc_yank_script()
if $SSH_CLIENT != ''
  nnoremap gx :call system('y', expand('<cfile>'))<CR>
endif

if has('terminal')
  augroup VimTerminal
    autocmd!
    autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no
  augroup END
  tnoremap <C-u> <C-\><C-n>
  tnoremap <silent> <C-h> <C-w>:call plugins#tmux_navigator#navigate('h')<CR>
  tnoremap <silent> <C-j> <C-w>:call plugins#tmux_navigator#navigate('j')<CR>
  tnoremap <silent> <C-k> <C-w>:call plugins#tmux_navigator#navigate('k')<CR>
  tnoremap <silent> <C-l> <C-w>:call plugins#tmux_navigator#navigate('l')<CR>
  nnoremap <leader>to :execute 'terminal ++close ++rows='. min([15, &lines * 2/5])<CR>
  nmap <C-b> <leader>to
  nnoremap <leader>tO :terminal ++curwin ++noclose<CR>
  nnoremap <leader>th :terminal ++close<CR>
  nnoremap <leader>tv :vertical terminal ++close<CR>
  nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
  call funcs#map_vim_send_terminal()
endif
