" =======================================================
" glutentags - too slow, tagfile too large
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_project_root = ['.project', '.root']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_cache_dir = expand('~/.cache/vim')
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q', '--c++-kinds=+px', '--c-kinds=+px']

" =======================================================
" use NERD_tree instead
" built in :Lexplore<CR> settings
let g:netrw_dirhistmax=0
let g:netrw_banner=0
let g:netrw_browse_split=2
let g:netrw_winsize=20
let g:netrw_liststyle=3

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

