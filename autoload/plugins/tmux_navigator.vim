" commit: 9ca5bfe5bd274051b5dd796cc150348afc993b80
" resize reference: https://github.com/martin-louazel-engineering/vim-tmux-navigator

" Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are
" no more windows in that direction, forwards the operation to tmux.
" Additionally, <C-\> toggles between last active vim splits/tmux panes.

if exists("g:loaded_tmux_navigator") || &cp
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

function! s:VimHasNeighbour(direction)
  return winnr(a:direction) != winnr()
endfunction

function! s:VimLayout()
  let layout = []
  let win_nr = winnr('$')
  while win_nr > 0
    call add(layout, [win_screenpos(win_nr), winwidth(win_nr), winheight(win_nr)])
    let win_nr = win_nr - 1
  endwhile
  return layout
endfunction

function! s:SystemCommand(cmd)
  let shellcmdflag = &shellcmdflag
  try
    let &shellcmdflag = '-c'
    return system(a:cmd)
  finally
    let &shellcmdflag = shellcmdflag
  endtry
endfunction

function! s:Spawn(cmd)
  if has('nvim')
    call jobstart(a:cmd, {'detach': v:true})
  else
    call job_start(a:cmd, {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
  endif
endfunction

if empty($TMUX) && !empty($HERDR_ENV)
  let s:herdr_directions = {'h': 'left', 'j': 'down', 'k': 'up', 'l': 'right'}

  function! s:HerdrDirection(direction)
    return get(s:herdr_directions, a:direction, '')
  endfunction

  function! s:HerdrCommand(args)
    if empty($HERDR_BIN_PATH)
      return ''
    endif
    return s:SystemCommand(shellescape($HERDR_BIN_PATH) . ' ' . a:args)
  endfunction

  function! s:HerdrPane(action, direction)
    let direction = s:HerdrDirection(a:direction)
    if empty($HERDR_BIN_PATH) || empty(direction)
      return
    endif
    call s:Spawn([$HERDR_BIN_PATH, 'pane', a:action, '--direction', direction, '--current'])
  endfunction

  function! s:HerdrHasNeighbour(direction)
    let direction = s:HerdrDirection(a:direction)
    if empty(direction)
      return 0
    endif
    let result = s:HerdrCommand('pane neighbor --direction ' . direction . ' --current')
    return result =~# '"neighbor_pane_id"\s*:\s*"[^"]\+"'
  endfunction

  function! s:HerdrAwareNavigate(direction)
    let window = winnr()
    call s:VimNavigate(a:direction)
    if window == winnr()
      call s:HerdrPane('focus', a:direction)
    endif
  endfunction

  function! s:ShouldForwardResizeBackToHerdr(direction)
    if tabpagewinnr(tabpagenr(), '$') == 1
      return 1
    endif
    let separator_direction = tr(a:direction, 'hjkl', 'ljjl')
    if s:VimHasNeighbour(separator_direction)
      return 0
    endif
    if s:HerdrHasNeighbour(separator_direction)
      return 1
    endif
    let reverse_direction = tr(separator_direction, 'jl', 'kh')
    return !s:VimHasNeighbour(reverse_direction)
  endfunction

  function! s:HerdrAwareResize(direction)
    if s:ShouldForwardResizeBackToHerdr(a:direction)
      call s:HerdrPane('resize', a:direction)
      return
    endif
    let layout_before = s:VimLayout()
    call s:VimResize(a:direction)
    if layout_before == s:VimLayout()
      call s:HerdrPane('resize', a:direction)
    endif
  endfunction

  function! plugins#tmux_navigator#navigate(direction)
    call s:HerdrAwareNavigate(a:direction)
  endfunction
  function! plugins#tmux_navigator#resize(direction)
    call s:HerdrAwareResize(a:direction)
  endfunction
  finish
endif

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

function! s:TmuxSocket()
  " The socket path is the first value in the comma-separated list of $TMUX.
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  return s:SystemCommand(cmd)
endfunction

function! s:TmuxSpawn(args)
  call s:Spawn([s:TmuxOrTmateExecutable(), '-S', s:TmuxSocket()] + a:args)
endfunction

" Zoom flag and, per direction, whether the vim pane is at the window edge.
function! s:TmuxPaneState()
  let flags = split(s:TmuxCommand('display-message -p -t ' . shellescape($TMUX_PANE)
        \ . " '#{window_zoomed_flag} #{pane_at_left} #{pane_at_bottom} #{pane_at_top} #{pane_at_right}'"))
  let [zoomed, h, j, k, l] = map(flags + ['0', '0', '0', '0', '0'], 'v:val == "1"')[:4]
  return {'zoomed': zoomed, 'h': h, 'j': j, 'k': k, 'l': l}
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
  if tmux_last_pane || at_tab_page_edge
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
    let args = ['select-pane', '-t', $TMUX_PANE, '-' . tr(a:direction, 'phjkl', 'lLDUR')]
    if g:tmux_navigator_preserve_zoom == 1
      let args += ['-Z']
    endif
    if g:tmux_navigator_disable_when_zoomed
      let args = ['if-shell', '-F', '-t', $TMUX_PANE, '#{?window_zoomed_flag,,1}', join(args)]
    endif
    call s:TmuxSpawn(args)
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction

function! s:ShouldForwardResizeBackToTmux(direction, state)
  if g:tmux_navigator_disable_when_zoomed && a:state.zoomed
    return 0
  endif
  if tabpagewinnr(tabpagenr(), '$') == 1
    return 1
  endif
  let xy_axis=tr(a:direction, 'hjkl', 'ljjl')
  " case: there are no more vim neighboring windows, and there is still at
  " least one tmux pane in the direction of the separator that can be shrunk
  if !s:VimHasNeighbour(xy_axis) && !a:state[xy_axis]
    return 1
  elseif !s:VimHasNeighbour(xy_axis)
    let xy_axis_reverse=tr(xy_axis, 'jl', 'kh')
    " case: If there is one vim split before along the axis, move it
    " Otherwise, forward to tmux
    return !s:VimHasNeighbour(xy_axis_reverse)
  endif
  return 0
endfunction

function! s:TmuxAwareResize(direction)
  let state = s:TmuxPaneState()
  if s:ShouldForwardResizeBackToTmux(a:direction, state)
    call s:TmuxSpawn(['resize-pane', '-t', $TMUX_PANE, '-' . tr(a:direction, 'hjkl', 'LDUR'), g:tmux_navigator_resize_step . ''])
  else
    let l:layout_before = s:VimLayout()
    call s:VimResize(a:direction)
    let l:layout_after = s:VimLayout()
    if l:layout_before == l:layout_after
      let tmux_sep_direction=tr(a:direction, 'hjkl', 'ljjl')
      if state[tmux_sep_direction]
	let tmux_sep_direction = tr(tmux_sep_direction, 'jl', 'kh')
      endif
      " If we are moving away from the separator, we should resize the
      " previous pane along the axes
      let tmux_direction_previous = get({'h':'left', 'j':'up', 'k':'up', 'l':'left'}, tmux_sep_direction)
      let tmux_pane_to_resize = (tmux_sep_direction == a:direction) ? $TMUX_PANE : "{" . tmux_direction_previous . "-of}"
      let tmux_resize_direction = (tmux_sep_direction == a:direction) ? tr(a:direction, 'hjkl', 'LDUR') : tr(a:direction, 'hjkl', 'LUUL')
      call s:TmuxSpawn(['resize-pane', '-t', tmux_pane_to_resize, '-' . tmux_resize_direction, g:tmux_navigator_resize_step . ''])
    endif
  endif
endfunction
