" ===================== Plugins =========================
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'chiel92/vim-autoformat'
Plug 'chun-yang/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'lfilho/cosco.vim'
Plug 'shougo/neocomplcache.vim'
Plug 'shougo/neosnippet.vim'
Plug 'honza/vim-snippets'
call plug#end()

" ===================== Themes ==========================
set t_Co=256
set laststatus=2
set background=dark
colorscheme one
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='onedark'

" ====================== Shortcuts ======================
let mapleader=';'
nnoremap 0 ^
nnoremap - $
imap <F1> <C-o><F1>
nnoremap <F1> :w!<CR>
imap <F2> <Esc><F2>
nnoremap <F2> gT
imap <F3> <Esc><F3>
nnoremap <F3> gt
nnoremap <F4> *
imap <F5> <Esc><F5>
nnoremap <F5> :wincmd w<CR>
imap <F12> <C-o><F12>
nnoremap <F12> :set paste! <bar> set number! <bar> set relativenumber!<CR>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
imap <C-S-f> <C-o><C-S-f>
nnoremap <C-S-f> :Autoformat<CR>
inoremap ;; <Esc>:CommaOrSemiColon<CR>$
nnoremap <leader>w :w!<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>com o=======================================================<Esc>:Commentary<CR>
vnoremap < <gv
vnoremap > >gv

" ======================= Format ========================
autocmd FileType c,java nnoremap <buffer> <leader>f :update<bar>silent exec "!~/.vim/astyle % --style=k/r -T4ncpUHk1A2 > /dev/null"<bar>:edit!<bar>:redraw!<CR>
" autocmd FileType python nnoremap <buffer> <leader>f :update<bar>silent exec "!python ~/.vim/autopep8.py % --in-place"<bar>:edit!<bar>:redraw!<CR>


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
endfun

" ==================== Execute code =====================
imap <F10> <Esc><F10>
autocmd FileType python nnoremap <buffer> <F10> :update<bar>!clear && python %<CR>
autocmd FileType c nnoremap <buffer> <F10> :update<bar>!clear && gcc % -o %< -g && ./%<<CR>
autocmd FileType java nnoremap <buffer> <F10> :update<bar>!clear && javac % && java %<<CR>
imap <F11> <Esc><F11>
autocmd FileType python nnoremap <buffer> <F11> :update<bar>call RunShellCommand('python %')<CR>
autocmd FileType c nnoremap <buffer> <F11> :update<bar>call RunShellCommand('gcc % -o %< -g && ./%<')<CR>
autocmd FileType java nnoremap <buffer> <F11> :update<bar>call RunShellCommand('javac % && java %<')<CR>
command! -complete=shellcmd -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(cmdline)
    let expanded_cmdline = a:cmdline
    " for part in split(a:cmdline, ' ')
    "     if part[0] =~ '\v[%#<]'
    "         let expanded_part = fnameescape(expand(part))
    "         let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
    "     endif
    " endfor
    let expanded_cmdline = substitute(expanded_cmdline, './%<', './'. fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%<', fnameescape(expand('%<')), '')
    let expanded_cmdline = substitute(expanded_cmdline, '%', fnameescape(expand('%')), '')
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile wrap
    nnoremap <buffer> <Space> :q<CR>
    call setline(1, 'Run: ' .expanded_cmdline)
    call setline(2, substitute(getline(1),'.','=','g'))
    execute "resize " . (winheight(0) * 4/5)
    execute '$read !'. expanded_cmdline
    setlocal nomodifiable
    1
endfunction

" =================== Neocomplcache =====================
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,menu,longest,preview
set previewheight=2
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
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
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

" ======================= Basics ========================
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax enable
" set working directory
autocmd BufEnter * silent! lcd %:p:h
set number relativenumber
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
set numberwidth=4
set wrap
set linebreak
set showcmd
set showmatch
set showmode
set title
set ruler
set wildmenu
set splitbelow
set splitright
set scrolloff=5
set mouse=nv
set backspace=eol,start,indent
set autoread
set history=500
set lazyredraw
set noswapfile
set nowb
set nobackup

set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set hlsearch
set incsearch
set ignorecase
set smartcase

map <leader>vim :tabe ~/.vimrc<CR>
autocmd bufwritepost .vimrc source $MYVIMRC
