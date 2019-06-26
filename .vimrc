" ==================== Settings ========================= {{{
let g:Theme = 1
let g:Completion = 4  " 0: mucomplete, 1: YCM, 2: deoplete, 3: ncm2, 4: coc
let g:PythonPath = 'python'
let g:ExecCommand = 'term ++close ipython -i %'
" }}}

" ===================== Plugins ========================= {{{
call plug#begin('~/.vim/plugged')
" Plug 'mhinz/vim-startify'
" Plug 'w0rp/ale'
" Plug 'sheerun/vim-polyglot'
Plug 'skywind3000/quickmenu.vim', { 'on': [] }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'chiel92/vim-autoformat', { 'on': [] }
Plug 'mg979/vim-visual-multi', { 'on': [] }
Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-f)'] }
Plug 'dahu/vim-fanfingtastic', { 'on': ['<Plug>fanfingtastic_f', '<Plug>fanfingtastic_t', '<Plug>fanfingtastic_F', '<Plug>fanfingtastic_T'] }
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gdiff'] }
Plug 'tpope/vim-commentary', { 'on': ['<Plug>Commentary', 'Commentary'] }
Plug 'tpope/vim-surround', { 'on': ['<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround', '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround', '<Plug>VSurround', '<Plug>VgSurround'] }
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'sillybun/vim-autodoc', { 'on': [] }
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }  " load on startup to record MRU
Plug 'tpope/vim-repeat'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'jiangmiao/auto-pairs'
Plug 'shougo/echodoc.vim'
Plug 'davidhalter/jedi-vim', { 'on': [] }
if g:Completion >= 0
    Plug 'sirver/ultisnips', { 'for': ['vim', 'c', 'cpp', 'java', 'python'] }
    Plug 'honza/vim-snippets', { 'for': ['vim', 'c', 'cpp', 'java', 'python'] }
endif
if g:Completion == 0
    Plug 'lifepillar/vim-mucomplete'
elseif g:Completion == 1
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --ts-completer --java-completer' }
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
elseif g:Completion == 4
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
call plug#end()
silent! call yankstack#setup()
" }}}

" ===================== Themes ========================== {{{
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=light
if g:Theme < 0
    set background=dark
endif
if g:Theme == 0
    colorscheme solarized8_flat
elseif g:Theme == 1
    colorscheme PaperColor
elseif g:Theme == 2
    colorscheme snow
elseif g:Theme == -1
    colorscheme onedark
elseif g:Theme == -2
    colorscheme forest-night
elseif g:Theme == -3
    colorscheme molokai
