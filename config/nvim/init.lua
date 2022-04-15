-- options {{{
pcall(require, "impatient") --         lua/states.lua
require("states") --                   lua/utils.lua
vim.g.loaded_matchparen = 1 --         lua/themes.lua
vim.g.loaded_matchit = 1 --            lua/plugins.lua
vim.g.loaded_2html_plugin = 1 --       lua/plugin-configs.lua
vim.g.loaded_remote_plugins = 1 --     lua/lsp.lua
vim.g.loaded_tutor_mode_plugin = 1 --  lua/rooter.lua
vim.g.do_filetype_lua = 1 --           ginit.vim
vim.g.did_load_filetypes = 0 --        autoload/funcs.vim
vim.g.mapleader = ";"
vim.g.maplocalleader = "|"
vim.g.netrw_dirhistmax = 0
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.markdown_fenced_languages = { "javascript", "js=javascript", "css", "html", "python", "java", "c", "bash=sh" }
vim.opt.whichwrap = "<,>,[,]"
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.numberwidth = 2
vim.opt.number = true
vim.opt.linebreak = true
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.diffopt = vim.opt.diffopt + { "vertical", "indent-heuristic", "algorithm:patience" }
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.textwidth = 0
vim.opt.complete = { ".", "w", "b", "u" }
vim.opt.completeopt = { "menuone", "noinsert" }
vim.opt.completefunc = "funcs#complete_word"
vim.opt.pumblend = 8
vim.opt.shortmess = vim.opt.shortmess + { c = true, A = true }
vim.opt.spellsuggest = vim.opt.spellsuggest + { 10 }
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.virtualedit = "block"
vim.opt.previewheight = 7
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.jumpoptions = "stack"
vim.opt.shada = [[!,'1000,<50,s10,/20,@20,h]]
vim.opt.undofile = true
vim.opt.isfname = vim.opt.isfname - { "=" }
vim.opt.path = { ".", "", "**5" }
vim.opt.list = true
vim.opt.listchars = { tab = "» ", nbsp = "␣", trail = "•" }
vim.opt.timeoutlen = 1500
vim.opt.ttimeoutlen = 40
vim.opt.synmaxcol = 1000
vim.opt.lazyredraw = true
vim.opt.writebackup = false
vim.opt.wildcharm = 26 -- <C-z>
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --auto-hybrid-regex"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.cedit = "<C-x>"

-- mappings {{{1
-- text objects {{{2
local text_objects = { "<Space>", "_", ".", ":", ",", ";", "<bar>", "/", "<bslash>", "*", "+", "-", "#", "=", "&" }
for _, char in ipairs(text_objects) do
    vim.keymap.set("x", "i" .. char, ":<C-u>normal! T" .. char .. "vt" .. char .. "<CR>", { silent = true })
    vim.keymap.set("o", "i" .. char, "<Cmd>normal vi" .. char .. "<CR>", { silent = true })
    vim.keymap.set("x", "a" .. char, ":<C-u>normal! F" .. char .. "vt" .. char .. "<CR>", { silent = true })
    vim.keymap.set("o", "a" .. char, "<Cmd>normal va" .. char .. "<CR>", { silent = true })
end
vim.keymap.set("x", "il", "^og_")
vim.keymap.set("o", "il", "<Cmd>normal vil<CR>")
vim.keymap.set("x", "al", "0o$")
vim.keymap.set("o", "al", "<Cmd>normal val<CR>")
vim.keymap.set("x", "ii", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "ii", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("x", "ai", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "ai", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("x", "iI", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "iI", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("x", "aI", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "aI", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("x", "v", ":<C-u>call plugins#expand_region#next('v', '+')<CR>", { silent = true })
vim.keymap.set("x", "<BS>", ":<C-u>call plugins#expand_region#next('v', '-')<CR>", { silent = true })
-- general {{{2
vim.keymap.set("n", "[\\", "<Cmd>tabedit<CR>")
vim.keymap.set("n", "]\\", "<Cmd>enew<CR>")
vim.keymap.set({ "n", "x", "o" }, "0", "funcs#home()", { expr = true })
vim.keymap.set({ "n", "x", "o" }, "^", "0")
vim.keymap.set({ "n", "o" }, "-", "$") -- $ in normal mode will always put cursor at last column when scrolling, g_ will not
vim.keymap.set("x", "-", "g_")
vim.keymap.set({ "n", "x", "o" }, "g-", "g$")
vim.keymap.set({ "n", "x", "o" }, "<Home>", "g^")
vim.keymap.set({ "n", "x", "o" }, "<End>", "g$")
vim.keymap.set({ "n", "x", "o" }, "<Down>", "gj")
vim.keymap.set({ "n", "x", "o" }, "<Up>", "gk")
vim.keymap.set("!", "<S-Del>", "<BS>")
vim.keymap.set("i", "<Down>", "pumvisible() ? '<C-n>' : '<C-o>gj'", { expr = true })
vim.keymap.set("i", "<Up>", "pumvisible() ? '<C-p>' : '<C-o>gk'", { expr = true })
vim.keymap.set("i", "<Home>", "<C-o>g^")
vim.keymap.set("i", "<End>", "<C-o>g$")
vim.keymap.set("i", "<C-_>", "<C-o>u")
vim.keymap.set("n", "_", "<C-o>")
vim.keymap.set("n", "+", "<C-i>")
vim.keymap.set("n", "Q", "q")
vim.keymap.set("x", "@q", ":normal! @q<CR>")
vim.keymap.set("x", "@@", ":normal! @@<CR>")
vim.keymap.set("n", "U", "<Cmd>execute 'earlier '. v:count1. 'f'<CR>")
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("n", "gp", "`[v`]")
vim.keymap.set("n", "zm", "<Cmd>%foldclose<CR>")
vim.keymap.set("n", "cr", "<Cmd>call funcs#edit_register()<CR>")
vim.keymap.set("n", "Z[", "<Cmd>BufferLineCloseLeft<CR>")
vim.keymap.set("n", "Z]", "<Cmd>BufferLineCloseRight<CR>")
vim.keymap.set("n", "gx", "<Cmd>call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>")
vim.keymap.set("x", "gx", ":<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>")
vim.keymap.set("n", "<C-c>", "<Cmd>nohlsearch <bar> silent! AsyncStop!<CR><Cmd>echo<CR>")
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("x", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-w><C-c>", "<Esc>")
vim.keymap.set("n", "<C-w><", "<C-w><<C-w>", { remap = true })
vim.keymap.set("n", "<C-w>>", "<C-w>><C-w>", { remap = true })
vim.keymap.set("n", "<C-w>+", "<C-w>+<C-w>", { remap = true })
vim.keymap.set("n", "<C-w>-", "<C-w>-<C-w>", { remap = true })
vim.keymap.set("n", "<C-f>", "<Cmd>lua require('lsp').organize_imports_and_format()<CR>")
vim.keymap.set("x", "<C-f>", vim.lsp.buf.range_formatting)
vim.keymap.set({ "n", "x", "o" }, "<leader>p", '"0p')
vim.keymap.set({ "n", "x", "o" }, "<leader>P", '"0P')
vim.keymap.set("i", "<leader>r", "<Esc><leader>r", { remap = true })
vim.keymap.set("n", "<leader>r", "<Cmd>execute funcs#get_run_command()<CR>")
vim.keymap.set({ "n", "x", "o" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+y$')
vim.keymap.set("n", "<leader>b", "<Cmd>Neotree reveal<CR>")
vim.keymap.set("n", "<leader>B", "<Cmd>Neotree git_status<CR>")
vim.keymap.set("n", "<leader>n", [[:let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>]], { silent = true })
vim.keymap.set("x", "<leader>n", [["xy:let @/=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>]], { silent = true })
vim.keymap.set("n", "<leader>u", "<Cmd>MundoToggle<CR>")
vim.keymap.set("n", "<leader>v", "<Cmd>AerialToggle<CR>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
vim.keymap.set("x", "<leader>s", [["xy:%s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\r', 'g')<CR>/gc<Left><Left><Left>]])
vim.keymap.set("n", "<leader>l", "<Cmd>call funcs#print_variable(0, 0)<CR>")
vim.keymap.set("x", "<leader>l", ":<C-u>call funcs#print_variable(1, 0)<CR>")
vim.keymap.set("n", "<leader>L", "<Cmd>call funcs#print_variable(0, 1)<CR>")
vim.keymap.set("x", "<leader>L", ":<C-u>call funcs#print_variable(1, 1)<CR>")
vim.keymap.set("n", "<leader>tm", "<Cmd>TableModeToggle<CR>")
vim.keymap.set("i", "<leader>w", "<Esc><Cmd>update<CR>")
vim.keymap.set("n", "<leader>w", "<Cmd>update<CR>")
vim.keymap.set("n", "<leader>W", "<Cmd>wall<CR>")
vim.keymap.set("n", "<leader>q", "<Cmd>call funcs#quit(0, 0)<CR>") -- close window
vim.keymap.set("n", "<leader>Q", "<Cmd>call funcs#quit(0, 1)<CR>") -- close tab
vim.keymap.set("n", "<leader>x", "<Cmd>call funcs#quit(1, 0)<CR>") -- close buffer and preserve layout
vim.keymap.set("n", "<leader>X", "<Cmd>call funcs#quit(1, 1)<CR>") -- force quit
vim.keymap.set("n", "yoq", "empty(filter(getwininfo(), 'v:val.quickfix')) ? '<Cmd>copen<CR>' : '<Cmd>cclose<CR>'", { expr = true })
vim.keymap.set("n", "yol", "empty(filter(getwininfo(), 'v:val.loclist')) ? '<Cmd>lopen<CR>' : '<Cmd>lclose<CR>'", { expr = true })
vim.keymap.set("n", "yof", "winnr('$') > 1 ? '<Cmd>let g:temp = winsaveview() <bar> -tabedit %<CR><Cmd>call winrestview(g:temp) <bar> let b:is_zoomed = 1<CR>' : get(b:, 'is_zoomed', 0) ? '<Cmd>tabclose<CR>' : ''", { expr = true })
vim.keymap.set("c", "<C-Space>", [['/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>']], { expr = true })
vim.keymap.set("c", "<BS>", [['/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>']], { expr = true })
vim.cmd("cnoreabbrev print <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'lua =( )' : 'print')<CR><C-r>=(getcmdtype() == ':' && getcmdline() == 'lua =( )' ? setcmdpos(7)[-1] : '')<CR>") -- vim.pretty_print
-- wilder.nvim {{{2
vim.keymap.set("c", "<Tab>", "'/?' =~ getcmdtype() ? '<C-g>' : wilder#in_context() ? wilder#next() : '<C-z>'", { expr = true }) -- <C-z> is 'wildcharm'
vim.keymap.set("c", "<S-Tab>", "'/?' =~ getcmdtype() ? '<C-t>' : wilder#in_context() ? wilder#previous() : '<S-Tab>'", { expr = true })
-- nvim_bufferline {{{2
vim.keymap.set("n", "<BS>", "<Cmd>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "\\", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<C-w><BS>", "<Cmd>BufferLineMovePrev<CR><C-w>", { remap = true })
vim.keymap.set("n", "<C-w>\\", "<Cmd>BufferLineMoveNext<CR><C-w>", { remap = true })
-- terminal {{{2
vim.keymap.set("n", "<C-b>", "<Cmd>execute 'Ttoggle resize='. min([10, &lines * 2/5])<CR>")
vim.keymap.set("n", "<leader>to", "<Cmd>lua require('rooter').run_without_rooter('Ttoggle resize=' .. math.min(10, vim.o.lines))<CR>")
vim.keymap.set("n", "<leader>tt", "<Cmd>tab Tnew<CR>")
vim.keymap.set("n", "<leader>tO", "<Cmd>Tnew <bar> only<CR>")
vim.keymap.set("n", "<leader>t<C-l>", "<Cmd>Tclear!<CR>")
vim.keymap.set("n", "<leader>te", "<Plug>(neoterm-repl-send)")
vim.keymap.set("n", "<leader>tee", "<Plug>(neoterm-repl-send-line)")
vim.keymap.set("x", "<leader>te", "<Plug>(neoterm-repl-send)")
vim.keymap.set("t", "<C-u>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-b>", "<Cmd>Ttoggle<CR>")
-- quickui {{{2
vim.keymap.set("n", "K", "<Cmd>lua require('plugin-configs').open_quickui_context_menu()<CR>")
vim.keymap.set("n", "<CR>", "<Cmd>call quickui#menu#open('normal')<CR>")
vim.keymap.set("x", "<CR>", "<Esc><Cmd>call quickui#menu#open('visual')<CR>")
vim.keymap.set("n", "<leader>tp", [[<Cmd>call quickui#terminal#open('zsh', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': ''})<CR>]])
vim.keymap.set("n", "<C-o>", [[<Cmd>let g:lf_selection_path = tempname() <bar> call quickui#terminal#open('sh -c "lf -last-dir-path=\"$HOME/.cache/lf_dir\" -selection-path='. fnameescape(g:lf_selection_path). ' \"'. expand('%'). '\""', {'h': &lines - 7, 'w': &columns * 9/10, 'line': 3, 'callback': 'funcs#lf_edit_callback'})<CR>]])
-- kommentary {{{2
vim.keymap.set("n", "gc", "<Plug>kommentary_motion_default")
vim.keymap.set("n", "gcc", "<Plug>kommentary_line_default")
vim.keymap.set("x", "gc", "<Plug>kommentary_visual_default<Esc>")
vim.keymap.set("o", "gc", ":<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>") -- vim-commentary text object
-- visualmulti {{{2
vim.keymap.set("n", "<C-n>", "<Plug>(VM-Find-Under)")
vim.keymap.set("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)")
-- hop {{{2
vim.keymap.set({ "n", "x", "o" }, "'", "<Cmd>lua require('utils').command_without_quickscope('HopChar1')<CR>")
vim.keymap.set({ "n", "x", "o" }, "q", "<Cmd>lua require('utils').command_without_quickscope('HopWord')<CR>")
vim.keymap.set({ "n", "x", "o" }, "<leader>e", "<Cmd>lua require('utils').command_without_quickscope('HopWordCurrentLine')<CR>")
vim.keymap.set({ "n", "x", "o" }, "<leader>j", "<Cmd>lua require('utils').command_without_quickscope('HopLineAC')<CR>")
vim.keymap.set({ "n", "x", "o" }, "<leader>k", "<Cmd>lua require('utils').command_without_quickscope('HopLineBC')<CR>")
-- vim-matchup {{{2
vim.keymap.set("n", "<leader>c", "<Cmd>MatchupWhereAmI<CR>")
-- fanfingtastic {{{2
vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>fanfingtastic_f")
vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>fanfingtastic_F")
vim.keymap.set({ "n", "x", "o" }, "t", "<Plug>fanfingtastic_t")
vim.keymap.set({ "n", "x", "o" }, "T", "<Plug>fanfingtastic_T")
vim.keymap.set({ "n", "x", "o" }, ",", "<Plug>fanfingtastic_;")
vim.keymap.set({ "n", "x", "o" }, ";,", "<Plug>fanfingtastic_,")
-- vim-illuminate {{{2
vim.keymap.set("n", "[m", "<Cmd>lua require('illuminate').next_reference({ wrap = true, reverse = true })<CR>")
vim.keymap.set("n", "]m", "<Cmd>lua require('illuminate').next_reference({ wrap = true })<CR>")
-- wordmotion {{{2
vim.keymap.set({ "n", "x", "o" }, "gw", "<Plug>WordMotion_w")
vim.keymap.set({ "n", "x", "o" }, "gb", "<Plug>WordMotion_b")
vim.keymap.set({ "n", "x", "o" }, "ge", "<Plug>WordMotion_e")
vim.keymap.set("o", "u", "<Plug>WordMotion_w")
vim.keymap.set("o", "iu", "<Plug>WordMotion_iw")
vim.keymap.set("x", "iu", "<Plug>WordMotion_iw")
vim.keymap.set("o", "au", "<Plug>WordMotion_aw")
vim.keymap.set("x", "au", "<Plug>WordMotion_aw")
-- sandwich {{{2
vim.keymap.set("n", "ys", "<Plug>(operator-sandwich-add)")
vim.keymap.set("n", "yss", "<Plug>(operator-sandwich-add)iw")
vim.keymap.set("n", "yS", "<Plug>(operator-sandwich-add)g_")
vim.keymap.set("n", "ds", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)")
vim.keymap.set("n", "dss", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
vim.keymap.set("n", "cs", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)")
vim.keymap.set("n", "css", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
vim.keymap.set("x", "s", "<Plug>(operator-sandwich-add)")
vim.keymap.set("x", "s<", "<Plug>(operator-sandwich-add)t")
-- vim-swap {{{2
vim.keymap.set("o", "ia", "<Plug>(swap-textobject-i)")
vim.keymap.set("x", "ia", "<Plug>(swap-textobject-i)")
vim.keymap.set("o", "aa", "<Plug>(swap-textobject-a)")
vim.keymap.set("x", "aa", "<Plug>(swap-textobject-a)")
vim.keymap.set("n", "g<", "<Plug>(swap-prev)")
vim.keymap.set("n", "g>", "<Plug>(swap-next)")
vim.keymap.set("n", "gs", "<Plug>(swap-interactive)")
vim.keymap.set("x", "gs", "<Plug>(swap-interactive)")
-- tmux-navigator {{{2
vim.keymap.set("n", "<M-h>", "<Cmd>lua require('tmux').resize_left()<CR>")
vim.keymap.set("n", "<M-j>", "<Cmd>lua require('tmux').resize_bottom()<CR>")
vim.keymap.set("n", "<M-k>", "<Cmd>lua require('tmux').resize_top()<CR>")
vim.keymap.set("n", "<M-l>", "<Cmd>lua require('tmux').resize_right()<CR>")
vim.keymap.set("t", "<M-h>", "<Cmd>lua require('tmux').resize_left()<CR>")
vim.keymap.set("t", "<M-j>", "<Cmd>lua require('tmux').resize_bottom()<CR>")
vim.keymap.set("t", "<M-k>", "<Cmd>lua require('tmux').resize_top()<CR>")
vim.keymap.set("t", "<M-l>", "<Cmd>lua require('tmux').resize_right()<CR>")
vim.keymap.set("n", "<C-h>", "<Cmd>lua require('tmux').move_left()<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>lua require('tmux').move_bottom()<CR>")
vim.keymap.set("n", "<C-k>", "<Cmd>lua require('tmux').move_top()<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>lua require('tmux').move_right()<CR>")
vim.keymap.set("t", "<C-h>", "<Cmd>lua require('tmux').move_left()<CR>")
vim.keymap.set("t", "<C-j>", "<Cmd>lua require('tmux').move_bottom()<CR>")
vim.keymap.set("t", "<C-k>", "<Cmd>lua require('tmux').move_top()<CR>")
vim.keymap.set("t", "<C-l>", "<Cmd>lua require('tmux').move_right()<CR>")
-- telescope {{{2
vim.keymap.set("n", "<C-p>", "<Cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>")
vim.keymap.set("n", "<leader>fs", "<C-p>", { remap = true })
vim.keymap.set("n", "<leader>fm", "<Cmd>lua require('telescope.builtin').oldfiles({include_current_session = true})<CR>")
vim.keymap.set("n", "<leader>fM", "<Cmd>lua require('telescope.builtin').jumplist({initial_mode = 'normal'})<CR>")
vim.keymap.set("n", "<leader>fb", "<Cmd>lua require('telescope.builtin').buffers({initial_mode = 'normal'})<CR>")
vim.keymap.set("n", "<leader>fu", "<Cmd>lua require('telescope.builtin')[require('lsp').is_active() and 'lsp_document_symbols' or 'treesitter']()<CR>")
vim.keymap.set("n", "<leader>fU", "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>")
vim.keymap.set("n", "<leader>fg", ":GrepRegex ")
vim.keymap.set("x", "<leader>fg", ":<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR>")
vim.keymap.set("n", "<leader>fG", "<Cmd>lua require('telescope.builtin').resume({initial_mode = 'normal'})<CR>")
vim.keymap.set("n", "<leader>fj", ":GrepRegex \\b<C-r>=expand('<cword>')<CR>\\b<CR>")
vim.keymap.set("x", "<leader>fj", ":<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>")
vim.keymap.set("n", "<leader>fq", "<Cmd>lua require('telescope.builtin').quickfix()<CR>")
vim.keymap.set("n", "<leader>fl", "<Cmd>lua require('telescope.builtin').loclist()<CR>")
vim.keymap.set("n", "<leader>fL", "<Cmd>lua require('telescope.builtin').live_grep()<CR>")
vim.keymap.set("n", "<leader>fa", "<Cmd>lua require('telescope.builtin').commands()<CR>")
vim.keymap.set("n", "<leader>ft", "<Cmd>lua require('telescope.builtin').filetypes()<CR>")
vim.keymap.set("n", "<leader>ff", "<Cmd>lua require('telescope.builtin').builtin()<CR>")
vim.keymap.set("n", "<leader>f/", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
vim.keymap.set("n", "<leader>fr", "<Cmd>lua require('telescope.builtin').registers()<CR>")
vim.keymap.set("n", "<leader>fh", "<Cmd>lua require('telescope.builtin').command_history()<CR>")
vim.keymap.set("n", "<leader>fy", "<Cmd>lua require('packer').loader('nvim-neoclip.lua')<CR><Cmd>lua require('telescope').extensions.neoclip.default({initial_mode = 'normal'})<CR>")
-- lsp {{{2
vim.keymap.set("n", "gd", "<Cmd>lua if require('lsp').is_active() then vim.lsp.buf.definition() else vim.cmd('normal! gd') end<CR>")
vim.keymap.set("n", "gD", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>d", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>a", "<Cmd>CodeActionMenu<CR>")
vim.keymap.set("x", "<leader>a", ":<C-u>CodeActionMenu<CR>")
vim.keymap.set("n", "gh", "<Cmd>lua if vim.diagnostic.open_float(0, {scope = 'cursor', border = 'rounded'}) == nil then vim.lsp.buf.hover() end<CR>")
vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename)
vim.keymap.set("n", "[a", "<Cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded'}})<CR>")
vim.keymap.set("n", "]a", "<Cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded'}})<CR>")
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)

-- autocmds {{{1
vim.api.nvim_create_augroup("AutoCommands", {})
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    group = "AutoCommands",
    command = "if !exists('w:SavedBufView') | let w:SavedBufView = {} | endif | let w:SavedBufView[bufnr()] = winsaveview()",
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = "AutoCommands",
    command = "let b:SavedBufnr = bufnr() | if exists('w:SavedBufView') && has_key(w:SavedBufView, b:SavedBufnr) | let b:SavedBufView = winsaveview() | if b:SavedBufView.lnum == 1 && b:SavedBufView.col == 0 && !&diff | call winrestview(w:SavedBufView[b:SavedBufnr]) | endif | unlet w:SavedBufView[b:SavedBufnr] | endif",
})
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    group = "AutoCommands",
    command = [[if !exists('b:RestoredCursor') && line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif | let b:RestoredCursor = 1]],
})
vim.api.nvim_create_autocmd("BufWritePost", { pattern = "*/lua/plugins.lua", group = "AutoCommands", command = "source <afile> | PackerCompile" })
vim.api.nvim_create_autocmd("User", { pattern = "PackerCompileDone", group = "AutoCommands", command = "PackerInstall" })
vim.api.nvim_create_autocmd("TextYankPost", { pattern = "*", group = "AutoCommands", callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 }) end })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.http", group = "AutoCommands", command = "set filetype=http commentstring=#\\ %s" })
vim.api.nvim_create_autocmd("FileType", { pattern = "*", group = "AutoCommands", command = "setlocal formatoptions=jql" })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    group = "AutoCommands",
    callback = function()
        vim.bo.bufhidden = "wipe"
        vim.keymap.set("n", "h", "[[<CR>^", { remap = true, buffer = true })
        vim.keymap.set("n", "l", "<CR>", { remap = true, buffer = true })
        vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true })
        vim.keymap.set("n", "q", "<Cmd>call funcs#quit_netrw_and_dirs()<CR>", { buffer = true, nowait = true })
        vim.keymap.set("n", "<leader>q", "q", { remap = true, buffer = true })
    end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "quickfix",
    group = "AutoCommands",
    callback = function()
        vim.bo.buflisted = false
        vim.bo.modifiable = true
        vim.keymap.set("n", "<leader>w", [[<Cmd>let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> silent! bdelete! <bar> copen<CR>]], { buffer = true })
        vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
    end,
})
vim.api.nvim_create_autocmd("CmdwinEnter", { pattern = "*", group = "AutoCommands", callback = function() vim.keymap.set("n", "<CR>", "<CR>", { buffer = true }) end })
vim.api.nvim_create_autocmd("BufEnter", { pattern = "term://*", group = "AutoCommands", command = [[if line('$') <= line('w$') && len(filter(getline(line('.') + 1, '$'), 'v:val != ""')) == 0 | startinsert | endif]] })
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", group = "AutoCommands", callback = require("rooter").root })
vim.api.nvim_create_autocmd("User", {
    pattern = "FugitiveIndex",
    group = "AutoCommands",
    callback = function() vim.keymap.set("n", "dt", ":Gtabedit <Plug><cfile><bar>Gdiffsplit! @<CR>", { silent = true, buffer = true }) end,
})

-- commands {{{1
vim.api.nvim_create_user_command("SetRunCommand", "let b:RunCommand = <q-args>", { complete = "file", nargs = "*" })
vim.api.nvim_create_user_command("SetArgs", "let b:args = <q-args> == '' ? '' : ' '. <q-args>", { complete = "file", nargs = "*" })
vim.api.nvim_create_user_command("S", [[execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr(). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | else | execute "put =execute('". <q-args>. "')" | endif | 1d]], { complete = "command", nargs = "*", range = true, bang = true })
vim.api.nvim_create_user_command("W", [[call mkdir(expand('%:p:h'), 'p') | if '<bang>' == '' | execute 'write !sudo tee % > /dev/null' | else | %yank | vnew | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | 0put='Enter password in terminal and press <lt>C-u>pa<lt>Esc>;w' | wincmd p | execute 'lua require("packer").loader("neoterm")' | execute "botright T sudo vim +'set paste' +'1,$d' +startinsert %" | endif]], { bang = true })
vim.api.nvim_create_user_command("Grt", [[execute 'lua require("packer").loader("vim-fugitive")' | Gcd]], {})
vim.api.nvim_create_user_command("SessionSave", "silent! ScrollViewDisable | mksession! ~/.cache/nvim/session.vim | silent! ScrollViewEnable | lua vim.notify('Session saved to ~/.cache/nvim/session.vim')", {})
vim.api.nvim_create_user_command("SessionLoad", "source ~/.cache/nvim/session.vim | lua vim.notify('Loaded session from ~/.cache/nvim/session.vim')", {})
vim.api.nvim_create_user_command("GrepRegex", "lua require('telescope.builtin').grep_string({path_display = {'smart'}, use_regex = true, search = <q-args>, initial_mode = 'normal'})", { nargs = "*" })
vim.api.nvim_create_user_command("GrepNoRegex", "lua require('telescope.builtin').grep_string({path_display = {'smart'}, search = <q-args>, initial_mode = 'normal'})", { nargs = "*" })
vim.api.nvim_create_user_command("Untildone", "lua require('utils').untildone(<q-args>, '<bang>')", { complete = "shellcmd", nargs = "*", bang = true })
vim.api.nvim_create_user_command("LspInstallAll", "lua require('lsp').lsp_install_all()", {})

-- overrides {{{1
if vim.fn.glob(vim.fn.stdpath("config") .. "/lua/packer_compiled.lua") == "" then
    require("plugins").compile()
else
    vim.api.nvim_create_user_command("PackerStatus", function() require("plugins").status() end, {})
    vim.api.nvim_create_user_command("PackerInstall", function() require("plugins").install() end, {})
    vim.api.nvim_create_user_command("PackerUpdate", function() require("plugins").update() end, {})
    vim.api.nvim_create_user_command("PackerSync", function() require("plugins").sync() end, {})
    vim.api.nvim_create_user_command("PackerClean", function() require("plugins").clean() end, {})
    vim.api.nvim_create_user_command("PackerCompile", function() require("plugins").compile() end, {})
    vim.api.nvim_create_user_command("PackerStatus", function() require("plugins").status() end, {})
    vim.api.nvim_create_user_command("PackerLoad", function(args) require('plugins').loader(args.fargs, args.bang) end, {
        bang = true,
        nargs = "+",
        complete = "customlist,v:lua.require'packer'.loader_complete",
    })
    require("packer_compiled")
end
vim.notify = function(...)
    require("packer").loader("nvim-notify")
    vim.notify = require("notify")
    vim.notify(...)
end
vim.paste = (function(overridden)
    return function(lines, phase) -- break undo before pasting in insert mode
        if (phase == -1 or phase == 1) and vim.fn.mode() == "i" and not vim.o.paste then
            vim.cmd("let &undolevels = &undolevels") -- resetting undolevels breaks undo
        end
        overridden(lines, phase)
    end
end)(vim.paste)
if vim.env.SSH_CLIENT ~= nil then -- ssh session
    vim.fn["funcs#map_copy_with_osc_yank"]()
    vim.keymap.set("n", "gx", "<Cmd>let @x = expand('<cfile>') <bar> OSCYankReg x<CR>")
elseif vim.fn.has("macunix") ~= 1 then -- WSL Vim
    vim.fn["funcs#map_copy_to_win_clip"]()
end

-- delayed plugins {{{1
if require("states").small_file then
    vim.schedule(function()
        vim.defer_fn(function()
            local plugins = {
                "nvim-treesitter",
                "nvim-treesitter-textobjects",
                "plenary.nvim",
                "vim-illuminate",
                "nvim-lsp-installer",
            }
            require("packer").loader(table.concat(plugins, " "))
        end, 30)
        vim.defer_fn(function()
            local plugins = {
                "indent-blankline.nvim",
                "nvim-scrollview",
                "gitsigns.nvim",
                "conflict-marker.vim",
                "vim-sleuth",
                "quick-scope",
                "vim-wordmotion", -- motions/text objects sometimes don't work if loaded on keys
                "vim-sandwich",
                "vim-fanfingtastic",
                "vim-matchup",
            }
            require("packer").loader(table.concat(plugins, " "))
        end, 100)
    end)
end
-- vim:foldmethod=marker
