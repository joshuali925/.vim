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
install-from-url vimv https://raw.githubusercontent.com/thameera/vimv/HEAD/vimv "$@"
install-from-github btm ClementTsang/bottom x86_64-unknown-linux-musl aarch64-unknown-linux x86_64-apple-darwin '' btm "$@"
  # zinit light-mode as"program" from"gh-r" atclone"mv btm $ZPFX/bin" for ClementTsang/bottom
alias btm='btm --config=/dev/null --mem_as_value --process_command --color=gruvbox --basic'
    btm) sudo -E "$(/usr/bin/which btm)" --config=/dev/null --mem_as_value --process_command --color=gruvbox --basic "$@" ;;


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
                    -- TODO @parameter.outer is not supported by most languages, use vim-swap for now
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
  git clone https://github.com/facebook/PathPicker.git ~/.local/python-packages/PathPicker --depth=1
  ln -s ~/.local/python-packages/PathPicker/fpp ~/.local/bin/fpp
  log "Installed bpytop, fpp"
alias fpp='if [ -t 0 ] && [ $# -eq 0 ] && [[ ! $(fc -ln -1) =~ "\| *fpp$" ]]; then eval $(fc -ln -1) | command fpp; else command fpp; fi'


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
" dap, buggy
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
" dirdiff
        use({ "will133/vim-dirdiff", cmd = "DirDiff" })
