if has('win32')  " nvim-qt.exe
  GuiFont! JetBrainsMono\ NF:h10
else
  " check available fonts with :set guifont=*<CR> and :set guifont?<CR>
  set guifont=JetBrainsMono\ Nerd\ Font:h14
endif

if exists('g:neovide')
  let g:neovide_cursor_vfx_mode = "railgun"
  " let g:neovide_cursor_animation_length=0.12
  " let g:neovide_cursor_vfx_particle_lifetime=1.2
  " let g:neovide_cursor_vfx_particle_density=7.0
  " let g:neovide_cursor_vfx_particle_speed=10.0
  " let g:neovide_refresh_rate = 30

  inoremap <D-v> <C-g>u<C-o>"+p
  nnoremap <D-v> "+p
  xnoremap <D-v> "+p
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

elseif !has('gui_vimr')  " nvim-qt
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
