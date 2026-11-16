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
  let matched_words = len(a:base) ? matchfuzzy(words, a:base) : words
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

let s:highlight_index = 0
let s:pattern_to_match_id = {}
function! funcs#highlight(pattern)
  let highlights = ['Visual', 'DiffAdd', 'DiffDelete', 'DiffText']
  if has_key(s:pattern_to_match_id, a:pattern)
    call matchdelete(s:pattern_to_match_id[a:pattern])
    unlet s:pattern_to_match_id[a:pattern]
    let s:highlight_index = 0
  else
    let s:pattern_to_match_id[a:pattern] = matchadd(highlights[s:highlight_index], a:pattern)
    let s:highlight_index = (s:highlight_index + 1) % len(highlights)
  endif
endfunction

function! funcs#highlight_clear()
  call clearmatches()
  let s:highlight_index = 0
  let s:pattern_to_match_id = {}
endfunction

function! funcs#get_session_names(arg_lead, cmd_line, cursor_pos)
  return map(glob(stdpath('data') . '/session_*.vim', 0, 1), 'substitute(v:val, stdpath("data") . "/session_", "", "")[0:-5]')
endfunction

function! funcs#grep(prg, pattern)
  let command = a:prg . ' ' . a:pattern
  let lines = systemlist(command)
  call setqflist([], ' ', {'lines': lines, 'efm': '%f:%l:%c:%m,%f:%l:%m,%f', 'title': '(' . len(lines) . ') ' . command})
  if len(lines) > 1
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
  let buf_len = len(getbufinfo({'buflisted': 1}))
  let has_nvim = has('nvim')
  let win_len = has_nvim ? len(filter(nvim_list_wins(), 'nvim_win_get_config(v:val).relative == ""')) : winnr('$')  " exclude nvim floating windows
  let sidebars = ['help', 'netrw', 'man', 'qf', 'neo-tree', 'gitsigns-blame', 'snacks_layout_box', 'snacks_picker_list', 'snacks_terminal', 'sidekick_terminal', 'kulala_ui.text']
  let others_all_sidebars = win_len > 1 && len(filter(range(1, win_len), 'v:val != winnr() && index(sidebars, getbufvar(winbufnr(v:val), "&filetype")) >= 0')) == win_len - 1
  let has_content = buf_len > 1 || bufname('%') != ''
  if has_nvim && nvim_win_get_config(0).relative != ''  " floating window focused
    quit
  elseif (a:buffer_mode == 0 && a:force == 1) || (others_all_sidebars && !has_content)  " <leader>Q, or nothing left to edit and only sidebars remain
    if tabpagenr('$') == 1
      quitall
    else
      tabclose
    endif
  " delete buffer if has multiple buffers open and one of the following: used <leader>x; last window; multiple windows but the other ones are sidebars
  elseif (buf_len > 1 && (a:buffer_mode == 1 || tabpagenr('$') == 1 && win_len == 1)) || (others_all_sidebars && has_content)
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

" alternative: andrewferrier/debugprint.nvim, Goose97/timber.nvim
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
  let print['lua'] = 'vim.notify("❗' . word . ': " .. vim.inspect(' . word . '))'
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

" alternative: https://github.com/rcarriga/neotest
function! funcs#jest_context() abort
  let pos = getcurpos()
  normal! $
  let regex = '([''"`]\zs[^''"`]\+\ze'
  let desc_line = search('^\s*describe' . regex, 'cbnW')
  let desc_match = matchstr(getline(desc_line), 'describe' . regex)
  let it_match = matchstr(getline(search('^\s*\(it\|test\)' . regex, 'cbnW', desc_line)), '\(it\|test\)' . regex)
  call setpos('.', pos)
  return '"' . desc_match . ' ' . it_match . '"'
endfunction

