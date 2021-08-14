" ==================== Settings ========================= {{{
let s:Completion = 0  " 0: custom fuzzy completion, 1: coc
" }}}

" ===================== Plugins ========================= {{{
call plug#begin(expand('<sfile>:p:h'). '/plugged')  " ~/.vim/plugged or ~/vimfiles/plugged or ~/.config/nvim/plugged
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
Plug 'skywind3000/vim-quickui', { 'on': [] }
Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'dhruvasagar/vim-table-mode', { 'on': ['TableModeToggle', 'TableModeRealign', 'Tableize', 'TableAddFormula', 'TableEvalFormulaLine'] }
Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'mg979/vim-visual-multi', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': '<Plug>(easymotion-' }
Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git', 'GBrowse', 'Ggrep', 'Glgrep', 'Gdiffsplit', 'Gread', 'Gwrite', 'Gedit'] }
Plug 'tpope/vim-rhubarb', { 'on': ['GBrowse'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
" comment out CursorMoved autocmd in plugged/vim-context-commentstring/plugin/context-commentstring.vim:23, change s:UpdateCommentString to UpdateCommentString
" add "if &filetype == 'typescriptreact' | call UpdateCommentString() | endif" to plugged/vim-commentary/plugin/commentary.vim:28 in s:go()
Plug 'suy/vim-context-commentstring', { 'for': 'typescriptreact' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescriptreact' }
Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescriptreact' }
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKeyVisual'] }
Plug 'christoomey/vim-tmux-navigator', { 'on': ['TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious'] }
Plug 'machakann/vim-swap', { 'on': '<Plug>(swap-' }
Plug 'chaoren/vim-wordmotion', { 'on': '<Plug>WordMotion_' }
Plug 'terryma/vim-expand-region', { 'on': '<Plug>(expand_region_' }
Plug 'wellle/context.vim', { 'on': ['ContextToggleWindow', 'ContextPeek'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
Plug 'inkarkat/vim-ingo-library', { 'on': '<Plug>Mark' }
Plug 'inkarkat/vim-mark', { 'on': '<Plug>Mark' }
Plug 'ojroques/vim-oscyank', { 'on': ['OSCYank', 'OSCYankReg'] }
" use noautocmd for Tnew/Ttoggle to avoid triggering BufReadPost and restoring last edit position again
Plug 'kassio/neoterm', { 'on': ['Ttoggle', 'Tnew'] }
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'tamago324/LeaderF-filer'
Plug 'svermeulen/vim-yoink'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-sandwich'
Plug 'justinmk/vim-sneak'
Plug 'tmsvg/pear-tree'
Plug 'joshuali925/vim-indent-object'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-unimpaired'
Plug 'rhysd/conflict-marker.vim'
Plug 'markonm/traces.vim'
Plug 'tpope/vim-repeat'
Plug 'jdhao/better-escape.vim'
if s:Completion >= 1
  Plug 'honza/vim-snippets'
  if s:Completion == 1
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  endif
endif
call plug#end()
set guioptions=Mgt  " should set 'M' before vim-plug loads filetype and syntax, but that breaks MacVim's cmd + v
" }}}

" ====================== Themes ========================= {{{
source <sfile>:p:h/colors/current_theme.vim  " load g:Theme value
set termguicolors  " load theme after vim-plug loads filetype and syntax
let &t_ut = ''  " https://github.com/microsoft/terminal/issues/832
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"  " truecolor
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI .= "\<Esc>[6 q"  " cursor shape
let &t_SR .= "\<Esc>[4 q"
let &t_EI .= "\<Esc>[2 q"
let s:theme_list = {}  " g:Theme < 0 for dark themes
let s:theme_list[0] = 'solarized'
let s:theme_list[1] = 'PaperColor'
let s:theme_list[2] = 'github'
let s:theme_list[3] = 'ayu'
let s:theme_list[4] = 'gruvbox_material'
let s:theme_list[-1] = 'one'
let s:theme_list[-2] = 'ayu'
let s:theme_list[-3] = 'dracula'
let s:theme_list[-4] = 'nord'
let s:theme_list[-5] = 'github'
let s:theme_list[-6] = 'solarized'
let s:theme_list[-7] = 'forest_night'
let s:theme_list[-8] = 'gruvbox_material'
let s:theme_list[-9] = 'sonokai'
let g:sonokai_style = 'andromeda'
let g:github_colors_soft = 1
let g:lightline = {}
function! LoadColorscheme(index, refresh)
  let g:lightline.colorscheme = s:theme_list[a:index]
  let g:quickui_color_scheme = a:index < 0 ? 'papercol-dark' : 'papercol-light'
  let g:ayucolor = a:index < 0 ? 'mirage' : 'light'
  execute 'set background='. (a:index < 0 ? 'dark' : 'light')
  execute 'colorscheme '. get(s:theme_list, a:index, 'desert')
  if a:refresh
    call lightline#init()
    execute 'source' globpath(&runtimepath, 'autoload/lightline/colorscheme/'. s:theme_list[a:index]. '.vim')
    call lightline#colorscheme()
    call lightline#update()
    execute 'set filetype='. &filetype
  endif
endfunction
call LoadColorscheme(g:Theme, 0)
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
set smarttab
set expandtab
set tabstop=4
set softtabstop=2
set shiftwidth=2
set shiftround
set textwidth=0
set autoread
set autochdir
set hidden
set complete=.,w,b,u
set completeopt=menuone,noselect
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
set foldmethod=indent
set foldlevelstart=99
set belloff=all
set history=1000
set undofile
set undolevels=1000
set undoreload=10000
set path=.,,**5
set list
set listchars=tab:»\ ,nbsp:␣,trail:•
set fillchars=vert:│
set encoding=utf-8
set timeout
set timeoutlen=1500
set ttimeoutlen=40
set updatetime=300
set synmaxcol=1000
set lazyredraw
set noswapfile
set nobackup
set nowritebackup
set wildcharm=<C-z>
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
set grepformat=%f:%l:%c:%m,%f:%l:%m
" }}}

" ====================== Mappings ======================= {{{
let mapleader=';'
imap <F2> <Esc><F2>
imap <F3> <Esc><F3>
noremap <expr> <F2> tabpagenr('$') > 1 ? 'gT' : ':bprevious<CR>'
noremap <expr> <F3> tabpagenr('$') > 1 ? 'gt' : ':bnext<CR>'
nnoremap <BS> :bprevious<CR>
nnoremap \ :bnext<CR>
nnoremap [\ :tabedit<CR>
nnoremap ]\ :enew<CR>
map gw <Plug>WordMotion_w
map gb <Plug>WordMotion_b
map ge <Plug>WordMotion_e
omap u <Plug>WordMotion_w
omap iu <Plug>WordMotion_iw
xmap iu <Plug>WordMotion_iw
omap au <Plug>WordMotion_aw
xmap au <Plug>WordMotion_aw
xmap v <Plug>(expand_region_expand)
xmap <BS> <Plug>(expand_region_shrink)
imap <Space> <Plug>(PearTreeSpace)
map [m <Plug>MarkSearchOrCurPrev
map ]m <Plug>MarkSearchOrCurNext
map <leader>m <Plug>MarkSet
map <leader>M <Plug>MarkRegex
map f <Plug>Sneak_f
map F <Plug>Sneak_F
nmap t <Plug>Sneak_s
nmap T <Plug>Sneak_S
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T
map , <Plug>Sneak_;
map ;, <Plug>Sneak_,
map <expr> n sneak#is_sneaking() ? '<Plug>Sneak_;' : 'n'
map <expr> N sneak#is_sneaking() ? '<Plug>Sneak_,' : 'N'
map ' <Plug>(easymotion-bd-f)
map q <Plug>(easymotion-bd-w)
map <leader>e <Plug>(easymotion-lineanywhere)
map <leader>j <Plug>(easymotion-sol-j)
map <leader>k <Plug>(easymotion-sol-k)
map gc <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap [g <Plug>(GitGutterPrevHunk)
nmap ]g <Plug>(GitGutterNextHunk)
omap ig <Plug>(GitGutterTextObjectInnerPending)
xmap ig <Plug>(GitGutterTextObjectInnerVisual)
omap ag <Plug>(GitGutterTextObjectOuterPending)
xmap ag <Plug>(GitGutterTextObjectOuterVisual)
omap ia <Plug>(swap-textobject-i)
xmap ia <Plug>(swap-textobject-i)
omap aa <Plug>(swap-textobject-a)
xmap aa <Plug>(swap-textobject-a)
nmap g< <Plug>(swap-prev)
nmap g> <Plug>(swap-next)
nmap gs <Plug>(swap-interactive)
xmap gs <Plug>(swap-interactive)
nmap ys <Plug>(operator-sandwich-add)
nmap yss <Plug>(operator-sandwich-add)iw
nmap yS ysg_
nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap dss <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap css <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
xmap s <Plug>(operator-sandwich-add)
xmap s< <Plug>(operator-sandwich-add)t
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
noremap <expr> 0 col('.') - 1 == match(getline('.'), '\S') ? '0' : '^'
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
nnoremap cr :call <SID>EditRegister()<CR>
nnoremap K :call <SID>LoadQuickUI(1)<CR>
nnoremap Z[ :1,.- bdelete<CR>
nnoremap Z] :.+,$ bdelete<CR>
" https://github.com/vim/vim/issues/4738
nnoremap gx :execute 'AsyncRun -mode=term -pos=hide open '. expand('<cfile>')<CR>
nmap <C-c> <Plug>MarkAllClear:nohlsearch <bar> call sneak#cancel() <bar> silent! AsyncStop!<CR>:echo<CR>
inoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-o> :call <SID>LoadQuickUI(0)<CR><C-o>
nmap <C-f> :call <SID>LoadAutoformat()<CR><C-f>
xmap <C-f> :<C-u>call <SID>LoadAutoformat()<CR>gv<C-f>
nmap <C-n> :call <SID>LoadVisualMulti()<CR><C-n>
xmap <C-n> :<C-u>call <SID>LoadVisualMulti()<CR>gv<C-n>
nmap <leader><C-n> :call <SID>LoadVisualMulti()<CR><leader><C-n>
imap <leader>r <Esc><leader>r
nnoremap <leader>r :update <bar> execute <SID>GetRunCommand()<CR>
nmap <CR> :call <SID>LoadQuickUI(0)<CR><CR>
xmap <CR> :<C-u>call <SID>LoadQuickUI(0)<CR>gv<CR>
nmap y <Plug>(YoinkYankPreserveCursorPosition)
xmap y <Plug>(YoinkYankPreserveCursorPosition)
noremap <leader>y "+y
nnoremap <leader>Y "+y$
nmap p <Plug>(YoinkPaste_p)
nmap P <Plug>(YoinkPaste_P)
nmap <leader>p <Plug>(YoinkPostPasteSwapBack)
nmap <leader>P <Plug>(YoinkPostPasteSwapForward)
nnoremap <leader>fs :LeaderfFile<CR>
nnoremap <leader>fd :LeaderfFiler<CR>
nnoremap <leader>fm :LeaderfMru<CR>
nnoremap <leader>fb :Leaderf! buffer<CR>
nnoremap <leader>fu :LeaderfFunction<CR>
nnoremap <leader>fU :LeaderfFunctionAll<CR>
nnoremap <leader>f] :LeaderfBufTagAll<CR>
nnoremap <leader>fg :Leaderf! rg -e<Space>""<Left>
xnoremap <leader>fg :<C-u><C-r>=printf('Leaderf! rg -F -e %s', leaderf#Rg#visual())<CR>
nnoremap <leader>fG :LeaderfRgRecall<CR>
nmap <leader>fj <Plug>LeaderfRgBangCwordLiteralBoundary<CR>
xmap <leader>fj <Plug>LeaderfRgBangVisualLiteralNoBoundary<CR>
nnoremap <leader>fq :LeaderfQuickFix<CR>
nnoremap <leader>fl :LeaderfLocList<CR>
nnoremap <leader>fL :Leaderf rg -S<CR>
nnoremap <leader>fa :LeaderfCommand<CR>
nnoremap <leader>ft :LeaderfFiletype<CR>
nnoremap <leader>ff :LeaderfSelf<CR>
nnoremap <leader>fw :LeaderfWindow<CR>
nnoremap <leader>f/ :LeaderfLineAll<CR>
nnoremap <leader>fr :Leaderf registers<CR>
nnoremap <leader>fy :Leaderf yank<CR>
nnoremap <leader>fY :registers<CR>:normal! "P<Left>
nnoremap <leader>b :Lexplore<CR>
nnoremap <leader>n :let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/='\V'. substitute(escape(@x, '\'), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>u :MundoToggle<CR>
nnoremap <leader>v :Vista!!<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
xnoremap <leader>s "xy:%s/<C-r>x/<C-r>x/gc<Left><Left><Left>
nnoremap <leader>l :call <SID>PrintCurrVars(0, 0)<CR>
xnoremap <leader>l :<C-u>call <SID>PrintCurrVars(1, 0)<CR>
nnoremap <leader>L :call <SID>PrintCurrVars(0, 1)<CR>
xnoremap <leader>L :<C-u>call <SID>PrintCurrVars(1, 1)<CR>
nnoremap <leader>c :ContextPeek<CR>
nnoremap <leader>C :ContextToggleWindow<CR>
nnoremap <leader>tm :TableModeToggle<CR>
inoremap <leader>w <Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :wall<CR>
nnoremap <silent> <leader>q :call <SID>Quit(0, 0)<CR>
nnoremap <silent> <leader>x :call <SID>Quit(1, 0)<CR>
nnoremap <silent> <leader>X :call <SID>Quit(1, 1)<CR>
nnoremap <expr> yoq empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
nnoremap <expr> yol empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'
cnoremap <expr> <Tab> '/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'
cnoremap <expr> <S-Tab> '/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'
cnoremap <expr> <C-@> '/?' =~ getcmdtype() ? '.\{-}' : '<C-@>'
cnoremap <expr> <C-Space> '/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>'
cnoremap <expr> <BS> '/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>'
" }}}

" ====================== Autocmd ======================== {{{
augroup AutoCommands
  autocmd!
  autocmd BufLeave * call s:AutoSaveWinView()
  autocmd BufEnter * call s:AutoRestoreWinView()
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif  " restore last edit position
  autocmd BufWritePost $MYVIMRC ++nested source $MYVIMRC  " auto source vimrc on write, ++nested required by lightline
  autocmd FileType python syntax keyword pythonSelf self | highlight def link pythonSelf Special
  autocmd FileType make,go setlocal noexpandtab shiftwidth=4 softtabstop=4
  autocmd FileType * setlocal formatoptions=jql
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :bdelete<CR>
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>| nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
augroup END
" }}}

" ===================== Lazy load ======================= {{{
function! s:LoadAutoformat()
  let g:formatters_python = ['yapf']
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
  let g:VM_maps['Add Cursor At Pos'] = 'g<C-n>'
  let g:VM_maps['Case Setting'] = ''
  nmap <C-n> <Plug>(VM-Find-Under)
  xmap <C-n> <Plug>(VM-Find-Subword-Under)
  call plug#load('vim-visual-multi')
endfunction
function! s:LoadQuickUI(open_menu)
  nnoremap <CR> :call quickui#menu#open('normal')<CR>
  xnoremap <CR> :<C-u>call quickui#menu#open('visual')<CR>
  nnoremap <silent> K :call <SID>OpenQuickUIContextMenu()<CR>
  nnoremap <silent> <leader>tp :call quickui#terminal#open('zsh', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': ''})<CR>
  nnoremap <silent> <C-o> :let g:lf_selection_path = tempname() <bar> call quickui#terminal#open('sh -c "lf -last-dir-path=\"$HOME/.cache/lf_dir\" -selection-path='. shellescape(g:lf_selection_path). ' \"'. expand('%'). '\""', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': 'LFEditCallback'})<CR>
  let g:quickui_color_scheme = g:Theme < 0 ? 'papercol-dark' : 'papercol-light'
  let g:quickui_show_tip = 1
  let g:quickui_border_style = 2
  call plug#load('vim-quickui')
  call quickui#menu#switch('normal')
  call quickui#menu#reset()
  call quickui#menu#install('&Actions', [
        \ ['&Insert line', 'execute "normal! o\<Space>\<BS>\<Esc>55a=" | execute "Commentary"', 'Insert a dividing line'],
        \ ['Insert tim&e', "put=strftime('%x %X')", 'Insert MM/dd/yyyy hh:mm:ss tt'],
        \ ['--', ''],
        \ ['&Word count', 'call feedkeys("g\<C-g>")', 'Show document details'],
        \ ['&Trim spaces', 'keeppatterns %s/\s\+$//e | execute "normal! ``"', 'Remove trailing spaces'],
        \ ['Cou&nt occurrences', 'keeppatterns %s///gn | execute "normal! ``"', 'Count occurrences of current search pattern'],
        \ ['Search in &buffers', 'execute "cexpr [] | bufdo vimgrepadd //g %" | copen', 'Grep current search pattern in all buffers, add to quickfix'],
        \ ['Calculate line &=', 'let @x = getline(".")[max([0, matchend(getline("."), ".*=")]):] | execute "normal! A = \<C-r>=\<C-r>x\<CR>"', 'Calculate expression from previous "=" or current line'],
        \ ['&Diff unsaved', 'execute "diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype=". &filetype. " | read ++edit # | 0d_ | diffthis"', 'Diff current buffer with file on disk'],
        \ ['--', ''],
        \ ['Move tab left &-', '-tabmove'],
        \ ['Move tab right &+', '+tabmove'],
        \ ['Move buffer rightmost &>', 'call MoveBufferRight()', 'Wipe out current buffer and reopen, will lose temporary variables'],
        \ ['&Refresh screen', 'execute "nohlsearch | syntax sync fromstart | diffupdate | GitGutter | let @/=\"QWQ\" | normal! \<C-l>"', 'Clear search and refresh screen'],
        \ ['--', ''],
        \ ['Open WhichKe&y', 'WhichKey ";"', 'Show WhichKey for ;'],
        \ ['Open &Startify', 'Startify', 'Open vim-startify'],
        \ ['Save sessi&on', 'SSave!', 'Save as a new session using vim-startify'],
        \ ['Delete session', 'SDelete!', 'Delete a session using vim-startify'],
        \ ['--', ''],
        \ ['Edit Vimr&c', 'edit $MYVIMRC'],
        \ ['Open in &VSCode', "execute \"silent !code --goto '\" . expand(\"%\") . \":\" . line(\".\") . \":\" . col(\".\") . \"'\" | redraw!"],
        \ ])
  call quickui#menu#install('&Git', [
        \ ['Git &status', 'Git', 'Git status'],
        \ ['Git checko&ut file', 'Gread', 'Checkout current file and load as unsaved buffer'],
        \ ['Git &blame', 'Git blame', 'Git blame of current file'],
        \ ['Git &diff', 'Gdiffsplit', 'Diff current file with last staged version'],
        \ ['Git diff H&EAD', 'Gdiffsplit HEAD', 'Diff current file with last committed version'],
        \ ['Git &changes', 'Git! difftool', 'Load unstaged changes into quickfix list (use [q, ]q to navigate)'],
        \ ['Git &file history', 'call plug#load("vim-fugitive") | vsplit | 0Gclog', 'Browse previously committed versions of current file'],
        \ ['Git l&og', 'Git log --decorate --all --full-history', 'Show git logs (use <CR>/- to navigate)'],
        \ ['--', ''],
        \ ['Git search &all', 'call feedkeys(":Git log -p --all -S \"\"\<Left>", "n")', 'Search a string in all committed versions of files, flags: --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>'],
        \ ['Git gre&p all', 'call feedkeys(":Git log -p --all -i -G \"\"\<Left>", "n")', 'Search a regex in all committed versions of files, flags: --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>'],
        \ ['Git fi&nd files all', 'call feedkeys(":Git log --all --full-history --name-only -- \"**\"\<Left>\<Left>", "n")', 'Grep file names in all commits'],
        \ ['--', ''],
        \ ['Git open &remote', 'let temp = getcurpos() | call plug#load("vim-rhubarb") | call plug#load("vim-fugitive") | call setpos(".", temp) | .GBrowse', 'Open remote url in browser'],
        \ ])
  call quickui#menu#install('&Toggle', [
        \ ['Quick&fix             %{empty(filter(getwininfo(), "v:val.quickfix")) ? "[ ]" : "[x]"}', 'execute empty(filter(getwininfo(), "v:val.quickfix")) ? "copen" : "cclose"'],
        \ ['Location l&ist        %{empty(filter(getwininfo(), "v:val.loclist")) ? "[ ]" : "[x]"}', 'execute empty(filter(getwininfo(), "v:val.loclist")) ? "lopen" : "lclose"'],
        \ ['Set &diff             %{&diff ? "[x]" : "[ ]"}', 'execute &diff ? "windo diffoff" : "windo diffthis"', 'Toggle diff in current window'],
        \ ['Set scr&ollbind       %{&scrollbind ? "[x]" : "[ ]"}', 'execute &scrollbind ? "windo set noscrollbind" : "windo set scrollbind"', 'Toggle scrollbind in current window'],
        \ ['Set &wrap             %{&wrap ? "[x]" : "[ ]"}', 'set wrap!', 'Toggle wrap lines'],
        \ ['Set &paste            %{&paste ? "[x]" : "[ ]"}', 'execute &paste ? "set nopaste number mouse=a signcolumn=yes" : "set paste nonumber norelativenumber mouse= signcolumn=no"', 'Toggle paste mode (shift alt drag to select and copy)'],
        \ ['Set &spelling         %{&spell ? "[x]" : "[ ]"}', 'set spell!', 'Toggle spell checker (z= to auto correct current word)'],
        \ ['Set &virtualedit      %{&virtualedit=~#"all" ? "[x]" : "[ ]"}', 'execute &virtualedit=~#"all" ? "set virtualedit-=all" : "set virtualedit+=all"', 'Toggle virtualedit'],
        \ ['Set previ&ew          %{&completeopt=~"preview" ? "[x]" : "[ ]"}', 'execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"', 'Toggle function preview'],
        \ ['Set &cursorline       %{&cursorline ? "[x]" : "[ ]"}', 'set cursorline!', 'Toggle cursorline'],
        \ ['Set cursorcol&umn     %{&cursorcolumn ? "[x]" : "[ ]"}', 'set cursorcolumn!', 'Toggle cursorcolumn'],
        \ ['Set light &background %{&background=~"light" ? "[x]" : "[ ]"}', 'let &background = &background=="dark" ? "light" : "dark"', 'Toggle background color'],
        \ ['--', ''],
        \ ['Ne&trw', 'Lexplore', 'Toggle Vim Netrw'],
        \ ['&Markdown preview', 'execute "normal \<Plug>MarkdownPreviewToggle"', 'Toggle markdown preview'],
        \ ])
  call quickui#menu#install('Ta&bles', [
        \ ['Table &mode', 'TableModeToggle', 'Toggle TableMode'],
        \ ['&Reformat table', 'TableModeRealign', 'Reformat table'],
        \ ['&Format to table', 'Tableize', 'Format to table, use <leader>T to set delimiter'],
        \ ['&Delete row', 'execute "normal \<Plug>(table-mode-delete-row)"', 'Delete row'],
        \ ['Delete &column', 'execute "normal \<Plug>(table-mode-delete-column)"', 'Delete column'],
        \ ['Show cell &position', 'execute "normal \<Plug>(table-mode-echo-cell)"', 'Show cell index number'],
        \ ['--', ''],
        \ ['&Add formula', 'TableAddFormula', 'Add formula to current cell, i.e. Sum(r1,c1:r2,c2)'],
        \ ['&Evaluate formula', 'TableEvalFormulaLine', 'Evaluate formula'],
        \ ['--', ''],
        \ ['Align using = (delimiter fixed)', 'Tabularize /=\zs', 'Tabularize /=\zs'],
        \ ['Align using , (delimiter fixed)', 'Tabularize /,\zs', 'Tabularize /,\zs'],
        \ ['Align using # (delimiter fixed)', 'Tabularize /#\zs', 'Tabularize /#\zs'],
        \ ['Align using : (delimiter fixed)', 'Tabularize /:\zs', 'Tabularize /:\zs'],
        \ ['--', ''],
        \ ['Align using = (delimiter centered)', 'Tabularize /=', 'Tabularize /='],
        \ ['Align using , (delimiter centered)', 'Tabularize /,', 'Tabularize /,'],
        \ ['Align using # (delimiter centered)', 'Tabularize /#', 'Tabularize /#'],
        \ ['Align using : (delimiter centered)', 'Tabularize /:', 'Tabularize /:'],
        \ ])
  let l:quickui_theme_list = []
  let l:used_chars = 'hjklqg'
  let l:category = '(Dark) '
  for l:index in sort(keys(s:theme_list), 'N')
    if l:index == 0
      call reverse(l:quickui_theme_list)
      call add(l:quickui_theme_list, ['--', ''])
      let l:category = '(Light) '
    endif
    let l:hint_pos = match(s:theme_list[l:index], '\c[^'. l:used_chars. ']')
    let l:used_chars .= s:theme_list[l:index][l:hint_pos]
    call add(l:quickui_theme_list, [l:category. (l:hint_pos < 0 ? s:theme_list[l:index] : strcharpart(s:theme_list[l:index], 0, l:hint_pos). '&'. strcharpart(s:theme_list[l:index], l:hint_pos)), "execute 'call writefile([\"let g:Theme = ". l:index. '"], "'. substitute(fnamemodify(expand('$MYVIMRC'), ':p:h'), '\', '\\\\', 'g'). "/colors/current_theme.vim\")' | call LoadColorscheme(". l:index. ', 1)'])
  endfor
  call quickui#menu#install('&Colors', l:quickui_theme_list)
  call quickui#menu#switch('visual')
  call quickui#menu#reset()
  call quickui#menu#install('&Actions', [
        \ ['Surround with &space', "normal! gvc\<Space>\<C-r>\<C-p>\"\<Space>\<Esc>"],
        \ ["Surround with &''", "normal! gvc'\<C-r>\<C-p>\"'\<Esc>"],
        \ ['Surround with &""', "normal! gvc\"\<C-r>\<C-p>\"\"\<Esc>"],
        \ ['Surround with &()', "normal! gvc(\<C-r>\<C-p>\")\<Esc>"],
        \ ['Surround with &[]', "normal! gvc[\<C-r>\<C-p>\"]\<Esc>"],
        \ ['Surround with &{}', "normal! gvc{\<C-r>\<C-p>\"}\<Esc>"],
        \ ['--', ''],
        \ ['Open &WhichKey', 'WhichKeyVisual ";"', 'Show WhichKey for ;'],
        \ ['--', ''],
        \ ['OSC &yank', 'OSCYank', 'Use ANSI OSC52 sequence to copy from remote SSH sessions'],
        \ ])
  call quickui#menu#install('&Git', [
        \ ['Git &file history', "call plug#load('vim-fugitive') | vsplit | '<,'>Gclog", 'Browse previously committed versions of selected range'],
        \ ['Git l&og', "execute 'Git log -L' line(\"'<\"). ','. line(\"'>\"). ':'. expand('%')", 'Show git log of selected range'],
        \ ['--', ''],
        \ ['Git open &remote', "'<,'>GBrowse", 'Open remote url in browser'],
        \ ])
  call quickui#menu#install('Ta&bles', [
        \ ['Reformat table', "'<,'>TableModeRealign", 'Reformat table'],
        \ ['Format to table', "'<,'>Tableize", 'Format to table, use <leader>T to set delimiter'],
        \ ['--', ''],
        \ ['Align using = (delimiter fixed)', "'<,'>Tabularize /=\\zs", "'<,'>Tabularize /=\\zs"],
        \ ['Align using , (delimiter fixed)', "'<,'>Tabularize /,\\zs", "'<,'>Tabularize /,\\zs"],
        \ ['Align using # (delimiter fixed)', "'<,'>Tabularize /#\\zs", "'<,'>Tabularize /#\\zs"],
        \ ['Align using : (delimiter fixed)', "'<,'>Tabularize /:\\zs", "'<,'>Tabularize /:\\zs"],
        \ ['--', ''],
        \ ['Align using = (delimiter centered)', "'<,'>Tabularize /=", "'<,'>Tabularize /="],
        \ ['Align using , (delimiter centered)', "'<,'>Tabularize /,", "'<,'>Tabularize /,"],
        \ ['Align using # (delimiter centered)', "'<,'>Tabularize /#", "'<,'>Tabularize /#"],
        \ ['Align using : (delimiter centered)', "'<,'>Tabularize /:", "'<,'>Tabularize /:"],
        \ ['--', ''],
        \ ['Sort asc', "'<,'>sort", 'Sort in ascending order (sort)'],
        \ ['Sort desc', "'<,'>sort!", 'Sort in descending order (sort!)'],
        \ ['Sort num asc', "'<,'>sort n", 'Sort numerically in ascending order (sort n)'],
        \ ['Sort num desc', "'<,'>sort! n", 'Sort numerically in descending order (sort! n)'],
        \ ])
  if a:open_menu == 1
    call s:OpenQuickUIContextMenu()
  endif
