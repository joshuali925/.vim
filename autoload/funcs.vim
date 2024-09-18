function! s:f(line, base) abort
  let idx = match(a:line, '\V' . a:base)
  if idx == -1
    return ''
  endif
  return strpart(a:line, idx)
endfunction
function! funcs#complete_word(findstart, base)
  if a:findstart
    return match(getline('.'), '\S\+\%' . col('.') . 'c')
  endif
  let lines = getline(1, '$')
  let words = split(join(lines, "\n"))
  let matched_words = len(a:base) ? exists('*matchfuzzy') ? matchfuzzy(words, a:base) : filter(words, 'match(v:val, "\\V" . a:base) != -1') : words
  let matched_suffixes = map(lines, 's:f(v:val, a:base)')
  return map(matched_words + matched_suffixes, '{"word": v:val, "kind": "[WORD]"}')
endfunction

function! funcs#simple_complete()
  if pumvisible()
    return "\<C-n>"
  endif
  let column = col('.')
  let line = getline('.')
  if !(column>1 && strpart(line, column-2, 3)=~'^\w')
    let pre_char = line[column-2]
    if pre_char == '.'
      return "\<C-x>\<C-o>\<C-p>"
    elseif pre_char == '/'
      return "\<C-x>\<C-f>\<C-p>"
    else
      return "\<Tab>"
    endif
  endif
  let substr = matchstr(strpart(line, -1, column+1), "[^ \t]*$")
  if match(substr, '\/') != -1
    return "\<C-x>\<C-f>"
  else
    return "\<C-n>"
  endif
endfunction

function! funcs#get_session_names(arg_lead, cmd_line, cursor_pos)
  return map(glob(stdpath('data') . '/session_*.vim', 0, 1), 'substitute(v:val, stdpath("data") . "/session_", "", "")[0:-5]')
endfunction

function! funcs#grep(prg, pattern)
  let saved_errorformat = &errorformat
  set errorformat=%f:%l:%c:%m,%f:%l:%m,%f
  if a:prg == 'glob'
    let command = a:pattern[0] == '*' ? '{**/.' . a:pattern . ',**/' . a:pattern . '}' : '**/' . a:pattern
    if a:pattern[0] == '*'  " hidden file needs **/.*pat, {**/.*pat,**/*pat} in `command` is faster but depends on &shell and doesn't work on windows and some bash
      cgetexpr filter(glob('**/.' . a:pattern, 0, 1), '!isdirectory(v:val)')
      caddexpr filter(glob('**/' . a:pattern, 0, 1), '!isdirectory(v:val)')
    else
      cgetexpr filter(glob(command, 0, 1), '!isdirectory(v:val)')
    endif
  else
    let command = a:prg . ' ' . a:pattern
    cgetexpr systemlist(command)
  endif
  let &errorformat = saved_errorformat
  let len = len(getqflist())
  silent! call setqflist([], 'a', {'title': '(' . len . ') ' . command })  " setqflist() does not support 'title' in 7.4
  if len > 1
    copen
  else
    cfirst
  endif
endfunction

function! funcs#home() abort
  let start = match(getline('.'), '\S')
  return start == -1 && col('.') == col('$') - 1 || start == col('.') - 1 ? '0' : '^'
endfunction

function! funcs#edit_register() abort
  let r = nr2char(getchar())
  call feedkeys('q:ilet @' . r . " = \<C-r>\<C-r>=string(@" . r . ")\<CR>\<Esc>0f'", 'n')
endfunction

function! funcs#quit(buffer_mode, force) abort
  let buf_len = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))  " old method for compatibility
  let has_nvim = has('nvim')
  let win_len = has_nvim ? len(filter(nvim_list_wins(), 'nvim_win_get_config(v:val).relative == ""')) : winnr('$')  " exclude nvim floating windows
  let sidebars = ['help', 'netrw', 'man', 'qf', 'neo-tree', 'toggleterm', 'fugitiveblame']
  if has_nvim && nvim_win_get_config(0).relative != ''  " floating window focused
    quit
  elseif (a:buffer_mode == 0 && a:force == 1)  " <leader>Q
    if tabpagenr('$') == 1
      quitall
    else
      tabclose
    endif
  " delete buffer if has multiple buffers open and one of the following: used <leader>x; last window; multiple windows but the other ones are sidebars
  elseif (buf_len > 1 && (a:buffer_mode == 1 || tabpagenr('$') == 1 && win_len == 1)) || (win_len > 1 && len(filter(range(1, win_len), 'v:val != winnr() && index(sidebars, getbufvar(winbufnr(v:val), "&filetype")) >= 0')) == win_len - 1 && (buf_len > 1 || bufname('%') != ''))
    if has_nvim
      execute 'lua require("mini.bufremove").delete(0, ' . (a:force ? 'true' : 'false') . ')'
    else
      call plugins#bbye#bdelete('bdelete', (a:force ? '!' : ''), '')
    endif
  else
    execute 'quit' . (a:force ? '!' : '')
  endif
