" ==================== Settings ========================= {{{
source <sfile>:p:h/colors/current_theme.vim  " load g:Theme value
let s:Completion = 1  " 0: mucomplete, 1: coc
let s:PythonPath = 'python3'
let s:ExecCommand = ''
" }}}

" ===================== Plugins ========================= {{{
call plug#begin(expand('<sfile>:p:h'). '/plugged')  " ~/.vim/plugged or ~/vimfiles/plugged or ~/.config/nvim/plugged
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
Plug 'skywind3000/vim-quickui', { 'on': [] }
Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'dhruvasagar/vim-table-mode', { 'on': ['TableModeToggle', 'TableModeRealign', 'Tableize', 'TableAddFormula', 'TableEvalFormulaLine'] }
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'mg979/vim-visual-multi', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-'] }
Plug 'dahu/vim-fanfingtastic', { 'on': ['<Plug>fanfingtastic_' ] }
Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git', 'Gblame', 'Ggrep', 'Glgrep', 'Gdiffsplit', 'Gread'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKeyVisual'] }
Plug 'christoomey/vim-tmux-navigator', { 'on': ['TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious'] }
Plug 'tpope/vim-surround', { 'on': ['<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround', '<Plug>VgSurround'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }  " load on insert doesn't work
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }  " load on startup to record MRU
Plug 'tmsvg/pear-tree'  " lazy load breaks <CR>
Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'pacha/vem-tabline'
Plug 'markonm/traces.vim'
if s:Completion >= 0
  Plug 'sirver/ultisnips'
  Plug 'honza/vim-snippets'
  if s:Completion == 0
    Plug 'lifepillar/vim-mucomplete'
  elseif s:Completion == 1
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  endif
endif
call plug#end()
set guioptions=Mgt  " should set 'M' before vim-plug loads filetype and syntax, but that breaks MacVim's cmd + v
" }}}

" ====================== Themes ========================= {{{
set termguicolors  " load theme after vim-plug loads filetype and syntax
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"  " truecolor
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI.="\<Esc>[6 q"  " cursor shape
let &t_SR.="\<Esc>[4 q"
let &t_EI.="\<Esc>[2 q"
let s:theme_list = {}  " g:Theme < 0 for dark themes
let s:theme_list[0] = 'solarized8_flat'
let s:theme_list[1] = 'PaperColor'
let s:theme_list[2] = 'github'
let s:theme_list[3] = 'one'
let s:theme_list[4] = 'ayu'
let s:theme_list[5] = 'material'
let s:theme_list[6] = 'gruvbox-material'
let s:theme_list[-1] = 'onedark'
let s:theme_list[-2] = 'material'
let s:theme_list[-3] = 'ayu'
let s:theme_list[-4] = 'dracula'
let s:theme_list[-5] = 'nord'
let s:theme_list[-6] = 'solarized8_flat'
let s:theme_list[-7] = 'forest-night'
let s:theme_list[-8] = 'gruvbox-material'
let s:theme_list[-9] = 'sonokai'
let g:sonokai_style = 'andromeda'
function! LoadColorscheme(index)
  let g:material_theme_style = a:index < 0 ? 'palenight' : 'lighter'
  let g:ayucolor = a:index < 0 ? 'mirage' : 'light'
  execute 'set background='. (a:index < 0 ? 'dark' : 'light')
  execute 'colorscheme '. get(s:theme_list, a:index, 'desert')
  if exists('*QuickThemeChange')  " QuickThemeChange fixes vim-quickui issue #8
    call QuickThemeChange(a:index < 0 ? 'papercol' : 'solarized')
  endif
endfunction
call LoadColorscheme(g:Theme)
" }}}

" ====================== Options ======================== {{{
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
set diffopt+=vertical
set splitright
set splitbelow
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set textwidth=0
set autoread
set autochdir
set hidden
set complete-=i
set completeopt=menuone
set shortmess+=c
set shortmess-=S
set nrformats-=octal
set scrolloff=2
set nostartofline
set display=lastline
set previewheight=7
set foldmethod=indent
set foldlevelstart=99
set belloff=all
set history=500
set undofile
set undolevels=1000
set undoreload=10000
set undodir=~/.cache/vim/undo
set tags=./.tags;,.tags
set path=**
set list
set listchars=tab:→\ ,nbsp:␣,trail:•
set encoding=utf-8
set timeoutlen=1500
set ttimeoutlen=40
set synmaxcol=500
set lazyredraw
set noswapfile
set nobackup
set nowritebackup
set statusline=%<[%{mode()}]\ %F\ %{&paste?'[paste]':''}%h%m%r%=%-14.(%c/%{len(getline('.'))}%)\ %l/%L\ %P
" }}}

