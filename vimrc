" if empty(glob('~/.vim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/HEAD/plug.vim
"   let s:init_plug = 1
" endif
" call plug#begin(expand('<sfile>:p:h'). '/plugged')
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" call plug#end()
" if exists('s:init_plug') | PlugInstall | unlet s:init_plug | endif

let &t_ut = ''  " https://github.com/microsoft/terminal/issues/832
let &t_SI .= "\<Esc>[6 q"  " cursor shape
let &t_EI .= "\<Esc>[2 q"
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " https://github.com/vim/vim/issues/3608#issuecomment-438487463
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set t_Co=256
  set termguicolors
endif
silent! syntax enable  " ignore errors when no runtime files
filetype plugin indent on
silent! colorscheme ayu
let g:netrw_dirhistmax = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:markdown_fenced_languages = [ 'javascript', 'js=javascript', 'css', 'html', 'python', 'java', 'c', 'bash=sh' ]
let g:RooterCmd = 'Grt'

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
" ignore errors for sudoedit (vim small)
silent! set foldmethod=indent
silent! set foldlevel=99
set history=1000
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.cache/vim/undo
set viminfo='1000,<50,s10,h,n~/.cache/vim/viminfo
set isfname-==
set path=.,,**5
set wildignore=*/tags,*/\.git/*,*/dist/*,*/build/*,*/node_modules/*,*/venv/*,*/__pycache__/*
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
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m,%f:%l:%m,%f
set cedit=<C-x>
set statusline=%<[%{mode()}](%{fnamemodify(getcwd(),':t')})\ %{expand('%:~:.')}\ %{&paste?'[paste]':''}%{&fileencoding!=''&&&fileencoding!='utf-8'?'[fileencoding\:\ '.&fileencoding.']':''}%{&fileformat!='unix'?'[fileformat\:\ '.&fileformat.']':''}%h%m%r%=%-14.(col\ %c%)%l/%L\ %P

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
xnoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
nnoremap <silent> gw :call plugins#wordmotion#motion(v:count1, 'n', 'w', 0, [])<CR>
xnoremap <silent> gw :<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'w', 0, [])<CR>
onoremap <silent> gw :<C-u>call plugins#wordmotion#motion(v:count1, 'o', 'w', 0, [])<CR>
nnoremap <silent> gb :call plugins#wordmotion#motion(v:count1, 'n', 'b', 0, [])<CR>
xnoremap <silent> gb :<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'b', 0, [])<CR>
onoremap <silent> gb :<C-u>call plugins#wordmotion#motion(v:count1, 'o', 'b', 0, [])<CR>
nnoremap <silent> ge :call plugins#wordmotion#motion(v:count1, 'n', 'e', 0, [])<CR>
xnoremap <silent> ge :<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'e', 0, [])<CR>
onoremap <silent> ge :<C-u>call plugins#wordmotion#motion(v:count1, 'o', 'e', 0, [])<CR>
xnoremap <silent> iu :<C-u>call plugins#wordmotion#object(v:count1, 'x', 1, 0)<CR>
onoremap <silent> iu :<C-u>call plugins#wordmotion#object(v:count1, 'o', 1, 0)<CR>
xnoremap <silent> au :<C-u>call plugins#wordmotion#object(v:count1, 'x', 0, 0)<CR>
onoremap <silent> au :<C-u>call plugins#wordmotion#object(v:count1, 'o', 0, 0)<CR>
xnoremap <silent> v :<C-u>call plugins#expand_region#next('v', '+')<CR>
xnoremap <silent> <BS> :<C-u>call plugins#expand_region#next('v', '-')<CR>
onoremap <silent> ib :<C-u>call plugins#expand_region#any_pair('o', 'i')<CR>
xnoremap <silent> ib :<C-u>call plugins#expand_region#any_pair('v', 'i')<CR>
onoremap <silent> ab :<C-u>call plugins#expand_region#any_pair('o', 'a')<CR>
xnoremap <silent> ab :<C-u>call plugins#expand_region#any_pair('v', 'a')<CR>
nnoremap <silent> f :call plugins#fanfingtastic#next_char(v:count1, '', 'f', 'f')<CR>
xnoremap <silent> f :call plugins#fanfingtastic#visual_next_char(v:count1, '', 'f', 'f')<CR>
onoremap <silent> f :call plugins#fanfingtastic#operator_next_char(v:count1, '', 'f', 'f')<CR>
nnoremap <silent> F :call plugins#fanfingtastic#next_char(v:count1, '', 'F', 'F')<CR>
xnoremap <silent> F :call plugins#fanfingtastic#visual_next_char(v:count1, '', 'F', 'F')<CR>
onoremap <silent> F :call plugins#fanfingtastic#operator_next_char(v:count1, '', 'F', 'F')<CR>
nnoremap <silent> t :call plugins#fanfingtastic#next_char(v:count1, '', 't', 't')<CR>
xnoremap <silent> t :call plugins#fanfingtastic#visual_next_char(v:count1, '', 't', 't')<CR>
onoremap <silent> t :call plugins#fanfingtastic#operator_next_char(v:count1, '', 't', 't')<CR>
nnoremap <silent> T :call plugins#fanfingtastic#next_char(v:count1, '', 'T', 'T')<CR>
xnoremap <silent> T :call plugins#fanfingtastic#visual_next_char(v:count1, '', 'T', 'T')<CR>
onoremap <silent> T :call plugins#fanfingtastic#operator_next_char(v:count1, '', 'T', 'T')<CR>
nnoremap <silent> , :call plugins#fanfingtastic#next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>
xnoremap <silent> , :call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>
onoremap <silent> , :call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>
nnoremap <silent> ;, :call plugins#fanfingtastic#next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>
xnoremap <silent> ;, :call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>
onoremap <silent> ;, :call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>
nnoremap <expr> cx ':set operatorfunc=plugins#exchange#exchange_set<CR>'. (v:count1 == 1 ? '' : v:count1). 'g@'
xnoremap X :<C-u>call plugins#exchange#exchange_set(visualmode(), 1)<CR>
nnoremap <expr> cxx ':set operatorfunc=plugins#exchange#exchange_set<CR>'. (v:count1 == 1 ? '' : v:count1). 'g@_'
nnoremap cxc :call plugins#exchange#exchange_clear()<CR>
nnoremap <BS> :bprevious<CR>
nnoremap \ :bnext<CR>
nnoremap [\ :tab sbuffer<CR>
nnoremap ]\ :enew<CR>
nnoremap [<BS> :new<CR>
nnoremap ]<BS> :vnew<CR>
nnoremap <silent> <C-]> :call funcs#ctags()<CR>
nnoremap <silent> <leader><C-]> :call funcs#ctags_create_and_jump()<CR>
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
nnoremap gf gF
nnoremap gF gf
nnoremap gx :call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>
xnoremap gx :<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>
nnoremap <expr> zn v:count > 0 ? ':set foldlevel='. v:count. '<CR>' : ':%foldclose<CR>'
nnoremap cr :call funcs#edit_register()<CR>
nnoremap Z[ :1,.- bdelete<CR>
nnoremap Z] :.+,$ bdelete<CR>
nmap zh zhz
nmap zl zlz
inoremap jk <Esc>
inoremap kj <Esc>
nnoremap <C-c> <C-c>:nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> redraw!<CR>
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
nnoremap <C-o> :call <SID>EditCallback('lf')<CR>
noremap <leader>p "0p
noremap <leader>P "0P
imap <leader>r <Esc><leader>r
nnoremap <leader>r :execute funcs#get_run_command()<CR>
nnoremap <C-p> :call <SID>EditCallback($FZF_CTRL_T_COMMAND. ' \| FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"')<CR>
xnoremap <C-p> :call <SID>EditCallback($FZF_CTRL_T_COMMAND. ' '. shellescape(funcs#get_visual_selection()). ' \| FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"')<CR>
nmap <leader>fs <C-p>
nnoremap <leader>ff :VFind **<Left>
nnoremap <leader>fb :buffers<CR>:buffer<Space>
nnoremap <leader>fm :call <SID>EditCallback('awk ''$1 == ">" {print $2}'' $HOME/.cache/vim/viminfo \| sed "s,^~/,$HOME/," \| grep -v "/vim/.*/doc/.*.txt\\|.*COMMIT_EDITMSG\\|^'. expand('%:p'). '$" \| while IFS= read -r file; do test -f "$file" && echo "$file"; done \| fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"')<CR>
nnoremap <leader>fM :call <SID>Oldfiles()<CR>
nnoremap <leader>fg :RgRegex<Space>
xnoremap <leader>fg :<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR>
nnoremap <leader>fj :RgRegex \b<C-r>=expand('<cword>')<CR>\b<CR>
xnoremap <leader>fj :<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>
nnoremap <leader>fL :call <SID>EditCallback('FZF_DEFAULT_COMMAND="rg --column --line-number --no-heading --color=always \"\"" fzf --multi --ansi --disabled --bind="change:reload:sleep 0.2; rg --column --line-number --no-heading --color=always {q} \|\| true" --delimiter=: --preview="bat --theme=Dracula --color=always {1} --highlight-line {2}" --preview-window="up,40\%,border-bottom,+{2}+3/3,~3"')<CR>
nnoremap <leader>ft :call <SID>EditCallback('filetypes')<CR>
nnoremap <leader>fy :registers<CR>:normal! "p<Left>
xnoremap <leader>fy :<C-u>registers<CR>:normal! gv"p<Left>
" nnoremap <silent> <leader>b :silent execute 'Lexplore'. (expand('%') != '' ? ' %:h' : '') <bar> if &filetype == 'netrw' <bar> execute 'normal ^'. repeat('-', count(expand('#:~:.'), '/')) <bar> call search(' \zs'. expand('#:t'). '\(\*\\|@\)\?\ze\(\s\\|$\)') <bar> endif<CR>
" 7.4 doesn't have Lexplore and netrw has many issues
nnoremap <silent> <leader>b :let @x = ' \zs'. expand('%:t'). '\(\*\\|@\)\?\ze\(\s\\|$\)' <bar> let @y = len(split(expand('%:~:.'), '/')) - 1 <bar> silent execute (exists(':Lexplore') ? 'L' : 'V'). 'explore'. (expand('%') != '' ? ' %:h' : '') <bar> if &filetype == 'netrw' <bar> execute @y > 0 ? 'normal '. repeat('-', @y) : '' <bar> call search(@x) <bar> execute 'normal! zb' <bar> endif<CR>
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
" map ;q separately from <leader>q to support sudoedit (vim small)
nnoremap ;q :quit<CR>
nnoremap <silent> <leader>q :call funcs#quit(0, 0)<CR>
nnoremap <silent> <leader>Q :call funcs#quit(0, 1)<CR>
nnoremap <silent> <leader>x :call funcs#quit(1, 0)<CR>
nnoremap <silent> <leader>X :call funcs#quit(1, 1)<CR>
nnoremap yoq :call <SID>ToggleQuickfix()<CR>
nnoremap <expr> yol empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'
cnoremap <expr> <Tab> '/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'
cnoremap <expr> <S-Tab> '/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'
cnoremap <expr> <C-@> ':/?' =~ getcmdtype() ? '.\{-}' : '<C-@>'
cnoremap <expr> <C-Space> ':/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>'
cnoremap <expr> <BS> ':/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>'

