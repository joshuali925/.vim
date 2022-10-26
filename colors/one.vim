" https://raw.githubusercontent.com/kevinhwang91/dotfiles/d58baa79d5d2db7898e45ea4d8282e0c5e741f1e/nvim/colors/one.vim
" add 256colors: https://raw.githubusercontent.com/vim-scripts/gui2term.py/master/gui2term.py
" hex to 256color: https://stackoverflow.com/questions/11765623/convert-hex-to-closest-x11-color-number/62219320#62219320

if exists('g:colors_name')
  hi clear
  syntax reset
endif
let g:colors_name = 'one'

hi Bold gui=bold cterm=bold
hi Italic gui=italic cterm=italic
hi Cursor cterm=reverse gui=reverse
hi Normal guifg=#abb2bf ctermfg=249 guibg=#292c33 ctermbg=235
hi ColorColumn guibg=#282c34 ctermbg=236
hi Conceal guifg=#4b5263 ctermfg=239 guibg=NONE ctermbg=NONE
hi CursorColumn guibg=#282c34 ctermbg=236
hi CursorLine guibg=#282c34 ctermbg=236 gui=none cterm=none
hi Directory guifg=#61afef ctermfg=75
hi ErrorMsg guifg=#e06c75 ctermfg=168 guibg=NONE ctermbg=NONE gui=none cterm=none
hi VertSplit guifg=#3e4452 ctermfg=238 gui=none cterm=none
hi Folded guifg=#202326 ctermfg=16 guibg=#5c6370 ctermbg=241 gui=none cterm=none
hi FoldColumn guifg=#4b5263 ctermfg=239 guibg=#202326 ctermbg=16
hi IncSearch guifg=#d19a66 ctermfg=173
hi LineNr guifg=#4b5263 ctermfg=239
hi CursorLineNr guifg=#abb2bf ctermfg=249 guibg=#282c34 ctermbg=236 gui=none cterm=none
hi MatchParen guifg=#e06c75 ctermfg=168 guibg=NONE ctermbg=NONE gui=underline,bold cterm=underline,bold
hi ModeMsg guifg=#abb2bf ctermfg=249
hi MoreMsg guifg=#abb2bf ctermfg=249
hi NonText guifg=#5c6370 ctermfg=241 gui=none cterm=none
hi PMenu guifg=#abb2bf ctermfg=249 guibg=#333841 ctermbg=237
hi PMenuSel guifg=#abb2bf ctermfg=249 guibg=#4b5263 ctermbg=239
hi PMenuSbar guibg=#292c33 ctermbg=235
hi PMenuThumb guibg=#abb2bf ctermbg=249
hi Question guifg=#61afef ctermfg=75
hi QuickFixLine guibg=#31435e ctermbg=238 gui=bold cterm=bold
hi Search guifg=#202326 ctermfg=16 guibg=#e5c07b ctermbg=180
hi SpecialKey guifg=#3e4452 ctermfg=238 gui=none cterm=none
hi StatusLine guifg=#abb2bf ctermfg=249 guibg=#30353f ctermbg=236 gui=none cterm=none
hi StatusLineNC guifg=#202326 ctermfg=16 guibg=#5c6370 ctermbg=241 gui=none cterm=none
hi TabLine guifg=#abb2bf ctermfg=249 guibg=#3e4452 ctermbg=238 gui=none cterm=none
hi TabLineFill guifg=#5c6370 ctermfg=241 guibg=#292c33 ctermbg=235 gui=none cterm=none
hi TabLineSel guifg=#292c33 ctermfg=235 guibg=#8a8a8a ctermbg=245 gui=bold cterm=bold
hi Title guifg=#abb2bf ctermfg=249 gui=bold cterm=bold
hi Visual guibg=#3e4452 ctermbg=238
hi WarningMsg guifg=#e06c75 ctermfg=168
hi WildMenu guifg=#abb2bf ctermfg=249 guibg=#5c6370 ctermbg=241
hi SignColumn guibg=#202326 ctermbg=16
hi Comment guifg=#5c6370 ctermfg=241
hi Constant guifg=#98c379 ctermfg=114
hi Number guifg=#d19a66 ctermfg=173
hi Identifier guifg=#e06c75 ctermfg=168 gui=none cterm=none
hi Statement guifg=#c678dd ctermfg=176 gui=none cterm=none
hi Operator guifg=#528bff ctermfg=69 gui=none cterm=none
hi PreProc guifg=#e5c07b ctermfg=180
hi Type guifg=#e5c07b ctermfg=180 gui=none cterm=none
hi Special guifg=#61afef ctermfg=75
hi SpecialChar guifg=#56b6c2 ctermfg=73
hi Underlined guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=underline cterm=underline
hi Error guifg=#e06c75 ctermfg=168 guibg=NONE ctermbg=NONE gui=bold cterm=bold
hi Todo guifg=#c678dd ctermfg=176 guibg=NONE ctermbg=NONE gui=italic cterm=italic
hi Parameter guifg=#50a14f ctermfg=71
hi CurrentWord guibg=#31435e ctermbg=238 gui=bold cterm=bold
hi DiffAdd guifg=NONE ctermfg=NONE guibg=#0b4820 ctermbg=22 gui=none cterm=none
hi DiffChange guifg=NONE ctermfg=NONE guibg=#30353f ctermbg=236 gui=none cterm=none
hi DiffDelete guifg=NONE ctermfg=NONE guibg=#450a15 ctermbg=52 gui=none cterm=none
hi DiffText guifg=NONE ctermfg=NONE guibg=#263F78 ctermbg=237 gui=bold cterm=bold
hi htmlH1 guifg=#56b6c2 ctermfg=73 gui=bold cterm=bold
hi markdownBold guifg=#d19a66 ctermfg=173 gui=bold cterm=bold
hi markdownItalic guifg=#d19a66 ctermfg=173 gui=bold cterm=bold

" editor color
hi link Whitespace SpecialKey

" syntax
hi link Define Statement
hi link Macro Statement
hi link Include Special
hi link Function Special
hi link Delimiter NONE
hi link Boolean Number
hi link Float Number
hi link Label Identifier

" help
hi link helpCommand Type
hi link helpExample Type
hi link helpHeader Title
hi link helpSectionDelim NonText

" asciidoc
hi link asciidocListingBlock NonText

" git related plugins
hi link DiffAdded DiffAdd
hi link DiffNewFile DiffAdd
hi link DiffFile DiffDelete
hi link DiffRemoved DiffDelete
hi link DiffLine DiffText

" markdown
hi link markdownUrl NonText
hi link markdownCode Constant
hi link markdownCodeDelimiter Constant
hi link markdownCodeBlock Identifier
hi link markdownHeadingDelimiter SpecialChar
hi link markdownListMarker Identifier
hi link markdownError Normal

" vim
hi link vimCommentTitle NonText
hi link vimHighlight Function
hi link vimFunction Function
hi link vimFuncName Keyword
hi link vimHighlight Function
hi link vimUserFunc Function
hi link vimNotation SpecialChar
hi link vimFuncSID SpecialChar

" xml
hi link xmlTag Identifier
hi link xmlTagName Identifier

" zsh
hi link zshCommands Keyword
hi link zshDeref Identifier
hi link zshShortDeref Identifier
hi link zshFunction Function
hi link zshSubst Identifier
hi link zshSubstDelim NonText
hi link zshVariableDef Number

" man
hi link manTitle SpecialChar
hi link manFooter NonText

" hi! link markdownItalic Normal
set background=dark
