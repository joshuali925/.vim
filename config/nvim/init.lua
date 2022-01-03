-- options {{{
local g, opt, fn, cmd = vim.g, vim.opt, vim.fn, vim.cmd
require("current-theme") --        lua/themes.lua
g.loaded_matchparen = 1 --         lua/utils.lua
g.loaded_matchit = 1 --            lua/plugins.lua
g.loaded_2html_plugin = 1 --       lua/plugin-configs.lua
g.loaded_remote_plugins = 1 --     lua/lsp.lua
g.loaded_tutor_mode_plugin = 1 --  ginit.vim
g.mapleader = ";" --               plugin/init.vim
g.netrw_dirhistmax = 0 --          autoload/funcs.vim
g.netrw_banner = 0
g.netrw_liststyle = 3
g.markdown_fenced_languages = {"javascript", "js=javascript", "css", "html", "python", "java", "c", "bash=sh"}
g.untildone_count = 0
opt.whichwrap = "<,>,[,]"
opt.termguicolors = true
opt.mouse = "a"
opt.cursorline = true
opt.numberwidth = 2
opt.number = true
opt.wrap = true
opt.linebreak = true
opt.showmatch = true
opt.showmode = false
opt.diffopt = opt.diffopt + {"vertical", "indent-heuristic", "algorithm:patience"}
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.textwidth = 0
opt.complete = {".", "w", "b", "u"}
opt.completeopt = {"menuone", "noselect"}
opt.completefunc = "funcs#complete_word"
opt.pumblend = 8
opt.shortmess = opt.shortmess + {c = true, A = true}
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.signcolumn = "yes"
opt.virtualedit = "block"
opt.previewheight = 7
opt.foldmethod = "indent"
opt.foldlevelstart = 99
opt.jumpoptions = "stack"
opt.shada = [[!,'1000,<50,s10,/20,@20,h]]
opt.undofile = true
opt.isfname = opt.isfname - {"="}
opt.path = {".", "", "**5"}
opt.list = true
opt.listchars = {tab = "» ", nbsp = "␣", trail = "•"}
opt.timeoutlen = 1500
opt.ttimeoutlen = 40
opt.synmaxcol = 1000
opt.lazyredraw = true
opt.writebackup = false
opt.wildcharm = 26 -- <C-z>
opt.grepprg = "rg --vimgrep --smart-case --hidden --auto-hybrid-regex"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
opt.cedit = "<C-x>"
-- }}}

-- mappings {{{
local function map(mode, lhs, rhs, opts)
    opts = opts or {noremap = true}
    if mode == "" then -- to not map select mode for snippets
        vim.api.nvim_set_keymap("n", lhs, rhs, opts)
        vim.api.nvim_set_keymap("x", lhs, rhs, opts)
        vim.api.nvim_set_keymap("o", lhs, rhs, opts)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end
-- text objects
local text_objects = {"<Space>", "_", ".", ":", ",", ";", "<bar>", "/", "<bslash>", "*", "+", "-", "#", "=", "&"}
for _, char in ipairs(text_objects) do
    map("x", "i" .. char, ":<C-u>normal! T" .. char .. "vt" .. char .. "<CR>", {noremap = true, silent = true})
    map("o", "i" .. char, "<Cmd>normal vi" .. char .. "<CR>", {noremap = true, silent = true})
    map("x", "a" .. char, ":<C-u>normal! T" .. char .. "vf" .. char .. "<CR>", {noremap = true, silent = true})
    map("o", "a" .. char, "<Cmd>normal va" .. char .. "<CR>", {noremap = true, silent = true})
end
map("x", "il", "^og_")
map("o", "il", "<Cmd>normal vil<CR>")
map("x", "al", "0o$")
map("o", "al", "<Cmd>normal val<CR>")
map(
    "x",
    "ii",
    [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]],
    {noremap = true, silent = true}
)
map(
    "o",
    "ii",
    [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]],
    {noremap = true, silent = true}
)
map(
    "x",
    "ai",
    [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 1, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]],
    {noremap = true, silent = true}
)
map(
    "o",
    "ai",
    [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 1, 0, [line("."), line("."), col("."), col(".")])<CR>]],
    {noremap = true, silent = true}
)
map(
    "x",
    "iI",
    [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(1, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]],
    {noremap = true, silent = true}
)
map(
    "o",
    "iI",
    [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(1, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]],
    {noremap = true, silent = true}
)
map(
    "x",
    "aI",
    [[:<C-u>call plugins#indent_object#HandleTextObjectMapping(0, 0, 1, [line("'<"), line("'>"), col("'<"), col("'>")])<CR><Esc>gv]],
    {noremap = true, silent = true}
)
map(
    "o",
    "aI",
    [[<Cmd>call plugins#indent_object#HandleTextObjectMapping(0, 0, 0, [line("."), line("."), col("."), col(".")])<CR>]],
    {noremap = true, silent = true}
)
-- general
map("n", "[\\", "<Cmd>tabedit<CR>")
map("n", "]\\", "<Cmd>enew<CR>")
map("", "0", "funcs#home()", {expr = true, noremap = true})
map("", "^", "0")
map("n", "-", "$") -- $ in normal mode will always put cursor at last column when scrolling, g_ will not
map("o", "-", "$")
map("x", "-", "g_")
map("", "g-", "g$")
map("", "<Home>", "g^")
map("", "<End>", "g$")
map("", "<Down>", "gj")
map("", "<Up>", "gk")
map("i", "<S-Del>", "<BS>")
map("i", "<Down>", "pumvisible() ? '<C-n>' : '<C-o>gj'", {expr = true, noremap = true})
map("i", "<Up>", "pumvisible() ? '<C-p>' : '<C-o>gk'", {expr = true, noremap = true})
map("i", "<Home>", "<C-o>g^")
map("i", "<End>", "<C-o>g$")
map("i", "<C-_>", "<C-o>u")
map("n", "_", "<C-o>")
map("n", "+", "<C-i>")
map("n", "Q", "q")
map("x", "@q", "<Cmd>normal! @q<CR>")
map("x", "@@", "<Cmd>normal! @@<CR>")
map("n", "U", "<Cmd>execute('earlier '. v:count1. 'f')<CR>")
map("x", "<", "<gv")
map("x", ">", ">gv")
map("n", "gp", "`[v`]")
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
map("n", "<C-f>", "<Cmd>call OrganizeImportsAndFormat()<CR>")
map("x", "<C-f>", "<Cmd>Neoformat<CR>")
map("i", "<leader>r", "<Esc><leader>r", {})
map("n", "<leader>r", "<Cmd>update <bar> execute funcs#get_run_command()<CR>")
map("", "<leader>y", '"+y')
map("n", "<leader>Y", '"+y$')
map(
    "n",
    "<leader>b",
    [[<Cmd>if !get(g:, 'nvim_tree_git_hl', 0) <bar> execute 'lua require("packer").loader("nvim-tree.lua")' <bar> sleep 100m <bar> endif <bar> NvimTreeFindFile<CR>]]
)
map("n", "<leader>B", "<Cmd>NvimTreeToggle<CR>")
map("n", "<leader>n", [[:let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>]], {noremap = true, silent = true})
map(
    "x",
    "<leader>n",
    [["xy:let @/=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g') <bar> set hlsearch<CR>]],
    {noremap = true, silent = true}
)
map("n", "<leader>u", "<Cmd>MundoToggle<CR>")
map("n", "<leader>v", "<Cmd>SymbolsOutline<CR>")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
map(
    "x",
    "<leader>s",
    [["xy:%s/<C-r>=substitute(escape(@x, '/\.*$^~['), '\n', '\\n', 'g')<CR>/<C-r>=substitute(escape(@x, '/\.*$^~[&'), '\n', '\\r', 'g')<CR>/gc<Left><Left><Left>]]
)
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
map(
    "n",
    "yoq",
    "empty(filter(getwininfo(), 'v:val.quickfix')) ? '<Cmd>copen<CR>' : '<Cmd>cclose<CR>'",
    {expr = true, noremap = true}
)
map(
    "n",
    "yol",
    "empty(filter(getwininfo(), 'v:val.loclist')) ? '<Cmd>lopen<CR>' : '<Cmd>lclose<CR>'",
    {expr = true, noremap = true}
)
map(
    "n",
    "yof",
    "winnr('$') > 1 ? '<Cmd>let g:temp = winsaveview() <bar> -tabedit %<CR><Cmd>call winrestview(g:temp) <bar> let b:is_zoomed = 1<CR>' : get(b:, 'is_zoomed', 0) ? '<Cmd>tabclose<CR>' : ''",
    {expr = true, noremap = true}
)
map("c", "<S-Del>", "<BS>")
map("c", "<Tab>", "'/?' =~ getcmdtype() ? '<C-g>' : '<C-z>'", {expr = true, noremap = true})
map("c", "<S-Tab>", "'/?' =~ getcmdtype() ? '<C-t>' : '<S-Tab>'", {expr = true, noremap = true})
map("c", "<C-Space>", [['/?' =~ getcmdtype() ? '.\{-}' : '<C-Space>']], {expr = true, noremap = true})
map(
    "c",
    "<BS>",
    [['/?' =~ getcmdtype() && '.\{-}' == getcmdline()[getcmdpos()-6:getcmdpos()-2] ? '<BS><BS><BS><BS><BS>' : '<BS>']],
    {expr = true, noremap = true}
)
-- nvim_bufferline
map("n", "<BS>", "<Cmd>BufferLineCyclePrev<CR>")
map("n", "\\", "<Cmd>BufferLineCycleNext<CR>")
map("n", "<C-w><BS>", "<Cmd>BufferLineMovePrev<CR><C-w>", {})
map("n", "<C-w>\\", "<Cmd>BufferLineMoveNext<CR><C-w>", {})
-- terminal
map("n", "<C-b>", "<Cmd>execute 'Ttoggle resize='. min([10, &lines * 2/5])<CR>")
map("n", "<leader>to", "<C-b>", {})
map("n", "<leader>tt", "<Cmd>tab Tnew<CR>")
map("n", "<leader>tO", "<Cmd>Tnew <bar> only<CR>")
map("n", "<leader>t<C-l>", "<Cmd>Tclear!<CR>")
map("n", "<leader>te", "<Plug>(neoterm-repl-send)", {})
map("n", "<leader>tee", "<Plug>(neoterm-repl-send-line)", {})
map("x", "<leader>te", "<Plug>(neoterm-repl-send)", {})
map("t", "<C-u>", "<C-\\><C-n>")
map("t", "<C-b>", "<Cmd>Ttoggle<CR>")
-- quickui
map("n", "K", "<Cmd>call v:lua.quickui_context_menu()<CR>")
map("n", "<CR>", "<Cmd>call quickui#menu#open('normal')<CR>")
map("x", "<CR>", "<Esc><Cmd>call quickui#menu#open('visual')<CR>")
map(
    "n",
    "<leader>tp",
    [[<Cmd>call quickui#terminal#open('zsh', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': ''})<CR>]]
)
map(
    "n",
    "<C-o>",
    [[<Cmd>let g:lf_selection_path = tempname() <bar> call quickui#terminal#open('sh -c "lf -last-dir-path=\"$HOME/.cache/lf_dir\" -selection-path='. fnameescape(g:lf_selection_path). ' \"'. expand('%'). '\""', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': 'funcs#lf_edit_callback'})<CR>]]
)
-- kommentary
map("n", "gc", "<Plug>kommentary_motion_default", {})
map("n", "gcc", "<Plug>kommentary_line_default", {})
map("x", "gc", "<Plug>kommentary_visual_default<Esc>", {})
map("o", "gc", ":<C-u>call plugins#commentary#textobject(get(v:, 'operator', '') ==# 'c')<CR>") -- vim-commentary text object
-- miniyank
map("", "p", "<Plug>(miniyank-autoput)", {})
map("", "P", "<Plug>(miniyank-autoPut)", {})
map("n", "<leader>p", "<Plug>(miniyank-cycle)", {})
map("x", "<leader>p", '"0p')
map("n", "<leader>P", "<Plug>(miniyank-cycleback)", {})
map("x", "<leader>P", '"0P')
map("n", "=v", "<Plug>(miniyank-tochar)", {})
map("n", "=V", "<Plug>(miniyank-toline)", {})
map("n", "=<C-v>", "<Plug>(miniyank-toblock)", {})
-- visualmulti
map("n", "<C-n>", "<Plug>(VM-Find-Under)", {})
map("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", {})
-- hop
map("", "'", "<Cmd>HopChar1<CR>")
map("", "q", "<Cmd>HopWord<CR>")
map("", "<leader>e", "<Cmd>HopWordCurrentLine<CR>")
map("", "<leader>j", "<Cmd>HopLineAC<CR>")
map("", "<leader>k", "<Cmd>HopLineBC<CR>")
-- vim-matchup
map("n", "<leader>c", "<Cmd>MatchupWhereAmI<CR>", {})
-- fanfingtastic
map("", "f", "<Plug>fanfingtastic_f", {})
map("", "F", "<Plug>fanfingtastic_F", {})
map("", "t", "<Plug>fanfingtastic_t", {})
map("", "T", "<Plug>fanfingtastic_T", {})
map("", ",", "<Plug>fanfingtastic_;", {})
map("", ";,", "<Plug>fanfingtastic_,", {})
-- wordmotion
map("", "gw", "<Plug>WordMotion_w", {})
map("", "gb", "<Plug>WordMotion_b", {})
map("", "ge", "<Plug>WordMotion_e", {})
map("o", "u", "<Plug>WordMotion_w", {})
map("o", "iu", "<Plug>WordMotion_iw", {})
map("x", "iu", "<Plug>WordMotion_iw", {})
map("o", "au", "<Plug>WordMotion_aw", {})
map("x", "au", "<Plug>WordMotion_aw", {})
-- sandwich
map("n", "ys", "<Plug>(operator-sandwich-add)", {})
map("n", "yss", "<Plug>(operator-sandwich-add)iw", {})
map("n", "yS", "ysg_", {})
map(
    "n",
    "ds",
    "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
    {}
)
map(
    "n",
    "dss",
    "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
    {}
)
map(
    "n",
    "cs",
    "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
    {}
)
map(
    "n",
    "css",
    "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
    {}
)
map("x", "s", "<Plug>(operator-sandwich-add)", {})
map("x", "s<", "<Plug>(operator-sandwich-add)t", {})
-- vim-swap
map("o", "ia", "<Plug>(swap-textobject-i)", {})
map("x", "ia", "<Plug>(swap-textobject-i)", {})
map("o", "aa", "<Plug>(swap-textobject-a)", {})
map("x", "aa", "<Plug>(swap-textobject-a)", {})
map("n", "g<", "<Plug>(swap-prev)", {})
map("n", "g>", "<Plug>(swap-next)", {})
map("n", "gs", "<Plug>(swap-interactive)", {})
map("x", "gs", "<Plug>(swap-interactive)", {})
-- vim-expand-region
map("x", "v", "<Plug>(expand_region_expand)", {})
map("x", "<BS>", "<Plug>(expand_region_shrink)", {})
-- tmux-navigator
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
-- telescope
-- TODO multi select issue https://github.com/nvim-telescope/telescope.nvim/issues/416
map("n", "<C-p>", "<Cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>")
map("n", "<leader>fs", "<C-p>", {})
map("n", "<leader>fm", "<Cmd>lua require('telescope.builtin').oldfiles({include_current_session = true})<CR>")
map("n", "<leader>fb", "<Cmd>lua require('telescope.builtin').buffers()<CR><Esc>")
map(
    "n",
    "<leader>fu",
    "<Cmd>lua require('telescope.builtin')[next(vim.lsp.buf_get_clients()) == nil and 'treesitter' or 'lsp_document_symbols']()<CR>"
)
map("n", "<leader>fU", "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>")
map("n", "<leader>fg", ":GrepRegex ")
map("x", "<leader>fg", ":<C-u>GrepRegex <C-r>=funcs#get_visual_selection()<CR>")
map("n", "<leader>fj", ":GrepRegex \\b<C-r>=expand('<cword>')<CR>\\b<CR>", {noremap = true, silent = true})
map("x", "<leader>fj", ":<C-u>GrepNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>", {noremap = true, silent = true})
map("n", "<leader>fq", "<Cmd>lua require('telescope.builtin').quickfix()<CR>")
map("n", "<leader>fl", "<Cmd>lua require('telescope.builtin').loclist()<CR>")
map("n", "<leader>fL", "<Cmd>lua require('telescope.builtin').live_grep()<CR>")
map("n", "<leader>fa", "<Cmd>lua require('telescope.builtin').commands()<CR>")
map("n", "<leader>ft", "<Cmd>lua require('telescope.builtin').filetypes()<CR>")
map("n", "<leader>ff", "<Cmd>lua require('telescope.builtin').builtin()<CR>")
map("n", "<leader>f/", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
map("n", "<leader>fr", "<Cmd>lua require('telescope.builtin').registers()<CR>")
map("n", "<leader>fh", "<Cmd>lua require('telescope.builtin').command_history()<CR>")
map("n", "<leader>fy", "<Cmd>lua require('telescope').extensions.yank.history()<CR>")
map("n", "<leader>fM", "<Cmd>lua require('telescope').extensions.projects.projects()<CR>")
-- lsp
map(
    "n",
    "gd",
    "<Cmd>lua if next(vim.lsp.buf_get_clients()) == nil then vim.cmd('normal! gd') else vim.lsp.buf.definition() end<CR>"
)
map("n", "gD", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
map("n", "<leader>d", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<leader>a", "<Cmd>CodeActionMenu<CR>")
map("x", "<leader>a", ":<C-u>CodeActionMenu<CR>")
map(
    "n",
    "gh",
    "<Cmd>lua if vim.diagnostic.open_float(0, {scope = 'line', border = 'rounded'}) == nil then vim.lsp.buf.hover() end<CR>"
)
map("n", "<leader>R", "<Cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "[a", "<Cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded'}})<CR>")
map("n", "]a", "<Cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded'}})<CR>")
map("i", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
-- }}}

-- overrides {{{
if fn.glob(fn.stdpath("config") .. "/lua/packer_compiled.lua") == "" then
    require("plugins").compile()
else
    cmd [[
        command! PackerInstall lua require('plugins').install()
        command! PackerUpdate lua require('plugins').update()
        command! PackerSync lua require('plugins').sync()
        command! PackerClean lua require('plugins').clean()
        command! PackerCompile lua require('plugins').compile()
        command! PackerStatus lua require('plugins').status()
        command! -bang -nargs=+ -complete=customlist,v:lua.require('packer').loader_complete PackerLoad lua require('packer').loader(<f-args>, '<bang>' == '!')
    ]]
    require("packer_compiled")
end
vim.notify = function(...)
    require("packer").loader("nvim-notify")
    vim.notify = require("notify")
    vim.notify(...)
end
vim.paste =
    (function(overridden)
    return function(lines, phase)
        if (phase == -1 or phase == 1) and fn.mode() == "i" and not vim.o.paste then
            cmd("let &undolevels = &undolevels") -- resetting undolevels breaks undo
        end
        overridden(lines, phase)
    end
end)(vim.paste)
if vim.env.SSH_CLIENT ~= nil then -- ssh session
    fn["funcs#map_copy_with_osc_yank"]()
elseif fn.has("macunix") ~= 1 then -- WSL Vim
    fn["funcs#map_copy_to_win_clip"]()
end
-- }}}

-- delayed plugins {{{
local fsize = fn.getfsize(fn.expand("%:p:f"))
if fsize == nil or fsize < 1048576 then -- 1MB
    vim.schedule(
        function()
            vim.defer_fn(
                function()
                    local plugins = {
                        "nvim-treesitter",
                        "nvim-treesitter-textobjects",
                        "nvim-lsp-installer"
                    }
                    require("packer").loader(table.concat(plugins, " "))
                end,
                30
            )
            vim.defer_fn(
                function()
                    local plugins = {
                        "indent-blankline.nvim",
                        "plenary.nvim",
                        "gitsigns.nvim",
                        "conflict-marker.vim",
                        "vim-sleuth",
                        "quick-scope",
                        "vim-wordmotion", -- motions/text objects sometimes don't work if loaded on keys
                        "vim-sandwich",
                        "vim-fanfingtastic",
                        "vim-matchup"
                    }
                    require("packer").loader(table.concat(plugins, " "))
                end,
                100
            )
        end
    )
end
-- }}}
-- vim:foldmethod=marker