endfunction

function! funcs#quit_netrw_and_dirs()
  for i in range(1, bufnr('$'))
    if buflisted(i) && (getbufvar(i, '&filetype') == 'netrw' || isdirectory(bufname(i)) == 1)
      execute 'bdelete ' . i
    endif
  endfor
  if &filetype == 'netrw'
    if get(g:, 'dot_vim_dir', '') != ''
      call writefile([b:netrw_curdir], g:dot_vim_dir . '/tmp/last_result')
      echo "last_result: '" . b:netrw_curdir . "'"
    endif
    execute get(g:, 'should_quit_netrw', 0) ? 'quit' : 'bdelete'
  endif
endfunction

function! funcs#print_variable(visual, printAbove) abort
  let new_line = 'normal! ' . (a:printAbove ? 'O' : 'o') . "\<Space>\<BS>"
  let word = a:visual ? funcs#get_visual_selection() : expand('<cword>')
  let print = {}
  let print['python'] = "print('❗" . word . ":', " . word . ')'
  let print['javascript'] = "console.log('❗" . word . ":', " . word . ');'
  let print['typescript'] = print['javascript']
  let print['typescriptreact'] = print['javascript']
  let print['java'] = 'System.out.println("[" + getClass().getSimpleName() + " " + (' . word . ').getClass().getSimpleName() + "] ❗' . word . ': " + ' . word . ');'
  let print['kotlin'] = 'println("[${javaClass.simpleName}] ❗' . word . ': " + ' . word . ')'
  let print['groovy'] = 'println "❗' . word . ': " + ' . word
  let print['vim'] = "echomsg '❗" . word . ":' " . word
  let print['lua'] = 'print("❗' . word . ': " .. vim.inspect(' . word . '))'
  let print['sh'] = 'echo "❗' . word . ': ${' . word . '}"'
  let print['bash'] = print['sh']
  let print['zsh'] = print['sh']
  let print['tmux'] = 'display-message "❗' . word . '"'
  if has_key(print, &filetype)
    let pos = getcurpos()
    execute new_line
    call append(line('.'), print[&filetype])
    join
    call setpos('.', pos)
  endif
endfunction

" TODO https://github.com/rcarriga/neotest
function! funcs#jest_context() abort
  let pos = getcurpos()
  normal! $
  let regex = '([''"`]\zs[^''"`]\+\ze'
  let desc_match = matchstr(getline(search('^\s*describe' . regex, 'cbnW')), 'describe' . regex)
  let it_match = matchstr(getline(search('^\s*\(it\|test\)' . regex, 'cbnW')), '\(it\|test\)' . regex)
  call setpos('.', pos)
  return '"' . desc_match . ' ' . it_match . '"'
endfunction

function! funcs#get_run_command() abort
  if expand('%') =~ '\.class'
    call funcs#decompile_java_class()
    return
  endif
  update
  let user_command = get(b:, 'RunCommand', get(g:, 'RunCommand', ''))
  if user_command != ''
    return user_command
  endif
  if expand('%') =~ '\.test\.[tj]sx\?'
    return 'TermExec size=' . max([10, &columns * 1/2]) . " direction=vertical cmd=' yarn test:jest " . expand('%') . ' -t ' . funcs#jest_context() . ' --coverage --coverageReporters=text -u' . "'"
  endif
  let run_command = {}
  let run_command['vim'] = 'source %'
  let run_command['lua'] = 'luafile %'
  if exists(':TermExec')
    let run_command['python'] = "TermExec cmd=' python3 \"%\"'"
    let run_command['javascript'] = "TermExec cmd=' node \"%\"'"
    let run_command['typescript'] = "TermExec cmd=' npx ts-node --esm \"%\"'"
    let run_command['java'] = "TermExec cmd=' javac \"%\" && java -classpath \"%:p:h\" \"%:t:r\"'"
  else
    let run_command['python'] = '!clear; python3 %'
    let run_command['javascript'] = '!clear; node %'
  endif
  let run_command['html'] = 'silent !open "$(VIM_FILEPATH)"'
  let run_command['xhtml'] = 'silent !open "$(VIM_FILEPATH)"'
  let run_command['http'] = 'lua require("kulala").run()'
  let run_command['markdown'] = $SSH_CLIENT != '' ? 'Glow' : 'MarkdownPreview'
  return get(run_command, &filetype, '') . get(b:, 'args', '')