" ====================== Mappings ======================= {{{
let mapleader=';'
inoremap <F2> <Esc>gT
inoremap <F3> <Esc>gt
noremap <F2> gT
noremap <F3> gt
imap <Space> <Plug>(PearTreeSpace)
map f <Plug>fanfingtastic_f
map t <Plug>fanfingtastic_t
map F <Plug>fanfingtastic_F
map T <Plug>fanfingtastic_T
map , <Plug>fanfingtastic_;
map ;, <Plug>fanfingtastic_,
map ? <Plug>(easymotion-bd-f)
nmap S <Plug>(easymotion-bd-w)
map  gc <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap ds <Plug>Dsurround
nmap cs <Plug>Csurround
nmap cS <Plug>CSurround
nmap ys <Plug>Ysurround
nmap yS <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
xmap S <Plug>VSurround
xmap gS <Plug>VgSurround
nmap <Backspace> <Plug>vem_prev_buffer-
nmap <Space> <Plug>vem_next_buffer-
nmap <leader>bh <Plug>vem_move_buffer_left-
nmap <leader>bl <Plug>vem_move_buffer_right-
nnoremap <leader>bH :-tabmove<CR>
nnoremap <leader>bL :+tabmove<CR>
xnoremap i<Space> iW
onoremap i<Space> iW
xnoremap a<Space> aW
onoremap a<Space> aW
xnoremap il ^og_
onoremap <silent> il :normal vil<CR>$
xnoremap al 0o$
onoremap <silent> al :normal val<CR>
noremap 0 ^
noremap ^ 0
noremap - $
xnoremap - $h
noremap g- g$
noremap <Home> g^
noremap <End> g$
noremap <Down> gj
noremap <Up> gk
inoremap <Home> <C-o>g^
inoremap <End> <C-o>g$
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
xnoremap @q :normal! @q<CR>
xnoremap @@ :normal! @@<CR>
nnoremap Q q:k
nnoremap <CR> :
nnoremap Y y$
xnoremap < <gv
xnoremap > >gv
nnoremap gp `[v`]
nnoremap cr :call <SID>EditRegister()<CR>
nnoremap K :call <SID>LoadQuickUI(1)<CR>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [t :tprevious<CR>
nnoremap ]t :tnext<CR>
nnoremap [e :move .-2<CR>==
nnoremap ]e :move .+1<CR>==
xnoremap [e :move '<-2<CR>gv=gv
xnoremap ]e :move '>+1<CR>gv=gv
nnoremap [<Space> O<Esc>
nnoremap ]<Space> o<Esc>
nnoremap [p O<C-r>"<Esc>
nnoremap ]p o<C-r>"<Esc>
nnoremap <silent> [Q :execute empty(filter(getwininfo(), 'v:val.quickfix')) ? 'copen' : 'cclose'<CR>
nmap ]Q [Q
nnoremap <silent> [L :execute empty(filter(getwininfo(), 'v:val.loclist')) ? 'lopen' : 'lclose'<CR>
nmap ]L [L
xnoremap " c"<C-r><C-p>""<Esc>
xnoremap ' c'<C-r><C-p>"'<Esc>
xnoremap ` c`<C-r><C-p>"`<Esc>
xnoremap ( c(<C-r><C-p>")<Esc>
xnoremap [ c[<C-r><C-p>"]<Esc>
xnoremap { c{<C-r><C-p>"}<Esc>
xnoremap <Space> c<Space><C-r><C-p>"<Space><Esc>
nnoremap <C-c> :nohlsearch <bar> silent! AsyncStop!<CR>:echo<CR>
inoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
nnoremap <C-b> :Lexplore<CR>
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-f> :call <SID>LoadAutoformat()<CR><C-f>
imap <C-f> <Esc>:call <SID>LoadAutoformat()<CR>V<C-f>A
xmap <C-f> :<C-u>call <SID>LoadAutoformat()<CR>gv<C-f>
nmap <C-n> :call <SID>LoadVisualMulti()<CR><C-n>
xmap <C-n> :<C-u>call <SID>LoadVisualMulti()<CR>gv<C-n>
nmap <leader><C-n> :call <SID>LoadVisualMulti()<CR><leader><C-n>
imap <leader>r <Esc><leader>r
nnoremap <leader>r :wall <bar> execute 'AsyncRun '. <SID>GetRunCommand()<CR>
xmap <leader>m :<C-u>call <SID>LoadQuickUI(0)<CR>gv<leader>m
nmap <leader>m :call <SID>LoadQuickUI(0)<CR><leader>m
noremap <leader>y "+y
noremap <leader>p "0p
noremap <leader>P "0P
nnoremap <leader>ff :LeaderfFile<CR>
nnoremap <leader>fm :LeaderfMru<CR>
nnoremap <leader>fb :Leaderf! buffer<CR>
nnoremap <leader>fu :LeaderfFunctionAll<CR>
nnoremap <leader>fg :Leaderf! rg -F -e<Space>""<Left>
xnoremap <leader>fg :<C-u><C-r>=printf('Leaderf! rg -F -e %s', leaderf#Rg#visual())<CR>
nnoremap <leader>fG :LeaderfRgRecall<CR>
nmap <leader>fj <Plug>LeaderfRgBangCwordLiteralBoundary<CR>
xmap <leader>fj <Plug>LeaderfRgBangVisualLiteralNoBoundary<CR>
nnoremap <leader>fq :LeaderfQuickFix<CR>
nnoremap <leader>fl :LeaderfLocList<CR>
nnoremap <leader>fL :Leaderf rg -S<CR>
nnoremap <leader>fa :LeaderfCommand<CR>
nnoremap <leader>ft :LeaderfBufTagAll<CR>
nnoremap <leader>fw :LeaderfWindow<CR>
nnoremap <leader>fs :vertical sfind \c*
nnoremap <leader>fy :registers<CR>:normal! "p<Left>
nnoremap <leader>fY :registers<CR>:normal! "P<Left>
nnoremap <leader>n :let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy/\V<C-r>"<CR>N
nnoremap <leader>k K
nnoremap <leader>u :MundoToggle<CR>
nnoremap <leader>v :Vista!!<CR>
nnoremap <leader>h :WhichKey ';'<CR>
xnoremap <leader>h :<C-u>WhichKeyVisual ';'<CR>
nnoremap <leader>l :nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
xnoremap <leader>s "xy:%s/<C-r>x/<C-r>x/gc<Left><Left><Left>
nnoremap <leader>c :call <SID>PrintCurrVars(0, 0)<CR>
xnoremap <leader>c :<C-u>call <SID>PrintCurrVars(1, 0)<CR>$
nnoremap <leader>C :call <SID>PrintCurrVars(0, 1)<CR>
xnoremap <leader>C :<C-u>call <SID>PrintCurrVars(1, 1)<CR>$
nnoremap <leader>b :buffers<CR>:buffer<Space>
nnoremap <leader>tm :TableModeToggle<CR>
inoremap <leader>w <Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :write !sudo tee %<CR>
nnoremap <leader>q :call <SID>Quit(0)<CR>
nnoremap <leader>x :call <SID>Quit(1)<CR>
cnoremap <expr> <Space> '/?' =~ getcmdtype() ? '.\{-}' : '<Space>'
" }}}

" ====================== Autocmd ======================== {{{
augroup AutoCommands
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g'\"" | endif  " restore last edit position
  autocmd BufWritePost $MYVIMRC source $MYVIMRC  " auto source vimrc when write
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
  autocmd FileType vim setlocal foldmethod=marker  " use triple curly brackets for fold instead of indentation
  autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent execute '!~/.vim/bin/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> edit! <bar> redraw!<CR>
  autocmd FileType python setlocal nosmartindent | syntax keyword pythonSelf self | highlight def link pythonSelf Special  " fix python comment indentation, highlight keyword self
  autocmd FileType * setlocal formatoptions=jql
  autocmd User targets#mappings#user call targets#mappings#extend({'b': {'pair': [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}], 'quote': [{'d':"'"}, {'d':'"'}, {'d':'`'}]}})
augroup END
" }}}

" ===================== Lazy load ======================= {{{
function! s:LoadAutoformat()
  let g:formatters_python = ['yapf']
  inoremap <C-f> <Esc>V:'<,'>Autoformat<CR>A
  nnoremap <C-f> :Autoformat<CR>
  xnoremap <C-f> :'<,'>Autoformat<CR>$
  call plug#load('vim-autoformat')
endfunction
function! s:LoadVisualMulti()
  let g:VM_default_mappings = 0
  let g:VM_exit_on_1_cursor_left = 1
  let g:VM_maps = {}
  let g:VM_maps['Select All'] = '<leader><C-n>'
  let g:VM_maps['Find Under'] = '<C-n>'
  let g:VM_maps['Find Subword Under'] = '<C-n>'
  let g:VM_maps['Remove Last Region'] = '<C-p>'
  let g:VM_maps['Skip Region'] = '<C-x>'
  let g:VM_maps['Switch Mode'] = '<C-c>'
  let g:VM_maps['Case Setting'] = ''
  nmap <C-n> <Plug>(VM-Find-Under)
  xmap <C-n> <Plug>(VM-Find-Subword-Under)
  call plug#load('vim-visual-multi')
endfunction
function! s:LoadQuickUI(open_menu)
  nnoremap <leader>m :call quickui#menu#open('normal')<CR>
  xnoremap <leader>m :<C-u>call quickui#menu#open('visual')<CR>
  nnoremap K :call <SID>OpenQuickUIContextMenu()<CR>
  nnoremap <silent> <leader>tp :call quickui#terminal#open('zsh', {'h': winheight(0) * 3/4, 'w': winwidth(0) * 4/5, 'line': winheight(0) * 1/6, 'callback': 'FloatTermExit'})<CR>
  let g:quickui_color_scheme = g:Theme < 0 ? 'papercol' : 'solarized'
  let g:quickui_show_tip = 1
  let g:quickui_border_style = 2
  call plug#load('vim-quickui')
  call quickui#menu#switch('normal')
  call quickui#menu#reset()
  call quickui#menu#install('&Actions', [
        \ ['&Insert Line', 'execute "normal! o\<Space>\<BS>\<Esc>55a=" | execute "Commentary"', 'Insert a dividing line'],
        \ ['Insert Tim&e', "put=strftime('%x %X')", 'Insert MM/dd/yyyy hh:mm:ss tt'],
        \ ['--', ''],
        \ ['&Word Count', 'call feedkeys("g\<C-g>")', 'Show document details'],
        \ ['Trim &Spaces', 'keeppatterns %s/\s\+$//e | execute "normal! ``"', 'Remove trailing spaces'],
        \ ['Format as JSO&N', 'execute "update | %!python3 -m json.tool" | keeppatterns %s;^\(\s\+\);\=repeat(" ", len(submatch(0))/2);g | execute "normal! ``"', 'Use `python3 -m json.tool` to format current buffer'],
        \ ['--', ''],
        \ ['Open &Buffers', 'call quickui#tools#list_buffer("e")'],
        \ ['Open &Functions', 'call quickui#tools#list_function()'],
        \ ['Open &Terminal', 'call quickui#terminal#open("zsh", {"h": winheight(0) * 3/4, "w": winwidth(0) * 4/5, "line": winheight(0) * 1/6, "callback": "FloatTermExit"})', 'Open terminal as popup window: <leader>tp'],
        \ ['--', ''],
        \ ['Save Sessi&on', 'SSave', 'Save as a new session using vim-startify'],
        \ ['&Delete Session', 'SDelete', 'Delete a session using vim-startify'],
        \ ['--', ''],
        \ ['Edit Vimr&c', 'edit $MYVIMRC'],
        \ ['Open in &VSCode', "execute \"silent !code --goto '\" . expand(\"%\") . \":\" . line(\".\") . \":\" . col(\".\") . \"'\" | redraw!"],
        \ ])
  call quickui#menu#install('&Git', [
        \ ['Git &Status', 'Git', 'Git status'],
        \ ['Git Check&out Buffer', 'Gread', 'Checkout current file and load as unsaved buffer'],
        \ ['Git &Blame', 'Gblame', 'Git blame of current file'],
        \ ['Git &Diff', 'Gdiffsplit', 'Diff current file with last staged version'],
        \ ['Git &Changes', 'Git! difftool', 'Load unstaged changes into quickfix list (use [q, ]q to navigate)'],
        \ ['Git &File History', 'call plug#load("vim-fugitive") | vsplit | 0Gclog', 'Browse previously committed versions of current file'],
        \ ['--', ''],
        \ ['Copy &Remote URL', 'GitHubURL', 'Copy github remote url'],
        \ ])
  call quickui#menu#install('&Toggle', [
        \ ['Ne&trw', 'Lexplore', 'Toggle Vim Netrw'],
        \ ['&Markdown Preview', 'execute "normal \<Plug>MarkdownPreviewToggle"', 'Toggle markdown preview'],
        \ ['Set &Diff         %{&diff ? "[x]" :"[ ]"}', 'execute &diff ? "windo diffoff" : "windo diffthis"', 'Toggle diff in current window'],
        \ ['Set &Fold         %{&foldlevel ? "[ ]" :"[x]"}', 'execute &foldlevel ? "normal! zM" : "normal! zR"', 'Toggle fold by indent'],
        \ ['Set &Wrap         %{&wrap ? "[x]" :"[ ]"}', 'set wrap!', 'Toggle wrap lines'],
        \ ['Set &Paste        %{&paste ? "[x]" :"[ ]"}', 'execute &paste ? "set nopaste number mouse=a signcolumn=auto" : "set paste nonumber norelativenumber mouse= signcolumn=no"', 'Toggle paste mode (shift alt drag to select and copy)'],
        \ ['Set &Spelling     %{&spell ? "[x]" :"[ ]"}', 'set spell!', 'Toggle spell checker (z= to auto correct current word)'],
        \ ['Set Pre&view      %{&completeopt=~"preview" ? "[x]" :"[ ]"}', 'execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"', 'Toggle function preview'],
        \ ['Set CursorLi&ne   %{&cursorline ? "[x]" :"[ ]"}', 'set cursorline!', 'Toggle cursorline'],
        \ ['Set Cursor&Column %{&cursorcolumn ? "[x]" :"[ ]"}', 'set cursorcolumn!', 'Toggle cursorcolumn'],
        \ ['Set &Background %{&background=~"dark" ? "Light" :"Dark"}', 'let &background = &background=="dark" ? "light" : "dark"', 'Toggle background color'],
        \ ])
  call quickui#menu#install('Ta&bular', [
        \ ['Align Using = (delimiter fixed)', 'Tabularize /=\zs', 'Tabularize /=\zs'],
        \ ['Align Using , (delimiter fixed)', 'Tabularize /,\zs', 'Tabularize /,\zs'],
        \ ['Align Using # (delimiter fixed)', 'Tabularize /#\zs', 'Tabularize /#\zs'],
        \ ['Align Using : (delimiter fixed)', 'Tabularize /:\zs', 'Tabularize /:\zs'],
        \ ['--', ''],
        \ ['Align Using = (delimiter centered)', 'Tabularize /=', 'Tabularize /='],
        \ ['Align Using , (delimiter centered)', 'Tabularize /,', 'Tabularize /,'],
        \ ['Align Using # (delimiter centered)', 'Tabularize /#', 'Tabularize /#'],
        \ ['Align Using : (delimiter centered)', 'Tabularize /:', 'Tabularize /:'],
        \ ])
  call quickui#menu#install('Table &Mode', [
        \ ['Table &Mode', 'TableModeToggle', 'Toggle TableMode'],
        \ ['&Reformat Table', 'TableModeRealign', 'Reformat table'],
        \ ['&Format to Table', 'Tableize', 'Format to table, use <leader>T to set delimiter'],
        \ ['Delete Row', 'execute "normal \<Plug>(table-mode-delete-row)"', 'Delete row'],
        \ ['&Delete Column', 'execute "normal \<Plug>(table-mode-delete-column)"', 'Delete column'],
        \ ['Show Cell &Position', 'execute "normal \<Plug>(table-mode-echo-cell)"', 'Show cell index number'],
        \ ['--', ''],
        \ ['&Add Formula', 'TableAddFormula', 'Add formula to current cell, i.e. Sum(r1,c1:r2,c2)'],
        \ ['&Evaluate Formula', 'TableEvalFormulaLine', 'Evaluate formula'],
        \ ])
  let l:quickui_theme_list = []
  let l:category = '(Dark) &'
  for l:index in sort(keys(s:theme_list), 'N')
    if l:index == 0
      call reverse(l:quickui_theme_list)
      call add(l:quickui_theme_list, ['--', ''])
      let l:category = '(Light) &'
    endif
    call add(l:quickui_theme_list, [l:category. s:theme_list[l:index], "execute 'call writefile([\"let g:Theme = ". l:index. '"], "'. substitute(fnamemodify(expand('$MYVIMRC'), ':p:h'), '\', '\\\\', 'g'). "/colors/current_theme.vim\")' | call LoadColorscheme(". l:index. ')'])
  endfor
  call quickui#menu#install('&Color Scheme', l:quickui_theme_list)
  call quickui#menu#switch('visual')
  call quickui#menu#reset()
  call quickui#menu#install('&Git', [
        \ ['Copy &Remote URL', "'<,'>GitHubURL", 'Copy github remote url'],
        \ ])
  call quickui#menu#install('&Tabular', [
        \ ['Align Using = (delimiter fixed)', "'<,'>Tabularize /=\\zs", "'<,'>Tabularize /=\\zs"],
        \ ['Align Using , (delimiter fixed)', "'<,'>Tabularize /,\\zs", "'<,'>Tabularize /,\\zs"],
        \ ['Align Using # (delimiter fixed)', "'<,'>Tabularize /#\\zs", "'<,'>Tabularize /#\\zs"],
        \ ['Align Using : (delimiter fixed)', "'<,'>Tabularize /:\\zs", "'<,'>Tabularize /:\\zs"],
        \ ['--', ''],
        \ ['Align Using = (delimiter centered)', "'<,'>Tabularize /=", "'<,'>Tabularize /="],
        \ ['Align Using , (delimiter centered)', "'<,'>Tabularize /,", "'<,'>Tabularize /,"],
        \ ['Align Using # (delimiter centered)', "'<,'>Tabularize /#", "'<,'>Tabularize /#"],
        \ ['Align Using : (delimiter centered)', "'<,'>Tabularize /:", "'<,'>Tabularize /:"],
        \ ['--', ''],
        \ ['Sort Asc', "'<,'>sort", 'Sort in ascending order (sort)'],
        \ ['Sort Desc', "'<,'>sort!", 'Sort in descending order (sort!)'],
        \ ['Sort Num Asc', "'<,'>sort n", 'Sort numerically in ascending order (sort n)'],
        \ ['Sort Num Desc', "'<,'>sort! n", 'Sort numerically in descending order (sort! n)'],
        \ ])
  call quickui#menu#install('Table &Mode', [
        \ ['Reformat Table', "'<,'>TableModeRealign", 'Reformat table'],
        \ ['Format to Table', "'<,'>Tableize", 'Format to table, use <leader>T to set delimiter'],
        \ ])
  if a:open_menu == 1
    call <SID>OpenQuickUIContextMenu()
  endif
