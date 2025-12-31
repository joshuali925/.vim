" =================== full vimrc ========================
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
set isfname-==
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
command! W write !sudo tee % > /dev/null
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
    set pythonthreedll=python38.dll  " set to python3x.dll for python3.x, python and vim x86/x64 versions need to match and vim should be downloaded from https://github.com/vim/vim-win32-installer/releases
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
" ==================== vimrc end ========================
{
  "coc.preferences.extensionUpdateCheck": "weekly",
  "coc.source.file.ignoreHidden": false,
  "suggest.completionItemKindLabels": {
    "class": "\uf0e8",
    "color": "\ue22b",
    "constant": "\uf8fe",
    "default": "\uf29c",
    "enum": "\uf435",
    "enumMember": "\uf02b",
    "event": "\ufacd",
    "field": "\uf93d",
    "file": "\uf723",
    "folder": "\uf115",
    "function": "\u0192",
    "interface": "\uf417",
    "keyword": "\uf1de",
    "method": "\uf6a6",
    "module": "\uf40d",
    "operator": "\uf915",
    "property": "\ue624",
    "reference": "\ufa46",
    "snippet": "\ue60b",
    "struct": "\ufb44",
    "text": "\ue612",
    "typeParameter": "\uf728",
    "unit": "\uf475",
    "value": "\uf89f",
    "variable": "\ue71b"
  },
  "diagnostic.errorSign": "\uf467",
  "diagnostic.warningSign": "\uf071",
  "diagnostic.infoSign": "\uf129",
  "diagnostic.hintSign": "\uf864",
  "diagnostic.virtualTextPrefix": " ❯❯❯ ",
  "diagnostic.virtualText": true,
  "diagnostic.virtualTextCurrentLineOnly": false,
  "yank.highlight.enable": false,
  "explorer.icon.enableNerdfont": true,
  "explorer.file.showHiddenFiles": true,
  "explorer.previewAction.onHover": false,
  "explorer.width": 23,
  "explorer.keyMappings.global": {
    "m": "actionMenu",
    "c": "copyFilepath",
    "y": "copyFile",
    "v": "open:vsplit"
  }
}
" =============== coc-settings.json =====================

" =======================================================
" sends commend to terminal
function! SendCommendToTerminal(command)
    let buff_n = term_list()
    if len(buff_n) > 0
        let buff_n = buff_n[0] " sends to most recently opened terminal
        call term_sendkeys(buff_n, a:command. "\<CR>")
    endif
endfunction

" =======================================================
" glutentags - too slow, tagfile too large
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.git', 'package.json']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
endif
let g:gutentags_cache_dir = expand('~/.cache/vim/tags')
let g:gutentags_ctags_extra_args = ['--fields=+niamlzS', '--extra=+q', '--c++-kinds=+px', '--c-kinds=+px', '--tag-relative=yes']
let g:gutentags_ctags_exclude = [ '*.git', '*.svg', '*.hg', '*/tests/*', 'build', 'dist', '*sites/*/files/*', 'bin', 'node_modules', 'plugged', 'bower_components', 'cache', 'compiled', 'docs', 'example', 'bundle', 'vendor', '*.md', '*-lock.json', '*.lock', '*bundle*.js', '*build*.js', '.*rc*', '*.json', '*.min.*', '*.map', '*.bak', '*.zip', '*.pyc', '*.class', '*.sln', '*.Master', '*.csproj', '*.tmp', '*.csproj.user', '*.cache', '*.pdb', 'tags*', 'cscope.*', '*.css', '*.less', '*.scss', '*.exe', '*.dll', '*.mp3', '*.ogg', '*.flac', '*.swp', '*.swo', '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2', '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', ]
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" =======================================================
" use <C-hjkl> instead
nnoremap <leader>h :call ToggleFileSplit()<CR>
" =================== Toggle split ======================
function! ToggleFileSplit()
    exec 'wincmd w'
    let b_name = bufname('%')
    while (b_name=~'NERD_tree' || b_name=~'NetrwTreeListing' || b_name=~'__Tagbar__' || b_name=~'!/bin/' || b_name=~'LeaderF' || getwinvar(0,'&syntax')=='qf' || &pvw)
        exec 'wincmd w'
        let b_name = bufname('%')
    endwhile
endfunction

" =======================================================
" too slow
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'solarized'

" =======================================================
" not useful
let g:ExecCommand = g:PythonPath. ' %'
nmap <leader>r :wall <bar> exec 'AsyncRun '. g:ExecCommand<CR>

" =======================================================
" use vim8 instead
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" =======================================================
" use mucomplete instead
function! SimpleComplete()
    if pumvisible()
        return "\<C-n>"
    endif
    let column = col('.')
    let line = getline('.')
    if !(column>1 && strpart(line, column-2, 3)=~'^\w')
        let pre_char = line[column-2]
        if pre_char == '.'
            return "\<C-x>\<C-o>\<C-p>"
        elseif pre_char == '/'
            return "\<C-x>\<C-f>\<C-p>"
        else
            return "\<TAB>"
        endif
    endif
    let substr = matchstr(strpart(line, -1, column+1), "[^ \t]*$")
    let has_slash = match(substr, '\/') != -1
    if has_slash
        return "\<C-x>\<C-f>"
    else
        return "\<C-n>"
    endif
endfunction
if g:Completion == 0  " default
    set omnifunc=syntaxcomplete#Complete
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : SimpleComplete()
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-d>"
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    imap <expr> <C-c> pumvisible() ? "\<C-y>\<C-c>" : "\<C-c>"

" =======================================================
" change to open term only
function! ToggleTerm()
    let term_winnr = bufwinnr('!/bin/bash')
    if term_winnr < 1
        let term_winnr = bufwinnr('!/bin/zsh')
    endif
    if term_winnr < 1
        let term_winnr = bufwinnr('!zsh')
    endif
    if term_winnr < 1
        exec 'botright new | set nonumber norelativenumber nocursorline nocursorcolumn | resize'. (winheight(0) * 2/5). ' | terminal ++curwin ++close'
    else
        exec '5wincmd j'
        let status = term_getstatus(bufnr('%'))
        if status == ''
            exec term_winnr. 'wincmd w'
            let status = term_getstatus(bufnr('%'))
        endif
        if status == 'running,normal'
            exec 'normal a'
        endif
    endif
endfunction

" =======================================================
" switch to vim-visual-multi
Plug 'terryma/vim-multiple-cursors', { 'on': [] }
nmap <C-n> :call LoadMultipleCursors()<CR><C-n>
xmap <C-n> :call LoadMultipleCursors()<CR>gv<C-n>
nmap <leader><C-n> :call LoadMultipleCursors()<CR><leader><C-n>
xmap <leader><C-n> :call LoadMultipleCursors()<CR>gv<leader><C-n>
function! LoadMultipleCursors()
    nnoremap <C-n> :call multiple_cursors#new("n", 1)<CR>
    xnoremap <C-n> :<C-u>call multiple_cursors#new("v", 0)<CR>
    nnoremap <leader><C-n> :call multiple_cursors#select_all("n", 1)<CR>
    xnoremap <leader><C-n> :<C-u>call multiple_cursors#select_all("v", 0)<CR>
    call plug#load('vim-multiple-cursors')
endfunction
let g:multi_cursor_select_all_word_key = '<leader><C-n>'

" =======================================================
" leaderf mappings
" <C-p>: 2<C-p>=mru, 2<C-f>=function, 4<C-p>=grep, type keyword and enter, 4<C-f>=grep current keyword
let g:Lf_NormalMap = { 'File': [['<C-p>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfMru<CR>'],
            \               ['<C-f>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfFunction<CR>']],
            \       'Mru': [['<C-p>', ':exec g:Lf_py "fileExplManager.quit()"<CR>:AsyncRun! grep -n -R  .<Left><Left>'],
            \               ['<C-f>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfFile<CR>']],
            \  'Function': [['<C-p>', ':exec g:Lf_py "fileExplManager.quit()" <bar> LeaderfFile<CR>'],
            \               ['<C-f>', ':exec g:Lf_py "fileExplManager.quit()"<CR>:AsyncRun! grep -n -R <cword> .<CR>']] }


" =======================================================
" non true colors
    set t_Co=256
    let g:solarized_termcolors = 256
    highlight link EasyMotionTarget Search
    highlight link EasyMotionShade Comment
    highlight link EasyMotionTarget2First Search
    highlight link EasyMotionTarget2Second Search

" =======================================================
" autodoc
Plug 'sillybun/vim-autodoc', { 'on': [] }
function! LoadRecordParameter()
    call plug#load('vim-autodoc')
    RecordParameter
endfunction
    call g:quickmenu#append('Record Python Parameter', 'call LoadRecordParameter()', '', 'python')

" =======================================================
" leaderf
let g:Lf_NormalMap = { 'File': [['u', ':LeaderfFile ..<CR>']]
            \        'Mru': [['<C-p>', ':exec g:Lf_py "mruExplManager.quit()" <bar> LeaderfRgInteractive<CR>'],
            \               ['<C-f>', ':exec g:Lf_py "mruExplManager.quit()" <bar> LeaderfFunctionAll<CR>']] }

" =======================================================
" ncm2 and deoplete
elseif g:Completion == 2
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'Shougo/deoplete.nvim'
    Plug 'Shougo/neco-syntax'
    Plug 'Shougo/neco-vim', { 'for': 'vim' }
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
elseif g:Completion == 3  " lazy load doesn't seem to work
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'ncm2/ncm2'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'Shougo/neco-syntax'
    Plug 'ncm2/ncm2-syntax'
    Plug 'ncm2/ncm2-ultisnips', { 'for': ['vim', 'c', 'cpp', 'java', 'python'] }
    Plug 'ncm2/ncm2-jedi', { 'for': 'python' }
let g:deoplete#sources#jedi#python_path=g:PythonPath
elseif g:Completion == 2  " deoplete
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-d>"
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? deoplete#close_popup() : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    let g:deoplete#enable_at_startup = 1
elseif g:Completion == 3  " ncm2
    set completeopt+=noinsert,noselect
    augroup ncm2
        autocmd!
        autocmd BufEnter * call ncm2#enable_for_buffer()
    augroup end
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
if has('win32')
    " for ncm2, doesn't work with any virtual env
    let g:python3_host_prog = 'C:\Users\Josh\Anaconda3\python.exe'

" =======================================================
" for execute code, use dictionary maybe faster
let g:DefaultCommand = ''
augroup Execute_Code
    autocmd!
    autocmd FileType * let b:args = ''
    autocmd FileType c let g:DefaultCommand = 'gcc % -o %< -g && ./%<'
    autocmd FileType cpp let g:DefaultCommand = 'g++ % -o %< -g && ./%<'
    autocmd FileType java let g:DefaultCommand = 'javac % && java %<'
    autocmd FileType python let g:DefaultCommand = g:PythonPath. ' %'
    autocmd FileType javascript let g:DefaultCommand = 'node %'
augroup END
function! GetRunCommand()
    return g:DefaultCommand. b:args
endfunction

" =======================================================
" vim plug seems faster even with less lazy load
" curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
" sh ./installer.sh ~/.vim/dein
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
call dein#begin('~/.vim/dein')
call dein#add('Shougo/dein.vim')
call dein#add('wsdjeg/dein-ui.vim', { 'on_cmd': 'DeinUpdate' })
call dein#add('ianding1/leetcode.vim', { 'on_cmd': 'LeetCodeList' })
call dein#add('skywind3000/quickmenu.vim')
call dein#add('scrooloose/nerdtree', { 'on_cmd': 'NERDTreeTabsToggle' })
call dein#add('jistr/vim-nerdtree-tabs', { 'on_cmd': 'NERDTreeTabsToggle' })
call dein#add('mbbill/undotree', { 'on_cmd': 'UndotreeToggle' })
call dein#add('godlygeek/tabular', { 'on_cmd': 'Tabularize' })
call dein#add('dhruvasagar/vim-table-mode', { 'on_cmd': 'TableModeToggle' })
call dein#add('majutsushi/tagbar', { 'on_cmd': 'TagbarToggle' })
call dein#add('skywind3000/asyncrun.vim', { 'on_cmd': 'AsyncRun' })
call dein#add('chiel92/vim-autoformat')
call dein#add('mg979/vim-visual-multi', { 'on_cmd': [] })
call dein#add('easymotion/vim-easymotion', { 'on_cmd': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-f)'] })
call dein#add('dahu/vim-fanfingtastic', { 'on_cmd': ['<Plug>fanfingtastic_f', '<Plug>fanfingtastic_t', '<Plug>fanfingtastic_F', '<Plug>fanfingtastic_T'] })
call dein#add('tpope/vim-fugitive', { 'on_cmd': ['Gstatus', 'Gdiff'] })
call dein#add('tpope/vim-commentary', { 'on_cmd': ['<Plug>Commentary', 'Commentary'] })
call dein#add('tpope/vim-surround', { 'on_cmd': ['<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround', '<Plug>VgSurround'] })
call dein#add('liuchengxu/vim-which-key', { 'on_cmd;': ['WhichKey', 'WhichKey!'] })
call dein#add('Yggdroot/LeaderF')
call dein#add('tpope/vim-repeat')
call dein#add('maxbrunsfeld/vim-yankstack')
call dein#add('jiangmiao/auto-pairs')
call dein#add('kana/vim-textobj-user')
call dein#add('rhysd/vim-textobj-anyblock')
call dein#add('sgur/vim-textobj-parameter')
call dein#add('shougo/echodoc.vim')
if g:Completion >= 0
    call dein#add( 'sirver/ultisnips')
    call dein#add( 'honza/vim-snippets')
    call dein#add( 'davidhalter/jedi-vim')
endif
if g:Completion == 0
    call dein#add('lifepillar/vim-mucomplete')
elseif g:Completion == 1
    call dein#add('valloric/youcompleteme')
elseif g:Completion == 2
    " :CocInstall coc-git coc-snippets coc-highlight coc-tsserver coc-html coc-css coc-emmet
    " if doesn't work, use cd ~/.config/coc/extensions && yarn add coc-...
    call dein#add('neoclide/coc.nvim', { 'rev': 'release' })
endif
call dein#end()
call dein#save_state()

" =======================================================
" lazy load on insert
augroup InsertLazyLoad
  autocmd!
  autocmd InsertEnter * call plug#load('echodoc.vim') | call plug#load('ultisnips') | call plug#load('vim-snippets') | autocmd! InsertLazyLoad
augroup END

" =======================================================
" ale, replaced by coc
Plug 'w0rp/ale'
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_flake8_options = '--ignore=W291,W293,W391,E261,E302,E305,E501'

" =======================================================
" leetcode, password incorrect error
Plug 'ianding1/leetcode.vim', { 'on': ['LeetCodeList', 'LeetCodeTest', 'LeetCodeSubmit'] }
let g:leetcode_solution_filetype = 'python3'
let g:leetcode_username = 'joshuali925'  " keyring password is 1

" =======================================================
" replaced by vim-sandwich
Plug 'wellle/targets.vim'
    autocmd User targets#mappings#user call targets#mappings#extend({'b': {'pair': [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}], 'quote': [{'d':"'"}, {'d':'"'}, {'d':'`'}]}})
Plug 'tpope/vim-surround', { 'on': ['<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround', '<Plug>VgSurround'] }
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

" =======================================================
" replaced by pear-tree
Plug 'Raimondi/delimitMate', { 'on': [] }
augroup LazyLoad
    autocmd!
    autocmd InsertEnter * call plug#load('delimitMate') | autocmd! LazyLoad
augroup END
let g:delimitMate_expand_space = 1
let g:delimitMate_balance_matchpairs = 1
let g:delimitMate_nesting_quotes = ['"', '`', "'"]
inoremap <expr> <CR> pumvisible() ? "\<Esc>a" : delimitMate#WithinEmptyPair() ? "\<CR>\<Esc>O\<Space>\<BS>" : "\<CR>\<Space>\<BS>"
" on YCM
    imap <silent> <BS> <C-r>=YcmOnDeleteChar()<CR><Plug>delimitMateBS

