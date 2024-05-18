" https://raw.githubusercontent.com/lifepillar/vim-zeef/HEAD/autoload/zeef.vim
" Name:        Zeef
" Author:      Lifepillar <lifepillar@lifepillar.me>
" Maintainer:  Lifepillar <lifepillar@lifepillar.me>
" License:     MIT
" Description: Zeef is Dutch for sieve, I am told
" commit: 195659ef40594dde249988622f50dde32ffd9007

" Internal state {{{
let s:use_matchfuzzy = exists('*matchfuzzy')
let s:use_rg = executable('rg')
let s:use_find = !s:use_rg && !has('win32') && executable('find')
let s:use_dir = !s:use_find && has('win32') && executable('dir')

" The prompt
let s:prompt = get(g:, 'zeef_prompt', '> ')

" Zeef's buffer number
let s:bufnr = -1

" Window layout to restore when the finder is closed
let s:winrestsize = ''

" The selected items
let s:result = []

" The callback to be invoked on the selected items
let s:callback = ''

" The latest key press
let s:keypressed = ''

" Text used to filter the input list
let s:filter = ''

" Stack of 0s/1s that tells whether to undo when pressing backspace.
" If the top of the stack is 1 then undo; if it is 0, do not undo.
let s:undoseq = []

" Stack of fuzzy matched positions.
let s:match_pos_stack = []

" Default regexp filter.
"
" This behaves mostly like globbing, except that ^ and $ can be used to anchor
" a pattern. All characters are matched literally except ^, $, and the
" wildchar; the latter matches zero 0 more characters.
fun! s:default_regexp(input)
  return substitute(escape(a:input, '~.\[:'), get(g:, 'zeef_wildchar', ' '), '.\\{-}', 'g')
endf

" The function used to generate the filter
let s:Regexp = get(g:, 'Zeef_regexp', function('s:default_regexp'))
" }}}
" Key actions {{{
fun! plugins#zeef#up()
  execute 'norm!' (line('.') == 1 ? 'G' : 'k')
  return 0
endf

fun! plugins#zeef#down()
  execute 'norm!' (line('.') == line('$') ? 'gg' : 'j')
  return 0
endf

fun! plugins#zeef#right()
  norm! 5zl
  return 0
endf

fun! plugins#zeef#left()
  norm! 5zh
  return 0
endf

fun! plugins#zeef#passthrough()
  execute "normal" s:keypressed
  return 0
endf

fun! plugins#zeef#clear()
  silent undo 1
  let s:undoseq = []
  let s:match_pos_stack = []
  let s:filter = ''
  return 0
endf

fun! plugins#zeef#toggle_fuzzy()
  if exists('*matchfuzzy')
    let s:use_matchfuzzy = 1 - s:use_matchfuzzy
    call plugins#zeef#clear()
  endif
endf

fun! plugins#zeef#close(action)
  if empty(s:result)
    call add(s:result, getline('.'))
  endif
  let &l:scrolloff = s:saved_scrolloff
  wincmd p
  execute "bwipe!" s:bufnr
  execute s:winrestsize
  if index(['split', 'vsplit', 'tabnew'], a:action) != -1
    execute a:action
  endif
  redraw
  echo "\r"
  return 1
endf

if has('textprop')
  fun! s:mark(linenr)
    call prop_add(a:linenr, 1,  { 'bufnr': s:bufnr, 'type': 'zeef', 'length': len(getline(a:linenr)) })
  endf

  fun! s:unmark(linenr)
    call prop_remove({ 'bufnr': s:bufnr, 'type': 'zeef' }, a:linenr)
  endf
else
  fun! s:mark(linenr)
  endf

  fun! s:unmark(linenr)
  endf
endif

fun! plugins#zeef#toggle()
  let l:idx = index(s:result, getline('.'))
  if l:idx != -1
    call remove(s:result, l:idx)
    call s:unmark(line('.'))
  else
    call add(s:result, getline('.'))
    call s:mark(line('.'))
  endif
  return 0
endf

fun! plugins#zeef#toggle_up()
  call plugins#zeef#toggle()
  call plugins#zeef#up()
  return 0
endf

