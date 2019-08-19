" ==================== Settings ========================= {{{
let g:Theme = -2
let g:Completion = 2  " 0: mucomplete, 1: YCM, 2: coc
let g:PythonPath = 'python'
let g:ExecCommand = ''
" }}}

" ===================== Plugins ========================= {{{
call plug#begin('~/.vim/plugged')
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
" Plug 'mhinz/vim-startify'
" Plug 'w0rp/ale'
" Plug 'sheerun/vim-polyglot'
Plug 'ianding1/leetcode.vim', { 'on': 'LeetCodeList' }
Plug 'skywind3000/quickmenu.vim', { 'on': [] }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'mg979/vim-visual-multi', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-f)'] }
Plug 'dahu/vim-fanfingtastic', { 'on': ['<Plug>fanfingtastic_f', '<Plug>fanfingtastic_t', '<Plug>fanfingtastic_F', '<Plug>fanfingtastic_T'] }
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gdiffsplit'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
Plug 'tpope/vim-surround', { 'on': ['<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround', '<Plug>VgSurround'] }
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'shougo/echodoc.vim', { 'on': [] }
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }  " load on startup to record MRU
Plug 'jiangmiao/auto-pairs'  " lazy load wouldn't work
Plug 'tpope/vim-repeat'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'wellle/targets.vim'
if g:Completion >= 0
    Plug 'sirver/ultisnips', { 'on': [] }
    Plug 'honza/vim-snippets', { 'on': [] }
    Plug 'davidhalter/jedi-vim', { 'on': [] }
endif
if g:Completion == 0
    Plug 'lifepillar/vim-mucomplete'
elseif g:Completion == 1
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --ts-completer --java-completer' }
elseif g:Completion == 2
    " :CocInstall coc-git coc-snippets coc-highlight coc-tsserver coc-html coc-css coc-emmet
    " if doesn't work, use cd ~/.config/coc/extensions && yarn add coc-...
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
call plug#end()
silent! call yankstack#setup()
" }}}

" ===================== Themes ========================== {{{
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
let g:ayucolor='light'
set background=light
if g:Theme < 0
    let g:ayucolor='mirage'
    set background=dark
endif
function! SetTheme()
    let l:Theme_list = {}
    let l:Theme_list[0] = 'solarized8_flat'
    let l:Theme_list[1] = 'PaperColor'
    let l:Theme_list[2] = 'github'
    let l:Theme_list[3] = 'gruvbox'
    let l:Theme_list[4] = 'two-firewatch'
    let l:Theme_list[5] = 'ayu'
    let l:Theme_list[-1] = 'onedark'
    let l:Theme_list[-2] = 'ayu'
    let l:Theme_list[-3] = 'forest-night'
    let l:Theme_list[-4] = 'gruvbox'
    let l:Theme_list[-5] = 'two-firewatch'
    let l:Theme_list[-6] = 'molokai'
    exec 'colorscheme '. get(l:Theme_list, g:Theme, 'solarized8_flat')
endfunction
call SetTheme()
" }}}

" ======================= Basics ======================== {{{
filetype plugin indent on
syntax enable
let &t_SI.="\e[6 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[2 q"
if &compatible | set nocompatible | endif
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
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set textwidth=0
set autoread
set autochdir
set completeopt=menuone
set scrolloff=3
set previewheight=7
set foldmethod=marker
set foldlevel=1
set belloff=all
set history=500
set sessionoptions-=buffer
set undofile
set undolevels=1000
set undoreload=10000
set undodir=~/.cache/vim/undo
set tags=./.tags;,.tags
set path=**
set encoding=utf-8
set timeoutlen=1500
set ttimeoutlen=40
set lazyredraw
set noswapfile
set nowritebackup
set nobackup
set statusline=%<[%{mode()}]\ %f\ %{GetPasteStatus()}%h%m%r%=%-14.(%c/%{len(getline('.'))}%)%l/%L\ %P
" }}}

