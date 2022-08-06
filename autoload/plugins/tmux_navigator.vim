" commit: 9ca5bfe5bd274051b5dd796cc150348afc993b80
" resize reference: https://github.com/martin-louazel-engineering/vim-tmux-navigator

" Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are
" no more windows in that direction, forwards the operation to tmux.
" Additionally, <C-\> toggles between last active vim splits/tmux panes.

if exists("g:loaded_tmux_navigator") || &cp || v:version < 700
  finish
endif
let g:loaded_tmux_navigator = 1

function! s:VimNavigate(direction)
  try
    execute 'wincmd ' . a:direction
  catch
    echohl ErrorMsg | echo 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd k' | echohl None
  endtry
endfunction

if !exists("g:tmux_navigator_resize_step")
  let g:tmux_navigator_resize_step = 1
endif

function! s:VimResize(direction)
  let sep_direction = tr(a:direction, 'hjkl', 'ljjl')
  let plus_minus = tr(a:direction, 'hjkl', '-+-+')
  if !s:VimHasNeighbour(sep_direction)
    let plus_minus = plus_minus == '+' ? '-' : '+'
  end
  let vertical = tr(a:direction, 'hjkl', '1001')
  let vimCmd = (vertical ? 'vertical ' : '') . 'resize' . plus_minus . g:tmux_navigator_resize_step
  exec vimCmd
endfunction

" equivalent to 'winnr() == winnr(direction)' for vim < 8.1
function! s:VimHasNeighbour(direction)
  let current_position = win_screenpos(winnr())
  if a:direction == 'k'
    " Account for potential bufferline
    return current_position[0] > 2
  elseif a:direction == 'h'
    return current_position[1] != 1
  endif
  let win_nr = winnr('$')
  while win_nr > 0
    let position = win_screenpos(win_nr)
    let win_nr = win_nr - 1
    if a:direction == 'l' && (current_position[1] + winwidth(0)) < position[1]
      return 1
    elseif a:direction == 'j' && (current_position[0] + winheight(0)) < position[0]
      return 1
    endif
  endwhile
endfunction

if empty($TMUX)
  function! plugins#tmux_navigator#navigate(direction)
    call s:VimNavigate(a:direction)
  endfunction
  function! plugins#tmux_navigator#resize(direction)
    call s:VimResize(a:direction)
  endfunction
  finish
endif

function! plugins#tmux_navigator#navigate(direction)
  call s:TmuxAwareNavigate(a:direction)
endfunction
function! plugins#tmux_navigator#resize(direction)
  call s:TmuxAwareResize(a:direction)
endfunction

if !exists("g:tmux_navigator_save_on_switch")
  let g:tmux_navigator_save_on_switch = 0
endif

if !exists("g:tmux_navigator_disable_when_zoomed")
  let g:tmux_navigator_disable_when_zoomed = 1
endif

if !exists("g:tmux_navigator_preserve_zoom")
  let g:tmux_navigator_preserve_zoom = 0
endif

function! s:TmuxOrTmateExecutable()
  return (match($TMUX, 'tmate') != -1 ? 'tmate' : 'tmux')
endfunction

function! s:TmuxVimPaneIsZoomed()
  return s:TmuxCommand("display-message -p '#{window_zoomed_flag}'") == 1
endfunction

function! s:TmuxSocket()
  " The socket path is the first value in the comma-separated list of $TMUX.
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  let l:x=&shellcmdflag
  let &shellcmdflag='-c'
  let retval=system(cmd)
  let &shellcmdflag=l:x
  return retval
endfunction

function! s:TmuxNavigatorProcessList()
  echo s:TmuxCommand("run-shell 'ps -o state= -o comm= -t ''''#{pane_tty}'''''")
endfunction
command! TmuxNavigatorProcessList call s:TmuxNavigatorProcessList()

let s:tmux_is_last_pane = 0
augroup tmux_navigator
  au!
  autocmd WinEnter * let s:tmux_is_last_pane = 0
augroup END

function! s:NeedsVitalityRedraw()
  return exists('g:loaded_vitality') && v:version < 704 && !has("patch481")
