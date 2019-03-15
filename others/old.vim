Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_project_root = ['.project', '.root']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_cache_dir = expand('~/.cache/vim')
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q', '--c++-kinds=+px', '--c-kinds=+px']

" built in :Lexplore<CR> settings
let g:netrw_dirhistmax=0
let g:netrw_banner=0
let g:netrw_browse_split=2
let g:netrw_winsize=20
let g:netrw_liststyle=3

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

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'solarized'