augroup AutoCommands
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | nnoremap <silent> <buffer> <CR> :nunmap <buffer> <lt>CR><bar>call <SID>Oldfiles()<CR>| endif
  autocmd BufEnter * execute g:RooterCmd
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd FileType * setlocal formatoptions=jql
  autocmd FileType json setlocal formatprg=python\ -m\ json.tool
  autocmd FileType help,man nnoremap <buffer> <nowait> d <C-d>| nnoremap <buffer> u <C-u>
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nmap <buffer> C gn:execute 'cd '. b:netrw_curdir<CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :call funcs#quit_netrw_and_dirs()<CR>| nmap <buffer> <leader>q q| nmap <buffer> a %
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m,%f\|\|%m' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>| nnoremap <buffer> o <CR>:cclose<CR>
augroup END

command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee % > /dev/null
command! TrimTrailingSpaces keeppatterns %s/\s\+$//e | silent! execute 'normal! ``'
command! ShowHighlightGroups echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
command! DiffOrig execute 'diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype='. &filetype. ' | read ++edit # | 0d_ | diffthis'
command! Grt silent execute 'cd '. fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' '). ';'), ':h'))
command! -nargs=* Gdiff execute 'diffthis | vnew | setlocal buftype=nofile bufhidden=wipe filetype='. &filetype. ' | file !git\ show\ <args>:'. expand('%:~:.'). ' | silent read !git show <args>:'. expand('%:~:.') | 0d_ | diffthis
command! -nargs=* Gblame call setbufvar(winbufnr(popup_atcursor(systemlist('cd '. shellescape(fnamemodify(resolve(expand('%:p')), ':h')). ' && git log --no-merges -n 1 -L '. shellescape(line('v'). ','. line('.'). ':'. resolve(expand('%:p')))), { 'padding': [1,1,1,1], 'pos': 'botleft', 'wrap': 0 })), '&filetype', 'git')
command! -complete=command -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr('.'). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | elseif <q-args> != '' | redir @x | <args> | redir END | put x | endif | 1d
command! -complete=file -nargs=+ VFind call s:Grep('glob', <q-args>)
command! -nargs=* VGrep execute 'vimgrep /'. escape(<q-args>, '/'). '/gj **/.* **/*' | if len(getqflist()) > 1 | copen | else | cfirst | endif
command! -nargs=* VGrepNoRegex execute 'vimgrep /'. substitute(escape(<q-args>, '/\.*$^~['), '\n', '\\n', 'g'). '/gj **/.* **/*' | if len(getqflist()) > 1 | copen | else | cfirst | endif
command! -complete=file -nargs=+ Find call s:Grep('find -L . -type f -iname', shellescape(<q-args>))
command! -nargs=+ Grep call s:Grep('grep --ignore-case --line-number -I -R', '-- '. shellescape(<q-args>). ' .')
command! -nargs=+ GrepNoRegex call s:Grep('grep --ignore-case --line-number -I -R --fixed-strings', '-- '. shellescape(<q-args>). ' .')
command! -complete=file -nargs=+ GFind call s:Grep('git ls-files', '-- '. shellescape(<q-args>))
command! -nargs=+ GGrep call s:Grep('git grep -n --ignore-case', '-- '. shellescape(<q-args>))
command! -nargs=+ GGrepNoRegex call s:Grep('git grep -n --ignore-case --fixed-strings', '-- '. shellescape(<q-args>))
command! -nargs=+ Rg call s:Grep('rg --vimgrep', <q-args>)
command! -complete=file -nargs=+ RgFind call s:Grep('rg --vimgrep --files -g', shellescape(<q-args>))
command! -nargs=+ RgRegex call s:Grep('rg --vimgrep', '-- '. shellescape(<q-args>))
command! -nargs=+ RgNoRegex call s:Grep('rg --vimgrep --fixed-strings', '-- '. shellescape(<q-args>))