endfunction
function! s:OpenQuickUIContextMenu()
  let l:quickui_content = []
  if s:Completion == 1
    call add(l:quickui_content, ['Docu&mentation', 'call CocAction("doHover")', 'Coc documentation'])
    call add(l:quickui_content, ['D&efinition', 'execute "normal \<Plug>(coc-definition)"', 'Coc definition'])
    call add(l:quickui_content, ['&Type Definition', 'execute "normal \<Plug>(coc-type-definition)"', 'Coc type definition'])
    call add(l:quickui_content, ['&References', 'execute "normal \<Plug>(coc-references)"', 'Coc references'])
    call add(l:quickui_content, ['&Implementation', 'execute "normal \<Plug>(coc-implementation)"', 'Coc implementation'])
    call add(l:quickui_content, ['Re&name', 'execute "normal \<Plug>(coc-rename)"', 'Coc rename'])
    call add(l:quickui_content, ['&Fix', 'execute "normal \<Plug>(coc-fix-current)"', 'Coc fix'])
    call add(l:quickui_content, ['--', ''])
    call add(l:quickui_content, ['Git Hunk &Diff', 'CocCommand git.chunkInfo', 'Coc git chunk info'])
    call add(l:quickui_content, ['Git Hunk &Undo', 'CocCommand git.chunkUndo', 'Coc git undo chunk'])
    call add(l:quickui_content, ['Git Hunk &Stage', 'CocCommand git.chunkStage', 'Coc git stage chunk'])
  endif
  call add(l:quickui_content, ['Git &Blame', "call setbufvar(winbufnr(popup_atcursor(systemlist('cd '. shellescape(fnamemodify(resolve(expand('%:p')), ':h')). ' && git log --no-merges -n 1 -L '. shellescape(line('v'). ','. line('.'). ':'. resolve(expand('%:p')))), { 'padding': [1,1,1,1], 'pos': 'botleft', 'wrap': 0 })), '&filetype', 'git')", 'Git blame of current line'])
  call add(l:quickui_content, ['--', ''])
  call add(l:quickui_content, ['Built-in D&ocs', 'execute "normal! K"', 'Vim built in help'])
  call quickui#context#open(l:quickui_content, {'index': g:quickui#context#cursor})
