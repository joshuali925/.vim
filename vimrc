" Compatible since CentOS7 vim7.4: docker run -it --rm -e TERM -v $HOME/.vim:/root/.vim --entrypoint /bin/sh thinca/vim:v7.4.629

let g:dot_vim_dir=expand('<sfile>:p:h')

" if empty(glob(g:dot_vim_dir . '/autoload/plug.vim'))
"   silent execute '!curl -fLo ' . g:dot_vim_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/HEAD/plug.vim'
"   let s:init_plug = 1
" endif
" call plug#begin(g:dot_vim_dir . '/plugged')
" Plug 'airblade/vim-gitgutter' | set updatetime=200
" call plug#end()
" if exists('s:init_plug') | PlugInstall | unlet s:init_plug | endif

if has('gui_running')
  set guioptions=Mgt
  set guicursor+=a:blinkon0
  silent! set guifont=Consolas:h12:cANSI
elseif !has('win32') && !has('win32unix')
  let s:use_osc52=1
endif

let &t_ut = ''  " https://github.com/microsoft/terminal/issues/832
let &t_SI .= "\<Esc>[6 q"  " cursor shape
let &t_EI .= "\<Esc>[2 q"
let &t_BE = "\<Esc>[?2004h"  " bracked paste, manually set for vim version < 9
let &t_BD = "\<Esc>[?2004l"
let &t_PS = "\<Esc>[200~"
let &t_PE = "\<Esc>[201~"
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"  " :h tmux-integration, https://github.com/vim/vim/issues/3608#issuecomment-438487463
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
let g:netrw_preview = 1
let g:netrw_alto = 0
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:markdown_fenced_languages = [ 'javascript', 'js=javascript', 'css', 'html', 'python', 'java', 'c', 'bash=sh' ]
let g:RooterCmd = 'Gcd'
let $FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS . ' --layout=default --bind=tab:toggle-out,shift-tab:toggle-in --height=100%'

set backspace=eol,start,indent
set whichwrap=<,>,[,]
if has('mouse')
  set mouse=a
  set ttymouse=sgr
endif
set cursorline
silent! set cursorlineopt=number,screenline
set numberwidth=2
set number
set wrap
set linebreak
set showcmd
set showmatch
set noshowmode
set ruler
set laststatus=2
set wildmenu
set splitright
set splitbelow
silent! set splitkeep=topline
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=-1
set shiftwidth=2
set shiftround
set autoread
set hidden
set complete=.,w,b,u
" do not set noselect or noinsert and silent errors on 'shortmess' for 7.4 compatibility
set completeopt=menuone
silent! set shortmess+=c
set shortmess-=S
set nrformats-=octal
set scrolloff=2
set sidescrolloff=5
set nostartofline
set display=lastline
set virtualedit+=block
set previewheight=7
if has('folding')  " vim small does not have folding
  set foldmethod=expr
  set foldlevel=99
  set foldexpr=max([indent(v:lnum),indent(v:lnum+1)])/&shiftwidth
  let &foldtext='getline(v:foldstart)." ⋯"'
  " invalid argument in windows git-bash
  silent! set fillchars=eob:\ ,fold:\ ,foldopen:,foldsep:\ ,foldclose:
endif
set history=1000
set undofile
let &undodir=g:dot_vim_dir . '/tmp/undo'
let &viminfo="'5000,<50,s10,h,n" . g:dot_vim_dir . '/tmp/viminfo'
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
set cedit=<C-x>
set statusline=%<[%{mode()}](%{fnamemodify(getcwd(),':t')})\ %{expand('%:~:.')}\ %{&paste?'[paste]':''}%{&fileencoding!=''&&&fileencoding!='utf-8'?'[fileencoding\:\ '.&fileencoding.']':''}%{&fileformat!='unix'?'[fileformat\:\ '.&fileformat.']':''}%h%m%r%=%-14.(col\ %c%)%l/%L\ %P
set showtabline=2
set tabline=%!BufferLine()
set list
let &listchars='tab:█ ,nbsp:␣,trail:•'
" leadmultispace is available for >= 8.2.5066
let &listchars='tab:█ ,nbsp:␣,trail:•,leadmultispace:▏' . repeat(' ', &shiftwidth - 1)
silent! set belloff=all

