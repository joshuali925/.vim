vim9script

const diff_opts = {output: 'indices', algorithm: 'histogram', 'indent-heuristic': true}
const has_git = executable('git')

def HasDiff(): bool
  if !exists('*diff')
    return false
  endif
  try
    # mac builds expose diff() but return 0 when the internal library is unavailable.
    return type(call('diff', [['a'], ['b'], diff_opts])) == v:t_list
  catch
    return false
  endtry
enddef

const has_diff = HasDiff()
var cache: dict<dict<any>> = {}
var repos: dict<dict<any>> = {}
var pending: dict<bool> = {}
var stash: dict<dict<any>> = {}
var flush_timer = 0
const missing = ['', '', '']

def DefineHl()
  hi default GitDiffAdd ctermfg=113 guifg=#87d96c
  hi default GitDiffChange ctermfg=111 guifg=#80bfff
  hi default GitDiffDelete ctermfg=210 guifg=#f27983
enddef

if has_git && has_diff
  DefineHl()
  sign_define([
    {name: 'GitDiffAdd', text: '▎', texthl: 'GitDiffAdd'},
    {name: 'GitDiffChange', text: '░', texthl: 'GitDiffChange'},
    {name: 'GitDiffChangeDelete', text: '▒', texthl: 'GitDiffChange'},
    {name: 'GitDiffDelete', text: '▏', texthl: 'GitDiffDelete'},
    {name: 'GitDiffTopDelete', text: '▔', texthl: 'GitDiffDelete'},
  ])

  augroup GitDiff
    autocmd!
    autocmd ColorScheme * DefineHl()
    autocmd TextChanged,TextChangedI * Schedule(str2nr(expand('<abuf>')))
    autocmd BufEnter,FocusGained,ShellCmdPost * CheckIndex()
    autocmd BufWritePost * OnWrite(str2nr(expand('<abuf>')))
    autocmd BufUnload * Detach(str2nr(expand('<abuf>')))
  augroup END
endif

export def Notify(msg: string, error = false)
  execute 'echohl' error ? 'ErrorMsg' : 'None'
  echomsg msg
  echohl None
enddef

export def Run(cmd: list<string>, job_opts: dict<any>, Cb: func(number, string), input = '')
  final r = {out: [], code: -1, closed: false}
  const Done = () => {
    if r.closed && r.code >= 0
      Cb(r.code, r.out->join(''))
    endif
  }
  const job = job_start(cmd, extend({in_io: input == '' ? 'null' : 'pipe', noblock: true, out_mode: 'raw', err_io: 'out',
    out_cb: (_, msg) => {
      r.out->add(msg)
    },
    close_cb: (_) => {
      r.closed = true
      Done()
    },
    exit_cb: (_, code) => {
      r.code = code
      Done()
    },
  }, job_opts))
  if job_status(job) == 'fail'
    Cb(-1, $'{cmd[0]}: cannot start')
  elseif input != ''
    ch_sendraw(job, input)
    ch_close_in(job)
  endif
enddef

export def FindRepo(dir: string): list<string>
  var d = dir
  while true
    const git = d .. '/.git'
    if isdirectory(git)
      return [d, git]
    elseif filereadable(git)
      const gitdir = readfile(git, '', 1)->get(0, '')->matchstr('^gitdir: \zs.*')
      return gitdir == '' ? [] : [d, gitdir[0] == '/' ? gitdir : simplify($'{d}/{gitdir}')]
    endif
    const parent = fnamemodify(d, ':h')
    if parent == d
      return []
    endif
    d = parent
  endwhile
  return []
enddef

def IndexSig(index: string): list<any>
  return [getftime(index), getfsize(index), filereadable(index) ? readblob(index, -20) : 0z]
enddef