endif
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
nnoremap <F1> :call LoadQuickmenu()<CR>
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
nmap ? <Plug>(easymotion-bd-w)
map <leader>f <Plug>(easymotion-bd-f)
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
nnoremap - $
vnoremap - $h
noremap <Down> gj
noremap <Up> gk
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
nnoremap Q @q
nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv
nnoremap o o<Space><BS>
nnoremap O O<Space><BS>
nnoremap K :call ShowDocs()<CR>
inoremap <CR> <CR><Space><BS>
nnoremap gf <C-w>gf
nnoremap gp `[v`]
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
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-p> :LeaderfFile<CR>
nnoremap <C-g> :LeaderfRgInteractive<CR>
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
vmap <C-f> :call LoadAutoformat()<CR>gv<C-f>
nmap <C-n> :call LoadVisualMulti()<CR><C-n>
xmap <C-n> :call LoadVisualMulti()<CR>gv<C-n>
nmap <leader><C-n> :call LoadVisualMulti()<CR><leader><C-n>
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nmap <leader>o o<Esc>
nmap <leader>O O<Esc>
nnoremap <leader>m :LeaderfMru<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>h :WhichKey ';'<CR>
nnoremap <leader>l :nohlsearch <bar> diffupdate <bar> let @/='QwQ'<CR><C-l>
nnoremap <leader>F :vertical sfind *
nnoremap <leader>ta :Tabularize /
nnoremap <leader>tE :exec getline('.')<CR>``
inoremap <leader>w <Esc>:update<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>W :w !sudo tee %<CR>
nnoremap <leader>Q :mksession! ~/.cache/vim/session.vim <bar> wqa!<CR>
nnoremap <leader>L :silent source ~/.cache/vim/session.vim<CR>
nnoremap <leader>q :q<CR>
vnoremap <leader>q <Esc>:q<CR>
nnoremap <leader>vim :tabedit $MYVIMRC<CR>
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
" set cursorline
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
set viminfo+=n~/.cache/vim/viminfo
set path=$PWD/**
set encoding=utf-8
set timeoutlen=1500
set ttimeoutlen=40
set lazyredraw
set noswapfile
set nowritebackup
set nobackup
set statusline=%<[%{mode()}]\ %f\ %{GetPasteStatus()}%h%m%r%=%-14.(%c/%{len(getline('.'))}%)%l/%L\ %P
" }}}

" ====================== Autocmd ======================== {{{
augroup RestoreCursor_AutoSource_Format_PyComment_InsertColon_HighlightSelf
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exec "normal! g'\"zz" | endif
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd FileType c,cpp,java nnoremap <buffer> <C-f> :update <bar> silent exec '!~/.vim/bin/astyle % --style=k/r -s4ncpUHk1A2 > /dev/null' <bar> :edit! <bar> :redraw!<CR>
    autocmd FileType * setlocal formatoptions=jql
    autocmd FileType python inoremap <buffer> # <Space><C-h>#<Space>
    autocmd FileType c,cpp,java,javascript inoremap <buffer> ;; <C-o>$;
    autocmd FileType python inoremap <buffer> ;; <C-o>$:
    autocmd FileType python syntax keyword pythonSelf self | highlight def link pythonSelf Special
augroup END
" }}}

" ====================== LazyLoad ======================= {{{
function! LoadAutoformat()
    nnoremap <C-f> :Autoformat<CR>
    inoremap <C-f> <Esc>V:'<,'>Autoformat<CR>A
    vnoremap <C-f> :'<,'>Autoformat<CR>$
    call plug#load('vim-autoformat')
endfunction
function! LoadVisualMulti()
    nmap <C-n> <Plug>(VM-Find-Under)
    xmap <C-n> <Plug>(VM-Find-Subword-Under)
    call plug#load('vim-visual-multi')
endfunction
function! LoadRecordParameter()
    call plug#load('vim-autodoc')
    RecordParameter
endfunction
function! ShowDocs()
    if &filetype == 'python'
        let g:jedi#auto_initialization = 1
        let g:jedi#auto_vim_configuration = 0
        let g:jedi#completions_enabled = 0
        let g:jedi#show_call_signatures = "2"
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
    nnoremap <F1> :call quickmenu#toggle(0)<CR>
    call plug#load('quickmenu.vim')
    let g:quickmenu_options = "HL"
    call g:quickmenu#reset()
    call g:quickmenu#header('QvQ')
    call g:quickmenu#append('# Actions', '')
    call g:quickmenu#append('Insert Comment Line', 'call InsertCommentLine()')
    call g:quickmenu#append('Insert Time', "put=strftime('%x %X')")
    call g:quickmenu#append('Git Diff', 'Gdiff', 'use fugitive Gdiff on current document')
    call g:quickmenu#append('Git Status', 'Gstatus', 'use fugitive Gstatus on current document')
    call g:quickmenu#append('Record Python Parameter', 'call LoadRecordParameter()', '', 'python')
    call g:quickmenu#append('# Toggle', '')
    call g:quickmenu#append('NERDTree', 'NERDTreeToggle')
    call g:quickmenu#append('Undo Tree', 'UndotreeToggle')
    call g:quickmenu#append('Tagbar', 'TagbarToggle')
    call g:quickmenu#append('Table Mode', 'TableModeToggle')
    call g:quickmenu#append('Diff %{g:DiffOn==1? "[x]" :"[ ]"}', 'call ToggleDiff()')
    call g:quickmenu#append('Fold %{g:FoldOn==1? "[x]" :"[ ]"}', 'call ToggleFold()')
    call g:quickmenu#append('Paste %{&paste? "[x]" :"[ ]"}', 'call TogglePaste()')
    call g:quickmenu#append('Preview %{g:PreviewOn==1? "[x]" :"[ ]"}', 'call TogglePreview()')
    call g:quickmenu#toggle(0)
endfunction
" }}}

" ================= Insert Comment Line ================= {{{
function! InsertCommentLine()
    exec 'normal! o'
    exec 'normal! 55i='
    exec 'Commentary'
endfunction
" }}}

" ======================= Macro ========================= {{{
function! ExecuteMacroOverVisualRange()
    echo '@'.getcmdline()
    exec ":'<,'>normal! @".nr2char(getchar())
endfunction
function! EditRegister() abort
    let r = nr2char(getchar())
    call feedkeys("q:ilet @". r. " = \<C-r>\<C-r>=string(@". r. ")\<CR>\<Esc>0f'", 'n')
endfunction
" }}}

" ======================== Diff ========================= {{{
let g:DiffOn = 0
function! ToggleDiff()
    if g:DiffOn == 0
        exec 'windo diffthis'
    else
        exec 'windo diffoff'
    endif
    let g:DiffOn = 1 - g:DiffOn
endfunction
" }}}

" ===================== Fold code ======================= {{{
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
" }}}

" ======================= Paste ========================= {{{
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
" }}}

" ======================= Preview ======================= {{{
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
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_flake8_options = '--ignore=W291,W293,W391,E261,E302,E305,E501'
let g:asyncrun_open = 12
let g:AutoPairsShortcutFastWrap = '<C-l>'
let g:AutoPairsShortcutBackInsert = '<C-b>'
let g:EasyMotion_smartcase = 1
let g:formatters_python = ['yapf']
let NERDTreeWinSize = 23
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
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
set wildignore+=*/tmp/*,*/\.git/*,*/\.oh-my-zsh/*,*/node_modules/*,*/venv/*,*/\.env/*  " do NOT wildignore plugged
let g:Lf_WildIgnore = { 'dir':['tmp','.git','.oh-my-zsh','plugged','node_modules','venv','.env','.local','.idea','*cache*'],'file':[] }
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_ReverseOrder = 1
let g:Lf_ShortcutF = '<C-p>'
" <C-p>: File; <leader>m: MRU, [2<C-p>: Rip Grep | 2<C-f>: Functions]
let g:Lf_CommandMap = { '<C-]>':['<C-v>'],'<C-j>':['<DOWN>'],'<C-k>':['<UP>'],'<TAB>':['<TAB>','<C-p>','<C-f>'] }
let g:Lf_NormalMap = { 'File': [['u', ':LeaderfFile ..<CR>']],
            \        'Mru': [['<C-p>', ':exec g:Lf_py "mruExplManager.quit()" <bar> LeaderfRgInteractive<CR>'],
            \               ['<C-f>', ':exec g:Lf_py "mruExplManager.quit()" <bar> LeaderfFunctionAll<CR>']] }
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_CacheDirectory = expand('~/.cache/')
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_width = 25
let g:tagbar_singleclick = 1
let g:tagbar_iconchars = [ '+', '-' ]
let g:echodoc_enable_at_startup = 1
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
" }}}

" ==================== Execute code ===================== {{{
autocmd FileType * let b:args = ''
command! -complete=file -nargs=* SetArgs call SetArgs(<q-args>)
function! SetArgs(cmdline)
    if a:cmdline == ''
        let b:args = ''
    else
        let b:args = ' '. a:cmdline
    endif
endfunction
let g:OutputCount = 1
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(cmdline)
    let expanded_cmdline = substitute(a:cmdline, './%<', './'. fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%<', fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%', fnameescape(expand('%')), '')
    let curr_bufnr = bufwinnr('%')
    let win_left = winnr('$')
    while win_left>1 && bufname('%')!~'[Output_'
        exec 'wincmd w'
        let win_left = win_left - 1
    endwhile
    if bufname('%') =~ '[Output_'
        setlocal modifiable
        exec '%d'
    else
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap nocursorline nocursorcolumn
        silent exec '0f | file [Output_'. g:OutputCount. '] | resize '. (winheight(0) * 4/5)
        let g:OutputCount = g:OutputCount + 1
        nnoremap <buffer> q :q<CR>
        nnoremap <buffer> w :set wrap!<CR>
    endif
    call setline(1, 'Run: '. expanded_cmdline)
    call setline(2, substitute(getline(1), '.', '=', 'g'))
    exec '$read !'. expanded_cmdline
    setlocal nomodifiable
    exec curr_bufnr. 'wincmd w'
endfunction
function! GetRunCommand()
    if &filetype == 'python'
        return g:PythonPath. ' %'. b:args
    elseif &filetype == 'c'
        return 'gcc % -o %< -g && ./%<'. b:args
    elseif &filetype == 'cpp'
        return 'g++ % -o %< -g && ./%<'. b:args
    elseif &filetype == 'java'
        return 'javac % && java %<'. b:args
    endif
    return ''
endfunction
imap <leader>r <Esc><leader>r
if g:ExecCommand == ''
    nmap <leader>r <F11>
else
    " nmap <leader>r :wall <bar> exec 'AsyncRun '. g:ExecCommand<CR>
    nmap <leader>r :wall <bar> exec g:ExecCommand<CR>
endif
" }}}

" ==================== AutoComplete ===================== {{{
" let g:ycm_path_to_python_interpreter=''  " for ycmd, don't change
let g:ycm_python_binary_path=g:PythonPath  " for JediHTTP
let g:deoplete#sources#jedi#python_path=g:PythonPath
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
    " let g:ycm_semantic_triggers = { 'c,cpp,python,java': ['re!\w{2}'] }  " auto semantic complete
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    " for c include files, add to .ycm_extra_conf.py
    " '-isystem',
    " '/path/to/include'
    let g:ycm_global_ycm_extra_conf = '~/.vim/others/.ycm_extra_conf.py'
    let g:echodoc#enable_force_overwrite = 1
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
elseif g:Completion == 4  " coc
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
            exec 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction
endif
" }}}

" ====================== Terminal ======================= {{{
" do not tmap <Esc> in vim 8
tnoremap <F2> <C-w>gT
tnoremap <F3> <C-w>gt
tnoremap <C-u> <C-\><C-n>
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
nnoremap <leader>to :exec 'terminal ++close ++rows='. winheight(0) * 2/5<CR>
nnoremap <leader>tO :terminal ++curwin ++close<CR>
nnoremap <leader>th :terminal ++close<CR>
nnoremap <leader>tv :vertical terminal ++close<CR>
nnoremap <leader>tt :tabedit <bar> terminal ++curwin ++close<CR>
nnoremap <leader>te V:call SendToTerminal()<CR>$
vnoremap <leader>te <Esc>:call SendToTerminal()<CR>
function! SendToTerminal()
    let buff_n = term_list()
    if len(buff_n) > 0
        let buff_n = buff_n[0] " sends to most recently opened terminal
        let lines = getline(getpos("'<")[1], getpos("'>")[1])
        let indent = match(lines[0], '[^ \t]') " for removing unnecessary indent
        for l in lines
            let new_indent = match(l, '[^ \t]')
            if new_indent == 0
                call term_sendkeys(buff_n, l. "\<CR>")
            else
                call term_sendkeys(buff_n, l[indent:]. "\<CR>")
            endif
            sleep 10m
        endfor
    endif
endfunction
" }}}

" ================== Windows settings =================== {{{
" first manually create %UserProfile%/.cache/vim/undo directory
" plugins are installed to %UserProfile%/.vim
if has('win32')
    " for ncm2, doesn't work with any virtual env
    let g:python3_host_prog = 'C:\Users\Josh\Anaconda3\python.exe'
    " set PYTHONHOME for vim (windows python bug)
    " also needs to set when entering virtual environments
    " works for conda only, do NOT use Activate for virtualenv
    if $PYTHONHOME == ''
        let $PYTHONHOME = 'C:\Users\Josh\Anaconda3'
    endif
    " clear PYTHONHOME after vim is loaded
    " autocmd BufNew * let $PYTHONHOME=''
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
        set guioptions=grt
        set guicursor+=a:blinkon0
        if &columns < 85 && &lines < 30
            set lines=25
            set columns=85
        endif
    endif
endif
" }}}