function! s:Grep(prg, pattern)
  let saved_errorformat = &errorformat
  set errorformat=%f:%l:%c:%m,%f:%l:%m,%f
  if a:prg == 'glob'
    let command = a:pattern[0] == '*' ? '{**/.'. a:pattern. ',**/'. a:pattern. '}' : '**/'. a:pattern
    if a:pattern[0] == '*'  " hidden file needs **/.*pat, {**/.*pat,**/*pat} in `command` is faster but depends on &shell and doesn't work on windows and some bash
      cgetexpr glob('**/.'. a:pattern, 0, 1)
      caddexpr glob('**/'. a:pattern, 0, 1)
    else
      cgetexpr glob(command, 0, 1)
    endif
  else
    let command = a:prg. ' '. a:pattern
    cgetexpr systemlist(command)
  endif
  let &errorformat = saved_errorformat
  let len = len(getqflist())
  silent! call setqflist([], 'a', {'title': '('. len. ') '. command })  " setqflist() does not support 'title' in 7.4
  if len > 1
    copen
  else
    cfirst
  endif
endfunction
function! s:Oldfiles()
  let saved_errorformat = &errorformat
  set errorformat=%f
  if &shell =~ '\(bash\|zsh\)$'
    let MRU = systemlist('awk ''$1 == ">" {print $2}'' $HOME/.cache/vim/viminfo | sed "s,^~/,$HOME/," | grep -v "/vim/.*/doc/.*.txt\|.*COMMIT_EDITMSG\|^'. expand('%:p'). '$" | while IFS= read -r file; do test -f "$file" && echo "$file"; done')
    cgetexpr MRU
  else
    call filter(v:oldfiles, 'filereadable(expand(v:val)) && expand(v:val) !~ "/vim/.*/doc/.*.txt\\|.*COMMIT_EDITMSG\\|^'. expand('%:p'). '$"')
    cgetexpr v:oldfiles
  endif
  let &errorformat = saved_errorformat
  copen
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
function! s:EditCallback(command) abort
  let sink = 'edit '
  let tempfile = tempname()
  if a:command == 'lf'
    execute 'silent !lf -last-dir-path="$HOME/.cache/lf_dir" -selection-path='. fnameescape(tempfile). ' "'. expand('%'). '"'
  elseif a:command == 'filetypes'
    let sink = 'set filetype='
    let $fzftemp = join(sort(map(split(globpath(&rtp, 'syntax/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")')), '\n')
    execute 'silent !echo -e $fzftemp | fzf > '. fnameescape(tempfile)
    let $fzftemp = ''  " cannot unlet environment variables in 7.4
  else
    execute 'silent !'. a:command. ' > '. fnameescape(tempfile)
  endif
  try
    if filereadable(tempfile)
      for line in readfile(tempfile)
        if sink == 'edit ' && line =~ ':\d'
          let args = split(line, ':')
          execute 'edit +'. args[1]. ' '. fnameescape(args[0])
        else
          execute sink. fnameescape(line)
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
nnoremap <expr> yog g:RooterCmd == '' ? ':execute "Grt" <bar> let g:RooterCmd = "Grt" <bar> echo "Git rooter enabled"<CR>' : ':silent execute "cd ". (expand("%") == "" ? $PWD : expand("%:p:h")) <bar> let g:RooterCmd = "" <bar> echo "Git rooter disabled"<CR>'
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
nnoremap Ko K
nnoremap Km K
nnoremap Kd mx:Gdiff<CR><C-w><C-p>`x<C-w><C-p>
nnoremap Kb :Gblame<CR>

" execute "set <M-h>=\<Esc>h"
" execute "set <M-j>=\<Esc>j"
" execute "set <M-k>=\<Esc>k"
" execute "set <M-l>=\<Esc>l"
nnoremap <silent> <C-h> :call plugins#tmux_navigator#navigate('h')<CR>
nnoremap <silent> <C-j> :call plugins#tmux_navigator#navigate('j')<CR>
nnoremap <silent> <C-k> :call plugins#tmux_navigator#navigate('k')<CR>
nnoremap <silent> <C-l> :call plugins#tmux_navigator#navigate('l')<CR>
nnoremap <silent> <M-h> :call plugins#tmux_navigator#resize('h')<CR>
nnoremap <silent> <M-j> :call plugins#tmux_navigator#resize('j')<CR>
nnoremap <silent> <M-k> :call plugins#tmux_navigator#resize('k')<CR>
nnoremap <silent> <M-l> :call plugins#tmux_navigator#resize('l')<CR>
nnoremap <expr> gc plugins#commentary#go()
nnoremap <expr> gcc plugins#commentary#go(). '_'
xnoremap <expr> gc plugins#commentary#go()
onoremap <silent> gc :<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>
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
onoremap <silent> ia :call plugins#angry#list(',', 1, 0, v:count1)<CR>
xnoremap <silent> ia :<C-u>call plugins#angry#list(',', 1, 0, v:count1, visualmode())<CR>
onoremap <silent> aa :call plugins#angry#list(',', 1, 1, v:count1)<CR>
xnoremap <silent> aa :<C-u>call plugins#angry#list(',', 1, 1, v:count1, visualmode())<CR>
if $VIM_SYSTEM_CLIPBOARD != ''
  nnoremap <leader>y "+y
  xnoremap <leader>y "+y
  nnoremap <leader>Y "+y$
else
  call funcs#map_copy_with_osc_yank_script()
endif
if $SSH_CLIENT != ''
  nnoremap gx :call system('y', expand('<cfile>'))<CR>
endif

if has('terminal')
  augroup VimTerminal
    autocmd!
    autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no filetype=terminal | nnoremap <buffer> <nowait> d <C-d>| nnoremap <buffer> u <C-u>
  augroup END
  tnoremap <C-u> <C-\><C-n>
  tnoremap <silent> <C-h> <C-w>:call plugins#tmux_navigator#navigate('h')<CR>
  tnoremap <silent> <C-j> <C-w>:call plugins#tmux_navigator#navigate('j')<CR>
  tnoremap <silent> <C-k> <C-w>:call plugins#tmux_navigator#navigate('k')<CR>
  tnoremap <silent> <C-l> <C-w>:call plugins#tmux_navigator#navigate('l')<CR>
  tnoremap <silent> <M-h> <C-w>:call plugins#tmux_navigator#resize('h')<CR>
  tnoremap <silent> <M-j> <C-w>:call plugins#tmux_navigator#resize('j')<CR>
  tnoremap <silent> <M-k> <C-w>:call plugins#tmux_navigator#resize('k')<CR>
  tnoremap <silent> <M-l> <C-w>:call plugins#tmux_navigator#resize('l')<CR>
  nnoremap <C-b> :execute 'terminal ++close ++rows='. min([15, &lines * 2/5])<CR>
  nnoremap <leader>to :let $VIM_DIR=expand('%:p:h')<CR>:execute 'terminal ++close ++rows='. min([15, &lines * 2/5])<CR>cd $VIM_DIR<CR>
  nnoremap <leader>tO :terminal ++curwin ++noclose<CR>
  nnoremap <leader>th :terminal ++close<CR>
  nnoremap <leader>tv :vertical terminal ++close<CR>
  nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
  call funcs#map_vim_send_terminal()
endif

if exists('g:plugs')
  nnoremap <C-p> :FZF<CR>
  xnoremap <C-p> :<C-u>execute 'FZF --query='. funcs#get_visual_selection()<CR>
else
  let $FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS. ' --layout=default --bind=tab:toggle-out,shift-tab:toggle-in --height=100% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'
endif