export def Attach(buf: number)
  Detach(buf)
  const name = bufname(buf)
  if name == '' || getbufvar(buf, '&buftype') != '' || !has_git || !has_diff
    return
  endif
  const path = resolve(fnamemodify(name, ':p'))
  final prev = stash->get(buf, {})
  if !empty(prev) && prev.path == path
    cache[buf] = stash->remove(buf)
    [prev.hunks, prev.tick] = [[], -1]
    Update(buf)
    if IndexSig(repos[prev.root].index) != prev.sig
      Fetch(buf)
    endif
    return
  endif
  const repo = isdirectory(path) ? [] : FindRepo(fnamemodify(path, ':h'))
  if empty(repo) || stridx(path, repo[0] .. '/') != 0
    return
  endif
  const rel = strpart(path, len(repo[0]) + 1)
  if rel =~ "^\\.git/\\|\n"
    return
  endif
  if !repos->has_key(repo[0])
    repos[repo[0]] = {index: repo[1] .. '/index', daemon: {}}
  endif
  cache[buf] = {path: path, root: repo[0], rel: rel, blob: '', exists: false, ref: [], hunks: [], timer: 0, gen: 0, got: 0,
    sig: [], tick: -1}
  Fetch(buf)
enddef

def Detach(buf: number)
  if !cache->has_key(buf)
    return
  endif
  final st = cache->remove(buf)
  timer_stop(st.timer)
  if bufexists(buf)
    sign_unplace('GitDiff', {buffer: buf})
  endif
  # :edit! and autoread unload the buffer right before re-reading it; Attach picks the state back up.
  if empty(stash)
    timer_start(0, (_) => {
      stash = {}
    })
  endif
  stash[buf] = st
enddef

def OnWrite(buf: number)
  final st = cache->get(buf, {})
  if empty(st)
    Attach(buf)
  elseif st.blob == '' && !st.exists
    Fetch(buf)
  endif
enddef

def Fetch(buf: number)
  pending[buf] = true
  if flush_timer == 0
    flush_timer = timer_start(0, (_) => Flush())
  endif
enddef

def Flush()
  flush_timer = 0
  var groups: dict<list<list<any>>> = {}
  for b in pending->keys()->mapnew((_, k) => str2nr(k))
    final st = cache->get(b, {})
    if !empty(st)
      st.gen += 1
      st.exists = filereadable(st.path)
      groups[st.root] = groups->get(st.root, []) + [[b, st, st.gen]]
    endif
  endfor
  pending = {}
  for [root, entries] in groups->items()
    const d = Daemon(root)
    for e in entries
      e[1].sig = d.sig
    endfor
    Query(d, entries->mapnew((_, e) => $':0:{e[1].rel}'), (results) => {
      var untracked: list<list<any>> = []
      for i in range(len(entries))
        const [oid, type, content] = results[i]
        if type != 'blob'
          if IsCurrent(entries[i])
            untracked->add(entries[i])
          endif
          continue
        endif
        const lines = oid == entries[i][1].blob ? [] : content->split("\n", true)
        SetRef(entries[i], oid, strpart(content, len(content) - 1) == "\n" ? lines[: -2] : lines)
      endfor
      if empty(untracked)
        return
      endif
      Run(['git', '--literal-pathspecs', 'ls-files', '--others', '--exclude-standard', '-z', '--']
          + untracked->mapnew((_, e) => e[1].rel), {cwd: root}, (_, out) => {
        const files = out->split("\n")
        for e in untracked
          SetRef(e, files->index(e[1].rel) >= 0 ? 'untracked' : '', [])
        endfor
      })
    })
  endfor
enddef

# `git cat-file --batch` resolves `:0:path` against the index it read first, so it is replaced once the index changes.
def Daemon(root: string): dict<any>
  final repo = repos[root]
  const sig = IndexSig(repo.index)
  const running = !empty(repo.daemon) && job_status(repo.daemon.job) == 'run'
  if running && repo.daemon.sig == sig
    return repo.daemon
  elseif running
    ch_close_in(repo.daemon.job)
  endif
  final d = {sig: sig, queue: [], rx: [], size: 0, need: -1, head: []}
  d.job = job_start(['git', 'cat-file', '--batch'], {cwd: root, noblock: true, out_mode: 'raw', err_io: 'null',
    out_cb: (_, msg) => Receive(d, msg), close_cb: (_) => Drain(d)})
  repo.daemon = d
  return d
enddef

