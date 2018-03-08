" ===================== Plugins =========================
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'
Plug 'lfilho/cosco.vim', { 'on': 'CommaOrSemiColon' }
Plug 'chun-yang/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'chiel92/vim-autoformat', { 'on': 'Autoformat' }
Plug 'shougo/neocomplcache.vim'
Plug 'shougo/neosnippet.vim'
Plug 'honza/vim-snippets'
call plug#end()

" ===================== Themes ==========================
set t_Co=256
set background=dark
colorscheme one
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='onedark'

" ====================== Shortcuts ======================
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
nnoremap <F1> :wincmd w<CR>
imap <F2> <Esc><F2>
nnoremap <F2> gT
imap <F3> <Esc><F3>
nnoremap <F3> gt
nnoremap <F4> *
imap <F12> <C-o><F12>
nnoremap <F12> :set paste! <bar> set number! <bar> set relativenumber!<CR>
inoremap <Esc> <C-o>:stopinsert<CR>
inoremap <C-c> <C-o>:stopinsert<CR>
inoremap <C-l> <C-o>:stopinsert<CR>
nnoremap <C-l> :noh <bar> let @/=""<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
imap <C-f> <C-o><C-f>
nnoremap <C-f> :Autoformat<CR>
imap <C-g> <C-o><C-g>
nnoremap <C-g> :%s/\(\n\n\)\n\+/\1/<CR>
inoremap ;; <Esc>:CommaOrSemiColon<CR>$
nnoremap 0 ^
nnoremap - $
vnoremap < <gv
vnoremap > >gv
inoremap <C-j> <C-o>A
inoremap <C-b> <C-o>b
inoremap <C-w> <C-o>w
inoremap <C-e> <C-o>e
nnoremap <leader>w :w!<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>com o=======================================================<Esc>:Commentary<CR>

" ======================= Basics ========================
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax enable
set numberwidth=4
set number relativenumber
set mouse=nv
set cursorline
set backspace=eol,start,indent
augroup linenum_currdir_comment
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
    autocmd BufEnter * silent! lcd %:p:h
    autocmd FileType * setlocal formatoptions-=cro
augroup END
set wrap
set linebreak
set showcmd
set showmatch
set showmode
set title
set ruler
set laststatus=2
set wildmenu
set splitright
set splitbelow
set scrolloff=5
set autoread
set history=500
set lazyredraw
set noswapfile
set nowb
set nobackup
let g:netrw_dirhistmax=0

set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set hlsearch
set incsearch
set ignorecase
set smartcase

nnoremap <leader>vim :tabe $MYVIMRC<CR>
augroup auto_source
    autocmd!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

" ====================== Fold code ======================
set foldmethod=indent
set foldlevel=99
let g:FoldMethod = 0
nnoremap <F6> :call ToggleFold()<cr>
function! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfunction

" ======================= Format ========================
autocmd FileType c,java nnoremap <buffer> <leader>f :update<bar>silent exec "!~/.vim/astyle % --style=k/r -T4ncpUHk1A2 > /dev/null"<bar>:edit!<bar>:redraw!<CR>
" autocmd FileType python nnoremap <buffer> <leader>f :update<bar>silent exec "!python ~/.vim/autopep8.py % --in-place"<bar>:edit!<bar>:redraw!<CR>

" ==================== Execute code =====================
let b:args = ''
command! -complete=file -nargs=* SetArgs call SetArgs(<q-args>)
function! SetArgs(cmdline)
    if a:cmdline == ''
        let b:args = ''
    else
        let b:args = ' '. a:cmdline
    endif
endfunction
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(cmdline)
    let expanded_cmdline = a:cmdline
    let expanded_cmdline = substitute(expanded_cmdline, './%<', './'. fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%<', fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%', fnameescape(expand('%')), '')
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile norelativenumber wrap
    nnoremap <buffer> <Space> :q<CR>
    nnoremap <buffer> t :wincmd T<CR>
    call setline(1, 'Run: '. expanded_cmdline)
    call setline(2, substitute(getline(1), '.', '=', 'g'))
    execute 'resize '. (winheight(0) * 4/5)
    execute '$read !'. expanded_cmdline
    setlocal nomodifiable
endfunction
imap <F10> <Esc><F10>
imap <F11> <Esc><F11>
augroup run_code
    autocmd!
    autocmd FileType python nnoremap <buffer> <F10> :update<bar>exec '!clear && python %'. b:args<CR>
    autocmd FileType c nnoremap <buffer> <F10> :update<bar>exec '!clear && gcc % -o %< -g && ./%<'. b:args<CR>
    autocmd FileType java nnoremap <buffer> <F10> :update<bar>exec '!clear && javac % && java %<'. b:args<CR>
    autocmd FileType python nnoremap <buffer> <F11> :update<bar>call RunShellCommand('python %'. b:args)<CR>
    autocmd FileType c nnoremap <buffer> <F11> :update<bar>call RunShellCommand('gcc % -o %< -g && ./%<'. b:args)<CR>
    autocmd FileType java nnoremap <buffer> <F11> :update<bar>call RunShellCommand('javac % && java %<'. b:args)<CR>
augroup END

" =================== Neocomplcache =====================
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,menu,longest
" set completeopt=menuone,menu,longest,preview
" set previewheight=2
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_fuzzy_completion = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_quick_match = 1
inoremap <expr><C-@>  pumvisible() ? "\<C-n>" : "\<C-x>" . "\<C-u>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><C-x>  pumvisible() ? neocomplcache#cancel_popup() : "\<C-x>"
inoremap <expr><CR> pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" ================== NERDTree, ctrlp ====================
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeWinSize=23
let NERDTreeShowHidden=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*
let g:ctrlp_custom_ignore = 'tmp$\|\.git$\|\.hg$\|\.svn$\|.rvm$|.bundle$\|vendor'
let g:ctrlp_cache_dir = '~/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_show_hidden = 1