fun! plugins#zeef#toggle_down()
  call plugins#zeef#toggle()
  call plugins#zeef#down()
  return 0
endf

fun! plugins#zeef#deselect_all()
  call plugins#zeef#clear()
  if has('textprop')
    call prop_remove({ 'bufnr': s:bufnr, 'type': 'zeef', 'all': 1}, 1, line('$'))
  endif
  let s:result = []
  return 0
endf

fun! plugins#zeef#deselect_current()
  for l:linenr in range(1, line('$'))
    let l:idx = index(s:result, getline(l:linenr))
    if l:idx != -1
      call remove(s:result, l:idx)
      call s:unmark(l:linenr)
    endif
  endfor
endf

fun! plugins#zeef#select_current()
  for l:linenr in range(1, line('$'))
    let l:idx = index(s:result, getline(l:linenr))
    if l:idx == -1
      call add(s:result, getline(l:linenr))
      call s:mark(l:linenr)
    endif
  endfor
  return 0
endf

fun! plugins#zeef#to_quickfix()
  if empty(s:result)
    let s:result = getline('1', '$')
  endif
  let saved_errorformat = &errorformat
  set errorformat=%f
  cgetexpr s:result
  let &errorformat = saved_errorformat
  call plugins#zeef#close('')
  copen
  return 1
endf

fun! s:accept(action)
  call plugins#zeef#close(a:action)
  if !empty(s:result)
    call function(s:callback)(s:result)
  endif
  return 1
endf

fun! plugins#zeef#accept()
  return s:accept('')
endf

fun! plugins#zeef#accept_split()
  return s:accept('split')
endf

fun! plugins#zeef#accept_vsplit()
  return s:accept('vsplit')
endf

fun! plugins#zeef#accept_tabnew()
  return s:accept('tabnew')
endf

fun! s:noop()
  return 0
endf
" }}}
" Keymap {{{
let s:default_keymap = extend({
      \ "\<c-k>":   function('plugins#zeef#up'),
      \ "\<up>":    function('plugins#zeef#up'),
      \ "\<c-j>":   function('plugins#zeef#down'),
      \ "\<down>":  function('plugins#zeef#down'),
      \ "\<left>":  function('plugins#zeef#left'),
      \ "\<right>": function('plugins#zeef#right'),
      \ "\<c-d>":   function('plugins#zeef#passthrough'),
      \ "\<c-e>":   function('plugins#zeef#passthrough'),
      \ "\<c-y>":   function('plugins#zeef#passthrough'),
      \ "\<c-u>":   function('plugins#zeef#clear'),
      \ "\<c-g>":   function('plugins#zeef#deselect_all'),
      \ "\<c-q>":   function('plugins#zeef#to_quickfix'),
      \ "\<tab>":   function('plugins#zeef#toggle_down'),
      \ "\<s-tab>": function('plugins#zeef#toggle_up'),
      \ "\<c-a>":   function('plugins#zeef#select_current'),
      \ "\<c-r>":   function('plugins#zeef#deselect_current'),
      \ "\<enter>": function('plugins#zeef#accept'),
      \ "\<c-x>":   function('plugins#zeef#accept_split'),
      \ "\<c-v>":   function('plugins#zeef#accept_vsplit'),
      \ "\<c-t>":   function('plugins#zeef#accept_tabnew'),
      \ "\<c-f>":   function('plugins#zeef#toggle_fuzzy'),
      \ }, get(g:, "zeef_keymap", {}))
" }}}
" Main interface {{{

fun! s:redraw(prompt, match_positions)
  call matchadd('Comment', '\(\s*\d\+:\)\?\zs.*[/\\]\ze.*$') " Regex taken from habamax/vim-select
  if !empty(s:filter)
    if !s:use_matchfuzzy
      call matchadd('ZeefMatch', '\c' . s:Regexp(s:filter))
    elseif s:ch >=# 0x20
      call add(s:match_pos_stack, flatten(map(a:match_positions, {line, cols -> map(cols, {_, col -> [line + 1, col + 1]})}), 1))
    elseif s:keypressed ==# "\<bs>" && len(s:match_pos_stack) > 0
      call remove(s:match_pos_stack, -1)
    endif
    if len(s:match_pos_stack) > 0 && len(s:match_pos_stack[-1]) > 0
      call matchaddpos('ZeefMatch', s:match_pos_stack[-1])
    endif
  endif
  redraw
  echo a:prompt