endfunction
" }}}

" ====================== Functions ====================== {{{
function! FloatTermExit(code)
  setlocal number signcolumn=auto
endfunction
function! s:DoAction(algorithm, type)  " https://vim.fandom.com/wiki/Act_on_text_objects_with_custom_functions
  let l:sel_save = &selection
  let l:cb_save = &clipboard
  set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
  let l:reg_save = @@
  if a:type =~ '^\d\+$'
    silent execute 'normal! V'. a:type. '$y'
  elseif a:type =~ '^.$'
    silent execute "normal! `<". a:type. "`>y"
  elseif a:type == 'line'
    silent execute "normal! '[V']y"
  elseif a:type == 'block'
    silent execute "normal! `[\<C-V>`]y"
  else
    silent execute "normal! `[v`]y"
  endif
  let l:repl = s:{a:algorithm}(@@)
  if type(l:repl) == 1
    call setreg('@', l:repl, getregtype('@'))
    normal! gvp
  endif
  let @@ = l:reg_save
  let &selection = l:sel_save
  let &clipboard = l:cb_save
endfunction
function! s:ActionOpfunc(type)
  return s:DoAction(s:encode_algorithm, a:type)
endfunction
function! s:ActionSetup(algorithm)
  let s:encode_algorithm = a:algorithm
  let &opfunc = matchstr(expand('<sfile>'), '<SNR>\d\+_'). 'ActionOpfunc'