" =======================================================
" Windows python path bug
if has('win32')
    " this sets PYTHONHOME for vim (windows python bug), also needs to reset when entering virtual environments
    " 8/27/19 - seems to work without setting PYTHONHOME now
    " if $PYTHONHOME == ''
    "     let $PYTHONHOME = $LOCALAPPDATA. '/Programs/Python/Python37'
    " endif
    " Activate works for conda only, do NOT use for virtualenv
    function! ActivatePyEnv(environment)
        if a:environment == ''
            silent execute '!venv & '. g:gVimPath. expand('%:p')
        else
            " silent execute '!activate '. a:environment. ' & '. g:gVimPath. expand('%:p')
            silent execute '!activate '. a:environment. ' & '. g:gVimPath. expand('%:p'). ' -c "let $PYTHONHOME='''. $USERPROFILE. '/Anaconda3/envs/'. a:environment. '''"'
        endif
    endfunction
    command! -complete=shellcmd -nargs=* Activate call ActivatePyEnv(<q-args>) <bar> quit
endif

" =======================================================
" TagBar replaced by vista
" note vista doesn't work with exuberant ctags
" use tagbar instead if only has universal ctags
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
nnoremap <leader>ft :TagbarToggle<CR>
    call g:quickmenu#append('Tagbar', 'TagbarToggle', 'Toggle Tagbar')
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_width = 25
let g:tagbar_singleclick = 1
let g:tagbar_iconchars = [ '▸', '▾' ]

" =======================================================
" Quickmenu replaced by quickui, which needs vim >= 8.2
Plug 'skywind3000/quickmenu.vim', { 'on': [] }
vmap <F1> :<C-u>call LoadQuickmenu()<CR>gv<F1>
nmap <F1> :call LoadQuickmenu()<CR><F1>
function! LoadQuickmenu()
    nnoremap <F1> :call g:quickmenu#toggle(0) <bar> set showcmd<CR>
    vnoremap <F1> :<C-u>call g:quickmenu#toggle(3) <bar> set showcmd<CR>
    call plug#load('quickmenu.vim')
    let g:quickmenu_options = 'HL'
    call g:quickmenu#reset()
    call g:quickmenu#current(0)
    call g:quickmenu#header('QvQ')
    call g:quickmenu#append('# Actions', '')
    call g:quickmenu#append('Themes', 'call g:quickmenu#toggle(1)', 'Change vim colorscheme (let g:Theme = <index> must be the second line in $MYVIMRC)')
    call g:quickmenu#append('Insert Line', 'execute "normal! o\<Space>\<BS>\<Esc>55i=" | execute "Commentary"', 'Insert a dividing line')
    call g:quickmenu#append('Insert Time', "put=strftime('%x %X')", 'Insert MM/dd/yyyy hh:mm:ss tt')
    call g:quickmenu#append('Git Diff', 'Gdiffsplit', 'Fugitive git diff')
    call g:quickmenu#append('Git Status', 'Gstatus', 'Fugitive git status')
    call g:quickmenu#append('Word Count', 'call feedkeys("g\<C-g>")', 'Show document details')
    call g:quickmenu#append('Trim Spaces', 'keeppatterns %s/\s\+$//e | execute "normal! ``"', 'Remove trailing spaces')
    call g:quickmenu#append('Tabular Menu', 'call g:quickmenu#toggle(2)', 'Use Tabular to align selected text')
    call g:quickmenu#append('# Toggle', '')
    call g:quickmenu#append('NERDTree', 'NERDTreeTabsToggle', 'Toggle NERDTree')
    call g:quickmenu#append('Netrw', 'Lexplore', 'Toggle Vim Netrw')
    call g:quickmenu#append('Undo Tree', 'UndotreeToggle', 'Toggle Undotree')
    call g:quickmenu#append('Vista', 'Vista!!', 'Toggle Vista')
    call g:quickmenu#append('Table Mode', 'TableModeToggle', 'Toggle TableMode')
    call g:quickmenu#append('Markdown Preview', 'execute "normal \<Plug>MarkdownPreviewToggle"', 'Toggle markdown preview')
    call g:quickmenu#append('Diff %{&diff ? "[x]" :"[ ]"}', 'execute &diff ? "windo diffoff" : "windo diffthis"', 'Toggle diff in current window')
    call g:quickmenu#append('Fold %{&foldlevel ? "[ ]" :"[x]"}', 'execute &foldlevel ? "normal! zM" : "normal! zR"', 'Toggle fold by indent')
    call g:quickmenu#append('Wrap %{&wrap ? "[x]" :"[ ]"}', 'set wrap!', 'Toggle wrap lines')
    call g:quickmenu#append('Paste %{&paste ? "[x]" :"[ ]"}', 'execute &paste ? "set nopaste number mouse=nv signcolumn=auto" : "set paste nonumber norelativenumber mouse= signcolumn=no"', 'Toggle paste mode (shift alt drag to select and copy)')
    call g:quickmenu#append('Spelling %{&spell ? "[x]" :"[ ]"}', 'set spell!', 'Toggle spell checker (z= to auto correct current word)')
    call g:quickmenu#append('Preview %{&completeopt=~"preview" ? "[x]" :"[ ]"}', 'execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"', 'Toggle function preview')
    call g:quickmenu#append('Cursorline %{&cursorline ? "[x]" :"[ ]"}', 'set cursorline!', 'Toggle cursorline')
    call g:quickmenu#append('Cursorcolumn %{&cursorcolumn ? "[x]" :"[ ]"}', 'set cursorcolumn!', 'Toggle cursorcolumn')
    call g:quickmenu#append('Dark Theme %{&background=~"dark" ? "[x]" :"[ ]"}', 'let &background = &background=="dark" ? "light" : "dark"', 'Toggle background color')
    call g:quickmenu#current(1)
    call g:quickmenu#header('Themes')
    call g:quickmenu#append('# Dark', '')
    for index in sort(keys(s:theme_list))
        if index == 0
            call g:quickmenu#append('# Light', '')
        endif
        call g:quickmenu#append(s:theme_list[index], "execute 'silent !sed --in-place --follow-symlinks \"2 s/let g:Theme = .*/let g:Theme = ". index. '/" '. $MYVIMRC. "' | call LoadColorscheme(". index. ')')
    endfor
    call g:quickmenu#current(2)
    call g:quickmenu#header('Tabular Normal Mode')
    call g:quickmenu#append('# Fixed Delimiter', '')
    call g:quickmenu#append('Align Using =', 'Tabularize /=\zs', 'Tabularize /=\zs')
    call g:quickmenu#append('Align Using ,', 'Tabularize /,\zs', 'Tabularize /,\zs')
    call g:quickmenu#append('Align Using #', 'Tabularize /#\zs', 'Tabularize /#\zs')
    call g:quickmenu#append('Align Using :', 'Tabularize /:\zs', 'Tabularize /:\zs')
    call g:quickmenu#append('# Center Delimiter', '')
    call g:quickmenu#append('Align Using =', 'Tabularize /=', 'Tabularize /=')
    call g:quickmenu#append('Align Using ,', 'Tabularize /,', 'Tabularize /,')
    call g:quickmenu#append('Align Using #', 'Tabularize /#', 'Tabularize /#')
    call g:quickmenu#append('Align Using :', 'Tabularize /:', 'Tabularize /:')
    call g:quickmenu#current(3)
    call g:quickmenu#header('Tabular Visual Mode')
    call g:quickmenu#append('# Fixed Delimiter', '')
    call g:quickmenu#append('Align Using =', "'<,'>Tabularize /=\\zs", "'<,'>Tabularize /=\\zs")
    call g:quickmenu#append('Align Using ,', "'<,'>Tabularize /,\\zs", "'<,'>Tabularize /,\\zs")
    call g:quickmenu#append('Align Using #', "'<,'>Tabularize /#\\zs", "'<,'>Tabularize /#\\zs")
    call g:quickmenu#append('Align Using :', "'<,'>Tabularize /:\\zs", "'<,'>Tabularize /:\\zs")
    call g:quickmenu#append('# Center Delimiter', '')
    call g:quickmenu#append('Align Using =', "'<,'>Tabularize /=", "'<,'>Tabularize /=")
    call g:quickmenu#append('Align Using ,', "'<,'>Tabularize /,", "'<,'>Tabularize /,")
    call g:quickmenu#append('Align Using #', "'<,'>Tabularize /#", "'<,'>Tabularize /#")
    call g:quickmenu#append('Align Using :', "'<,'>Tabularize /:", "'<,'>Tabularize /:")
    call g:quickmenu#append('# Sort', '')
    call g:quickmenu#append('Sort Asc', "'<,'>sort", 'Sort in ascending order (sort)')
    call g:quickmenu#append('Sort Desc', "'<,'>sort!", 'Sort in descending order (sort!)')
    call g:quickmenu#append('Sort Num Asc', "'<,'>sort n", 'Sort numerically in ascending order (sort n)')
    call g:quickmenu#append('Sort Num Desc', "'<,'>sort! n", 'Sort numerically in descending order (sort! n)')
endfunction


" =======================================================
" use separate file to store g:Theme instead of modify vimrc with sed
        call add(l:quickui_theme_list, [l:background_color. s:theme_list[l:index], "execute 'silent !sed --in-place \"2 s/let s:Theme = .*/let s:Theme = ". l:index. '/" '. $MYVIMRC. "' | call LoadColorscheme(". l:index. ')'])  " set sed --follow-symlinks flag to redirect neovim init.vim symlink to vimrc (windows sed doesn't have --follow-symlinks)

" =======================================================
" use Coc instead of yankstack and nerdtree
Plug 'maxbrunsfeld/vim-yankstack'
silent! call yankstack#setup()
" for yankstack, do NOT use nnoremap for Y y$
nmap Y y$
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' }
nnoremap <C-b> :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 23
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" =======================================================
" from .zshrc - lazy load
autoload -U compinit && compinit -u  # for autocomplete
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
autoload -U +X bashcompinit && bashcompinit
zinit wait lucid for \
    hlissner/zsh-autopair \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    atload"FAST_HIGHLIGHT[chroma-git]='chroma/-ogit.ch'" \
    zdharma/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start; \
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'; \
    ZSH_AUTOSUGGEST_STRATEGY+=(history completion); \
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(up-line-or-beginning-search down-line-or-beginning-search); \
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1; \
    ZSH_AUTOSUGGEST_USE_ASYNC=1" \
    zsh-users/zsh-autosuggestions
alias zf='FZFTEMP=$(z --list | awk "{print \$2}" | fzf) && cd "$FZFTEMP" && unset FZFTEMP'
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%} "
zinit snippet OMZ::lib/key-bindings.zsh
zplugin ice ver'fe9fa652390c78859450838825a8b5c40e9921ef'  # use this commit if master doesn't work
zinit depth=1 light-mode for Aloxaf/fzf-tab  # load fzf-tab after fzf/completion.zsh
" zinit light-mode as"program" from"gh-r" for sbin dylanaraps/neofetch  # somehow only downloads v5.0.0

" =======================================================
" zinit binaries
" https://www.aloxaf.com/2019/11/zplugin_tutorial
zinit light zinit-zsh/z-a-bin-gem-node
zinit wait"2" lucid as"program" from"gh-r" for \
    mv"ripgrep* -> ripgrep" sbin"ripgrep/rg" BurntSushi/ripgrep \
    mv"fd* -> fd" sbin"fd/fd" @sharkdp/fd \
    mv"bat* -> bat" sbin"bat/bat" @sharkdp/bat \
    sbin junegunn/fzf-bin \
    sbin gokcehan/lf \
    mv"exa* -> exa" sbin ogham/exa
zinit ice mv="*.zsh -> _fzf" as="completion"
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/completion.zsh'
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
zinit ice as="completion"
zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd'
zinit ice as="completion"
zinit snippet 'https://github.com/BurntSushi/ripgrep/blob/master/complete/_rg'
" unused binaries
  # zinit light-mode as"program" from"gh-r" for sbin jesseduffield/lazydocker
  # zinit light-mode as"program" from"gh-r" for sbin so-fancy/diff-so-fancy
  # zinit light-mode as"program" from"gh-r" for sbin schollz/croc
  # zinit light-mode as"program" from"gh-r" for sbin"bin/exa" ogham/exa
  # zinit light-mode as"program" from"gh-r" for mv"jq* -> jq" sbin stedolan/jq
  # zinit light-mode as"program" from"gh-r" for mv"uni* -> uni" sbin arp242/uni
  # zinit light-mode as"program" from"gh-r" for sbin pemistahl/grex
  # zinit light-mode as"program" from"gh-r" for mv"up* -> up" sbin akavel/up
  # zinit light-mode as"program" from"gh-r" for sbin XAMPPRocky/tokei
  # zinit light-mode as"program" from"gh-r" for mv"dust* -> dust" sbin"dust/dust" bootandy/dust
  # zinit light-mode as"program" from"gh-r" for sbin muesli/duf
  # zinit light-mode as"program" from"gh-r" for mv"gdu* -> gdu" sbin dundee/gdu
  # zinit light-mode as"program" from"gh-r" for mv"hyperfine* -> hyperfine" sbin"hyperfine/hyperfine" @sharkdp/hyperfine
  # zinit light-mode as"program" from"gh-r" for mv"shellcheck* -> shellcheck" sbin"shellcheck/shellcheck" koalaman/shellcheck
install-from-github btm ClementTsang/bottom x86_64-unknown-linux-musl aarch64-unknown-linux x86_64-apple-darwin '' btm "$@"
install-from-github stylua JohnnyMorganz/StyLua linux '' macos '' '' "$@"
install-from-github shellcheck koalaman/shellcheck linux.x86_64 linux.aarch64 darwin.x86_64 '' '--strip-components=1 --wildcards shellcheck*/shellcheck' "$@"
install-from-github croc schollz/croc Linux-64bit.tar.gz Linux-ARM64.tar.gz macOS-64bit macOS-ARM64 croc "$@"
install-from-github dep-tree gabotechs/dep-tree linux_amd64 linux_arm64 darwin_amd64 darwin_arm64 dep-tree "$@"
install-from-github grex pemistahl/grex x86_64-unknown-linux-musl aarch64-unknown-linux-musl x86_64-apple-darwin aarch64-apple-darwin '' "$@"
install-from-github dust bootandy/dust x86_64-unknown-linux-musl aarch64-unknown-linux-musl x86_64-apple-darwin '' '--strip-components=1 --wildcards dust*/dust' "$@"
install-from-github up akavel/up up '' up-darwin '' '' "$@"
install-from-github imgcat danielgatis/imgcat Linux_x86_64 Linux_arm64 Darwin_x86_64 Darwin_arm64 imgcat "$@"
install-from-github markdown-preview yusukebe/gh-markdown-preview linux_amd64 linux_arm64 darwin_amd64 darwin_arm64 '' "$@"
install-from-url iterm-imgls https://iterm2.com/utilities/imgls "$@"
install-from-url git-quick-stats https://raw.githubusercontent.com/git-quick-stats/git-quick-stats/HEAD/git-quick-stats "$@"
install-from-url asn https://raw.githubusercontent.com/nitefood/asn/HEAD/asn "$@"
install-from-url ack https://beyondgrep.com/ack-v3.8.1 "$@"
alias l='eza -lF --git --color=always --color-scale=size --icons --header --group-directories-first --time-style=long-iso --all --smart-group'
install-from-github eza eza-community/eza x86_64-unknown-linux-musl.tar.gz aarch64-unknown-linux-gnu.tar.gz '' '' '' "$@"
alias ctop='docker run -e TERM=xterm-256color --rm -it --name ctop -v /var/run/docker.sock:/var/run/docker.sock:ro quay.io/vektorlab/ctop'  # doesn't support arm64
  # zinit light-mode as"program" from"gh-r" atclone"mv btm $ZPFX/bin" for ClementTsang/bottom
alias btm='btm --config=/dev/null --mem_as_value --process_command --color=gruvbox --basic'
    btm) sudo -E "$(/usr/bin/which btm)" --config=/dev/null --mem_as_value --process_command --color=gruvbox --basic "$@" ;;
croc() {
  local line phrase
  if [[ $# -eq 0 ]]; then
    command croc
  elif grep -q '^[0-9]\{4\}-[a-z]\+-[a-z]\+-[a-z]\+$' <<< "$1"; then
    command croc --curve p256 --yes "$@"
  elif [[ -e $1 ]] || [[ $1 = send ]]; then
    [[ $1 = send ]] && shift 1
    timeout 60 croc send "$@" 2>&1 | {
      while read -r line; do
        echo "$line"
        [[ -z $phrase ]] && phrase=$(grep -o '[0-9]\{4\}-[a-z]\+-[a-z]\+-[a-z]\+$' <<< "$line") && echo -n " command croc --curve p256 --yes $phrase" | y
      done
    }
  else
    command croc "$@"
  fi
}


" =======================================================
zinit light-mode for \
    OMZ::lib/directories.zsh \
    OMZ::lib/history.zsh \
    OMZ::lib/key-bindings.zsh
setopt hist_ignore_all_dups
setopt hist_save_no_dups

" =======================================================
" from bashrc
# alias f='a(){ find . -iname *$@*; }; a'
# alias cc='a(){ gcc $1.c -o $1 -g && ./$@; }; a'
function f {
    find . -iname \*$1\*;
}

" =======================================================
alias cdf="FZFTEMP=\$(rg --files | fzf) && cd \"\$(dirname \$FZFTEMP)\" && unset FZFTEMP"
alias vf="FZFTEMP=\$(rg --files | fzf) && vim \"\$FZFTEMP\" && unset FZFTEMP"

" =======================================================
" stop using word motion
Plug 'chaoren/vim-wordmotion'
" stop using vim-sandwich, switch back to surround
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap', { 'on': ['<Plug>(swap-'] }
xmap i <Plug>(textobj-sandwich-query-i)
xmap a <Plug>(textobj-sandwich-query-a)
omap i <Plug>(textobj-sandwich-query-i)
omap a <Plug>(textobj-sandwich-query-a)
xmap ib <Plug>(textobj-sandwich-auto-i)
xmap ab <Plug>(textobj-sandwich-auto-a)
omap ib <Plug>(textobj-sandwich-auto-i)
omap ab <Plug>(textobj-sandwich-auto-a)
xmap is <Plug>(textobj-sandwich-literal-query-i)
xmap as <Plug>(textobj-sandwich-literal-query-a)
omap is <Plug>(textobj-sandwich-literal-query-i)
omap as <Plug>(textobj-sandwich-literal-query-a)
omap ia <Plug>(swap-textobject-i)
xmap ia <Plug>(swap-textobject-i)
omap aa <Plug>(swap-textobject-a)
xmap aa <Plug>(swap-textobject-a)
nmap gs <Plug>(swap-interactive)
xmap gs <Plug>(swap-interactive)
xnoremap i< i<
xnoremap a< a<
onoremap i< i<
onoremap a< a<
xnoremap i> i>
xnoremap a> a>
onoremap i> i>
onoremap a> a>
xnoremap iw iw
xnoremap aw aw
onoremap iw iw
onoremap aw aw
xnoremap iW iW
xnoremap aW aW
onoremap iW iW
onoremap aW aW
xnoremap ip ip
xnoremap ap ap
onoremap ip ip
onoremap ap ap
" lazy load vim-sandwich doesn't work on first time
Plug 'machakann/vim-sandwich', { 'on': ['<Plug>(operator-sandwich-', '<Plug>(textobj-sandwich-'] }
" this doesn't work for y, d, c
Plug 'machakann/vim-sandwich', { 'on': [] }
nmap y :call <SID>LoadSandwich()<CR>y
nmap d :call <SID>LoadSandwich()<CR>d
nmap c :call <SID>LoadSandwich()<CR>c
xmap i :<C-u>call <SID>LoadSandwich()<CR>gvi
xmap a :<C-u>call <SID>LoadSandwich()<CR>gva
xmap S :<C-u>call <SID>LoadSandwich()<CR>gvS
function! s:LoadSandwich()
  nunmap y
  nunmap d
  nunmap c
  xunmap i
  xunmap a
  xunmap S
  call plug#load('vim-sandwich')
  runtime macros/sandwich/keymap/surround.vim
  " add custom mappings below
endfunction

" =======================================================
" replaced by MapAction
" send to vim terminal
  nnoremap <leader>te V:call <SID>SendToTerminal()<CR>$
  xnoremap <leader>te <Esc>:call <SID>SendToTerminal()<CR>
" wsl copy
  nmap <leader>y V<leader>y
  xnoremap <leader>y :<C-u>call system('clip.exe', <SID>GetVisualSelection())<CR>
" do not lazyload on insert to keep scroll position
  augroup LazyLoadCompletion
    autocmd!
    autocmd InsertEnter * call plug#load('echodoc.vim') | call plug#load('ultisnips') | call plug#load('vim-snippets') | autocmd! LazyLoadCompletion
  augroup END
Plug 'ap/vim-buftabline'
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap <F10> :wall <bar> execute '!clear && '. <SID>GetRunCommand()<CR>
nnoremap <F12> :wall <bar> call <SID>RunShellCommand(<SID>GetRunCommand())<CR>

" =======================================================
  " WSL vim
  " fix vim auto entering replace mode, but breaks unicode
  set ambiwidth=double

  " functions not in use
nnoremap <leader>tE :execute getline('.')<CR>``
function! s:GetVisualSelection()
  let [l:line_start, l:column_start] = getpos("'<")[1:2]
  let [l:line_end, l:column_end] = getpos("'>")[1:2]
  let l:lines = getline(l:line_start, l:line_end)
  if len(l:lines) == 0
    return ''
  endif
  let l:lines[-1] = l:lines[-1][: l:column_end - (&selection == 'inclusive' ? 1 : 2)]
  let l:lines[0] = l:lines[0][l:column_start - 1:]
  return join(l:lines, "\n")
endfunction

" =======================================================
" any-jump.vim
Plug 'pechorin/any-jump.vim', { 'on': ['AnyJump', 'AnyJumpVisual'] }
nnoremap <leader>fj :AnyJump<CR>
nnoremap <leader>fJ :AnyJumpLastResults<CR>
xnoremap <leader>fj :AnyJumpVisual<CR>
let g:any_jump_disable_default_keybindings = 1
let g:any_jump_search_prefered_engine = 'rg'

" =======================================================
" https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
  execute 'xnoremap i'. char. ' :<C-u>normal! T'. char. 'vt'. char. '<CR>'
  execute 'onoremap i'. char. ' :normal vi'. char. '<CR>'
  execute 'xnoremap a'. char. ' :<C-u>normal! F'. char. 'vf'. char. '<CR>'
  execute 'onoremap a'. char. ' :normal va'. char. '<CR>'
endfor
xnoremap <silent> in :<C-u>call <SID>VisualNumber()<CR>
onoremap <silent> in :normal vin<CR>
function! s:VisualNumber()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal! v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
  normal! o
endfunction

" =======================================================
set showbreak=↪\  " a trailing space after arrow
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
nnoremap cc cc<Space><BS>

" =======================================================
" lf cd on exit - not stable
push mmx
map w quit
map q push 'xw
map W $$SHELL
" common.sh
alias lf='lf -last-dir-path="$HOME/.cache/lf_dir" && [[ $PWD != $(cat "$HOME/.cache/lf_dir") ]] && cd "$(cat "$HOME/.cache/lf_dir")"'

" =======================================================
" nvim config
  let loaded_matchit = 1  " disable matchit
  " let g:python_host_prog = '/usr/bin/python2.7'
  " let g:python3_host_prog = '/usr/bin/python3.6'
  " let g:loaded_python_provider = 1
  " let g:loaded_python3_provider = 1

" =======================================================
" jedi and youcompleteme
if s:Completion >= 0
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }
  elseif s:Completion == 1
    Plug 'shougo/echodoc.vim'
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --ts-completer --java-completer' }
endif
  if s:Completion >= 0 && &filetype == 'python'
    call add(l:quickui_content, ['Jedi Do&cumentation', 'call jedi#show_documentation()', 'Jedi documentation'])
    call add(l:quickui_content, ['Jedi &Goto', 'call jedi#goto()', 'Jedi goto'])
    call add(l:quickui_content, ['Jedi Definition', 'call jedi#goto_definitions()', 'Jedi definition'])
    call add(l:quickui_content, ['Jedi Assignments', 'call jedi#goto_assignments()', 'Jedi assignments'])
    call add(l:quickui_content, ['Jedi Stubs', 'call jedi#goto_stubs()', 'Jedi stubs'])
    call add(l:quickui_content, ['Jedi Re&ferences', 'call jedi#usages()', 'Jedi references'])
    call add(l:quickui_content, ['Jedi Rena&me', 'call jedi#rename()', 'Jedi rename'])
    call add(l:quickui_content, ['--', ''])
  endif
  if s:Completion == 1
    call add(l:quickui_content, ['&Documentation', 'YcmCompleter GetDoc', 'YouCompleteMe documentation'])
    call add(l:quickui_content, ['D&efinition', 'YcmCompleter GoToDefinitionElseDeclaration', 'YouCompleteMe definition'])
    call add(l:quickui_content, ['&Type Definition', 'YcmCompleter GetType', 'YouCompleteMe type definition'])
    call add(l:quickui_content, ['&References', 'YcmCompleter GoToReferences', 'YouCompleteMe references'])
    call add(l:quickui_content, ['&Implementation', 'YcmCompleter GoToImplementation', 'YouCompleteMe implementation'])
    call add(l:quickui_content, ['&Fix', 'YcmCompleter FixIt', 'YouCompleteMe fix'])
    call add(l:quickui_content, ['&Organize Imports', 'YcmCompleter OrganizeImports', 'YouCompleteMe organize imports'])
    call add(l:quickui_content, ['--', ''])
" let g:ycm_path_to_python_interpreter=''  " for ycmd, don't modify
let g:ycm_python_binary_path=s:PythonPath  " for JediHTTP, comment out if venv doesn't work
let g:echodoc_enable_at_startup = 1
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = '2'
let g:jedi#documentation_command = '<leader>k'
let g:jedi#goto_command = '<leader>d'
let g:jedi#rename_command = '<leader>R'
let g:jedi#goto_stubs_command = ''
elseif s:Completion == 1  " YCM
  inoremap <expr> <C-e> pumvisible() ? "\<C-e>\<Esc>a" : "\<C-e>"
  nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
  nnoremap <leader>a :YcmCompleter FixIt<CR>
  " let g:ycm_show_diagnostics_ui = 0
  " let g:ycm_semantic_triggers = { 'c,cpp,python,java,javscript': ['re!\w{2}'] }  " auto semantic complete, can be slow
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_comments = 1
  let g:ycm_complete_in_strings = 1
  " for c include files, add to .ycm_extra_conf.py
  " '-isystem',
  " '/path/to/include'
  let g:ycm_global_ycm_extra_conf = '~/.vim/config/.ycm_extra_conf.py'
  let g:echodoc#enable_force_overwrite = 1

" =======================================================
" to find '~/.vim/config/.ycm_extra_conf.py' and fish configs, see commit before 22874af1f0031634770005b467b65e603e759b2d
ln -sr ~/.vim/config/fish ~/.config/fish
# fish
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt install -y fish

" =======================================================
" Windows gVim activate python virtualenv
    function! s:ActivatePyEnv(environment)
      if a:environment == ''
        silent execute '!venv & '. g:gVimPath. expand('%:p')
      else
        silent execute '!activate '. a:environment. ' & '. g:gVimPath. expand('%:p')
      endif
    endfunction
    command! -nargs=* Activate call <SID>ActivatePyEnv(<q-args>) <bar> quit

" =======================================================
function! FloatTermExit(code)
  setlocal number signcolumn=auto
endfunction
" quickmenu open float terminal, toggle markdown
        \ ['Open &Terminal', 'call quickui#terminal#open("zsh", {"h": winheight(0) * 3/4, "w": winwidth(0) * 4/5, "line": winheight(0) * 1/6, "callback": "FloatTermExit"})', 'Open terminal as popup window: <leader>tp'],
        \ ['&Markdown Preview', 'execute "normal \<Plug>MarkdownPreviewToggle"', 'Toggle markdown preview'],

" =======================================================
" doesn't work in neovim
function! s:LF()
    let l:temp = tempname()
    execute 'silent !lf -selection-path='. shellescape(l:temp). ' "'. expand('%:p'). '"'
    if !filereadable(l:temp)
        redraw!
        return
    endif
    for l:name in readfile(l:temp)
        execute 'edit ' . fnameescape(l:name)
    endfor
    redraw!
endfunction
nnoremap <C-p> :call <SID>LF()<CR>
" change ../plugged/vim-lf/autoload/lf.vim to have better terminal width/height
    let winid = popup_dialog(buf, #{minwidth: max([80, winwidth(0) * 4/5]), minheight: max([20, winheight(0) * 3/4]), highlight: 'Normal'})

" =======================================================
nnoremap <leader>l :nohlsearch <bar> syntax sync fromstart <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <leader>b :buffers<CR>:buffer<Space>
nnoremap <CR> :
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>

" =======================================================
" Shell command, use asyncrun/terminal instead, github copy remote
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

" =======================================================
" use quickui or surround
xnoremap " c"<C-r><C-p>""<Esc>
xnoremap ' c'<C-r><C-p>"'<Esc>
xnoremap ` c`<C-r><C-p>"`<Esc>
xnoremap ( c(<C-r><C-p>")<Esc>
xnoremap [ c[<C-r><C-p>"]<Esc>
xnoremap { c{<C-r><C-p>"}<Esc>
xnoremap <Space> c<Space><C-r><C-p>"<Space><Esc>
" use unimpaired.vim instead
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [t :tprevious<CR>
nnoremap ]t :tnext<CR>
nnoremap [T :tfirst<CR>
nnoremap ]T :tlast<CR>
nnoremap [e :move .-2<CR>==
nnoremap ]e :move .+1<CR>==
xnoremap [e :move '<-2<CR>gv=gv
xnoremap ]e :move '>+1<CR>gv=gv
nnoremap [<Space> O<Esc>
nnoremap ]<Space> o<Esc>
nnoremap [p O<C-r>"<Esc>
nnoremap ]p o<C-r>"<Esc>

" =======================================================
" sneak
Plug 'justinmk/vim-sneak', { 'on': '<Plug>Sneak_' }
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
map , <Plug>Sneak_;
map ;, <Plug>Sneak_,
map <F99> <Plug>Sneak_s<Plug>Sneak_S  " disable mapping for s
nnoremap <C-c> :nohlsearch <bar> silent! AsyncStop!<CR>:call sneak#cancel() <bar> echo<CR>

" =======================================================
" vem-tabline
Plug 'pacha/vem-tabline'
set statusline=%<[%{mode()}]\ %F\ %{&paste?'[paste]':''}%h%m%r%=%-14.(%c/%{len(getline('.'))}%)\ %l/%L\ %P
map <expr> <F2> tabpagenr('$') > 1 ? 'gT' : '<Plug>vem_prev_buffer-'
map <expr> <F3> tabpagenr('$') > 1 ? 'gt' : '<Plug>vem_next_buffer-'
map <BS> <Plug>vem_prev_buffer-
map \ <Plug>vem_next_buffer-
nnoremap <leader>1 :VemTablineGo 1<CR>
nnoremap <leader>2 :VemTablineGo 2<CR>
nnoremap <leader>3 :VemTablineGo 3<CR>
nnoremap <leader>4 :VemTablineGo 4<CR>
nnoremap <leader>5 :VemTablineGo 5<CR>
nnoremap <leader>6 :VemTablineGo 6<CR>
nnoremap <leader>7 :VemTablineGo 7<CR>
nnoremap <leader>8 :VemTablineGo 8<CR>
nnoremap <leader>9 :VemTablineGo 9<CR>
        \ ['&1. Move Buffer Left', 'call feedkeys("\<Plug>vem_move_buffer_left-", "")', 'Use vem-tabline to move buffer'],
        \ ['&2. Move Buffer Right', 'call feedkeys("\<Plug>vem_move_buffer_right-", "")', 'Use vem-tabline to move buffer'],
        \ ['&3. Move Tab Left', '-tabmove'],
        \ ['&4. Move Tab Right', '+tabmove'],
let g:vem_tabline_show_number = 'index'
let g:vem_tabline_show = 2
let g:vem_tabline_multiwindow_mode = 0
  tmap <expr> <F2> tabpagenr('$') > 1 ? '<C-\><C-n>gT' : '<C-\><C-n><Plug>vem_prev_buffer-'
  tmap <expr> <F3> tabpagenr('$') > 1 ? '<C-\><C-n>gt' : '<C-\><C-n><Plug>vem_next_buffer-'

" =======================================================
function! LightlineCurrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
let g:lightline.component_function = {
      \   'method': 'LightlineCurrFunction',
      \ }

" =======================================================
" javascript log prints object as string
  let l:print['javascript'] = 'console.log(`'. join(map(copy(l:vars), "v:val. ': ${'. v:val. '}'"), ' | '). '`);'

" =======================================================
" unused quickui
        \ ['Format as JSO&N', 'execute "update | %!python3 -m json.tool" | keeppatterns %s;^\(\s\+\);\=repeat(" ", len(submatch(0))/2);g | execute "normal! ``"', 'Use `python3 -m json.tool` to format current buffer'],
        \ ['Open &Buffers', 'call quickui#tools#list_buffer("e")'],
        \ ['Open &Functions', 'call quickui#tools#list_function()'],

" =======================================================
# <a-c> fzf cd all subdirectories
export FZF_ALT_C_COMMAND='fd --type=d'
export FZF_ALT_C_COMMAND="rg --files --null | xargs -0 dirname | awk '!h[\$0]++'"

" =======================================================
" tmux wsl copy
bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "clip.exe"
" tmux join panes to <session:window>
bind j command-prompt -p "send pane to window:" "join-pane -h -t :'%%'"

" =======================================================
" far.vim
Plug 'brooth/far.vim', { 'on': ['F', 'Far', 'Farr', 'Farf'] }
let g:far#default_file_mask = '**/*.*'  " **/*.* doesn't include filenames without dot, **/* doesn't respect .gitignore
let g:far#source = 'rg'
let g:far#enable_undo = 1

" =======================================================
" ycm doesn't need these now, also python2 is not used
let s:PythonPath = 'python3'
" let g:ycm_path_to_python_interpreter=''  " for ycmd, don't modify
" let g:ycm_python_binary_path=s:PythonPath  " for JediHTTP, comment out if venv doesn't work
" let g:ycm_semantic_triggers = { 'c,cpp,python,java,javscript': ['re!\w{2}'] }  " auto semantic complete, can be slow

" =======================================================
" coc-git replaced by gitgutter
  let g:coc_global_extensions = ['coc-git', ...]
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
let g:lightline.active = { 'left': [['mode', 'paste', 'readonly'], ['absolutepath'], ['modified']], 'right': [['lineinfo'], ['colinfo'], ['cocgit'], ['cocstatus']] }
let g:lightline.component = { 'lineinfo': '%l/%L', 'colinfo': '%{len(col(".")) == 1 ? " " : ""}%c', 'cocgit': '%{get(g:, "coc_git_status", "")}' }
    call add(l:quickui_content, ['--', ''])
    call add(l:quickui_content, ['Git hunk &diff', 'CocCommand git.chunkInfo', 'Coc git chunk info'])
    call add(l:quickui_content, ['Git hunk &undo', 'CocCommand git.chunkUndo', 'Coc git undo chunk'])
    call add(l:quickui_content, ['Git hunk &add', 'CocCommand git.chunkStage', 'Coc git stage chunk'])
    call add(l:quickui_content, ['Git &copy link', 'CocCommand git.copyUrl', 'Coc git copy remote url'])
" coc-settings.json
  "git.changedSign.text": "░",
  "git.addedSign.text": "▎",
  "git.removedSign.text": "▏",
  "git.topRemovedSign.text": "▔",
  "git.changeRemovedSign.text": "▒",

" =======================================================
" lgetbuffer doesn't work here
function! s:Scratch(...) range
  let l:bufnr = bufnr()
  let l:is_quickfix = getwininfo(win_getid())[0]['quickfix']  " quickfix or location list
  let l:is_loclist = getwininfo(win_getid())[0]['loclist']
  botright new
  execute 'resize '. min([15, &lines * 2/5])
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile errorformat=%f\|%l\ col\ %c\|%m
  if a:firstline < a:lastline
    put =getbufline(l:bufnr, a:firstline, a:lastline)
  endif
  if l:is_quickfix
    execute 'nnoremap <buffer> <leader>w :'. (l:is_loclist ? 'l' : 'c'). 'getbuffer<CR>'
    if a:firstline >= a:lastline
      put =getbufline(l:bufnr, 1, '$')
    endif
  endif
  execute 'read !'. join(a:000)
  1d
endfunction
command! -complete=shellcmd -nargs=* -range S <line1>,<line2>call s:Scratch(<q-args>)

" =======================================================
" include files in alt-c fzf
export FZF_ALT_C_COMMAND='ls -1dA */ 2> /dev/null'  # dir only
export FZF_ALT_C_COMMAND='ls -1A 2> /dev/null'  # include files
" use bat
alias man="LESS_TERMCAP_md=$'\e[01;31m' LESS_TERMCAP_me=$'\e[0m' LESS_TERMCAP_se=$'\e[0m' LESS_TERMCAP_so=$'\e[01;44;33m' LESS_TERMCAP_ue=$'\e[0m' LESS_TERMCAP_us=$'\e[01;32m' man"
export LESS_TERMCAP_mb=$'\E[1m\E[32m'
export LESS_TERMCAP_mh=$'\E[2m'
export LESS_TERMCAP_mr=$'\E[7m'
export LESS_TERMCAP_md=$'\E[1m\E[36m'
export LESS_TERMCAP_ZW=""
export LESS_TERMCAP_us=$'\E[4m\E[1m\E[37m'
export LESS_TERMCAP_me=$'\E(B\E[m'
export LESS_TERMCAP_ue=$'\E[24m\E(B\E[m'
export LESS_TERMCAP_ZO=""
export LESS_TERMCAP_ZN=""
export LESS_TERMCAP_se=$'\E[27m\E(B\E[m'
export LESS_TERMCAP_ZV=""
export LESS_TERMCAP_so=$'\E[1m\E[33m\E[44m'

" =======================================================
" auto virtualenv for bash
function cd { builtin cd $@ && ls -CF; }
function cd() {
    builtin cd $@
    ls -CF
    if [[ -z "$VIRTUAL_ENV" ]] ; then
        if [[ -f ./venv/bin/activate ]] ; then
            source ./venv/bin/activate
        fi
    else
        parentdir="$(dirname "$VIRTUAL_ENV")"
        if [[ "$PWD"/ != "$parentdir"/* ]] ; then
            deactivate
        fi
    fi
}

" =======================================================
nnoremap <leader>fs :vertical sfind \c*
xnoremap <leader>n "xy/\V<C-r>=substitute(escape(@x, '/\'), '\n', '\\n', 'g')<CR><CR>N
xnoremap <leader>n "xy:let @/='\V'. substitute(escape(@x, '\'), '\n', '\\n', 'g') <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/=substitute(escape(@x, "\\/.*'$^~[]"), '\n', '\\n', 'g') <bar> set hlsearch<CR>
let s:RelativeNumber = 0
  if s:RelativeNumber == 1
    set relativenumber
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave * set norelativenumber
  endif
        \ ['Set f&old             %{&foldlevel ? "[ ]" : "[x]"}', 'execute &foldlevel ? "normal! zM" : "normal! zR"', 'Toggle fold by indent'],

" =======================================================
" too slow, and doesn't work for vscode
Plug 'andymass/vim-matchup'
let g:matchup_matchparen_deferred = 1
let g:matchup_transmute_enabled = 1
let g:matchup_matchparen_offscreen = { 'method': '' }

" =======================================================
" coc-yank
nnoremap <leader>fy :CocList yank<CR>

" =======================================================
" use neoterm for terminal
if has('nvim')
  augroup NvimTerminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no | startinsert
    autocmd BufEnter term://* startinsert
  augroup END
  tnoremap <expr> <F2> tabpagenr('$') > 1 ? '<C-\><C-n>gT' : '<C-\><C-n>:bprevious<CR>'
  tnoremap <expr> <F3> tabpagenr('$') > 1 ? '<C-\><C-n>gt' : '<C-\><C-n>:bnext<CR>'
  tnoremap <C-u> <C-\><C-n>
  tnoremap <silent> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
  tnoremap <silent> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
  tnoremap <silent> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
  tnoremap <silent> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
  nnoremap <leader>to :execute 'split <bar> resize'. min([15, &lines * 2/5]). ' <bar> terminal'<CR>
  nnoremap <leader>tO :terminal<CR>
  nnoremap <leader>th :split <bar> terminal<CR>
  nnoremap <leader>tv :vsplit <bar> terminal<CR>
  nnoremap <leader>tt :tabedit <bar> terminal<CR>
  nmap <leader>tp :call <SID>LoadQuickUI(0)<CR><leader>tp
  function! s:SendToTerminal(str)
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
  set undodir=~/.cache/vim/undo
  set cursorlineopt=number,screenline
  augroup VimTerminal
    autocmd!
    autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no
  augroup END
  " do not tmap <Esc> in vim
  tnoremap <expr> <F2> tabpagenr('$') > 1 ? '<C-w>gT' : '<C-w>:bprevious<CR>'
  tnoremap <expr> <F3> tabpagenr('$') > 1 ? '<C-w>gt' : '<C-w>:bnext<CR>'
  tnoremap <C-u> <C-\><C-n>
  tnoremap <silent> <C-h> <C-w>:TmuxNavigateLeft<CR>
  tnoremap <silent> <C-j> <C-w>:TmuxNavigateDown<CR>
  tnoremap <silent> <C-k> <C-w>:TmuxNavigateUp<CR>
  tnoremap <silent> <C-l> <C-w>:TmuxNavigateRight<CR>
  nnoremap <leader>to :execute 'terminal ++close ++rows='. min([15, &lines * 2/5])<CR>
  nnoremap <leader>tO :terminal ++curwin ++noclose<CR>
  nnoremap <leader>th :terminal ++close<CR>
  nnoremap <leader>tv :vertical terminal ++close<CR>
  nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
  nmap <leader>tp :call <SID>LoadQuickUI(0)<CR><leader>tp
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
call <SID>MapAction('SendToTerminal', '<leader>te')

" =======================================================
" mucomplete
Plug 'lifepillar/vim-mucomplete'
set omnifunc=syntaxcomplete#Complete
inoremap <expr> <C-@> pumvisible() ? '<C-e><C-x><C-o><C-p>' : '<C-x><C-o><C-p>'
inoremap <expr> <C-Space> pumvisible() ? '<C-e><C-x><C-o><C-p>' : '<C-x><C-o><C-p>'
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#chains = {'default': ['path', 'ulti', 'keyn', 'omni', 'c-n', 'uspl']}

" =======================================================
" use fixjson for json
  if s:Completion != 1  " use astyle and python json.tool to format if not using coc
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :silent! update <bar> silent execute '!~/.vim/bin/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> edit! <bar> redraw!<CR>
    autocmd FileType json nnoremap <buffer> <C-f> :silent! update <bar> execute 'normal! mx' <bar> silent execute '%!python3 -m json.tool' <bar> keeppatterns %s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g <bar> redraw! <bar> execute 'normal! `xzz'<CR>
  endif

" =======================================================
" youcompleteme, ultisnips
  Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<TAB>'
let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
  elseif s:Completion == 2
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --ts-completer --java-completer' }

  elseif s:Completion == 2
    call add(l:quickui_content, ['Docu&mentation', 'YcmCompleter GetDoc', 'YouCompleteMe documentation'])
    call add(l:quickui_content, ['D&efinition', 'YcmCompleter GoToDefinitionElseDeclaration', 'YouCompleteMe definition'])
    call add(l:quickui_content, ['&Type definition', 'YcmCompleter GetType', 'YouCompleteMe type definition'])
    call add(l:quickui_content, ['&References', 'YcmCompleter GoToReferences', 'YouCompleteMe references'])
    call add(l:quickui_content, ['&Implementation', 'YcmCompleter GoToImplementation', 'YouCompleteMe implementation'])
    call add(l:quickui_content, ['&Fix', 'YcmCompleter FixIt', 'YouCompleteMe fix'])
    call add(l:quickui_content, ['&Organize imports', 'YcmCompleter OrganizeImports', 'YouCompleteMe organize imports'])

elseif s:Completion == 2  " YCM
  if exists('+completepopup')  " vim only
    set completeopt+=popup
    set completepopup=align:menu,border:off,highlight:WildMenu
  endif
  inoremap <expr> <C-e> pumvisible() ? '<C-e><Esc>a' : '<C-e>'
  nmap gh <Plug>(YCMHover)
  nnoremap gr :YcmCompleter GoToReferences<CR>
  nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
  nnoremap <leader>a :YcmCompleter FixIt<CR>
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_comments = 1
  let g:ycm_complete_in_strings = 1
  " for c include files, add to .ycm_extra_conf.py
  " '-isystem',
  " '/path/to/include'
  " copied from https://github.com/ycm-core/ycmd/blob/master/.ycm_extra_conf.py
  let g:ycm_global_ycm_extra_conf = '~/.vim/config/.ycm_extra_conf.py'

" =======================================================
" tmux bind gf to open filepath, gF to open filepath:line
bind -T copyModeMultiKey_g f if-shell -F '#{selection_active}' '' 'send-keys -X select-word' \; send-keys -X copy-pipe 'xargs -I{} tmux new-window "$EDITOR #{pane_current_path}/{}"'
bind -T copyModeMultiKey_g F if-shell -F '#{selection_active}' '' 'send-keys -X select-word' \; send-keys -X copy-pipe "awk -F: '{print \"$EDITOR #{pane_current_path}/\" $1 \" +\" $2 \" < /dev/tty\"}' | xargs -I{} tmux new-window {}"
" above two merged together by testing file existence
bind -T copyModeMultiKey_g f if-shell -F '#{selection_active}' '' 'send-keys -X select-word' \; send-keys -X copy-pipe "xargs -I{} sh -c \"test -f \\\"#{pane_current_path}/{}\\\" && tmux new-window \\\"$EDITOR #{pane_current_path}/{}\\\" || echo {} | awk -F: '{print \\\"$EDITOR #{pane_current_path}/\\\" \\\$1 \\\" +\\\" \\\$2 \\\" < /dev/tty\\\"}' | xargs -I{} tmux new-window {}\""
# replaced by this, doesn't work if filepath contains ':' but simpler
bind -T copyModeMultiKey_g f if-shell -F '#{selection_active}' '' 'send-keys -X select-word' \; send-keys -X copy-pipe "awk -F: '{line=($2==\"\")?\"\":\" +\"$2; print \"$EDITOR #{pane_current_path}/\" $1 line}' | xargs -I{} tmux new-window {}"
" tmux fingers, slow
set -g @plugin 'Morantron/tmux-fingers'       # <prefix>e
set -g @fingers-key e
set -g @fingers-main-action 'xargs tmux new-window -c "#{pane_current_path}" $EDITOR'

" =======================================================
" xargs changes current directory to home
vf() {
  local FZFTEMP
  if [ -z "$1" ]; then  # for xargs 2017 and later, use xargs -d '\n' -o $EDITOR
    FZFTEMP=$(rg --files | fzf --multi) && echo $FZFTEMP | xargs -d '\n' sh -c '$EDITOR "$@" < /dev/tty' $EDITOR
  else
    FZFTEMP=$(rg --files | rg "$@" | fzf --multi) && echo $FZFTEMP | xargs -d '\n' sh -c '$EDITOR "$@" < /dev/tty' $EDITOR
  fi
}

" =======================================================
" use vim expand region
Plug 'gcmt/wildfire.vim', { 'on': '<Plug>(wildfire-' }
map v <Plug>(wildfire-fuel)
let g:wildfire_objects = {
      \ '*' : ["i'", 'i"', 'i)', 'i]', 'i}', 'i`', 'ip', 'i>', 'ii', 'aI'],
      \ 'javascript,typescript,typescriptreact' : ["i'", 'i"', 'i)', 'i]', 'i}', 'i`', 'ip', 'at', 'aI'],
      \ 'python' : ["i'", 'i"', 'i)', 'i]', 'i}', 'i`', 'ip', 'ai', 'ii'],
      \ }

" =======================================================
" neovim doesn't need -inlcr
    STTY=-inlcr $EDITOR "$dir" < /dev/tty
  STTY=-inlcr lf -last-dir-path="$HOME/.cache/lf_dir" < /dev/tty

" =======================================================
" treesitter, use expand region and vim swap
        --[[ incremental_selection = {
            enable = true,
            keymaps = {
                node_incremental = "v",
                scope_incremental = "<leader>v",
                node_decremental = "<BS>"
            }
        }, ]]
                keymaps = {
                    -- @parameter.outer is not supported by most languages, use vim-swap for now
                    --[[ ['ia'] = '@parameter.inner',
                    ['aa'] = '@parameter.outer', ]]
                    ["if"] = "@function.inner",
                    ["af"] = "@function.outer",
                    ["ic"] = "@class.inner",
                    ["ac"] = "@class.outer"
                }
            --[[ swap = {
                -- enable = true,
                swap_previous = {
                    ['gsh'] = '@parameter.inner',
                },
                swap_next = {
                    ['gsl'] = '@parameter.inner',
                },
            }, ]]


" =======================================================
" using neoformat
    --[[ local function mapb(mode, lhs, rhs)
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
    end
    if client.resolved_capabilities.document_formatting then
        mapb('n', '<C-f>', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
    elseif client.resolved_capabilities.document_range_formatting then
        mapb('n', '<C-f>', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>')
    end ]]

" vim-sneak
            use {"justinmk/vim-sneak", fn = "sneak#*", keys = "<Plug>Sneak_"}
map("", "f", "<Plug>Sneak_f", {})
map("", "F", "<Plug>Sneak_F", {})
map("n", "t", "<Plug>Sneak_s", {})
map("n", "T", "<Plug>Sneak_S", {})
map("x", "t", "<Plug>Sneak_t", {})
map("x", "T", "<Plug>Sneak_T", {})
map("o", "t", "<Plug>Sneak_t", {})
map("o", "T", "<Plug>Sneak_T", {})
map("", ",", "<Plug>Sneak_;", {})
map("", ";,", "<Plug>Sneak_,", {})
map("", "n", "sneak#is_sneaking() ? '<Plug>Sneak_;' : 'n'", {expr = true})
map("", "N", "sneak#is_sneaking() ? '<Plug>Sneak_,' : 'N'", {expr = true})
" use vim.inspect
function M.dump(tbl, indent)
    if type(tbl) ~= "table" then
        print(tostring(tbl))
        return
    end
    if not indent then
        indent = 0
    end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            M.debug(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end


" =======================================================
" tmux theme
# # -- theme
# # panes
# # # set -g pane-border-status top
# set -g pane-border-format '#[align=right] #{?#{&&:#{pane_active},#{client_prefix}},#[underscore],}\
# #{pane_current_command}  #{pane_tty} #{?pane_active,❐ #S:#I/#{session_windows} ,}\
# #{?window_zoomed_flag,⬢,❄} #P '
# set -g pane-active-border-style '#{?pane_in_mode,fg=yellow,\
# #{?synchronize-panes,fg=cyan#,bold,#{?#{==:#{client_key_table},resize},fg=white,fg=blue#,bold}}}'
# set -g pane-border-style fg=magenta
# set -g pane-border-lines heavy
# set -g copy-mode-mark-style fg=black,bg=white,underscore
# set -g copy-mode-match-style fg=black,bg=cyan
# set -g copy-mode-current-match-style fg=black,bg=magenta,underscore
# # windows
# set -g status-justify left
# set -g status-right-length '80'
# set -g window-status-separator ''
# # statusbar
# set -g status-bg colour234
# set -g status-left ' #{?client_prefix,#[fg=brightyellow],#[fg=magenta]}❐ #S'
# set -g status-right '  #[fg=magenta] %a %m/%d %I:%M %p '
# set -g window-status-format ' #I #W '
# set -g window-status-current-format ' #I #W '
# set -g window-status-style fg=magenta
# set -g window-status-current-style fg=brightblue,bold
# set -g window-status-bell-style fg=yellow,bold

" =======================================================
# vim
sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt upgrade -y vim
# need to export after p10k instant prompt loads
echo "export \$EDITOR='vim'" >> ~/.zshrc
# zsh inscure directories fix:
compaudit | xargs chmod g-w
compaudit | sudo xargs chmod -R 755

" =======================================================
" tmux plugins
set -g @plugin 'laktak/extrakto'              # <prefix>f
set -g @extrakto_key 'f'
set -g @extrakto_split_size 12
set -g @extrakto_insert_key 'enter'
set -g @extrakto_copy_key 'tab'
set -g @extrakto_clip_tool_run 'fg'

" =======================================================
" somehow not needed for telescope extensions
    require("telescope").load_extension("gh")
    require("telescope").load_extension("yank")
opt.showbreak = '╰─➤ '

" =======================================================
" lazyload file type
g.did_load_filetypes = 1
    vim.cmd([[
        syntax enable
        unlet g:did_load_filetypes
        filetype on
        doautoall filetypedetect BufRead
    ]])

" =======================================================
" barbar too slow
            use {"romgrk/barbar.nvim", opt = false, config = get_config("barbar")}
function M.barbar()
    vim.cmd [[
    let bufferline = get(g:, 'bufferline', {})
    let bufferline.animation = v:false
    let bufferline.maximum_padding = 1
    let bufferline.no_name_title = ""
    ]]
end
map("n", "Z[", "<Cmd>BufferCloseBuffersLeft<CR>")
map("n", "Z]", "<Cmd>BufferCloseBuffersRight<CR>")
map("n", "<BS>", "<Cmd>BufferLineCyclePrev<CR>")
map("n", "\\", "<Cmd>BufferLineCycleNext<CR>")
map("n", "<C-w><BS>", "<Cmd>BufferLineMovePrev<CR><C-w>", {})
map("n", "<C-w>\\", "<Cmd>BufferLineMoveNext<CR><C-w>", {})
function! funcs#quit(buffer_mode, force) abort
  if (a:buffer_mode == 1 || tabpagenr('$') == 1 && winnr('$') == 1) && len(getbufinfo({'buflisted':1})) > 1
    if a:force == 1
      BufferClose!
    else
      BufferClose
    endif
  else
    execute 'quit'. (a:force ? '!' : '')
  endif
endfunction
    vim.cmd [[
    " for barbar
    highlight! link BufferVisible BufferInactive
    highlight! link BufferVisibleIndex BufferInactiveIndex
    highlight! link BufferVisibleMod BufferInactiveMod
    highlight! link BufferVisibleSign BufferInactiveSign
    highlight! link BufferVisibleTarget BufferInactiveTarget
    ]]

" =======================================================
" tmux gf binding use fzf query
bind -T copyModeMultiKey_semicolon f if-shell -F '#{selection_active}' '' 'send-keys -X select-word' \; send-keys -X pipe 'xargs basename | xargs -I {} tmux new-window -a -c "#{pane_current_path}" "rg --files | rg \"{}\" | fzf --multi --bind=\"enter:execute($EDITOR {+} < /dev/tty)+abort\""'

" =======================================================
" install.sh no need to packer compile
    sh -c 'sleep 20 && killall nvim && echo "Timeout, killed neovim"' &
    local pid2=$!
    ~/.local/bin/nvim +"lua vim.defer_fn(vim.fn['funcs#quitall'], 15000)" || true
    kill $pid1 $pid2 > /dev/null 2>&1 || true

" =======================================================
" normal and visual git log, use vim-flog instead
            {"Git l&og", [[Git log --decorate --all --full-history]], "Show git logs (use <CR>/- to navigate)"},
            {
                "Git l&og",
                [[execute 'Git log -L '. line("'<"). ','. line("'>"). ':'. expand('%')]],
                "Show git log of selected range"
            },

" =======================================================
" .zshrc
[[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE  # fix wsl bug
alias gbd='git branch -d'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gclean='git clean -fd'
alias gdw='git diff --word-diff'
alias gpoat='git push origin --all && git push origin --tags'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gfo='git fetch origin'
alias ggp='git push origin $(git symbolic-ref --short HEAD)'
alias ggl='git pull origin $(git symbolic-ref --short HEAD)'
alias glum='git pull upstream $(git symbolic-ref --short HEAD)'
alias ggsup='git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD)'
alias gpsup='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
cc() {
  gcc $1.c -o $1 -g && ./$@;
}
" install.sh
  pip3 install --user pynvim
  log "Installed pynvim for neovim"
" .bashrc, tab to fzf cd or complete (_check_tab_complete, _reset_tab) references
# https://stackoverflow.com/questions/994563/integrate-readlines-kill-ring-and-the-x11-clipboard
# https://stackoverflow.com/questions/4726695/bash-and-readline-tab-completion-in-a-user-input-loop
# https://unix.stackexchange.com/questions/52578/execute-a-readline-function-without-keybinding
# https://stackoverflow.com/questions/40417695/refreshing-bash-prompt-after-invocation-of-a-readline-bound-command \300\301 \365-\367 \370-\377 unused key code ranges
# https://github.com/rcaloras/bash-preexec/blob/master/bash-preexec.sh
# https://unix.stackexchange.com/questions/250713/modify-all-bash-commands-through-a-program-before-executing-them
(trap '_reset_tab' DEBUG) replaced by (PROMPT_COMMAND='_reset_tab')


" =======================================================
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = 'rounded'
  }
)
" lspsaga
        {"Docu&mentation", "lua require('lspsaga.provider').preview_definition()", "Preview definition with lspsaga"},
        {"&Select reference", "lua require('lspsaga.provider').lsp_finder()", "Jump to a reference with lspsaga"},
map("n", "<leader>d", "<Cmd>lua require('lspsaga.provider').lsp_finder()<CR>")
            use {
                -- "glepnir/zephyr-nvim",
                event = "VimEnter",
                config = function()
                    require("zephyr")
                end
            }
    " galaxyline for zephyr
    local colors = {
        bg = "#22262e",
        fg = "#abb2bf",
        green = "#B2CD8C",
        red = "#d47d85",
        lightbg = "#2d3139",
        lightbg2 = "#262a32",
        blue = "#659ECB",
        darkblue = "#46617a",
        yellow = "#E9C780",
        orange = "#EB9C6B",
        purple = "#B598E9",
        grey = "#6f737b"
    }
" cd root with lspconfig
    local cwd = require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p"))
    vim.cmd("cd " .. cwd)
" use oscyank.vim
nnoremap <leader>yy V:w !~/.vim/bin/oscyank<CR>
xnoremap <leader>y :w !~/.vim/bin/oscyank<CR>

" =======================================================
" zsh generate completion from help, use _gnu_generic (https://unix.stackexchange.com/questions/417054/automatically-generate-zsh-bash-completion-files)
zinit depth=1 wait"0" lucid light-mode for \
  atinit"GENCOMPL_FPATH=$HOME/.zinit/completions" \
  RobSis/zsh-completion-generator
zstyle ':plugin:zsh-completion-generator' programs fzf

" =======================================================
" lspsaga
            use {"tami5/lspsaga.nvim", module = "lspsaga", config = get_config("lspsaga")}
map("n", "<leader>d", "<Cmd>lua require('lspsaga.provider').preview_definition()<CR>")
map("n", "<leader>a", "<Cmd>lua require('lspsaga.codeaction').code_action()<CR>")
map("x", "<leader>a", ":<C-u>lua require('lspsaga.codeaction').range_code_action()<CR>")
map("n", "gh", "<Cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>")
map("n", "<leader>R", "<Cmd>lua require('lspsaga.rename').rename()<CR>")
map("n", "[a", "<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>")
map("n", "]a", "<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>")
        {"Docu&mentation", "lua require('lspsaga.hover').render_hover_doc()", "Show documentation with lspsaga"},
        {
            "Hover diagnostic",
            "lua require('lspsaga.diagnostic').show_line_diagnostics()",
            "Show diagnostic of current line with lspsaga"
        },
function M.lspsaga()
    require("lspsaga").init_lsp_saga {
        use_saga_diagnostic_sign = false,
        finder_action_keys = {
            open = "<CR>",
            vsplit = "s",
            split = "i",
            quit = {"<Esc>", "q"},
            scroll_down = "<NOP>",
            scroll_up = "<NOP>"
        },
        code_action_keys = {
            quit = {"<Esc>", "q"},
            exec = "<CR>"
        }
    }
end

" =======================================================
# download 64-bit gvim from https://github.com/vim/vim-win32-installer/releases/latest
# WSL specific
alias cmd='/mnt/c/Windows/System32/cmd.exe /k'
# `zsh` doesn't work
curl -fsSL https://raw.githubusercontent.com/joshuali925/.vim/HEAD/install.sh | bash -s --

" =======================================================
" lazyload filetype.vim https://github.com/joshuali925/.vim/tree/ff1ef83c290bfd61cc964a27f17d98ea57adcd3a
g.did_load_filetypes = 1
vim.cmd("syntax off")
        vim.defer_fn(
            function()
                -- https://github.com/kevinhwang91/dotfiles/blob/da97fbe354931d440b0ff12215de67a8233ce319/nvim/init.lua#L499
                vim.cmd("syntax enable")
                require("treesitter").init()
                vim.cmd [[
                    unlet g:did_load_filetypes
                    autocmd! syntaxset
                    autocmd syntaxset FileType * lua require('treesitter').hijack_synset()
                    filetype on
                    doautoall filetypedetect BufRead
                    augroup FormatOptions
                        autocmd!
                        autocmd FileType * setlocal formatoptions=jql
                    augroup END
                ]]
                loader("nvim-lspinstall lsp_signature.nvim")
            end,
            30
        )
    local present, treesitter = pcall(require, "nvim-treesitter.configs")
    if present then
        treesitter.setup(config)
        local parsers = config.ensure_installed
        local hl_disabled = config.highlight.disable
        for _, lang in ipairs(parsers) do
            if not vim.tbl_contains(hl_disabled, lang) then
                treesitter_hl_enabled[lang] = true
            end
        end
    end
function M.hijack_synset()
    local ft = vim.fn.expand("<amatch>")
    if not treesitter_hl_enabled[ft] then
        vim.opt.syntax = ft
    end
end

" =======================================================
" lsp-signature, persistent text issue
            use {
                "neovim/nvim-lspconfig",
                after = {"nvim-lsp-installer", "lsp_signature.nvim"},
            use {"ray-x/lsp_signature.nvim"}
local function on_attach(client, bufnr)
    require("lsp_signature").on_attach({hint_enable = false}, bufnr)

" =======================================================
" karabiner
"shell_command": "osascript -e 'tell app \"Terminal\" to do script \"$HOME/.local/bin/gvim\"' && sleep 1 && killall Terminal"

" =======================================================
# cron auto restore at reboot, env not complete sometimes breaks
# @reboot EDITOR=nvim SHELL=/usr/bin/zsh PATH=$HOME/.local/bin:$PATH tmux new-session -d " tmux run-shell $HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"

" =======================================================
" relativenumber
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if index(g:qs_filetype_blacklist, &ft) < 0 | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave * set norelativenumber
" line soft break
opt.showbreak = "╰─➤"
opt.cpoptions = opt.cpoptions + {n = true}
" autopairs, lsp breaks undo
            use {"Krasjet/auto.pairs", event = "InsertEnter", config = get_config("auto_pairs")}
function M.auto_pairs()
    g.AutoPairsShortcutToggle = ""
    g.AutoPairsShortcutFastWrap = "<C-l>"
    g.AutoPairsShortcutJump = ""
    g.AutoPairsShortcutBackInsert = ""
    g.AutoPairsMapCh = 0
    vim.fn.AutoPairsTryInit()
end
" .git root
    <Cmd>lua require('telescope.builtin').find_files({hidden = true, cwd = require('lspconfig.util').root_pattern('.git')(vim.fn.expand('%:p'))})<CR>

" =======================================================
" python packages
  python3 -m venv ~/.local/python-packages
  source ~/.local/python-packages/bin/activate && pip install bpytop && deactivate
  echo -e "color_theme=\"dracula\"\nshow_init=False" >> ~/.config/bpytop/bpytop.conf
  ln -s ~/.local/python-packages/bin/bpytop ~/.local/bin/bpytop
  curl -L -o- https://github.com/facebook/PathPicker/archive/main.tar.gz | tar xz -C ~/.local/lib/PathPicker --strip-components=1
  ln -srvf ~/.local/lib/PathPicker/fpp ~/.local/bin/fpp || ln -svf ~/.local/lib/PathPicker/fpp ~/.local/bin/fpp
  log "Installed bpytop, fpp"
alias fpp='if [[ -t 0 ]] && [[ $# -eq 0 ]] && [[ ! $(fc -ln -1) =~ "\| *fpp$" ]]; then eval "$(fc -ln -1 | sed "s/^rg /rg --vimgrep /")" | command fpp; else command fpp; fi'


" =======================================================
            use {
                "mhinz/vim-startify",
                cond = function()
                    return vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1
                end,
                config = get_config("startify")
            }
            {"Open &Startify", [[execute "PackerLoad! vim-startify" | Startify]], "Open vim-startify"},
            {
                "Save sessi&on",
                [[execute "PackerLoad! vim-startify" | SSave!]],
                "Save as a new session using vim-startify"
            },
            {"Delete session", [[execute "PackerLoad! vim-startify" | SDelete!]], "Delete a session using vim-startify"},
function M.startify()
    function _G.webDevIcons(path)
        local filename = vim.fn.fnamemodify(path, ":t")
        local extension = vim.fn.fnamemodify(path, ":e")
        return require("nvim-web-devicons").get_icon(filename, extension, {default = true})
    end
    vim.cmd [[
        function! StartifyEntryFormat() abort
            return 'v:lua.webDevIcons(absolute_path). " ". entry_path'
        endfunction
    ]]
    g.startify_session_dir = "~/.cache/nvim/sessions"
    g.startify_enable_special = 0
    g.startify_fortune_use_unicode = 1
    g.startify_commands = {
        {["!"] = {"Git diff unstaged", ":args `Git ls-files --modified` | Git difftool"}},
        {["+"] = {"Git diff HEAD", "DiffviewOpen"}},
        {
            ["*"] = {
                "Git diff remote",
                "execute 'DiffviewOpen '. trim(system('git rev-parse --abbrev-ref --symbolic-full-name @{u}')). '..HEAD'"
            }
        },
        {o = {"Git log", "Flog"}},
        {["\\"] = {"Open quickui", "call quickui#menu#open('normal')"}},
        {f = {"Find files", "lua require('telescope.builtin').find_files({hidden = true})"}},
        {m = {"Find MRU", "lua require('telescope.builtin').oldfiles({include_current_session = true})"}},
        {c = {"Edit vimrc", "edit $MYVIMRC"}},
        {s = {"Profile startup time", "StartupTime"}},
        {D = {"Delete session", "SDelete!"}}
    }
    g.startify_lists = {
        {type = "files", header = {"   MRU"}},
        {type = "dir", header = {"   MRU " .. vim.loop.cwd()}},
        {type = "commands", header = {"   Commands"}},
        {type = "sessions", header = {"   Sessions"}}
    }
end
            use {
                "max397574/better-escape.nvim",
                event = "InsertEnter",
                config = function()
                    require("better_escape").setup({mapping = {"jk", "kj"}})
                end
            }

" =======================================================
function! funcs#print_curr_vars(visual, printAbove) abort
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
  let l:print['lua'] = 'print('. join(map(copy(l:vars), "\"'\". v:val. \": ' .. \". v:val"), " .. ' | ' .. "). ')'
  if has_key(l:print, &filetype)
    let l:pos = getcurpos()
    execute l:new_line
    call append(line('.'), l:print[&filetype])
    join
    call setpos('.', l:pos)
  endif
endfunction
nnoremap <silent> <expr> <leader>y plugins#oscyank#OSCYankOperator('')
nmap <leader>yy V<leader>y
nmap <leader>Y <leader>y$
xnoremap <silent> <expr> <leader>y plugins#oscyank#OSCYankOperator('')

" =======================================================
" install all font family of JetBrainsMono Nerd Font
    font = wezterm.font_with_fallback({"JetBrains Mono", "JetBrainsMono Nerd Font", "JetBrainsMono NF"}),
    font_rules = {
        {
            italic = false,
            intensity = "Normal",
            font = wezterm.font_with_fallback({"JetBrainsMono Nerd Font", "JetBrainsMono NF"})
        }
    },

" =======================================================
" just use xargs
linedo() {
  if [ "$#" -eq 0 ]; then echo "Usage: <command> | $0 <command>, use {} as placeholder for each line, otherwise line is appended as args."; return 1; fi
  local placeholder
  [[ "$*" = *{}* ]] && placeholder=1
  while read -r line; do
    if [ -n "$placeholder" ]; then
      eval "${@//\{\}/$line}"
    else
      eval "$@" "$line"
    fi
  done
}
" get latest tag from github
curl -s https://github.com/neovim/neovim/releases/latest | sed 's#.*tag/\(.*\)\".*#\1#'

" =======================================================
" dap, buggy. maybe https://theosteiner.de/debugging-javascript-frameworks-in-neovim
        use({ "mfussenegger/nvim-dap", event = "VimEnter" })
        use({
            "rcarriga/nvim-dap-ui",
            after = "nvim-dap",
            config = function()
                require("dapui").setup()
            end,
        })
        use({
            "theHamsta/nvim-dap-virtual-text",
            after = "nvim-dap",
            config = function()
                require("nvim-dap-virtual-text").setup()
            end,
        })
" lsp.lua
    jdtls = {
        initializationOptions = {
            bundles = {
                -- https://repo1.maven.org/maven2/com/microsoft/java/com.microsoft.java.debug.plugin/0.34.0/com.microsoft.java.debug.plugin-0.34.0.jar
                vim.loop.os_homedir() .. "/.vim/com.microsoft.java.debug.plugin-0.34.0.jar",
            },
        },
    },
require("dap").configurations.java = {
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
    },
}
require("dap").adapters.java = function(callback, config)
    vim.lsp.buf_request(
        0,
        "workspace/executeCommand",
        { command = "vscode.java.startDebugSession" },
        function(err, ret, res)
            if ret ~= nil then
                callback({ type = "server", host = "127.0.0.1", port = ret })
            end
        end
    )
end
" project.nvim slow
        use({ "ahmedkhalf/project.nvim", opt = false, config = conf("project_nvim") })
function M.project_nvim()
    require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "gradlew", "Makefile", "package.json" },
    })
end
    require("telescope").load_extension("projects")
map("n", "<leader>fM", "<Cmd>lua require('telescope').extensions.projects.projects()<CR>")
" symbols-outline.nvim
        use({ "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", setup = conf("setup_symbols_outline") })
function M.setup_symbols_outline()
    vim.g.symbols_outline = {
        auto_preview = false,
        relative_width = false,
        width = 30,
        keymaps = { close = "q", hover_symbol = "p", rename_symbol = "R" },
    }
end
" nvim-tree
        use({ "kyazdani42/nvim-tree.lua", cmd = "NvimTreeToggle", config = conf("nvim_tree") })
map(
    "n",
    "<leader>b",
    [[<Cmd>if !get(g:, 'nvim_tree_indent_markers', 0) <bar> execute 'lua require("packer").loader("nvim-tree.lua")' <bar> sleep 100m <bar> endif <bar> NvimTreeFindFile<CR>]]
)
map("n", "<leader>B", "<Cmd>NvimTreeToggle<CR>")
function M.nvim_tree()
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_highlight_opened_files = 1
    local tree_cb = require("nvim-tree.config").nvim_tree_callback
    require("nvim-tree").setup({
        disable_netrw = false,
        diagnostics = { enable = true },
        view = {
            mappings = {
                list = {
                    { key = { "?" }, cb = tree_cb("toggle_help") },
                    { key = { "i" }, cb = tree_cb("toggle_ignored") },
                    { key = { "r" }, cb = tree_cb("refresh") },
                    { key = { "R" }, cb = tree_cb("rename") },
                    { key = { "x" }, cb = tree_cb("remove") },
                    { key = { "d" }, cb = tree_cb("cut") },
                    { key = { "y" }, cb = tree_cb("copy") },
                    { key = { "yy" }, cb = tree_cb("copy_absolute_path") },
                    { key = { "C" }, cb = tree_cb("cd") },
                    { key = { "s" }, cb = tree_cb("split") },
                    { key = { "h" }, cb = tree_cb("close_node") },
                    { key = { "l" }, cb = tree_cb("edit") },
                    { key = { "[g" }, cb = tree_cb("prev_git_item") },
                    { key = { "]g" }, cb = tree_cb("next_git_item") },
                    { key = { "q" }, cb = "<Cmd>execute 'NvimTreeResize '. winwidth(0) <bar> NvimTreeClose<CR>" },
                    { key = { "<Left>" }, cb = "<Cmd>normal! zh<CR>" },
                    { key = { "<Right>" }, cb = "<Cmd>normal! zl<CR>" },
                    { key = { "H" }, cb = "<Cmd>normal! H<CR>" },
                    { key = { "-" }, cb = "<Cmd>normal! $<CR>" },
                },
            },
        },
    })
end
" miniyank
" telescope plugin path: config/nvim/lua/telescope/_extensions/yank.lua
        use({
            "bfredl/nvim-miniyank",
            event = "TextYankPost",
            fn = "miniyank#*",
            keys = "<Plug>(miniyank-",
            config = "vim.g.miniyank_maxitems = 200",
        })
-- miniyank {{{2
map("", "p", "<Plug>(miniyank-autoput)", {})
map("", "P", "<Plug>(miniyank-autoPut)", {})
map("n", "<leader>p", "<Plug>(miniyank-cycle)", {})
map("x", "<leader>p", '"0p')
map("n", "<leader>P", "<Plug>(miniyank-cycleback)", {})
map("x", "<leader>P", '"0P')
map("n", "=v", "<Plug>(miniyank-tochar)", {})
map("n", "=V", "<Plug>(miniyank-toline)", {})
map("n", "=<C-v>", "<Plug>(miniyank-toblock)", {})
" treesitter-playground
        use({ "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" } })
" vim-matchup
        use({ "andymass/vim-matchup", config = conf("vim_matchup") })
function M.vim_matchup()
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_deferred_hide_delay = 300
    vim.g.matchup_motion_override_Npercent = 0
end
vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
    require("nvim-treesitter.configs").setup({
        matchup = { enable = true }, -- for vim-matchup
-- vim-matchup {{{2
vim.keymap.set("n", "<leader>c", "<Cmd>MatchupWhereAmI<CR>")

" =======================================================
" lsp highlight
"debounced
    local timer = vim.loop.new_timer()
        function _G.lsp_document_highlight()
            timer:start(
                50,
                0,
                vim.schedule_wrap(
                    function()
                        vim.cmd("silent! lua vim.lsp.buf.clear_references()")
                        vim.cmd("silent! lua vim.lsp.buf.document_highlight()")
                    end
                )
            )
        end
        vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorMoved <buffer> call v:lua.lsp_document_highlight()
                autocmd CursorMovedI <buffer> call v:lua.lsp_document_highlight()
            augroup END
        ]]
      " not debounced
        if client.resolved_capabilities.document_highlight then
            vim.cmd([[
                augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]])
        end

" =======================================================
" user commands and autocmds moved to init.lua
cnoreabbrev print <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'lua print(vim.inspect( ))' : 'print')<CR><C-r>=(getcmdtype() == ':' && getcmdline() == 'lua print(vim.inspect( ))' ? setcmdpos(23)[-1] : '')<CR>
command! -complete=file -nargs=* SetRunCommand let b:RunCommand = <q-args>
command! -complete=file -nargs=* SetArgs let b:args = <q-args> == '' ? '' : ' '. <q-args>
command! -complete=command -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr(). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | else | execute "put =execute('". <q-args>. "')" | endif | 1d
command! -bang W call mkdir(expand('%:p:h'), 'p') | if '<bang>' == '' | execute 'write !sudo tee % > /dev/null' | else | %yank | vnew | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | 0put='Enter password in terminal and press <lt>C-u>pa<lt>Esc>;w' | wincmd p | execute 'lua require("packer").loader("neoterm")' | execute "botright T sudo vim +'set paste' +'1,$d' +startinsert %" | endif
command! Grt execute 'lua require("packer").loader("vim-fugitive")' | Gcd
command! SessionSave mksession! ~/.cache/nvim/session.vim | lua vim.notify("Session saved to ~/.cache/nvim/session.vim")
command! SessionLoad source ~/.cache/nvim/session.vim | lua vim.notify("Loaded session from ~/.cache/nvim/session.vim")
command! -nargs=* GrepRegex lua require("telescope.builtin").grep_string({path_display = {"smart"}, use_regex = true, search = <q-args>, initial_mode = 'normal'})
command! -nargs=* GrepNoRegex lua require("telescope.builtin").grep_string({path_display = {"smart"}, search = <q-args>, initial_mode = 'normal'})
command! -complete=shellcmd -nargs=* -bang Untildone lua require("utils").untildone(<q-args>, "<bang>")
command! LspInstallAll lua require("lsp").lsp_install_all()
  autocmd BufReadPost * if !exists('b:RestoredCursor') && line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif | let b:RestoredCursor = 1
  autocmd BufWritePost */lua/plugins.lua source <afile> | PackerCompile
  autocmd User PackerCompileDone PackerInstall
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup = "IncSearch", timeout = 300})
  autocmd BufNewFile,BufRead *.http set filetype=http commentstring=#\ %s
  autocmd FileType * setlocal formatoptions=jql
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q <Cmd>call funcs#quit_netrw_and_dirs()<CR>| nmap <buffer> <leader>q q
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> silent! bdelete! <bar> copen<CR>| nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
  autocmd BufEnter term://* if line('$') <= line('w$') && len(filter(getline(line('.') + 1, '$'), 'v:val != ""')) == 0 | startinsert | endif
  autocmd BufEnter * lua require("rooter").root()
  autocmd User FugitiveIndex nmap <silent> <buffer> dt :Gtabedit <Plug><cfile><bar>Gdiffsplit! @<CR>
" https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
function! s:AutoSaveWinView()
  if !exists('w:SavedBufView')
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr()] = winsaveview()
endfunction
function! s:AutoRestoreWinView()
  let buf = bufnr()
  if exists('w:SavedBufView') && has_key(w:SavedBufView, buf)
    let view = winsaveview()
    if view.lnum == 1 && view.col == 0 && !&diff
      call winrestview(w:SavedBufView[buf])
    endif
    unlet w:SavedBufView[buf]
  endif
endfunction
augroup SavedBufView
  autocmd!
  autocmd BufLeave * call s:AutoSaveWinView()
  autocmd BufEnter * call s:AutoRestoreWinView()
augroup END

" =======================================================
" wilder.nvim
        use({ "gelguy/wilder.nvim", requires = { "romgrk/fzy-lua-native" }, event = "CmdlineEnter", config = conf("wilder_nvim") })
-- wilder.nvim {{{2
vim.keymap.set("c", "<Tab>", "'/?' =~ getcmdtype() ? '<C-g>' : wilder#in_context() ? wilder#next() : '<C-z>'", { expr = true }) -- <C-z> is 'wildcharm'
vim.keymap.set("c", "<S-Tab>", "'/?' =~ getcmdtype() ? '<C-t>' : wilder#in_context() ? wilder#previous() : '<S-Tab>'", { expr = true })
function M.wilder_nvim()
    -- https://github.com/gelguy/wilder.nvim/issues/52
    vim.cmd([[
        call wilder#setup({'modes': [':'], 'next_key': '<F13>', 'previous_key': '<F13>'})
        call wilder#set_option('use_python_remote_plugin', 0)
        call wilder#set_option('pipeline', [
                \     wilder#branch(
                \     wilder#cmdline_pipeline({ 'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter(), 'debounce': 50 }),
                \     ),
                \ ])
        call wilder#set_option('renderer', wilder#renderer_mux({
                \ ':': wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
                \     'border': 'rounded',
                \     'empty_message': 0,
                \     'highlighter': wilder#lua_fzy_highlighter(),
                \     'highlights': { 'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}]) },
                \     'winblend': 8,
                \     'left': [' ', wilder#popupmenu_devicons()],
                \     'right': [' ', wilder#popupmenu_scrollbar()],
                \     'apply_incsearch_fix': 0,
                \ })),
                \ 'substitute': 0
                \ }))
    ]])
end

" =======================================================
" broken by scrollview
vim.keymap.set("n", "yof", "winnr('$') > 1 ? '<Cmd>let g:temp = winsaveview() <bar> -tabedit %<CR><Cmd>call winrestview(g:temp) <bar> let b:is_zoomed = 1<CR>' : get(b:, 'is_zoomed', 0) ? '<Cmd>tabclose<CR>' : ''", { expr = true })
" nvim-ufo fold
    require("indent_blankline").setup({
        indent_blankline_char_priority = 20, -- https://github.com/kevinhwang91/nvim-ufo/issues/19
        use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async", wants = "promise-async", config = conf("nvim_ufo") })
function M.nvim_ufo()
    require("ufo").setup({ provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end })
end
vim.keymap.set("n", "K", function() if not require("ufo").peekFoldedLinesUnderCursor() then require("plugin-configs").open_quickui_context_menu() end end)

" =======================================================
" doesn't work for .class files opened in jar
    call setline(1, systemlist('java -jar ~/.local/lib/cfr.jar /dev/stdin', join(getline(1, '$'), "\n")))

" =======================================================
" nvm replaced by asdf
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
  NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
" yarn
  curl -o- -L https://yarnpkg.com/install.sh | bash
_load_nvm() {
  unset -f _load_nvm nvm npx node yarn
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}
nvm() { _load_nvm && nvm "$@"; }
npx() { _load_nvm && npx "$@"; }
node() { _load_nvm && node "$@"; }
yarn() { _load_nvm && yarn "$@"; }

" =======================================================
" neo-tree
        use({
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = "MunifTanjim/nui.nvim",
            wants = "nui.nvim",
            cmd = "Neotree",
            config = conf("neo_tree"),
        })
function M.neo_tree()
    local defaults = {
        ["h"] = "close_node",
        ["l"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["R"] = "rename",
        ["zM"] = "close_all_nodes",
        ["z"] = "none",
        ["H"] = "none",
        ["/"] = "none",
        ["r"] = function(state)
            local node = state.tree:get_node()
            require("neo-tree.sources.filesystem.commands").clear_filter(state)
            require("neo-tree.sources.buffers.commands").refresh()
            require("neo-tree.sources.filesystem").navigate(state, state.path, node:get_id())
        end,
        ["o"] = function(state)
            require("neo-tree.sources.common.commands").open(state)
            require("neo-tree").focus()
        end,
        ["q"] = function(state)
            require("neo-tree.ui.renderer").close(state)
        end,
        ["<Left>"] = function()
            vim.cmd("normal! zh")
        end,
        ["<Right>"] = function()
            vim.cmd("normal! zl")
        end,
    }
    local function with_default_mappings(custom)
        for k, v in pairs(defaults) do
            if not custom[k] then
                custom[k] = v
            end
        end
        return custom
    end

    local function focus(type)
        return function()
            require("neo-tree").focus(type)
        end
    end

    require("neo-tree").setup({
        renderers = { -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/348
            directory = {
                { "indent" },
                { "icon" },
                { "current_filter" },
                { "name" },
                { "clipboard" },
                { "diagnostics", errors_only = true },
            },
            file = {
                { "indent" },
                { "icon" },
                { "name", use_git_status_colors = true, zindex = 10 },
                { "clipboard" },
                { "bufnr" },
                { "modified" },
                { "diagnostics" },
                { "git_status" },
            },
        },
        default_component_configs = { icon = { default = "" }, modified = { symbol = "פֿ" } },
        filesystem = {
            search_limit = 500,
            filtered_items = { visible = true, hide_dotfiles = false, never_show = { ".git" } },
            window = {
                width = 35,
                mappings = with_default_mappings({
                    ["-"] = "navigate_up",
                    ["C"] = "set_root",
                    ["x"] = "delete",
                    ["y"] = "copy_to_clipboard",
                    ["d"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["f"] = "filter_on_submit",
                    ["t"] = "filter_as_you_type",
                    ["<BS>"] = focus("git_status"),
                    ["\\"] = focus("buffers"),
                }),
            },
        },
        buffers = {
            show_unloaded = true,
            window = {
                width = 35,
                mappings = with_default_mappings({ ["d"] = "buffer_delete", ["<BS>"] = focus("filesystem"), ["\\"] = focus("git_status") }),
            },
        },
        git_status = {
            window = {
                width = 35,
                mappings = with_default_mappings({ ["<BS>"] = focus("buffers"), ["\\"] = focus("filesystem") }),
            },
        },
        event_handlers = {
            {
                event = "vim_buffer_enter",
                handler = function(arg)
                    if vim.bo.filetype == "neo-tree" then
                        vim.wo.signcolumn = "no" -- hide instead of overriding highlights, neo-tree resets winhighlight on BufEnter
                    end
                end
            }
        }
    })
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { link = "NormalSB" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { link = "NormalSB" })
    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { link = "DiagnosticWarn" })
end

" =======================================================
" auto colors
local function get_color_fg(name, bg)
    return string.format("#%x", vim.api.nvim_get_hl_by_name(name, true)[bg or "foreground"])
end
local function get_color_bg(name)
    return string.format("#%x", vim.api.nvim_get_hl_by_name(name, true).background)
end
function M.colors()
    return {
        bg = get_color_bg("CursorLine"),
        fg = get_color_fg("ModeMsg"),
        lightbg = get_color_bg("Normal"),
        lightbg2 = get_color_bg("NormalNC"),
        primary = get_color_fg("Function"),
        secondary = get_color_fg("String"),
        dim_primary = get_color_bg("Visual"),
        red = get_color_fg("Identifier"),
        yellow = get_color_fg("Type"),
        orange = get_color_fg("Constant"),
        purple = get_color_fg("Statement"),
        grey = get_color_fg("LineNr"),
    }
    -- return themes[M.theme].colors and themes[M.theme].colors() or default_colors
end
    require("lualine").setup {
        options = {
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { function() return "" end },
            lualine_b = { { "filetype", colored = true, icon_only = true }, { "filename", path = 1 } },
            lualine_c = { function() return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " " end, "diff", "diagnostics" },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "branch" },
            lualine_z = { "location" }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {}
        },
        extensions = { "quickfix" }
    }

" =======================================================
" feline update on event
    local custom_providers = {
        c_mode = function()
            return " ", { str = "  ", hl = { fg = colors.lightbg, bg = mode_colors[vim.fn.mode()] or colors.primary } }
        end,
        c_file = function()
            local icon, color = require("nvim-web-devicons").get_icon_color(vim.fn.expand("%:t"), vim.fn.expand("%:e"))
            return " " .. vim.fn.expand("%:~:.") .. " ", { str = icon or " ", hl = { fg = color or colors.primary } }
        end,
        c_dir = function()
            return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
        end,
        c_pos = function()
            local col = vim.fn.col(".")
            return string.format(" %s/%s", vim.fn.line("."), vim.fn.line("$")), { str = (col < 10 and "  " or " ") .. col, hl = { fg = colors.secondary, bg = colors.lightbg } }
        end,
    }
    local components = { active = { {}, {}, {} }, inactive = { {}, {}, {} } }
    components.active[1][1] = {
        provider = { name = "c_mode", update = { "ModeChanged" } },
        hl = { fg = colors.fg, bg = colors.lightbg },
    }
    components.active[1][2] = {
        provider = { name = "c_file", update = { "BufEnter" } },
        hl = { fg = colors.fg, bg = colors.lightbg },
        right_sep = { str = " ", hl = { fg = colors.lightbg, bg = colors.lightbg2 } },
    }
    components.active[1][3] = {
        provider = { name = "c_dir", update = { "BufEnter", "DirChanged" } },
        hl = { fg = colors.grey, bg = colors.lightbg2 },
        right_sep = { str = " ", hi = { fg = colors.lightbg2 } },
    }
    components.active[3][6] = {
        provider = { name = "c_pos", update = { "CursorMoved", "CursorMovedI" } },
        hl = { fg = colors.primary, bg = colors.lightbg },

" =======================================================
" bash check file existence for :oldfiles MRU (<leader>fm)
| perl -ne 'chomp(); if (-e $_) {print "$_\n"}'
| xargs -L 1 ls -1 2>/dev/null
| while IFS= read -r file; do test -f "$file" && echo "$file"; done

" =======================================================
alias title='printf "$([ -n "$TMUX" ] && printf "\033Ptmux;\033")\e]0;%s\e\\$([ -n "$TMUX" ] && printf "\033\\")"'
alias quote="awk -v q=\"'\" 'BEGIN{ for (i=1; i<ARGC; i++) { gsub(q, q \"\\\\\" q q, ARGV[i]); printf \"%s \", q ARGV[i] q; } print \"\" }'"
export FZF_CTRL_T_COMMAND='rg --files'
alias rgf='rg --files | rg'
alias rgd='rg --files --null | xargs -0 dirname | sort -u | rg'
gvf() {
  local IFS=$'\n' FZFTEMP
  if [ -z "$1" ]; then
    FZFTEMP=($(git ls-files $(git rev-parse --show-toplevel) | fzf --multi))
  else
    FZFTEMP=($(git ls-files $(git rev-parse --show-toplevel) | rg "$@" | fzf --multi))
  fi
  [ -n "$FZFTEMP" ] && $EDITOR "${FZFTEMP[@]}"
}
tldr() {
  glow https://raw.githubusercontent.com/tldr-pages/tldr/master/pages/common/"$1".md
}
install-from-url tldr https://cht.sh/:cht.sh "$@"

" =======================================================
" doesn't work with gitignore
install_unison() {
  local releases url
  releases=$(curl -s "https://api.github.com/repos/bcpierce00/unison/releases/latest")
  # | grep "browser_download_url.*$package" | head -n 1 | cut -d '"' -f 4)
  if [ "$PLATFORM" == 'linux' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      url=$(grep "browser_download_url.*x86_64.linux.static.tar.gz" <<< "$releases" | tail -n 1 | cut -d '"' -f 4)
      curl -sL -o- "$url" | sudo tar xvz -C /usr/local/bin --strip-components=1 bin/unison bin/unison-fsmonitor
      log "Installed unison, unison-fsmonitor"
    else
      echo "architecture not supported, skipping.."
      return 0
    fi
  elif [ "$PLATFORM" == 'darwin' ]; then
    url=$(grep "browser_download_url.*x86_64.macos-" <<< "$releases" | tail -n 1 | cut -d '"' -f 4)
    curl -sL -o- "$url" | tar xvz -C ~/.local/bin --strip-components=1 bin/unison
    log "Installed unison, installing unison-fsmonitor, unison-gitignore.."
    git clone https://github.com/hnsl/unox ~/.local/lib/unison/unox --depth=1
    python3 -m venv ~/.local/lib/unison && source ~/.local/lib/unison/bin/activate
    pip install ~/.local/lib/unison/unox
    " maybe pip install git+https://github.com/hnsl/unox.git
    pip install unison-gitignore
    deactivate
    ln -sf ~/.local/lib/unison/bin/unison-fsmonitor ~/.local/bin/unison-fsmonitor
    ln -sf ~/.local/lib/unison/bin/unison-gitignore ~/.local/bin/unison-gitignore
    log "Installed unison-fsmonitor, unison-gitignore"
  else
    echo "Unknown distro.."
    return 0
  fi
}
" use asdf
install_java() {
  # https://raw.githubusercontent.com/shyiko/jabba/HEAD/index.json
  local jdk_version jdk_url
  if [ "$PLATFORM" == 'linux' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      jdk_url=https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz
      jdk_version=jdk-14.0.1
    else
      jdk_url=https://github.com/bell-sw/Liberica/releases/download/14.0.2+13/bellsoft-jdk14.0.2+13-linux-aarch64.tar.gz
      jdk_version=jdk-14.0.2
    fi
  elif [ "$PLATFORM" == 'darwin' ]; then
    if [ "$ARCHITECTURE" == 'x86_64' ]; then
      # brew tap AdoptOpenJDK/openjdk && brew install --cask adoptopenjdk14
      # echo "export JAVA_HOME=$(/usr/libexec/java_home)" >> ~/.zshrc
      # return 0
      jdk_url=https://cdn.azul.com/zulu/bin/zulu14.29.23-ca-jdk14.0.2-macosx_x64.tar.gz
      jdk_version=zulu14.29.23-ca-jdk14.0.2-macosx_x64
    else
      jdk_url=https://cdn.azul.com/zulu/bin/zulu15.36.13-ca-jdk15.0.5-macosx_aarch64.tar.gz
      jdk_version=zulu15.36.13-ca-jdk15.0.5-macosx_aarch64
    fi
  else
    echo "Unknown distro.."
    return 0
  fi
  curl -L -o- "$jdk_url" | tar -xz -C "$HOME/.local/lib"
  echo "export PATH=\$HOME/.local/lib/$jdk_version/bin:\$PATH" >> ~/.zshrc
  echo "export JAVA_HOME=\$HOME/.local/lib/$jdk_version" >> ~/.zshrc
  log "Installed $jdk_version, exported JAVA_HOME to ~/.zshrc, restart your shell"
  # export JAVA_HOME installed by asdf: echo "export JAVA_HOME=$(asdf where java)" >> ~/.zshrc
}
" install.sh install neovim plugins and treesitter
  # https://github.com/wbthomason/packer.nvim/issues/198#issuecomment-817426007
  timeout 120 ~/.local/bin/nvim --headless -u NORC --noplugin +'autocmd User PackerComplete quitall' +'silent lua require("plugins").sync()' || true
  timeout 120 ~/.local/bin/nvim --headless +'PackerLoad! nvim-treesitter mason.nvim' +'MasonInstall prettier' +'TSUpdateSync | quitall' || true
" 7z-bin install, use official 7z
source ~/.vim/bin/_install_from_github.sh
detect-env
[ "$PLATFORM" = 'darwin' ] && PLATFORM=mac
[ "$ARCHITECTURE" = 'x86_64' ] && ARCHITECTURE=x64
install-from-url 7z "https://github.com/develar/7zip-bin/raw/master/$PLATFORM/$ARCHITECTURE/7za" "$@"

" =======================================================
" lf shell doesn't support <<< and array
cmd zip ${{
  set -f
  selected=()
  while IFS= read -r filepath; do
    selected+=("$(realpath --relative-to='.' "$filepath")")
  done <<< "$fx"
  zip -r "${selected[0]}.zip" "${selected[@]}"
}}
" column on ansi escaped colors for aligning git log with filename (gls alias)
https://unix.stackexchange.com/questions/121107/a-shell-tool-to-tablify-input-data-containing-ansi-escape-codes/448471#448471
https://github.com/LukeSavefrogs/column_ansi
" =======================================================
" oscyank before tmux 3.3
buf=$(cat "$@")
buflen=$(printf %s "$buf" | wc -c)
maxlen=74994
while [ "$buflen" -gt 0 ]; do
  esc="\033]52;c;$(printf %s "$buf" | tail -c "$buflen" | head -c "$maxlen" | base64 | tr -d '\r\n')\a"
  if [ -n "$SSH_TTY" ]; then
    otty=$SSH_TTY
  elif [ -n "$TMUX" ]; then
    esc="\033Ptmux;\033$esc\033\\"
    otty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
  else
    otty=$TTY
    if [ -z "$otty" ]; then
      otty="/dev/$(ps -p $PPID -o tty=)"
    fi
    if [ -z "$otty" ]; then
      otty="/dev/tty"
    fi
  fi
  printf "$esc" > $otty
  ((buflen -= maxlen))
  if [ "$buflen" -gt 0 ]; then
    printf "input is %d bytes too long, needs %d more time" "$buflen" "$((buflen / maxlen + 1))" >&2
    read -p ', continue? (Y/n) ' -n 1 < $otty
    echo
    [[ ! $REPLY =~ ^[Yy]?$ ]] && break
  fi
done

" =======================================================
" all zinit binaries
  zinit depth=1 light-mode for zdharma-continuum/z-a-bin-gem-node
  zinit light-mode as"program" from"gh-r" for \
    mv"ripgrep* -> ripgrep" sbin"ripgrep/rg" BurntSushi/ripgrep \
    mv"fd* -> fd" sbin"fd/fd" @sharkdp/fd \
    mv"bat* -> bat" sbin"bat/bat" @sharkdp/bat \
    mv"delta* -> delta" sbin"delta/delta" dandavison/delta \
    sbin junegunn/fzf \
    sbin gokcehan/lf \
    sbin jesseduffield/lazygit

" =======================================================
" using lspsaga to replace native lsp actions
        use({ "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" })
vim.keymap.set("n", "<leader>a", "<Cmd>CodeActionMenu<CR>")
vim.keymap.set("x", "<leader>a", ":<C-u>CodeActionMenu<CR>")
vim.keymap.set("n", "gh", "<Cmd>lua if vim.diagnostic.open_float(0, {scope = 'cursor', border = 'single'}) == nil then vim.lsp.buf.hover() end<CR>")
vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename)
vim.keymap.set("n", "[a", "<Cmd>lua vim.diagnostic.goto_prev({float = {border = 'single'}})<CR>")
vim.keymap.set("n", "]a", "<Cmd>lua vim.diagnostic.goto_next({float = {border = 'single'}})<CR>")
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
        { "Docu&mentation", "lua vim.lsp.buf.hover()", "Show documentation" },
        { "&Signautre", "lua vim.lsp.buf.signature_help()", "Show function signature help" },
        { "Hover diagnostic", "lua vim.diagnostic.open_float(0, {scope = 'line', border = 'single'})", "Show diagnostic of current line" },
" aerial
        use({ "stevearc/aerial.nvim", cmd = "AerialToggle", config = conf("aerial_nvim") })
vim.keymap.set("n", "<leader>v", "<Cmd>AerialToggle<CR>")
        if packer_plugins["aerial.nvim"].loaded then
            require("aerial").on_attach(client, bufnr)
        else
            require("plugin-configs").aerial_nvim_save_callback(function() require("aerial").on_attach(client, bufnr) end)
        end
local aerial_callbacks = {}
function M.aerial_nvim_save_callback(callback)
    table.insert(aerial_callbacks, callback)
end
function M.aerial_nvim()
    require("aerial").setup({
        filter_kind = {
            "Class",
            "Constant",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },
    })
    for i, callback in ipairs(aerial_callbacks) do
        pcall(callback)
        aerial_callbacks[i] = nil
    end
end
" nvim-surround, css not correct, no repeats for visual
use({ "kylechui/nvim-surround", keys = { { "n", "y" }, { "n", "c" }, { "n", "d" }, { "x", "s" } }, config = conf("nvim_surround") })
function M.nvim_surround()
    require("nvim-surround").setup({
        keymaps = {
            normal_cur = "<NOP>",
            normal_line = "<NOP>",
            normal_cur_line = "ysl",
            visual = "s",
        },
    })
end
vim.keymap.set("n", "yss", "ysiw", { remap = true })
vim.keymap.set("n", "yS", "ysg_", { remap = true })
" vim-oscyank
        use({ "ojroques/vim-oscyank", cmd = { "OSCYank", "OSCYankReg" }, setup = "vim.g.oscyank_term = 'default'" })
        { "OSC yank (plugin)", [[OSCYank]], "Use OSCYank plugin to copy" },
function! funcs#map_copy_with_osc_yank()
  function! s:CopyWithOSCYank(str)
    let @" = a:str
    OSCYankReg "
  endfunction
  call <SID>MapAction('CopyWithOSCYank', '<leader>y')
  nmap <leader>Y <leader>y$
endfunction
    vim.fn["funcs#map_copy_with_osc_yank"]()
" neoterm
        use({ "kassio/neoterm", cmd = { "T", "Ttoggle", "Tnew" }, keys = "<Plug>(neoterm-repl-send", setup = conf("setup_neoterm") })
function M.setup_neoterm()
    vim.g.neoterm_default_mod = "belowright"
    vim.g.neoterm_automap_keys = ";tT"
    vim.g.neoterm_autoinsert = 1
    vim.g.neoterm_repl_command = {} -- bug?
end
vim.keymap.set("n", "<C-b>", "<Cmd>execute 'Ttoggle resize='. min([10, &lines * 2/5])<CR>")
vim.keymap.set("n", "<leader>to", "<Cmd>lua require('rooter').run_without_rooter('Ttoggle resize=' .. math.min(10, vim.o.lines))<CR>")
vim.keymap.set("n", "<leader>tt", "<Cmd>tab Tnew<CR>")
vim.keymap.set("n", "<leader>tO", "<Cmd>Tnew <bar> only<CR>")
vim.keymap.set("n", "<leader>t<C-l>", "<Cmd>Tclear!<CR>")
vim.keymap.set("n", "<leader>te", "<Plug>(neoterm-repl-send)")
vim.keymap.set("n", "<leader>tee", "<Plug>(neoterm-repl-send-line)")
vim.keymap.set("x", "<leader>te", "<Plug>(neoterm-repl-send)")
vim.keymap.set("t", "<C-u>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-b>", "<Cmd>Ttoggle<CR>")
  let context = '"'. desc_match. ' '. it_match. '"'
  return escape(context, '<>')  " funcs#jest_context()
  if expand('%') =~ '\.test\.[tj]sx\?'
    if !exists('g:neoterm')
      lua require('packer').loader('neoterm')
    endif
    return 'vertical T yarn test '. expand('%'). ' -t '. funcs#jest_context(). ' --coverage -u'
  endif
vim.keymap.set("n", "<leader>tp", [[<Cmd>call quickui#terminal#open('zsh', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': ''})<CR>]])
vim.keymap.set("n", "<C-o>", [[<Cmd>let g:lf_selection_path = tempname() <bar> call quickui#terminal#open('lf -last-dir-path="$HOME/.cache/lf_dir" -selection-path='. substitute(fnameescape(g:lf_selection_path), '\\', '\\\\\', 'g'). ' "'. expand('%'). '"', {'h': &lines - 7, 'w': &columns * 9/10, 'line': 3, 'callback': 'funcs#lf_edit_callback'})<CR>]])
function! funcs#lf_edit_callback(code) abort
  if filereadable(g:lf_selection_path)
    for filename in readfile(g:lf_selection_path)
      execute 'edit '. escape(filename, '%#')
    endfor
    call delete(g:lf_selection_path)
  endif
endfunction
function M.run_without_rooter(command)
    local prev_dir = vim.fn.getcwd()
    local prev_enabled = enabled
    enabled = false
    vim.api.nvim_set_current_dir(vim.fn.expand("%") == "" and vim.env.PWD or vim.fn.expand("%:p:h"))
    vim.cmd(command)
    vim.api.nvim_set_current_dir(prev_dir)
    enabled = prev_enabled
end
" vim-sandwich
        use({ "machakann/vim-sandwich", setup = "vim.g.operator_sandwich_no_default_key_mappings = 1" })
vim.keymap.set("n", "ys", "<Plug>(operator-sandwich-add)")
vim.keymap.set("n", "yss", "<Plug>(operator-sandwich-add)iw")
vim.keymap.set("n", "yS", "<Plug>(operator-sandwich-add)g_")
vim.keymap.set("n", "ds", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)")
vim.keymap.set("n", "dss", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
vim.keymap.set("n", "cs", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)")
vim.keymap.set("n", "css", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
vim.keymap.set("x", "s", "<Plug>(operator-sandwich-add)")
vim.keymap.set("x", "s<", "<Plug>(operator-sandwich-add)t")
" tmux.nvim
        use({ "aserowy/tmux.nvim", module = "tmux", config = function() require("tmux").setup({ navigation = { cycle_navigation = false } }) end })
vim.keymap.set({ "n", "t" }, "<M-h>", "<Cmd>lua require('tmux').resize_left()<CR>")
vim.keymap.set({ "n", "t" }, "<M-j>", "<Cmd>lua require('tmux').resize_bottom()<CR>")
vim.keymap.set({ "n", "t" }, "<M-k>", "<Cmd>lua require('tmux').resize_top()<CR>")
vim.keymap.set({ "n", "t" }, "<M-l>", "<Cmd>lua require('tmux').resize_right()<CR>")
vim.keymap.set({ "n", "t" }, "<C-h>", "<Cmd>lua require('tmux').move_left()<CR>")
vim.keymap.set({ "n", "t" }, "<C-j>", "<Cmd>lua require('tmux').move_bottom()<CR>")
vim.keymap.set({ "n", "t" }, "<C-k>", "<Cmd>lua require('tmux').move_top()<CR>")
vim.keymap.set({ "n", "t" }, "<C-l>", "<Cmd>lua require('tmux').move_right()<CR>")
" sneak
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
" colorizer
        use({
            "NvChad/nvim-colorizer.lua",
            cmd = "ColorizerAttachToBuffer",
            config = function() require("colorizer").setup({}, { RGB = false, rgb_fn = true, mode = "virtualtext" }) end,
        })

" =======================================================
" cmdheight = 0
vim.o.cmdheight = 0
    components.active[3][6] = {
        provider = function()
            return " recording @" .. vim.fn.reg_recording()
        end,
        enabled = function() return vim.fn.reg_recording() ~= "" end,
        hl = { fg = colors.red, bg = colors.lightbg },
    }

" =======================================================
grg() {  # grep all commits, replace `log` with `reflog` for local commits
  git log --patch --color=always --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --regexp-ignore-case -G "$@" | DELTA_PAGER="$BAT_PAGER --pattern='$1'" delta --line-numbers
}

" =======================================================
Plug 'ctrlpvim/ctrlp.vim'
if exists('*matchfuzzy')
  Plug 'mattn/ctrlp-matchfuzzy'
  let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
endif
let g:ctrlp_show_hidden = 1
let g:ctrlp_prompt_mappings = { 'ToggleType(1)': ['<Tab>'], 'ToggleType(-1)': ['<S-Tab>'], 'ToggleFocus()': ['<C-b>'] }

" =======================================================
nnoremap <leader>fM :browse oldfiles<CR>
command! -complete=file -nargs=+ VFind execute 'Grt' | execute 'vimgrep /\%(\%<2l\)/j **/.'. <q-args>. ' **/'. <q-args> | copen
command! -complete=file -nargs=+ VFind execute 'Grt' | execute 'vimgrep /\%^/j **/.'. <q-args>. ' **/'. <q-args> | copen
function! s:Grep(prg, pattern)
  " use execute so sudoedit will not complain
  execute 'Grt'
  let saved_grepprg = &grepprg
  let &grepprg = (a:prg =~ '^ \|^$' ? saved_grepprg. a:prg : a:prg)
  " do not prepend '--' if pattern is part of flag value
  silent execute 'grep! '. (a:prg =~ '^find\|--files' ? '"' : '-- "'). escape(a:pattern, '\#%$|"'). '"'
  let &grepprg = saved_grepprg
  redraw!
  copen
endfunction
function! funcs#quit(buffer_mode, force) abort
    if exists(':Bdelete')
      try
        execute 'Bdelete'. (a:force ? '!' : '')
      catch
        throw 'Unsaved buffer'
      endtry
    else
      bprevious
      if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1  " check number of buffers again after bprevious
        try
          execute 'bdelete'. (a:force ? '!' : ''). ' #'
        catch
          bnext
          echoerr v:exception
        endtry
      endif
    endif

" =======================================================
" oneline bash prompt PS1
PS1='\[\e[38;5;208m\]\W$(_get_prompt_tail " ")'
_disable_prompt_functions() {
  PS1='\[\e[38;5;208m\]\W \[\e[38;5;141m\]$ \[\e[0m\]'
" _z -c -l
    fzftemp=$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | subdirs=$(_z -c -l 2>&1 | sed -e '/^common:/d' -e 's/^[0-9,.]* *//') fzf --scheme=history --tac --bind='tab:down,btab:up' --bind='`:unbind(`)+reload(echo $subdirs)') && cd "$fzftemp"
" windows lfrc, "$f" doesn't expand correctly under git bash
# use unix settings on windows for git bash
set shell sh
set shellflag -c
map e $$EDITOR "$f"
map w $$SHELL
map i $$PAGER "$f"

" =======================================================
" use https://github.com/jose-elias-alvarez/typescript.nvim
        tsserver = function()
            register_server("tsserver", {
                init_options = { preferences = { importModuleSpecifierPreference = "relative" } },
                commands = {
                    OrganizeImports = {
                        function()
                            vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
                                command = "_typescript.organizeImports",
                                arguments = { vim.api.nvim_buf_get_name(0) },
                                title = "",
                            }, 3000)
                        end,
                        description = "Organize Imports",
                    },
                },
            })
        end,
" fold
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
" themes
        use({ "EdenEast/nightfox.nvim", cond = "require('themes').theme == 'nightfox.nvim'", config = "require('themes').config()" })
    ["nightfox.nvim"] = {
        colors = function()
            default_colors.secondary = "#8bb19c"
            if theme_index < 0 then
                default_colors.primary = "#7a9bd1"
            else
                default_colors.bg = "#ede8e2"
                default_colors.primary = "#65929d"
            end
            return default_colors
        end,
        config = function()
            vim.cmd.colorscheme(theme_index < 0 and "nordfox" or "dawnfox")
        end,
    },
        use({ "eddyekofo94/gruvbox-flat.nvim", cond = "require('themes').theme == 'gruvbox-flat.nvim'", config = "require('themes').config()" })
    ["gruvbox-flat.nvim"] = {
        colors = function()
            default_colors.bg = "#242400"
            default_colors.primary = "#7daea3"
            default_colors.secondary = "#a9b665"
            default_colors.dim_primary = "#5c6e6a"
            return default_colors
        end,
        config = function()
            vim.g.gruvbox_flat_style = "dark"
            vim.g.gruvbox_sidebars = sidebars
            vim.cmd.colorscheme("gruvbox-flat")
            -- https://github.com/eddyekofo94/gruvbox-flat.nvim/issues/21
            vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#808080" })
            vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#7c6f64" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#ea6962" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#ea6962" })
            vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9da85f" })
            vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#9da85f" })
            vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9da85f" })
            vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#7daea3" })
            vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#7daea3" })
            vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#d4d4d4" })
            vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#d4d4d4" })
            vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#47403b" })
            vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#706964" })
        end,
    },

" =======================================================
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
if exists('g:plugs')
  nnoremap <C-p> :FZF<CR>
  xnoremap <C-p> :<C-u>execute 'FZF --query='. funcs#get_visual_selection()<CR>
endif

" =======================================================
" local-bin/rg
#!/usr/bin/env bash
set -eo pipefail
[ "$1" = --files ] && exec fd "$@"
while [ $# -gt 0 ]; do
  [[ $1 = -* ]] && shift || break
done
exec grep --ignore-case --line-number -I -R -- "${1:-*}" .
" local-bin/fd
#!/usr/bin/env bash
set -eo pipefail
while [ $# -gt 0 ]; do
  [[ $1 = -* ]] && shift || break
done
exec find . -type f -not -path '*/.git/*' -iname "*${1:-}*"

" =======================================================
" for compatibility, also search for '7.4' and 'silent!'
  bufnr('%')

" =======================================================
" https://www.reddit.com/r/neovim/comments/10fpqbp/gist_statuscolumn_separate_diagnostics_and/
" many issues like performance, duplicate line number when wrapped, blank margin for sidebars, etc
_G.status_column = function()
    local sign, git_sign
    local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local signs = vim.tbl_map(function(s)
        return vim.fn.sign_getdefined(s.name)[1]
    end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
    for _, s in ipairs(signs) do
        if s.name:find("GitSign") then
            git_sign = s
        else
            sign = s
        end
    end
    local components = {
        sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or " ",
        "%=",
        "%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ",
        git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*") or "  ",
    }
    return table.concat(components, "")
end
vim.o.statuscolumn = "%!v:lua.status_column()"
" treesitter slow
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

" =======================================================
# tmux alt-click to move cursor in non-alternate screen, fast but only works on the same line
bind -n M-MouseDown1Pane {
  select-pane
  if-shell -F '#{||:#{pane_in_mode},#{alternate_on}}' {
    send-keys -M
  } {
    copy-mode -e
    send-keys -X begin-selection
    set-environment -gF TMUX_PREV_X '#{copy_cursor_x}'
    set-environment -gF TMUX_PREV_Y '#{copy_cursor_y}'
    send-keys -X cancel
    if-shell '[ "$TMUX_PREV_X" -ne #{cursor_x} ] || [ "$TMUX_PREV_Y" -ne #{cursor_y} ]' {
      if-shell '[ "$TMUX_PREV_Y" -eq #{cursor_y} ] && [ "$TMUX_PREV_X" -lt #{cursor_x} ] || [ "$TMUX_PREV_Y" -lt #{cursor_y} ]' {
        run-shell 'tmux send-keys -N $((#{cursor_x}-$TMUX_PREV_X+(#{cursor_y}-$TMUX_PREV_Y)*#{pane_width})) Left'
      } {
        run-shell 'tmux send-keys -N $(($TMUX_PREV_X-#{cursor_x}+($TMUX_PREV_Y-#{cursor_y})*#{pane_width})) Right'
      }
    }
  }
}
#!/usr/bin/env bash
set -eo pipefail
cursors=($(tmux display-message -p '#{copy_cursor_x} #{copy_cursor_y} #{cursor_x} #{cursor_y}'))
tmux send-keys -X cancel
copy_cursor_x="${cursors[0]}"
copy_cursor_y="${cursors[1]}"
cursor_x="${cursors[2]}"
cursor_y="${cursors[3]}"
if [ "$copy_cursor_y" -lt "$cursor_y" ]; then
  # need to fix off by 1
  # steps = characters in lines above + number of physical lines crossed - target x + current x
  # if crossing lines, then wc counts correctly (+1 for each line)
  #                         wc -l = number of lines crossed
  # if not crossing lines, then wc counts 1 extra for each screen line, needs tr -d '\n'
  #                             wc -l = 1
  steps=$(($(tmux capture-pane -p -J -S "$copy_cursor_y" -E "$((cursor_y-1))" | wc -m)-copy_cursor_x+cursor_x-1))
  tmux send-keys -N "$steps" Left
elif [ "$copy_cursor_y" -gt "$cursor_y" ]; then
  steps=$(($(tmux capture-pane -p -J -S "$cursor_y" -E "$((copy_cursor_y-1))" | wc -m)+copy_cursor_x-cursor_x-1))
  tmux send-keys -N "$steps" Right
else
  if [ "$copy_cursor_x" -lt "$cursor_x" ]; then
    tmux send-keys -N "$((cursor_x-copy_cursor_x))" Left
  elif [ "$copy_cursor_x" -gt "$cursor_x" ]; then
    tmux send-keys -N "$((copy_cursor_x-cursor_x))" Right
  fi
fi

" =======================================================
-- treesitter performance issues with other plugins
            vim.api.nvim_create_autocmd("BufReadPre", {
                pattern = "*",
                group = "AutoCommands",
                callback = function(opts)
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(opts.buf))
                    if ok and stats and stats.size > vim.g.treesitter_size_threshold then
                        vim.cmd.IlluminatePauseBuf()
                        vim.cmd.IndentBlanklineDisable()
                    end
                end,
            })
            -- telescope insert mappings
                            ["<Esc>"] = function(opts) -- workaround https://github.com/windwp/nvim-ts-autotag/issues/99
                                vim.cmd.stopinsert()
                                vim.schedule(function() actions.close(opts) end)
                            end,
                            ["<CR>"] = function(opts)
                                vim.cmd.stopinsert()
                                vim.schedule(function() actions.select_default(opts) end)
                            end,

" =======================================================
    { "dmmulroy/tsc.nvim", cmd = "TSC", config = true },
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    if not vim.loop.fs_stat(mason_path .. "/bin/tsc") then -- for tsc.nvim
        os.execute("ln -sr " .. mason_path .. "/packages/typescript-language-server/node_modules/typescript/bin/tsc " .. mason_path .. "/bin/tsc")
    end

" =======================================================
export MANPAGER="sh -c 'col -bx | bat --language=man --plain'"
export MANROFFOPT='-c'

" =======================================================
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = { offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory" } } }, -- taking too much space
            ...
        },
    },
" noice.nvim, distracting
    {
        "folke/noice.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            lsp = { override = { ["vim.lsp.util.convert_input_to_markdown_lines"] = true, ["vim.lsp.util.stylize_markdown"] = true } },
            presets = { command_palette = true, long_message_to_split = true, lsp_doc_border = true },
            -- routes = { { filter = { event = "msg_show", find = "search hit" }, skip = true } }, -- filter seems to break long_message_to_split
        },
    },
" mini.nvim
    {
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        keys = {
            { "'", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>e", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.word_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>j", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.line_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>k", "<Cmd>lua require('utils').command_without_quickscope(function() MiniJump2d.start(MiniJump2d.builtin_opts.line_start) end)<CR>", mode = { "n", "x", "o" } },
            { "<leader>,", "<Cmd>lua MiniJump.jump(MiniJump.state.target, not MiniJump.state.backward, MiniJump.state.till, MiniJump.state.n_times)<CR><Cmd>lua MiniJump.state.backward = not MiniJump.state.backward<CR>", mode = { "n", "x", "o" } },
            { "<leader>ga", "<leader>gAig", remap = true },
            { "<leader>gu", "<leader>gUig", remap = true },
            { "[m", "<Cmd>lua require('mini.visits').iterate_paths('backward')<CR>" },
            { "]m", "<Cmd>lua require('mini.visits').iterate_paths('forward')<CR>" },
            { "[M", "<Cmd>lua require('mini.visits').iterate_paths('first')<CR>" },
            { "]M", "<Cmd>lua require('mini.visits').iterate_paths('last')<CR>" },
            -- { "<leader>mm", "<Cmd>lua require('mini.extra').pickers.visit_paths()<CR>" },
            -- { "<leader>mf", "<Cmd>lua require('mini.extra').pickers.visit_labels()<CR>" },
            -- { "<leader>ma", "<Cmd>lua require('mini.visits').add_label()<CR>" },
            -- { "<leader>md", "<Cmd>lua require('mini.visits').remove_label()<CR>" },
            { "ma", "<Cmd>lua require('mini.visits').add_label()<CR>" },
            { "mf", function()
                require("mini.extra").pickers.visit_labels({}, {
                    mappings = {
                        remove = {
                            char = "<C-d>",
                            func = function()
                                require("mini.visits").remove_label(require("mini.pick").get_picker_matches().current)
                                require("mini.pick").stop()
                                vim.cmd.normal("mf")
                            end,
                        }
                    },
                })
            end },
            { "<leader>fM", function()
                local curr = vim.fn.expand("%:p")
                require("mini.extra").pickers.visit_paths({ filter = function(path) return path.path ~= curr end })
            end },
            { "<leader>gf", "<Cmd>lua require('mini.git').show_at_cursor()<CR>", mode = { "n", "x" } },
        },
        config = function()
            require("mini.pairs").setup({ mappings = { [" "] = { action = "open", pair = "  ", neigh_pattern = "[%(%[{][%)%]}]" } } }) -- doesn't support triple quotes
            require('mini.surround').setup() -- doesn't support closest pair
            require("mini.jump").setup({ mappings = { repeat_jump = "," }, delay = { highlight = 1500, idle_stop = 1500 }, silent = true }) -- doesn't support disable auto smart jumps
            require("mini.sessions").setup({ -- doesn't restore scrollview
                hooks = {
                    pre = { read = function() vim.cmd.ScrollViewDisable() end, write = function() vim.cmd.ScrollViewDisable() end },
                    post = { read = function() vim.cmd.ScrollViewEnable() end, write = function() vim.cmd.ScrollViewEnable() end },
                },
            })
            require("mini.pick").setup()
            require("mini.extra").setup()
            vim.ui.select = require("mini.pick").ui_select
            require("mini.visits").setup() -- similar to oldfiles
                " theme.button("E", "Load from session", "<Cmd>lua MiniSessions.select()<CR>"),
                " theme.button("R", "Load from last session", "<Cmd>lua MiniSessions.read()<CR>"),
                " { "&Save session", [[call feedkeys(":lua MiniSessions.write('temp')\<Left>\<Left>", "n")]], "Save session using mini.nvim" },
                " { "Load s&ession", [[lua MiniSessions.select()]], "Load session using mini.nvim" },
            require("mini.git").setup() -- show_at_cursor needs current file committed
            require("mini.keymap").map_combo("i", "jk", "<BS><BS><Esc>") -- sometimes doesn't trigger, and does not clear space on empty line
            local sl = require("mini.statusline")
            local filename = sl.section_filename({ trunc_width = 9999 })
            sl.setup({
                content = {
                    active = function()
                        local _, mode_hl = sl.section_mode({})
                        local fileinfo = sl.section_fileinfo({ trunc_width = 120 })
                        local cwd = " " .. vim.uv.cwd():match("^.+/(.+)$")
                        local diff = vim.b.minidiff_summary_string
                        local diff_text = diff and diff ~= "" and diff:sub((diff:find(" ", 3, true))) or nil
                        local diagnostics = sl.section_diagnostics({ icon = "", signs = { ERROR = " ", WARN = " ", HINT = " ", INFO = " " }, trunc_width = 75 })
                        local search = sl.section_searchcount({ trunc_width = 75 })
                        local clients = vim.tbl_map(function(client) return client.name end, vim.lsp.get_clients({ bufnr = 0 }))
                        local clients_text = #clients > 0 and " " .. table.concat(clients, " ") or nil
                        local reg = vim.fn.reg_recording()
                        local reg_text = reg ~= "" and "recording @" .. reg or nil
                        return sl.combine_groups({
                            { hl = mode_hl, strings = { "" } },
                            { hl = "MiniStatuslineFileinfo", strings = { filename } },
                            "%<",
                            { hl = "MiniStatuslineFilename", strings = { cwd, diff_text, diagnostics } },
                            "%=",
                            { hl = "Constant", strings = { reg_text } },
                            { hl = "MiniStatuslineFilename", strings = { "%S", clients_text } },
                            { hl = "MiniStatuslineDevinfo", strings = { fileinfo } },
                            { hl = mode_hl, strings = { search, (vim.o.expandtab and " " or " ") .. vim.o.shiftwidth, " %c %l/%L" } },
                        })
                    end,
                    inactive = function() return sl.combine_groups({ { hl = "MiniStatuslineInactive", strings = { filename } } }) end,
                },
            })
        end,
    },
" hop.nvim
    {
        "phaazon/hop.nvim",
        keys = {
            { "'", "<Cmd>HopChar1<CR>", mode = { "n", "x", "o" } },
            { "<leader>e", "<Cmd>HopWord<CR>", mode = { "n", "x", "o" } },
            { "<leader>j", "<Cmd>HopLineAC<CR>", mode = { "n", "x", "o" } },
            { "<leader>k", "<Cmd>HopLineBC<CR>", mode = { "n", "x", "o" } },
        },
        config = function()
            require("hop").setup()
            vim.api.nvim_set_hl(0, "HopNextKey", { link = "HopNextKey1" })
            vim.api.nvim_set_hl(0, "HopNextKey2", { link = "HopNextKey1" })
        end,
    },
" ccc.nvim
    {
        "uga-rosa/ccc.nvim",
        cmd = "CccHighlighterEnable",
        config = function()
            local ccc = require("ccc")
            ccc.setup({ highlighter = { auto_enable = true }, mappings = { ["<Tab>"] = ccc.mapping.toggle_input_mode } })
        end,
    },
                    local ccc_state = require("lazy.core.config").plugins["ccc.nvim"]
                    if ccc_state and ccc_state._.loaded then
                        table.insert(content, { "&Color picker", "CccPick", "Open color picker, control: hjkl, 1-9" })
                        table.insert(content, { "Color convert", "CccConvert", "Convert color between hex, rgb, hsl" })
                        table.insert(content, { "--", "" })
                    end
                { "Enable colori&zer", [[CccHighlighterEnable]], "Enable colorizer" },
            "jose-elias-alvarez/typescript.nvim",
        tsserver = function()
            register_server("tsserver", {
                init_options = { preferences = { importModuleSpecifierPreference = "relative" } },
            })
        end,
        local ok, resp = pcall(require("typescript").actions.organizeImports, { sync = true })
        if not ok then vim.notify(resp, vim.log.levels.ERROR, { title = "Organize imports failed" }) end
" asyncrun
    { "skywind3000/asyncrun.vim", cmd = "AsyncRun", config = function() vim.g.asyncrun_open = 12 end },
  if exists(':AsyncRun')
    let run_command['python'] = 'AsyncRun -raw python3 "$(VIM_FILEPATH)"'
    let run_command['javascript'] = 'AsyncRun -raw node "$(VIM_FILEPATH)"'
    let run_command['typescript'] = 'AsyncRun -raw npx ts-node --esm "$(VIM_FILEPATH)"'
    let run_command['c'] = 'AsyncRun -raw gcc "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" -g && "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"'
    let run_command['cpp'] = 'AsyncRun -raw g++ "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" -g && "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"'
    let run_command['java'] = 'AsyncRun -raw javac "$(VIM_FILEPATH)" && java -classpath "$(VIM_FILEDIR)" "$(VIM_FILENOEXT)"'
    let run_command['html'] = 'AsyncRun -silent open "$(VIM_FILEPATH)"'
    let run_command['xhtml'] = 'AsyncRun -silent open "$(VIM_FILEPATH)"'
" neoclip
    {
        "AckslD/nvim-neoclip.lua",
        event = "TextYankPost",
        -- dependencies = { "tami5/sqlite.lua" }, -- persistent history needs libsqlite3
        opts = {
            -- enable_persistent_history = true,
            content_spec_column = true,
            on_paste = { set_reg = true },
            keys = { telescope = { n = { select = "yy", paste = "<CR>", replay = "Q" } } },
        },
    },
" harpoon
    {
        "ThePrimeagen/harpoon",
        keys = {
            { "<leader>m", "<Cmd>lua require('harpoon.mark').add_file()<CR>" },
            { "<leader>h", "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>" },
            { "<leader>1", "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>" },
            { "<leader>2", "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>" },
            { "<leader>3", "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>" },
        },
    },

" =======================================================
" tmux load average to percentage
  set -g status-right "#[fg=colour237,bg=colour178,bold] #(uptime | awk -F ', ' -v nproc=$(nproc) '{sub(/.+load average: /,\"\"); for(i=0;i<NF;i++) printf \$i/nproc*100 \"%% \"}')#[fg=colour237,bg=colour117,bold] #(free | awk 'NR==2{printf \"%%.2f%%%%\", 100*$3/$2}') #[fg=colour237,bg=colour114,bold] %m/%d %I:%M %p #[default]"

" niz keyboard simple modifications
      "simple_modifications": [ { "from": { "key_code": "escape" }, "to": [ { "key_code": "grave_accent_and_tilde" } ] }, { "from": { "key_code": "grave_accent_and_tilde" }, "to": [ { "key_code": "delete_or_backspace" } ] }, { "from": { "key_code": "left_command" }, "to": [ { "key_code": "left_option" } ] }, { "from": { "key_code": "left_option" }, "to": [ { "key_code": "left_command" } ] }, { "from": { "key_code": "right_option" }, "to": [ { "key_code": "right_command" } ] } ]
" dictation switch language, process reload is still needed
        {
          "type": "basic",
          "from": {
            "key_code": "left_shift",
            "modifiers": {
              "mandatory": ["left_option"]
            }
          },
          "to": [
            {
              "shell_command": "{ [ $(defaults read com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMNetworkBasedLocaleIdentifier) = en_US ] && echo zh_CN || echo en_US; } | xargs -I@ sh -c \"defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMNetworkBasedLocaleIdentifier @; osascript -e 'display notification \\\"Changed dictation to @\\\"'\""
            }
          ]
        }

" =======================================================
" use watchexec
react() {
  if [ "$#" -lt 2 ]; then echo "Usage: $0 <dir_to_watch> <command>, use {} as placeholder of modified files." >&2; return 1; fi
  local changed
  echo "Watching \"$1\", passing modified files to \"${*:2}\" command every 2 seconds." >&2
  while true; do
    changed=($(fd --base-directory "$1" --absolute-path --type=f --changed-within 2s))
    if [ ${#changed[@]} -gt 0 ]; then
      local cmd="${@:2}"
      eval "${cmd//\{\}/${changed[@]}}"
    fi
    sleep 2
  done
}
" fff
start=$SECONDS
install-from-github lf gokcehan/lf linux-amd64 linux-arm64 darwin-amd64 darwin-arm64 '' "$@" || {
  if [ $((($SECONDS - $start))) -lt 1 ]; then
    if [ ! -x "$HOME/.vim/tmp/fff" ]; then
      curl -sL -o "$HOME/.vim/tmp/fff" https://raw.githubusercontent.com/dylanaraps/fff/HEAD/fff
      chmod +x "$HOME/.vim/tmp/fff"
    fi
    FFF_HIDDEN=1 FFF_CD_FILE=~/.vim/tmp/lf_dir FFF_KEY_MOVE=d FFF_KEY_TRASH=x FFF_KEY_RENAME=R FFF_KEY_REFRESH=r exec "$HOME/.vim/tmp/fff" "$@"
  fi
}
" vimv https://github.com/thameera/vimv/issues/39
install-from-url vimv https://raw.githubusercontent.com/thameera/vimv/HEAD/vimv "$@"
cmd vimv-bulk-rename ${{ vimv $fx; echo }}
" tmux-thumbs, use wezterm quick select and tmux-picker
  set -g @plugin 'fcsonline/tmux-thumbs'        # <M-'>
  set -g @thumbs-bg-color '#383A57'
  set -g @thumbs-fg-color '#B695F3'
  set -g @thumbs-hint-bg-color '#383A57'
  set -g @thumbs-hint-fg-color '#F4BB78'
  set -g @thumbs-select-bg-color '#383A57'
  set -g @thumbs-select-fg-color '#85F789'
  set -g @thumbs-command 'tmux set-buffer -- {} && tmux paste-buffer'
  set -g @thumbs-upcase-command 'tmux new-window -c "#{pane_current_path}" "$EDITOR \"{}\""'
  set -g @thumbs-regexp-1 '[\w\-.%/]*\.[\w~]+'
  # set -g @thumbs-regexp-1 '\d+:[\w-]+'
  # set -g @thumbs-regexp-2 'i-\w+'
  # set -g @thumbs-regexp-3 '[\w\-.%/]*\.[\w~]+'
  set -g @thumbs-reverse 'enabled'
  set -g @thumbs-unique 'enabled'
  if [ -d "$HOME/.tmux/plugins/tmux-thumbs" ]; then
    log 'Installing tmux-thumbs binaries..'
    curl -L -o- "https://github.com/joshuali925/.vim/releases/download/binaries/tmux-thumbs-$PLATFORM-$ARCHITECTURE.tar.gz" | tar xz -C "$HOME/.tmux/plugins/tmux-thumbs"
  fi

" =======================================================
" null-ls formatter, doesn't work with prettier through conform
                "sh",     -- prettier-plugin-sh (cd ~/.local/share/nvim/mason/packages/prettier; npm install prettier-plugin-sh)
                "bash",
                "java",   -- prettier-plugin-java
                "kotlin", -- prettier-plugin-kotlin
" nvim-notify replaced by fidget.nvim
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({ timeout = 3000 })
            vim.api.nvim_create_user_command("NotificationsDismiss", function() require("notify").dismiss({ silent = true, pending = true }) end, {})
        end,
    },
                        {
                            function()
                                local lsp_progress = vim.lsp.util.get_progress_messages()[1]
                                if lsp_progress then
                                    local title = lsp_progress.title or ""
                                    local percentage = lsp_progress.percentage or 0
                                    local msg = lsp_progress.message or ""
                                    if percentage > 70 then
                                        return string.format(" %%<%s %s %s (%s%%%%) ", "", title, msg, percentage)
                                    end
                                    local spinners = { "󰪞 ", "󰪟 ", "󰪠 ", "󰪡 ", "󰪢 ", "󰪣 ", "󰪤 ", "󰪥" }
                                    local ms = math.floor(vim.loop.hrtime() / 120000000) -- 120ms
                                    local frame = ms % #spinners
                                    return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
                                end
                                return ""
                            end,
                            color = "String",
                        },
" better-escape
    { "max397574/better-escape.nvim", event = "InsertEnter", opts = { mapping = { "jk", "kj" }, timeout = 200, clear_empty_lines = true } },

" =======================================================
" gh markdown preview, install as separate binary
  BIN_INIT=1 gh extension install yusukebe/gh-markdown-preview || true

" =======================================================
" code-server karabiner focus
 || (ps p $(pgrep app_mode_loader) | grep -o '\\(Codespaces\\|code-server\\)\\( [0-9]\\)\\?.app' | xargs -I{} open -a '{}')

" =======================================================
function! funcs#map_copy_with_osc_yank_script()  " doesn't work in neovim
  function! s:CopyWithOSCYankScript(str)
    let @" = a:str
    let buflen = len(a:str)
    let copied = 0
    while buflen > copied
      if copied > 0 && input('Total: ' . buflen . ', copied: ' . copied . ', continue? [Y/n] ') =~ '^[Nn]$'
        break
      endif
      call system('y', a:str[copied :copied + 74993])
      let copied += 74994
    endwhile
    echomsg '[osc52] Copied ' . min([buflen, copied]) . ' characters.'
  endfunction
  call <SID>MapAction('CopyWithOSCYankScript', '<leader>y')
  nmap <leader>Y <leader>y$
endfunction

" =======================================================
" null-ls
    local null_ls = require("null-ls")
    local null_ls_sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.diagnostics.zsh,
    }
    if require("mason-registry").is_installed("shellcheck") then
        table.insert(null_ls_sources, null_ls.builtins.diagnostics.shellcheck)
    end
    null_ls.setup({ sources = null_ls_sources })
function M.is_active()
    for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        if client.name ~= "null-ls" then
            return true
        end
    end
    return false
end

" =======================================================
# https://github.com/MrKai77/Loop
Loop -> General -> check "Restore window frame on drag"
     -> Preview -> uncheck "Show Preview when looping"
     -> Keybindings -> Trigger key: left option
                    -> Import: ~/.vim/config/loop.json
     -> More -> check "Hide Loop until direction is chosen"
loop.json: [{"direction":"Maximize","keybind":[126]},{"direction":"InitialFrame","keybind":[125]},{"direction":"LeftHalf","keybind":[123]},{"direction":"RightHalf","keybind":[124]},{"direction":"Smaller","keybind":[27]},{"direction":"Larger","keybind":[24]},{"direction":"Center","keybind":[56,8]},{"direction":"PreviousScreen","keybind":[56,123]},{"direction":"NextScreen","keybind":[56,124]}]

" =======================================================
" tabularize
                { "--", "" },
                { "Align using = (delimiter fixed)", [[Tabularize /=\zs]], [[Tabularize /=\zs]] },
                { "Align using , (delimiter fixed)", [[Tabularize /,\zs]], [[Tabularize /,\zs]] },
                { "Align using # (delimiter fixed)", [[Tabularize /\#\zs]], [[Tabularize /\#\zs]] },
                { "Align using : (delimiter fixed)", [[Tabularize /:\zs]], [[Tabularize /:\zs]] },
                { "--", "" },
                { "Align using = (delimiter aligned)", [[Tabularize /=]], "Tabularize /=" },
                { "Align using , (delimiter aligned)", [[Tabularize /,]], "Tabularize /," },
                { "Align using # (delimiter aligned)", [[Tabularize /\#]], "Tabularize /\\#" },
                { "Align using : (delimiter aligned)", [[Tabularize /:]], "Tabularize /:" },
                { "--", "" },
                { "Align using = (delimiter fixed)", [['<,'>Tabularize /=\zs]], "'<,'>Tabularize /=\\zs" },
                { "Align using , (delimiter fixed)", [['<,'>Tabularize /,\zs]], "'<,'>Tabularize /,\\zs" },
                { "Align using # (delimiter fixed)", [['<,'>Tabularize /\#\zs]], "'<,'>Tabularize /\\#\\zs" },
                { "Align using : (delimiter fixed)", [['<,'>Tabularize /:\zs]], "'<,'>Tabularize /:\\zs" },
                { "--", "" },
                { "Align using = (delimiter aligned)", [['<,'>Tabularize /=]], "'<,'>Tabularize /=" },
                { "Align using , (delimiter aligned)", [['<,'>Tabularize /,]], "'<,'>Tabularize /," },
                { "Align using # (delimiter aligned)", [['<,'>Tabularize /\#]], "'<,'>Tabularize /\\#" },
                { "Align using : (delimiter aligned)", [['<,'>Tabularize /:]], "'<,'>Tabularize /:" },
" nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        keys = { { "<leader>b", "expand('%') == '' ? '<Cmd>NvimTreeOpen<CR>' : '<Cmd>NvimTreeFindFile<CR>'", expr = true, replace_keycodes = false } },
        config = function()
            require("nvim-tree").setup({
                hijack_cursor = true,
                hijack_netrw = false,
                git = { show_on_open_dirs = false },
                filters = { git_ignored = false },
                actions = { open_file = { resize_window = false } },
                renderer = { highlight_git = true, full_name = true, indent_markers = { enable = true } },
                on_attach = function(bufnr)
                    local function opts(desc)
                        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end
                    local api = require("nvim-tree.api")
                    local filters = require("nvim-tree.explorer.filters").config
                    local function set_gitignore_filter(current)
                        if filters[current] then
                            if not filters.filter_git_ignored then
                                api.tree.toggle_gitignore_filter()
                            end
                            api.tree.collapse_all()
                            api.tree.expand_all()
                        elseif filters.filter_git_ignored then
                            api.tree.toggle_gitignore_filter()
                        end
                    end
                    api.config.mappings.default_on_attach(bufnr)
                    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
                    vim.keymap.set("n", "i", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
                    vim.keymap.set("n", "r", [[<Cmd>execute 'lua require("nvim-tree.api").tree.reload()' <bar> if winwidth(0) >= &columns / 2 - 1 <bar> NvimTreeResize 30 <bar> endif<CR>]], opts("Refresh"))
                    vim.keymap.set("n", "R", api.fs.rename, opts("Rename"))
                    vim.keymap.set("n", "x", api.fs.remove, opts("Delete"))
                    vim.keymap.set("n", "d", api.fs.cut, opts("Cut"))
                    vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
                    vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
                    vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
                    vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
                    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
                    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
                    vim.keymap.set("n", "zc", api.node.navigate.parent_close, opts("Close Directory"))
                    vim.keymap.set("n", "zo", api.node.open.edit, opts("Open"))
                    vim.keymap.set("n", "zM", api.tree.collapse_all, opts("Collapse"))
                    vim.keymap.set("n", "zR", api.tree.expand_all, opts("Expand"))
                    vim.keymap.set("n", "[g", api.node.navigate.git.prev, opts("Prev Git"))
                    vim.keymap.set("n", "]g", api.node.navigate.git.next, opts("Next Git"))
                    vim.keymap.set("n", "<BS>", function()
                        if not filters.filter_git_clean and not filters.filter_no_buffer then
                            api.tree.toggle_git_clean_filter()
                            set_gitignore_filter("filter_git_clean")
                            vim.cmd.file("Git")
                        elseif filters.filter_git_clean then
                            api.tree.toggle_git_clean_filter()
                            api.tree.toggle_no_buffer_filter()
                            set_gitignore_filter("filter_no_buffer")
                            vim.cmd.file("Buffer")
                        else
                            api.tree.toggle_no_buffer_filter()
                            set_gitignore_filter("filter_no_buffer")
                            vim.cmd.file("NvimTree_1")
                        end
                    end, opts("Toggle Filter: Git Clean"))
                    vim.keymap.set("n", "\\", function()
                        if not filters.filter_git_clean and not filters.filter_no_buffer then
                            api.tree.toggle_no_buffer_filter()
                            set_gitignore_filter("filter_no_buffer")
                            vim.cmd.file("Buffer")
                        elseif filters.filter_no_buffer then
                            api.tree.toggle_no_buffer_filter()
                            api.tree.toggle_git_clean_filter()
                            set_gitignore_filter("filter_git_clean")
                            vim.cmd.file("Git")
                        else
                            api.tree.toggle_git_clean_filter()
                            set_gitignore_filter("filter_git_clean")
                            vim.cmd.file("NvimTree_1")
                        end
                    end, opts("Toggle Filter: No Buffer"))
                    vim.keymap.set("n", "q", "<Cmd>execute 'NvimTreeResize ' . winwidth(0) <bar> NvimTreeClose<CR>", opts("Close"))
                    vim.keymap.set("n", "<Left>", "zh", opts("Scroll Left"))
                    vim.keymap.set("n", "<Right>", "zl", opts("Scroll Right"))
                    vim.keymap.set("n", "-", "$", opts("Scroll End"))
                    vim.keymap.set("n", "H", "H", opts("Top"))
                    vim.keymap.set("n", "<C-e>", "<C-e>", opts("Scroll down"))
                end,
            })
        end,
    },
" vim-swap and vim-exchange
vim.keymap.set("n", "cx", "'<Cmd>set operatorfunc=plugins#exchange#exchange_set<CR>' . (v:count1 == 1 ? '' : v:count1) . 'g@'", { expr = true, replace_keycodes = false })
vim.keymap.set("x", "X", ":<C-u>call plugins#exchange#exchange_set(visualmode(), 1)<CR>")
vim.keymap.set("n", "cxx", "'<Cmd>set operatorfunc=plugins#exchange#exchange_set<CR>' . (v:count1 == 1 ? '' : v:count1) . 'g@_'", { expr = true, replace_keycodes = false })
vim.keymap.set("n", "cxc", "<Cmd>call plugins#exchange#exchange_clear()<CR>")
    {
        "machakann/vim-swap",
        keys = {
            { "ia", "<Plug>(swap-textobject-i)", mode = { "x", "o" } },
            { "aa", "<Plug>(swap-textobject-a)", mode = { "x", "o" } },
            { "g<", "<Plug>(swap-prev)" },
            { "g>", "<Plug>(swap-next)" },
            { "gs", "<Plug>(swap-interactive)", mode = { "n", "x" } },
        },
    },
" https://github.com/tomasky/bookmarks.nvim/pull/15
    {
        "tomasky/bookmarks.nvim",
        event = "VeryLazy",
        keys = {
            { "ma", "<Cmd>lua require('bookmarks').bookmark_ann()<CR>" },
            { "mm", "<Cmd>lua require('bookmarks').bookmark_toggle()<CR>" },
            { "mc", "<Cmd>lua require('bookmarks').bookmark_clean()<CR>" },
            { "mC", "<Cmd>lua require('bookmarks').bookmark_clear_all()<CR>" },
            { "mf", "<Cmd>lua require('bookmarks').bookmark_list()<CR>" },
            { "mF", "<Cmd>lua require('telescope').extensions.bookmarks.list()<CR>" },
        },
        opts = {
            sign_priority = 14,
            save_file = vim.fn.stdpath("state") .. "/.bookmarks",
            signs = { add = { hl = "BookMarksAdd", text = "󰈿" }, ann = { hl = "BookMarksAnn", text = "󱞂" } },
        },
    },
local function show_git_log_for_lines()
    local current_file = vim.fn.expand("%:p")
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    local line_range = start_line .. "," .. end_line
    local git_cmd = "git log --no-merges -n 1 -L " .. vim.fn.shellescape(line_range .. ":" .. current_file)
    local git_log = vim.fn.systemlist(git_cmd)
    local popup_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("filetype", "git", { buf = popup_bufnr })
    vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, true, git_log)
    local popup_winnr = vim.api.nvim_open_win(popup_bufnr, false, {
        width = 50,
        height = #git_log,
        relative = "cursor",
        row = 0,
        col = 0,
        style = "minimal",
        border = "rounded"
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinLeave" }, {
        pattern = "*",
        group = "AutoCommands",
        once = true,
        callback = function()
            vim.api.nvim_win_close(popup_winnr, true)
            vim.cmd.bdelete(popup_bufnr, true)
        end
    })
end

" =======================================================
" 0.10 default
vim.keymap.set("n", "gx", "<Cmd>call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>")
vim.keymap.set("x", "gx", ":<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>")
function! funcs#map_copy_to_win_clip()
  function! s:CopyToWinClip(str)
    let @" = a:str
    call system('clip.exe', a:str)
  endfunction
  call <SID>MapAction('CopyToWinClip', '<leader>y')
  nmap <leader>Y <leader>y$
endfunction
function M.copy_with_osc_yank_script(str)
    local message = ""
    if str:len() > 70000 then
        str = str:sub(1, 70000)
        message = "String too large. "
    end
    local handle = assert(io.popen("y", "w"))
    handle:write(str)
    handle:flush()
    handle:close()
    vim.notify(message .. "Copied " .. str:len() .. " characters.", vim.log.levels.INFO, { annote = "osc52" })
end
    {
        "stevearc/aerial.nvim",
        keys = { { "<leader>v", "<Cmd>AerialToggle<CR>" }, { "<leader>V", "<Cmd>AerialNavToggle<CR>" } },
        opts = {
            keymaps = {
                ["v"] = function()
                    require("aerial.actions").close.callback()
                    require("aerial").nav_open()
                end,
            },
            nav = { preview = true, keymaps = { ["q"] = "actions.close" } },
        },
    },
                        { "References", "lua vim.lsp.buf.references()", "Show references" },
                        { "&Signautre", "lua vim.lsp.buf.signature_help()", "Show function signature help" },
                        { "Implementation", "lua vim.lsp.buf.implementation()", "Go to implementation" },
                        { "--", "" },
                        { "Git hunk &diff", "lua require('gitsigns').preview_hunk()", "Git preview hunk" },
                        { "Git hunk &undo", "lua require('gitsigns').reset_hunk()", "Git undo hunk" },
                        { "Git hunk &add", "lua require('gitsigns').stage_hunk()", "Git stage hunk" },
                        { "Git hunk reset", "lua require('gitsigns').undo_stage_hunk()", "Git undo stage hunk" },
                        { "Git buffer reset", "lua require('gitsigns').reset_buffer_index()", "Git reset buffer index" },
                        { "Git &blame", "lua require('gitsigns').blame_line({full = true})", "Git blame of current line" },
                        { "Git &remote", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | if $SSH_CLIENT == "" | .GBrowse | else | let @+=split(execute(".GBrowse!"), "\n")[-1] | endif]], "Open remote url in browser, or copy to clipboard if over ssh" },
            vim.fn["quickui#menu#install"]("&Toggle", {
                { "Quickfix             %{empty(filter(getwininfo(), 'v:val.quickfix')) ? '[ ]' : '[x]'}", [[execute empty(filter(getwininfo(), "v:val.quickfix")) ? "copen" : "cclose"]] },
                { "Location list        %{empty(filter(getwininfo(), 'v:val.loclist')) ? '[ ]' : '[x]'}", [[execute empty(filter(getwininfo(), "v:val.loclist")) ? "lopen" : "lclose"]] },
                { "Set &diff             %{&diff ? '[x]' : '[ ]'}", [[execute &diff ? "windo diffoff" : len(filter(nvim_list_wins(), 'nvim_win_get_config(v:val).relative == ""')) == 1 ? "vsplit | bnext | windo diffthis" : "windo diffthis"]], "Toggle diff in current tab, split next buffer if only one window" },
                { "Set scr&ollbind       %{&scrollbind ? '[x]' : '[ ]'}", [[execute &scrollbind ? "windo set noscrollbind" : "windo set scrollbind"]], "Toggle scrollbind in current tab" },
                { "Set &wrap             %{&wrap ? '[x]' : '[ ]'}", [[set wrap!]], "Toggle wrap lines" },
                { "Set &paste            %{&paste ? '[x]' : '[ ]'}", [[execute &paste ? "set nopaste number mouse=a signcolumn=yes" : "set paste nonumber norelativenumber mouse= signcolumn=no"]], "Toggle paste mode" },
                { "Set &spelling         %{&spell ? '[x]' : '[ ]'}", [[set spell!]], "Toggle spell checker (z= to auto correct current word)" },
                { "Set &virtualedit      %{&virtualedit=~#'all' ? '[x]' : '[ ]'}", [[execute &virtualedit=~#"all" ? "set virtualedit=block" : "set virtualedit=all"]], "Toggle virtualedit" },
                { "Set preview          %{&completeopt=~'preview' ? '[x]' : '[ ]'}", [[execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"]], "Toggle function preview" },
                { "Set &cursorline       %{&cursorline ? '[x]' : '[ ]'}", [[set cursorline!]], "Toggle cursorline" },
                { "Set cursorcol&umn     %{&cursorcolumn ? '[x]' : '[ ]'}", [[set cursorcolumn!]], "Toggle cursorcolumn" },
                { "Set light &background %{&background=~'light' ? '[x]' : '[ ]'}", [[let &background = &background=="dark" ? "light" : "dark"]], "Toggle background color" },
                { "Show cmdlin&e         %{&cmdheight==1 ? '[x]' : '[ ]'}", [[let &cmdheight = &cmdheight==1 ? 0 : 1]], "Toggle cmdheight" },
                { "Reader &mode          %{get(g:, 'ReaderMode', 0) == 0 ? '[ ]' : '[x]'}", [[execute get(g:, "ReaderMode", 0) == 0 ? "nnoremap <nowait> d <C-d>\<bar>nnoremap u <C-u>" : "nunmap d\<bar>nunmap u" | let g:ReaderMode = 1 - get(g:, "ReaderMode", 0) | lua vim.notify("Reader mode " .. (vim.g.ReaderMode == 1 and "on" or "off"))]], "Toggle using 'd' and 'u' for '<C-d>' and '<C-u>' scrolling" },
                { "--", "" },
                { "&Indent line", [[IBLToggle]], "Toggle indent lines" },
                { "&Rooter", [[lua require("rooter").toggle()]], "Toggle automatically change root directory" },
            })

" =======================================================
fif() {  # find in file
  if [[ $# -eq 0 ]]; then echo 'Need a string to search for.'; return 1; fi
  rg --files-with-matches --no-messages "$@" | fzf --multi --preview-window=up,60% --preview="rg --pretty --context 5 --max-columns 0 -- $(printf "%q " "$@"){+}" --bind="enter:execute($EDITOR -c \"/$1\" -- {+} < /dev/tty)"
}
                theme.button("!", "Git changed files", [[<Cmd>execute "lua require('lazy').load({plugins = 'vim-flog'})" | Git difftool --name-status | args `git ls-files --others --exclude-standard`<CR>]]),
alias gvenv='[[ ! -d $HOME/.local/lib/venv ]] && python3 -m venv "$HOME/.local/lib/venv"; source "$HOME/.local/lib/venv/bin/activate"'
install-from-github q harelba/q linux-q '' macos-q '' '' "$@"
alias q='q --output-header --pipe-delimited-output --beautify --delimiter=, --skip-header'
alias q-="up -c \"\\\\\$(alias q | sed \"s/[^']*'\\(.*\\)'/\\1/\") 'select * from -'\""
alias gunshallow='if [[ "$(git config --local --get remote.origin.partialclonefilter)" = blob:none ]]; then git fetch --no-filter --refetch; else git remote set-branches origin "*" && git fetch -v && echo -e "\nRun \"git fetch --unshallow\" to fetch all history"; fi'
alias gsall="find . -name .git -execdir bash -c 'echo -e \"\\033[1;32m\"repo: \"\\033[1;34m\"\$([[ \$(pwd) = '\$PWD' ]] && echo \$(basename \$PWD) \"\\033[1;30m\"\(current directory\) || realpath --relative-to=\"'\$PWD'\" .) \"\\033[1;30m\"- \"\\033[1;33m\"\$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)\"\\033[1;30m\"\$(git log --pretty=format:\" (%cr)\" --max-count 1)\"\\033[0m\"; git status -s' \\;"
alias gls="\ls -A --group-directories-first -1 | while IFS= read -r line; do git log --color --format=\"\$(\ls -d -F --color \"\$line\") =} %C(bold black)▏%Creset%C(yellow)%h %Cgreen%cr%Creset =} %C(bold black)▏%C(bold blue)%an %Creset%s%Creset\" --abbrev-commit --max-count 1 HEAD -- \"\$line\"; done | awk -F'=}' '{ nf[NR]=NF; for (i = 1; i <= NF; i++) { cell[NR,i] = \$i; gsub(/\033\[([[:digit:]]+(;[[:digit:]]+)*)?[mK]/, \"\", \$i); len[NR,i] = l = length(\$i); if (l > max[i]) max[i] = l; } } END { for (row = 1; row <= NR; row++) { for (col = 1; col < nf[row]; col++) printf \"%s%*s%s\", cell[row,col], max[col]-len[row,col], \"\", OFS; print cell[row,nf[row]]; } }'"
gpr() {
  if [[ $# -lt 1 ]]; then echo "Usage: $0 [-d|--diff|-p|--patch] {<PR-number>|<PR-URL>} [<remote>]" >&2; return 1; fi
  local rest=()
  for arg in "$@"; do
    case $arg in
      -d|--diff) local reset=1 ;;  # if --diff is specified, reset to the common ancestor of HEAD and remote default branch
      -p|--patch) local patch=1 ;;  # if --patch is specified, directly apply the diff from PR
      *) rest+=("$arg") ;;
    esac
  done
  set -- "${rest[@]}"
  local pr=${1##*/} remote=${2:-origin}
  if ! git rev-parse --git-dir > /dev/null 2>&1; then  # clone a new directory for PR if not in git
    local repo=${1%/pull/*}
    git clone --filter=blob:none "$repo" "${repo##*/}-$pr"
    cd "${repo##*/}-$pr" > /dev/null || return 1
  fi
  git stash push --include-untracked --message 'git PR temporary stash'
  if [[ -n $patch ]]; then
    curl -fsSL "$(git remote get-url "$remote" | sed -e 's,git@\\([^:]\\+\\):,https://\\1/,' -e 's/\\.git$//')/pull/${pr}.diff" | git apply -3
    return $?
  fi
  git fetch "$remote" "pull/$pr/head" && { git branch "pr/$pr" 2> /dev/null; git checkout "pr/$pr" && git reset --hard FETCH_HEAD; }
  if [[ -n $reset ]]; then
    git fetch "$remote" HEAD
    git reset "$(git merge-base HEAD "$remote"/HEAD)"
  fi
}
gh-backport() {
  if [[ $# -ne 1 ]]; then echo "Usage: $0 <SHA>" >&2; return 1; fi
  local sha=$1 args=() ref=$(git symbolic-ref --short HEAD)
  if [[ -f .github/PULL_REQUEST_TEMPLATE.md ]]; then
    args+=(--body-file .github/PULL_REQUEST_TEMPLATE.md)
  fi
  { git cherry-pick -x "$sha" || git cherry-pick --continue; } && git push fork "$ref" -f && gh pr create --title "[$ref] $(git log -n 1 --pretty=format:%s "$sha")" --base "$ref" "${args[@]}"
}


" =======================================================
local function show_git_log_for_lines() -- does not handle modified file correctly
    local current_file = vim.fn.expand("%:p")
    local git_cmd = "git log --no-merges -n 1 -L " .. vim.fn.shellescape(("%s,%s:%s"):format(vim.fn.line("v"), vim.fn.line("."), current_file))
    local git_log = vim.fn.systemlist(git_cmd)
    local max_width = 0
    for _, line in ipairs(git_log) do
        local width = vim.fn.strdisplaywidth(line)
        if width > max_width then
            max_width = width
        end
    end
    local popup_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("filetype", "git", { buf = popup_bufnr })
    vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, true, git_log)
    local popup_winnr = vim.api.nvim_open_win(popup_bufnr, false, {
        width = max_width,
        height = #git_log,
        relative = "cursor",
        row = 0,
        col = 0,
        style = "minimal",
        border = "rounded"
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinLeave" }, {
        pattern = "*",
        group = "AutoCommands",
        once = true,
        callback = function()
            if vim.api.nvim_win_is_valid(popup_winnr) then
                vim.api.nvim_win_close(popup_winnr, true)
            end
            if vim.api.nvim_buf_is_valid(popup_bufnr) then
                vim.api.nvim_buf_delete(popup_bufnr, { force = true })
            end
        end
    })
end
    {
        "tristone13th/lspmark.nvim",
        lazy = false,
        keys = {
            { "ma", "<Cmd>lua require('lspmark.bookmarks').toggle_bookmark({with_comment=false})<CR>" }
        },
        config = true,
    },
    " use noice.nvim
vim.o.lazyredraw = true
            {
                "j-hui/fidget.nvim",
                init = function()
                    vim.notify = (function(overridden)
                        return function(...)
                            local present, fidget = pcall(require, "fidget")
                            if present then
                                vim.notify = function(msg, level, opts)
                                    if opts and opts["title"] then opts["annote"] = opts["title"] end
                                    return fidget.notify(msg, level, opts)
                                end
                            else
                                vim.notify = overridden
                            end
                            vim.notify(...)
                        end
                    end)(vim.notify)
                end,
                config = function()
                    require("fidget").setup()
                    vim.api.nvim_create_user_command("Notifications", "lua require('fidget.notification').show_history()", {})
                end,
            },
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

" =======================================================
    {
        "rhysd/conflict-marker.vim",
        config = function()
            vim.g.conflict_marker_enable_mappings = 0
            vim.g.conflict_marker_begin = "^<<<<<<< .*$"
            vim.g.conflict_marker_common_ancestors = "^||||||| .*$"
            vim.g.conflict_marker_end = "^>>>>>>> .*$"
            vim.g.conflict_marker_highlight_group = ""
            vim.cmd.doautocmd("BufReadPost") -- refresh highlights when delay loaded after treesitter
        end,
    },
function! funcs#get_conflict_state() abort  " conflict-marker.vim
  let current_styles = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  if match(current_styles, '^Conflict') != -1
    if len(current_styles) == 2 && match(current_styles, '^ConflictMarkerBegin$') != -1 || len(current_styles) == 1 && match(current_styles, '^ConflictMarker\(Begin\|Ours\)$') != -1
      return 'Ourselves'
    elseif len(current_styles) == 2 && match(current_styles, '^ConflictMarkerEnd$') != -1 || len(current_styles) == 1 && match(current_styles, '^ConflictMarker\(End\|Theirs\)$') != -1
      return 'Themselves'
    endif
    return 'AncestorOrSeparator'
  endif
  return ''
endfunction
        vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { bg = "#427266" })
        vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { bg = "#364f49" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestors", { bg = "#383838" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestorsHunk", { bg = "#282828" })
        vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { bg = "#3a4f67" })
        vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { bg = "#234a78" })
        vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { bg = "#7ed9ae" })
        vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { bg = "#94ffcc" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestors", { bg = "#bfbfbf" })
        vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestorsHunk", { bg = "#e5e5e5" })
        vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { bg = "#b9d1fa" })
        vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { bg = "#86abeb" })
                    local conflict_state = vim.fn["funcs#get_conflict_state"]()
                    if conflict_state ~= "" then
                        if conflict_state == "Ourselves" or conflict_state == "Themselves" then
                            table.insert(content, { "Git &conflict get", "ConflictMarker" .. conflict_state, "Get change from " .. conflict_state })
                        end
                        table.insert(content, { "Git conflict get &all", "ConflictMarkerBoth", "Get change from ours and theirs" })
                        table.insert(content, { "Git conflict remove", "ConflictMarkerNone", "Remove conflict" })
                        table.insert(content, { "--", "" })
                    end
" gitsigns
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "[g", "<Cmd>lua require('gitsigns').prev_hunk()<CR>" },
            { "]g", "<Cmd>lua require('gitsigns').next_hunk()<CR>" },
            { "ig", ":<C-u>lua require('gitsigns.actions').select_hunk()<CR>", mode = { "o", "x" } },
            { "<leader>gd", "<Cmd>lua require('gitsigns').preview_hunk()<CR>" },
            { "<leader>ga", "<Cmd>lua require('gitsigns').stage_hunk()<CR>" },
            { "<leader>gu", "<Cmd>lua require('gitsigns').reset_hunk()<CR>" },
            { "<leader>gU", "<Cmd>lua require('gitsigns').undo_stage_hunk()<CR>" },
            { "<leader>gb", "<Cmd>lua require('gitsigns').blame_line({full = true, ignore_whitespace = true})<CR>" },
        },
        opts = {
            signs = { add = { text = "▎" }, change = { text = "░" }, delete = { text = "▏" }, topdelete = { text = "▔" }, changedelete = { text = "▒" } },
            update_debounce = 250,
            sign_priority = 13, -- higher priority than diagnostic signs
        },
    },
            require("scrollview.contrib.gitsigns").setup()
                { "Git &toggle deleted", [[lua require("gitsigns").toggle_deleted()]], "Show deleted lines with gitsigns" },
                { "Git toggle &word diff", [[lua require("gitsigns").toggle_word_diff()]], "Show word diff with gitsigns" },
                { "Git toggle line blame", [[lua require("gitsigns").toggle_current_line_blame()]], "Show blame of current line with gitsigns" },
                { "Git &changes since ref", [[call feedkeys(":lua require('utils').git_change_base('@')\<Left>\<Left>", "n")]], "Load changed files since ref into quickfix (Git! difftool --name-status ref), and show hunks based on ref instead of staged (to reset run :Gitsigns reset_base true)" },
function M.git_change_base(commit)
    require("lazy").load({ plugins = "vim-flog" })
    vim.cmd.Git({ args = { "difftool --name-status " .. commit }, bang = true })
    require("gitsigns").change_base(commit, true)
end

" async format on save
local function setup_format_on_save(client, bufnr) -- https://sxyz.blog/nvim-async-formatting/, https://gist.github.com/sxyazi/b730a430e064c5eb59e7a0e76b587e38
    local version = nil
    local function on_formatted(err, result, ctx)
        if err ~= nil then
            require("vim.lsp.log").error(string.format("[%s] %d: %s", client.name, err.code, err.message))
            return
        end
        if result == nil or not vim.api.nvim_buf_is_loaded(ctx.bufnr) or vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick") ~= version then
            return
        end
        vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-16")
        if vim.api.nvim_get_current_buf() == ctx.bufnr then
            vim.b.format_saving = true
            vim.cmd.update()
            vim.b.format_saving = false
        end
    end
    if client.supports_method("textDocument/formatting") then
        local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = group,
            buffer = bufnr,
            callback = function()
                if vim.b.format_saving then return end
                version = vim.api.nvim_buf_get_var(bufnr, "changedtick")
                client.request("textDocument/formatting", vim.lsp.util.make_formatting_params(), on_formatted, bufnr)
            end,
        })
    end
end

" =======================================================
" lfrc, use yazi
# default shell is sh which doesn't support arrays and `<<<` herestring
cmd zip ${{
  set -f
  echo "$fx" | {
    while IFS= read -r filepath; do
      set -- "$@" "$(realpath --relative-to='.' "$filepath")"
    done
    zip -r "${1}.zip" "$@"  # positional arguments only available in subshell from pipe
  }
}}
" yazi get selected_or_hovered in plugin
-- https://github.com/yazi-rs/plugins/tree/main/chmod.yazi
local selected_or_hovered = ya.sync(function()
    local tab, paths = cx.active, {}
    for _, u in pairs(tab.selected) do
        paths[#paths + 1] = tostring(u)
    end
    if #paths == 0 and tab.current.hovered then
        paths[1] = tostring(tab.current.hovered.url)
    end
    return paths
end)
" auto set terminal background
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, { -- https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance
    group = "AutoCommands",
    callback = function()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        if normal.bg then
            local group = vim.api.nvim_create_augroup("ClearBG", {})
            vim.api.nvim_create_autocmd("UILeave", { group = group, callback = function() io.write("\027]111\027\\") end })
            io.write(string.format("\027]11;#%06x\027\\", normal.bg))
        end
    end,
})
" yazi follow file, doesn't normalize directory
    local h = cx.active.current.hovered
    if h.link_to ~= nil then return ya.manager_emit("reveal", { tostring(h.link_to) }) end

" =======================================================
" visual_studio_code theme
            if require("themes").theme == "visual_studio_code" then
                return
            end
    { "askfiy/visual_studio_code", priority = 1000, enabled = theme == "vscode" },
            require("visual_studio_code").setup({ mode = theme_index < 0 and "dark" or "light" })
            vim.cmd.colorscheme("visual_studio_code")
            if theme_index < 0 then
                vim.api.nvim_set_hl(0, "IblIndent", { fg = "#353535" })
                vim.api.nvim_set_hl(0, "IblScope", { fg = "#4a4a4a" })
                vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#484848" })
                vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#484848" })
                vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#484848" })
                require("visual_studio_code.utils").hl.set("CursorLine", { bg = "#282828" })
            end
            require("lualine").setup({
                options = {
                    theme = "visual_studio_code",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = require("visual_studio_code").get_lualine_sections(),
            })
            require("bufferline").setup({ options = { custom_areas = { right = require("visual_studio_code").get_bufferline_right() } } })
" use stevearc/quicker.nvim
vim.keymap.set("n", "yoq", "empty(filter(getwininfo(), 'v:val.quickfix')) ? '<Cmd>copen<CR>' : '<Cmd>cclose<CR>'", { expr = true, replace_keycodes = false })
vim.keymap.set("n", "yol", "empty(filter(getwininfo(), 'v:val.loclist')) ? '<Cmd>lopen<CR>' : '<Cmd>lclose<CR>'", { expr = true, replace_keycodes = false })
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "quickfix",
    group = "AutoCommands",
    callback = function()
        vim.bo.buflisted = false
        vim.bo.modifiable = true
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = [[matchstr(getline(v:lnum),'^[^|]\+')==#matchstr(getline(v:lnum+1),'^[^|]\+')?1:'<1']]
        vim.o.foldtext = [[matchstr(getline(v:foldstart),'^[^|]\+').'| ⋯']]
        vim.keymap.set("n", "<leader>w", [[<Cmd>let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m,%f\|\|%m,%f' <bar> cgetbuffer <bar> silent! bdelete! <bar> copen<CR>]], { buffer = true })
        vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
        vim.keymap.set("n", "<leader>s", [[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]], { buffer = true })
        vim.keymap.set("x", "<leader>s", [["xy:cdo s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\r', 'g')<CR>/g<Left><Left>]], { buffer = true })
    end,
})
" codeium.vim
            {
                "Exafunction/codeium.vim",
                enabled = vim.env.ENABLE_CODEIUM ~= nil,
                config = function()
                    vim.g.codeium_disable_bindings = 1
                    vim.g.codeium_tab_fallback = "<Right>"
                    local filetype_map = {}
                    for _, filetype in ipairs(vim.g.qs_filetype_blacklist) do
                        filetype_map[filetype] = false
                    end
                    vim.g.codeium_filetypes = filetype_map
                    vim.keymap.set("i", "<Right>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
                    vim.keymap.set("i", "<Left>", function()
                        if vim.b._codeium_completions == nil then return "<Left>" end
                        return vim.fn["codeium#Clear"](-1)
                    end, { expr = true })
                end,
            },
    vim.api.nvim_set_hl(0, "CodeiumSuggestion", { link = "LspCodeLens" }) -- codeium
                                local codeium = ""
                                if vim.env.ENABLE_CODEIUM then
                                    codeium = " " .. (vim.g.codeium_filetypes and vim.api.nvim_call_function("codeium#GetStatusString", {}) or "OFF") .. " "
                                end
" codeium.nvim
            { "Exafunction/codeium.nvim", config = true, enabled = vim.env.ENABLE_CODEIUM ~= nil },
                Codeium = " ",
                    ["<C-n>"] = cmp.mapping.complete({ config = { sources = { { name = "codeium" } } } }),
                    { name = "codeium" },
" blink.cmp - vim.snippet variable transformation not working https://github.com/neovim/neovim/issues/25696
            sources = {
                providers = {
                    snippets = {
                        opts = {
                            search_paths = { vim.fn.expand("~/.vim/config/snippets") }, -- vscode snippets: $HOME/Library/ApplicationSupport/Code/User/snippets
                            extended_filetypes = { zsh = { "sh" }, typescript = { "javascript" }, typescriptreact = { "javascript", "typescript" } },
                        }
                    },
                },
            },
" csv.vim
    {
        "chrisbra/csv.vim",
        cmd = "CSVWhatColumn",
        init = function()
            vim.g.csv_nomap_cr = 1
            vim.g.csv_nomap_bs = 1
        end,
        config = function() vim.o.filetype = "csv" end,
    },
                { "--", "" },
                { "CSV show column", [[CSVWhatColumn!]], "Show column title under cursor" },
                { "&CSV arrange column", [[execute "lua require('lazy').load({plugins = 'csv.vim'})" | 1,$CSVArrangeColumn!]], "Align csv columns" },
                { "CSV to table", [[execute "lua require('lazy').load({plugins = 'csv.vim'})" | CSVTabularize]], "Convert csv to table" },
" grug-far
    { "MagicDuck/grug-far.nvim", keys = { { "g/", "<Cmd>lua require('grug-far').open()<CR>", mode = { "n", "x" } } }, opts = { keymaps = { close = { n = "<leader>q" } } } },

" =======================================================
" karabiner switch window, too slow
              "shell_command": "(pgrep Chrome && osascript -e 'tell application \"System Events\"' -e 'set isActive to (name of first application process whose frontmost is true) = \"Google Chrome\"' -e 'end tell' -e 'tell application \"Google Chrome\"' -e 'if isActive then' -e 'set windowCount to count of windows' -e 'if windowCount > 1 then' -e 'set currentWindow to index of front window' -e 'if currentWindow = windowCount then' -e 'set index of window 1 to 1' -e 'else' -e 'set index of window (currentWindow + 1) to (currentWindow + 1)' -e 'end if' -e 'end if' -e 'else' -e 'activate' -e 'end if' -e 'end tell') || (pgrep 'Microsoft Edge' && open -a 'Microsoft Edge') || (pgrep Orion && open -a 'Orion') || (pgrep '^Arc$' && open -a 'Arc')"

" =======================================================
" multi-grep https://github.com/tjdevries/advent-of-nvim/blob/13d4ec68a2a81f27264f3cc73dd7cd8c047aab87/nvim/lua/config/telescope/multigrep.lua
return function(opts)
    opts = opts or {}
    require("telescope.pickers").new(opts, {
        finder = require("telescope.finders").new_job(function(prompt)
            if not prompt or prompt == "" then return nil end
            local parts = vim.split(prompt, "  ")
            local args = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" } -- vimgrep_arguments
            if parts[2] then
                for _, glob in ipairs(vim.split(parts[2], ",")) do
                    table.insert(args, "-g")
                    table.insert(args, glob)
                end
            end
            if parts[1] then
                table.insert(args, "-e")
                table.insert(args, parts[1])
            end
            return args
        end, require("telescope.make_entry").gen_from_vimgrep(opts), opts.max_results, opts.cwd or vim.uv.cwd()),
        prompt_title = "Multi Grep",
        previewer = require("telescope.config").values.grep_previewer(opts),
        sorter = require("telescope.sorters").highlighter_only(opts),
        push_cursor_on_edit = true,
    }):find()
end

" =======================================================
" wezterm status bar
wezterm.on("update-right-status", function(window, pane)
    local date = wezterm.strftime("%a %m/%d %I:%M %p")
    local battery = ""
    for _, b in ipairs(wezterm.battery_info()) do
        local icon
        if b.state_of_charge > 0.90 then
            icon = "  "
        elseif b.state_of_charge > 0.75 then
            icon = "  "
        elseif b.state_of_charge > 0.5 then
            icon = "  "
        elseif b.state_of_charge > 0.25 then
            icon = "  "
        elseif b.state_of_charge > 0.05 then
            icon = "  "
        end
        battery = string.format("%.0f%%", b.state_of_charge * 100) .. icon
    end
    window:set_right_status(wezterm.format({ { Text = battery .. "   " .. date } }))
end)

" =======================================================
" https://stackoverflow.com/questions/13630849/git-difference-between-assume-unchanged-and-skip-worktree
alias gexclude='cat >> "$(git rev-parse --show-toplevel)/.git/info/exclude" <<<'
alias gexcluded='grep -v "^# " "$(git rev-parse --show-toplevel)/.git/info/exclude"'
gunexclude() { sed -i "/^${*//\//\\/}\$/d" "$(git rev-parse --show-toplevel)/.git/info/exclude"; local r=$?; gexcluded; return $r; }
alias gexclude2='git update-index --assume-unchanged'
alias gexcluded2='git ls-files -v | grep "^[[:lower:]]"'
alias gunexclude2='git update-index --no-assume-unchanged'
" pynvim
  PIP_BREAK_SYSTEM_PACKAGES=1 pip3 install --user pynvim && log 'Installed python3, pip3, pynvim' || log 'Installed python3, failed to install pip packages'
  log "To use pynvim regardless of venv, set ${YELLOW}vim.g.python3_host_prog = \"$(which python3)\""

" =======================================================
" nvim fzf
function M.fzf(visual)
    local height = vim.o.lines - 6
    local width = math.ceil(vim.o.columns * 9 / 10)
    if visual or fzf_term == nil or prev_height ~= height or prev_width ~= width then
        local cmd = ([[FZF_DEFAULT_COMMAND="$FZF_CTRL_T_COMMAND" FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --multi --layout=default --height=100% --bind=tab:toggle-out,shift-tab:toggle-in --bind=",:preview-down,.:preview-up" --preview="bat --plain --color=always {}" ]]):gsub("`", "\\`"):gsub("%%", "%%%%") .. (visual and "--query " .. M.get_visual_selection() .. " > %s" or "> %s")
        fzf_term = term_with_edit_callback(cmd, height, width, "none")
    end
    fzf_term:toggle()
end
            { "<leader>fS", "<Cmd>lua require('utils').fzf()<CR>" },
            { "<leader>fS", ":<C-u>lua require('utils').fzf(true)<CR>", mode = "x" },
" custom osc52 override
    local function paste() return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end
    vim.g.clipboard = {
        name = "osc52",
        copy = { ["+"] = require("vim.ui.clipboard.osc52").copy("+"), ["*"] = require("vim.ui.clipboard.osc52").copy("*") },
        paste = { ["+"] = paste, ["*"] = paste }, -- osc52 paste doesn't work in some terminal and can be blocking with yanky.nvim
    }
" avante
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        enabled = vim.env.OPENAI_API_KEY ~= nil,
        build = "make",
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            { "nvim-lualine/lualine.nvim", opts = { options = { globalstatus = true } } },
        },
        opts = {
            vendors = {
                my_openai = {
                    __inherited_from = "openai",
                    api_key_name = "OPENAI_API_KEY",
                    endpoint = vim.env.OPENAI_API_BASE,
                    model = "anthropic.claude-3-5-sonnet-20241022-v2:0",
                },
            },
            provider = "my_openai",
            auto_suggestions_provider = "my_openai",
            behaviour = { auto_suggestions = false },
            mappings = {
                -- suggestion = { accept = "<Right>", next = "<Down>", prev = "<Up>" },
                submit = { insert = "<CR>" },
                ask = "<leader>hq",
                edit = "<leader>he",
                refresh = "<leader>hr",
                focus = "<leader>hf",
                toggle = { default = "<leader>hh", debug = "<leader>hd", hint = "<leader>ht", suggestion = "<leader>hs", repomap = "<leader>hR" },
                files = { add_current = "<leader>ha" },
            },
        },
    },
" fzf option breaks live grep preview to show lines at the top rather than matched lines
--preview-window="<40(up,40%)"

" =======================================================
" untildone in nvim
local states = require("states")
local timers = {}
local id = 1
local function is_empty(value)
    return value == nil or value == ""
end
-- terminate and rerun previous command in tmux first window top left pane
function M.restart_tmux_task()
    io.popen("tmux send-keys -t 1.0 -X cancel 2>/dev/null; tmux send-keys -t 1.0 c-c 2>/dev/null"):close()
    vim.schedule(function()
        vim.defer_fn(function()
            local handle = assert(io.popen("tmux send-keys -t 1.0 s-up enter 2>&1"))
            local result = handle:read("*a")
            handle:close()
            if result ~= "" then
                vim.notify(result, vim.log.levels.ERROR, { title = "Restarting tmux task" })
            end
        end, 500)
    end)
end
function M.untildone(command, should_restart_tmux_task, message)
    if not is_empty(should_restart_tmux_task) then
        M.restart_tmux_task()
    end
    if is_empty(command) then
        local jobs = #timers
        for i, timer in pairs(timers) do
            if pcall(timer.close, timer) then
                states.untildone_count = states.untildone_count - 1
                table.remove(timers, i)
            end
        end
        vim.notify("Number of jobs stoped: " .. jobs - #timers .. "\nNumber of jobs running: " .. #timers,
            vim.log.levels.INFO, { title = "All loop stopped" })
        return
    end
    local timer = vim.uv.new_timer()
    local timer_id = id
    id = id + 1
    timers[timer_id] = timer
    states.untildone_count = states.untildone_count + 1
    vim.notify(command, vim.log.levels.INFO, { title = "Loop started" })
    timer:start(1000, 1000, function()
        local handle = assert(io.popen(command .. " 2>&1; echo $?"))
        local result = handle:read("*a")
        handle:close()
        if result:match(".*%D(%d+)") == "0" then
            states.untildone_count = states.untildone_count - 1
            vim.notify(message or "Command succeeded", vim.log.levels.INFO, { title = "Loop stopped", icon = "" })
            timer:close()
            table.remove(timers, timer_id)
        end
    end)
end
                                require("states").untildone_count == 0 and "󰉡" or " " .. require("states").untildone_count,

" =======================================================
    {
        "ramilito/kubectl.nvim",
        opts = {
            kubectl_cmd = {
                cmd = "kubectl",
                env = function()
                    local result = {}
                    local varNames = { "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_SESSION_TOKEN", "AWS_DEFAULT_REGION", "AWS_DEFAULT_OUTPUT" }
                    for _, var in ipairs(varNames) do
                        result[var] = os.getenv(var)
                    end
                    return result
                end,
            },
        },
    },
    {
        "HakonHarnes/img-clip.nvim",
        enabled = vim.env.SSH_CLIENT == nil,
        keys = { { "<leader>p", "<Esc><Cmd>PasteImage<CR>", mode = "i" } },
        opts = { default = { use_cursor_in_template = false, insert_mode_after_paste = false, relative_to_current_file = true } },
    },

" =======================================================
mise() {
  unset -f mise
  eval "$(mise activate zsh)"
  mise "$@"
}

" =======================================================
ai(){
  OPENAI_MODEL=${OPENAI_MODEL:-$(curl -s -X GET "$OPENAI_API_BASE/models" -H "Authorization: Bearer $OPENAI_API_KEY" -H "Content-Type: application/json" | jq -r '.data[0].id')}
  curl -s -N "$OPENAI_API_BASE/chat/completions" -H "Accept: text/event-stream" -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API_KEY" -d '{
    "model": "'"$OPENAI_MODEL"'",
    "messages": [{"role": "user", "content": "Answer the question, be concise. '"${*// /+}"'"}],
    "stream": true
  }' | sed -e '/id/!d' -e 's/^data: //' | jq --unbuffered --stream -r -j 'fromstream(inputs).choices[].delta.content | select(. != null)'
  echo
}
" nvim 0.11 terminal supports osc52
# if called from nvim terminal (:h v:servername), look upwards to find tty of the nvim process
if [[ -n $NVIM ]]; then
  if [[ -d /proc ]]; then
    while [[ -n $ppid ]]; do
      if [[ $(< "/proc/$ppid/comm") = *nvim ]]; then
        otty="$(readlink "/proc/$ppid/fd/0")" && [[ $otty != /dev/null ]] && break
      fi
      ppid=$(awk '/PPid/ {print $2}' "/proc/$ppid/status")
    done
  else
    while [[ -n $ppid ]]; do
      read -r ppid tty comm < <(ps -p "$ppid" -o ppid= -o tty= -o comm=)
      if [[ $comm = *nvim ]]; then
        otty="/dev/$tty" && [[ $otty != /dev/\?* ]] && break
      fi
    done
  fi
fi

" =======================================================
    {
        "folke/flash.nvim",
        keys = {
            { "'", "<Cmd>lua require('utils').command_without_quickscope(require('flash').jump)<CR>", mode = { "n", "x", "o" } },
            { "<leader>e", "<Cmd>lua require('utils').command_without_quickscope(require('flash').treesitter)<CR>", mode = { "n", "x", "o" } },
            { "r", "<Cmd>lua require('utils').command_without_quickscope(require('flash').treesitter_search)<CR>", mode = { "o" } },
        },
        opts = { label = { uppercase = false, before = true, after = false }, jump = { autojump = true }, modes = { char = { enabled = false } } },
    },
            {
                "K",
                function()
                    vim.fn["quickui#context#open"]({
                        { "Docu&mentation", "lua vim.lsp.buf.hover()", "Show documentation" },
                        { "Declaration", "lua vim.lsp.buf.declaration()", "Go to declaration" },
                        { "Line diagnostic", "lua vim.diagnostic.open_float({ scope = 'line', border = 'single' })", "Show diagnostic of current line" },
                        { "G&enerate doc", "lua require('neogen').generate()", "Generate annotations with neogen" },
                        { "--", "" },
                        { "Built-in d&ocs", [[execute &filetype == "lua" ? "help " . expand('<cword>') : "normal! K"]], "Open vim built in help" },
                    }, { index = vim.g["quickui#context#cursor"] or -1 })
                end,
            },
    vim.keymap.set("n", "K", "<Cmd>execute index(['lua', 'vim', 'help'], &filetype) >= 0 ? 'help ' . expand('<cword>') : 'lua vim.lsp.buf.hover()'<CR>")
    vim.keymap.set("n", "gh", "<Cmd>lua if vim.diagnostic.open_float({ scope = 'cursor', border = 'single' }) == nil then vim.lsp.buf.hover() end<CR>")
---@type vim.lsp.Config
return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    single_file_support = true,
    init_options = {
        hostInfo = "neovim",
        preferences = {
            importModuleSpecifierPreference = "shortest",
            includeInlayParameterNameHints = "all",
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
        },
    },
}
    if vim.tbl_contains(active_clients, "typescript-language-server") then
        vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
            title = "",
        }, 3000)
function M.restart_lsp()
    local clients = vim.lsp.get_clients()
    vim.lsp.stop_client(clients, true)
    assert(vim.uv.new_timer()):start(500, 0, function()
        for _, _client in ipairs(clients) do
            vim.schedule_wrap(function(client)
                vim.lsp.enable(client.name)
                vim.cmd.edit()
            end)(_client)
        end
    end)
end

" =======================================================
    {
        "milanglacier/minuet-ai.nvim",
        enabled = vim.env.VIM_AI == "minuet" and vim.env.OPENAI_API_BASE ~= nil,
        event = "VeryLazy", -- InsertEnter isn't working
        opts = {
            n_completions = 1,
            add_single_line_entry = false,
            cmp = { enable_auto_complete = false },
            blink = { enable_auto_complete = false },
            provider = "openai_compatible",
            provider_options = {
                openai_compatible = {
                    api_key = "OPENAI_API_KEY",
                    name = "my_openai",
                    end_point = ("%s/chat/completions"):format(vim.env.OPENAI_API_BASE),
                    stream = true,
                    model = vim.env.AIDER_WEAK_MODEL,
                },
            },
            virtualtext = {
                auto_trigger_ft = { "*" },
                auto_trigger_ignore_ft = vim.g.qs_filetype_blacklist,
                keymap = { accept = "<Right>", accept_line = "<A-a>", prev = "<Up>", next = "<Down>", dismiss = "<A-e>" },
            },
        },
    },
    {
        "augmentcode/augment.vim",
        enabled = vim.env.VIM_AI == "augment",
        event = "InsertEnter",
        cmd = "Augment",
        keys = { { "<leader>h", "<Cmd>Augment chat<CR>", mode = { "n", "x" } }, { "<leader>H", "<Cmd>Augment chat-toggle<CR>", mode = { "n", "x" } } },
        init = function()
            vim.g.augment_disable_tab_mapping = true
            -- vim.g.augment_workspace_folders = { vim.uv.cwd() }
        end,
        config = function() vim.keymap.set("i", "<Right>", function() vim.fn["augment#Accept"](vim.keycode("<C-g>U<Right>")) end) end,
    },
    {
        "monkoose/neocodeium",
        enabled = vim.env.VIM_AI == "codeium",
        event = "InsertEnter",
        config = function()
            vim.keymap.set("i", "<Right>", function()
                if require("neocodeium").visible() then return require("neocodeium").accept() end
                vim.api.nvim_feedkeys(vim.keycode("<C-g>U<Right>"), "n", false)
            end)
            vim.keymap.set("i", "<Down>", function()
                if require("neocodeium").visible() then return require("neocodeium").cycle(1) end
                vim.api.nvim_feedkeys(vim.keycode("<Down>"), "n", false)
            end)
            vim.keymap.set("i", "<Up>", function()
                if require("neocodeium").visible() then return require("neocodeium").cycle(-1) end
                vim.api.nvim_feedkeys(vim.keycode("<Up>"), "n", false)
            end)
            require("neocodeium").setup({ filetypes = require("states").qs_disabled_filetypes, silent = true, debounce = true })
        end,
    },
    {
        "supermaven-inc/supermaven-nvim",
        enabled = vim.env.VIM_AI == "supermaven",
        event = "InsertEnter",
        config = function()
            require("supermaven-nvim").setup({
                disable_keymaps = true,
                condition = function() return require("states").qs_disabled_filetypes[vim.o.filetype] == false end,
            })
            vim.keymap.set("i", "<Right>", function()
                local suggestion = require("supermaven-nvim.completion_preview")
                if suggestion.has_suggestion() then return suggestion.on_accept_suggestion() end
                vim.api.nvim_feedkeys(vim.keycode("<C-g>U<Right>"), "n", false) -- <C-g>U is for multicursor.nvim
            end)
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        enabled = vim.env.OPENAI_API_KEY ~= nil,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            { "ravitemer/mcphub.nvim", build = "npm install -g mcp-hub@latest", cmd = "MCPHub", opts = { auto_approve = true } },
        },
        keys = { { "<leader>h", "<Cmd>CodeCompanionChat Toggle<CR>" }, { "<leader>h", "<Cmd>CodeCompanionActions<CR>", mode = { "x" } } },
        config = function()
            require("codecompanion").setup({
                display = { action_palette = { provider = "snacks" } },
                adapters = {
                    http = {
                        my_openai = function()
                            return require("codecompanion.adapters").extend("openai_compatible", {
                                schema = { model = { default = vim.env.OPENAI_MODEL } },
                                env = { url = vim.env.OPENAI_API_BASE, chat_url = "/chat/completions" },
                            })
                        end,
                    },
                },
                strategies = {
                    chat = {
                        adapter = "my_openai",
                        keymaps = {
                            send = { modes = { n = "<leader>r", i = "<leader>r" } },
                            stop = { modes = { n = "<C-c>", i = "<C-c>" } },
                            close = { modes = { n = "<leader>x" } },
                            completion = { modes = { i = "<C-n>" } },
                            previous_chat = { modes = { n = "<BS>" } },
                            next_chat = { modes = { n = "\\" } },
                        },
                        slash_commands = { ["file"] = { opts = { provider = "snacks" } }, ["buffer"] = { opts = { provider = "snacks" } } },
                        opts = { completion_provider = "default" },
                    },
                    inline = { adapter = "my_openai" },
                },
                extensions = {
                    mcphub = { callback = "mcphub.extensions.codecompanion", opts = { show_result_in_chat = true, make_vars = true, make_slash_commands = true } },
                },
            })
            local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
            vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionChatCreated",
                group = group,
                command = "call nvim_buf_set_lines(0, 2, 2, v:false, ['#{buffer}{watch}']) | nnoremap <buffer> ]\\ <C-w>p<Cmd>CodeCompanionChat<CR>",
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionChatSubmitted",
                group = group,
                callback = function()
                    require("blink.cmp").hide()
                    vim.cmd.stopinsert()
                end,
            })
            vim.api.nvim_create_autocmd("User", { pattern = "CodeCompanionRequestStarted", group = group, callback = function() require("states").loading = true end })
            vim.api.nvim_create_autocmd("User", { pattern = "CodeCompanionRequestFinished", group = group, callback = function() require("states").loading = false end })
        end,
    },
local qs_disabled_filetypes = { ["."] = false } -- neocodeium has "." = false
    vim.api.nvim_set_hl(0, "NeoCodeiumSuggestion", { link = "LspCodeLens" })
                        if package.loaded["neocodeium"] ~= nil then
                            local serverstatus = require("neocodeium").get_status() -- https://www.reddit.com/r/neovim/comments/1fc34na/comment/lm5wr1j
                            if serverstatus == 0 then
                                icon = " " -- Connected
                            elseif serverstatus == 1 then
                                icon = "󰣻 " -- Connection Error
                            elseif serverstatus == 2 then
                                icon = "󰣽 " -- Disconnected
                            else
                                icon = "󰣼 " -- Unknown
                            end
                        end
    " markdown preview in lua, xml encodes characters in code block
    { "brianhuster/live-preview.nvim", cmd = "LivePreview" },

" =======================================================
zmodule zsh-users/zsh-completions --fpath src
scoop bucket add versions
scoop bucket add java
scoop install openjdk21
scoop install python
reg import "$env:USERPROFILE\scoop\apps\python\current\install-pep-514.reg"
scoop install nodejs18@18.19.0
npm install yarn -g
echo "To install and switch other versions: scoop install openjdk17; scoop reset openjdk17"
" this has argument descriptions in completions, but doesn't support 'docker compose'
curl -fsSL -o ~/.vim/config/zsh/completions/_docker https://raw.githubusercontent.com/docker/cli/HEAD/contrib/completion/zsh/_docker

" =======================================================
" cmd starship is slow
Add-Content -Path "$env:LocalAppData\clink\starship.lua" -Value "load(io.popen('starship init cmd'):read('*a'))()"
git clone --depth=1 https://github.com/vladimir-kotikov/clink-completions "$env:USERPROFILE\scoop\others\clink-completions"
clink installscripts "$env:USERPROFILE\scoop\others\clink-completions"
git clone --depth=1 https://github.com/chrisant996/clink-gizmos "$env:USERPROFILE\scoop\others\clink-gizmos"
clink installscripts "$env:USERPROFILE\scoop\others\clink-gizmos"
## enable sshd on ec2
if ((Get-WmiObject -Class Win32_ComputerSystem).Manufacturer -match 'Amazon EC2') {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Set-Service -Name sshd -StartupType 'Automatic'
    Start-Service sshd
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:USERPROFILE\scoop\shims\bash.exe" -PropertyType String -Force
}

" =======================================================
    {
        "MunifTanjim/nui.nvim",
        init = function()
            vim.ui.input = (function(overridden)
                return function(...)
                    local present = pcall(require, "nui.input")
                    if not present then vim.ui.input = overridden end
                    vim.ui.input(...)
                end
            end)(vim.ui.input)
        end,
        config = function() -- https://github.com/MunifTanjim/nui.nvim/wiki/vim.ui, https://github.com/MunifTanjim/dotfiles/tree/8c13a4e05359bb12f9ade5abc1baca6fcec372db/private_dot_config/nvim/lua/plugins/lsp/custom
            local function get_prompt_text(prompt)
                local prompt_text = prompt or "[Input]"
                if prompt_text:sub(-1) == ":" then prompt_text = "[" .. prompt_text:sub(1, -2) .. "]" end
                return prompt_text
            end
            local UIInput = require("nui.input"):extend("UIInput")
            local input_ui = nil
            function UIInput:init(opts, on_done)
                local default_value = tostring(opts.default or "")
                local cursor = vim.api.nvim_win_get_cursor(0)
                UIInput.super.init(self, {
                    relative = { type = "buf", position = { row = cursor[1], col = cursor[2] } }, -- use buf to avoid cursor shifting before on_submit
                    position = { row = 1, col = 0 },
                    size = { width = math.max(40, vim.api.nvim_strwidth(default_value) + 20) },
                    border = { style = "rounded", text = { top = get_prompt_text(opts.prompt), top_align = "left" } },
                    win_options = { winhighlight = "NormalFloat:Normal,FloatBorder:Normal" },
                    buf_options = { filetype = "nui_input" },
                }, {
                    default_value = default_value,
                    on_close = function() on_done(nil) end,
                    on_submit = function(value) on_done(value) end,
                })
                self:map("n", "<CR>", function(value) on_done(value) end, { noremap = true, nowait = true })
                self:map("n", "<Esc>", function() on_done(nil) end, { noremap = true, nowait = true })
                self:map("n", "q", function() on_done(nil) end, { noremap = true, nowait = true })
                self:on(require("nui.utils.autocmd").event.BufLeave, function() on_done(nil) end, { once = true })
            end
            vim.ui.input = function(opts, on_confirm)
                assert(type(on_confirm) == "function", "missing on_confirm function")
                if input_ui then return end
                input_ui = UIInput(opts, function(value)
                    if input_ui then input_ui:unmount() end
                    on_confirm(value)
                    input_ui = nil
                end)
                input_ui:mount()
            end
        end,
    },

" =======================================================
export AIDER_DARK_MODE=true
export AIDER_GITIGNORE=false
export AIDER_CACHE_PROMPTS=true
export AIDER_SHOW_MODEL_WARNINGS=false
export AIDER_MAP_TOKENS=3000
export AIDER_MODEL=us.anthropic.claude-sonnet-4-20250514-v1:0  # us.anthropic.claude-3-7-sonnet-20250219-v1:0
export AIDER_WEAK_MODEL=anthropic.claude-3-5-haiku-20241022-v1:0
export AIDER_EDIT_FORMAT=diff
export AIDER_ATTRIBUTE_AUTHOR=false
export AIDER_ATTRIBUTE_COMMITTER=false
export AIDER_ATTRIBUTE_CO_AUTHORED_BY=false
export AIDER_SUBTREE_ONLY=true
export AIDER_WATCH_FILES=true
alias aider='AWS_ACCESS_KEY_ID= AWS_SECRET_ACCESS_KEY= AWS_SESSION_TOKEN= AWS_PROFILE=bedrock-prod \aider'
local aider_cmd = nil
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>i",
                function()
                    if aider_cmd then return require("snacks.terminal").toggle(aider_cmd, { win = { position = "right" } }) end
                    vim.env.AWS_ACCESS_KEY_ID = nil
                    vim.env.AWS_SECRET_ACCESS_KEY = nil
                    vim.env.AWS_SESSION_TOKEN = nil
                    vim.env.AWS_PROFILE = "bedrock-prod"
                    local function get_name(buf)
                        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
                            local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
                            if name ~= "" and name:find("^/") == nil and name:find("^%w+://") == nil then return name end
                        end
                    end
                    local files = {}
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        local name = get_name(buf)
                        if name then files[name] = true end
                    end
                    aider_cmd = vim.list_extend({ "aider" }, vim.tbl_keys(files))
                    local terminal = require("snacks.terminal").toggle(aider_cmd, { win = { position = "right" } })
                    local buf = terminal.buf
                    local channel = vim.bo[buf].channel
                    vim.keymap.set("t", "<C-b>", function()
                        local aider_win = vim.api.nvim_get_current_win()
                        require("snacks.picker").buffers({
                            confirm = function(picker, item)
                                picker:close()
                                vim.fn.chansend(channel, (" `%s` "):format(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(item.buf), ":t:r")))
                            end,
                            on_close = function()
                                vim.api.nvim_set_current_win(aider_win)
                                vim.schedule(vim.cmd.startinsert)
                            end,
                        })
                    end, { buffer = buf })
                    vim.keymap.set("t", "<C-p>", function()
                        local aider_win = vim.api.nvim_get_current_win()
                        vim.cmd.wincmd("p")
                        require("snacks.picker")[require("lsp").is_active() and "lsp_symbols" or "treesitter"]({
                            confirm = function(picker, item)
                                picker:close()
                                vim.fn.chansend(channel, (" `%s` "):format(item.name))
                            end,
                            on_close = function()
                                vim.api.nvim_set_current_win(aider_win)
                                vim.schedule(vim.cmd.startinsert)
                            end,
                        })
                    end, { buffer = buf })
                    vim.api.nvim_create_augroup("Aider", {})
                    vim.api.nvim_create_autocmd("BufEnter", { group = "Aider", buffer = buf, command = "startinsert" })
                    vim.api.nvim_create_autocmd("BufDelete", {
                        group = "Aider",
                        callback = function(e)
                            local name = get_name(e.buf)
                            if name and files[name] ~= nil then
                                vim.fn.chansend(channel, ("/drop %s\n"):format(name))
                                files[name] = nil
                            end
                        end,
                    })
                    vim.api.nvim_create_autocmd("BufReadPost", {
                        group = "Aider",
                        callback = function(e)
                            vim.schedule(function() -- wrap in schedule to run after buflisted when opening with mini.nvim
                                local name = get_name(e.buf)
                                if name and files[name] == nil then
                                    vim.fn.chansend(channel, ("/add %s\n"):format(name))
                                    files[name] = true
                                end
                            end)
                        end,
                    })
                    vim.api.nvim_create_autocmd("TermClose", {
                        group = "Aider",
                        callback = function(e)
                            if e.buf ~= buf then return end
                            vim.api.nvim_del_augroup_by_name("Aider")
                            files = nil
                            aider_cmd = nil
                        end,
                    })
                end,
            },
        },
    },
# lazygit
customCommands:
  - key: C
    context: files
    command: AWS_ACCESS_KEY_ID= AWS_SECRET_ACCESS_KEY= AWS_SESSION_TOKEN= AWS_PROFILE=bedrock-prod aider --commit
    output: terminal

" =======================================================
  if ! docker image ls | grep -q ubuntu_vim; then
    docker build --network host -t ubuntu_vim -f ~/.vim/Dockerfile ~/.vim || return 1
    echo -e "\n\nFinished building image. To commit new change: docker commit vim_container ubuntu_vim"
  fi
  # shellcheck disable=2046
  case $1 in
    vim-once) docker run --network host -it --name vim_container_temp --rm ubuntu_vim; return $? ;;
    vim-remove) docker container rm $(docker ps -aq --filter ancestor=ubuntu_vim) && docker image rm ubuntu_vim; return $? ;;
    vim-build) docker build --network host -t ubuntu_vim -f ~/.vim/Dockerfile ~/.vim; return $? ;;
    vim) local container_name=${2:-vim_container} ;;
    *) echo -e "Usage: $0 {vim-once|vim-remove|vim-build|vim [container-name]}\nReceived argument $1, exiting.." >&2; return 1 ;;
  esac
  local running=$(docker inspect -f '{{.State.Running}}' "$container_name" 2> /dev/null)
  if [[ $running = true ]]; then
    echo 'Starting shell in running container..'; docker exec -it "$container_name" zsh
  elif [[ $running = false ]]; then
    echo 'Starting stopped container..'; docker start -ai "$container_name"
  else
    echo "Starting new container ($container_name) with host network and docker socket mapped.."
    mkdir -p ~/.local/docker-share
    docker run --network host -v /var/run/docker.sock:/var/run/docker.sock -v ~/.local/docker-share:/docker-share -it --name "$container_name" ubuntu_vim
  fi

" =======================================================
" minidiff and fugitive
            { "<leader>gd", "<Cmd>lua require('mini.diff').toggle_overlay()<CR>" },
            { "<leader>ga", "<leader>gAig", remap = true },
            { "<leader>gu", "<leader>gUig", remap = true },
                require("mini.diff").setup({
                    view = { style = "sign", signs = { add = "▎", change = "░", delete = "▏" } },
                    mappings = { apply = "<leader>gA", reset = "<leader>gU", textobject = "ig", goto_first = "[G", goto_prev = "[g", goto_next = "]g", goto_last = "]G" },
                    options = { wrap_goto = true },
                    source = { require("mini.diff").gen_source.git(), require("mini.diff").gen_source.save() },
                })
                            local summary = vim.b.minidiff_summary
                            if summary then return { added = summary.add, modified = summary.change, removed = summary.delete } end
    {
        "rbong/vim-flog",
        dependencies = {
            "tpope/vim-fugitive",
            {
                "ja-he/heat.nvim",
                opts = { colors = { [1] = { value = 0, color = { 0, 0, 0 } }, [2] = { value = 0.95, color = { 0.75, 0.75, 0.75 } }, [3] = { value = 1, color = { 1, 1, 1 } } } },
            },
        },
        ft = "gitcommit", -- issue number omni-completion, does not work if cloned with url.replacement.insteadOf
        cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gclog", "Greset", "Flog" },
        keys = {
            { "<leader>gf", "<Cmd>.Flogsplit<CR>" },
            { "<leader>gf", ":Flogsplit<CR>", mode = { "x" } },
            -- { "<leader>gb", "<Cmd>0,.Git blame<CR>" },
            { "<leader>gc", "<Cmd>Git commit --signoff<CR>" },
            { "<leader>f~", "<Cmd>Git mergetool<CR>" },
        },
        config = function()
            vim.g.fugitive_summary_format = "%d %s (%cr) <%an>"
            vim.keymap.set("ca", "git", "<C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'Git' : 'git')<CR>")
            vim.api.nvim_create_user_command("Greset", "Git reset %", {})
            vim.api.nvim_create_autocmd("User", {
                pattern = "FugitiveIndex",
                group = "AutoCommands",
                callback = function() vim.keymap.set("n", "dt", ":Gtabedit <Plug><cfile><bar>Gdiffsplit! @<CR>", { silent = true, buffer = true }) end,
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "fugitiveblame", -- https://github.com/tpope/vim-fugitive/issues/543#issuecomment-1875806353
                group = "AutoCommands",
                callback = function()      -- '-' to reblame at commit, '~' to blame prior to commit, '_' to go back, '+' to go forward
                    vim.keymap.set("n", "_", "<Cmd>quit<CR><C-o><Cmd>Git blame<CR>", { buffer = true })
                    vim.keymap.set("n", "+", "<Cmd>quit<CR><C-i><Cmd>Git blame<CR>", { buffer = true })
                end,
            })
        end,
    },
                { "Git checko&ut ref", [[call feedkeys(":Gread @:%\<Left>\<Left>", "n")]], "Checkout current file from ref and load as unsaved buffer (Gread HEAD:%)" },
                { "Git &blame", [[Git blame]], "Git blame of current file" },
                { "Git &diff", [[Gdiffsplit]], "Diff current file with last staged version (Gdiffsplit)" },
                { "Git diff H&EAD", [[Gdiffsplit HEAD:%]], "Diff current file with last committed version (Gdiffsplit HEAD:%)" },
                { "Git file history", [[vsplit | execute "lua require('lazy').load({plugins = 'vim-flog'})" | 0Gclog]], "Browse previously committed versions of current file" },
                { "--", "" },
                { "Git &status", [[Git]], "Git status" },
                { "Git l&og", [[Flog]], "Show git logs with vim-flog" },
                { "--", "" },
                { "Git search current", [[call feedkeys(":Git log --all --name-status -S '' -- %\<Left>\<S-Left>\<Left>\<Left>", "n")]], "Search a string in all committed versions of current file, command: git log -p --all -S '<pattern>' --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- %" },
                { "Git search &all", [[call feedkeys(":Git log --all --name-status -S ''\<Left>", "n")]], "Search a string in all committed versions of files, command: git log -p --all -S '<pattern>' --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>" },
                { "Git gre&p all", [[call feedkeys(":Git log --all --name-status -i -G ''\<Left>", "n")]], "Search a regex in all committed versions of files, command: git log -p --all -i -G '<pattern>' --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>" },
                { "Git fi&nd files all", [[call feedkeys(":Git log --all --name-status -- '**'\<Left>\<Left>", "n")]], "Grep file names in all commits" },
                " visual
                { "Git file history", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | vsplit | '<,'>Gclog]], "Browse previously committed versions of selected range" },
                { "Git l&og", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | '<,'>Flogsplit]], "Show git log of selected range with vim-flog" },
                { "Git &search", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | execute "Git log --all --name-status -S '" . substitute(funcs#get_visual_selection(), "'", "''", 'g') . "'"]], "Search selected in all committed versions of files" },

" =======================================================
    {
        "iamcco/markdown-preview.nvim",
        enabled = vim.env.SSH_CLIENT == nil,
        build = "cd app && yarn install",
        cmd = "MarkdownPreview",
        init = function()
            vim.g.mkdp_auto_close = 0
            vim.g.mkdp_preview_options = { disable_sync_scroll = 1 }
        end,
        config = function() vim.cmd.doautocmd("FileType") end, -- trigger autocmd to define MarkdownPreview command for buffer
    },
    { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" }, opts = { view = { merge_tool = { layout = "diff1_plain" } } } },
                { "Diffview &file history", [[DiffviewFileHistory % --follow]], "Browse previously committed versions of current file with Diffview" },
                { "Diffview &file history", [['<,'>DiffviewFileHistory --follow]], "Browse previously committed versions of selected range with Diffview" },
            vim.api.nvim_create_user_command("Gdiffsplit", lua require('gitsigns').diffthis(<q-args>, {split = 'aboveleft'}, function() vim.api.nvim_win_set_option(vim.fn.win_getid(vim.fn.winnr('#')), 'winbar', '%f') end)", { nargs = "*" }) -- git diff <ref> -- %

" =======================================================
" diff-so-fancy
install-from-url diff-so-fancy https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy "$@"
	diffw = -c core.pager='diff-so-fancy | less --tabs=4 -RiMXF' diff --word-diff=color --ignore-all-space
	diff-so-fancy = -c core.pager='diff-so-fancy | less --tabs=4 -RiMXF' diff
	pager = diff-so-fancy | less -RiMXF
	diffFilter = diff-so-fancy --patch
[diff-so-fancy]
	stripLeadingSymbols = false

" =======================================================
  { on = ["m", "s"], run = '''shell --block -- du -sbc %s | awk 'function hr(bytes) { hum[1099511627776]="TiB"; hum[1073741824]="GiB"; hum[1048576]="MiB"; hum[1024]="kiB"; for (x = 1099511627776; x >= 1024; x /= 1024) { if (bytes >= x) { return sprintf("%%11.6f %%s", bytes/x, hum[x]); } } return sprintf("%%4d     B", bytes); } { printf hr($1) "\t"; $1=""; print $0; }' | grep "total\$"; echo Press any key to continue; bash -c "read -n 1 -s _"''', desc = "Show selected size", for = "unix" },
        if command:match("^size$") then return shell([[du -b --max-depth=1 | sort -nr | head -n 20 | awk 'function hr(bytes) { hum[1099511627776]="TiB"; hum[1073741824]="GiB"; hum[1048576]="MiB"; hum[1024]="kiB"; for (x = 1099511627776; x >= 1024; x /= 1024) { if (bytes >= x) { return sprintf("%%8.3f %%s", bytes/x, hum[x]); } } return sprintf("%%4d     B", bytes); } { printf hr($1) "\t"; $1=""; print $0; }']], true) end
