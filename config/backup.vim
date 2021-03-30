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
xnoremap <leader>n "xy:let @/=substitute(escape(@x, "\\/.*'$^~[]"), '\n', '\\n', 'g') <bar> set hlsearch<CR>
let s:RelativeNumber = 0
  if s:RelativeNumber == 1
    set relativenumber
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave * set norelativenumber
  endif

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
