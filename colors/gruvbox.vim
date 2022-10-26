if exists('g:colors_name')
  hi clear
  syntax reset
endif
let g:colors_name = 'gruvbox'

hi Bold gui=bold cterm=bold
hi Italic gui=italic cterm=italic
hi Cursor gui=reverse cterm=reverse
hi Normal ctermfg=223 ctermbg=235 guifg=#d4be98 guibg=#282828
hi ColorColumn term=reverse ctermbg=236 guibg=#32302f
hi Conceal ctermfg=243 guifg=#7c6f64
hi CursorColumn term=reverse ctermbg=236 guibg=#32302f
hi CursorLine cterm=none ctermbg=236 gui=none guibg=#32302f
hi Directory term=bold ctermfg=142 guifg=#a9b665
hi VertSplit term=reverse ctermfg=239 guifg=#5a524c
hi Folded term=standout ctermfg=245 ctermbg=236 guifg=#928374 guibg=#32302f
hi FoldColumn term=standout ctermfg=243 ctermbg=236 guifg=#7c6f64 guibg=#32302f
hi IncSearch term=reverse ctermfg=235 ctermbg=167 guifg=#282828 guibg=#ea6962
hi LineNr cterm=none ctermfg=243 gui=none guifg=#7c6f64
hi CursorLineNr cterm=none ctermfg=246 ctermbg=236 gui=none guifg=#a89984 guibg=#32302f
hi MatchParen cterm=underline ctermbg=237 gui=underline guibg=#45403d
hi ModeMsg term=bold cterm=bold ctermfg=223 gui=bold guifg=#d4be98
hi MoreMsg term=bold cterm=bold ctermfg=214 gui=bold guifg=#d8a657
hi NonText term=bold ctermfg=239 guifg=#5a524c
hi PMenu guifg=#abb2bf guibg=#333841 ctermfg=249 ctermbg=237
hi PMenuSel guifg=#abb2bf guibg=#4b5263 ctermfg=249 ctermbg=239
hi PMenuSbar guibg=#292c33 ctermbg=236
hi PMenuThumb guibg=#abb2bf ctermbg=249
hi Question term=standout ctermfg=214 guifg=#d8a657
hi Search term=reverse ctermfg=235 ctermbg=142 guifg=#282828 guibg=#a9b665
hi QuickFixLine cterm=bold ctermfg=175 gui=bold guifg=#d3869b
hi SpecialKey cterm=none ctermfg=239 gui=none guifg=#5a524c
hi StatusLine cterm=none ctermfg=223 gui=none ctermbg=236 guifg=#ddc7a1 guibg=#3a3735
hi StatusLineNC term=reverse ctermfg=246 ctermbg=236 guifg=#a89984 guibg=#3a3735
hi TabLine cterm=none ctermfg=223 ctermbg=240 gui=none guifg=#ddc7a1 guibg=#504945
hi TabLineFill cterm=none ctermfg=223 ctermbg=236 gui=none guifg=#d4be98 guibg=#32302f
hi TabLineSel cterm=none ctermfg=235 ctermbg=246 gui=none guifg=#282828 guibg=#a89984
hi Title term=bold cterm=bold ctermfg=208 gui=bold guifg=#e78a4e
hi Visual term=reverse ctermbg=237 guibg=#45403d
hi WarningMsg term=standout cterm=bold ctermfg=214 gui=bold guifg=#d8a657
hi WildMenu term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
hi SignColumn term=standout ctermfg=223 ctermbg=236 guifg=#d4be98 guibg=#32302f
hi Comment term=bold ctermfg=245 gui=italic guifg=#928374
hi Constant term=underline ctermfg=108 guifg=#89b482
hi Number ctermfg=175 guifg=#d3869b
hi Identifier term=underline ctermfg=109 guifg=#7daea3
hi Statement term=bold ctermfg=167 guifg=#ea6962
hi Operator ctermfg=208 guifg=#e78a4e
hi PreProc term=underline ctermfg=175 guifg=#d3869b
hi Type term=underline ctermfg=214 guifg=#d8a657
hi Special term=bold ctermfg=214 guifg=#d8a657
hi SpecialChar ctermfg=214 guifg=#d8a657
hi Underlined term=underline cterm=underline gui=underline
hi Error term=reverse ctermfg=167 guifg=#ea6962
hi Todo term=standout cterm=italic ctermfg=175 gui=italic guifg=#d3869b
hi Parameter guifg=#50a14f ctermfg=71
hi CurrentWord ctermbg=237 guibg=#3c3836
hi DiffAdd term=bold ctermbg=22 guibg=#34381b
hi DiffChange term=bold ctermbg=17 guibg=#0e363e
hi DiffDelete term=bold ctermbg=52 guibg=#402120
hi DiffText term=reverse ctermfg=235 ctermbg=223 guifg=#282828 guibg=#d4be98
hi htmlH1 cterm=bold ctermfg=167 gui=bold guifg=#ea6962
hi markdownBold cterm=bold gui=bold
hi markdownItalic cterm=italic gui=italic

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
