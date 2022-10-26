if exists('g:colors_name')
  hi clear
  syntax reset
endif
let g:colors_name = 'papercolor'

hi Bold gui=bold cterm=bold
hi Italic gui=italic cterm=italic
hi Cursor gui=reverse cterm=reverse
hi Normal guifg=#444444 guibg=#eeeeee ctermfg=238 ctermbg=255
hi ColorColumn term=reverse guibg=#e4e4e4 ctermbg=254
hi Conceal guifg=#b2b2b2 guibg=#eeeeee ctermfg=249 ctermbg=255
hi CursorColumn term=reverse guibg=#e4e4e4 ctermbg=254
hi CursorLine term=underline guibg=#e4e4e4 ctermbg=254 cterm=NONE
hi Directory term=bold guifg=#005faf ctermfg=25
hi ErrorMsg term=standout guifg=#eeeeee guibg=#d70000 ctermfg=255 ctermbg=160
hi VertSplit term=reverse guifg=#eeeeee guibg=#005f87 gui=reverse ctermfg=255 ctermbg=24 cterm=reverse
hi Folded term=standout guifg=#0087af guibg=#afd7ff ctermfg=31 ctermbg=153
hi FoldColumn term=standout guifg=#0087af guibg=#eeeeee ctermfg=31 ctermbg=255
hi IncSearch term=reverse gui=reverse cterm=reverse
hi LineNr term=underline guifg=#b2b2b2 guibg=#eeeeee ctermfg=249 ctermbg=255
hi CursorLineNr cterm=none gui=none guifg=#af5f00 guibg=#eeeeee ctermfg=130 ctermbg=255
hi MatchParen term=reverse guifg=#005f87 guibg=#c6c6c6 ctermfg=24 ctermbg=251
hi ModeMsg term=bold guifg=#5f8700 gui=bold ctermfg=64 cterm=bold
hi MoreMsg term=bold guifg=#5f8700 gui=bold ctermfg=64 cterm=bold
hi NonText term=bold guifg=#bcbcbc guibg=#eeeeee gui=bold ctermfg=250 ctermbg=255 cterm=bold
hi PMenu ctermfg=238 ctermbg=253 guifg=#31435e guibg=#e1e2e7
hi PMenuSel ctermfg=238 ctermbg=117 guifg=#31435e guibg=#88d7ff
hi PMenuSbar ctermbg=252 guibg=#d0d0d0
hi PMenuThumb ctermbg=249 guibg=#b2b3b2
hi Question term=standout guifg=#5f8700 gui=bold ctermfg=64 cterm=bold
hi Search term=reverse guifg=#444444 guibg=#ffff5f ctermfg=238 ctermbg=227
hi QuickFixLine term=reverse guifg=#444444 guibg=#ffff5f ctermfg=238 ctermbg=227
hi SpecialKey term=bold guifg=#bcbcbc ctermfg=250
hi StatusLine term=bold,reverse guifg=#005f87 guibg=#e4e4e4 gui=bold,reverse ctermfg=24 ctermbg=254 cterm=bold,reverse
hi StatusLineNC term=reverse guifg=#d0d0d0 guibg=#444444 gui=reverse ctermfg=252 ctermbg=238 cterm=reverse
hi TabLine cterm=none gui=none guifg=#eeeeee guibg=#0087af ctermfg=255 ctermbg=31
hi TabLineFill term=reverse guifg=#005f87 guibg=#005f87 ctermfg=24 ctermbg=24
hi TabLineSel term=bold guifg=#444444 guibg=#e4e4e4 ctermfg=238 ctermbg=254
hi Title term=bold guifg=#878787 gui=bold ctermfg=102 cterm=bold
hi Visual term=reverse guifg=#eeeeee guibg=#0087af ctermfg=255 ctermbg=31
hi WarningMsg term=standout guifg=#d70087 ctermfg=162
hi WildMenu term=standout guifg=#444444 guibg=#ffff00 gui=bold ctermfg=238 ctermbg=226 cterm=bold
hi SignColumn term=standout guifg=#008700 guibg=#eeeeee ctermfg=28 ctermbg=255
hi Comment term=bold guifg=#878787 ctermfg=102
hi Constant term=underline guifg=#d75f00 ctermfg=166
hi Number guifg=#d75f00 ctermfg=166
hi Identifier term=underline guifg=#005f87 ctermfg=24
hi Statement term=bold guifg=#d70087 ctermfg=162
hi Operator guifg=#0087af ctermfg=31
hi PreProc term=underline guifg=#005faf ctermfg=25
hi Type term=underline guifg=#d70087 gui=bold ctermfg=162 cterm=bold
hi Special term=bold guifg=#444444 ctermfg=238
hi SpecialChar guifg=#444444 ctermfg=238
hi Underlined term=underline guifg=#005f87 gui=underline ctermfg=24 cterm=underline
hi Error term=reverse guifg=#af0000 guibg=#ffd7ff ctermfg=124 ctermbg=225
hi Todo term=standout guifg=#00af5f guibg=#eeeeee gui=bold ctermfg=35 ctermbg=255 cterm=bold
hi Parameter guifg=#50a14f ctermfg=71
hi CurrentWord guibg=#31435e gui=bold ctermbg=238 cterm=bold
hi DiffAdd term=bold guibg=#0087af ctermbg=31
hi DiffChange term=bold guibg=#af0000 ctermbg=124
hi DiffDelete term=bold guifg=#005faf guibg=#0087af gui=bold ctermfg=25 ctermbg=31 cterm=bold
hi DiffText term=reverse guibg=#d70000 gui=bold ctermbg=160 cterm=bold
hi htmlH1 cterm=bold ctermfg=28
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

set background=light
