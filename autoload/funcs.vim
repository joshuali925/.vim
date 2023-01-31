function! funcs#complete_word(findstart, base)
  if a:findstart
    return match(getline('.'), '\S\+\%'. col('.'). 'c')
  else
    let words = split(join(getline(1, '$'), "\n"))
    let matched = len(a:base) ? exists('*matchfuzzy') ? matchfuzzy(words, a:base) : filter(words, 'match(v:val, "\\V". a:base) != -1') : words
    return map(matched, '{"word": v:val, "kind": "[WORD]"}')
  endif
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

function! funcs#get_conflict_state() abort  " conflict-marker.vim
  let current_styles = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  if match(current_styles, '^Conflict') != -1
    if len(current_styles) == 2 && match(current_styles, '^ConflictMarkerBegin$') != -1 || len(current_styles) == 1 && match(current_styles, '^ConflictMarker\(Begin\|Ours\)$') != -1
      return 'Ourselves'
    elseif len(current_styles) == 2 && match(current_styles, '^ConflictMarkerEnd$') != -1 || len(current_styles) == 1 && match(current_styles, '^ConflictMarker\(End\|Theirs\)$') != -1
      return 'Themselves'
    endif
    return 'AncestorOrSeparator'
  endif
  return ''
endfunction

function! funcs#home() abort
  let start = match(getline('.'), '\S')
  return start == -1 && col('.') == col('$') - 1 || start == col('.') - 1 ? '0' : '^'
endfunction

function! funcs#edit_register() abort
  let r = nr2char(getchar())
  call feedkeys('q:ilet @'. r. " = \<C-r>\<C-r>=string(@". r. ")\<CR>\<Esc>0f'", 'n')
endfunction

function! funcs#quit(buffer_mode, force) abort
  let buf_len = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))  " old method for compatibility
  let has_nvim = has('nvim')
  let win_len = has_nvim ? len(filter(nvim_list_wins(), 'nvim_win_get_config(v:val).relative == ""')) : winnr('$')  " exclude nvim floating windows
  let sidebars = ['help', 'netrw', 'man', 'qf', 'NvimTree', 'toggleterm']
  if has_nvim && win_len == 1 && nvim_win_get_config(win_getid()).relative != ''  " floating window focused
    quit
  elseif (a:buffer_mode == 0 && a:force == 1)  " <leader>Q
    if tabpagenr('$') == 1
      quitall
    else
      tabclose
    endif
  " delete buffer if has multiple buffers open and one of the following: used <leader>x; last window; multiple windows but the other ones are sidebars
  elseif (buf_len > 1 && (a:buffer_mode == 1 || tabpagenr('$') == 1 && win_len == 1)) || (win_len > 1 && len(filter(range(1, win_len), 'v:val != winnr() && index(sidebars, getbufvar(winbufnr(v:val), "&filetype")) >= 0')) == win_len - 1 && (buf_len > 1 || bufname('%') != ''))
    call plugins#bbye#bdelete('bdelete', (a:force ? '!' : ''), '')
  else
    execute 'quit'. (a:force ? '!' : '')
  endif
endfunction

function! funcs#quit_netrw_and_dirs()
  for i in range(1, bufnr('$'))
    if buflisted(i) && (getbufvar(i, '&filetype') == 'netrw' || isdirectory(bufname(i)) == 1)
      execute 'bdelete '. i
    endif
  endfor
  if &filetype == 'netrw'
    bdelete
  endif
endfunction

function! funcs#print_variable(visual, printAbove) abort
  let new_line = 'normal! '. (a:printAbove ? 'O' : 'o'). "\<Space>\<BS>"
  let word = a:visual ? funcs#get_visual_selection() : expand('<cword>')
  let print = {}
  let print['python'] = "print('❗". word. ":', ". word. ')'
  let print['javascript'] = "console.log('❗". word. ":', ". word. ');'
  let print['typescript'] = print['javascript']
  let print['typescriptreact'] = print['javascript']
  let print['java'] = 'System.out.println("[" + getClass().getSimpleName() + " " + ('. word. ').getClass().getSimpleName() + "] ❗'. word. ': " + '. word. ');'
  let print['kotlin'] = 'println("[${javaClass.simpleName}] ❗'. word. ': " + '. word. ')'
  let print['groovy'] = 'println "❗'. word. ': " + '. word
  let print['vim'] = "echomsg '❗". word. ":' ". word
  let print['lua'] = 'print("❗'. word. ': " .. vim.inspect('. word. '))'
  let print['sh'] = 'echo "❗'. word. ': ${'. word. '}"'
  let print['bash'] = print['sh']
  let print['zsh'] = print['sh']
  let print['tmux'] = 'display-message "❗'. word. '"'
  if has_key(print, &filetype)
    let pos = getcurpos()
    execute new_line
    call append(line('.'), print[&filetype])
    join
    call setpos('.', pos)
  endif
endfunction

function! funcs#jest_context() abort
  let pos = getcurpos()
  normal! $
  let regex = '(''\zs[^'']\+\ze'
  let desc_match = matchstr(getline(search('describe'. regex, 'cbnW')), 'describe'. regex)
  let it_match = matchstr(getline(search('\(it\|test\)'. regex, 'cbnW')), '\(it\|test\)'. regex)
  call setpos('.', pos)
  return '"'. desc_match. ' '. it_match. '"'
endfunction

