function! completion#init() abort
  let s:custom_matcher = 1
  let s:min_match_len = 2
  let s:max_keyword_len = 100
  let s:max_matches = 50
  let s:max_file_size = 1000000  " 1mb
  let s:use_all_buffers = 1
  let s:use_cache = 1
  let s:force_refresh_menu = 0
  let s:omni_enabled_ft = {'python': 1, 'javascript': 1}
  let s:FuzzyFunc = s:custom_matcher || !exists('*matchfuzzy') ? function('s:FuzzyMatch') : function('s:VimFuzzyMatch')

  set omnifunc=syntaxcomplete#Complete
  set completeopt=menuone,noselect
  set shortmess+=c
  inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
  inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
  inoremap <expr> <C-@> completion#refresh()
  inoremap <expr> <C-Space> completion#refresh()

  augroup ComplInit
    autocmd!
    autocmd BufEnter,TabEnter * call s:OnBufEnter()
    autocmd FileType * let b:omni_enabled = get(s:omni_enabled_ft, &filetype, 0)
  augroup END
endfunction

function! s:OnBufEnter() abort
  let s:prev_base = '-'
  let s:omni_info = {'on': 0}  " builtin omni or path completion information

  if exists('b:loaded_completion')
    return
  endif
  let b:loaded_completion = 1

  if (&buftype != '' && &buftype != 'nofile') || wordcount().bytes > s:max_file_size
    return
  endif

  let b:omni_enabled = get(s:omni_enabled_ft, &filetype, 0)
  let b:prev_line = -1
  let b:prev_base_start = -1
  call s:RefreshBufWords({'type': 0})
  augroup ComplEvents
    autocmd! * <buffer>
    autocmd TextChangedI <buffer> call s:DoCompletion()
    if s:force_refresh_menu
      autocmd InsertCharPre <buffer> if pumvisible() && !s:omni_info['on'] | call feedkeys("\<C-e>", 'in') | endif
    endif
  augroup END
endfunction

function! completion#refresh()
  let b:prev_line = -1
  let b:prev_base_start = -1
  let s:prev_base = '-'

  if &buftype == 'nofile'  " refresh scratch buffer if focused
    call s:RefreshBufWords({'type': 2, 'bufnr': bufnr()})
  endif
  for l:bufnr in map(getbufinfo({'buflisted': 1, 'bufloaded': 1}), 'v:val.bufnr')
    call s:RefreshBufWords({'type': 2, 'bufnr': l:bufnr})
  endfor
  return pumvisible() ? "\<C-e>" : " \<BS>"
endfunction

function! s:DoCompletion() abort
  let l:line_content = getline('.')
  let l:line = line('.')
  let l:col = col('.')

  if !s:omni_info['on'] || s:omni_info['col'] != l:col || s:omni_info['line'] != l:line
    let l:last_char = l:line_content[l:col - 2]
    if l:last_char == '/' && l:line_content[match(l:line_content, '\S\+\%'. l:col. 'c')] =~ '\W'
      let s:omni_info = {'on': 1, 'line': l:line, 'col': l:col}
      call feedkeys("\<C-x>\<C-f>\<C-p>", 'in')
      return
    elseif b:omni_enabled && l:last_char == '.'
      let s:omni_info = {'on': 1, 'line': l:line, 'col': l:col}
      call feedkeys("\<C-x>\<C-o>\<C-p>", 'in')
      return
    endif
  endif
  let s:omni_info['on'] = 0

  let l:base_start = match(l:line_content, '\w\+\%'. l:col. 'c')
  let l:base = l:line_content[l:base_start:l:col-2]
  if len(l:base) < s:min_match_len
    return
  endif

  if b:prev_base_start != l:base_start || b:prev_line != l:line
    call s:RefreshBufWords({'type': s:use_cache, 'line': l:line, 'col': l:base_start - 2})
    let b:prev_line = l:line
    let b:prev_base_start = l:base_start
    let s:prev_base = '-'  " reset s:prev_base to disable cache on next match because word list is refreshed
  endif

  let s:match_list = s:FuzzyFunc(l:base)
  if len(s:match_list) > 0
    call complete(l:base_start + 1, s:match_list)
  endif
endfunction

