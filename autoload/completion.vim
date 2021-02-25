function! completion#init() abort
  " if exists('*matchfuzzy')
  "   let s:FuzzyFunc = function('matchfuzzy')
  " else
  let s:FuzzyFunc = function('s:FuzzyMatch')
  " endif

  set omnifunc=syntaxcomplete#Complete
  set completeopt=menuone,noselect
  set shortmess+=c
  inoremap <expr> <Tab> pumvisible()? '<C-n>' : '<Tab>'
  inoremap <expr> <S-Tab> pumvisible()? '<C-p>' : '<S-Tab>'
  inoremap <expr> <C-e> pumvisible()? '<C-e><Esc>a' : '<C-e>'
  inoremap <C-x><C-u> <C-x><C-u>

  augroup ComplInit
    autocmd!
    autocmd BufEnter,TabEnter * call s:EnableCompletion()
  augroup END
endfunction

function! s:EnableCompletion() abort
  if (&buftype != '' && &buftype != 'nofile') || wordcount().bytes > 5000000  " 5mb
    return
  endif
  let s:prev_line = -1
  let s:prev_column = -1
  augroup ComplEvents
    autocmd! * <buffer>
    autocmd TextChangedI <buffer> call s:DoCompletion()
    " autocmd InsertCharPre <buffer> if pumvisible() | call feedkeys("\<C-e>", 'in') | endif
  augroup END
endfunction

function! s:DoCompletion() abort
  let l:line_content = getline('.')
  let l:line = line('.')
  let l:col = col('.')

  let l:pre_char = l:line_content[l:col - 2]
  if l:pre_char == '/'
    call feedkeys("\<C-x>\<C-f>\<C-p>", 'in')
    return
  elseif l:pre_char == '.' && &filetype == 'python'
    call feedkeys("\<C-x>\<C-o>\<C-p>", 'in')
    return
  endif

  let l:start = match(l:line_content, '\w\+\%'. l:col. 'c')
  let l:base = l:line_content[l:start:l:col-2]
  if len(l:base) < 2
    return
  endif

  if s:prev_column != l:start || s:prev_line != l:line
    if s:prev_line != l:line  " get all keywords from buffer
      call s:RefreshWords({'inc': 0})
      let s:prev_line = l:line
    else  " get keywords incrementally as user types on the same line
      call s:RefreshWords({'inc': 1, 'from': s:prev_column, 'to': l:start - 2})
    endif
    let s:prev_column = l:start
  endif

  let s:match_list = s:FuzzyFunc(values(s:words_dict), l:base, {'key': 'word'})
  if len(s:match_list) > 0
    call complete(l:start + 1, s:match_list)
  endif
endfunction

function! s:RefreshWords(options) abort
  if a:options['inc'] == 1
    let l:buf_string = getline('.')[a:options['from']:a:options['to']]  " doesn't work with pasted text
    " let l:buf_string = getline('.')[0:a:options['to']]  " get current line until previous \W
  else
    let s:words_dict = {}
    let l:buf_string = join(getline(1, '$'), "\n")
  endif
  for l:word in filter(split(l:buf_string, '\W\+'), 'len(v:val) > 1')
    let s:words_dict[l:word] = {'word': l:word, 'kind': '[ID]'}
  endfor
endfunction

" https://gitee.com/Jimmy_Huang/MyVimrc/blob/master/autoload/completion.vim
function! s:FuzzyMatch(words, base, filter_field) abort
  let l:base_arr = split(a:base, '\zs')
  let l:regex = '\w\{}'. join(l:base_arr, '\w\{}')

  let l:sorted_list = []
  for l:item in a:words
    let l:word = l:item[a:filter_field.key]
    if !(l:word =~ l:regex)
      continue
    endif

    let l:rank = 0
    for l:char in l:base_arr
      let l:position_normal = match(l:word, l:char)
      let l:rank += l:position_normal
      let l:word = l:word[l:position_normal:]
    endfor
    let l:item['rank'] = l:rank

    let i = len(l:sorted_list)
    while i > 0
      if l:sorted_list[i - 1]['rank'] < l:rank
        break
      endif
      let i -= 1
    endwhile

    call insert(l:sorted_list, l:item, i)
    if len(l:sorted_list) > 100
      call remove(l:sorted_list, len(l:sorted_list) - 1)
    endif
  endfor

  return l:sorted_list
endfunction