endfunction
function! s:MapAction(algorithm, key)
  execute 'nnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>ActionSetup("'. a:algorithm. '")<CR>g@'
  execute 'xnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>DoAction("'. a:algorithm. '", visualmode())<CR>'
  execute 'nnoremap <silent> <Plug>actionsLine'.a:algorithm.' :<C-U>call <SID>DoAction("'. a:algorithm. '", v:count1)<CR>'
  execute 'nmap '. a:key. '  <Plug>actions'. a:algorithm
  execute 'xmap '. a:key. '  <Plug>actions'. a:algorithm
  execute 'nmap '. a:key.a:key[strlen(a:key)-1]. ' <Plug>actionsLine'. a:algorithm
endfunction
command! -nargs=* -range GitHubURL :call <SID>GitHubURL(<count>, <line1>, <line2>, <f-args>)
function! s:GitHubRun(...)
  return substitute(system(join(a:000, ' | ')), "\n", '', '')
endfunction
function! s:GitHubURL(count, line1, line2, ...)
  let l:get_remote = 'git remote -v | grep -E "^origin\s+.*github\.com.*\(fetch\)" | head -n 1'
  let l:get_username = 'sed -E "s/.*com[:\/](.*)\/.*/\\1/"'
  let l:get_repo = 'sed -E "s/.*com[:\/].*\/(.*).*/\\1/" | cut -d " " -f 1'
  let l:optional_ext = 'sed -E "s/\.git//"'
  if len(a:000) == 0
    let l:username = s:GitHubRun(l:get_remote, l:get_username)
    let l:repo = s:GitHubRun(l:get_remote, l:get_repo, l:optional_ext)
  elseif len(a:000) == 1
    let l:username = a:000[0]
    let l:repo = s:GitHubRun(l:get_remote, l:get_repo, l:optional_ext)
  elseif len(a:000) == 2
    let l:username = a:000[0]
    let l:repo = a:000[1]
  else
    return 'Too many arguments'
  endif
  let l:commit = s:GitHubRun('git rev-parse HEAD')
  let l:repo_root = s:GitHubRun('git rev-parse --show-toplevel')
  let l:file_path = substitute(expand('%:p'), l:repo_root . '/', '', 'e')
  let l:url = join(['https://github.com', l:username, l:repo, 'blob', l:commit, l:file_path], '/')
  if a:count == -1
    let l:line = '#L' . line('.')
  else
    let l:line = '#L' . a:line1 . '-L' . a:line2
  endif
  let @+ = l:url. l:line
  echom 'Copied: '. l:url. l:line