let mapleader=';'
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '=', '&' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vt' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor
xnoremap i<Space> iW
onoremap i<Space> iW
xnoremap a<Space> aW
onoremap a<Space> aW
xnoremap il ^og_
onoremap <silent> il :normal vil<CR>
xnoremap al 0o$
onoremap <silent> al :normal val<CR>
xnoremap ae GoggV
onoremap <silent> ae :normal vae<CR>
xnoremap if v%va)ob
onoremap <silent> if :normal vif<CR>
xnoremap a5 iw%
onoremap <silent> a5 :normal va5<CR>
nnoremap gp `[v`]
onoremap gp :silent normal gp<CR>
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
nnoremap <expr> cx ':set operatorfunc=plugins#exchange#exchange_set<CR>' . (v:count1 == 1 ? '' : v:count1) . 'g@'
xnoremap X :<C-u>call plugins#exchange#exchange_set(visualmode(), 1)<CR>
nnoremap <expr> cxx ':set operatorfunc=plugins#exchange#exchange_set<CR>' . (v:count1 == 1 ? '' : v:count1) . 'g@_'
nnoremap cxc :call plugins#exchange#exchange_clear()<CR>
nnoremap <expr> cr plugins#abolish#coerce('iw')
nnoremap <expr> crr plugins#abolish#coerce('')
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
nnoremap q :call plugins#zeef#buffer({'unlisted': 0})<CR>
nnoremap Q q
xnoremap @q :normal! @q<CR>
xnoremap @@ :normal! @@<CR>
nnoremap c@ :call funcs#edit_register()<CR>
nnoremap _ <C-o>
nnoremap + <C-i>
nnoremap Y y$
nnoremap U :execute 'earlier ' . v:count1 . 'f'<CR>
xnoremap . :normal .<CR>
xnoremap < <gv
xnoremap > >gv
nnoremap gf gF
nnoremap gF gf
xnoremap g/ <Esc>/\%><C-r>=line("'<") - 1<CR>l\%<<C-r>=line("'>") + 1<CR>l
nnoremap gx :call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>
xnoremap gx :<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>
nnoremap <expr> zn v:count > 0 ? ':set foldlevel=' . v:count . '<CR>' : ':%foldclose<CR>'
nnoremap Z[ :1,.- bdelete<CR>
nnoremap Z] :.+,$ bdelete<CR>
nnoremap ZX :%bdelete <bar> edit #<CR>
nmap zh zhz
nmap zl zlz
inoremap jk <Esc>
nnoremap <C-c> <C-c>:nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> redraw!<CR>
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-w><BS> :-tabmove<CR><C-w>
nmap <C-w>\ :+tabmove<CR><C-w>
nnoremap <C-o> :call <SID>EditCallback('file_manager')<CR>
noremap <leader>p "0p
noremap <leader>P "0P
" use ; to avoid typing delay if leader changed to ' '
imap ;r <Esc><leader>r
nnoremap <leader>r :execute funcs#get_run_command()<CR>
nnoremap <C-p> :call plugins#zeef#files()<CR>
xnoremap <C-p> :call plugins#zeef#files(funcs#get_visual_selection())<CR>
nnoremap <leader>fd :call <SID>EditCallback($FZF_CTRL_T_COMMAND . ' \| FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"')<CR>
xnoremap <leader>fd :call <SID>EditCallback($FZF_CTRL_T_COMMAND . ' ' . shellescape(funcs#get_visual_selection()) . ' \| FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat -plain --color=always {}"')<CR>
nnoremap <leader>ff :VFind **<Left>
nnoremap <leader>fb :buffers<CR>:buffer<Space>
nnoremap <leader>fm :call plugins#zeef#oldfiles(0)<CR>
nnoremap <Tab> :call plugins#zeef#oldfiles(1)<CR>
nnoremap <leader>fM :call <SID>EditCallback('awk ''$1 == ">" {print $2}'' ' . g:dot_vim_dir . '/tmp/viminfo \| sed "s,^~/,$HOME/," \| grep -v "/vim/.*/doc/.*.txt\\|.*COMMIT_EDITMSG\\|^' . expand('%:p') . '$" \| while IFS= read -r file; do test -f "$file" && echo "$file"; done \| fzf --multi --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}"')<CR>
nnoremap <leader>fg :RgRegex<Space>
xnoremap <leader>fg :<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR>
nnoremap <leader>fj :RgRegex \b<C-r>=expand('<cword>')<CR>\b<CR>
xnoremap <leader>fj :<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>
nnoremap <leader>fu :call plugins#zeef#buffer_tags()<CR>
nnoremap <leader>fL :call plugins#zeef#buffer_lines()<CR>
nnoremap <leader>f/ :call <SID>EditCallback('FZF_DEFAULT_COMMAND="rg --column --line-number --no-heading --color=always \"\"" fzf --multi --ansi --disabled --bind="change:reload:sleep 0.2; rg --column --line-number --no-heading --color=always {q} \|\| true" --delimiter=: --preview="bat --color=always --highlight-line {2} -- {1}" --preview-window="up,+{2}+3/3,~3"')<CR>
nnoremap <leader>ft :call plugins#zeef#filetype()<CR>
nnoremap <leader>fT :call <SID>EditCallback('filetypes')<CR>
nnoremap <leader>fy :registers<CR>:normal! "p<Left>
xnoremap <leader>fy :<C-u>registers<CR>:normal! gv"p<Left>
" nnoremap <silent> <leader>b :silent execute 'Lexplore' . (expand('%') != '' ? ' %:h' : '') <bar> if &filetype == 'netrw' <bar> execute 'normal ^' . repeat('-', count(expand('#:~:.'), '/')) <bar> call search(' \zs' . expand('#:t') . '\(\*\\|@\)\?\ze\(\s\\|$\)') <bar> endif<CR>
" 7.4 doesn't have Lexplore and netrw has many issues
nnoremap <silent> <leader>b :let @x = ' \zs' . expand('%:t') . '\(\*\\|@\)\?\ze\(\s\\|$\)' <bar> let @y = len(split(expand('%:~:.'), '/')) - 1 <bar> silent execute (exists(':Lexplore') ? 'L' : 'V') . 'explore' . (expand('%') != '' ? ' %:h' : '') <bar> if &filetype == 'netrw' <bar> execute @y > 0 ? 'normal ' . repeat('-', @y) : '' <bar> call search(@x) <bar> execute 'normal! zb' <bar> endif<CR>
nnoremap <leader>n :let @/ = '\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/ = substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
xnoremap <leader>s "xy:%s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\n', 'g')<CR>/gc<Left><Left><Left>
xnoremap <leader>S :s/\%V//g<Left><Left><Left>
nmap cn <leader>ncgn
xmap C <leader>ncgn
nmap <C-n> <leader>ncgn
xmap <C-n> <leader>ncgn
nnoremap <leader>tu <C-^>
nnoremap <leader>l :call funcs#print_variable(0, 0)<CR>
xnoremap <leader>l :<C-u>call funcs#print_variable(1, 0)<CR>
nnoremap <leader>L :call funcs#print_variable(0, 1)<CR>
xnoremap <leader>L :<C-u>call funcs#print_variable(1, 1)<CR>
" map ;w and ;q separately to support sudoedit (vim small)
nnoremap ;w :update<CR>
nnoremap ;q :quit<CR>
inoremap ;w <Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :wall<CR>
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
  autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | if &filetype == 'netrw' | let g:should_quit_netrw = 1 | else | nnoremap <silent> <buffer> <CR> :nunmap <buffer> <lt>CR><bar>call <SID>Oldfiles()<CR>| endif | endif
  autocmd BufEnter * ++nested execute g:RooterCmd
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd FileType * setlocal formatoptions=rjql
  autocmd FileType json setlocal formatprg=python\ -m\ json.tool
  autocmd FileType help,man nnoremap <buffer> <nowait> d <C-d>| nnoremap <buffer> u <C-u>
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nmap <buffer> C gn:execute 'cd ' . b:netrw_curdir<CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :call funcs#quit_netrw_and_dirs()<CR>| nmap <buffer> <leader>q q| nmap <buffer> a %
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable foldmethod=expr foldexpr=matchstr(getline(v:lnum),'^[^\|]\\+')==#matchstr(getline(v:lnum+1),'^[^\|]\\+')?1:'<1' | let &foldtext='matchstr(getline(v:foldstart),"^[^|]\\+")."| ⋯"' | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m,%f\|\|%m,%f' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>| nnoremap <buffer> o <CR>:cclose<CR>| nnoremap <buffer> <leader>s :cdo s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>| xnoremap <buffer> <leader>s "xy:cdo s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\n', 'g')<CR>/g<Left><Left>| nnoremap <buffer> < :colder<CR>| nnoremap <buffer> > :cnewer<CR>
  silent! autocmd OptionSet shiftwidth let &listchars='tab:█ ,nbsp:␣,trail:•,leadmultispace:▏' . repeat(' ', &shiftwidth - 1)
augroup END

command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee % > /dev/null
command! CountSearch %s///gn
command! TrimTrailingSpaces keeppatterns %s/\s\+$//e | silent! execute 'normal! ``'
command! ShowHighlightGroups echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
command! DiffOrig execute 'diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype=' . &filetype . ' | read ++edit # | 0d_ | diffthis'
command! Gcd silent execute 'cd ' . fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' ') . ';'), ':h'))
command! -nargs=* Gdiff execute 'diffthis | vnew | setlocal buftype=nofile bufhidden=wipe filetype=' . &filetype . ' | file !git\ show\ <args>:' . expand('%:~:.') . ' | silent read !git show <args>:' . expand('%:~:.') | 0d_ | diffthis
command! -nargs=* Gblame call setbufvar(winbufnr(popup_atcursor(systemlist('cd ' . shellescape(fnamemodify(resolve(expand('%:p')), ':h')) . ' && git log --no-merges -n 1 -L ' . shellescape(line('v') . ',' . line('.') . ':' . resolve(expand('%:p')))), { 'padding': [1,1,1,1], 'pos': 'botleft', 'wrap': 0 })), '&filetype', 'git')
command! -complete=command -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | if <line1> < <line2> | setlocal filetype=' . &filetype . ' | put =getbufline(' . bufnr('%') . ', <line1>, <line2>) | resize ' . min([<line2>-<line1>+2, &lines * 2/5]) . '| else | resize ' . min([15, &lines * 2/5]) . '| endif' | if '<bang>' != '' | execute 'read !' . <q-args> | elseif <q-args> != '' | redir @x | <args> | redir END | put x | endif | 1d
command! -nargs=+ Fd call funcs#grep('fd', <q-args>)
command! -complete=file -nargs=+ VFind call funcs#grep('glob', <q-args>)
command! -nargs=* VGrep execute 'vimgrep /' . escape(<q-args>, '/') . '/gj **/.* **/*' | if len(getqflist()) > 1 | copen | else | cfirst | endif
command! -nargs=* VGrepNoRegex execute 'vimgrep /' . substitute(escape(<q-args>, '/\.*$^~['), '\n', '\\n', 'g') . '/gj **/.* **/*' | if len(getqflist()) > 1 | copen | else | cfirst | endif
command! -complete=file -nargs=+ Find call funcs#grep('find -L . -type f -not -path "*/.git/*" -iname', shellescape(<q-args>))
" busybox grep does not recognize long option names
command! -nargs=+ Grep call funcs#grep('grep -i -n -I -r', '-- ' . shellescape(<q-args>) . ' .')
command! -nargs=+ GrepNoRegex call funcs#grep('grep -i -n -I -r --fixed-strings', '-- ' . shellescape(<q-args>) . ' .')
command! -complete=file -nargs=+ GFind call funcs#grep('git ls-files', '-- ' . shellescape(<q-args>))
command! -nargs=+ GGrep call funcs#grep('git grep -n -i', '-- ' . shellescape(<q-args>))
command! -nargs=+ GGrepNoRegex call funcs#grep('git grep -n -i --fixed-strings', '-- ' . shellescape(<q-args>))
let s:rg_cmd = 'RIPGREP_CONFIG_PATH="' . g:dot_vim_dir . '/config/.ripgreprc" rg --vimgrep'
command! -nargs=+ Rg call funcs#grep(s:rg_cmd, <q-args>)
command! -complete=file -nargs=+ RgFind call funcs#grep(s:rg_cmd . ' --files -g', shellescape(<q-args>))
command! -nargs=+ RgRegex call s:rg_or_grep('', '-- ' . shellescape(<q-args>))
command! -nargs=+ RgNoRegex call s:rg_or_grep(' --fixed-strings', '-- ' . shellescape(<q-args>))