endfunction
function! s:OpenQuickUIContextMenu()
  let l:quickui_content = []
  if s:Completion == 1
    call add(l:quickui_content, ['Docu&mentation', 'call CocAction("doHover")', 'Coc documentation'])
    call add(l:quickui_content, ['D&efinition', 'execute "normal \<Plug>(coc-definition)"', 'Coc definition'])
    call add(l:quickui_content, ['&Type definition', 'execute "normal \<Plug>(coc-type-definition)"', 'Coc type definition'])
    call add(l:quickui_content, ['&References', 'execute "normal \<Plug>(coc-references)"', 'Coc references'])
    call add(l:quickui_content, ['&Implementation', 'execute "normal \<Plug>(coc-implementation)"', 'Coc implementation'])
    call add(l:quickui_content, ['Re&name', 'execute "normal \<Plug>(coc-rename)"', 'Coc rename'])
    call add(l:quickui_content, ['&Fix', 'execute "normal \<Plug>(coc-fix-current)"', 'Coc fix'])
    call add(l:quickui_content, ['--', ''])
  endif
  call add(l:quickui_content, ['Git hunk &diff', 'GitGutterPreviewHunk', 'Git gutter preview hunk'])
  call add(l:quickui_content, ['Git hunk &undo', 'GitGutterUndoHunk', 'Git gutter undo hunk'])
  call add(l:quickui_content, ['Git hunk &add', 'GitGutterStageHunk', 'Git gutter stage hunk'])
  call add(l:quickui_content, ['Git fo&ld', 'GitGutterFold', 'Git gutter fold unchanged'])
  call add(l:quickui_content, ['Git &blame', "call setbufvar(winbufnr(popup_atcursor(systemlist('cd '. shellescape(fnamemodify(resolve(expand('%:p')), ':h')). ' && git log --no-merges -n 1 -L '. shellescape(line('v'). ','. line('.'). ':'. resolve(expand('%:p')))), { 'padding': [1,1,1,1], 'pos': 'botleft', 'wrap': 0 })), '&filetype', 'git')", 'Git blame of current line'])
  let l:current_styles = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  if match(l:current_styles, '^ConflictMarker') != -1
    call add(l:quickui_content, ['--', ''])
    if match(l:current_styles, '^ConflictMarker\(Begin\|Ours\)$') != -1
      call add(l:quickui_content, ['Git &conflict get', 'ConflictMarkerOurselves', 'Get change from ours'])
    elseif match(l:current_styles, '^ConflictMarker\(End\|Theirs\)$') != -1
      call add(l:quickui_content, ['Git &conflict get', 'ConflictMarkerThemselves', 'Get change from theirs'])
    endif
    call add(l:quickui_content, ['Git conflict get all', 'ConflictMarkerBoth', 'Get change from both'])
    call add(l:quickui_content, ['Git conflict remove', 'ConflictMarkerNone', 'Remove conflict'])
  endif
  call add(l:quickui_content, ['--', ''])
  call add(l:quickui_content, ['Built-in d&ocs', 'execute "normal! K"', 'Vim built in help'])
  call quickui#context#open(l:quickui_content, {'index': g:quickui#context#cursor})
