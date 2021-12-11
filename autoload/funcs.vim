" TODO use matchfuzzy if available when this is merged https://github.com/neovim/neovim/pull/12995
function! funcs#complete_word(findstart, base)
  if a:findstart
    return match(getline('.'), '\S\+\%'. col('.'). 'c')
  else
    let l:words = map(split(join(getline(1, '$'), "\n")), '{"word": v:val, "kind": "[WORD]"}')
    return len(a:base) ? filter(l:words, 'match(v:val.word, "\\V". a:base) != -1') : l:words
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
  let l:current_styles = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  if match(l:current_styles, '^ConflictMarker') != -1
    if match(l:current_styles, '^ConflictMarker\(Begin\|Ours\)$') != -1
      return 'Ourselves'
    elseif match(l:current_styles, '^ConflictMarker\(End\|Theirs\)$') != -1
      return 'Themselves'
    endif
  endif
  return ''
endfunction

function! funcs#home() abort
  let l:start = match(getline('.'), '\S')
  return l:start == -1 && col('.') == col('$') - 1 || l:start == col('.') - 1 ? '0' : '^'
endfunction

function! funcs#edit_register() abort
  let l:r = nr2char(getchar())
  call feedkeys('q:ilet @'. l:r. " = \<C-r>\<C-r>=string(@". l:r. ")\<CR>\<Esc>0f'", 'n')
endfunction

function! funcs#lf_edit_callback(code) abort
  if filereadable(g:lf_selection_path)
    for l:filename in readfile(g:lf_selection_path)
      execute 'edit '. l:filename
    endfor
    call delete(g:lf_selection_path)
  endif
endfunction

function! funcs#quit(buffer_mode, force) abort
  let l:buf_len = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))  " old method for compatibility
  let l:win_len = has('nvim') ? len(filter(nvim_list_wins(), {k, v -> nvim_win_get_config(v).relative == ''})) : winnr('$')  " exclude nvim floating windows
  if a:buffer_mode == 0 && a:force == 1
    if tabpagenr('$') == 1
      quit
    else
      tabclose
    endif
  " delete buffer if has multiple buffers open and one of the following: used <leader>x; last window; two windows but the other one is file tree
  elseif (l:buf_len > 1 && (a:buffer_mode == 1 || tabpagenr('$') == 1 && l:win_len == 1)) || (l:win_len == 2 && getbufvar(winbufnr(3 - winnr()), '&filetype') == 'NvimTree' && (l:buf_len > 1 || bufname('%') != ''))
    if exists(':Bdelete')
      try
        execute 'Bdelete'. (a:force ? '!' : '')
      catch
        throw 'Unsaved buffer'
      endtry
    else
      bprevious
      if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1  " check number of buffers again after bprevious
        try
          execute 'bdelete'. (a:force ? '!' : ''). ' #'
        catch
          bnext
          throw 'Unsaved buffer'
        endtry
      endif
    endif
  else
    execute 'quit'. (a:force ? '!' : '')
  endif
endfunction

function! funcs#print_curr_vars(visual, printAbove) abort
  let l:new_line = "normal! o\<Space>\<BS>"
  if a:printAbove
    let l:new_line = "normal! O\<Space>\<BS>"
  endif
  if a:visual  " print selection
    let l:vars = [getline('.')[getpos("'<")[2] - 1:getpos("'>")[2] - 1]]
  elseif getline('.') =~ '[^a-zA-Z0-9_,\[\]. ]\|[a-zA-Z0-9_\]]\s\+\w'  " print variable under cursor if line not comma separated
    let l:vars = [expand('<cword>')]
  else  " print variables on current line separated by commas
    let l:vars = split(substitute(getline('.'), ' ', '', 'ge'), ',')
    let l:new_line = "normal! cc\<Space>\<BS>"
  endif
  let l:print = {}
  let l:print['python'] = "print(f'". join(map(copy(l:vars), "v:val. ': {'. v:val. '}'"), ' | '). "')"
  let l:print['javascript'] = 'console.log('. join(map(copy(l:vars), "\"'\". v:val. \":', \". v:val"), ", '|', "). ');'
  let l:print['typescript'] = l:print['javascript']
  let l:print['typescriptreact'] = l:print['javascript']
  let l:print['java'] = 'System.out.println('. join(map(copy(l:vars), "'\"'. v:val. ': \" + '. v:val"), ' + " | " + '). ');'
  let l:print['vim'] = 'echomsg '. join(map(copy(l:vars), "\"'\". v:val. \": '. \". v:val"), ". ' | '. ")
  let l:print['lua'] = 'print('. join(map(copy(l:vars), "\"'\". v:val. \": ' .. \". v:val"), " .. ' | ' .. "). ')'
  if has_key(l:print, &filetype)
    let l:pos = getcurpos()
    execute l:new_line
    call append(line('.'), l:print[&filetype])
    join
    call setpos('.', l:pos)
  endif
