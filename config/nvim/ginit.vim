if has('win32')
  set guifont=JetBrainsMono\ NF:h10
else
  set guifont=JetBrainsMono\ Nerd\ Font:h14
endif

if exists('g:neovide')
  let g:neovide_cursor_vfx_mode = "railgun"
  " let g:neovide_cursor_animation_length=0.12
  " let g:neovide_cursor_vfx_particle_lifetime=1.2
  " let g:neovide_cursor_vfx_particle_density=7.0
  " let g:neovide_cursor_vfx_particle_speed=10.0
  " let g:neovide_refresh_rate = 30
  " let g:neovide_fullscreen = v:true

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

  " https://github.com/Kethku/neovide/issues/445
  imap <S-(> (
  imap <S-)> )
  map <S-_> _
  map <S-+> +
  imap <S-{> {
  imap <S-}> }
  imap <S-"> "
  map <S-"> "
  imap <S-lt> <
  imap <S->> >
  map <S-lt> <
  map <S->> >

  " https://github.com/Kethku/neovide/issues/181
  if !exists('g:neovide_fullscreen')
    " if &columns < 115 || &lines < 32
    "   set lines=32
    "   set columns=115
    " endif
    function! SetWindowSize(timer)
      set lines=32
      set columns=115
      if &filetype == 'startify'
        normal! zb
      else
        normal! zz
      endif
    endfunction
    call timer_start(500, 'SetWindowSize')
  endif

elseif !has('gui_vimr')  " nvim-qt
  GuiTabline 0
  GuiPopupmenu 0
  inoremap <S-Insert> <C-g>u<C-o>"+p
  nnoremap <S-Insert> "+p
  xnoremap <S-Insert> "+p
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
  noremap <leader>y "+y
  nnoremap <leader>Y "+y$
endif