endfunction
" }}}

" ====================== Functions ====================== {{{
function! CompleteWORD(findstart, base)
  if a:findstart
    return match(getline('.'), '\S\+\%'. col('.'). 'c')
  else
    let l:words = map(split(join(getline(1, '$'), "\n")), '{"word": v:val, "kind": "[WORD]"}')
    return len(a:base) ? matchfuzzy(l:words, a:base, {'key': 'word'}) : l:words
  endif
endfunction
function! MoveBufferRight() abort
  let l:buffer_name = expand('%:p')
  let l:pos = getcurpos()
  bwipeout
  execute 'edit '. l:buffer_name
  call setpos('.', l:pos)
  normal! zz
endfunction
function! GitGutterStatus() abort
  let [l:added, l:modified, l:removed] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction
function! LightlineTabs() abort
  return tabpagenr('$') > 1 ? reverse(lightline#tabs()) : ''
endfunction
function! LFEditCallback(code) abort
  if filereadable(g:lf_selection_path)
    for l:filename in readfile(g:lf_selection_path)
      execute 'edit '. l:filename
    endfor
    call delete(g:lf_selection_path)
  endif
endfunction
function! s:LfYankList(...)
  return split(execute('Yank'), '\n')[1:]
endfunction
function! s:LfYankAccept(line, args) abort
  let l:index = str2nr(a:line, 10)
  if l:index > 0
    call yoink#rotate(l:index)
  endif
  normal! p
endfunction
function! s:LfRegisters(...) abort
  return map(split(execute('registers'), '\n')[1:], 'substitute(v:val[6:], "\\^J", " ", "ge")')
endfunction
function! s:LfRegistersAccept(line, args) abort
  execute 'normal! "'. a:line[:0]. 'p'
endfunction
function! s:AutoSaveWinView()
  if !exists('w:SavedBufView')
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr('%')] = winsaveview()
endfunction
function! s:AutoRestoreWinView()
  let l:buf = bufnr('%')
  if exists('w:SavedBufView') && has_key(w:SavedBufView, l:buf)
    let l:view = winsaveview()
    if l:view.lnum == 1 && l:view.col == 0 && !&diff
      call winrestview(w:SavedBufView[l:buf])
    endif
    unlet w:SavedBufView[l:buf]
  endif
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
  let &operatorfunc = matchstr(expand('<sfile>'), '<SNR>\d\+_'). 'ActionOpfunc'
