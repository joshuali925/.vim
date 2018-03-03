execute pathogen#infect()
set t_Co=256
let g:airline#extensions#tabline#enabled=1
set laststatus=2

colorscheme one
set background=dark
let g:airline_theme='onedark'

" ======================== shortcuts ======================
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
nnoremap <F12> :set paste! <bar> set number!<CR>
nnoremap <C-l> :noh<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
imap <C-S-f> <C-o><C-S-f>
nnoremap <C-S-f> :Autoformat<CR>
nnoremap <leader>w :w!<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>com o=======================================================<Esc>:Commentary<CR>

" ======================= format ========================
autocmd FileType c,java nnoremap <buffer> <leader>f :update<bar>silent exec "!~/.vim/astyle % --style=k/r -T4ncpUHk1A2 > /dev/null"<bar>:edit!<bar>:redraw!<CR>
" autocmd FileType python nnoremap <buffer> <leader>f :update<bar>silent exec "!python ~/.vim/autopep8.py % --in-place"<bar>:edit!<bar>:redraw!<CR>


" ====================== fold code ======================
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

" ========== disable auto comment, run code =============
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
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

" ====== neocomplcache for autocomplete, snippets =======
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,menu,longest,preview
set previewheight=2
let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_fuzzy_completion = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_quick_match = 1
inoremap <expr><C-@>  pumvisible() ? "\<C-n>" : "\<C-x>" . "\<C-u>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><C-x>  pumvisible() ? neocomplcache#cancel_popup() : "\<C-x>"
inoremap <expr><CR> pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"
" neosnippet
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"


" =NERDTree open if empty file, close if is the only tab=
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeWinSize=23
let NERDTreeShowHidden=1

" ======================= basics ========================
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax enable
autocmd BufEnter * silent! lcd %:p:h
set number
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
set scrolloff=2
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

set hlsearch
set incsearch
set ignorecase
set smartcase

map <leader>vim :tabe ~/.vimrc<CR>
autocmd bufwritepost .vimrc source $MYVIMRC