function! s:RefreshBufWords(options) abort  " {'type': 0 = refresh current buffer, 1 = refresh incrementally while typing, 2 = manual refresh}
  let l:bufnr = get(a:options, 'bufnr', bufnr())
  let l:words_dict = a:options['type'] == 1 ? b:words_dict : {}

  if a:options['type'] == 1  " refresh incrementally
    if b:prev_line == a:options['line']
      " let l:buf_string = getline('.')[b:prev_base_start:a:options['col']]  " doesn't work in some cases, e.g. pasting text
      let l:buf_string = getline('.')[0:a:options['col']]
    elseif b:prev_line < a:options['line']
      let l:buf_string = join(getline(b:prev_line, a:options['line']), "\n")
    else  " editing text above, add a few more lines down in case new lines are added above
      let l:buf_string = join(getline(a:options['line'], b:prev_line + 10), "\n")
    endif
  elseif a:options['type'] == 0 || l:bufnr != bufnr()  " refresh all words in current or another buffer
    let l:buf_string = join(getbufline(l:bufnr, 1, '$'), "\n")
  else  " refresh current buffer except current word base (triggered manually)
    let l:lines = getline(1, '$')
    let l:line_index = line('.') - 1
    let l:col = col('.')
    let l:curr_line = l:lines[l:line_index]
    let l:base_start = match(l:curr_line, '\w\+\%'. l:col. 'c')
    let l:base_end = match(l:curr_line, '\W', l:col)
    let l:lines[l:line_index] = l:curr_line[:l:base_start]. l:curr_line[l:base_end:]
    let l:buf_string = join(l:lines, "\n")
  endif

  for l:word in filter(split(l:buf_string, '\W\+\d*\|^\d'), 'len(v:val) > s:min_match_len && len(v:val) < s:max_keyword_len')
    let l:words_dict[l:word] = 1
  endfor
  call setbufvar(l:bufnr, 'words_dict', l:words_dict)
endfunction

function! s:GetWordsList(regex) abort
  let l:all_words = a:regex != '' ? filter(keys(b:words_dict), 'v:val =~ a:regex') : keys(b:words_dict)
  if s:use_all_buffers == 0
    return l:all_words
  endif

  let s:curr_bwords_len = len(l:all_words)  " s:curr_bwords_len > 0 && l:all_words[:s:curr_bwords_len-1] will be words in current buffer
  let l:curr_buf = bufnr()
  for l:bufnr in filter(map(getbufinfo({'bufloaded': 1}), 'v:val.bufnr'), 'v:val != l:curr_buf')
    let l:buf_words_dict = getbufvar(l:bufnr, 'words_dict', {})
    if len(l:buf_words_dict) > 0 && len(l:buf_words_dict) < 20000
      call extend(l:all_words, a:regex != '' ? filter(keys(l:buf_words_dict), 'v:val =~ a:regex') : keys(l:buf_words_dict))
    endif
  endfor
  return l:all_words
endfunction

function! s:FuzzyMatch(base) abort
  let l:base_arr = split(a:base, '\zs')
  let l:regex = join(l:base_arr, '\w*')
  let l:regex_min_match = join(l:base_arr, '\w\{-}')
  let l:words = a:base =~ '^'. s:prev_base ? s:prev_list : s:GetWordsList(l:regex)

  if len(a:base) == s:min_match_len  " save word list if filtered with smallest base
    let s:prev_list = l:words
    let s:prev_base = a:base
    let l:curr_buf_words = s:curr_bwords_len == 0 ? [] : l:words[:s:curr_bwords_len-1]
    let l:other_buf_words = l:words[s:curr_bwords_len:]
  else  " base different from cache, filter now for better performance (won't change l:words because slice copies)
    let l:curr_buf_words = s:curr_bwords_len == 0 ? [] : filter(l:words[:s:curr_bwords_len-1], 'v:val =~ l:regex')
    let l:other_buf_words = filter(l:words[s:curr_bwords_len:], 'v:val =~ l:regex')
  endif

  let l:result = map(l:curr_buf_words, '{"word": v:val, "kind": "[ID]", "r": matchend(v:val, l:regex_min_match)}')
  call extend(l:result, map(l:other_buf_words, '{"word": v:val, "kind": "[Buffer]", "r": 2 * matchend(v:val, l:regex_min_match)}'))
  return sort(l:result, {i1, i2 -> i1['r'] > i2['r'] ? 1 : -1})[:s:max_matches]  " lambda compare in this order is faster than Funcref
endfunction

function! s:VimFuzzyMatch(base) abort
  return map(matchfuzzy(s:GetWordsList(''), a:base)[:s:max_matches], '{"word": v:val, "kind": "[ID]"}')
endfunction