endfunction
function! s:MapAction(algorithm, key)
  execute 'nnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>ActionSetup("'. a:algorithm. '")<CR>g@'
  execute 'xnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>DoAction("'. a:algorithm. '", visualmode())<CR>'
  execute 'nnoremap <silent> <Plug>actionsLine'.a:algorithm.' :<C-U>call <SID>DoAction("'. a:algorithm. '", v:count1)<CR>'
  execute 'nmap '. a:key. '  <Plug>actions'. a:algorithm
  execute 'xmap '. a:key. '  <Plug>actions'. a:algorithm
  execute 'nmap '. a:key.a:key[strlen(a:key)-1]. ' <Plug>actionsLine'. a:algorithm
endfunction
function! s:EditRegister() abort
  let l:r = nr2char(getchar())
  call feedkeys('q:ilet @'. l:r. " = \<C-r>\<C-r>=string(@". l:r. ")\<CR>\<Esc>0f'", 'n')
endfunction
function! s:Quit(buffer_mode, force) abort
  if (a:buffer_mode == 1 || tabpagenr('$') == 1 && winnr('$') == 1) && len(getbufinfo({'buflisted':1})) > 1
    execute 'bprevious'
    if len(getbufinfo({'buflisted':1})) > 1
      try
        execute 'bdelete'. (a:force ? '!' : ''). ' #'
      catch
        execute 'bnext'
        throw 'Unsaved buffer'
      endtry
    endif
  else
    execute 'quit'. (a:force ? '!' : '')
  endif
