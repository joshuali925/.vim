vim9script

import autoload 'plugins/gitdiff.vim'

const limit = 500
const chunk = 20000
var opts: dict<any>
var items: list<string>
var shown: list<string>
var marked: list<string>
var res: list<list<any>>
var [query, pending, t_ve] = ['', '', '']
var [pos, offset, gen, timer, debounce, prompt, menu] = [0, 0, 0, 0, 0, 0, 0]
var job: job
var reg_pending = false

export def Open(list: list<string>, o: dict<any>)
  hi default link PickerMatch Special
  hi default link PickerBorder Comment
  hi default link PickerCount Comment
  hi default link PickerMark Type
  hi default PickerCursor term=reverse cterm=reverse gui=reverse
  for t in ['PickerCount', 'PickerMark']
    if empty(prop_type_get(t))
      prop_type_add(t, {highlight: t})
    endif
  endfor
  [opts, items, marked, query, pending, reg_pending] = [o, list, [], get(o, 'query', ''), '', false]
  pos = strcharlen(query)
  const w = min([max([80, &columns * 2 / 5]), &columns - 4])
  const h = max([3, &lines * 2 / 5 - 3])
  const title = $' {o.title} '
  var popup = {col: (&columns - w - 4) / 2 + 1, minwidth: w, maxwidth: w, padding: [0, 1, 0, 1], highlight: 'Normal', borderhighlight: ['PickerBorder'], mapping: false, wrap: false, zindex: 300}
  prompt = popup_create('', extend({line: 2, border: [], borderchars: ['─', '│', '─', '│', '╭', '╮', '┤', '├'], title: repeat('─', (w + 2 - strwidth(title)) / 2) .. title, filter: OnKey, callback: (_, _) => Finish()}, popup))
  menu = popup_create([], extend({line: 5, minheight: h, maxheight: h, border: [0, 1, 1, 1], borderchars: ['─', '│', '─', '│', '╭', '╮', '╯', '╰'], scrollbar: false}, popup))
  setwinvar(menu, '&cursorline', 1)
  setwinvar(menu, '&cursorlineopt', 'line')
  t_ve = &t_ve
  &t_ve = ''
  if has_key(o, 'ignored')
    FindFiles()
  elseif has_key(o, 'live')
    Live()
  else
    Refresh()
  endif
enddef

def FindFiles()
  if executable('rg')
    StartJob(['rg', '--files', '--hidden', '-g', '!.git'] + (opts.ignored ? ['--no-ignore'] : []))
  else
    Stop()
    items = glob('**', opts.ignored, 1)->filter((_, f) => !isdirectory(f) && f !~ '^\%(.*/\)\?\.git/')
    Refresh()
  endif
enddef

def Live(_: number = 0)
  if query != ''
    StartJob(opts.live(query))
    return
  endif
  Stop()
  items = []
  Refresh()
enddef

def StartJob(cmd: list<string>)
  Stop()
  [items, pending] = [[], '']
  const g = gen
  job = job_start(cmd, {out_mode: 'raw', in_io: 'null', err_io: 'null', env: get(opts, 'env', {}),
    out_cb: (_, msg) => g == gen ? Append(msg) : 0,
    close_cb: (_) => g == gen ? Append("\n") : 0})
  Refresh()
enddef

def Stop()
  gen += 1
  timer_stop(timer)
  timer_stop(debounce)
  if job_status(job) == 'run'
    job_stop(job)
  endif
enddef

def Append(msg: string): number
  const live = has_key(opts, 'live')
  const full = len(items) >= limit
  if live && full
    return 0
  endif
  var lines = split(pending .. msg, "\n", true)
  pending = remove(lines, -1)
  lines->filter((_, l) => l != '')
  if empty(lines)
    return 0
  endif
  items->extend(lines)
  if live && len(items) >= limit
    job_stop(job)
  endif
  if full && query == ''
    Draw()
  else
    Update()
  endif
  return 0
enddef

def Refresh()
  timer_stop(timer)
  [offset, res] = [0, [[], [], []]]
  Update()
  win_execute(menu, 'normal! gg')
enddef

def Update()
  if query == '' || has_key(opts, 'live')
    Render(items[: limit - 1], [])
  elseif empty(timer_info(timer))
    Step()
  endif
enddef

def Step(_: number = 0)
  const slice = items[offset : offset + chunk - 1]
  offset += len(slice)
  const r = matchfuzzypos(slice, query, {limit: limit})
  if empty(res[0])
    res = r
  elseif !empty(r[0])
    const [s, p, c] = [res[0] + r[0], res[1] + r[1], res[2] + r[2]]
    const idx = range(len(s))->sort((a, b) => c[b] - c[a])[: limit - 1]
    res = [idx->mapnew((_, i) => s[i]), idx->mapnew((_, i) => p[i]), idx->mapnew((_, i) => c[i])]
  endif
  Render(res[0], res[1])
  if offset < len(items)
    timer = timer_start(0, Step)
  endif
enddef

