set belloff=all

if exists('g:neovide')
  " check available fonts with :set guifont=*<CR> and :set guifont?<CR>
  if has('mac')
    set guifont=JetBrainsMono\ Nerd\ Font:h14
  else
    set guifont=Maple\ Mono\ NF\ CN:h10
  endif

  " let g:neovide_cursor_vfx_mode = 'torpedo'

  " disable animations, https://neovide.dev/faq.html#how-to-turn-off-all-animations
  let g:neovide_position_animation_length = 0
  let g:neovide_cursor_animation_length = 0.00
  let g:neovide_cursor_trail_size = 0
  let g:neovide_cursor_animate_in_insert_mode = v:false
  let g:neovide_cursor_animate_command_line = v:false
  let g:neovide_scroll_animation_far_lines = 0
  let g:neovide_scroll_animation_length = 0.00

  inoremap <S-Insert> <C-g>u<C-r>+
  nnoremap <S-Insert> "+p
  xnoremap <S-Insert> "+p
  cnoremap <S-Insert> <C-r>+
  inoremap <D-v> <C-g>u<C-r>+
  cnoremap <D-v> <C-r>+
  tnoremap <D-v> <C-\><C-o>"+p
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
endif