endf

fun! plugins#zeef#statusline()
  return '%#ZeefName# [' . s:label . ']' . (s:use_matchfuzzy ? '[Fuzzy]' : '') . ' %* %l of %L'
        \ . (empty(s:result) ? '' : printf(" (%d selected)", len(s:result)))
endf

fun! plugins#zeef#keypressed()
  return s:keypressed
endf

fun! plugins#zeef#result()
  return s:result
endf

" Interactively filter a list of items as you type,
" and execute an action on the selected item.
"
" items: A List of items to be filtered
" callback: A function, funcref, or lambda to be called on the selected item(s)
" label: A name for the finder's prompt
" ...: optional query, optional keymap
fun! plugins#zeef#open(items, callback, label, ...) abort
  let s:winrestsize = winrestcmd()
  let s:callback = a:callback
  let s:result = []
  let s:undoseq = []
  let s:match_pos_stack = []
  let s:filter = ''
  let s:saved_scrolloff = &scrolloff  " scrolloff is global in 7.4
  let l:query = a:0 > 0 ? a:1 : ''

  hi default link ZeefMatch Special
  hi default link ZeefName StatusLine
  hi default      ZeefSelected term=reverse cterm=reverse gui=reverse

  " botright 10new may not set the right height, e.g., if the quickfix window is open
  execute get(g:, 'zeef_use_tab', 0) ? 'tabe' : printf("botright :1new | %dwincmd +", get(g:, 'zeef_height', 10) - 1)
  setlocal buftype=nofile bufhidden=wipe nobuflisted filetype=zeef
        \  modifiable noreadonly noswapfile noundofile
        \  foldmethod=manual nofoldenable nolist nospell
        \  nowrap scrolloff=0 textwidth=0 winfixheight
        \  cursorline nocursorcolumn nonumber norelativenumber
        \  statusline=%!plugins#zeef#statusline()
  abclear <buffer>

  let s:bufnr = bufnr('%')
  call setline(1, a:items)

  let s:keymap = a:0 > 1 ? extend(copy(s:default_keymap), a:2) : s:default_keymap

  if has('textprop')
    call prop_type_add('zeef', { 'bufnr': s:bufnr, 'highlight': 'ZeefSelected' })
  endif

  let s:Regexp = get(g:, 'Zeef_regexp', function('s:default_regexp'))
  let s:label = a:label
  let l:prompt = s:prompt
  call s:redraw(l:prompt, [])

  while 1
    let &ro=&ro     " Force status line update
    let l:error = 0 " Set to 1 when the input pattern is invalid
    let l:match_positions = []
    call clearmatches()

    if l:query != ''
      let s:ch = char2nr(l:query[0])
      let l:query = l:query[1:-1]
      let &undolevels = &undolevels " Break undo
    else
      try
        let s:ch = getchar()
      catch /^Vim:Interrupt$/  " CTRL-C
        return plugins#zeef#close('')
      endtry
    endif
    let s:keypressed = (type(s:ch) == 0 ? nr2char(s:ch) : s:ch)

    if s:ch >=# 0x20 " Printable character
      let s:filter .= s:keypressed
      if strchars(s:filter) < get(g:, 'zeef_skip_first', 0)
        call s:redraw(l:prompt . s:filter, l:match_positions)
        continue
      endif
      let l:seq_old = get(undotree(), 'seq_cur', 0)
      try
        if s:use_matchfuzzy
          let [l:match_results, l:match_positions, l:scores] = matchfuzzypos(a:items, s:filter)
          %d _ | call setline(1, l:match_results)
        else
          execute 'silent keeppatterns v:\m' . s:Regexp(s:filter) . ':d _'
        endif
      catch /^Vim\%((\a\+)\)\=:E/
        let l:error = 1
      endtry
      let l:seq_new = get(undotree(), 'seq_cur', 0)
      call add(s:undoseq, l:seq_new != l:seq_old) " seq_new != seq_old iff the buffer has changed
      norm! gg
    elseif s:keypressed ==# "\<bs>" " Backspace
      let s:filter = strpart(s:filter, 0, strchars(s:filter) - 1)
      if (empty(s:undoseq) ? 0 : remove(s:undoseq, -1))
        silent undo
      endif
      norm! gg
    elseif s:keypressed == "\<esc>"
      return plugins#zeef#close('')
    elseif get(s:keymap, s:keypressed, function('s:noop'))()
      return
    endif

    call s:redraw((l:error ? '[Invalid pattern] ' : '') . l:prompt . s:filter, l:match_positions)
  endwhile