def Render(strs: list<string>, poss: list<any>)
  shown = strs
  popup_settext(menu, strs)
  clearmatches(menu)
  var hl = []
  for i in range(len(poss))
    hl->extend(poss[i]->mapnew((_, p) => [i + 1, byteidx(strs[i], p) + 1]))
  endfor
  if !empty(hl)
    matchaddpos('PickerMatch', hl, 10, -1, {window: menu})
  elseif has_key(opts, 'live') && query != ''
    matchadd('PickerMatch', (query =~ '\u' ? '\C\V' : '\c\V') .. escape(query, '\'), 10, -1, {window: menu})
  endif
  Draw()
enddef

def Draw()
  const b = winbufnr(menu)
  prop_clear(1, max([1, len(shown)]), {bufnr: b})
  for i in empty(marked) ? [] : range(len(shown))
    if index(marked, shown[i]) >= 0
      prop_add(i + 1, 1, {bufnr: b, type: 'PickerMark', text: '● '})
    endif
  endfor
  popup_settext(prompt, $'> {query} ')
  prop_add(1, 0, {bufnr: winbufnr(prompt), type: 'PickerCount', text_align: 'right',
    text: (empty(marked) ? '' : $'({len(marked)}) ') .. printf('%d%s/%d', len(shown), len(shown) == limit ? '+' : '', len(items))
      .. (get(opts, 'ignored', false) ? ' [all]' : '')})
  clearmatches(prompt)
  matchaddpos('PickerCursor', [[1, len(strcharpart(query, 0, pos)) + 3]], 10, -1, {window: prompt})
  redraw
enddef

def Current(): string
  return shown->get(line('.', menu) - 1, '')
enddef

def Move(d: number)
  if !empty(shown)
    win_execute(menu, printf('normal! %dG', (line('.', menu) - 1 + d + len(shown)) % len(shown) + 1))
  endif
enddef

def Toggle(d: number)
  const c = Current()
  const i = index(marked, c)
  if i >= 0
    remove(marked, i)
  elseif c != ''
    add(marked, c)
  endif
  Draw()
  Move(d)
enddef

def Quickfix(r: list<string>)
  setqflist([], ' ', extend(has_key(opts, 'qf') ? {items: opts.qf(r)} : {lines: r, efm: get(opts, 'efm', '%f')}, {title: opts.title}))
  copen
enddef

def Finish(Do: func = null_function, r: list<string> = [])
  if prompt == 0
    return
  endif
  Stop()
  const p = prompt
  prompt = 0
  popup_close(menu)
  popup_close(p)
  &t_ve = t_ve
  [items, shown, marked, res] = [[], [], [], []]
  if Do != null_function && !empty(r)
    Do(r)
  elseif Do == null_function && has_key(opts, 'cancel')
    opts.cancel()
  endif
enddef

def SetLeft(left: string)
  [query, pos] = [left .. strcharpart(query, pos), strcharlen(left)]
enddef

def OnKey(_: number, key: string): bool
  const [q, p, left] = [query, pos, strcharpart(query, 0, pos)]
  if reg_pending
    reg_pending = false
    SetLeft(left .. getreg(key)->split("\n")->get(0, ''))
  elseif key == "\<Esc>" || key == "\<C-c>"
    Finish()
  elseif key == "\<CR>"
    Finish(opts.accept, empty(marked) ? [Current()]->filter((_, c) => c != '') : marked)
  elseif key == "\<C-q>"
    Finish(Quickfix, empty(marked) ? shown : marked)
  elseif index(["\<C-j>", "\<C-n>", "\<Down>"], key) >= 0
    Move(1)
  elseif index(["\<C-k>", "\<C-p>", "\<Up>"], key) >= 0
    Move(-1)
  elseif key == "\<Tab>" || key == "\<S-Tab>"
    Toggle(key == "\<Tab>" ? 1 : -1)
  elseif key == "\<C-a>"
    marked->extend(copy(shown)->filter((_, s) => index(marked, s) < 0))
    Draw()
  elseif key == "\<BS>"
    SetLeft(strcharpart(left, 0, pos - 1))
  elseif key == "\<C-w>"
    SetLeft(substitute(left, '\S*\s*$', '', ''))
  elseif key == "\<C-u>"
    SetLeft('')
  elseif key == "\<Left>" || key == "\<C-b>"
    pos = max([0, pos - 1])
  elseif key == "\<Right>" || key == "\<C-f>"
    pos = min([strcharlen(query), pos + 1])
  elseif key == "\<Home>"
    pos = 0
  elseif key == "\<End>" || key == "\<C-e>"
    pos = strcharlen(query)
  elseif key == "\<C-r>"
    reg_pending = true
  elseif key == '`' && has_key(opts, 'ignored')
    opts.ignored = !opts.ignored
    FindFiles()
  elseif strcharlen(key) == 1 && char2nr(key) >= 32 && char2nr(key) != 127
    SetLeft(left .. key)
  endif
  if prompt != 0 && query != q
    if has_key(opts, 'live')
      timer_stop(debounce)
      debounce = timer_start(100, Live)
      Draw()
    else
      Refresh()
    endif
  elseif prompt != 0 && pos != p
    Draw()
  endif
  return true
enddef

def Edit(r: list<string>)
  for f in r
    const b = bufadd(fnamemodify(f, ':p'))
    setbufvar(b, '&buflisted', true)
    execute 'buffer ' .. b
  endfor
enddef

def InBuffer(list: list<string>, title: string, b = bufnr())
  Open(list, {title: title, accept: (r) => execute(':' .. str2nr(r[0])),
    qf: (r) => r->mapnew((_, s) => ({bufnr: b, lnum: str2nr(s), text: matchstr(s, '^\d\+:\? \zs.*')}))})
enddef

export def Files(q = '')
  Open([], {title: 'Files', query: q, accept: Edit, ignored: false})
enddef

export def GitStatus()
  const root = gitdiff.FindRepo(getcwd())->get(0, '')
  if root == ''
    gitdiff.Notify('Not in a Git repository')
    return
  endif
  gitdiff.Run(['git', '-C', root, '--no-optional-locks', 'status', '--porcelain=v1', '-z', '--untracked-files=all'], {}, (code, out) => {
    if code != 0
      gitdiff.Notify(out->trim()->substitute("\n", ' ', 'g'), true)
      return
    endif
    # Job output turns the NUL separators into NL.
    ShowGitStatus(root, out->split("\n"))
  })
enddef

def ShowGitStatus(root: string, entries: list<string>)
  var files: list<string> = []
  var i = 0
  while i < len(entries)
    files->add(entries[i])
    # Renames and copies include a second field containing the old path.
    i += strpart(entries[i], 0, 2) =~ '[RC]' ? 2 : 1
  endwhile
  if empty(files)
    gitdiff.Notify('No Git status files')
    return
  endif
  Open(files, {title: 'Git status',
    accept: (r) => Edit(r->mapnew((_, s) => root .. '/' .. strpart(s, 3))),
    qf: (r) => r->mapnew((_, s) => ({filename: root .. '/' .. strpart(s, 3), text: strpart(s, 0, 2)}))})
enddef

export def Buffers()
  const cur = bufnr()
  Open(getbufinfo({buflisted: 1})->filter((_, b) => b.bufnr != cur)->sort((a, b) => b.lastused - a.lastused)
    ->mapnew((_, b) => printf('%d %s%s', b.bufnr, b.name == '' ? '[No Name]' : fnamemodify(b.name, ':~:.'), b.changed ? ' +' : '')),
    {title: 'Buffers', accept: (r) => execute('buffer ' .. matchstr(r[0], '^\d\+')), qf: (r) => r->mapnew((_, s) => ({bufnr: str2nr(s)}))})
enddef

export def FilterOldfiles(cwd: bool): list<string>
  const [doc, cur, dir] = [expand('$VIMRUNTIME/doc'), expand('%:p'), substitute(getcwd(), '[/\\]*$', '/', '')]
  return v:oldfiles->mapnew((_, f) => expand(f))->filter((_, f) => stridx(f, doc) < 0 && f != cur && (!cwd || stridx(f, dir) == 0) && filereadable(f))
enddef

export def Oldfiles(cwd: bool)
  Open(FilterOldfiles(cwd)->map((_, f) => fnamemodify(f, ':~:.')), {title: cwd ? 'Recent (cwd)' : 'Recent', accept: Edit})
enddef

export def Lines()
  InBuffer(getline(1, '$')->mapnew((i, l) => $'{i + 1}: {l}'), 'Lines')
enddef

export def BufferTags()
  const b = bufnr()
  gitdiff.Run([executable('uctags') ? 'uctags' : 'ctags', '-f', '-', '--sort=no', '--excmd=number', '--fields=', '--extras=+F',
      $'--language-force={funcs#ctags_language(&filetype)}', '--langmap=TypeScript:.ts.tsx', expand('%')], {err_io: 'null'}, (_, out) => {
    InBuffer(out->split("\n")->map((_, v) => substitute(v, '^\(\S\+\)\s.*\s\(\d\+\)$', '\2 \1', '')), 'Tags', b)
  })
enddef

export def Filetypes()
  Open(getcompletion('', 'filetype'),
    {title: 'Filetypes', accept: (r) => execute('setlocal filetype=' .. r[0])})
enddef

export def Grep()
  Open([], {title: 'Grep', live: (q) => ['rg', '--vimgrep', '--', q], efm: '%f:%l:%c:%m', env: {RIPGREP_CONFIG_PATH: $'{g:dot_vim_dir}/config/.ripgreprc'},
    accept: (r) => {
      if len(r) > 1
        Quickfix(r)
        return
      endif
      const m = matchlist(r[0], '^\(.\{-}\):\(\d\+\):\(\d\+\):')
      Edit([m[1]])
      normal! m'
      cursor(str2nr(m[2]), str2nr(m[3]))
    }})
enddef

export def Select()
  const lines = getline(1, '$')
  enew!
  Open(lines, {title: 'Select', accept: (r) => {
    writefile(r, expand('~/.vim/tmp/last_result'))
    qa!
  }, cancel: () => execute('cquit!')})
enddef
