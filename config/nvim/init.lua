-- options {{{1
require("states") --                   lua/states.lua       plugins/appearance.lua
vim.g.loaded_2html_plugin = 1 --       lua/utils.lua        plugins/completion.lua
vim.g.loaded_remote_plugins = 1 --     lua/themes.lua       plugins/editing.lua
vim.g.loaded_tutor_mode_plugin = 1 --  lua/lsp.lua          plugins/git.lua
vim.g.mapleader = ";" --               lua/rooter.lua       plugins/lang.lua
vim.g.maplocalleader = "|" --          ginit.vim            plugins/misc.lua
vim.g.netrw_dirhistmax = 0 --          autoload/funcs.vim   plugins/ui.lua
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.markdown_fenced_languages = { "javascript", "js=javascript", "css", "html", "python", "java", "c", "bash=sh" }
vim.o.whichwrap = "<,>,[,]"
vim.o.termguicolors = true
vim.o.mouse = "a"
vim.o.cursorline = true
vim.o.numberwidth = 2
vim.o.number = true
vim.o.linebreak = true
vim.o.showmatch = true
vim.o.showmode = false
vim.o.diffopt = vim.o.diffopt .. ",vertical,indent-heuristic,algorithm:patience" -- TODO(0.9) https://github.com/neovim/neovim/pull/14537
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.complete = ".,w,b,u"
vim.o.completeopt = "menuone,noselect"
vim.o.completefunc = "funcs#complete_word"
vim.o.shortmess = vim.o.shortmess .. "cAS"
vim.o.spellsuggest = vim.o.spellsuggest .. ",10"
vim.o.scrolloff = 2
vim.o.sidescrolloff = 5
vim.o.signcolumn = "yes"
vim.o.virtualedit = "block"
vim.o.previewheight = 7
vim.o.foldlevel = 99
vim.o.jumpoptions = "view"
vim.o.shada = "!,'1000,<50,s10,/20,@20,h"
vim.o.undofile = true
vim.o.isfname = vim.o.isfname:gsub(",=", "")
vim.o.path = ".,,**5"
vim.o.list = true
vim.o.listchars = "tab:» ,nbsp:␣,trail:•"
vim.o.timeoutlen = 1500
vim.o.ttimeoutlen = 40
vim.o.synmaxcol = 1000
vim.o.lazyredraw = true
vim.o.writebackup = false
vim.o.wildcharm = 26 -- <C-z>
vim.o.grepprg = "rg --vimgrep"
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m,%f"
vim.o.cedit = "<C-x>"

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
vim.keymap.set("x", "ae", "GoggV")
vim.keymap.set("o", "ae", "<Cmd>normal vae<CR>")
vim.keymap.set("x", "af", "iw%")
vim.keymap.set("o", "af", "<Cmd>normal vaf<CR>")
vim.keymap.set("x", "ii", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "ii", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("x", "ai", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "ai", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("x", "iI", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "iI", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("x", "aI", [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]], { silent = true })
vim.keymap.set("o", "aI", [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]], { silent = true })
vim.keymap.set("n", "gw", "<Cmd>call plugins#wordmotion#motion(v:count1, 'n', 'w', 0, [])<CR>", { silent = true })
vim.keymap.set("x", "gw", ":<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'w', 0, [])<CR>", { silent = true })
vim.keymap.set("o", "gw", "<Cmd>call plugins#wordmotion#motion(v:count1, 'o', 'w', 0, [])<CR>", { silent = true })
vim.keymap.set("n", "gb", "<Cmd>call plugins#wordmotion#motion(v:count1, 'n', 'b', 0, [])<CR>", { silent = true })
vim.keymap.set("x", "gb", ":<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'b', 0, [])<CR>", { silent = true })
vim.keymap.set("o", "gb", "<Cmd>call plugins#wordmotion#motion(v:count1, 'o', 'b', 0, [])<CR>", { silent = true })
vim.keymap.set("n", "ge", "<Cmd>call plugins#wordmotion#motion(v:count1, 'n', 'e', 0, [])<CR>", { silent = true })
vim.keymap.set("x", "ge", ":<C-u>call plugins#wordmotion#motion(v:count1, 'x', 'e', 0, [])<CR>", { silent = true })
vim.keymap.set("o", "ge", "<Cmd>call plugins#wordmotion#motion(v:count1, 'o', 'e', 0, [])<CR>", { silent = true })
vim.keymap.set("x", "iu", ":<C-u>call plugins#wordmotion#object(v:count1, 'x', 1, 0)<CR>", { silent = true })
vim.keymap.set("o", "iu", "<Cmd>call plugins#wordmotion#object(v:count1, 'o', 1, 0)<CR>", { silent = true })
vim.keymap.set("x", "au", ":<C-u>call plugins#wordmotion#object(v:count1, 'x', 0, 0)<CR>", { silent = true })
vim.keymap.set("o", "au", "<Cmd>call plugins#wordmotion#object(v:count1, 'o', 0, 0)<CR>", { silent = true })
vim.keymap.set("x", "v", ":<C-u>call plugins#expand_region#next('v', '+')<CR>", { silent = true })
vim.keymap.set("x", "<BS>", ":<C-u>call plugins#expand_region#next('v', '-')<CR>", { silent = true })
vim.keymap.set("o", "ib", "<Cmd>call plugins#expand_region#any_pair('o', 'i')<CR>", { silent = true })
vim.keymap.set("x", "ib", ":<C-u>call plugins#expand_region#any_pair('v', 'i')<CR>", { silent = true })
vim.keymap.set("o", "ab", "<Cmd>call plugins#expand_region#any_pair('o', 'a')<CR>", { silent = true })
vim.keymap.set("x", "ab", ":<C-u>call plugins#expand_region#any_pair('v', 'a')<CR>", { silent = true })
vim.keymap.set("n", "f", "<Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 'f', 'f')<CR>")
vim.keymap.set("x", "f", "<Cmd>call plugins#fanfingtastic#visual_next_char(v:count1, '', 'f', 'f')<CR>")
vim.keymap.set("o", "f", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 'f', 'f')<CR>")
vim.keymap.set("n", "F", "<Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 'F', 'F')<CR>")
vim.keymap.set("x", "F", "<Cmd>call plugins#fanfingtastic#visual_next_char(v:count1, '', 'F', 'F')<CR>")
vim.keymap.set("o", "F", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 'F', 'F')<CR>")
vim.keymap.set("n", "t", "<Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 't', 't')<CR>")
vim.keymap.set("x", "t", "<Cmd>call plugins#fanfingtastic#visual_next_char(v:count1, '', 't', 't')<CR>")
vim.keymap.set("o", "t", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 't', 't')<CR>")
vim.keymap.set("n", "T", "<Cmd>call plugins#fanfingtastic#next_char(v:count1, '', 'T', 'T')<CR>")
vim.keymap.set("x", "T", "<Cmd>call plugins#fanfingtastic#visual_next_char(v:count1, '', 'T', 'T')<CR>")
vim.keymap.set("o", "T", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, '', 'T', 'T')<CR>")
vim.keymap.set("n", ",", "<Cmd>call plugins#fanfingtastic#next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>")
vim.keymap.set("x", ",", "<Cmd>call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>")
vim.keymap.set("o", ",", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>")
vim.keymap.set("n", ";,", "<Cmd>call plugins#fanfingtastic#next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>")
vim.keymap.set("x", ";,", "<Cmd>call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>")
vim.keymap.set("o", ";,", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>")
vim.keymap.set("n", "cx", "'<Cmd>set operatorfunc=plugins#exchange#exchange_set<CR>'. (v:count1 == 1 ? '' : v:count1). 'g@'", { expr = true, replace_keycodes = false })
vim.keymap.set("x", "X", "<Cmd>call plugins#exchange#exchange_set(visualmode(), 1)<CR>")
vim.keymap.set("n", "cxx", "'<Cmd>set operatorfunc=plugins#exchange#exchange_set<CR>'. (v:count1 == 1 ? '' : v:count1). 'g@_'", { expr = true, replace_keycodes = false })
vim.keymap.set("n", "cxc", "<Cmd>call plugins#exchange#exchange_clear()<CR>")
vim.keymap.set("o", "gc", ":<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>")
-- general {{{2
vim.keymap.set("n", "[\\", "<Cmd>tab sbuffer<CR>")
vim.keymap.set("n", "]\\", "<Cmd>enew<CR>")
vim.keymap.set("n", "[<BS>", "<Cmd>new<CR>")
vim.keymap.set("n", "]<BS>", "<Cmd>vnew<CR>")
vim.keymap.set("n", "<C-]>", "<Cmd>call funcs#ctags()<CR>")
vim.keymap.set("n", "<leader><C-]>", "<Cmd>call funcs#ctags_create_and_jump()<CR>")
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
vim.keymap.set("n", "zn", "v:count > 0 ? '<Cmd>set foldlevel='. v:count. '<CR>' : '<Cmd>%foldclose<CR>'", { expr = true, replace_keycodes = false })
vim.keymap.set("n", "cr", "<Cmd>call funcs#edit_register()<CR>")
vim.keymap.set("n", "gf", "gF")
vim.keymap.set("n", "gF", "gf")
vim.keymap.set("n", "gx", "<Cmd>call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>")
vim.keymap.set("x", "gx", ":<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>")
vim.keymap.set("n", "zh", "zhz", { remap = true })
vim.keymap.set("n", "zl", "zlz", { remap = true })
vim.keymap.set("n", "<C-c>", "<Cmd>nohlsearch <bar> silent! AsyncStop!<CR><Cmd>echo<CR>")
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("x", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-w><C-c>", "<Esc>")
vim.keymap.set("n", "<C-w><", "<C-w><<C-w>", { remap = true })
vim.keymap.set("n", "<C-w>>", "<C-w>><C-w>", { remap = true })
vim.keymap.set("n", "<C-w>+", "<C-w>+<C-w>", { remap = true })
vim.keymap.set("n", "<C-w>-", "<C-w>-<C-w>", { remap = true })
vim.keymap.set({ "n", "t" }, "<C-h>", "<Cmd>call plugins#tmux_navigator#navigate('h')<CR>")
vim.keymap.set({ "n", "t" }, "<C-j>", "<Cmd>call plugins#tmux_navigator#navigate('j')<CR>")
vim.keymap.set({ "n", "t" }, "<C-k>", "<Cmd>call plugins#tmux_navigator#navigate('k')<CR>")
vim.keymap.set({ "n", "t" }, "<C-l>", "<Cmd>call plugins#tmux_navigator#navigate('l')<CR>")
vim.keymap.set({ "n", "t" }, "<M-h>", "<Cmd>call plugins#tmux_navigator#resize('h')<CR>")
vim.keymap.set({ "n", "t" }, "<M-j>", "<Cmd>call plugins#tmux_navigator#resize('j')<CR>")
vim.keymap.set({ "n", "t" }, "<M-k>", "<Cmd>call plugins#tmux_navigator#resize('k')<CR>")
vim.keymap.set({ "n", "t" }, "<M-l>", "<Cmd>call plugins#tmux_navigator#resize('l')<CR>")
vim.keymap.set("n", "<C-f>", "<Cmd>lua require('lsp').organize_imports_and_format()<CR>")
vim.keymap.set("x", "<C-f>", vim.lsp.buf.format)
vim.keymap.set({ "n", "x" }, "<leader>p", '"0p')
vim.keymap.set({ "n", "x" }, "<leader>P", '"0P')
vim.keymap.set("i", "<leader>r", "<Esc><leader>r", { remap = true })
vim.keymap.set("n", "<leader>r", "<Cmd>execute funcs#get_run_command()<CR>")
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+y$')
vim.keymap.set("n", "<leader>n", [[:let @/ = '\<<C-r><C-w>\>' <bar> set hlsearch<CR>]], { silent = true })
vim.keymap.set("x", "<leader>n", [["xy:let @/ = substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>]], { silent = true })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
vim.keymap.set("x", "<leader>s", [["xy:%s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\r', 'g')<CR>/gc<Left><Left><Left>]])
vim.keymap.set({ "n", "x" }, "<leader>c", "<leader>ncgn", { remap = true })
vim.keymap.set("n", "<leader>l", "<Cmd>call funcs#print_variable(0, 0)<CR>")
vim.keymap.set("x", "<leader>l", ":<C-u>call funcs#print_variable(1, 0)<CR>")
vim.keymap.set("n", "<leader>L", "<Cmd>call funcs#print_variable(0, 1)<CR>")
vim.keymap.set("x", "<leader>L", ":<C-u>call funcs#print_variable(1, 1)<CR>")
vim.keymap.set("i", "<leader>w", "<Esc><Cmd>update<CR>")
vim.keymap.set("n", "<leader>w", "<Cmd>update<CR>")
vim.keymap.set("n", "<leader>W", "<Cmd>wall<CR>")
vim.keymap.set("n", "<leader>q", "<Cmd>call funcs#quit(0, 0)<CR>") -- close window
vim.keymap.set("n", "<leader>Q", "<Cmd>call funcs#quit(0, 1)<CR>") -- close tab
vim.keymap.set("n", "<leader>x", "<Cmd>call funcs#quit(1, 0)<CR>") -- close buffer and preserve layout
vim.keymap.set("n", "<leader>X", "<Cmd>call funcs#quit(1, 1)<CR>") -- force quit
vim.keymap.set("n", "yoq", "empty(filter(getwininfo(), 'v:val.quickfix')) ? '<Cmd>copen<CR>' : '<Cmd>cclose<CR>'", { expr = true, replace_keycodes = false })
vim.keymap.set("n", "yol", "empty(filter(getwininfo(), 'v:val.loclist')) ? '<Cmd>lopen<CR>' : '<Cmd>lclose<CR>'", { expr = true, replace_keycodes = false })
vim.keymap.set("n", "yot", "<Cmd>TSBufToggle highlight <bar> TSBufToggle indent<CR>")
vim.keymap.set("n", "yog", "<Cmd>lua require('rooter').toggle()<CR>")
vim.keymap.set("t", "<C-u>", "<C-\\><C-n>")
vim.keymap.set("c", "<C-Space>", [[':/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>']], { expr = true, replace_keycodes = false })
vim.keymap.set("c", "<BS>", [[':/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>']], { expr = true, replace_keycodes = false })
vim.keymap.set("c", "<Tab>", "'/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'", { expr = true }) -- <C-z> is 'wildcharm'
vim.keymap.set("c", "<S-Tab>", "'/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'", { expr = true })
vim.cmd("cnoreabbrev print <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'lua =( )' : 'print')<CR><C-r>=(getcmdtype() == ':' && getcmdline() == 'lua =( )' ? setcmdpos(7)[-1] : '')<CR>") -- vim.pretty_print
vim.cmd("cnoreabbrev git <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'Git' : 'git')<CR>") -- fugitive

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
vim.api.nvim_create_autocmd("TextYankPost", { pattern = "*", group = "AutoCommands", callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 }) end })
vim.api.nvim_create_autocmd("FileType", { pattern = "*", group = "AutoCommands", command = "setlocal formatoptions=jql" })
vim.api.nvim_create_autocmd("FileType", { pattern = { "help", "man", "toggleterm" }, group = "AutoCommands", command = "nnoremap <nowait> <buffer> d <C-d>| nnoremap <buffer> u <C-u>" })
vim.api.nvim_create_autocmd("FileType", { pattern = "toggleterm", group = "AutoCommands", command = "nnoremap <buffer> gf :argadd <C-r><C-p><CR>" })
vim.api.nvim_create_autocmd("FileType", { pattern = "http", group = "AutoCommands", command = "setlocal commentstring=#\\ %s" })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    group = "AutoCommands",
    callback = function()
        vim.bo.bufhidden = "wipe"
        vim.keymap.set("n", "h", "[[<CR>^", { remap = true, buffer = true })
        vim.keymap.set("n", "l", "<CR>", { remap = true, buffer = true })
        vim.keymap.set("n", "C", "gn:execute 'cd '. b:netrw_curdir<CR>", { remap = true, buffer = true })
        vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true })
        vim.keymap.set("n", "q", "<Cmd>call funcs#quit_netrw_and_dirs()<CR>", { buffer = true, nowait = true })
        vim.keymap.set("n", "<leader>q", "q", { remap = true, buffer = true })
        vim.keymap.set("n", "a", "%", { remap = true, buffer = true })
    end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "quickfix",
    group = "AutoCommands",
    callback = function()
        vim.bo.buflisted = false
        vim.bo.modifiable = true
        vim.keymap.set("n", "<leader>w", [[<Cmd>let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m,%f\|\|%m' <bar> cgetbuffer <bar> silent! bdelete! <bar> copen<CR>]], { buffer = true })
        vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
    end,
})
vim.api.nvim_create_autocmd("CmdwinEnter", { pattern = "*", group = "AutoCommands", callback = function() vim.keymap.set("n", "<CR>", "<CR>", { buffer = true }) end })
vim.api.nvim_create_autocmd("BufEnter", { pattern = "term://*", group = "AutoCommands", command = [[if line('$') <= line('w$') && len(filter(getline(line('.') + 1, '$'), 'v:val != ""')) == 0 | startinsert | endif]] })
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", group = "AutoCommands", callback = require("rooter").root })
vim.api.nvim_create_autocmd("User", { -- fugitive buffer :Git
    pattern = "FugitiveIndex",
    group = "AutoCommands",
    callback = function() vim.keymap.set("n", "dt", ":Gtabedit <Plug><cfile><bar>Gdiffsplit! @<CR>", { silent = true, buffer = true }) end,
})

-- commands {{{1
vim.api.nvim_create_user_command("SetRunCommand", "if '<bang>' != '' | let b:RunCommand = <q-args> | else | let g:RunCommand = <q-args> | endif", { complete = "file", nargs = "*", bang = true })
vim.api.nvim_create_user_command("SetArgs", "let b:args = <q-args> == '' ? '' : ' '. <q-args>", { complete = "file", nargs = "*" })
vim.api.nvim_create_user_command("S", [[execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | if <range> != 0 | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr(). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | else | execute "put =execute('". <q-args>. "')" | endif | 1d]], { complete = "command", nargs = "*", range = true, bang = true })
vim.api.nvim_create_user_command("W", [[call mkdir(expand('%:p:h'), 'p') | if '<bang>' == '' | execute 'write !sudo tee % > /dev/null' | else | %yank | vnew | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | 0put='Enter password in terminal and press <lt>C-u>pa<lt>Esc>;w' | wincmd p | execute "botright terminal sudo `which nvim` +'set paste' +'1,$d' +startinsert %" | startinsert | endif]], { bang = true }) -- TODO(0.9) https://github.com/neovim/neovim/issues/19884
vim.api.nvim_create_user_command("Grt", "Gcd", {})
vim.api.nvim_create_user_command("SessionSave", "silent! ScrollViewDisable | mksession! ~/.cache/nvim/session.vim | silent! ScrollViewEnable | lua vim.notify('Session saved to ~/.cache/nvim/session.vim', 'INFO', { title = 'Session' })", {})
vim.api.nvim_create_user_command("SessionLoad", "source ~/.cache/nvim/session.vim | lua vim.notify('Loaded session from ~/.cache/nvim/session.vim', 'INFO', { title = 'Session' })", {})
vim.api.nvim_create_user_command("RgRegex", "lua require('telescope.builtin').grep_string({path_display = {'smart'}, use_regex = true, search = <q-args>, initial_mode = 'normal'})", { nargs = "*" })
vim.api.nvim_create_user_command("RgNoRegex", "lua require('telescope.builtin').grep_string({path_display = {'smart'}, search = <q-args>, initial_mode = 'normal'})", { nargs = "*" })
vim.api.nvim_create_user_command("Untildone", "lua require('utils').untildone(<q-args>, '<bang>')", { complete = "shellcmd", nargs = "*", bang = true })
vim.api.nvim_create_user_command("Glow", "terminal glow %", {})
vim.api.nvim_create_user_command("Prettier", function(args)
    local filetype_map = { javascript = "typescript", javascriptreact = "typescript", typescriptreact = "typescript" }
    local parser = args.args ~= "" and args.args or (filetype_map[vim.bo.filetype] or vim.bo.filetype)
    local line1 = args.range == 0 and 0 or args.line1 - 1
    local line2 = args.range == 0 and -1 or args.line2
    local formatted = vim.fn.systemlist("prettier --parser " .. parser, vim.api.nvim_buf_get_lines(0, line1, line2, false))
    if vim.api.nvim_get_vvar("shell_error") == 0 then
        vim.api.nvim_buf_set_lines(0, line1, line2, false, formatted)
    else
        vim.notify(formatted, "ERROR", { title = "Prettier failed" })
    end
end, { complete = "filetype", nargs = "*", range = true })

-- overrides {{{1
vim.filetype.add({
    extension = {
        log = "log",
        http = "http",
        conf = "config",
    },
    filename = {
        Caddyfile = "config",
    },
})
vim.notify = (function(overridden)
    return function(...)
        local present, notify = pcall(require, "notify")
        if present then
            vim.notify = notify
        else
            vim.notify = overridden
        end
        vim.notify(...)
    end
end)(vim.notify)
vim.paste = (function(overridden)
    return function(lines, phase) -- break undo before pasting in insert mode, :h vim.paste()
        if phase == -1 and vim.fn.mode() == "i" and not vim.o.paste then
            vim.cmd("let &undolevels = &undolevels") -- resetting undolevels breaks undo
        end
        overridden(lines, phase)
    end
end)(vim.paste)
if vim.env.SSH_CLIENT ~= nil then -- ssh session
    local function copy(lines, _)
        require("utils").copy_with_osc_yank_script(table.concat(lines, "\n"))
    end

    local function paste()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end

    vim.g.clipboard = {
        name = "osc52",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
    }
    vim.keymap.set("n", "gx", "<Cmd>lua require('utils').copy_with_osc_yank_script(vim.fn.expand('<cfile>'))<CR>")
elseif vim.fn.has("macunix") ~= 1 then -- WSL Vim
    vim.fn["funcs#map_copy_to_win_clip"]()
end

-- plugins {{{1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", { defaults = { lazy = true } })
if require("states").small_file then
    vim.schedule(function()
        vim.defer_fn(function()
            require("lazy").load({ plugins = { "nvim-treesitter", "mason.nvim" } })
        end, 30)
        vim.defer_fn(function()
            vim.o.foldmethod = "expr"
            vim.o.foldexpr = "max([indent(v:lnum),indent(v:lnum+1)])/&shiftwidth"
            vim.o.foldtext = "getline(v:foldstart).' ⋯'"
            vim.o.fillchars = "fold: "
            local plugins = { -- motions/text objects sometimes don't work if loaded on keys
                "vim-illuminate",
                "conflict-marker.vim",
                "indent-blankline.nvim",
                "nvim-scrollview",
                "gitsigns.nvim",
                "quick-scope",
            }
            require("lazy").load({ plugins = plugins })
        end, 100)
    end)
end
-- vim:foldmethod=marker