endf
" }}}
" Sample applications {{{

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Simple path filters
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! plugins#zeef#set_arglist(result)
  execute "args" join(map(a:result, 'fnameescape(v:val)'))
endf

" Filter a list of paths and populate the arglist with the selected items.
fun! plugins#zeef#args(paths, ...) " ...: optional label
  call plugins#zeef#open(a:paths, 'plugins#zeef#set_arglist', a:0 > 0 ? a:1 : 'Files')
endf

" Ditto, but use the paths in the specified directory
fun! plugins#zeef#files(...) " ...: optional query, optional directory
  let l:query = (a:0 > 0 ? a:1 : '')
  if s:use_rg
    let l:files = systemlist('rg --files ' . (a:0 > 1 ? a:2 : ''))
  elseif s:use_find
    let l:files = systemlist('find ' . (a:0 > 1 ? a:2 : '.') . ' -type f -not -path "*/.git/*"')
  elseif s:use_dir
    let l:files = systemlist('dir /s /b /a:-d ' . (a:0 > 1 ? a:2 : '.'))
  else
    let l:dir = a:0 > 1 ? a:2 . '/' : ''
    let l:files = filter(glob(l:dir . '**/*', 0, 1) + glob(l:dir . '**/.*', 0, 1), '!isdirectory(v:val)')
  endif
  call plugins#zeef#open(l:files, 'plugins#zeef#set_arglist', 'Files', l:query)
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" A buffer switcher
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! s:switch_to_buffer(result)
  execute "buffer" matchstr(a:result[0], '^\s*\zs\d\+')
endf

" props is a dictionary with the following keys:
"   - unlisted: when set to 1, show also unlisted buffers
fun! plugins#zeef#buffer(props)
  redir => ls_output
  execute 'ls' . (get(a:props, 'unlisted', 0) ? '!' : '')
  redir END
  let l:buffers = map(split(ls_output, "\n"), 'substitute(v:val, ''"\(.*\)"\s*line\s*\d\+$'', ''\1'', "")')
  call plugins#zeef#open(l:buffers, 's:switch_to_buffer', 'Switch buffer')
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find in buffer lines
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! s:jump_to_line(result)
  execute matchstr(a:result[0], '^\d\+\t\t▏ ') + 1
endf

fun! plugins#zeef#buffer_lines()
  call plugins#zeef#open(map(getline(1, '$'), 'v:key . "\t\t▏ " . v:val'), 's:jump_to_line', 'Find line')
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find in quickfix/location list
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! s:jump_to_qf_entry(result)
  execute "crewind" matchstr(a:result[0], '^\s*\d\+', '')
endf

fun! s:jump_to_loclist_entry(result)
  execute "lrewind" matchstr(a:result[0], '^\s*\d\+', '')
endf

fun! plugins#zeef#qflist()
  let l:qflist = getqflist()
  if empty(l:qflist)
    echo '[Zeef] Quickfix list is empty'
    return
  endif
  call plugins#zeef#open(split(execute('clist'), "\n"), 's:jump_to_qf_entry', 'Filter quickfix entry')
endf

fun! plugins#zeef#loclist(winnr)
  let l:loclist = getloclist(a:winnr)
  if empty(l:loclist)
    echo '[Zeef] Location list is empty'
    return
  endif
  call plugins#zeef#open(split(execute('llist'), "\n"), 's:jump_to_loclist_entry', 'Filter loclist entry')
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! s:set_colorscheme(result)
  execute "colorscheme" a:result[0]
endf

let s:colors = []