def Query(d: dict<any>, objects: list<string>, Cb: func(list<list<string>>))
  if job_status(d.job) != 'run'
    Cb(objects->mapnew((_, _) => missing))
    return
  endif
  d.queue->add({count: len(objects), results: [], Cb: Cb})
  ch_sendraw(d.job, objects->join("\n") .. "\n")
enddef

def Receive(d: dict<any>, msg: string)
  d.rx->add(msg)
  d.size += len(msg)
  if d.size < d.need
    return
  endif
  const data = d.rx->join('')
  var pos = 0
  var done: list<dict<any>> = []
  while len(done) < len(d.queue)
    if d.need < 0
      const nl = stridx(data, "\n", pos)
      if nl < 0
        break
      endif
      const m = matchlist(strpart(data, pos, nl - pos), '^\(\x\+\) \(\a\+\) \(\d\+\)$')
      const head = nl + 1 - pos
      [d.head, d.need] = empty(m) ? [missing, head] : [[m[1], m[2], head, str2nr(m[3])], head + str2nr(m[3]) + 1]
    endif
    if len(data) - pos < d.need
      break
    endif
    final req = d.queue[len(done)]
    req.results->add(d.head[0] == '' ? missing : [d.head[0], d.head[1], strpart(data, pos + d.head[2], d.head[3])])
    [pos, d.need] = [pos + d.need, -1]
    if len(req.results) == req.count
      done->add(req)
    endif
  endwhile
  [d.rx, d.size] = [[strpart(data, pos)], len(data) - pos]
  d.queue = d.queue[len(done) :]
  for req in done
    req.Cb(req.results)
  endfor
enddef

def Drain(d: dict<any>)
  for req in d.queue
    req.Cb(req.results + repeat([missing], req.count - len(req.results)))
  endfor
  d.queue = []
enddef

def IsCurrent(entry: list<any>): bool
  const [buf, st, gen] = entry
  return cache->get(buf, {}) is st && st.gen == gen
enddef

def SetRef(entry: list<any>, blob: string, ref: list<string>)
  if !IsCurrent(entry)
    return
  endif
  const [buf, st, gen] = entry
  st.got = gen
  if st.blob == blob
    return
  endif
  var lines = ref
  if getbufvar(buf, '&bomb') && !empty(lines)
    lines[0] = substitute(lines[0], "^\uFEFF", '', '')
  endif
  if getbufvar(buf, '&fileformat') == 'dos'
    lines->map((_, l) => substitute(l, '\r$', '', ''))
  endif
  [st.blob, st.ref, st.tick] = [blob, lines, -1]
  Update(buf)
enddef

def CheckIndex()
  var sigs: dict<list<any>> = {}
  for [b, st] in cache->items()
    if !sigs->has_key(st.root)
      sigs[st.root] = IndexSig(repos[st.root].index)
    endif
    if sigs[st.root] != st.sig
      Fetch(str2nr(b))
    endif
  endfor
enddef

def Schedule(buf: number)
  final st = cache->get(buf, {})
  if empty(st) || st.blob == ''
    return
  endif
  timer_stop(st.timer)
  st.timer = timer_start(200, (_) => Update(buf))
enddef

def Diff(ref: list<string>, lines: list<string>): list<dict<any>>
  return diff(ref, lines, diff_opts)->map((_, d) => ({
    ref_start: d.from_idx + (d.from_count == 0 ? 0 : 1), ref_count: d.from_count,
    buf_start: d.to_idx + (d.to_count == 0 ? 0 : 1), buf_count: d.to_count}))
enddef