function! s:rg_or_grep(arg, pattern)
  if executable('rg') == 1
    call funcs#grep(s:rg_cmd . a:arg, a:pattern)
  else
    echomsg 'Warning: rg not available, using grep'
    call funcs#grep('grep -i -n -I -r' . a:arg, a:pattern . ' .')
  endif
endfunction

function! s:Oldfiles()
  let saved_errorformat = &errorformat
  set errorformat=%f
  cgetexpr plugins#zeef#filter_oldfiles(0)
  let &errorformat = saved_errorformat
  let bufnr = bufnr('%')
  copen
  execute 'nnoremap <buffer> <CR> <CR>:bwipeout ' . bufnr . '<bar>cclose<CR>'
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
  echo 'checktime loop ' . (s:tail_on ? 'on' : 'off')
endfunction
function! s:EditCallback(command) abort
  let sink = 'edit '
  let tempfile = tempname()
  if a:command == 'file_manager'
    let curr_file = expand('%')
    if curr_file == ''
      let curr_file = '.'
    endif
    execute 'silent !yazi --cwd-file="$HOME/.vim/tmp/last_result" --chooser-file="' . fnameescape(tempfile) . '" "' . curr_file . '"'
  elseif a:command == 'filetypes'
    let sink = 'set filetype='
    let $fzftemp = join(sort(map(globpath(&rtp, 'syntax/*.vim', 0, 1), 'fnamemodify(v:val, ":t:r")')), '\n')
    execute 'silent !echo -e $fzftemp | fzf > ' . fnameescape(tempfile)
    let $fzftemp = ''  " cannot unlet environment variables in 7.4
  else
    execute 'silent !' . a:command . ' > ' . fnameescape(tempfile)
  endif
  try
    if filereadable(tempfile)
      for line in readfile(tempfile)
        if sink == 'edit ' && line =~ ':\d'
          let args = split(line, ':')
          execute 'edit +' . args[1] . ' ' . fnameescape(args[0])
        else
          execute sink . fnameescape(line)
        endif
      endfor
    endif
    redraw!
  finally
    call delete(tempfile)
  endtry
