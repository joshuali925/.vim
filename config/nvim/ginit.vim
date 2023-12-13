if has('win32')  " nvim-qt.exe
  GuiFont! JetBrainsMono\ NF:h10
else
  " check available fonts with :set guifont=*<CR> and :set guifont?<CR>
  set guifont=JetBrainsMono\ Nerd\ Font:h14
endif

if exists('g:neovide')
  " do not enable particles, https://github.com/neovide/neovide/issues/843
  let g:neovide_cursor_vfx_mode = 'sonicboom'
  let g:neovide_refresh_rate = 30
  inoremap <D-v> <C-g>u<C-o>"+p
  cnoremap <D-v> <C-r>+
  tnoremap <D-v> <C-\><C-n>"+p
  nnoremap <D-v> "+p
  xnoremap <D-v> "+p
  noremap <D-Left> <Home>
  noremap! <D-Left> <Home>
  noremap <D-Right> <End>
  noremap! <D-Right> <End>
  noremap <M-Left> <C-Left>
  noremap! <M-Left> <C-Left>
  noremap <M-Right> <C-right>
  noremap! <M-Right> <C-right>
  noremap! <M-BS> <C-w>

else  " nvim-qt
  GuiTabline 0
  GuiPopupmenu 0
  inoremap <S-Insert> <C-g>u<C-o>"+p
  nnoremap <S-Insert> "+p
  xnoremap <S-Insert> "+p
  cnoremap <S-Insert> <C-r>+
  inoremap <D-v> <C-g>u<C-o>"+p
  nnoremap <D-v> "+p
  xnoremap <D-v> "+p
  cnoremap <D-v> <C-r>+
  inoremap <D-z> <C-o>u
  nnoremap <D-z> u
  noremap <D-Left> <Home>
  noremap! <D-Left> <Home>
  noremap <D-Right> <End>
  noremap! <D-Right> <End>
  noremap <M-Left> <C-Left>
  noremap! <M-Left> <C-Left>
  noremap <M-Right> <C-right>
  noremap! <M-Right> <C-right>
  noremap! <M-BS> <C-w>
  noremap <leader>y "+y
  nnoremap <leader>Y "+y$
endif
