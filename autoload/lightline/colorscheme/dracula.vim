" =============================================================================
" Filename: autoload/lightline/colorscheme/dracula.vim
" Author: adamalbrecht
" License: MIT License
" Last Change: 2018/04/11
" =============================================================================
let g:dracula#palette           = {}
let g:dracula#palette.fg        = ['#F8F8F2', 253]

let g:dracula#palette.bglighter = ['#424450', 238]
let g:dracula#palette.bglight   = ['#343746', 237]
let g:dracula#palette.bg        = ['#282A36', 236]
let g:dracula#palette.bgdark    = ['#21222C', 235]
let g:dracula#palette.bgdarker  = ['#191A21', 234]

let g:dracula#palette.comment   = ['#6272A4',  61]
let g:dracula#palette.selection = ['#44475A', 239]
let g:dracula#palette.subtle    = ['#424450', 238]

let g:dracula#palette.cyan      = ['#8BE9FD', 117]
let g:dracula#palette.green     = ['#50FA7B',  84]
let g:dracula#palette.orange    = ['#FFB86C', 215]
let g:dracula#palette.pink      = ['#FF79C6', 212]
let g:dracula#palette.purple    = ['#BD93F9', 141]
let g:dracula#palette.red       = ['#FF5555', 203]
let g:dracula#palette.yellow    = ['#F1FA8C', 228]

let s:black    = g:dracula#palette.bg
let s:gray     = g:dracula#palette.selection
let s:white    = g:dracula#palette.fg
let s:darkblue = g:dracula#palette.comment
let s:cyan     = g:dracula#palette.cyan
let s:green    = g:dracula#palette.green
let s:orange   = g:dracula#palette.orange
let s:purple   = g:dracula#palette.purple
let s:red      = g:dracula#palette.red
let s:yellow   = g:dracula#palette.yellow

if exists('g:lightline')

  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let s:p.normal.left = [ [ s:black, s:purple ], [ s:cyan, s:gray ] ]
  let s:p.normal.right = [ [ s:black, s:purple ], [ s:white, s:darkblue ] ]
  let s:p.inactive.right = [ [ s:black, s:darkblue ], [ s:white, s:black ] ]
  let s:p.inactive.left =  [ [ s:cyan, s:black ], [ s:white, s:black ] ]
  let s:p.insert.left = [ [ s:black, s:green ], [ s:cyan, s:gray ] ]
  let s:p.replace.left = [ [ s:black, s:red ], [ s:cyan, s:gray ] ]
  let s:p.visual.left = [ [ s:black, s:orange ], [ s:cyan, s:gray ] ]
  let s:p.normal.middle = [ [ s:white, s:gray ] ]
  let s:p.inactive.middle = [ [ s:white, s:gray ] ]
  let s:p.tabline.left = [ [ s:darkblue, s:gray ] ]
  let s:p.tabline.tabsel = [ [ s:cyan, s:black ] ]
  let s:p.tabline.middle = [ [ s:darkblue, s:gray ] ]
  let s:p.tabline.right = copy(s:p.normal.right)
  let s:p.normal.error = [ [ s:red, s:black ] ]
  let s:p.normal.warning = [ [ s:yellow, s:black ] ]

  let g:lightline#colorscheme#dracula#palette = lightline#colorscheme#flatten(s:p)

endif

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