endfunction
function! BufferLine()  " https://www.reddit.com/r/vim/comments/11tdlx0/comment/jcii423
  let s = ''
  let bufnr = bufnr('%')
  for i in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let s .= i == bufnr ? '%#TabLineSel#' : '%#TabLine#'
    if bufname(i) == ''
      let s .= ' * '
    else
      let s .= ' ' . fnamemodify(bufname(i), ':t') . (getbufvar(i, "&modified") ? ' + ' : ' ')
    endif
  endfor
  let s .= '%#TabLineFill#%T%='
  let tabs = tabpagenr('$')
  if tabs > 1
    let tabpagenr = tabpagenr()
    for i in range(1, tabs)
      let s .= (i == tabpagenr ? '%#TabLineSel#' : '%#TabLine#') . '%' . i . 'T ' . i . ' '
    endfor
    let s .= '%999X X'
  endif
  let s .= '%#TabLineFill#%T'
  return s
endfunction

call fpc#init()
set omnifunc=syntaxcomplete#Complete
set completefunc=funcs#complete_word
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : funcs#simple_complete()
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
inoremap <expr> <Down> pumvisible() ? '<C-n>' : '<C-o>gj'
inoremap <expr> <Up> pumvisible() ? '<C-p>' : '<C-o>gk'