function! funcs#get_run_command() abort
  if expand('%') =~ '\.class'
    call funcs#decompile_java_class()
    return
  endif
  update  " write buffer unless it's a java class file, which will be modified when vim-sleuth loads
  let user_command = get(b:, 'RunCommand', get(g:, 'RunCommand', ''))
  if user_command != ''
    return user_command
  endif
  if expand('%') =~ '\.test\.[tj]sx\?'
    return 'TermExec size='. max([10, &columns * 1/2]). " direction=vertical cmd='yarn test ". expand('%'). ' -t '. funcs#jest_context(). ' --coverage -u'. "'"
  endif
  let run_command = {}
  let run_command['vim'] = 'source %'
  let run_command['lua'] = 'luafile %'
  let run_command['python'] = 'AsyncRun -raw python3 "$(VIM_FILEPATH)"'
  let run_command['c'] = 'AsyncRun -raw gcc "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" -g && "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"'
  let run_command['cpp'] = 'AsyncRun -raw g++ "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" -g && "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"'
  let run_command['java'] = 'AsyncRun -raw javac "$(VIM_FILEPATH)" && java -classpath "$(VIM_FILEDIR)" "$(VIM_FILENOEXT)"'
  let run_command['javascript'] = 'AsyncRun -raw node "$(VIM_FILEPATH)"'
  let run_command['typescript'] = 'AsyncRun -raw npx ts-node "$(VIM_FILEPATH)"'
  let run_command['markdown'] = $SSH_CLIENT != '' ? 'Glow' : 'MarkdownPreview'
  let run_command['html'] = 'AsyncRun -silent open "$(VIM_FILEPATH)"'
  let run_command['xhtml'] = 'AsyncRun -silent open "$(VIM_FILEPATH)"'
  let run_command['http'] = 'lua require("rest-nvim").run()'
  return get(run_command, &filetype, ''). get(b:, 'args', '')
endfunction

function! funcs#get_visual_selection()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
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
    silent execute 'normal! V'. a:type. '$"xy'
  elseif a:type =~ '^.$'
    silent execute "normal! `<". a:type. '`>"xy'
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
  let &operatorfunc = matchstr(expand('<sfile>'), '<SNR>\d\+_'). 'ActionOpfunc'
endfunction
function! s:MapAction(algorithm, key)
  execute 'nnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>ActionSetup("'. a:algorithm. '")<CR>g@'
  execute 'xnoremap <silent> <Plug>actions'    .a:algorithm.' :<C-U>call <SID>DoAction("'. a:algorithm. '", visualmode())<CR>'
  execute 'nnoremap <silent> <Plug>actionsLine'.a:algorithm.' :<C-U>call <SID>DoAction("'. a:algorithm. '", v:count1)<CR>'
  execute 'nmap '. a:key. '  <Plug>actions'. a:algorithm
  execute 'xmap '. a:key. '  <Plug>actions'. a:algorithm
  execute 'nmap '. a:key.a:key[strlen(a:key)-1]. ' <Plug>actionsLine'. a:algorithm
endfunction

function! funcs#map_copy_with_osc_yank_script()  " doesn't work in neovim
  function! s:CopyWithOSCYankScript(str)
    let @" = a:str
    let buflen = len(a:str)
    let copied = 0
    while buflen > copied
      if copied > 0 && input('Total: '. buflen. ', copied: '. copied. ', continue? [Y/n] ') =~ '^[Nn]$'
        break
      endif
      call system('y', a:str[copied :copied + 74993])
      let copied += 74994
    endwhile
    echomsg '[osc52] Copied '. min([buflen, copied]). ' characters.'
  endfunction
  call <SID>MapAction('CopyWithOSCYankScript', '<leader>y')
  nmap <leader>Y <leader>y$
endfunction

function! funcs#map_copy_to_win_clip()
  function! s:CopyToWinClip(str)
    let @" = a:str
    call system('clip.exe', a:str)
  endfunction
  call <SID>MapAction('CopyToWinClip', '<leader>y')
  nmap <leader>Y <leader>y$
endfunction

function! funcs#map_vim_send_terminal()
  function! s:SendToTerminal(str)
    let buff_n = term_list()
    if len(buff_n) > 0
      let buff_n = buff_n[0]  " sends to most recently opened terminal
      let lines = getline(getpos("'<")[1], getpos("'>")[1])
      let indent = match(lines[0], '[^ \t]')  " remove unnecessary indentation if first line is indented
      for line in lines
        call term_sendkeys(buff_n, (match(line, '[^ \t]') ? line[indent:] : line). "\<CR>")
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
    write! ~/.cache/vim/cfr-temp.class
    silent %!java -jar ~/.local/lib/cfr.jar ~/.cache/vim/cfr-temp.class
    call system('rm -f ~/.cache/vim/cfr-temp.class')
  endif
  set nomodified readonly filetype=java
endfunction

function! funcs#ctags() abort
  try
    silent execute 'ltag '. expand('<cword>')
    echo 'tag 1 of '. len(getloclist(0))
  catch /^Vim\%((\a\+)\)\=:E433:/
    call funcs#ctags_create_and_jump()
  endtry
endfunction

function! funcs#ctags_create_and_jump() abort
  let answer = input('Generate ctags for language ("all" for all supported, empty to cancel): ', &filetype, 'filetype')  " language list: ctags --list-languages
  if answer != ''
    let args = answer == 'all' ? '' : '--languages='. answer
    " TODO https://github.com/universal-ctags/ctags/issues/2667
    execute '!ctags --exclude=.git --exclude=node_modules --exclude=venv --langmap=TypeScript:.ts.tsx -R '. args
    silent execute 'ltag '. expand('<cword>')
    echo 'tag 1 of '. len(getloclist(0))
  endif
endfunction