" ====================== Shortcuts ====================== {{{
let mapleader=';'
nmap <leader>1 <F1>
nmap <leader>2 <F2>
nmap <leader>3 <F3>
nmap <leader>4 <F4>
nmap <leader>5 <F5>
nmap <leader>6 <F6>
nmap <leader>7 <F7>
nmap <leader>8 <F8>
nmap <leader>9 <F9>
nmap <leader>0 <F10>
nmap <leader>- <F11>
nmap <leader>= <F12>
imap <F1> <Esc><F1>
vmap <F1> :<C-u>call LoadQuickmenu()<CR>gv<F1>
nmap <F1> :call LoadQuickmenu()<CR><F1>
imap <F2> <Esc><F2>
nnoremap <F2> gT
imap <F3> <Esc><F3>
nnoremap <F3> gt
nnoremap <F4> *N
imap <F10> <Esc><F10>
nnoremap <F10> :wall <bar> exec '!clear && '. GetRunCommand()<CR>
imap <F11> <Esc><F11>
nnoremap <F11> :wall <bar> exec 'AsyncRun '. GetRunCommand()<CR>
imap <F12> <Esc><F12>
nnoremap <F12> :wall <bar> call RunShellCommand(''. GetRunCommand())<CR>
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
nmap Y y$
noremap 0 ^
noremap ^ 0
nnoremap - $
vnoremap - $h
noremap <Down> gj
noremap <Up> gk
xnoremap @ :call ExecuteMacroOverVisualRange()<CR>
nnoremap Q @q
nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
nnoremap K :call ShowDocs()<CR>
nnoremap U :earlier<CR>
inoremap <CR> <CR><Space><BS>
nnoremap gf <C-w>gf
nnoremap gp `[v`]
nnoremap yp "0p
nnoremap cr :call EditRegister()<CR>
vnoremap " c"<C-r><C-p>""<Esc>
vnoremap ' c'<C-r><C-p>"'<Esc>
vnoremap ( c(<C-r><C-p>")<Esc>
vnoremap [ c[<C-r><C-p>"]<Esc>
vnoremap { c{<C-r><C-p>"}<Esc>
vnoremap <Space> c<Space><C-r><C-p>"<Space><Esc>
nnoremap <C-c> :nohlsearch <bar> silent! AsyncStop!<CR>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
nnoremap <C-b> :NERDTreeTabsToggle<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-w><C-c> <Esc>
nmap <C-w>< <C-w><<C-w>
nmap <C-w>> <C-w>><C-w>
nmap <C-w>+ <C-w>+<C-w>
nmap <C-w>- <C-w>-<C-w>
nmap <C-f> :call LoadAutoformat()<CR><C-f>
imap <C-f> <Esc>:call LoadAutoformat()<CR>V<C-f>A
vmap <C-f> :<C-u>call LoadAutoformat()<CR>gv<C-f>
nmap <C-n> :call LoadVisualMulti()<CR><C-n>
xmap <C-n> :<C-u>call LoadVisualMulti()<CR>gv<C-n>
nmap <leader><C-n> :call LoadVisualMulti()<CR><leader><C-n>
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nmap <leader>o o<Esc>
nmap <leader>O O<Esc>
imap <leader>r <Esc><leader>r
nmap <leader>r <F11>
nnoremap <leader><F2> :-tabmove<CR>
nnoremap <leader><F3> :+tabmove<CR>
nnoremap <leader>ff :LeaderfFile<CR>
nnoremap <leader>fm :LeaderfMru<CR>
nnoremap <leader>fb :LeaderfBufferAll<CR>
nnoremap <leader>fu :LeaderfFunctionAll<CR>
nnoremap <leader>fg :LeaderfRgInteractive<CR>
nnoremap <leader>fl :LeaderfLineAll<CR>
nnoremap <leader>fa :LeaderfSelf<CR>
nnoremap <leader>fs :vertical sfind *
nnoremap <leader>ft :tabfind *
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>h :WhichKey ';'<CR>
nnoremap <leader>l :nohlsearch <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <leader>tm :TableModeToggle<CR>
nnoremap <leader>tE :exec getline('.')<CR>``
inoremap <leader>w <Esc>:update<CR>
inoremap <leader><leader>w <leader><Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :write !sudo tee %<CR>
nnoremap <leader>Q :mksession! ~/.cache/vim/session.vim <bar> wqall!<CR>
nnoremap <leader>L :silent source ~/.cache/vim/session.vim<CR>
nnoremap <leader>q :quit<CR>
vnoremap <leader>q <Esc>:quit<CR>
nnoremap <leader>vim :tabedit $MYVIMRC<CR>
" }}}

" ====================== Autocmd ======================== {{{
augroup AutoCommands
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exec "normal! g'\"zz" | endif  " restore last edit position
    autocmd BufWritePost $MYVIMRC source $MYVIMRC  " auto source vimrc when write
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent exec '!~/.vim/bin/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> :edit! <bar> :redraw!<CR>
    autocmd FileType python set nosmartindent
    autocmd FileType c,cpp,java,javascript inoremap <buffer> ;; <C-o>$;
    autocmd FileType python inoremap <buffer> ;; <C-o>$:
    autocmd FileType python syntax keyword pythonSelf self | highlight def link pythonSelf Special
    autocmd FileType * setlocal formatoptions=jql | let b:args = ''
    autocmd User targets#mappings#user call targets#mappings#extend({'b': {'pair': [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}], 'quote': [{'d':"'"}, {'d':'"'}, {'d':'`'}]}})
augroup END
augroup InsertLazyLoad
  autocmd!
  autocmd InsertEnter * call plug#load('echodoc.vim') | call plug#load('ultisnips') | call plug#load('vim-snippets') | autocmd! InsertLazyLoad
augroup END
" }}}

" ====================== LazyLoad ======================= {{{
function! LoadAutoformat()
    let g:formatters_python = ['yapf']
    nnoremap <C-f> :Autoformat<CR>
    inoremap <C-f> <Esc>V:'<,'>Autoformat<CR>A
    vnoremap <C-f> :'<,'>Autoformat<CR>$
    call plug#load('vim-autoformat')
endfunction
function! LoadVisualMulti()
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
function! ShowDocs()
    if &filetype == 'python'
        let g:jedi#auto_initialization = 1
        let g:jedi#auto_vim_configuration = 0
        let g:jedi#completions_enabled = 0
        let g:jedi#show_call_signatures = '2'
        let g:jedi#documentation_command = 'K'
        let g:jedi#rename_command = '<leader><C-r>'
        let g:jedi#goto_command = '<leader>d'
        let g:jedi#usages_command = '<leader>a'
        call plug#load('jedi-vim')
        call jedi#show_documentation()
    else
        normal! K
    endif
endfunction
function! LoadQuickmenu()
    nnoremap <F1> :call quickmenu#toggle(0) <bar> set showcmd<CR>
    vnoremap <F1> :<C-u>call quickmenu#toggle(2) <bar> set showcmd<CR>
    call plug#load('quickmenu.vim')
    let g:quickmenu_options = 'HL'
    call g:quickmenu#reset()
    call g:quickmenu#current(0)
    call g:quickmenu#header('QvQ')
    call g:quickmenu#append('# Actions', '')
    call g:quickmenu#append('Insert Line', 'call InsertCommentLine()', 'Insert a dividing line')
    call g:quickmenu#append('Insert Time', "put=strftime('%x %X')", 'Insert MM/dd/yyyy hh:mm:ss tt')
    call g:quickmenu#append('Git Diff', 'Gdiffsplit', 'Fugitive git diff')
    call g:quickmenu#append('Git Status', 'Gstatus', 'Fugitive git status')
    call g:quickmenu#append('Word Count', 'call feedkeys("g\<C-g>")', 'Show document details')
    call g:quickmenu#append('Tabular Menu', 'call g:quickmenu#toggle(1)', 'Use Tabular to align selected text')
    call g:quickmenu#append('# Toggle', '')
    call g:quickmenu#append('NERDTree', 'NERDTreeTabsToggle', 'Toggle NERDTree')
    call g:quickmenu#append('Netrw', 'Lexplore', 'Toggle Vim Netrw')
    call g:quickmenu#append('Undo Tree', 'UndotreeToggle', 'Toggle Undotree')
    call g:quickmenu#append('Tagbar', 'TagbarToggle', 'Toggle Tagbar')
    call g:quickmenu#append('Table Mode', 'TableModeToggle', 'Toggle TableMode')
    call g:quickmenu#append('Diff %{g:DiffOn==1? "[x]" :"[ ]"}', 'call ToggleDiff()', 'Toggle diff in current window')
    call g:quickmenu#append('Fold %{g:FoldOn==1? "[x]" :"[ ]"}', 'call ToggleFold()', 'Toggle fold by indent')
    call g:quickmenu#append('Paste %{&paste? "[x]" :"[ ]"}', 'call TogglePaste()', 'Toggle paste mode')
    call g:quickmenu#append('Spelling %{&spell? "[x]" :"[ ]"}', 'set spell!', 'Toggle spell checker')
    call g:quickmenu#append('Preview %{g:PreviewOn==1? "[x]" :"[ ]"}', 'call TogglePreview()', 'Toggle function preview')
    call g:quickmenu#current(1)
    call g:quickmenu#header('Tabular Normal Mode')
    call g:quickmenu#append('# Center Delimiter', '')
    call g:quickmenu#append('Align Using =', 'Tabularize /=')
    call g:quickmenu#append('Align Using ,', 'Tabularize /,')
    call g:quickmenu#append('Align Using |', 'Tabularize /|')
    call g:quickmenu#append('Align Using :', 'Tabularize /:')
    call g:quickmenu#append('# Fixed Delimiter', '')
    call g:quickmenu#append('Align Using =', 'Tabularize /=\zs')
    call g:quickmenu#append('Align Using ,', 'Tabularize /,\zs')
    call g:quickmenu#append('Align Using |', 'Tabularize /|\zs')
    call g:quickmenu#append('Align Using :', 'Tabularize /:\zs')
    call g:quickmenu#current(2)
    call g:quickmenu#header('Tabular Visual Mode')
    call g:quickmenu#append('# Center Delimiter', '')
    call g:quickmenu#append('Align Using =', "'<,'>Tabularize /=")
    call g:quickmenu#append('Align Using ,', "'<,'>Tabularize /,")
    call g:quickmenu#append('Align Using |', "'<,'>Tabularize /|")
    call g:quickmenu#append('Align Using :', "'<,'>Tabularize /:")
    call g:quickmenu#append('# Fixed Delimiter', '')
    call g:quickmenu#append('Align Using =', "'<,'>Tabularize /=\\zs")
    call g:quickmenu#append('Align Using ,', "'<,'>Tabularize /,\\zs")
    call g:quickmenu#append('Align Using |', "'<,'>Tabularize /|\\zs")
    call g:quickmenu#append('Align Using :', "'<,'>Tabularize /:\\zs")
    call g:quickmenu#append('# Sort', '')
    call g:quickmenu#append('Sort Asc', "'<,'>sort", 'Sort in ascending order')
    call g:quickmenu#append('Sort Desc', "'<,'>sort!", 'Sort in descending order')
    call g:quickmenu#append('Sort Num Asc', "'<,'>sort n", 'Sort numerically in ascending order')
    call g:quickmenu#append('Sort Num Desc', "'<,'>sort! n", 'Sort numerically in descending order')
endfunction
" }}}

" ====================== Functions ====================== {{{
function! InsertCommentLine()
    exec 'normal! o'
    exec 'normal! 55i='
    exec 'Commentary'
endfunction
function! ExecuteMacroOverVisualRange()
    echo '@'.getcmdline()
    exec ":'<,'>normal! @". nr2char(getchar())
endfunction
function! EditRegister() abort
    let l:r = nr2char(getchar())
    call feedkeys("q:ilet @". l:r. " = \<C-r>\<C-r>=string(@". l:r. ")\<CR>\<Esc>0f'", 'n')
endfunction
let g:DiffOn = 0
function! ToggleDiff()
    if g:DiffOn == 0
        exec 'windo diffthis'
    else
        exec 'windo diffoff'
    endif
    let g:DiffOn = 1 - g:DiffOn
endfunction
let g:FoldOn = 0
function! ToggleFold()
    if g:FoldOn == 0
        set foldmethod=indent
        exec 'normal! zM'
    else
        set foldmethod=marker
        exec 'normal! zR'
    endif
    let g:FoldOn = 1 - g:FoldOn
endfunction
" shift alt drag to select and copy
function! TogglePaste()
    if &paste
        set nopaste number mouse=nv signcolumn=auto
    else
        set paste nonumber norelativenumber mouse= signcolumn=no
    endif
endfunction
function! GetPasteStatus()
    if &paste
        return '[paste]'
    else
        return ''
    endif
endfunction
let g:PreviewOn = 0
function! TogglePreview()
    if g:PreviewOn == 0
        set completeopt+=preview
        echo 'Preview on'
    else
        set completeopt-=preview
        exec 'pclose'
        echo 'Preview off'
    endif
    let g:PreviewOn = 1 - g:PreviewOn
endfunction
" }}}

" =================== Other plugins ===================== {{{
" let g:ale_sign_column_always = 1
" let g:ale_lint_on_text_changed = 'normal'
" let g:ale_lint_on_insert_leave = 1
" let g:ale_python_flake8_executable = 'flake8'
" let g:ale_python_flake8_options = '--ignore=W291,W293,W391,E261,E302,E305,E501'
let g:asyncrun_open = 12
let g:AutoPairsShortcutFastWrap = '<C-l>'
let g:AutoPairsShortcutBackInsert = '<C-b>'
let g:EasyMotion_smartcase = 1
let g:NERDTreeWinSize = 23
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:netrw_dirhistmax = 0  " built in :Lexplore<CR> settings, replaced by NERDTree
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
set wildignore+=*/tmp/*,*/\.git/*,*/\.oh-my-zsh/*,*/node_modules/*,*/venv/*,*/\.env/*  " do NOT wildignore plugged
let g:Lf_WildIgnore = { 'dir':['tmp','.git','.oh-my-zsh','plugged','node_modules','venv','.env','.local','.idea','*cache*'],'file':[] }
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_ReverseOrder = 1
let g:Lf_ShortcutF = '<C-p>'
let g:Lf_CommandMap = { '<C-]>':['<C-v>'],'<C-j>':['<DOWN>'],'<C-k>':['<UP>'],'<TAB>':['<TAB>','<C-p>','<C-f>'] }
let g:Lf_NormalMap = { 'File': [['u', ':LeaderfFile ..<CR>']] }
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_width = 25
let g:tagbar_singleclick = 1
let g:tagbar_iconchars = [ '+', '-' ]
let g:table_mode_tableize_map = ''
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
let g:leetcode_solution_filetype = 'python3'
let g:leetcode_username = 'joshuali925'  " keyring password = 1
" }}}

" ==================== Execute code ===================== {{{
command! -complete=file -nargs=* SetArgs call SetArgs(<q-args>)
function! SetArgs(command)  " :SetArgs <args...><CR>, all execution will use args
    if a:command == ''
        let b:args = ''
    else
        let b:args = ' '. a:command
    endif
endfunction
let g:OutputCount = 1
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(command)
    let l:expanded_command = substitute(a:command, './%<', './'. fnameescape(expand('%<')), '')
    let l:expanded_command = substitute(l:expanded_command, '%<', fnameescape(expand('%<')), '')
    let l:expanded_command = substitute(l:expanded_command, '%', fnameescape(expand('%')), '')
    let l:curr_bufnr = bufwinnr('%')
    let l:win_left = winnr('$')
    while l:win_left>1 && bufname('%')!~'[Output_'
        exec 'wincmd w'
        let l:win_left = l:win_left - 1
    endwhile
    if bufname('%') =~ '[Output_'
        setlocal modifiable
        exec '%d'
    else
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap nocursorline nocursorcolumn
        silent exec '0f | file [Output_'. g:OutputCount. '] | resize '. (winheight(0) * 4/5)
        let g:OutputCount = g:OutputCount + 1
        nnoremap <buffer> q :quit<CR>
        nnoremap <buffer> w :set wrap!<CR>
    endif
    call setline(1, 'Run: '. l:expanded_command)
    call setline(2, substitute(getline(1), '.', '=', 'g'))
    exec '$read !'. l:expanded_command
    setlocal nomodifiable
    exec l:curr_bufnr. 'wincmd w'
endfunction
function! GetRunCommand()
    let l:run_command = {}
    let l:run_command['python'] = g:PythonPath. ' %'
    let l:run_command['c'] = 'gcc % -o %< -g && ./%<'
    let l:run_command['cpp'] = 'g++ % -o %< -g && ./%<'
    let l:run_command['java'] = 'javac % && java %<'
    let l:run_command['javascript'] = 'node %'
    return get(l:run_command, &filetype, ''). b:args
endfunction
if g:ExecCommand != ''
    nnoremap <leader>r :wall <bar> exec g:ExecCommand<CR>
endif
" }}}

" ==================== AutoComplete ===================== {{{
" let g:ycm_path_to_python_interpreter=''  " for ycmd, don't change
let g:ycm_python_binary_path=g:PythonPath  " for JediHTTP
let g:echodoc_enable_at_startup = 1
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<TAB>'
let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
" use <C-@> in vim, <C-Space> in nvim for ctrl space
if g:Completion == 0  " mucomplete
    set omnifunc=syntaxcomplete#Complete
    set completeopt+=noselect
    set shortmess+=c
    inoremap <expr> <C-@> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <C-Space> pumvisible() ? "\<C-e>\<C-x>\<C-o>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#chains = {}
    let g:mucomplete#chains.default = ['path', 'ulti', 'keyn', 'omni', 'file']
elseif g:Completion == 1  " YCM
    inoremap <expr> <CR> pumvisible() ? "\<Esc>a" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>\<Esc>a" : "\<C-x>"
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
    let g:ycm_global_ycm_extra_conf = '~/.vim/others/.ycm_extra_conf.py'
    let g:echodoc#enable_force_overwrite = 1
elseif g:Completion == 2  " coc
    set updatetime=300
    set shortmess+=c
    set signcolumn=yes
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <C-@> coc#refresh()
    inoremap <expr> <C-Space> coc#refresh()
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Space>\<BS>"
    inoremap <expr> <C-x> pumvisible() ? "\<C-e>" : "\<C-x>"
    xmap <C-f> <Plug>(coc-format-selected)
    nnoremap <C-f> :call CocAction('format')<CR>
    nnoremap K :call <SID>show_documentation()<CR>
    nmap <leader>a <Plug>(coc-fix-current)
    nmap <leader>R <Plug>(coc-rename)
    nmap <leader>d <Plug>(coc-definition)
    nmap gy <Plug>(coc-type-definition)
    nmap gi <Plug>(coc-implementation)
    nmap gr <Plug>(coc-references)
    imap <C-k> <Plug>(coc-snippets-expand)
    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'
    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            exec 'help '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction
endif
" }}}

" ====================== Terminal ======================= {{{
tnoremap <F2> <C-\><C-n>gT
tnoremap <F3> <C-\><C-n>gt
tnoremap <C-u> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <leader>to :call OpenNvimTerminal(0)<CR>
nnoremap <leader>tO :call OpenNvimTerminal(1)<CR>
nnoremap <leader>th :call OpenNvimTerminal(2)<CR>
nnoremap <leader>tv :call OpenNvimTerminal(3)<CR>
nnoremap <leader>tt :call OpenNvimTerminal(4)<CR>
nnoremap <leader>te V:call SendToNvimTerminal()<CR>$
vnoremap <leader>te <Esc>:call SendToNvimTerminal()<CR>
autocmd TermOpen,BufEnter term://* startinsert
autocmd TermClose term://* quit
function! OpenNvimTerminal(mode)
    let l:prefix = {}
    let l:prefix[0] = 'split | resize'. (winheight(0) * 2/5)
    let l:prefix[1] = ''
    let l:prefix[2] = 'split'
    let l:prefix[3] = 'vsplit'
    let l:prefix[4] = 'tabedit'
    exec l:prefix[a:mode]. ' | set nonumber norelativenumber signcolumn=no | terminal'
endfunction
function! SendToNvimTerminal()
    let l:job_id = -1
    for l:buff_n in tabpagebuflist()
        if nvim_buf_get_name(l:buff_n) =~ 'term://'
            let l:job_id = nvim_buf_get_var(l:buff_n, 'terminal_job_id')
            break
        endif
    endfor
    if l:job_id > 0
        let l:lines = getline(getpos("'<")[1], getpos("'>")[1])
        let l:indent = match(l:lines[0], '[^ \t]') " for removing unnecessary indent
        for l in l:lines
            let l:new_indent = match(l, '[^ \t]')
            if l:new_indent == 0
                call jobsend(l:job_id, l. "\n")
            else
                call jobsend(l:job_id, l[l:indent:]. "\n")
            endif
        endfor
    endif
endfunction
" }}}

" ================== Windows settings =================== {{{
" first manually create %UserProfile%/.cache/vim/undo directory
" plugins are installed to %UserProfile%/.vim
if has('win32')
    " set PYTHONHOME for vim (windows python bug)
    " also needs to reset when entering virtual environments
    " Activate works for conda only, do NOT use for virtualenv
    if $PYTHONHOME == ''
        let $PYTHONHOME = 'C:\Users\Josh\Anaconda3'
    endif
    function! ActivatePyEnv(environment)
        if a:environment == ''
            silent exec '!venv & gvim '. expand('%:p')
        else
            " silent exec '!activate '. a:environment. ' & gvim '. expand('%:p')
            silent exec '!activate '. a:environment. ' & gvim '. expand('%:p'). ' -c "let $PYTHONHOME='''. $USERPROFILE. '/Anaconda3/envs/'. a:environment. '''"'
        endif
    endfunction
    command! -complete=shellcmd -nargs=* Activate call ActivatePyEnv(<q-args>) <bar> quit
    let &t_SI=""
    let &t_SR=""
    let &t_EI=""
    vnoremap <C-c> "+y<Esc>
    if has('gui_running')
        nnoremap <leader>W :silent exec '!sudo /c gvim "%:p"'<CR>
        nnoremap <leader>R :silent exec '!gvim "%:p"' <bar> quit<CR>
        set guifont=Consolas:h11:cANSI
        set guioptions=Mgrt
        set guicursor+=a:blinkon0
        if &columns < 85 && &lines < 30
            set lines=25
            set columns=85
        endif
    endif
endif
" }}}