endfunction

function! s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
  if g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()
    return 0
  endif
  return a:tmux_last_pane || a:at_tab_page_edge
endfunction

function! s:TmuxAwareNavigate(direction)
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane
    call s:VimNavigate(a:direction)
  endif
  let at_tab_page_edge = (nr == winnr())
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
    if g:tmux_navigator_save_on_switch == 1
      try
        update " save the active buffer. See :help update
      catch /^Vim\%((\a\+)\)\=:E32/ " catches the no file name error
      endtry
    elseif g:tmux_navigator_save_on_switch == 2
      try
        wall " save all the buffers. See :help wall
      catch /^Vim\%((\a\+)\)\=:E141/ " catches the no file name error
      endtry
    endif
    let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
    if g:tmux_navigator_preserve_zoom == 1
      let l:args .= ' -Z'
    endif
    silent call s:TmuxCommand(args)
    if s:NeedsVitalityRedraw()
      redraw!
    endif
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction

function! s:TmuxHasNeighbour(direction)
  let tmux_direction = get({'h':'left', 'j':'bottom', 'k':'up', 'l':'right'}, a:direction)
  return !s:TmuxCommand("display-message -p '#{pane_at_" . tmux_direction . "}'")
endfunction

function! s:ShouldForwardResizeBackToTmux(direction)
  if g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()
    return 0
  endif
  if tabpagewinnr(tabpagenr(), '$') == 1
    return 1
  endif
  let xy_axis=tr(a:direction, 'hjkl', 'ljjl')
  " case: there are no more vim neighboring windows, and there is still at
  " least one tmux pane in the direction of the separator that can be shrunk
  if !s:VimHasNeighbour(xy_axis) && s:TmuxHasNeighbour(xy_axis)
    return 1
  elseif !s:VimHasNeighbour(xy_axis) && !s:TmuxHasNeighbour(xy_axis)
    let xy_axis_reverse=tr(xy_axis, 'jl', 'kh')
    " case: If there is one vim split before along the axis, move it
    " Otherwise, forward to tmux
    return !s:VimHasNeighbour(xy_axis_reverse)
  endif
  return 0
endfunction

" Returns an array with all windows' win_screenpos
function! s:VimLayout()
  let layout = []
  let win_nr = winnr('$')
  while win_nr > 0
    call add(layout, win_screenpos(win_nr))
    let win_nr = win_nr - 1
  endwhile
  return layout
endfunction

function! s:TmuxAwareResize(direction)
  if s:ShouldForwardResizeBackToTmux(a:direction)
    let args = 'resize-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'hjkl', 'LDUR') . " " . g:tmux_navigator_resize_step
    silent call s:TmuxCommand(args)
  else
    let l:layout_before = s:VimLayout()
    call s:VimResize(a:direction)
    let l:layout_after = s:VimLayout()
    if l:layout_before == l:layout_after
      let tmux_sep_direction=tr(a:direction, 'hjkl', 'ljjl')
      if !s:TmuxHasNeighbour(tmux_sep_direction)
	let tmux_sep_direction = tr(tmux_sep_direction, 'jl', 'kh')
      endif
      " If we are moving away from the separator, we should resize the
      " previous pane along the axes
      let tmux_direction_previous = get({'h':'left', 'j':'up', 'k':'up', 'l':'left'}, tmux_sep_direction)
      let tmux_pane_to_resize = (tmux_sep_direction == a:direction) ? shellescape($TMUX_PANE) : "{" . tmux_direction_previous . "-of}"
      let tmux_resize_direction = (tmux_sep_direction == a:direction) ? tr(a:direction, 'hjkl', 'LDUR') : tr(a:direction, 'hjkl', 'LUUL')
      let args = 'resize-pane -t ' . tmux_pane_to_resize . ' -' . tmux_resize_direction . " " . g:tmux_navigator_resize_step
      silent call s:TmuxCommand(args)
    endif
  endif
  if s:NeedsVitalityRedraw()
    redraw!
  endif
endfunction