nnoremap <leader>ac :edit $MYVIMRC<CR>
nnoremap <expr> yow ':setlocal ' . (&wrap ? 'no' : '') . 'wrap<CR>'
nnoremap <expr> yos ':setlocal ' . (&spell ? 'no' : '') . 'spell<CR>'
nnoremap <expr> yon ':setlocal ' . (&number ? 'no' : '') . 'number<CR>'
nnoremap <expr> yor ':setlocal ' . (&relativenumber ? 'no' : '') . 'relativenumber<CR>'
nnoremap <expr> you ':setlocal ' . (&cursorline ? 'no' : '') . 'cursorline<CR>'
nnoremap <expr> yoc ':setlocal ' . (&cursorcolumn ? 'no' : '') . 'cursorcolumn<CR>'
nnoremap yox :setlocal cursorline! cursorcolumn!<CR>
nnoremap <expr> yov ':setlocal virtualedit=' . (&virtualedit == 'block' ? 'all' : 'block') . '<CR>'
nnoremap <expr> yod &diff ? ':diffoff<CR>' : ':diffthis<CR>'
nnoremap <expr> yop &paste ? ':setlocal nopaste<CR>' : ':setlocal paste<CR>o'
nnoremap yoF :call <SID>ToggleTail()<CR>
nnoremap <expr> yog g:RooterCmd == '' ? ':execute "Gcd" <bar> let g:RooterCmd = "Gcd" <bar> echo "Git rooter enabled"<CR>' : ':silent execute "cd " . (expand("%") == "" ? $PWD : expand("%:p:h")) <bar> let g:RooterCmd = "" <bar> echo "Git rooter disabled"<CR>'
nnoremap <expr> [<Space> 'mx' . v:count1 . 'O<Esc>`x'
nnoremap <expr> ]<Space> 'mx' . v:count1 . 'o<Esc>`x'
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
nnoremap <expr> gcc plugins#commentary#go() . '_'
xnoremap <expr> gc plugins#commentary#go()
onoremap <silent> gc :<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>
nnoremap <silent> ds :<C-u>call plugins#surround#dosurround(plugins#surround#inputtarget())<CR>
nnoremap <silent> cs :<C-u>call plugins#surround#changesurround()<CR>
nnoremap <silent> cS :<C-u>call plugins#surround#changesurround(1)<CR>
nmap yss ysiw
nnoremap <expr> ySs plugins#surround#opfunc2('setup') . '_'
nnoremap <expr> ySS plugins#surround#opfunc2('setup') . '_'
nnoremap <expr> ys plugins#surround#opfunc('setup')
nmap yS ysg_
xnoremap <silent> s :<C-u>call plugins#surround#opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
xnoremap <silent> gS :<C-u>call plugins#surround#opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)<CR>
onoremap <silent> ia :call plugins#angry#list(',', 1, 0, v:count1)<CR>
xnoremap <silent> ia :<C-u>call plugins#angry#list(',', 1, 0, v:count1, visualmode())<CR>
onoremap <silent> aa :call plugins#angry#list(',', 1, 1, v:count1)<CR>
xnoremap <silent> aa :<C-u>call plugins#angry#list(',', 1, 1, v:count1, visualmode())<CR>
if !exists('s:use_osc52')
  nnoremap <leader>y "+y
  xnoremap <leader>y "+y
  nnoremap <leader>Y "+y$
