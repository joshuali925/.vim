" (debian 13) vim 9.1.1230+: docker run -it --rm -e TERM -v $HOME/.vim:/root/.vim --entrypoint /bin/sh thinca/vim:v9.1.1230
set encoding=utf-8
set backspace=eol,start,indent
set whichwrap=<,>,[,]
set mouse=a
set ttymouse=sgr
set cursorline
set cursorlineopt=number,screenline
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
set splitkeep=topline
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
set shortmess+=c
set shortmess-=S
set nrformats-=octal
set scrolloff=2
set sidescrolloff=5
set signcolumn=yes
set nostartofline
set display=lastline
set virtualedit+=block
set previewheight=7
set foldmethod=expr
set foldlevel=99
set fillchars=eob:\ ,diff:╱,fold:\ ,foldopen:,foldsep:\ ,foldclose:
set history=1000
set undofile
set isfname-==
set path=.,,**5
set wildignore=*/tags,*/\.git/*,*/dist/*,*/build/*,*/node_modules/*,*/.venv/*,*/__pycache__/*
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
set showtabline=2
set list
set belloff=all

xnoremap i<Space> iW
onoremap i<Space> iW
xnoremap a<Space> aW
onoremap a<Space> aW
xnoremap il ^og_
onoremap il <Cmd>normal vil<CR>
xnoremap al 0o$
onoremap al <Cmd>normal val<CR>
xnoremap ae GoggV
onoremap ae <Cmd>normal vae<CR>
xnoremap if v%va)ob
onoremap if <Cmd>normal vif<CR>
xnoremap a5 iw%
onoremap a5 <Cmd>normal va5<CR>
nnoremap gp `[v`]
onoremap gp <Cmd>silent normal gp<CR>
nnoremap <BS> <Cmd>bprevious<CR>
nnoremap \ <Cmd>bnext<CR>
nnoremap [\ <Cmd>tab sbuffer<CR>
nnoremap ]\ <Cmd>enew<CR>
nnoremap [<BS> <Cmd>new<CR>
nnoremap ]<BS> <Cmd>vnew<CR>
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
nnoremap ( <C-o>
nnoremap ) <C-i>
nnoremap Y y$
xnoremap . :normal .<CR>
xnoremap < <gv
xnoremap > >gv
nnoremap gf gF
nnoremap gF gf
nnoremap ZH <Cmd>1,.- bdelete<CR>
nnoremap ZL <Cmd>.+,$ bdelete<CR>
nnoremap ZX <Cmd>%bdelete <bar> edit #<CR>
nmap zh zhz
nmap zl zlz
inoremap jk <Esc>
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-w><BS> <Cmd>-tabmove<CR><C-w>
nmap <C-w>\ <Cmd>+tabmove<CR><C-w>
" ;w and ;q also work when mapleader is unset or changed
nnoremap ;w <Cmd>update<CR>
nnoremap ;q <Cmd>quit<CR>
inoremap ;w <Esc><Cmd>update<CR>
nnoremap yox <Cmd>setlocal cursorline! cursorcolumn!<CR>
nnoremap [p O<C-r>"<Esc>
nnoremap ]p o<C-r>"<Esc>
nnoremap [t <Cmd>tprevious<CR>
nnoremap ]t <Cmd>tnext<CR>
nnoremap [T <Cmd>tfirst<CR>
nnoremap ]T <Cmd>tlast<CR>

" vim.tiny skips all below
if 1

if has('gui_running')
  set guioptions=Mgt
  set guicursor+=a:blinkon0
  silent! set guifont=Consolas:h12:cANSI
endif
let &t_SI .= "\<Esc>[6 q"  " cursor shape
let &t_EI .= "\<Esc>[2 q"
set termguicolors
set t_RB=  " avoid flicker from terminal bg color detection
filetype plugin indent on
syntax enable
packadd! hlyank
packadd! comment
colorscheme ayu
let g:loaded_getscriptPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_logiPat = 1
let g:netrw_dirhistmax = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_preview = 1
let g:netrw_alto = 0
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:osc52_force_avail = 1
let g:osc52_disable_paste = 1
let g:markdown_fenced_languages = [ 'javascript', 'js=javascript', 'ts=typescript', 'tsx=typescriptreact', 'json=jsonc', 'html', 'python', 'bash=sh' ]
let g:terminal_ansi_colors = ['#1d202f', '#f7768e', '#9ece6a', '#e0af68', '#7aa2f7', '#bb9af7', '#7dcfff', '#a9b1d6', '#717993', '#f7768e', '#9ece6a', '#e0af68', '#7aa2f7', '#bb9af7', '#7dcfff', '#c0caf5']  " override ansi colors for terminal
let s:clip = '<Cmd>if ($SSH_CLIENT != "" <bar><bar> v:clipmethod ==# "none") && &clipmethod !~ "osc52" <bar> packadd osc52 <bar> set clipmethod^=osc52 <bar> endif<CR>'
let g:dot_vim_dir=expand('<sfile>:p:h')
let g:RooterCmd = 'Gcd'

let &foldtext='getline(v:foldstart)." ⋯"'
let &undodir=g:dot_vim_dir . '/tmp/undo'
let &viminfo="'5000,<50,s10,h,n" . g:dot_vim_dir . '/tmp/viminfo'
let &findfunc = expand('<SID>') . 'Find'
let &foldexpr = expand('<SID>') . 'FoldLevel()'
let &statusline = '%<%{' . expand('<SID>') . "Status()}%h%m%r%=%-14.(col %c%)%l/%L %P"

set listchars=tab:█\ ,nbsp:␣,leadmultispace:▏\ ,trail:•
set tabline=%!BufferLine()
set complete=.,w,b,u
if exists('+autocomplete')  " 'complete' F{func} needs 9.1.1409, 'autocomplete' needs 9.1.1590
  let &complete .= ',F' . expand('<SID>') . 'Complete'
  set autocomplete
  set autocompletedelay=150
else
  let [s:complete_timer, s:complete_context] = [-1, []]
  augroup AutoComplete
    autocmd!
    autocmd TextChangedI * call s:ScheduleAutoComplete()
    autocmd InsertLeave * call timer_stop(s:complete_timer) | let s:complete_context = []
  augroup END
endif
set completeopt=menuone,fuzzy,popup
set omnifunc=syntaxcomplete#Complete
set completefunc=funcs#complete_word
set wildoptions=pum,fuzzy
set wildmode=noselect:lastused,full
set diffopt=filler,closeoff,vertical,linematch:40
if has('patch-9.1.1243')
  set diffopt+=inline:char
endif

let mapleader=';'
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '=', '&' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' <Cmd>normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vt' . char . '<CR>'
  execute 'onoremap a' . char . ' <Cmd>normal va' . char . '<CR>'
endfor
xnoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap ii <Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap ai <Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap iI <Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap aI <Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
nnoremap gw <Cmd>call plugins#wordmotion#motion(v:count1, 'n', 'w', 0, [])<CR>
xnoremap <silent> gw :<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'w', 0, [])<CR>
onoremap gw <Cmd>call plugins#wordmotion#motion(v:count1, 'o', 'w', 0, [])<CR>
nnoremap gb <Cmd>call plugins#wordmotion#motion(v:count1, 'n', 'b', 0, [])<CR>
xnoremap <silent> gb :<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'b', 0, [])<CR>
onoremap gb <Cmd>call plugins#wordmotion#motion(v:count1, 'o', 'b', 0, [])<CR>
nnoremap ge <Cmd>call plugins#wordmotion#motion(v:count1, 'n', 'e', 0, [])<CR>
xnoremap <silent> ge :<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'e', 0, [])<CR>
onoremap ge <Cmd>call plugins#wordmotion#motion(v:count1, 'o', 'e', 0, [])<CR>
xnoremap <silent> iu :<C-u>call plugins#wordmotion#object(v:count1, 'x', 1, 0)<CR>
onoremap iu <Cmd>call plugins#wordmotion#object(v:count1, 'o', 1, 0)<CR>
xnoremap <silent> au :<C-u>call plugins#wordmotion#object(v:count1, 'x', 0, 0)<CR>
onoremap au <Cmd>call plugins#wordmotion#object(v:count1, 'o', 0, 0)<CR>
xnoremap <silent> v :<C-u>call plugins#expand_region#next('v', '+')<CR>
xnoremap <silent> <BS> :<C-u>call plugins#expand_region#next('v', '-')<CR>
onoremap ib <Cmd>call plugins#expand_region#any_pair('o', 'i')<CR>
xnoremap <silent> ib :<C-u>call plugins#expand_region#any_pair('v', 'i')<CR>
onoremap ab <Cmd>call plugins#expand_region#any_pair('o', 'a')<CR>
xnoremap <silent> ab :<C-u>call plugins#expand_region#any_pair('v', 'a')<CR>
nnoremap f <Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 'f', 'f')<CR>
xnoremap <silent> f :call plugins#fanfingtastic#visual_next_char(v:count1, '', 'f', 'f')<CR>
onoremap f <Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 'f', 'f')<CR>
nnoremap F <Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 'F', 'F')<CR>
xnoremap <silent> F :call plugins#fanfingtastic#visual_next_char(v:count1, '', 'F', 'F')<CR>
onoremap F <Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 'F', 'F')<CR>
nnoremap t <Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 't', 't')<CR>
xnoremap <silent> t :call plugins#fanfingtastic#visual_next_char(v:count1, '', 't', 't')<CR>
onoremap t <Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 't', 't')<CR>
nnoremap T <Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 'T', 'T')<CR>
xnoremap <silent> T :call plugins#fanfingtastic#visual_next_char(v:count1, '', 'T', 'T')<CR>
onoremap T <Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 'T', 'T')<CR>
nnoremap , <Cmd>call plugins#fanfingtastic#next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>
xnoremap <silent> , :call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>
onoremap , <Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>
nnoremap ;, <Cmd>call plugins#fanfingtastic#next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>
xnoremap <silent> ;, :call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>
onoremap ;, <Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>
nnoremap <expr> cx '<Cmd>set operatorfunc=plugins#exchange#exchange_set<CR>' . (v:count1 == 1 ? '' : v:count1) . 'g@'
xnoremap X :<C-u>call plugins#exchange#exchange_set(visualmode(), 1)<CR>
nnoremap <expr> cxx '<Cmd>set operatorfunc=plugins#exchange#exchange_set<CR>' . (v:count1 == 1 ? '' : v:count1) . 'g@_'
nnoremap cxc <Cmd>call plugins#exchange#exchange_clear()<CR>
nnoremap <expr> cr plugins#abolish#coerce('iw')
nnoremap <expr> crr plugins#abolish#coerce('')
nnoremap mf <Cmd>call plugins#gitdiff#Goto(0)<CR>
nnoremap mg <Cmd>call plugins#gitdiff#Goto(1)<CR>
onoremap ig <Cmd>call plugins#gitdiff#Select()<CR>
xnoremap ig <Cmd>call plugins#gitdiff#Select()<CR>
nnoremap <C-]> <Cmd>call funcs#ctags()<CR>
nnoremap <leader><C-]> <Cmd>call funcs#ctags_create_and_jump()<CR>
noremap <expr> 0 funcs#home()
nnoremap q <Cmd>call plugins#picker#Buffers()<CR>
nnoremap c@ <Cmd>call funcs#edit_register()<CR>
nnoremap U <Cmd>execute 'earlier ' . v:count1 . 'f'<CR>
xnoremap g/ <Esc>/\%><C-r>=line("'<") - 1<CR>l\%<<C-r>=line("'>") + 1<CR>l
nnoremap gx <Cmd>call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>
xnoremap gx :<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>
nnoremap <expr> zn v:count > 0 ? '<Cmd>set foldlevel=' . v:count . '<CR>' : '<Cmd>%foldclose<CR>'
nnoremap <C-c> <C-c><Cmd>nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> redraw!<CR>
nnoremap <C-o> <Cmd>call <SID>FileManager()<CR>
noremap <leader>p "0p
noremap <leader>P "0P
" use ; to avoid typing delay if leader changed to ' '
imap ;r <Esc><leader>r
nnoremap <leader>r <Cmd>execute funcs#get_run_command()<CR>
nnoremap <C-p> <Cmd>call plugins#picker#Files()<CR>
xnoremap <C-p> :<C-u>call plugins#picker#Files(funcs#get_visual_selection())<CR>
nnoremap <leader>ff :find<Space>
nnoremap <leader>fb :buffers<CR>:buffer<Space>
nnoremap <leader>fm <Cmd>call plugins#picker#Oldfiles(0)<CR>
nnoremap <leader>fs <Cmd>call plugins#picker#GitStatus()<CR>
nnoremap <Tab> <Cmd>call plugins#picker#Oldfiles(1)<CR>
nnoremap <leader>fg :RgRegex<Space>
xnoremap <leader>fg :<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR>
nnoremap <leader>fj <Cmd>execute "RgRegex \\b" . expand("<cword>") . "\\b"<CR>
xnoremap <leader>fj :<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>
nnoremap <leader>fu <Cmd>call plugins#picker#BufferTags()<CR>
nnoremap <leader>fL <Cmd>call plugins#picker#Lines()<CR>
nnoremap <leader>f/ <Cmd>call plugins#picker#Grep()<CR>
nnoremap <leader>ft <Cmd>call plugins#picker#Filetypes()<CR>
nnoremap <leader>fy :registers<CR>:normal! "p<Left>
xnoremap <leader>fy :<C-u>registers<CR>:normal! gv"p<Left>
nnoremap <leader>b <Cmd>let @x = ' \zs' . expand('%:t') . '\(\*\\|@\)\?\ze\(\s\\|$\)' <bar> let @y = len(split(expand('%:~:.'), '/')) - 1 <bar> silent execute 'Lexplore' . (expand('%') != '' ? ' %:h' : '') <bar> if &filetype == 'netrw' <bar> execute @y > 0 ? 'normal ' . repeat('-', @y) : '' <bar> call search(@x) <bar> execute 'normal! zb' <bar> endif<CR>
nnoremap <leader>n <Cmd>let @/ = "\\<" . expand("<cword>") . "\\>" <bar> set hlsearch<CR>
xnoremap <leader>n :<C-u>let @/ = substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
xnoremap <leader>s :<C-u>%s/<C-r>=substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(funcs#get_visual_selection(), '/\.*$^~[&'), '\n', '\\r', 'g')<CR>/gc<Left><Left><Left>]
xnoremap <leader>S :s/\%V//g<Left><Left><Left>
nnoremap m<C-c> <Cmd>call funcs#highlight_clear()<CR>
nnoremap m<leader>n <Cmd>call funcs#highlight("\\<" . expand("<cword>") . "\\>")<CR>
xnoremap m<leader>n :<C-u>call funcs#highlight(substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g'))<CR>]
nnoremap c. /\V\C<C-r>=escape(@", '/')<CR><CR>cgn<C-a><Esc>
nmap cn <leader>ncgn
xmap C <leader>ncgn
nmap <C-n> <leader>ncgn
xmap <C-n> <leader>ncgn
nnoremap <leader>tu <C-^>
nnoremap <leader>l <Cmd>call funcs#print_variable(0, 0)<CR>
xnoremap <leader>l :<C-u>call funcs#print_variable(1, 0)<CR>
nnoremap <leader>L <Cmd>call funcs#print_variable(0, 1)<CR>
xnoremap <leader>L :<C-u>call funcs#print_variable(1, 1)<CR>
nnoremap <leader>w <Cmd>update<CR>
nnoremap <leader>W <Cmd>wall<CR>
nnoremap <leader>q <Cmd>call funcs#quit(0, 0)<CR>
nnoremap <leader>Q <Cmd>call funcs#quit(0, 1)<CR>
nnoremap <leader>x <Cmd>call funcs#quit(1, 0)<CR>
nnoremap <leader>X <Cmd>call funcs#quit(1, 1)<CR>
nnoremap <expr> yoq empty(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) ? '<Cmd>copen<CR>' : '<Cmd>cclose<CR>'
nnoremap <expr> yol empty(filter(getwininfo(), 'v:val.loclist')) ? '<Cmd>lopen<CR>' : '<Cmd>lclose<CR>'
cnoremap <expr> <Tab> '/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'
cnoremap <expr> <S-Tab> '/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'
cnoremap <expr> <C-@> ':/?' =~ getcmdtype() ? '.\{-}' : '<C-@>'
cnoremap <expr> <C-Space> ':/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>'
cnoremap <expr> <Up> wildmenumode() ? '<C-e><Up>' : '<Up>'
cnoremap <expr> <Down> wildmenumode() ? '<C-e><Down>' : '<Down>'
cnoremap <expr> <BS> ':/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>'
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : funcs#simple_complete()
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
inoremap <expr> <Down> pumvisible() ? '<C-n>' : '<C-o>gj'
inoremap <expr> <Up> pumvisible() ? '<C-p>' : '<C-o>gk'
inoremap <expr> <CR> pumvisible() ? complete_info(['selected']).selected < 0 ? '<C-n><C-y>' : '<C-y>' : '<CR>'
inoremap <C-@> <C-n>
inoremap <C-Space> <C-n>
nnoremap <leader>ac <Cmd>edit $MYVIMRC<CR>
nnoremap <expr> yow '<Cmd>setlocal ' . (&wrap ? 'no' : '') . 'wrap<CR>'
nnoremap <expr> yos '<Cmd>setlocal ' . (&spell ? 'no' : '') . 'spell<CR>'
nnoremap <expr> yon '<Cmd>setlocal ' . (&number ? 'no' : '') . 'number<CR>'
nnoremap <expr> yor '<Cmd>setlocal ' . (&relativenumber ? 'no' : '') . 'relativenumber<CR>'
nnoremap <expr> you '<Cmd>setlocal ' . (&cursorline ? 'no' : '') . 'cursorline<CR>'
nnoremap <expr> yoc '<Cmd>setlocal ' . (&cursorcolumn ? 'no' : '') . 'cursorcolumn<CR>'
nnoremap <expr> yov '<Cmd>setlocal virtualedit=' . (&virtualedit == 'block' ? 'all' : 'block') . '<CR>'
nnoremap <expr> yod &diff ? '<Cmd>diffoff<CR>' : '<Cmd>diffthis<CR>'
nnoremap <expr> yop &paste ? '<Cmd>setlocal nopaste<CR>' : '<Cmd>setlocal paste<CR>o'
nnoremap <expr> yog g:RooterCmd == '' ? '<Cmd>execute "Gcd" <bar> let g:RooterCmd = "Gcd" <bar> echo "Git rooter enabled"<CR>' : '<Cmd>silent execute "cd " . (expand("%") == "" ? $PWD : expand("%:p:h")) <bar> let g:RooterCmd = "" <bar> echo "Git rooter disabled"<CR>'
nnoremap <expr> m<Space> 'mx' . v:count1 . 'O<Esc>`x'
nnoremap <expr> m<CR> 'mx' . v:count1 . 'o<Esc>`x'
nnoremap mq <Cmd>cprevious<CR>
nnoremap mw <Cmd>cnext<CR>
nnoremap mQ <Cmd>cfirst<CR>
nnoremap mW <Cmd>clast<CR>
nnoremap [<C-q> <Cmd>cpfile<CR>
nnoremap ]<C-q> <Cmd>cnfile<CR>
nnoremap [l <Cmd>lprevious<CR>
nnoremap ]l <Cmd>lnext<CR>
nnoremap [L <Cmd>lfirst<CR>
nnoremap ]L <Cmd>llast<CR>
nnoremap [<C-l> <Cmd>lpfile<CR>
nnoremap ]<C-l> <Cmd>lnfile<CR>
nnoremap [<C-t> <Cmd>ptprevious<CR>
nnoremap ]<C-t> <Cmd>ptnext<CR>
nnoremap <leader>gD mx<Cmd>Gdiff<CR><C-w><C-p>`x<C-w><C-p>
nnoremap <leader>gd <Cmd>call plugins#gitdiff#Do('preview', 0)<CR>
xnoremap <leader>gd <Cmd>call plugins#gitdiff#Do('preview', 1)<CR>
nnoremap <leader>ga <Cmd>call plugins#gitdiff#Do('stage', 0)<CR>
xnoremap <leader>ga <Cmd>call plugins#gitdiff#Do('stage', 1)<CR>
nnoremap <leader>gu <Cmd>call plugins#gitdiff#Do('reset', 0)<CR>
xnoremap <leader>gu <Cmd>call plugins#gitdiff#Do('reset', 1)<CR>
nnoremap <leader>gb <Cmd>call plugins#gitdiff#Blame()<CR>
nnoremap <C-h> <Cmd>call plugins#tmux_navigator#navigate('h')<CR>
nnoremap <C-j> <Cmd>call plugins#tmux_navigator#navigate('j')<CR>
nnoremap <C-k> <Cmd>call plugins#tmux_navigator#navigate('k')<CR>
nnoremap <C-l> <Cmd>call plugins#tmux_navigator#navigate('l')<CR>
nnoremap <M-h> <Cmd>call plugins#tmux_navigator#resize('h')<CR>
nnoremap <M-j> <Cmd>call plugins#tmux_navigator#resize('j')<CR>
nnoremap <M-k> <Cmd>call plugins#tmux_navigator#resize('k')<CR>
nnoremap <M-l> <Cmd>call plugins#tmux_navigator#resize('l')<CR>
omap gc <Plug>(comment-text-object-outer)
nnoremap ds <Cmd>call plugins#surround#dosurround(plugins#surround#inputtarget())<CR>
nnoremap cs <Cmd>call plugins#surround#changesurround()<CR>
nnoremap cS <Cmd>call plugins#surround#changesurround(1)<CR>
nmap yss ysiw
nnoremap <expr> ySs plugins#surround#opfunc2('setup') . '_'
nnoremap <expr> ySS plugins#surround#opfunc2('setup') . '_'
nnoremap <expr> ys plugins#surround#opfunc('setup')
nmap yS ysg_
xnoremap <silent> s :<C-u>call plugins#surround#opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
xnoremap <silent> gS :<C-u>call plugins#surround#opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)<CR>
onoremap ia <Cmd>call plugins#angry#list(',', 1, 0, v:count1)<CR>
xnoremap <silent> ia :<C-u>call plugins#angry#list(',', 1, 0, v:count1, visualmode())<CR>
onoremap aa <Cmd>call plugins#angry#list(',', 1, 1, v:count1)<CR>
xnoremap <silent> aa :<C-u>call plugins#angry#list(',', 1, 1, v:count1, visualmode())<CR>
execute 'nnoremap <leader>y ' . s:clip . '"+y'
execute 'xnoremap <leader>y ' . s:clip . '"+y'
execute 'nnoremap <leader>Y ' . s:clip . '"+y$'
nmap yc "xyygcc"xp
if $SSH_CLIENT != ''
  execute 'nnoremap gx ' . s:clip . '<Cmd>call setreg("+", expand("<cfile>"))<CR>'
endif
tnoremap <C-u> <C-\><C-n>
tnoremap <C-h> <Cmd>call plugins#tmux_navigator#navigate('h')<CR>
tnoremap <C-j> <Cmd>call plugins#tmux_navigator#navigate('j')<CR>
tnoremap <C-k> <Cmd>call plugins#tmux_navigator#navigate('k')<CR>
tnoremap <C-l> <Cmd>call plugins#tmux_navigator#navigate('l')<CR>
tnoremap <M-h> <Cmd>call plugins#tmux_navigator#resize('h')<CR>
tnoremap <M-j> <Cmd>call plugins#tmux_navigator#resize('j')<CR>
tnoremap <M-k> <Cmd>call plugins#tmux_navigator#resize('k')<CR>
tnoremap <M-l> <Cmd>call plugins#tmux_navigator#resize('l')<CR>
nnoremap <C-b> <Cmd>call <SID>ToggleTerminal()<CR>
tnoremap <C-b> <Cmd>call <SID>ToggleTerminal()<CR>
nnoremap gO <Cmd>HelpToc<CR>
nnoremap <leader>to <Cmd>let $VIM_DIR=expand('%:p:h')<CR><Cmd>execute 'terminal ++close ++rows=' . min([15, &lines * 2/5])<CR>cd $VIM_DIR<CR>
nnoremap <leader>tO <Cmd>terminal ++curwin ++noclose<CR>
nnoremap <leader>th <Cmd>terminal ++close<CR>
nnoremap <leader>tv <Cmd>vertical terminal ++close<CR>
nnoremap <leader>tt <Cmd>tabedit <bar> terminal ++curwin ++close<CR>
nnoremap <leader>te <Cmd>set operatorfunc=funcs#send_to_terminal<CR>g@
xnoremap <silent> <leader>te :<C-u>call funcs#send_to_terminal(visualmode())<CR>
nnoremap <leader>tee <Cmd>call funcs#send_to_terminal(v:count1)<CR>

augroup AutoCommands
  autocmd!
  autocmd CmdUndefined HelpToc ++once packadd helptoc
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | if &filetype == 'netrw' | let g:should_quit_netrw = 1 | else | nnoremap <buffer> <CR> <Cmd>nunmap <buffer> <lt>CR><bar>call <SID>Oldfiles()<CR>| endif | endif
  autocmd BufEnter * ++nested execute g:RooterCmd
  autocmd BufReadPost,BufNewFile,BufFilePost * call plugins#gitdiff#Attach(str2nr(expand('<abuf>')))
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd FileType * setlocal formatoptions=rjql
  autocmd FileType json setlocal formatprg=python\ -m\ json.tool\ --indent\ 2
  autocmd FileType python,javascript let b:omni = 1
  autocmd FileType help,man nnoremap <buffer> <nowait> d <C-d>| nnoremap <buffer> u <C-u>
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nmap <buffer> C gn<Cmd>execute 'cd ' . b:netrw_curdir<CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q <Cmd>call funcs#quit_netrw_and_dirs()<CR>| nmap <buffer> <leader>q q| nmap <buffer> a %
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable foldmethod=expr foldexpr=matchstr(getline(v:lnum),'^[^\|]\\+')==#matchstr(getline(v:lnum+1),'^[^\|]\\+')?1:'<1' | let &foldtext='matchstr(getline(v:foldstart),"^[^|]\\+")."| ⋯"' | nnoremap <buffer> <leader>w <Cmd>let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m,%f\|\|%m,%f' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>| nnoremap <buffer> o <CR><Cmd>cclose<CR>| nnoremap <buffer> <leader>s :cdo s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>| xnoremap <buffer> <leader>s "xy:cdo s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\n', 'g')<CR>/g<Left><Left>| nnoremap <buffer> < <Cmd>colder<CR>| nnoremap <buffer> > <Cmd>cnewer<CR>
  autocmd OptionSet shiftwidth let &listchars='tab:█ ,nbsp:␣,trail:•,leadmultispace:▏' . repeat(' ', &shiftwidth - 1)
  autocmd CmdlineEnter : let s:files_cache = []
  autocmd DirChanged * let s:cwd = getcwd(-1)
  if exists('*wildtrigger')  " wildtrigger() needs 9.1.1576, CmdlineLeavePre and cmdcomplete_info() need 9.1.1329
    autocmd CmdlineChanged : call wildtrigger()
    autocmd CmdlineLeavePre : let s:info = cmdcomplete_info() | if getcmdline() =~ '^\s*fin\%[d]\s' && s:info.selected == -1 && !empty(get(s:info, 'matches', [])) | call setcmdline('find ' . s:info.matches[0]) | endif
  endif
  autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no | nnoremap <buffer> <nowait> d <C-d>| nnoremap <buffer> u <C-u>| nnoremap <buffer> gf :argadd <C-r><C-p><CR>| xnoremap <buffer> gf :<C-u>execute "'<,'>normal! :argadd \<lt>C-r>\<lt>C-p>\<lt>CR>"<CR>
augroup END

command! W call mkdir(expand('%:p:h'), 'p') | write !sudo tee '%' > /dev/null
command! CountSearch %s///gn
command! TrimTrailingSpaces keeppatterns %s/\s\+$//e | silent! execute 'normal! ``'
command! -range JSON if <range> != 0 | execute "'<,'>!python -m json.tool --indent 2" | else | keeppatterns %s/\n\+\%$//e | set shiftwidth=2 filetype=json | execute '%!python -m json.tool --indent 2' | endif
command! -range -nargs=? JoinWithChar if <line1> < <line2> | keeppatterns <line1>,<line2>s/\s\+$//e | keeppatterns <line1>+1,<line2>s/^\s\+//e | if <q-args> != '' | silent keeppatterns <line1>,<line2>-1s/$/\=<q-args>/ | endif | <line1>,<line2>join! | endif
command! ShowHighlightGroups echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
command! DiffOrig execute 'diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype=' . &filetype . ' | read ++edit # | 0d_ | diffthis'
command! Gcd call s:Gcd()
command! -nargs=* Gdiff execute 'diffthis | vnew | setlocal buftype=nofile bufhidden=wipe filetype=' . &filetype . ' | file !git\ show\ <args>:' . expand('%:~:.') . ' | silent read !git show <args>:' . expand('%:~:.') | 0d_ | diffthis
command! -complete=command -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | if <line1> < <line2> | setlocal filetype=' . &filetype . ' | put =getbufline(' . bufnr('%') . ', <line1>, <line2>) | resize ' . min([<line2>-<line1>+2, &lines * 2/5]) . '| else | resize ' . min([15, &lines * 2/5]) . '| endif' | if '<bang>' != '' | execute 'read !' . <q-args> | elseif <q-args> != '' | call append('$', split(execute(<q-args>), "\n")) | endif | 1d
command! -nargs=+ Fd call funcs#grep('fd', <q-args>)
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
command! -nargs=+ RgRegex call s:RgOrGrep('', '-- ' . shellescape(<q-args>))
command! -nargs=+ RgNoRegex call s:RgOrGrep(' --fixed-strings', '-- ' . shellescape(<q-args>))
command! Glow terminal ++curwin glow %

def! s:RgOrGrep(arg: string, pattern: string)
  if executable('rg')
    funcs#grep(s:rg_cmd .. arg, pattern)
  else
    echomsg 'Warning: rg not available, using grep'
    funcs#grep('grep -i -n -I -r' .. arg, pattern .. ' .')
  endif
enddef
def! s:Oldfiles()
  setqflist([], ' ', {lines: plugins#picker#FilterOldfiles(false), efm: '%f'})
  const bufnr = bufnr()
  copen
  execute $'nnoremap <buffer> <CR> <CR><Cmd>bwipeout {bufnr}<bar>cclose<CR>'
enddef
let s:term_buf = 0
def! s:ToggleTerminal()
  const winid = s:term_buf == 0 ? -1 : bufwinid(s:term_buf)
  if winid != -1
    execute $':{win_id2win(winid)}hide'
    return
  endif
  const height = min([15, &lines * 2 / 5])
  if s:term_buf != 0 && term_getstatus(s:term_buf) =~ 'running'
    execute $'botright sbuffer {s:term_buf}'
    execute $'resize {height}'
    return
  endif
  if s:term_buf != 0 && bufexists(s:term_buf)
    execute $'bwipeout! {s:term_buf}'
  endif
  execute $'botright terminal ++close ++kill=hup ++rows={height}'
  s:term_buf = bufnr()
  setlocal nobuflisted bufhidden=hide
enddef
def! s:FoldLevel(): number
  return max([indent(v:lnum), indent(v:lnum + 1)]) / shiftwidth()
enddef
let s:cwd = getcwd(-1)
def! s:Status(): string
  const name = bufname()
  const dir = haslocaldir() != 0 ? getcwd() : s:cwd
  if get(b:, 'status_key', []) != [dir, name]
    b:status_key = [dir, name]
    b:status_path = $"({fnamemodify(dir, ':t')}) {fnamemodify(name, ':~:.')}"
  endif
  return $"[{mode()}]{b:status_path} {&paste ? '[paste]' : ''}"
    .. (&fileencoding != '' && &fileencoding != 'utf-8' ? $'[fileencoding: {&fileencoding}]' : '')
    .. (&fileformat != 'unix' ? $'[fileformat: {&fileformat}]' : '')
enddef
def! s:Gcd()
  const root = plugins#gitdiff#FindRepo(expand('%:p:h'))->get(0, '')
  if root != '' && root != getcwd()
    silent execute 'cd' fnameescape(root)
  endif
enddef
let s:files_cache = []
def! s:Find(arg: string, _: bool): list<string>
  if empty(s:files_cache)
    const job = job_start(executable('rg') ? ['rg', '--files'] : ['find', '.', '-path', '*/.git', '-prune', '-o', '-type', 'f', '-print'],
      {in_io: 'null', err_io: 'null', out_mode: 'raw', drop: 'never', env: {RIPGREP_CONFIG_PATH: $'{g:dot_vim_dir}/config/.ripgreprc'}})
    var out: list<string> = []
    while ch_status(job) =~ '^\%(open\|buffered\)$'
      out->add(ch_readraw(job, {timeout: 100}))
    endwhile
    s:files_cache = out->join('')->split("\n")
  endif
  return arg == '' ? s:files_cache : matchfuzzy(s:files_cache, arg)
