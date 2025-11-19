-- options {{{1
vim.loader.enable()
require("states")
vim.g.loaded_2html_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.mapleader = ";"
vim.g.maplocalleader = "'"
vim.g.netrw_dirhistmax = 0
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0
vim.g.netrw_liststyle = 3
vim.g.markdown_fenced_languages = { "javascript", "js=javascript", "ts=typescript", "tsx=typescriptreact", "json=jsonc", "html", "python", "bash=sh" }
vim.o.whichwrap = "<,>,[,]"
vim.o.mouse = "a"
vim.o.cursorline = true
vim.o.cursorlineopt = "number,screenline"
vim.o.numberwidth = 2
vim.o.number = true
vim.o.linebreak = true
vim.o.showmatch = true
vim.o.showmode = false
vim.o.showcmdloc = "statusline"
vim.o.cmdheight = 0
vim.o.diffopt = vim.o.diffopt .. ",vertical,indent-heuristic,algorithm:histogram" -- TODO(0.12) add inline:word or inline:char
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.splitkeep = "topline"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = -1
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.complete = ".,w,b,u"
vim.o.completeopt = "menuone,noinsert"
vim.o.completefunc = "funcs#complete_word"
vim.o.shortmess = vim.o.shortmess .. "cAS"
vim.o.spellsuggest = vim.o.spellsuggest .. ",10"
vim.o.spelloptions = "camel"
vim.o.spellcapcheck = ""
vim.o.fileencodings = "utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1"
vim.o.scrolloff = 2
vim.o.sidescrolloff = 5
vim.o.signcolumn = "yes"
vim.o.virtualedit = "block"
vim.o.previewheight = 7
vim.o.foldlevel = 99
vim.o.jumpoptions = "view"
vim.o.shada = "!,'5000,<50,s10,/20,@20,h"
vim.o.undofile = true
vim.o.isfname = vim.o.isfname:gsub(",=", "")
vim.o.path = ".,,**5"
vim.o.list = true
vim.o.listchars = "tab:» ,nbsp:␣,trail:•"
vim.o.timeoutlen = 1500
vim.o.ttimeoutlen = 40
vim.o.synmaxcol = 1000
vim.o.writebackup = false
vim.o.wildcharm = 26 -- <C-z>
vim.o.cedit = "<C-x>"
vim.filetype.add({ extension = { conf = "config" }, filename = { Caddyfile = "config" } })

-- mappings {{{1
-- text objects {{{2
local text_objects = { "_", ".", ":", ",", ";", "<bar>", "/", "<bslash>", "*", "+", "-", "#", "=", "&" }
for _, char in ipairs(text_objects) do
    vim.keymap.set("x", "i" .. char, ":<C-u>normal! T" .. char .. "vt" .. char .. "<CR>", { silent = true })
    vim.keymap.set("o", "i" .. char, "<Cmd>normal vi" .. char .. "<CR>", { silent = true })
    vim.keymap.set("x", "a" .. char, ":<C-u>normal! F" .. char .. "vt" .. char .. "<CR>", { silent = true })
    vim.keymap.set("o", "a" .. char, "<Cmd>normal va" .. char .. "<CR>", { silent = true })
end
vim.keymap.set("x", "i<Space>", "iW")
vim.keymap.set("o", "i<Space>", "iW")
vim.keymap.set("x", "a<Space>", "aW")
vim.keymap.set("o", "a<Space>", "aW")
vim.keymap.set("x", "il", "^og_")
vim.keymap.set("o", "il", "<Cmd>normal vil<CR>")
vim.keymap.set("x", "al", "0o$")
vim.keymap.set("o", "al", "<Cmd>normal val<CR>")
vim.keymap.set("x", "ae", "GoggV")
vim.keymap.set("o", "ae", "<Cmd>normal vae<CR>")
vim.keymap.set("x", "a5", "iw%")
vim.keymap.set("o", "a5", "<Cmd>normal va5<CR>")
vim.keymap.set("n", "gp", "`[v`]")
vim.keymap.set("o", "gp", "<Cmd>normal gp<CR>")
vim.keymap.set("x", "P", function()
    local is_visual_line = vim.fn.mode() == "V"
    vim.cmd.normal({ args = { '"' .. vim.v.register .. "P" }, bang = true })
    if is_visual_line then vim.cmd.normal({ args = { "`[v`]=" }, bang = true }) end
end)
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
vim.keymap.set("x", ",", ":call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>")
vim.keymap.set("o", ",", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ';')<CR>")
vim.keymap.set("n", ";,", "<Cmd>call plugins#fanfingtastic#next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>")
vim.keymap.set("x", ";,", ":call plugins#fanfingtastic#visual_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>")
vim.keymap.set("o", ";,", "<Cmd>call plugins#fanfingtastic#operator_next_char(v:count1, plugins#fanfingtastic#get('fchar'), plugins#fanfingtastic#get('ff'), ',')<CR>")
vim.keymap.set("n", "cr", "plugins#abolish#coerce('iw')", { expr = true })
vim.keymap.set("n", "crr", "plugins#abolish#coerce('')", { expr = true })
-- general {{{2
vim.keymap.set("n", "[\\", "<Cmd>tab sbuffer<CR>")
vim.keymap.set("n", "]\\", "<Cmd>enew<CR>")
vim.keymap.set("n", "[<BS>", "<Cmd>new<CR>")
vim.keymap.set("n", "]<BS>", "<Cmd>vnew<CR>")
vim.keymap.set("n", "<C-]>", "<Cmd>call funcs#ctags()<CR>")
vim.keymap.set("n", "<leader><C-]>", "<Cmd>call funcs#ctags_create_and_jump()<CR>")
vim.keymap.set({ "n", "x", "o" }, "0", "funcs#home()", { expr = true })
vim.keymap.set({ "n", "x", "o" }, "^", "0")
vim.keymap.set({ "n", "o" }, "-", "$") -- $ in normal mode will always put cursor at last column when scrolling (curswant), g_ will not
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
vim.keymap.set("i", "<C-r>/", [[<Cmd>call nvim_put([substitute(@/, '^\\<\|\\>$', '', 'g')], '', v:false, v:true)<CR>]])
vim.keymap.set("n", "c@", "<Cmd>call funcs#edit_register()<CR>")
vim.keymap.set("n", "U", "<Cmd>execute 'earlier ' . v:count1 . 'f'<CR>")
vim.keymap.set("x", ".", ":normal .<CR>")
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
vim.keymap.set({ "n", "x", "o" }, "gq", "gw")
vim.keymap.set("n", "zn", "v:count > 0 ? '<Cmd>set foldlevel=' . v:count . '<CR>' : '<Cmd>%foldclose<CR>'", { expr = true, replace_keycodes = false })
vim.keymap.set("n", "gf", "gF")
vim.keymap.set("n", "gF", "gf")
vim.keymap.set("x", "g/", [[<Esc>/\%><C-r>=line("'<") - 1<CR>l\%<<C-r>=line("'>") + 1<CR>l]]) -- search in fixed selection range, /\%V will search in the most recent selection dynamically
vim.keymap.set("n", "zh", "zhz", { remap = true })
vim.keymap.set("n", "zl", "zlz", { remap = true })
vim.keymap.set("n", "ZX", function()
    local cur = vim.api.nvim_get_current_buf()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted and bufnr ~= cur and vim.b[bufnr].bufpersist ~= 1 then require("mini.bufremove").delete(bufnr, false) end
    end
end, { desc = "Close untouched buffers" })
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<C-c>", "<C-c><Cmd>nohlsearch<CR>")
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
vim.keymap.set("x", "<C-f>", "<Cmd>Conform<CR><Esc>")
vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]])
vim.keymap.set({ "n", "x" }, "<leader>P", [["0P]])
vim.keymap.set("i", "<leader>r", "<Esc><leader>r", { remap = true })
vim.keymap.set("n", "<leader>r", "<Cmd>execute funcs#get_run_command()<CR>")
vim.keymap.set("n", "yc", '"xyygcc"xp', { remap = true })
vim.keymap.set("n", "<leader>n", [[:let @/ = '\<<C-r><C-w>\>' <bar> set hlsearch<CR>]], { silent = true })
vim.keymap.set("x", "<leader>n", [[:<C-u>let @/ = substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>]], { silent = true })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
vim.keymap.set("x", "<leader>s", [[:<C-u>%s/<C-r>=substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(funcs#get_visual_selection(), '/\.*$^~[&'), '\n', '\\r', 'g')<CR>/gc<Left><Left><Left>]])
vim.keymap.set("x", "<leader>S", [[:s/\%V//g<Left><Left><Left>]])
vim.keymap.set("n", "m<C-c>", "<Cmd>call funcs#highlight_clear()<CR>")
vim.keymap.set("n", "m<leader>n", [[:call funcs#highlight('\<<C-r><C-w>\>')<CR>]], { silent = true })
vim.keymap.set("x", "m<leader>n", [[:<C-u>call funcs#highlight(substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g'))<CR>]], { silent = true })
vim.keymap.set("n", "c.", '/\\V\\C<C-r>=escape(@", "/")<CR><CR>cgn<C-a><Esc>')
vim.keymap.set("n", "cn", "<leader>ncgn", { remap = true })
vim.keymap.set("x", "C", "<leader>ncgn", { remap = true })
vim.keymap.set("n", "<leader>tu", "<C-^>")
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
vim.keymap.set("n", "yot", "<Cmd>TSBufToggle highlight <bar> TSBufToggle indent<CR>")
vim.keymap.set("n", "yov", "':setlocal virtualedit=' . (&virtualedit == 'block' ? 'all' : 'block') . '<CR>'", { expr = true })
vim.keymap.set("n", "yog", "<Cmd>lua require('rooter').toggle()<CR>")
vim.keymap.set("n", "yoR", "<Cmd>if get(g:, 'ReaderMode', 0) == 0 | nnoremap <nowait> d <C-d>| nnoremap u <C-u> | else | execute 'nunmap d' | execute 'nunmap u' | endif | let g:ReaderMode = 1 - get(g:, 'ReaderMode', 0) | lua vim.notify('Reader mode ' .. (vim.g.ReaderMode == 1 and 'on' or 'off'))<CR>")
vim.keymap.set("t", "<C-u>", "<C-\\><C-n>")
vim.keymap.set("c", "<C-Space>", [[':/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>']], { expr = true, replace_keycodes = false })
vim.keymap.set("c", "<BS>", [[':/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>']], { expr = true, replace_keycodes = false })
vim.keymap.set("c", "<Tab>", "'/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'", { expr = true }) -- <C-z> is 'wildcharm'
vim.keymap.set("c", "<S-Tab>", "'/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'", { expr = true })
vim.keymap.set("ca", "fd", "<C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'Fd' : 'fd')<CR>")
vim.keymap.set("ca", "rg", "<C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'Rg' : 'rg')<CR>")

-- autocmds {{{1
vim.api.nvim_create_augroup("AutoCommands", {})
vim.api.nvim_create_autocmd("BufLeave", {
    group = "AutoCommands",
    command = "if !exists('w:SavedBufView') | let w:SavedBufView = {} | endif | let w:SavedBufView[bufnr()] = winsaveview()",
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = "AutoCommands",
    command = "if exists('w:SavedBufView') && has_key(w:SavedBufView, bufnr()) | let temp_view = winsaveview() | if temp_view.lnum == 1 && temp_view.col == 0 && !&diff | call winrestview(w:SavedBufView[bufnr()]) | endif | unlet w:SavedBufView[bufnr()] | endif",
})
vim.api.nvim_create_autocmd("BufReadPost", {
    group = "AutoCommands",
    callback = function(args)
        if vim.b.cursor_restored or require("states").qs_disabled_filetypes[vim.o.filetype] == false or vim.api.nvim_buf_get_name(args.buf):match("/COMMIT_EDITMSG$") then return end
        vim.b.cursor_restored = true
        pcall(vim.api.nvim_win_set_cursor, 0, vim.api.nvim_buf_get_mark(args.buf, '"'))
        vim.opt_local.winbar = "%f"
        vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, { once = true, buffer = args.buf, command = "let b:bufpersist = 1" })
    end,
})
local pre_yank_view
vim.keymap.set({ "n", "x" }, "y", function()
    pre_yank_view = vim.fn.winsaveview()
    return "y"
end, { expr = true })
vim.keymap.set("n", "Y", function()
    pre_yank_view = vim.fn.winsaveview()
    return "y$"
end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { remap = true })
vim.keymap.set("n", "<leader>Y", '"+y$', { remap = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "AutoCommands",
    callback = function()
        if vim.v.event.operator == "y" and pre_yank_view then pcall(vim.fn.winrestview, pre_yank_view) end
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})
vim.api.nvim_create_autocmd("VimResized", { group = "AutoCommands", command = "wincmd =" })
vim.api.nvim_create_autocmd("FileType", { group = "AutoCommands", command = "setlocal formatoptions=rjql" })
vim.api.nvim_create_autocmd("FileType", { group = "AutoCommands", pattern = { "help", "man", "snacks_terminal" }, command = "noremap <nowait> <buffer> d <C-d>| noremap <buffer> u <C-u>" })
vim.api.nvim_create_autocmd("FileType", { group = "AutoCommands", pattern = { "http", "nu" }, command = [[setlocal commentstring=#\ %s]] })
vim.api.nvim_create_autocmd("FileType", {
    group = "AutoCommands",
    pattern = "netrw", -- netrw is needed for gf on URL
    callback = function()
        vim.bo.bufhidden = "wipe"
        vim.keymap.set("n", "h", "[[<CR>^", { remap = true, buffer = true })
        vim.keymap.set("n", "l", "<CR>", { remap = true, buffer = true })
        vim.keymap.set("n", "C", "gn:execute 'cd ' . b:netrw_curdir<CR>", { remap = true, buffer = true })
        vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true })
        vim.keymap.set("n", "q", "<Cmd>call funcs#quit_netrw_and_dirs()<CR>", { buffer = true, nowait = true })
        vim.keymap.set("n", "<leader>q", "q", { remap = true, buffer = true })
        vim.keymap.set("n", "a", "%", { remap = true, buffer = true })
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    group = "AutoCommands",
    pattern = "zsh",
    callback = function()
        if vim.api.nvim_buf_get_name(0):match(".*/tmp/zsh.*") then -- https://www.reddit.com/r/neovim/comments/1m9iyem/comment/n58cnee
            vim.keymap.set("n", "<C-f>", [[<Cmd>%s/&&/\\\r\&\&/ge|%s/--/\\\r  --/ge|%s/ -\(\w\)/ \\\r  -\1/ge<CR><Cmd>nohlsearch<CR>]], { buffer = true })
            vim.keymap.set("x", "<C-f>", [[:s/&&/\\\r\&\&/ge|'<,'>s/--/\\\r  --/ge|'<,'>s/ -\(\w\)/ \\\r  -\1/ge<CR><Cmd>nohlsearch<CR>]], { buffer = true, silent = true })
        end
    end,
})
vim.api.nvim_create_autocmd("CmdwinEnter", { group = "AutoCommands", callback = function() vim.keymap.set("n", "<CR>", "<CR>", { buffer = true }) end })
vim.api.nvim_create_autocmd("BufEnter", { group = "AutoCommands", pattern = "term://*", command = [[if line('$') <= line('w$') && len(filter(getline(line('.') + 1, '$'), 'trim(v:val) != ""')) == 0 | startinsert | endif]] })

-- commands {{{1
vim.api.nvim_create_user_command("SetRunCommand", "if '<bang>' != '' | let b:RunCommand = <q-args> | else | let g:RunCommand = <q-args> | endif", { complete = "file", nargs = "*", bang = true })
vim.api.nvim_create_user_command("S", [[execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | if <range> != 0 | setlocal filetype=' . &filetype . ' | put =getbufline(' . bufnr() . ', <line1>, <line2>) | resize ' . min([<line2>-<line1>+2, &lines * 2/5]) . '| else | resize ' . min([15, &lines * 2/5]) . '| endif' | if '<bang>' != '' | execute 'read !' . <q-args> | else | execute "put =execute('" . <q-args> . "')" | endif | 1d]], { complete = "command", nargs = "*", range = true, bang = true })
vim.api.nvim_create_user_command("W", [[call mkdir(expand('%:p:h'), 'p') | if '<bang>' == '' | execute 'write !sudo tee % > /dev/null' | else | %yank | vnew | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | 0put='Enter password in terminal and press <lt>C-u>pa<lt>Esc>;w' | wincmd p | execute "botright terminal sudo `which nvim` +'1,$d' +startinsert %" | startinsert | endif]], { bang = true })
vim.api.nvim_create_user_command("ProfileStart", "lua require('plenary.profile').start(vim.fn.stdpath('cache') .. '/profile.log')", {})
vim.api.nvim_create_user_command("ProfileStop", [[execute "lua require('plenary.profile').stop()" | execute 'edit ' . stdpath('cache') . '/profile.log']], {})
vim.api.nvim_create_user_command("SessionSave", "silent! ScrollViewDisable | execute 'mksession! ' . stdpath('data') . '/session_' . <q-args> . '.vim' | silent! ScrollViewEnable | lua vim.notify('Session saved to \"' .. vim.fn.stdpath('data') .. '/session_' .. <q-args> .. '.vim\"', vim.log.levels.INFO, { title = 'Session' })", { nargs = "*", complete = "customlist,funcs#get_session_names" })
vim.api.nvim_create_user_command("SessionLoad", "execute 'source ' . stdpath('data') . '/session_' . <q-args> . '.vim' | lua vim.notify('Loaded session from \"' .. vim.fn.stdpath('data') .. '/session_' .. <q-args> .. '.vim\"', vim.log.levels.INFO, { title = 'Session' })", { nargs = "*", complete = "customlist,funcs#get_session_names" })
vim.api.nvim_create_user_command("Fd", "call funcs#grep('fd', <q-args>)", { nargs = "+" })
vim.api.nvim_create_user_command("Rg", "call funcs#grep('rg --vimgrep', <q-args>)", { nargs = "+" })
vim.api.nvim_create_user_command("RgRegex", "lua require('snacks.picker').grep({regex = '<bang>' == '' and true or false, live = false, on_show = function() vim.cmd.stopinsert() end, search = <q-args>})", { nargs = "*", bang = true })
vim.api.nvim_create_user_command("RgNoRegex", "lua require('snacks.picker').grep({regex = false, live = false, on_show = function() vim.cmd.stopinsert() end, search = <q-args>})", { nargs = "*" })
vim.api.nvim_create_user_command("DeleteComments", function(opts) if opts.range > 0 then require("utils").delete_comments(opts.line1, opts.line2) else require("utils").delete_comments() end end, { range = true })
vim.api.nvim_create_user_command("Glow", "execute 'terminal glow %' | noremap <nowait> <buffer> d <C-d>| noremap <buffer> u <C-u>", {})
vim.api.nvim_create_user_command("TSC", "compiler tsc | let &l:makeprg = stdpath('data') . '/mason/packages/typescript-language-server/node_modules/typescript/bin/tsc' | silent make --noEmit | copen", {})
vim.api.nvim_create_user_command("JSON", [[if <range> != 0 | execute "'<,'>Prettier json" | else | keeppatterns %s/\n\+\%$//e | set shiftwidth=2 filetype=json | execute 'Prettier json' | endif]], { range = true })
vim.api.nvim_create_user_command("Prettier", function(args)
    local filetype_map = { jsonc = "json", javascript = "typescript", javascriptreact = "typescript", typescriptreact = "typescript", [""] = "json" }
    local parser = args.args ~= "" and args.args or vim.bo.filetype
    local lines = args.range == 0 and vim.api.nvim_buf_get_lines(0, 0, -1, false) or vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), { type = vim.fn.visualmode() })
    local result = vim.system({ "prettier", "--parser", filetype_map[parser] or parser }, { text = true, stdin = lines }):wait()
    if result.code ~= 0 then return vim.notify(result.stderr, vim.log.levels.ERROR, { title = "Prettier failed" }) end
    if args.range == 0 then return vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result.stdout, "\n", { trimempty = true })) end
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    if end_pos[3] == vim.v.maxcol then end_pos[3] = vim.fn.col("'>") - 1 end
    vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], vim.split(result.stdout, "\n", { trimempty = true }))
end, { complete = "filetype", nargs = "*", range = true })

-- overrides {{{1
vim.defer_fn(function()
    if vim.fn.has("win32") == 1 then vim.g.termshell = "nu" end
    vim.paste = (function(overridden) -- break undo before pasting in insert mode, :h vim.paste()
        return function(lines, phase)
            if phase == -1 and vim.fn.mode() == "i" and not vim.o.paste then
                vim.o.undolevels = vim.o.undolevels -- resetting undolevels breaks undo
            end
            overridden(lines, phase)
        end
    end)(vim.paste)
    if vim.env.SSH_CLIENT ~= nil then -- ssh session
        vim.g.clipboard = {           -- in Windows Terminal -> ssh -> nvim, osc52 doesn't automatically enable
            name = "osc52",
            copy = { ["+"] = require("vim.ui.clipboard.osc52").copy("+"), ["*"] = require("vim.ui.clipboard.osc52").copy("*") },
            paste = { ["+"] = require("vim.ui.clipboard.osc52").paste("+"), ["*"] = require("vim.ui.clipboard.osc52").paste("*") },
        }
        vim.keymap.set("n", "gx", "<Cmd>let @+=expand('<cfile>') <bar> lua vim.notify(vim.fn.expand('<cfile>'), vim.log.levels.INFO, { title = 'Link copied' })<CR>")
    elseif vim.fn.has("wsl") == 1 then
        vim.g.clipboard = {
            name = "WslClipboard",
            copy = { ["+"] = "clip.exe", ["*"] = "clip.exe" },
            paste = {
                ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
        }
    end
end, 50)

-- plugins {{{1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }, { text = true }):wait()
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", { defaults = { lazy = true }, ui = { border = "rounded" } })
require("themes").setup()
require("rooter").setup()
if require("states").small_file then
    vim.defer_fn(function()
        require("lsp").setup()
        require("lazy").load({ plugins = { "nvim-treesitter", "dropbar.nvim" } })
    end, 30)
    vim.defer_fn(function()
        vim.o.foldmethod = "expr"
        -- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- makes :g commands slow
        vim.o.foldexpr = "max([indent(v:lnum),indent(v:lnum+1)])/&shiftwidth"
        vim.o.foldtext = ""
        vim.o.fillchars = "diff:╱,fold: ,foldopen:,foldsep: ,foldclose:"
        require("lazy").load({ plugins = { "nvim-scrollview", "git-conflict.nvim", "gitsigns.nvim", "quick-scope" } })
        vim.cmd.doautocmd("BufReadPost") -- lsp and git-conflict need this when delay loaded
        require("bookmarks").setup()
        require("clips").setup()
    end, 100)
end
-- vim:foldmethod=marker