endfunction

function! funcs#get_visual_selection()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  if column_end > getcharpos("'>")[2]
    let column_end = min([column_end + 2, v:maxcol])
  endif
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

function! s:DoAction(algorithm, type)  " https://vim.fandom.com/wiki/Act_on_text_objects_with_custom_functions
  let sel_save = &selection
  let cb_save = &clipboard
  set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
  let reg_save = @x
  if a:type =~ '^\d\+$'
    silent execute 'normal! V' . a:type . '$"xy'
  elseif a:type =~ '^.$'
    silent execute "normal! `<" . a:type . '`>"xy'
  elseif a:type == 'line'
    silent execute "normal! '[V']\"xy"
  elseif a:type == 'block'
    silent execute "normal! `[\<C-v>`]\"xy"
  else
    silent execute 'normal! `[v`]"xy'
  endif
  let repl = s:{a:algorithm}(@x)
  if type(repl) == 1
    call setreg('x', repl, getregtype('x'))
    normal! gvp
  endif
  let @x = reg_save
  let &selection = sel_save
  let &clipboard = cb_save
endfunction
function! s:ActionOpfunc(type)
  return s:DoAction(s:encode_algorithm, a:type)
endfunction
function! s:ActionSetup(algorithm)
  let s:encode_algorithm = a:algorithm
  let &operatorfunc = matchstr(expand('<sfile>'), '<SNR>\d\+_') . 'ActionOpfunc'
endfunction
function! s:MapAction(algorithm, key)
  execute 'nnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>ActionSetup("' . a:algorithm . '")<CR>g@'
  execute 'xnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>DoAction("' . a:algorithm . '", visualmode())<CR>'
  execute 'nnoremap <silent> <Plug>actionsLine'.a:algorithm.' :<C-U>call <SID>DoAction("' . a:algorithm . '", v:count1)<CR>'
  execute 'nmap ' . a:key . '  <Plug>actions' . a:algorithm
  execute 'xmap ' . a:key . '  <Plug>actions' . a:algorithm
  execute 'nmap ' . a:key.a:key[strlen(a:key)-1] . ' <Plug>actionsLine' . a:algorithm
endfunction

function! funcs#map_vim_send_terminal()
  function! s:SendToTerminal(str)
    let buff_n = term_list()
    if len(buff_n) > 0
      let buff_n = buff_n[0]  " sends to most recently opened terminal
      let lines = getline(getpos("'<")[1], getpos("'>")[1])
      let indent = match(lines[0], '[^ \t]')  " remove unnecessary indentation if first line is indented
      for line in lines
        call term_sendkeys(buff_n, (match(line, '[^ \t]') ? line[indent:] : line) . "\<CR>")
        sleep 10m
      endfor
    endif
  endfunction
  call <SID>MapAction('SendToTerminal', '<leader>te')
endfunction

function! funcs#decompile_java_class() abort
  if !filereadable(expand('~/.local/lib/cfr.jar'))
    call system('curl -L -o ~/.local/lib/cfr.jar https://github.com/leibnitz27/cfr/releases/download/0.152/cfr-0.152.jar')
  endif
  if glob('%') != ''
    silent %!java -jar ~/.local/lib/cfr.jar %
  else
    write! ~/.vim/tmp/cfr-temp.class
    silent %!java -jar ~/.local/lib/cfr.jar ~/.vim/tmp/cfr-temp.class
    call system('rm -f ~/.vim/tmp/cfr-temp.class')
  endif
  set nomodified readonly filetype=java
endfunction

function! funcs#ctags() abort
  try
    silent execute 'ltag ' . expand('<cword>')
    echo 'tag 1 of ' . len(getloclist(0))
  catch /^Vim\%((\a\+)\)\=:E433:/
    call funcs#ctags_create_and_jump()
  endtry
endfunction

function! funcs#ctags_create_and_jump() abort
  let types = {
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
        \ }
  let answer = input('Generate ctags for language ("all" for all supported, empty to cancel): ', get(types, &filetype, &filetype), 'filetype')  " language list: ctags --list-languages
  if answer != ''
    let args = answer == 'all' ? '' : '--languages=' . answer
    " TODO https://github.com/universal-ctags/ctags/issues/2667
    execute '!ctags --exclude=.git --exclude=node_modules --exclude=venv --langmap=TypeScript:.ts.tsx -R ' . args
    silent execute 'ltag ' . expand('<cword>')
    echo 'tag 1 of ' . len(getloclist(0))
  endif
endfunction