function! funcs#get_run_command() abort
  let file = expand('%')
  if file =~ 'Caddyfile$'
    return 'lua require("utils").term_exec([[ docker exec caddy caddy reload --config /etc/caddy/Caddyfile]])'
  endif
  if file =~ 'docker-compose.yml$'
    return 'lua require("utils").term_exec([[ dc -f "' . file . '" down --remove-orphans; dc -f "' . file . '" up -d]])'
  endif
  if file =~ '\.class$'
    call funcs#decompile_java_class()
    return
  endif
  update
  let user_command = get(b:, 'RunCommand', get(g:, 'RunCommand', ''))
  if user_command != ''
    return user_command
  endif
  if file =~ '\.test\.[tj]sx\?'
    let included_dir = expand('%:~:.::h')
    if fnamemodify(included_dir, ':t') =~ 'test'
      let included_dir = fnamemodify(included_dir, ':h')
    endif
    return 'lua local cur = vim.api.nvim_get_current_win(); vim.api.nvim_set_current_win(vim.fn.win_findbuf(require("utils").term_exec([[ yarn test:jest "' . file . '" -t ' . funcs#jest_context() . " --coverage --collectCoverageFrom='" . included_dir . "/**' --coverageReporters=text -u]], { win = { position = 'right' } }).buf)[1]); vim.cmd.startinsert(); vim.schedule(function() vim.api.nvim_set_current_win(cur) end)"
  endif
  let run_command = {}
  let run_command['vim'] = 'source %'
  let run_command['lua'] = 'luafile %'
  if has('nvim')
    let run_command['python'] = 'lua require("utils").term_exec([[ python3 "' . file . '"]])'
    let run_command['javascript'] = 'lua require("utils").term_exec([[ node "' . file . '"]])'
    let run_command['typescript'] = 'lua require("utils").term_exec([[ npx ts-node --esm "' . file . '"]])'
    let run_command['java'] = 'lua require("utils").term_exec([[ javac "' . file . '" && java -classpath "' . expand('%:p:h') . '" "' . expand('%:t:r') . '"]])'
  else
    let run_command['python'] = 'terminal python3 %'
    let run_command['javascript'] = 'terminal node %'
  endif
  let run_command['html'] = 'silent !open "$(VIM_FILEPATH)"'
  let run_command['xhtml'] = 'silent !open "$(VIM_FILEPATH)"'
  let run_command['csv'] = "lua require('utils').term_exec([[ csvq '" . file . "'\nselect * from t limit 1;]])"
  let run_command['markdown'] = $SSH_CLIENT == '' ? 'lua vim.cmd.LivePreview("close"); vim.cmd.LivePreview("start")' : 'lua vim.cmd.LivePreview("close"); vim.cmd.LivePreview("start"); vim.net.request("https://checkip.amazonaws.com", {}, function(err, res) if not err then vim.schedule(function() vim.fn.setreg("+", vim.trim(res.body) .. ":5500/" .. vim.fn.expand("%:.")); vim.notify("Copied markdown preview URL") end) end end)'
  return get(run_command, &filetype, '') . get(b:, 'args', '')
endfunction

function! funcs#get_visual_selection()
  return join(getregion(getpos("'<"), getpos("'>"), { 'type': visualmode() }), "\n")
endfunction

function! funcs#send_to_terminal(type) abort
  let terminal = get(term_list(), 0, 0)  " sends to most recently opened terminal
  if terminal == 0
    return
  endif
  if a:type =~ '^\d\+$'
    let [start, end, mode] = [[0, line('.'), 1, 0], [0, min([line('$'), line('.') + a:type - 1]), 1, 0], 'V']
  elseif a:type =~ '^.$'
    let [start, end, mode] = [getpos("'<"), getpos("'>"), a:type]
  else
    let [start, end, mode] = [getpos("'["), getpos("']"), get({'line': 'V', 'block': "\<C-v>"}, a:type, 'v')]
  endif
  let lines = getregion(start, end, {'type': mode, 'exclusive': 0})
  let indent = match(lines[0], '[^ \t]')  " remove unnecessary indentation if first line is indented
  for line in lines
    call term_sendkeys(terminal, (match(line, '[^ \t]') ? line[indent:] : line) . "\<CR>")
    sleep 10m
  endfor
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
    call delete(expand('~/.vim/tmp/cfr-temp.class'))
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

function! funcs#ctags_language(filetype) abort
  return get({'aspperl': 'asp', 'aspvbs': 'asp', 'cpp': 'c++', 'cs': 'c#', 'delphi': 'pascal', 'expect': 'tcl', 'mf': 'metapost', 'mp': 'metapost', 'rmd': 'rmarkdown', 'csh': 'sh', 'zsh': 'sh', 'tex': 'latex', 'typescriptreact': 'typescript'}, a:filetype, a:filetype)
endfunction

function! funcs#ctags_create_and_jump() abort
  let answer = input('Generate ctags for language ("all" for all supported, empty to cancel): ', funcs#ctags_language(&filetype), 'filetype')  " language list: ctags --list-languages
  if answer != ''
    let args = answer == 'all' ? '' : '--languages=' . answer
    execute '!ctags --exclude=.git --exclude=node_modules --exclude=.venv --langmap=TypeScript:.ts.tsx -R ' . args
    silent execute 'ltag ' . expand('<cword>')
    echo 'tag 1 of ' . len(getloclist(0))
  endif
endfunction
