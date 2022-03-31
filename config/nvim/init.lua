-- options {{{1
require("states") --                   lua/states.lua
vim.g.loaded_matchparen = 1 --         lua/utils.lua
vim.g.loaded_matchit = 1 --            lua/themes.lua
vim.g.loaded_2html_plugin = 1 --       lua/plugins.lua
vim.g.loaded_remote_plugins = 1 --     lua/plugin-configs.lua
vim.g.loaded_tutor_mode_plugin = 1 --  lua/lsp.lua
vim.g.mapleader = ";" --               lua/rooter.lua
vim.g.maplocalleader = "|" --          ginit.vim
vim.g.netrw_dirhistmax = 0 --          plugin/init.vim
vim.g.netrw_banner = 0 --              autoload/funcs.vim
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
vim.opt.completeopt = { "menuone", "noselect" }
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
local function map(mode, lhs, rhs, opts)
    opts = opts or { noremap = true }
    if mode == "" then -- to not map select mode for snippets
        vim.api.nvim_set_keymap("n", lhs, rhs, opts)
        vim.api.nvim_set_keymap("x", lhs, rhs, opts)
        vim.api.nvim_set_keymap("o", lhs, rhs, opts)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end

-- text objects {{{2
local text_objects = { "<Space>", "_", ".", ":", ",", ";", "<bar>", "/", "<bslash>", "*", "+", "-", "#", "=", "&" }
for _, char in ipairs(text_objects) do
    map("x", "i" .. char, ":<C-u>normal! T" .. char .. "vt" .. char .. "<CR>", { noremap = true, silent = true })
    map("o", "i" .. char, "<Cmd>normal vi" .. char .. "<CR>", { noremap = true, silent = true })
    map("x", "a" .. char, ":<C-u>normal! F" .. char .. "vt" .. char .. "<CR>", { noremap = true, silent = true })
    map("o", "a" .. char, "<Cmd>normal va" .. char .. "<CR>", { noremap = true, silent = true })
end
map("x", "il", "^og_")
map("o", "il", "<Cmd>normal vil<CR>")
map("x", "al", "0o$")
map("o", "al", "<Cmd>normal val<CR>")
map("x", "ii", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { noremap = true, silent = true })
map("o", "ii", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]], { noremap = true, silent = true })
map("x", "ai", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { noremap = true, silent = true })
map("o", "ai", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]], { noremap = true, silent = true })
map("x", "iI", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { noremap = true, silent = true })
map("o", "iI", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]], { noremap = true, silent = true })
map("x", "aI", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { noremap = true, silent = true })
map("o", "aI", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]], { noremap = true, silent = true })
map("x", "v", ":<C-u>call plugins#expand_region#next('v', '+')<CR>", { noremap = true, silent = true })
map("x", "<BS>", ":<C-u>call plugins#expand_region#next('v', '-')<CR>", { noremap = true, silent = true })
-- general {{{2
map("n", "[\\", "<Cmd>tabedit<CR>")
map("n", "]\\", "<Cmd>enew<CR>")
map("", "0", "funcs#home()", { expr = true, noremap = true })
map("", "^", "0")
map("n", "-", "$") -- $ in normal mode will always put cursor at last column when scrolling, g_ will not
map("o", "-", "$")
map("x", "-", "g_")
map("", "g-", "g$")
map("", "<Home>", "g^")
map("", "<End>", "g$")
map("", "<Down>", "gj")
map("", "<Up>", "gk")
map("!", "<S-Del>", "<BS>")
map("i", "<Down>", "pumvisible() ? '<C-n>' : '<C-o>gj'", { expr = true, noremap = true })
map("i", "<Up>", "pumvisible() ? '<C-p>' : '<C-o>gk'", { expr = true, noremap = true })
map("i", "<Home>", "<C-o>g^")
map("i", "<End>", "<C-o>g$")
map("i", "<C-_>", "<C-o>u")
map("n", "_", "<C-o>")
map("n", "+", "<C-i>")
map("n", "Q", "q")
map("x", "@q", "<Cmd>normal! @q<CR>")
map("x", "@@", "<Cmd>normal! @@<CR>")
map("n", "U", "<Cmd>execute 'earlier '. v:count1. 'f'<CR>")
map("x", "<", "<gv")
map("x", ">", ">gv")
map("n", "gp", "`[v`]")
map("n", "zm", "<Cmd>%foldclose<CR>")
map("n", "cr", "<Cmd>call funcs#edit_register()<CR>")
map("n", "Z[", "<Cmd>BufferLineCloseLeft<CR>")
map("n", "Z]", "<Cmd>BufferLineCloseRight<CR>")
map("n", "gx", "<Cmd>call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>")
map("x", "gx", ":<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>")
map("n", "<C-c>", "<Cmd>nohlsearch <bar> silent! AsyncStop!<CR><Cmd>echo<CR>")
map("i", "<C-c>", "<Esc>")
map("x", "<C-c>", "<Esc>")
map("n", "<C-w><C-c>", "<Esc>")
map("n", "<C-w><", "<C-w><<C-w>", {})
map("n", "<C-w>>", "<C-w>><C-w>", {})
map("n", "<C-w>+", "<C-w>+<C-w>", {})
map("n", "<C-w>-", "<C-w>-<C-w>", {})
map("n", "<C-f>", "<Cmd>lua require('lsp').organize_imports_and_format()<CR>")
map("x", "<C-f>", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>")
map("", "<leader>p", '"0p')
map("", "<leader>P", '"0P')
map("i", "<leader>r", "<Esc><leader>r", {})
map("n", "<leader>r", "<Cmd>execute funcs#get_run_command()<CR>")
map("", "<leader>y", '"+y')
map("n", "<leader>Y", '"+y$')
map("n", "<leader>b", "<Cmd>Neotree reveal<CR>")
map("n", "<leader>B", "<Cmd>Neotree git_status<CR>")
map("n", "<leader>n", [[:let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>]], { noremap = true, silent = true })
map("x", "<leader>n", [["xy:let @/=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>]], { noremap = true, silent = true })
map("n", "<leader>u", "<Cmd>MundoToggle<CR>")
map("n", "<leader>v", "<Cmd>AerialToggle<CR>")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
map("x", "<leader>s", [["xy:%s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\r', 'g')<CR>/gc<Left><Left><Left>]])
map("n", "<leader>l", "<Cmd>call funcs#print_variable(0, 0)<CR>")
map("x", "<leader>l", ":<C-u>call funcs#print_variable(1, 0)<CR>")
map("n", "<leader>L", "<Cmd>call funcs#print_variable(0, 1)<CR>")
map("x", "<leader>L", ":<C-u>call funcs#print_variable(1, 1)<CR>")
map("n", "<leader>tm", "<Cmd>TableModeToggle<CR>")
map("i", "<leader>w", "<Esc><Cmd>update<CR>")
map("n", "<leader>w", "<Cmd>update<CR>")
map("n", "<leader>W", "<Cmd>wall<CR>")
map("n", "<leader>q", "<Cmd>call funcs#quit(0, 0)<CR>") -- close window
map("n", "<leader>Q", "<Cmd>call funcs#quit(0, 1)<CR>") -- close tab
map("n", "<leader>x", "<Cmd>call funcs#quit(1, 0)<CR>") -- close buffer and preserve layout
map("n", "<leader>X", "<Cmd>call funcs#quit(1, 1)<CR>") -- force quit
map("n", "yoq", "empty(filter(getwininfo(), 'v:val.quickfix')) ? '<Cmd>copen<CR>' : '<Cmd>cclose<CR>'", { expr = true, noremap = true })
map("n", "yol", "empty(filter(getwininfo(), 'v:val.loclist')) ? '<Cmd>lopen<CR>' : '<Cmd>lclose<CR>'", { expr = true, noremap = true })
map("n", "yof", "winnr('$') > 1 ? '<Cmd>let g:temp = winsaveview() <bar> -tabedit %<CR><Cmd>call winrestview(g:temp) <bar> let b:is_zoomed = 1<CR>' : get(b:, 'is_zoomed', 0) ? '<Cmd>tabclose<CR>' : ''", { expr = true, noremap = true })
map("c", "<C-Space>", [['/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>']], { expr = true, noremap = true })
map("c", "<BS>", [['/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>']], { expr = true, noremap = true })
-- wilder.nvim {{{2
map("c", "<Tab>", "'/?' =~ getcmdtype() ? '<C-g>' : wilder#in_context() ? wilder#next() : '<C-z>'", { expr = true, noremap = true }) -- <C-z> is 'wildcharm'
map("c", "<S-Tab>", "'/?' =~ getcmdtype() ? '<C-t>' : wilder#in_context() ? wilder#previous() : '<S-Tab>'", { expr = true, noremap = true })
-- nvim_bufferline {{{2
map("n", "<BS>", "<Cmd>BufferLineCyclePrev<CR>")
map("n", "\\", "<Cmd>BufferLineCycleNext<CR>")
map("n", "<C-w><BS>", "<Cmd>BufferLineMovePrev<CR><C-w>", {})
map("n", "<C-w>\\", "<Cmd>BufferLineMoveNext<CR><C-w>", {})
-- terminal {{{2
map("n", "<C-b>", "<Cmd>execute 'Ttoggle resize='. min([10, &lines * 2/5])<CR>")
map("n", "<leader>to", "<Cmd>lua require('rooter').run_without_rooter('Ttoggle resize=' .. math.min(10, vim.o.lines))<CR>")
map("n", "<leader>tt", "<Cmd>tab Tnew<CR>")
map("n", "<leader>tO", "<Cmd>Tnew <bar> only<CR>")
map("n", "<leader>t<C-l>", "<Cmd>Tclear!<CR>")
map("n", "<leader>te", "<Plug>(neoterm-repl-send)", {})
map("n", "<leader>tee", "<Plug>(neoterm-repl-send-line)", {})
map("x", "<leader>te", "<Plug>(neoterm-repl-send)", {})
map("t", "<C-u>", "<C-\\><C-n>")
map("t", "<C-b>", "<Cmd>Ttoggle<CR>")
-- quickui {{{2
map("n", "K", "<Cmd>lua require('plugin-configs').open_quickui_context_menu()<CR>")
map("n", "<CR>", "<Cmd>call quickui#menu#open('normal')<CR>")
map("x", "<CR>", "<Esc><Cmd>call quickui#menu#open('visual')<CR>")
map("n", "<leader>tp", [[<Cmd>call quickui#terminal#open('zsh', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': ''})<CR>]])
map("n", "<C-o>", [[<Cmd>let g:lf_selection_path = tempname() <bar> call quickui#terminal#open('sh -c "lf -last-dir-path=\"$HOME/.cache/lf_dir\" -selection-path='. fnameescape(g:lf_selection_path). ' \"'. expand('%'). '\""', {'h': &lines - 7, 'w': &columns * 9/10, 'line': 3, 'callback': 'funcs#lf_edit_callback'})<CR>]])
-- kommentary {{{2
map("n", "gc", "<Plug>kommentary_motion_default", {})
map("n", "gcc", "<Plug>kommentary_line_default", {})
map("x", "gc", "<Plug>kommentary_visual_default<Esc>", {})
map("o", "gc", ":<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>") -- vim-commentary text object
-- visualmulti {{{2
map("n", "<C-n>", "<Plug>(VM-Find-Under)", {})
map("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", {})
-- hop {{{2
map("", "'", "<Cmd>lua require('utils').command_without_quickscope('HopChar1')<CR>")
map("", "q", "<Cmd>lua require('utils').command_without_quickscope('HopWord')<CR>")
map("", "<leader>e", "<Cmd>lua require('utils').command_without_quickscope('HopWordCurrentLine')<CR>")
map("", "<leader>j", "<Cmd>lua require('utils').command_without_quickscope('HopLineAC')<CR>")
map("", "<leader>k", "<Cmd>lua require('utils').command_without_quickscope('HopLineBC')<CR>")
-- vim-matchup {{{2
map("n", "<leader>c", "<Cmd>MatchupWhereAmI<CR>", {})
-- fanfingtastic {{{2
map("", "f", "<Plug>fanfingtastic_f", {})
map("", "F", "<Plug>fanfingtastic_F", {})
map("", "t", "<Plug>fanfingtastic_t", {})
map("", "T", "<Plug>fanfingtastic_T", {})
map("", ",", "<Plug>fanfingtastic_;", {})
map("", ";,", "<Plug>fanfingtastic_,", {})
-- vim-illuminate {{{2
map("n", "[m", "<Cmd>lua require('illuminate').next_reference({ wrap = true, reverse = true })<CR>")
map("n", "]m", "<Cmd>lua require('illuminate').next_reference({ wrap = true })<CR>")
-- wordmotion {{{2
map("", "gw", "<Plug>WordMotion_w", {})
map("", "gb", "<Plug>WordMotion_b", {})
map("", "ge", "<Plug>WordMotion_e", {})
map("o", "u", "<Plug>WordMotion_w", {})
map("o", "iu", "<Plug>WordMotion_iw", {})
map("x", "iu", "<Plug>WordMotion_iw", {})
map("o", "au", "<Plug>WordMotion_aw", {})
map("x", "au", "<Plug>WordMotion_aw", {})
-- sandwich {{{2
map("n", "ys", "<Plug>(operator-sandwich-add)", {})
map("n", "yss", "<Plug>(operator-sandwich-add)iw", {})
map("n", "yS", "ysg_", {})
map("n", "ds", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", {})
map("n", "dss", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", {})
map("n", "cs", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", {})
map("n", "css", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", {})
map("x", "s", "<Plug>(operator-sandwich-add)", {})
map("x", "s<", "<Plug>(operator-sandwich-add)t", {})
-- vim-swap {{{2
map("o", "ia", "<Plug>(swap-textobject-i)", {})
map("x", "ia", "<Plug>(swap-textobject-i)", {})
map("o", "aa", "<Plug>(swap-textobject-a)", {})
map("x", "aa", "<Plug>(swap-textobject-a)", {})
map("n", "g<", "<Plug>(swap-prev)", {})
map("n", "g>", "<Plug>(swap-next)", {})
map("n", "gs", "<Plug>(swap-interactive)", {})
map("x", "gs", "<Plug>(swap-interactive)", {})
-- tmux-navigator {{{2
map("n", "<M-h>", "<Cmd>lua require('tmux').resize_left()<CR>")
map("n", "<M-j>", "<Cmd>lua require('tmux').resize_bottom()<CR>")
map("n", "<M-k>", "<Cmd>lua require('tmux').resize_top()<CR>")
map("n", "<M-l>", "<Cmd>lua require('tmux').resize_right()<CR>")
map("t", "<M-h>", "<Cmd>lua require('tmux').resize_left()<CR>")
map("t", "<M-j>", "<Cmd>lua require('tmux').resize_bottom()<CR>")
map("t", "<M-k>", "<Cmd>lua require('tmux').resize_top()<CR>")
map("t", "<M-l>", "<Cmd>lua require('tmux').resize_right()<CR>")
map("n", "<C-h>", "<Cmd>lua require('tmux').move_left()<CR>")
map("n", "<C-j>", "<Cmd>lua require('tmux').move_bottom()<CR>")
map("n", "<C-k>", "<Cmd>lua require('tmux').move_top()<CR>")
map("n", "<C-l>", "<Cmd>lua require('tmux').move_right()<CR>")
map("t", "<C-h>", "<Cmd>lua require('tmux').move_left()<CR>")
map("t", "<C-j>", "<Cmd>lua require('tmux').move_bottom()<CR>")
map("t", "<C-k>", "<Cmd>lua require('tmux').move_top()<CR>")
map("t", "<C-l>", "<Cmd>lua require('tmux').move_right()<CR>")
-- telescope {{{2
map("n", "<C-p>", "<Cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>")
map("n", "<leader>fs", "<C-p>", {})
map("n", "<leader>fm", "<Cmd>lua require('telescope.builtin').oldfiles({include_current_session = true})<CR>")
map("n", "<leader>fM", "<Cmd>lua require('telescope.builtin').jumplist({initial_mode = 'normal'})<CR>")
map("n", "<leader>fb", "<Cmd>lua require('telescope.builtin').buffers({initial_mode = 'normal'})<CR>")
map("n", "<leader>fu", "<Cmd>lua require('telescope.builtin')[require('lsp').is_active() and 'lsp_document_symbols' or 'treesitter']()<CR>")
map("n", "<leader>fU", "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>")
map("n", "<leader>fg", ":GrepRegex ")
map("x", "<leader>fg", ":<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR>")
map("n", "<leader>fG", "<Cmd>lua require('telescope.builtin').resume({initial_mode = 'normal'})<CR>")
map("n", "<leader>fj", ":GrepRegex \\b<C-r>=expand('<cword>')<CR>\\b<CR>")
map("x", "<leader>fj", ":<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>")
map("n", "<leader>fq", "<Cmd>lua require('telescope.builtin').quickfix()<CR>")
map("n", "<leader>fl", "<Cmd>lua require('telescope.builtin').loclist()<CR>")
map("n", "<leader>fL", "<Cmd>lua require('telescope.builtin').live_grep()<CR>")
map("n", "<leader>fa", "<Cmd>lua require('telescope.builtin').commands()<CR>")
map("n", "<leader>ft", "<Cmd>lua require('telescope.builtin').filetypes()<CR>")
map("n", "<leader>ff", "<Cmd>lua require('telescope.builtin').builtin()<CR>")
map("n", "<leader>f/", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
map("n", "<leader>fr", "<Cmd>lua require('telescope.builtin').registers()<CR>")
map("n", "<leader>fh", "<Cmd>lua require('telescope.builtin').command_history()<CR>")
map("n", "<leader>fy", "<Cmd>lua require('packer').loader('nvim-neoclip.lua')<CR><Cmd>lua require('telescope').extensions.neoclip.default({initial_mode = 'normal'})<CR>")
-- lsp {{{2
map("n", "gd", "<Cmd>lua if require('lsp').is_active() then vim.lsp.buf.definition() else vim.cmd('normal! gd') end<CR>")
map("n", "gD", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
map("n", "<leader>d", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<leader>a", "<Cmd>CodeActionMenu<CR>")
map("x", "<leader>a", ":<C-u>CodeActionMenu<CR>")
map("n", "gh", "<Cmd>lua if vim.diagnostic.open_float(0, {scope = 'cursor', border = 'rounded'}) == nil then vim.lsp.buf.hover() end<CR>")
map("n", "<leader>R", "<Cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "[a", "<Cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded'}})<CR>")
map("n", "]a", "<Cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded'}})<CR>")
map("i", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")

-- overrides {{{1
if vim.fn.glob(vim.fn.stdpath("config") .. "/lua/packer_compiled.lua") == "" then
    require("plugins").compile()
else
    vim.cmd([[
        command! PackerInstall lua require('plugins').install()
        command! PackerUpdate lua require('plugins').update()
        command! PackerSync lua require('plugins').sync()
        command! PackerClean lua require('plugins').clean()
        command! PackerCompile lua require('plugins').compile()
        command! PackerStatus lua require('plugins').status()
        command! -bang -nargs=+ -complete=customlist,v:lua.require('packer').loader_complete PackerLoad lua require('packer').loader(<f-args>, '<bang>' == '!')
    ]])
    require("packer_compiled")
end
vim.notify = function(...)
    require("packer").loader("nvim-notify")
    vim.notify = require("notify")
    vim.notify(...)
end
vim.paste = (function(overridden)
    return function(lines, phase)
        if (phase == -1 or phase == 1) and vim.fn.mode() == "i" and not vim.o.paste then
            vim.cmd("let &undolevels = &undolevels") -- resetting undolevels breaks undo
        end
        overridden(lines, phase)
    end
end)(vim.paste)
if vim.env.SSH_CLIENT ~= nil then -- ssh session
    vim.fn["funcs#map_copy_with_osc_yank"]()
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