else
  nnoremap <expr> <leader>y plugins#oscyank#OSCYankOperator()
  nmap <leader>yy <leader>y_
  nmap <leader>Y <leader>y$
  xnoremap <leader>y :call plugins#oscyank#OSCYankVisual()<CR>
endif
nmap yc "xyygcc"xp
if $SSH_CLIENT != ''
  nnoremap gx :call system('y', expand('<cfile>'))<CR>
endif

if has('terminal')
  augroup VimTerminal
    autocmd!
    silent! autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no | nnoremap <buffer> <nowait> d <C-d>| nnoremap <buffer> u <C-u>| nnoremap <buffer> gf :argadd <C-r><C-p><CR>| xnoremap <buffer> gf :<C-u>execute "'<,'>normal! :argadd \<lt>C-r>\<lt>C-p>\<lt>CR>"<CR>
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
  nnoremap <C-b> :execute 'terminal ++close ++rows=' . min([15, &lines * 2/5])<CR>
  nnoremap <leader>to :let $VIM_DIR=expand('%:p:h')<CR>:execute 'terminal ++close ++rows=' . min([15, &lines * 2/5])<CR>cd $VIM_DIR<CR>
  nnoremap <leader>tO :terminal ++curwin ++noclose<CR>
  nnoremap <leader>th :terminal ++close<CR>
  nnoremap <leader>tv :vertical terminal ++close<CR>
  nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
  command! Glow terminal ++curwin glow %
  call funcs#map_vim_send_terminal()
endif