endfunction
function! s:PrintCurrVars(visual, printAbove) abort
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
  let l:print['javascript'] = 'console.log('. join(map(copy(l:vars), "\"'\". v:val. \":', \". v:val"), ", '|', "). ');'
  let l:print['typescript'] = l:print['javascript']
  let l:print['typescriptreact'] = l:print['javascript']
  let l:print['java'] = 'System.out.println('. join(map(copy(l:vars), "'\"'. v:val. ': \" + '. v:val"), ' + " | " + '). ');'
  let l:print['vim'] = 'echomsg '. join(map(copy(l:vars), "\"'\". v:val. \": '. \". v:val"), ". ' | '. ")
  if has_key(l:print, &filetype)
    let l:pos = getcurpos()
    execute l:new_line
    call append(line('.'), l:print[&filetype])
    join
    call setpos('.', l:pos)
  endif
endfunction
function! s:GetRunCommand()
  if get(b:, 'RunCommand', '') != ''
    return b:RunCommand
  endif
  let l:run_command = {}
  let l:run_command['vim'] = 'source %'
  let l:run_command['python'] = 'AsyncRun python3 %'
  let l:run_command['c'] = 'AsyncRun gcc % -o %< -g && ./%<'
  let l:run_command['cpp'] = 'AsyncRun g++ % -o %< -g && ./%<'
  let l:run_command['java'] = 'AsyncRun javac % && java %<'
  let l:run_command['javascript'] = 'AsyncRun node %'
  let l:run_command['markdown'] = 'MarkdownPreview'
  let l:run_command['html'] = 'AsyncRun -silent open %'
  let l:run_command['xhtml'] = 'AsyncRun -silent open %'
  return get(l:run_command, &filetype, ''). get(b:, 'args', '')