def Update(buf: number)
  final st = cache->get(buf, {})
  if empty(st)
    return
  endif
  timer_stop(st.timer)
  st.timer = 0
  const tick = getbufvar(buf, 'changedtick')
  if tick == st.tick
    return
  endif
  var hunks: list<dict<any>> = []
  if st.blob != ''
    const lines = getbufline(buf, 1, '$')
    hunks = empty(st.ref) && lines == [''] ? [] : Diff(st.ref, lines)
  endif
  st.tick = tick
  if hunks == st.hunks
    return
  endif
  st.hunks = hunks
  sign_unplace('GitDiff', {buffer: buf})
  var signs: list<dict<any>> = []
  # Vim scans the buffer's sign list to pick a free id and to find the insert position;
  # explicit ids placed bottom-up make each placement O(1).
  for h in hunks->copy()->reverse()
    if h.buf_count == 0
      signs->add({id: len(signs) + 1, lnum: max([h.buf_start, 1]), buffer: buf, group: 'GitDiff', priority: 13,
        name: h.buf_start == 0 ? 'GitDiffTopDelete' : 'GitDiffDelete'})
      continue
    endif
    const name = h.ref_count == 0 ? 'GitDiffAdd' : 'GitDiffChange'
    const end = h.buf_start + h.buf_count - 1
    for lnum in range(end, h.buf_start, -1)
      signs->add({id: len(signs) + 1, lnum: lnum, buffer: buf, group: 'GitDiff', priority: 13,
        name: lnum == end && h.ref_count > h.buf_count ? 'GitDiffChangeDelete' : name})
    endfor
  endfor
  sign_placelist(signs)
enddef

def Hunks(): list<dict<any>>
  final st = cache->get(bufnr(), {})
  if empty(st)
    return []
  endif
  if st.timer != 0
    Update(bufnr())
  endif
  return st.hunks
enddef

def Ranges(hunks: list<dict<any>>): list<list<number>>
  var res: list<list<number>> = []
  for h in hunks
    const from = max([h.buf_start, 1])
    const to = from + max([h.buf_count, 1]) - 1
    if !empty(res) && from <= res[-1][1] + 1
      res[-1][1] = max([res[-1][1], to])
    else
      res->add([from, to])
    endif
  endfor
  return res
enddef

def RangeAtCursor(): list<number>
  for r in Ranges(Hunks())
    if r[0] <= line('.') && line('.') <= r[1]
      return r
    endif
  endfor
  return []
enddef

export def Goto(forward: bool)
  const ranges = Ranges(Hunks())
  if empty(ranges)
    Notify('No hunks')
    return
  endif
  var lnum = line('.')
  var at = 0
  while at < len(ranges) && ranges[at][0] < lnum
    at += 1
  endwhile
  if forward
    if at < len(ranges) && ranges[at][0] == lnum
      at += 1
    endif
    if at == len(ranges) && !&wrapscan
      return
    endif
    at += v:count1 - 1
  else
    if at == 0 && !&wrapscan
      return
    endif
    at -= v:count1
  endif
  if &wrapscan
    at = ((at % len(ranges)) + len(ranges)) % len(ranges)
  else
    at = min([max([at, 0]), len(ranges) - 1])
  endif
  lnum = ranges[at][0]
  if lnum == line('.')
    return
  endif
  normal! m'
  cursor(lnum, 1)
  normal! ^zv
enddef

export def Select()
  const r = RangeAtCursor()
  if empty(r)
    return
  endif
  if mode() =~# "^[vV\<C-v>]"
    execute "normal! \<Esc>"
  endif
  execute $'normal! {r[0]}GV{r[1]}G'
enddef

export def Do(action: string, visual: bool)
  var r = RangeAtCursor()
  if visual
    r = [line('v'), line('.')]->sort('n')
    execute "normal! \<Esc>"
  endif
  var hunks: list<dict<any>> = []
  for h in empty(r) ? [] : Hunks()
    const start = max([h.buf_start, 1])
    const left = max([r[0], start])
    const right = min([r[1], start + max([h.buf_count, 1]) - 1])
    if left > right
      continue
    endif
    # Unequal replacements have no line correspondence, so keep the whole hunk.
    if h.ref_count != 0 && h.ref_count != h.buf_count
      hunks->add(h)
      continue
    endif
    const count = right - left + 1
    hunks->add(extendnew(h, {buf_start: left, buf_count: count,
      ref_start: h.ref_start + (h.ref_count == 0 ? 0 : left - start), ref_count: h.ref_count == 0 ? 0 : count}))
  endfor
  if empty(hunks)
    Notify('No hunks')
    return
  endif
  const buf = bufnr()
  if action == 'stage'
    Stage(buf, cache[buf], hunks)
  elseif action == 'reset'
    Reset(buf, cache[buf], hunks)
  else
    win_execute(popup_atcursor(Patch(cache[buf], hunks, getline(1, '$')), {padding: [0, 1, 0, 1], border: [], moved: 'any'}),
      ['setlocal filetype=diff syntax=diff'] + [['Add', '+'], ['Delete', '-'], ['Change', '@@']]
        ->mapnew((_, p) => $'call matchadd("GitDiff{p[0]}", "^{p[1]}.*")'))
  endif
