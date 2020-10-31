" =============================================================================
" Filename: autoload/lightline/colorscheme/ayu_mirage.vim
" Author: impulse
" License: MIT License
" Last Change: 2020/05/01 19:37:21.
" =============================================================================

let s:style = get(g:, 'ayucolor', 'dark')

let s:base0   = {'dark': '#e6e1cf' , 'light': '#5C6773', 'mirage': '#d9d7ce'}[s:style]
let s:base1   = {'dark': '#e6e1cf' , 'light': '#5C6773', 'mirage': '#d9d7ce'}[s:style]
let s:base2   = {'dark': '#3e4b59' , 'light': '#828C99', 'mirage': '#607080'}[s:style]
let s:base3   = {'dark': '#e6e1cf' , 'light': '#5C6773', 'mirage': '#d9d7ce'}[s:style]
let s:base00  = {'dark': '#14191f' , 'light': '#FFFFFF', 'mirage': '#272d38'}[s:style]
let s:base01  = {'dark': '#14191f' , 'light': '#FFFFFF', 'mirage': '#272d38'}[s:style]
let s:base02  = {'dark': '#0f1419' , 'light': '#FAFAFA', 'mirage': '#212733'}[s:style]
let s:base023 = {'dark': '#0f1419' , 'light': '#FAFAFA', 'mirage': '#212733'}[s:style]
let s:base03  = {'dark': '#e6b673' , 'light': '#E6B673', 'mirage': '#ffc44c'}[s:style]
let s:yellow  = {'dark': '#e6b673' , 'light': '#E6B673', 'mirage': '#ffc44c'}[s:style]
let s:orange  = {'dark': '#ff7733' , 'light': '#FF7733', 'mirage': '#ffae57'}[s:style]
let s:red     = {'dark': '#f07178' , 'light': '#f07178', 'mirage': '#f07178'}[s:style]
let s:magenta = {'dark': '#ffee99' , 'light': '#A37ACC', 'mirage': '#d4bfff'}[s:style]
let s:blue    = {'dark': '#36a3d9' , 'light': '#59c2ff', 'mirage': '#59c2ff'}[s:style]
let s:cyan    = {'dark': s:blue    , 'light': s:blue   , 'mirage': s:blue   }[s:style]
let s:green   = {'dark': '#b8cc52' , 'light': '#86B300', 'mirage': '#bbe67e'}[s:style]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:base02, s:blue ], [ s:base3, s:base01 ] ]
let s:p.normal.middle = [ [ s:base2, s:base02 ] ]
let s:p.normal.right = [ [ s:base02, s:base0 ], [ s:base1, s:base01 ] ]
let s:p.inactive.left =  [ [ s:base1, s:base01 ], [ s:base3, s:base01 ] ]
let s:p.inactive.middle = [ [ s:base1, s:base023 ] ]
let s:p.inactive.right = [ [ s:base1, s:base01 ], [ s:base2, s:base02 ] ]
let s:p.insert.left = [ [ s:base02, s:green ], [ s:base3, s:base01 ] ]
let s:p.replace.left = [ [ s:base023, s:red ], [ s:base3, s:base01 ] ]
let s:p.visual.left = [ [ s:base02, s:magenta ], [ s:base3, s:base01 ] ]
let s:p.tabline.tabsel = [ [ s:base02, s:base03 ] ]
let s:p.tabline.left = [ [ s:base3, s:base00 ] ]
let s:p.tabline.middle = [ [ s:base2, s:base02 ] ]
let s:p.tabline.right = [ [ s:base2, s:base00 ] ]
let s:p.normal.error = [ [ s:base03, s:red ] ]
let s:p.normal.warning = [ [ s:base023, s:yellow ] ]

let g:lightline#colorscheme#ayu#palette = lightline#colorscheme#fill(s:p)
