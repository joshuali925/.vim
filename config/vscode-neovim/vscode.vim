set packpath=
set runtimepath-=$HOME/.config/nvim
set runtimepath+=$HOME/.vim/config/vscode-neovim

call plug#begin('~/.vim/config/vscode-neovim/plugged')
" change these in plugged/vim-easymotion/autoload/EasyMotion.vim:1159 after installing easymotion to limit line range instead of whole file
" let win_first_line = max([line('w0'), line('.') - 30]) " visible first line num
" let win_last_line  = min([line('w$'), line('.') + 30]) " visible last line num
Plug 'asvetliakov/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-swap'
Plug 'chaoren/vim-wordmotion'
Plug 'terryma/vim-expand-region'
Plug 'machakann/vim-sandwich'
Plug 'joshuali925/vim-indent-object'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-repeat'
Plug 'maxbrunsfeld/vim-yankstack'
call plug#end()
call yankstack#setup()

set whichwrap+=<,>,[,]
set ignorecase
set smartcase

let mapleader=';'
nmap <BS> gT
nmap \ gt
map gw <Plug>WordMotion_w
map gb <Plug>WordMotion_b
map ge <Plug>WordMotion_e
omap u <Plug>WordMotion_w
omap iu <Plug>WordMotion_iw
xmap iu <Plug>WordMotion_iw
omap au <Plug>WordMotion_aw
xmap au <Plug>WordMotion_aw
xmap v <Plug>(expand_region_expand)
xmap <BS> <Plug>(expand_region_shrink)
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
map ' <Plug>(easymotion-bd-f)
map q <Plug>(easymotion-bd-w)
map <leader>e <Plug>(easymotion-lineanywhere)
map <leader>j <Plug>(easymotion-sol-j)
map <leader>k <Plug>(easymotion-sol-k)
map gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
for char in [ '<Space>', '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '=', '&' ]
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
nnoremap _ <C-o>
nnoremap + <C-i>
nnoremap Q q
" yankstack needs nmap
nmap Y y$
xnoremap < <gv
xnoremap > >gv
nnoremap gp `[v`]
nnoremap <C-c> :nohlsearch<CR>
nnoremap <C-f> :call VSCodeCall('editor.action.organizeImports') <bar> sleep 500m <bar> call VSCodeCall('editor.action.formatDocument')<CR>
nnoremap <leader><C-f> :call VSCodeNotify('editor.action.formatChanges')<CR>
xnoremap <C-f> =
nnoremap <leader>r :call <SID>RunCode()<CR>
noremap <leader>y "+y
nnoremap <leader>Y "+y$
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nnoremap <C-p> :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>fs :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>fd :call VSCodeNotify('breadcrumbs.focus')<CR>
nnoremap <leader>fm :call VSCodeNotify('workbench.action.openRecent')<CR>
nnoremap <leader>fb :call VSCodeNotify('workbench.explorer.openEditorsView.toggleVisibility')<CR>
nnoremap <leader>fu :call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <leader>f] :call VSCodeNotify('workbench.action.showAllSymbols')<CR>
nnoremap <leader>fg :call VSCodeNotify('workbench.view.search')<CR>
xnoremap <leader>fg <Cmd>call VSCodeNotifyRangePos('workbench.action.findInFiles', getpos('v')[1], getpos('.')[1], getpos('v')[2], getpos('.')[2] + 1, 1)<CR>
nnoremap <leader>fj :call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
xnoremap <leader>fj :call VSCodeNotify('workbench.action.findInFiles', { 'query': <SID>GetVisualSelection() })<CR>
nnoremap <leader>fa :call VSCodeNotify('workbench.action.showCommands')<CR>
nnoremap <leader>fA :call VSCodeNotify('workbench.action.focusActivityBar')<CR>
nnoremap <leader>fy :registers<CR>
nnoremap <leader>b :call VSCodeNotify('workbench.view.explorer')<CR>
nnoremap <leader>n :let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/='\V'. substitute(escape(@x, '\'), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :call VSCodeNotify('actions.find') <bar> call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
xnoremap <leader>s <Cmd>call VSCodeNotifyRangePos('actions.find', getpos('v')[1], getpos('.')[1], getpos('v')[2], getpos('.')[2] + 1, 1) <bar> call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
nnoremap <leader>l :call <SID>PrintCurrVars(0, 0)<CR>
xnoremap <leader>l :<C-u>call <SID>PrintCurrVars(1, 0)<CR>
nnoremap <leader>L :call <SID>PrintCurrVars(0, 1)<CR>
xnoremap <leader>L :<C-u>call <SID>PrintCurrVars(1, 1)<CR>
nnoremap <leader>tu :call VSCodeNotify('workbench.action.reopenClosedEditor')<CR>
nnoremap <leader>w :call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <leader>W :call VSCodeNotify('workbench.action.files.saveAll')<CR>
nnoremap <leader>q :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <leader>x :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
" open current file in gvim
" nnoremap <leader>V :call VSCodeNotify('workbench.action.terminal.sendSequence', {'text': "gvim '${file}'\u000D"})<CR>
nnoremap <leader>V :call VSCodeNotify('workbench.action.terminal.sendSequence', {'text': "iterm \"vim '${file}' && exit\"\u000D"})<CR>

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

function! s:RunCode()
  if expand('%') =~ 'test.[tj]sx\?'
    call VSCodeNotify('extension.runJestAndUpdateSnapshots')
  else
    call VSCodeNotify('code-runner.run')
  endif
endfunction
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
  let l:new_line = a:printAbove ? 'O' : 'o'
  let l:word = a:visual ? <SID>GetVisualSelection() : expand('<cword>')
  let l:print = {}
  let l:print['python'] = "print('". l:word. "', ". l:word. ')'
  let l:print['javascript'] = "console.log('". l:word. "', ". l:word. ');'
  let l:print['javascriptreact'] = l:print['javascript']
  let l:print['typescript'] = l:print['javascript']
  let l:print['typescriptreact'] = l:print['javascript']
  let l:print['java'] = 'System.out.println("'. l:word. '" + '. l:word. ');'
  let l:print['vim'] = "echomsg '". l:word. "' ". l:word
  let l:pos = getcurpos()
  execute 'normal! '. l:new_line. get(l:print, &filetype, l:print['javascript'])
  call setpos('.', l:pos)
endfunction

let g:wordmotion_nomap = 1
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:highlightedyank_highlight_duration = 500
let g:table_mode_tableize_map = ''
let g:table_mode_motion_left_map = '<leader>th'
let g:table_mode_motion_up_map = '<leader>tk'
let g:table_mode_motion_down_map = '<leader>tj'
let g:table_mode_motion_right_map = '<leader>tl'
let g:table_mode_corner = '|'  " markdown compatible tablemode