enddef
def! s:FileManager()
  const tempfile = tempname()
  const width = &columns * 9 / 10
  const height = &lines * 9 / 10
  const buf = term_start(['yazi', $'--cwd-file={$HOME}/.vim/tmp/last_result', $'--chooser-file={tempfile}', expand('%') ?? '.'], {hidden: 1, term_finish: 'close', term_cols: width, term_rows: height})
  setbufvar(buf, '&buflisted', 0)
  setbufvar(buf, '&bufhidden', 'wipe')
  popup_create(buf, {minwidth: width, minheight: height, border: [], callback: (_, _) => {
    for f in filereadable(tempfile) ? readfile(tempfile) : []
      execute 'edit ' .. fnameescape(f)
    endfor
    delete(tempfile)
  }})
enddef
" https://www.reddit.com/r/vim/comments/11tdlx0/comment/jcii423
def! BufferLine(): string
  var s = ''
  const cur = bufnr()
  for b in range(1, bufnr('$'))
    if !buflisted(b)
      continue
    endif
    const name = bufname(b)
    s ..= (b == cur ? '%#TabLineSel#' : '%#TabLine#') .. (name == '' ? ' * ' : ' ' .. fnamemodify(name, ':t') .. (getbufvar(b, '&modified') ? ' + ' : ' '))
  endfor
  s ..= '%#TabLineFill#%T%='
  if tabpagenr('$') > 1
    for i in range(1, tabpagenr('$'))
      s ..= (i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') .. $'%{i}T {i} '
    endfor
    s ..= '%999X X'
  endif
  return s .. '%#TabLineFill#%T'
enddef
def! s:CompleteKind(): string
  const line = strpart(getline('.'), 0, col('.') - 1)
  return line =~ '\f*/\f*$' ? 'path' : get(b:, 'omni', 0) && line =~ '\w\.\w*$' ? 'omni' : line =~ '\k\k$' ? 'word' : ''
enddef
let s:complete_mode = ''
def! s:Complete(findstart: number, base: string): any
  if !findstart
    return s:complete_mode == 'path' ? getcompletion(base, 'file') : call(&omnifunc, [0, base])
  endif
  s:complete_mode = s:CompleteKind()
  return s:complete_mode == 'path' ? match(strpart(getline('.'), 0, col('.') - 1), '\f*$') : s:complete_mode == 'omni' ? call(&omnifunc, [1, '']) : -2
enddef
" fallback custom completion
def! s:ScheduleAutoComplete()
  const context = [bufnr(), line('.'), col('.'), getline('.')]
  if context == s:complete_context
    return
  endif
  s:complete_context = context
  timer_stop(s:complete_timer)
  s:complete_timer = timer_start(150, s:AutoComplete)
enddef
def! s:AutoComplete(_: number)
  const keys = get({path: "\<C-x>\<C-f>", omni: "\<C-x>\<C-o>", word: "\<C-n>"}, s:CompleteKind(), '')
  if keys == '' || mode() != 'i' || pumvisible() || state('m') != '' || getchar(1) != 0 || complete_info(['mode']).mode == 'ctrl_x'
      || [bufnr(), line('.'), col('.'), getline('.')] != s:complete_context
    return
  endif
  feedkeys(keys .. "\<C-p>", 'n')
enddef

endif
