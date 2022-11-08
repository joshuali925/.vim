if exists('g:colors_name')
  hi clear
  syntax reset
endif
let g:colors_name = 'ayu'

hi Bold gui=bold cterm=bold
hi Italic gui=italic cterm=italic
hi Cursor gui=reverse cterm=reverse
hi Normal guifg=#cbccc6 guibg=#1f2430 ctermfg=252 ctermbg=235
hi ColorColumn guibg=#191e2a ctermbg=234
hi Conceal guifg=#5c6773 ctermfg=241
hi CursorColumn guibg=#191e2a ctermbg=234
hi CursorLine guibg=#191e2a gui=none ctermbg=234 cterm=none
hi Directory guifg=#ffd580 ctermfg=222
hi ErrorMsg guifg=#e06c75 ctermfg=168 guibg=NONE ctermbg=NONE gui=none cterm=none
hi VertSplit guifg=#1f2430 guibg=#101521 ctermfg=235 ctermbg=233
hi Folded guifg=#607080 guibg=#232834 ctermfg=242 ctermbg=235
hi FoldColumn guibg=#1f2430 ctermbg=235
hi IncSearch guifg=#ffa759 guibg=#323a4c ctermfg=215 ctermbg=237
hi LineNr guifg=#5f6675 ctermfg=242
hi CursorLineNr guifg=#ffcc66 guibg=#191e2a gui=none ctermfg=222 ctermbg=234 cterm=none
hi MatchParen guisp=#ffd580 gui=underline cterm=underline
hi ModeMsg guifg=#bae67e ctermfg=149
hi MoreMsg guifg=#bae67e ctermfg=149
hi NonText guifg=#383e4c ctermfg=237
hi PMenu guifg=#abb2bf guibg=#333841 ctermfg=249 ctermbg=237
hi PMenuSel guifg=#abb2bf guibg=#4b5263 ctermfg=249 ctermbg=239
hi PMenuSbar guibg=#292c33 ctermbg=236
hi PMenuThumb guibg=#abb2bf ctermbg=249
hi Question guifg=#bae67e ctermfg=149
hi Search guifg=#1f2430 guibg=#d4bfff ctermfg=235 ctermbg=183
hi QuickFixLine guifg=#1f2430 guibg=#d4bfff ctermfg=235 ctermbg=183
hi SpecialKey guifg=#323a4c ctermfg=237
hi StatusLine guifg=#cbccc6 guibg=#232834 gui=none ctermfg=252 ctermbg=236 cterm=none
hi StatusLineNC guifg=#607080 guibg=#232834 gui=none ctermfg=242 ctermbg=236 cterm=none
hi TabLine guifg=#5c6773 guibg=#141925 gui=none ctermfg=241 ctermbg=234 cterm=none
hi TabLineFill guifg=#cbccc6 guibg=#101521 gui=none ctermfg=252 ctermbg=233 cterm=none
hi TabLineSel guifg=#cbccc6 guibg=#1f2430 gui=none ctermfg=252 ctermbg=235 cterm=none
hi Title guifg=#ffa759 ctermfg=215
hi Visual guibg=#323a4c ctermbg=237
hi WarningMsg guifg=#ffa759 ctermfg=215
hi WildMenu guifg=#cbccc6 guibg=#f28779 ctermfg=252 ctermbg=210
hi SignColumn guibg=#1f2430 ctermbg=235
hi Comment guifg=#69737d ctermfg=243
hi Constant guifg=#bae67e ctermfg=149
hi Number guifg=#d4bfff ctermfg=183
hi Identifier guifg=#73d0ff ctermfg=117
hi Statement guifg=#ffa759 ctermfg=215
hi Operator guifg=#f29e74 ctermfg=216
hi PreProc guifg=#ffcc66 ctermfg=222
hi Type guifg=#73d0ff ctermfg=117
hi Special guifg=#ffcc66 ctermfg=222
hi SpecialChar guifg=#ffcc66 ctermfg=222
hi Underlined guifg=#5ccfe6 gui=underline ctermfg=45 cterm=underline
hi Error guifg=#ffffff guibg=#c21919 ctermfg=231 ctermbg=203
hi Todo guifg=#bf665a ctermfg=131
hi Parameter guifg=#50a14f ctermfg=71
hi CurrentWord guibg=#31435e gui=bold ctermbg=238 cterm=bold
hi DiffAdd guibg=#313d37 ctermbg=237
hi DiffChange guibg=#323a4c ctermbg=237
hi DiffDelete guibg=#3e373a ctermbg=237
hi DiffText guibg=#404755 ctermbg=238
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

set background=dark
