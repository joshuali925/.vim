call plug#begin('~/.vim/plugged/vscode')
" change these in plugged/vscode/vim-easymotion/autoload/EasyMotion.vim:1159 after installing easymotion to limit line range instead of whole file
" let win_first_line = max([line('w0'), line('.') - 30]) " visible first line num
" let win_last_line  = min([line('w$'), line('.') + 30]) " visible last line num
Plug 'asvetliakov/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-swap'
Plug 'machakann/vim-sandwich'
Plug 'gcmt/wildfire.vim'
" swap aI and ai in plugged/vscode/vim-indent-object/plugin/indent-object.vim:28
Plug 'michaeljsmith/vim-indent-object'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-repeat'
call plug#end()

set whichwrap+=<,>,[,]
set ignorecase
set smartcase

let mapleader=';'
nmap <BS> gT
nmap \ gt
map <Space> <Plug>(wildfire-fuel)
map f <Plug>Sneak_f
map F <Plug>Sneak_F
nmap t <Plug>Sneak_s
nmap T <Plug>Sneak_S
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T
map , <Plug>Sneak_;
map ;, <Plug>Sneak_,
map <expr> n sneak#is_sneaking() ? '<Plug>Sneak_;' : 'n'
map <expr> N sneak#is_sneaking() ? '<Plug>Sneak_,' : 'N'
map S <Plug>(easymotion-bd-w)
map <leader>e <Plug>(easymotion-lineanywhere)
map <leader>j <Plug>(easymotion-sol-j)
map <leader>k <Plug>(easymotion-sol-k)
map gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
for char in [ '<Space>', '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
  execute 'xnoremap i'. char. ' :<C-u>normal! T'. char. 'vt'. char. '<CR>'
  execute 'onoremap i'. char. ' :normal vi'. char. '<CR>'
  execute 'xnoremap a'. char. ' :<C-u>normal! T'. char. 'vf'. char. '<CR>'
  execute 'onoremap a'. char. ' :normal va'. char. '<CR>'
endfor
omap ia <Plug>(swap-textobject-i)
xmap ia <Plug>(swap-textobject-i)
omap aa <Plug>(swap-textobject-a)
xmap aa <Plug>(swap-textobject-a)
nmap ys <Plug>(operator-sandwich-add)
nmap <silent> yss <Plug>(operator-sandwich-add)iw
nmap yS ysg_
nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap dss <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap css <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
xmap s <Plug>(operator-sandwich-add)
xmap s< <Plug>(operator-sandwich-add)t
xnoremap il ^og_
onoremap <silent> il :normal vil<CR>
xnoremap al 0o$
onoremap <silent> al :normal val<CR>
noremap <expr> 0 col('.') - 1 == match(getline('.'), '\S') ? '0' : '^'
noremap ^ 0
noremap - $
xnoremap - g_
noremap g- g$
map <Down> gj
map <Up> gk
nnoremap Y y$
xnoremap < <gv
xnoremap > >gv
nnoremap gp `[v`]
nnoremap <C-c> :nohlsearch<CR>
nnoremap <C-f> :call VSCodeNotify('editor.action.organizeImports') <bar> sleep 200m <bar> call VSCodeNotify('editor.action.formatDocument')<CR>
nnoremap <leader><C-f> :call VSCodeNotify('editor.action.formatChanges')<CR>
xnoremap <C-f> =
nnoremap <leader>r :call VSCodeNotify('code-runner.run')<CR>
noremap <leader>y "+y
nnoremap <leader>Y "+y$
noremap <leader>p "0p
noremap <leader>P "0P
nnoremap <leader>fs :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>fm :call VSCodeNotify('workbench.action.openRecent')<CR>
nnoremap <leader>fb :call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>
nnoremap <leader>fu :call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <leader>f] :call VSCodeNotify('workbench.action.showAllSymbols')<CR>
nnoremap <leader>fg :call VSCodeNotify('workbench.view.search')<CR>
xnoremap <leader>fg <Cmd>call VSCodeNotifyRangePos('workbench.action.findInFiles', getpos('v')[1], getpos('.')[1], getpos('v')[2], getpos('.')[2] + 1, 1)<CR>
nnoremap <leader>fj :call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
xnoremap <leader>fj :call VSCodeNotify('workbench.action.findInFiles', { 'query': <SID>GetVisualSelection() })<CR>
nnoremap <leader>fa :call VSCodeNotify('workbench.action.showCommands')<CR>
nnoremap <leader>fy :registers<CR>
nnoremap <leader>b :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
nnoremap <leader>n :let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/='\V'. substitute(escape(@x, '\'), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :call VSCodeNotify('actions.find') <bar> call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
xnoremap <leader>s <Cmd>call VSCodeNotifyRangePos('actions.find', getpos('v')[1], getpos('.')[1], getpos('v')[2], getpos('.')[2] + 1, 1) <bar> call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
nnoremap <leader>l :call <SID>PrintCurrVars(0, 0)<CR>
xnoremap <leader>l :<C-u>call <SID>PrintCurrVars(1, 0)<CR>
nnoremap <leader>L :call <SID>PrintCurrVars(0, 1)<CR>
xnoremap <leader>L :<C-u>call <SID>PrintCurrVars(1, 1)<CR>
nnoremap <leader>tu :call VSCodeNotify('workbench.action.reopenClosedEditor')<CR>
nnoremap <leader>b :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
nnoremap <leader>w :call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <leader>W :call VSCodeNotify('workbench.action.files.saveAll')<CR>
nnoremap <leader>q :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <leader>x :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
" open current file in gvim
nnoremap <leader>V :call VSCodeNotify('workbench.action.terminal.sendSequence', {'text': "gvim '${file}'\u000D"})<CR>

nnoremap <leader>l mx"xyiwoconsole.log('<C-r>x', <C-r>x);<Esc>`x
nnoremap <leader>L mx"xyiwOconsole.log('<C-r>x', <C-r>x);<Esc>`x

nnoremap Z[ :call VSCodeNotify('workbench.action.closeEditorsToTheLeft')<CR>
nnoremap Z] :call VSCodeNotify('workbench.action.closeEditorsToTheRight')<CR>
nnoremap [g :call VSCodeNotify('workbench.action.editor.previousChange')<CR>
nnoremap ]g :call VSCodeNotify('workbench.action.editor.nextChange')<CR>
nnoremap [a :call VSCodeNotify('editor.action.marker.prev')<CR>
nnoremap ]a :call VSCodeNotify('editor.action.marker.next')<CR>
nmap [b gT
nmap ]b gt
nnoremap [e :call VSCodeNotify('editor.action.moveLinesUpAction')<CR>
xnoremap [e <Cmd>call VSCodeNotifyRange('editor.action.moveLinesUpAction', line('v'), line('.'), 1)<CR>
nnoremap ]e :call VSCodeNotify('editor.action.moveLinesDownAction')<CR>
xnoremap ]e <Cmd>call VSCodeNotifyRange('editor.action.moveLinesDownAction', line('v'), line('.'), 1)<CR>
nnoremap [<Space> mxO<Esc>`x
nnoremap ]<Space> mxo<Esc>`x
nnoremap [p O<C-r>"<Esc>
nnoremap ]p o<C-r>"<Esc>

nnoremap gr :call VSCodeNotify('references-view.find')<CR>
nnoremap Ku :call VSCodeNotify('git.revertSelectedRanges')<CR>
nnoremap Ka :call VSCodeNotify('git.stageSelectedRanges')<CR>
nmap Kd gh
nnoremap <leader>a :call VSCodeNotify('editor.action.quickFix')<CR>
nnoremap <leader>R :call VSCodeNotify('editor.action.rename')<CR>
nnoremap <leader>d :call VSCodeNotify('references-view.findImplementations')<CR>

nnoremap <leader>to :call VSCodeNotify('workbench.action.terminal.focus')<CR>
nnoremap <leader>tt :call VSCodeNotify('workbench.action.terminal.newWithCwd', { 'cwd': '${fileDirname}' })<CR>
nnoremap <leader>te :call VSCodeNotify('workbench.action.terminal.runSelectedText')<CR>
xnoremap <leader>te <Cmd>call VSCodeNotifyRange('workbench.action.terminal.runSelectedText', line('v'), line('.'), 1)<CR>

nnoremap zc :call VSCodeNotify('editor.fold')<CR>
nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
nnoremap za :call VSCodeNotify('editor.toggleFold')<CR>
nnoremap zm :call VSCodeNotify('editor.foldAll')<CR>
nnoremap zM :call VSCodeNotify('editor.foldAll')<CR>
nnoremap zr :call VSCodeNotify('editor.unfoldAll')<CR>
nnoremap zR :call VSCodeNotify('editor.unfoldAll')<CR>

" nnoremap <C-d> :call VSCodeExtensionCall('scroll', 'halfPage', 'down')<CR>
nmap <C-d> Lzz
xnoremap <C-d> 15j
" nnoremap <C-u> :call VSCodeExtensionCall('scroll', 'halfPage', 'up')<CR>
nmap <C-u> Hzz
xnoremap <C-u> 15k
xnoremap H 10k
xnoremap L 10j

function! s:GetVisualSelection()
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
function! s:PrintCurrVars(visual, printAbove)
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
  let l:print['javascriptreact'] = l:print['javascript']
  let l:print['typescript'] = l:print['javascript']
  let l:print['typescriptreact'] = l:print['javascript']
  let l:print['java'] = 'System.out.println('. join(map(copy(l:vars), "'\"'. v:val. ': \" + '. v:val"), ' + " | " + '). ');'
  let l:print['vim'] = 'echomsg '. join(map(copy(l:vars), "\"'\". v:val. \": '. \". v:val"), ". ' | '. ")
  if has_key(l:print, &filetype)
    let l:pos = getcurpos()
    execute l:new_line
    call append(line('.'), l:print[&filetype])
    join
    call setpos('.', l:pos)
  endif
endfunction

let g:wildfire_objects = {
      \ '*' : ["i'", 'i"', 'i)', 'i]', 'i}', 'i`', 'ip', 'i>', 'ii', 'aI'],
      \ 'javascript,typescript,typescriptreact' : ["i'", 'i"', 'i)', 'i]', 'i}', 'i`', 'ip', 'at', 'aI'],
      \ 'python' : ["i'", 'i"', 'i)', 'i]', 'i}', 'i`', 'ip', 'ai', 'ii'],
      \ }
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_shade = 0
let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj2345789;'
let g:highlightedyank_highlight_duration = 500
let g:table_mode_tableize_map = ''
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
let g:table_mode_corner = '|'  " markdown compatible tablemode
