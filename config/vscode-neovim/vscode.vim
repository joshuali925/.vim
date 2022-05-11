" vscode-neovim vimrc, to install plugins:
" nvim -u ~/.vim/config/vscode-neovim/vscode.vim +PlugInstall +quitall

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
Plug 'machakann/vim-sandwich'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'machakann/vim-highlightedyank'
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
xnoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ii :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> ai :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> iI :<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv
onoremap <silent> aI :<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>
xnoremap <silent> v :<C-u>call plugins#expand_region#next('v', '+')<CR>
xnoremap <silent> <BS> :<C-u>call plugins#expand_region#next('v', '-')<CR>
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
  execute 'xnoremap a'. char. ' :<C-u>normal! F'. char. 'vt'. char. '<CR>'
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
noremap <expr> 0 funcs#home()
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
nnoremap <leader>fU :call VSCodeNotify('workbench.action.showAllSymbols')<CR>
nnoremap <leader>fg :call VSCodeNotify('workbench.view.search')<CR>
xnoremap <leader>fg <Cmd>call VSCodeNotifyRangePos('workbench.action.findInFiles', getpos('v')[1], getpos('.')[1], getpos('v')[2], getpos('.')[2] + 1, 1)<CR>
nnoremap <leader>fj :call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
xnoremap <leader>fj :call VSCodeNotify('workbench.action.findInFiles', { 'query': funcs#get_visual_selection() })<CR>
nnoremap <leader>fa :call VSCodeNotify('workbench.action.showCommands')<CR>
nnoremap <leader>fA :call VSCodeNotify('workbench.action.focusActivityBar')<CR>
nnoremap <leader>fy :registers<CR>
nnoremap <leader>b :call VSCodeNotify('workbench.view.explorer')<CR>
nnoremap <leader>n :let @/ = '\<<C-r><C-w>\>' <bar> set hlsearch<CR>
xnoremap <leader>n "xy:let @/ = substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>
nnoremap <leader>s :call VSCodeNotify('actions.find') <bar> call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
xnoremap <leader>s <Cmd>call VSCodeNotifyRangePos('actions.find', getpos('v')[1], getpos('.')[1], getpos('v')[2], getpos('.')[2] + 1, 1) <bar> call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
nnoremap <leader>l :call funcs#print_variable(0, 0)<CR>
xnoremap <leader>l :<C-u>call funcs#print_variable(1, 0)<CR>
nnoremap <leader>L :call funcs#print_variable(0, 1)<CR>
xnoremap <leader>L :<C-u>call funcs#print_variable(1, 1)<CR>
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

nnoremap gD :call VSCodeNotify('editor.action.peekTypeDefinition')<CR>
nnoremap gr :call VSCodeNotify('references-view.find')<CR>
nnoremap Ku :call VSCodeNotify('git.revertSelectedRanges')<CR>
nnoremap Ka :call VSCodeNotify('git.stageSelectedRanges')<CR>
nmap Kd gh
nnoremap Kr :call VSCodeNotify('openInGithub.openInGitHubFile')<CR>
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

let g:wordmotion_nomap = 1
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:highlightedyank_highlight_duration = 500