enddef

export def Blame()
  const file = resolve(expand('%:p'))
  Run(['git', 'log', '--no-merges', '-n', '1', '-L', $"{line('v')},{line('.')}:{file}"], {cwd: fnamemodify(file, ':h')}, (_, out) => {
    setbufvar(winbufnr(popup_atcursor(out->split("\n"), {padding: [1, 1, 1, 1], pos: 'botleft', wrap: 0})), '&filetype', 'git')
  })
enddef

def Stage(buf: number, st: dict<any>, hunks: list<dict<any>>)
  const lines = getline(1, '$')
  const header = st.blob == 'untracked'
    ? [$'diff --git a/{st.rel} b/{st.rel}', $'new file mode {getfperm(st.path)[2] == 'x' ? 100755 : 100644}',
      '--- /dev/null', $'+++ b/{st.rel}']
    : [$'diff --git a/{st.rel} b/{st.rel}', $'--- a/{st.rel}', $'+++ b/{st.rel}']
  const index = repos[st.root].index
  const before = IndexSig(index)
  const fresh = st.got == st.gen && st.sig == before && !pending->has_key(buf)
  const [gen, ref] = [st.gen, ApplyHunks(st.ref, lines, hunks)]
  Run(['git', 'apply', '--whitespace=nowarn', '--cached', '--unidiff-zero', '-'], {cwd: st.root}, (code, err) => {
    if code != 0
      Notify('git apply: ' .. err->split("\n")->join(' '), true)
    endif
    if code != 0 || !fresh || cache->get(buf, {}) isnot st || st.gen != gen
      Fetch(buf)
      return
    endif
    const after = IndexSig(index)
    for other in cache->values()
      if other.root == st.root && other.sig == before
        other.sig = after
      endif
    endfor
    [st.blob, st.ref, st.tick] = ['staged', ref, -1]
    Update(buf)
  }, (header + Patch(st, hunks, lines, true))->join("\n") .. "\n")
enddef

def ApplyHunks(ref: list<string>, lines: list<string>, hunks: list<dict<any>>): list<string>
  var res: list<string> = []
  var pos = 0
  for h in hunks
    const start = h.ref_count == 0 ? h.ref_start : h.ref_start - 1
    res += ref->slice(pos, start) + lines->slice(h.buf_start - 1, h.buf_start - 1 + h.buf_count)
    pos = start + h.ref_count
  endfor
  return res + ref->slice(pos)
enddef

def Reset(buf: number, st: dict<any>, hunks: list<dict<any>>)
  var offset = 0
  for h in hunks
    const ref = st.ref->slice(h.ref_start - 1, h.ref_start - 1 + h.ref_count)
    const at = h.buf_start + offset + (h.buf_count == 0 ? 1 : 0)
    appendbufline(buf, at - 1, ref)
    if h.buf_count > 0
      deletebufline(buf, at + len(ref), at + len(ref) + h.buf_count - 1)
    endif
    offset += h.ref_count - h.buf_count
  endfor
  Update(buf)
enddef

def Patch(st: dict<any>, hunks: list<dict<any>>, lines: list<string>, stage = false): list<string>
  const cr = stage && &fileformat == 'dos' ? "\r" : ''
  var out: list<string> = []
  var offset = 0
  for h in hunks
    const start = h.ref_start + (stage && h.ref_count == 0 ? 1 : 0)
    out->add($'@@ -{start},{h.ref_count} +{stage ? start + offset : h.buf_start},{h.buf_count} @@')
    out += st.ref->slice(h.ref_start - 1, h.ref_start - 1 + h.ref_count)->map((_, l) => '-' .. l .. cr)
    out += lines->slice(h.buf_start - 1, h.buf_start - 1 + h.buf_count)->map((_, l) => '+' .. l .. cr)
    offset += h.buf_count - h.ref_count
  endfor
  return out
enddef