endfunction

function! funcs#jest_context() abort
  let l:pos = getcurpos()
  normal! $
  let l:regex = '(''\zs[^'']\+\ze'
  let l:desc_match = matchstr(getline(search('describe'. l:regex, 'cbnW')), 'describe'. l:regex)
  let l:it_match = matchstr(getline(search('\(it\|test\)'. l:regex, 'cbnW')), '\(it\|test\)'. l:regex)
  call setpos('.', l:pos)
  let l:context = "'". l:desc_match. ' '. l:it_match. "'"
  return escape(l:context, '<>')
endfunction

function! funcs#get_run_command() abort
  if get(b:, 'RunCommand', '') != ''
    return b:RunCommand
  endif
  if expand('%') =~ '.test.[tj]sx\?'
    if !exists('g:neoterm')
      lua require('packer').loader('neoterm')
    endif
    return 'vertical T yarn test '. expand('%'). ' -t '. funcs#jest_context(). ' --coverage -u'
  endif
  let l:run_command = {}
  let l:run_command['vim'] = 'source %'
  let l:run_command['lua'] = 'luafile %'
  let l:run_command['python'] = 'AsyncRun python3 %'
  let l:run_command['c'] = 'AsyncRun gcc % -o %< -g && ./%<'
  let l:run_command['cpp'] = 'AsyncRun g++ % -o %< -g && ./%<'
  let l:run_command['java'] = 'AsyncRun javac % && java %<'
  let l:run_command['javascript'] = 'AsyncRun node %'
  let l:run_command['markdown'] = 'MarkdownPreview'
  let l:run_command['html'] = 'AsyncRun -silent open %'
  let l:run_command['xhtml'] = 'AsyncRun -silent open %'
  let l:run_command['http'] = 'lua require("rest-nvim").run()'
  return get(l:run_command, &filetype, 'Neomake'). get(b:, 'args', '')
endfunction

function! funcs#get_visual_selection()
  let [l:line_start, l:column_start] = getpos("'<")[1:2]
  let [l:line_end, l:column_end] = getpos("'>")[1:2]
  let l:lines = getline(l:line_start, l:line_end)
  if len(l:lines) == 0
    return ''
  endif
  let l:lines[-1] = l:lines[-1][: l:column_end - (&selection == 'inclusive' ? 1 : 2)]
  let l:lines[0] = l:lines[0][l:column_start - 1:]
  return join(l:lines, "\n")
endfunction

function! s:DoAction(algorithm, type)  " https://vim.fandom.com/wiki/Act_on_text_objects_with_custom_functions
  let l:sel_save = &selection
  let l:cb_save = &clipboard
  set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
  let l:reg_save = @@
  if a:type =~ '^\d\+$'
    silent execute 'normal! V'. a:type. '$y'
  elseif a:type =~ '^.$'
    silent execute "normal! `<". a:type. "`>y"
  elseif a:type == 'line'
    silent execute "normal! '[V']y"
  elseif a:type == 'block'
    silent execute "normal! `[\<C-V>`]y"
  else
    silent execute "normal! `[v`]y"
  endif
  let l:repl = s:{a:algorithm}(@@)
  if type(l:repl) == 1
    call setreg('@', l:repl, getregtype('@'))
    normal! gvp
  endif
  let @@ = l:reg_save
  let &selection = l:sel_save
  let &clipboard = l:cb_save
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

function! funcs#map_copy_with_osc_yank()
  function! s:CopyWithOSCYank(str)
    let @" = a:str
    OSCYankReg "
  endfunction
  call <SID>MapAction('CopyWithOSCYank', '<leader>y')
  nmap <leader>Y <leader>y$
endfunction

function! funcs#map_copy_to_win_clip()
  function! s:CopyToWinClip(str)
    call system('clip.exe', a:str)
  endfunction
  call <SID>MapAction('CopyToWinClip', '<leader>y')
  nmap <leader>Y <leader>y$
endfunction