endfunction
function! s:EditRegister() abort
  let l:r = nr2char(getchar())
  call feedkeys('q:ilet @'. l:r. " = \<C-r>\<C-r>=string(@". l:r. ")\<CR>\<Esc>0f'", 'n')
endfunction
function! s:Quit(buffer_mode) abort
  if (a:buffer_mode == 1 || tabpagenr('$') == 1 && winnr('$') == 1) && len(getbufinfo({'buflisted':1})) > 1
    let l:current_buffer = bufnr('%')
    let l:next_buffer = g:vem_tabline#tabline.get_replacement_buffer()
    try
      execute 'confirm '. l:current_buffer. 'bdelete'
      if l:next_buffer != 0
        execute l:next_buffer. 'buffer'
      endif
    catch /E516:/
    endtry
  else
    execute 'quit'
  endif
endfunction
function! s:PrintCurrVars(visual, printAbove)
  let l:new_line = "normal! o\<Space>\<BS>"
  if a:printAbove
    let l:new_line = "normal! O\<Space>\<BS>"
  endif
  if a:visual  " print selection
    let l:vars = [getline('.')[getpos("'<")[2] - 1:getpos("'>")[2] - 1]]
  elseif getline('.') =~ '[^a-zA-Z0-9_,\[\]. ]\|[a-zA-Z0-9_\]]\s\+\w'  " print variable under cursor if line not comma separated
    let l:vars = [expand('<cword>')]
  else  " print variables on current line separated by commas
    let l:vars = split(substitute(getline('.'), ' ', '', 'ge'), ',')
    let l:new_line = "normal! cc\<Space>\<BS>"
  endif
  let l:print = {}
  let l:print['python'] = "print(f'". join(map(copy(l:vars), "v:val. ': {'. v:val. '}'"), ' | '). "')"
  let l:print['javascript'] = 'console.log(`'. join(map(copy(l:vars), "v:val. ': ${'. v:val. '}'"), ' | '). '`)'
  let l:print['javascriptreact'] = l:print['javascript']
  let l:print['typescript'] = l:print['javascript']
  let l:print['typescriptreact'] = l:print['javascript']
  let l:print['java'] = 'System.out.println('. join(map(copy(l:vars), "'\"'. v:val. ': \" + '. v:val"), ' + " | " + '). ')'
  let l:print['vim'] = 'echomsg '. join(map(copy(l:vars), "\"'\". v:val. \": '. \". v:val"), ". ' | '. ")
  if has_key(l:print, &filetype)
    execute l:new_line
    call append(line('.'), l:print[&filetype])
    normal! J
  endif
endfunction
" }}}