endfunction
command! -complete=file -nargs=* SetRunCommand let b:RunCommand = <q-args>
command! -complete=file -nargs=* SetArgs let b:args = <q-args> == '' ? '' : ' '. <q-args>  " :SetArgs <args...><CR>, all execution will use args
command! -complete=shellcmd -nargs=* -range S execute 'botright new | setlocal filetype='. &filetype. ' buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | resize '. min([15, &lines * 2/5]). '| if <line1> < <line2> | put =getbufline('. bufnr(). ', <line1>, <line2>) | endif | read !'. <q-args> | 1d
command! -complete=command -nargs=* C execute "botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | put =execute('". <q-args>. "')"
command! W write !sudo tee %
" }}}

" =================== Other plugins ===================== {{{
let g:wordmotion_nomap = 1
let g:mw_no_mappings = 1  " vim-mark
let g:mwIgnoreCase = 0
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:context_enabled = 0
let g:context_max_height = 8
let g:startify_session_dir = '~/.cache/vim/sessions'
let g:startify_enable_special = 0
let g:startify_fortune_use_unicode = 1
let g:startify_commands = [
      \ { '!': ['Git modified', ':args `Git ls-files --modified` | Git difftool'] },
      \ { 'f': ['Find files', 'LeaderfFile'] },
      \ { 'm': ['Find MRU', 'LeaderfMru'] },
      \ { 'c': ['Edit vimrc', 'edit $MYVIMRC'] },
      \ { 's': ['Profile startup time', 'StartupTime'] },
      \ ]
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ ]
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline = { 'left': [['buffers']], 'right': [['close'], ['tabs']] }
let g:lightline.tab = { 'active': ['tabnum'], 'inactive': ['tabnum'] }
let g:lightline.active = { 'left': [['mode', 'paste', 'readonly'], ['absolutepath'], ['modified']], 'right': [['lineinfo'], ['colinfo'], ['gitgutter'], ['cocstatus']] }
let g:lightline.inactive = { 'left': [['absolutepath']], 'right': [['lineinfo']] }
let g:lightline.component = { 'lineinfo': '%l/%L', 'colinfo': '%{len(col(".")) == 1 ? " " : ""}%c' }
let g:lightline.component_function = { 'cocstatus': 'coc#status', 'gitgutter': 'GitGutterStatus' }
let g:lightline.component_expand = { 'buffers': 'lightline#bufferline#buffers', 'tabs': 'LightlineTabs' }
let g:lightline.component_type = { 'buffers': 'tabsel' }
let g:lightline.component_raw = { 'buffers': 1 }
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#enable_nerdfont = 1
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#clickable = 1
let g:lightline#bufferline#unnamed = ''
let g:asyncrun_open = 12
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_closers = 1
let g:vista_executive_for = { 'typescriptreact': 'coc' }
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:mundo_preview_bottom = 1
let g:mundo_width = 30
let g:yoinkIncludeDeleteOperations = 1
let g:yoinkMaxItems = 99
let g:highlightedyank_highlight_duration = 500
let g:netrw_dirhistmax = 0  " built in :Lexplore<CR> settings
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
set wildignore+=*/tmp/*,*/\.git/*,*/node_modules/*,*/venv/*,*/\.env/*  " do NOT wildignore plugged
let g:Lf_WildIgnore = { 'dir':['tmp','.git','plugged','node_modules','venv','.env','.local','.idea','*cache*'],'file':[] }
let g:Lf_MruWildIgnore = { 'dir':['tmp', '.git'], 'file':[] }
let g:Lf_RgConfig = ['--glob=!.git/*', '--hidden']
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_UseCache = 0
let g:Lf_MruMaxFiles = 1000
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
let g:Lf_FilerShowHiddenFiles = 1
let g:Lf_FilerShowPromptPath = 1
let g:Lf_FilerInsertMap = { '<C-v>': 'accept_vertical', '<Up>': 'up', '<Down>': 'down', '<CR>': 'open_current', '<Tab>': 'open_current', '<BS>': 'open_parent_or_backspace', '<C-u>': 'switch_normal_mode', '<C-n>': 'add_selections' }
let g:Lf_FilerNormalMap = { 'i': 'switch_insert_mode', '<Esc>': 'quit', '~': 'goto_root_marker_dir', 'M': 'mkdir', 'T': 'create_file' }
let g:Lf_Extensions = {
      \   'registers': {
      \     'source': string(function('s:LfRegisters'))[10:-3],
      \     'accept': string(function('s:LfRegistersAccept'))[10:-3],
      \   },
      \   'yank': {
      \     'source': string(function('s:LfYankList'))[10:-3],
      \     'accept': string(function('s:LfYankAccept'))[10:-3],
      \   },
      \ }
let g:gitgutter_map_keys = 0
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '░'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▒'
let g:conflict_marker_enable_mappings = 0
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'
let g:conflict_marker_highlight_group = ''
highlight ConflictMarkerBegin guibg=#427266
highlight ConflictMarkerOurs guibg=#364f49
highlight ConflictMarkerTheirs guibg=#3a4f67
highlight ConflictMarkerEnd guibg=#234a78
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoinsert = 1
let g:table_mode_tableize_map = ''
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
let g:table_mode_corner = '|'  " markdown compatible tablemode
let g:mkdp_auto_close = 0  " markdown-preview.nvim
let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'css', 'html', 'python', 'java', 'c', 'bash=sh']  " should work without plugins
" }}}

" ==================== Auto complete ==================== {{{
set completefunc=CompleteWORD
imap <expr> <CR> pumvisible() ? '<C-y>' : '<C-g>u<Plug>(PearTreeExpand)'
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
inoremap <expr> <Down> pumvisible() ? '<C-n>' : '<C-o>gj'
inoremap <expr> <Up> pumvisible() ? '<C-p>' : '<C-o>gk'
if s:Completion == 0  " custom fuzzy completion
  call fpc#init()
  imap <expr> <CR> pumvisible() ? fpc#accept() : '<C-g>u<Plug>(PearTreeExpand)'
elseif s:Completion == 1  " coc
  let g:coc_global_extensions = ['coc-marketplace', 'coc-explorer', 'coc-yank', 'coc-snippets', 'coc-highlight', 'coc-json', 'coc-vimlsp', 'coc-pyright', 'coc-tsserver', 'coc-prettier', 'coc-eslint', 'coc-html', 'coc-css', 'coc-emmet']
  " to manually install extensions, run :CocInstall coc-...
  " or run cd ~/.config/coc/extensions && yarn add coc-..., yarn cannot be cmdtest
  " in Windows run cd %LOCALAPPDATA%/coc/extensions && yarn add coc-...
  let g:coc_snippet_next = '<Tab>'
  let g:coc_snippet_prev = '<S-Tab>'
  inoremap <expr> <C-@> coc#refresh()
  inoremap <expr> <C-Space> coc#refresh()
  nnoremap <leader>b :CocCommand explorer<CR>
  imap <C-k> <Plug>(coc-snippets-expand)
  nmap <C-f> <Plug>(coc-format)
  xmap <C-f> <Plug>(coc-format-selected)
  nmap gr <Plug>(coc-references)
  nmap <silent> gh :call CocActionAsync('doHover')<CR>
  nmap <leader>d <Plug>(coc-definition)
  nmap <leader>R <Plug>(coc-rename)
  nmap <leader>a <Plug>(coc-codeaction-line)
  nmap <leader>A <Plug>(coc-codeaction)
  xmap <leader>a <Plug>(coc-codeaction-selected)
  nnoremap <leader>fa :CocList<CR>
  nnoremap <leader>fy :CocList yank<CR>
  nnoremap <leader>fA :LeaderfCommand<CR>
  nnoremap <leader>fo :CocList outline<CR>
  nmap [a <Plug>(coc-diagnostic-prev)
  nmap ]a <Plug>(coc-diagnostic-next)
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)
  command! -nargs=0 Tsc call CocAction('runCommand', 'tsserver.watchBuild') | copen
endif
" }}}

" ====================== Terminal ======================= {{{
nnoremap <C-b> :noautocmd execute 'Ttoggle resize='. min([15, &lines * 2/5])<CR>
nmap <leader>to <C-b>
nnoremap <leader>tt :noautocmd Ttoggle resize=999<CR>
nmap <leader>te <Plug>(neoterm-repl-send)
nmap <leader>tee <Plug>(neoterm-repl-send-line)
xmap <leader>te <Plug>(neoterm-repl-send)
nmap <leader>tp :call <SID>LoadQuickUI(0)<CR><leader>tp
tnoremap <C-u> <C-\><C-n>
set viminfo+=n~/.cache/vim/viminfo
set undodir=~/.cache/vim/undo
set cursorlineopt=number,screenline
set termwinkey=<C-s>
tnoremap <expr> <F2> tabpagenr('$') > 1 ? '<C-s>gT' : '<C-s>:bprevious<CR>'
tnoremap <expr> <F3> tabpagenr('$') > 1 ? '<C-s>gt' : '<C-s>:bnext<CR>'
tnoremap <silent> <C-h> <C-s>:TmuxNavigateLeft<CR>
tnoremap <silent> <C-j> <C-s>:TmuxNavigateDown<CR>
tnoremap <silent> <C-k> <C-s>:TmuxNavigateUp<CR>
tnoremap <silent> <C-l> <C-s>:TmuxNavigateRight<CR>
tnoremap <C-b> <C-s>:Ttoggle<CR>
" }}}

" ================== System specific ==================== {{{
if has('gui_running')
  let &t_SI = ''
  let &t_SR = ''
  let &t_EI = ''
  imap <C-Tab> <F3>
  imap <C-S-Tab> <F2>
  nmap <C-Tab> <F3>
  nmap <C-S-Tab> <F2>
  tmap <C-Tab> <F3>
  tmap <C-S-Tab> <F2>
  set guicursor+=a:blinkon0
  if &columns < 90 || &lines < 25
    set lines=25
    set columns=90
  endif
  if has('win32')  " Windows gVim
    " :set guifont=* :set guifont?  " manually run to pick font and get value
    set guifont=JetBrainsMono_NF:h10:cANSI
    set pythonthreedll=python38.dll  " set to python3x.dll for python3.x, python and vim x86/x64 versions need to match
    let g:gVimPath = substitute($VIMRUNTIME. '\gvim', '\', '\\\\', 'g'). ' '
    nnoremap <leader>W :silent execute '!sudo /c '. g:gVimPath. '"%:p"'<CR>
    nnoremap <leader><C-r> :silent execute '!'. g:gVimPath. '"%:p"' <bar> quit<CR>
  elseif has('gui_macvim')  " MacVim
    set guifont=JetBrainsMono\ Nerd\ Font:h14
    set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.9/Python
    set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.9
    if &columns < 115 || &lines < 32
      set lines=32
      set columns=115
    endif
  endif
elseif $SSH_CLIENT != ''  " ssh session
  function! s:CopyWithOSCYank(str)
    let @" = a:str
    OSCYankReg "
  endfunction
  call <SID>MapAction('CopyWithOSCYank', '<leader>y')
  nmap <leader>Y <leader>y$
elseif !has('macunix')  " WSL Vim
  function! s:CopyToWinClip(str)
    call system('clip.exe', a:str)
  endfunction
  call <SID>MapAction('CopyToWinClip', '<leader>y')
  nmap <leader>Y <leader>y$
endif
" }}}

" vim: foldmethod=marker foldlevel=99