fun! plugins#zeef#colorscheme()
  if empty(s:colors)
    let s:colors = map(globpath(&runtimepath, "colors/*.vim", 0, 1) , 'fnamemodify(v:val, ":t:r")')
    let s:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", 0, 1) , 'fnamemodify(v:val, ":t:r")')
  endif
  call plugins#zeef#open(s:colors, 's:set_colorscheme', 'Colorscheme')
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MRU
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filter oldfiles to not be vim_doc, current file, non-exist files
fun! s:f(f) abort
  let p = expand(a:f)
  return stridx(p, s:d) < 0 && p != s:b && filereadable(p)
endf
fun! s:F(f, d) abort
  let p = expand(a:f)
  return stridx(p, s:d) < 0 && p != s:b && filereadable(p) && stridx(p, a:d) == 0
endf
fun! plugins#zeef#filter_oldfiles(cwd)
  let s:d = expand("$VIMRUNTIME") . (has("win32") ? '\' : '/') . "doc"
  let s:b = expand('%:p')
  if a:cwd == 1
    let d = getcwd()
    return filter(copy(v:oldfiles), 's:F(v:val,d)')
  endif
  return filter(copy(v:oldfiles), 's:f(v:val)')
endf

fun! plugins#zeef#oldfiles(cwd)
  call plugins#zeef#args(plugins#zeef#filter_oldfiles(a:cwd), 'MRU' . (a:cwd == 1 ? '_CWD' : ''))
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetypes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! s:set_filetype(result)
  if a:result[0] != ''
    let &filetype = a:result[0]
  endif
endf

fun! plugins#zeef#filetype()
  call plugins#zeef#open(map(globpath(&rtp, 'syntax/*.vim', 0, 1), 'fnamemodify(v:val, ":t:r")'), 's:set_filetype', 'Filetypes')
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command line fuzzy finder (see ../../local-bin/fzf)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Doesn't seem possible to output to stdout in non-headless. https://vi.stackexchange.com/a/800
fun! s:select_to_file(result)
  call writefile(a:result, $HOME . '/.vim/tmp/last_result')
  quit!
endf
fun! plugins#zeef#fuzzy_select()
  let g:zeef_use_tab = 1
  set showtabline=0
  call plugins#zeef#open(getline(1, '$'), 's:select_to_file', 'Select')
  cquit!
endf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer tags (using Ctags)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ctags binary
let s:ctags = executable("uctags") ? "uctags" : "ctags"

" Adapted from CtrlP's buffertag.vim
let s:types = extend({
      \ 'aspperl':             'asp',
      \ 'aspvbs':              'asp',
      \ 'cpp':                 'c++',
      \ 'cs':                  'c#',
      \ 'delphi':              'pascal',
      \ 'expect':              'tcl',
      \ 'mf':                  'metapost',
      \ 'mp':                  'metapost',
      \ 'rmd':                 'rmarkdown',
      \ 'csh':                 'sh',
      \ 'zsh':                 'sh',
      \ 'tex':                 'latex',
      \ 'typescriptreact':     'typescript',
      \ }, get(g:, 'zeef_ctags_types', {}))

fun! plugins#zeef#tags(path, ft)
  return systemlist(printf(s:ctags . ' -f - --sort=no --excmd=number --fields= --extras=+F --language-force=%s' .
        \ ' --exclude=.git --exclude=node_modules --exclude=venv --langmap=TypeScript:.ts.tsx %s',
        \ get(s:types, a:ft, a:ft),
        \ shellescape(expand(a:path))
        \ ))
endf

fun! s:jump_to_tag(result, bufname)
  if a:result[0] =~# '^\d\+'
    let [l:line, l:tag] = split(a:result[0], '\s\+')
    execute "buffer" "+" . l:line a:bufname
  endif
endf

fun! plugins#zeef#buffer_tags()
  let l:bufname = bufname("%")
  call plugins#zeef#open(
        \ map(plugins#zeef#tags(l:bufname, &ft),
        \      { _, v -> substitute(v, '^\(\S\+\)\s.*\s\(\d\+\)$', '\2 \1', '') }
        \    ),
        \ { x -> s:jump_to_tag(x, l:bufname) },
        \ 'Tag'
        \ )
endf
" }}}