" =================== Other plugins ===================== {{{
let g:startify_session_dir = '~/.cache/vim/sessions'
let g:startify_session_persistence = 1
let g:startify_enable_special = 0
let g:startify_enable_unsafe = 1
let g:startify_fortune_use_unicode = 1
let g:startify_commands = [
      \ { '!': ['Git modified', ':args `Git ls-files --modified` | Git difftool'] },
      \ { 'f': ['Find files', 'LeaderfFile'] },
      \ { 'm': ['Find MRU', 'LeaderfMru'] },
      \ { 'c': ['Edit vimrc', 'edit $MYVIMRC'] },
      \ ]
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ ]
let g:asyncrun_open = 12
let g:vista_executive_for = { 'typescriptreact': 'coc' }
let g:EasyMotion_smartcase = 1
let g:mundo_preview_bottom = 1
let g:mundo_width = 30
let g:netrw_dirhistmax = 0  " built in :Lexplore<CR> settings
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:vem_tabline_show = 2
let g:vem_tabline_multiwindow_mode = 0
set wildignore+=*/tmp/*,*/\.git/*,*/node_modules/*,*/venv/*,*/\.env/*  " do NOT wildignore plugged
let g:Lf_WildIgnore = { 'dir':['tmp','.git','plugged','node_modules','venv','.env','.local','.idea','*cache*'],'file':[] }
let g:Lf_MruWildIgnore = { 'dir':['.git'], 'file':[] }
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_UseCache = 0
let g:Lf_ShortcutF = '<C-p>'
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_RgStorePattern = 'g'
let g:Lf_PreviewResult = { 'Function': 0 }
let g:Lf_CommandMap = { '<C-]>':['<C-v>'],'<C-j>':['<C-j>','<DOWN>'],'<C-k>':['<C-k>','<UP>'] }
let g:Lf_NormalMap = { 'File': [['u', ':LeaderfFile ..<CR>']] }
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Aa'
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:Lf_CtagsFuncOpts = { 'typescriptreact': '--map-typescript=.tsx' }
let g:table_mode_tableize_map = ''
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
let g:table_mode_corner = '|'  " markdown compatible tablemode
let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'css', 'html', 'python', 'java', 'c', 'bash=sh']  " should work without plugins
" }}}

" ==================== Execute code ===================== {{{
command! -complete=file -nargs=* SetArgs let b:args = <q-args> == '' ? '' : ' '. <q-args>  " :SetArgs <args...><CR>, all execution will use args
command! -complete=shellcmd -nargs=+ Shell call <SID>RunShellCommand(<q-args>)
let s:OutputCount = 1
function! s:RunShellCommand(command)
  let l:expanded_command = substitute(a:command, './%<', './'. fnameescape(expand('%<')), '')
  let l:expanded_command = substitute(l:expanded_command, '%<', fnameescape(expand('%<')), '')
  let l:expanded_command = substitute(l:expanded_command, '%', fnameescape(expand('%')), '')
  let l:curr_bufnr = bufwinnr('%')
  let l:win_remain = winnr('$')
  while l:win_remain > 1 && bufname('%') !~ '[Output_'
    execute 'wincmd w'
    let l:win_remain = l:win_remain - 1
  endwhile
  if bufname('%') =~ '[Output_'
    setlocal modifiable
    execute '%d'
  else
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap nocursorline nocursorcolumn
    silent execute '0f | file [Output_'. s:OutputCount. '] | resize '. (winheight(0) * 4/5)
    let s:OutputCount = s:OutputCount + 1
  endif
  call setline(1, 'Run: '. l:expanded_command)
  call setline(2, substitute(getline(1), '.', '=', 'g'))
  execute '$read !'. l:expanded_command
  setlocal nomodifiable
  execute l:curr_bufnr. 'wincmd w'
endfunction
function! s:GetRunCommand()
  let l:run_command = {}
  let l:run_command['python'] = s:PythonPath. ' %'
  let l:run_command['c'] = 'gcc % -o %< -g && ./%<'
  let l:run_command['cpp'] = 'g++ % -o %< -g && ./%<'
  let l:run_command['java'] = 'javac % && java %<'
  let l:run_command['javascript'] = 'node %'
  return get(l:run_command, &filetype, ''). (exists('b:args') ? b:args : '')
endfunction
if s:ExecCommand != ''
  nnoremap <leader>r :wall <bar> execute s:ExecCommand<CR>
endif
" }}}

" ==================== Auto complete ==================== {{{
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<TAB>'
let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
imap <expr> <CR> pumvisible() ? "\<Esc>a" : "\<C-g>u\<Plug>(PearTreeExpand)\<Space>\<BS>"
if s:Completion == 0  " mucomplete
  set omnifunc=syntaxcomplete#Complete
  set completeopt+=noselect
  inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
  inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
  let g:mucomplete#enable_auto_at_startup = 1
  let g:mucomplete#chains = {'default': ['path', 'ulti', 'keyn', 'omni', 'file']}
elseif s:Completion == 1  " coc
  let g:coc_global_extensions = ['coc-git', 'coc-snippets', 'coc-highlight', 'coc-vimlsp', 'coc-tsserver', 'coc-html', 'coc-css', 'coc-emmet', 'coc-python', 'coc-explorer', 'coc-yank']
  " to manually install extensions, run :CocInstall coc-git coc-...
  " or run cd ~/.config/coc/extensions && yarn add coc-..., yarn cannot be cmdtest
  " in Windows run cd %LOCALAPPDATA%/coc/extensions && yarn add coc-...
  let g:coc_snippet_next = '<Tab>'
  let g:coc_snippet_prev = '<S-Tab>'
  set updatetime=300
  set signcolumn=yes
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <C-@> coc#refresh()
  inoremap <expr> <C-Space> coc#refresh()
  nnoremap <C-b> :CocCommand explorer<CR>
  nnoremap <C-f> :call CocAction('format')<CR>
  xmap <C-f> <Plug>(coc-format-selected)
  nmap <leader>d <Plug>(coc-definition)
  nmap <leader>R <Plug>(coc-rename)
  nmap <leader>a <Plug>(coc-fix-current)
  nnoremap <leader>fA :CocList<CR>
  nnoremap <leader>fy :CocList yank<CR>
  imap <C-k> <Plug>(coc-snippets-expand)
  nmap [a <Plug>(coc-diagnostic-prev)
  nmap ]a <Plug>(coc-diagnostic-next)
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)
endif
" }}}

" ====================== Terminal ======================= {{{
if has('nvim')
  augroup NvimTerminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no | startinsert
    autocmd TermClose * quit
    autocmd BufEnter term://* startinsert
  augroup END
  tnoremap <F2> <C-\><C-n>gT
  tnoremap <F3> <C-\><C-n>gt
  tnoremap <C-u> <C-\><C-n>
  tnoremap <Esc> <C-\><C-n>
  tnoremap <silent> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
  tnoremap <silent> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
  tnoremap <silent> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
  tnoremap <silent> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
  nnoremap <leader>to :execute 'split <bar> resize'. (winheight(0) * 2/5). ' <bar> terminal'<CR>
  nnoremap <leader>tO :terminal<CR>
  nnoremap <leader>th :split <bar> terminal<CR>
  nnoremap <leader>tv :vsplit <bar> terminal<CR>
  nnoremap <leader>tt :tabedit <bar> terminal<CR>
  nmap <leader>tp :call <SID>LoadQuickUI(0)<CR><leader>tp
  call <SID>MapAction('SendToNvimTerminal', '<leader>te')
  function! s:SendToNvimTerminal(str)
    let l:job_id = -1
    for l:buff_n in tabpagebuflist()
      if nvim_buf_get_name(l:buff_n) =~ 'term://'
        let l:job_id = nvim_buf_get_var(l:buff_n, 'terminal_job_id')  " sends to last opened terminal in current tab
        break
      endif
    endfor
    if l:job_id > 0
      let l:lines = getline(getpos("'<")[1], getpos("'>")[1])
      let l:indent = match(l:lines[0], '[^ \t]')  " remove unnecessary indentation if first line is indented
      for l:line in l:lines
        call jobsend(l:job_id, (match(l:line, '[^ \t]') ? l:line[l:indent:] : l:line). "\n")
      endfor
    endif
  endfunction
else
  set viminfo+=n~/.cache/vim/viminfo
  augroup VimTerminal
    autocmd!
    autocmd TerminalOpen * setlocal nonumber norelativenumber signcolumn=no
  augroup END
  " do not tmap <Esc> in vim 8
  tnoremap <F2> <C-w>gT
  tnoremap <F3> <C-w>gt
  tnoremap <C-u> <C-\><C-n>
  tnoremap <silent> <C-h> <C-w>:TmuxNavigateLeft<CR>
  tnoremap <silent> <C-j> <C-w>:TmuxNavigateDown<CR>
  tnoremap <silent> <C-k> <C-w>:TmuxNavigateUp<CR>
  tnoremap <silent> <C-l> <C-w>:TmuxNavigateRight<CR>
  nnoremap <leader>to :execute 'terminal ++close ++rows='. winheight(0) * 2/5<CR>
  nnoremap <leader>tO :terminal ++curwin ++close<CR>
  nnoremap <leader>th :terminal ++close<CR>
  nnoremap <leader>tv :vertical terminal ++close<CR>
  nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
  nmap <leader>tp :call <SID>LoadQuickUI(0)<CR><leader>tp
  call <SID>MapAction('SendToTerminal', '<leader>te')
  function! s:SendToTerminal(str)
    let l:buff_n = term_list()
    if len(l:buff_n) > 0
      let l:buff_n = l:buff_n[0]  " sends to most recently opened terminal
      let l:lines = getline(getpos("'<")[1], getpos("'>")[1])
      let l:indent = match(l:lines[0], '[^ \t]')  " remove unnecessary indentation if first line is indented
      for l:line in l:lines
        call term_sendkeys(l:buff_n, (match(l:line, '[^ \t]') ? l:line[l:indent:] : l:line). "\<CR>")
        sleep 10m
      endfor
    endif
  endfunction
endif
" }}}

" ================== System specific ==================== {{{
if has('gui_running')
  let &t_SI=""
  let &t_SR=""
  let &t_EI=""
  imap <C-Tab> <F3>
  imap <C-S-Tab> <F2>
  nmap <C-Tab> <F3>
  nmap <C-S-Tab> <F2>
  set guicursor+=a:blinkon0
  if &columns < 85 && &lines < 30
    set lines=25
    set columns=90
  endif
  if has('win32')
    " Windows gVim
    set guifont=Consolas_NF:h11:cANSI
    set pythonthreedll=python38.dll  " set to python3x.dll for python3.x, python and vim x86/x64 version need to match
    let g:gVimPath = substitute($VIMRUNTIME. '\gvim', '\', '\\\\', 'g'). ' '
    function! s:ActivatePyEnv(environment)
      if a:environment == ''
        silent execute '!venv & '. g:gVimPath. expand('%:p')
      else
        silent execute '!activate '. a:environment. ' & '. g:gVimPath. expand('%:p')
      endif
    endfunction
    command! -nargs=* Activate call <SID>ActivatePyEnv(<q-args>) <bar> quit
    nnoremap <leader>W :silent execute '!sudo /c '. g:gVimPath. '"%:p"'<CR>
    nnoremap <leader><C-r> :silent execute '!'. g:gVimPath. '"%:p"' <bar> quit<CR>
  elseif has('gui_vimr')
    " VimR
    inoremap <D-Left> <C-o>^
    noremap <D-Left> ^
    inoremap <D-Right> <C-o>$
    noremap <D-Right> $
    inoremap <M-BS> <C-w>
    noremap <M-BS> b
    inoremap <D-BS> <C-u>
    noremap <D-BS> 0
    inoremap <M-Right> <C-o>w
    noremap <M-Right> w
    inoremap <M-Left> <C-o>b
    noremap <M-Left> b
    inoremap <D-Down> <C-o>G
    noremap <D-Down> G
    inoremap <D-Up> <C-o>gg
    noremap <D-Up> gg
  else
    " MacVim
    set guifont=JetBrainsMonoNerdFontComplete-Regular:h13
  endif
elseif has('macunix')
  " iTerm2 vim
  inoremap <C-a> <C-o>^
  noremap <C-a> ^
  inoremap <C-e> <C-o>$
  noremap <C-e> $
  inoremap <Esc>f <C-o>w
  nnoremap <Esc>f w
  inoremap <Esc>b <C-o>b
  nnoremap <Esc>b b
else
  " WSL vim
  function! s:CopyToWinClip(str)
    call system('clip.exe', a:str)
  endfunction
  call <SID>MapAction('CopyToWinClip', '<leader>y')
endif
" }}}
