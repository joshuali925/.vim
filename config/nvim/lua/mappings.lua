local map = require("utils").map

local function map_text_object(char)
    map("x", "i" .. char, ":<C-u>normal! T" .. char .. "vt" .. char .. "<CR>", {noremap = true, silent = true})
    map("o", "i" .. char, "<Cmd>normal vi" .. char .. "<CR>", {noremap = true, silent = true})
    map("x", "a" .. char, ":<C-u>normal! T" .. char .. "vf" .. char .. "<CR>", {noremap = true, silent = true})
    map("o", "a" .. char, "<Cmd>normal va" .. char .. "<CR>", {noremap = true, silent = true})
end

-- custom text objects
local text_objects = {"<Space>", "_", ".", ":", ",", ";", "<bar>", "/", "<bslash>", "*", "+", "-", "#", "=", "&"}
for i = 1, #text_objects do
    map_text_object(text_objects[i])
end
map("x", "il", "^og_")
map("o", "il", "<Cmd>normal vil<CR>")
map("x", "al", "0o$")
map("o", "al", "<Cmd>normal val<CR>")

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
map("i", "<Home>", "<C-o>g^")
map("i", "<End>", "<C-o>g$")
map("i", "<C-_>", "<C-o>u")
map("n", "_", "<C-o>")
map("n", "+", "<C-i>")
map("n", "Q", "q")
map("x", "@q", "<Cmd>normal! @q<CR>")
map("x", "@@", "<Cmd>normal! @@<CR>")
map("n", "Y", "y$")
map("x", "<", "<gv")
map("x", ">", ">gv")
map("n", "gp", "`[v`]")
map("n", "cr", "<Cmd>call funcs#edit_register()<CR>")
map("n", "Z[", "<Cmd>BufferLineCloseLeft<CR>")
map("n", "Z]", "<Cmd>BufferLineCloseRight<CR>")
map("n", "gx", "<Cmd>call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>")
map("x", "gx", ":<C-u>call netrw#BrowseX(expand(funcs#get_visual_selection()), netrw#CheckIfRemote())<CR>")
map(
    "n",
    "<C-c>",
    "<Cmd>execute 'ColorizerAttachToBuffer' | nohlsearch <bar> silent! AsyncStop!<CR><Cmd>lua require('gitsigns').refresh()<CR>:echo<CR>"
)
map("i", "<C-c>", "<Esc>")
map("x", "<C-c>", "<Esc>")
map("n", "<C-w><C-c>", "<Esc>")
map("n", "<C-w><", "<C-w><<C-w>", {})
map("n", "<C-w>>", "<C-w>><C-w>", {})
map("n", "<C-w>+", "<C-w>+<C-w>", {})
map("n", "<C-w>-", "<C-w>-<C-w>", {})
map("n", "<C-f>", "<Cmd>Neoformat<CR>")
map("x", "<C-f>", "<Cmd>Neoformat<CR>")
map("i", "<leader>r", "<Esc><leader>r", {})
map("n", "<leader>r", "<Cmd>update <bar> execute funcs#get_run_command()<CR>")
map("", "<leader>y", '"+y')
map("n", "<leader>Y", '"+y$')
map("n", "<leader>b", "<Cmd>NvimTreeToggle<CR>")
map("n", "<leader>B", "<Cmd>NvimTreeFindFile<CR>")
map("n", "<leader>n", [[:let @/='\<<C-r><C-w>\>' <bar> set hlsearch<CR>]], {noremap = true, silent = true})
map(
    "x",
    "<leader>n",
    [["xy:let @/='\V'. substitute(escape(@x, '\'), '\n', '\\n', 'g') <bar> set hlsearch<CR>]],
    {noremap = true, silent = true}
)
map("n", "<leader>u", "<Cmd>MundoToggle<CR>")
map("n", "<leader>v", "<Cmd>SymbolsOutline<CR>")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
map("x", "<leader>s", [["xy:%s/<C-r>x/<C-r>x/gc<Left><Left><Left>]])
map("n", "<leader>l", "<Cmd>call funcs#print_curr_vars(0, 0)<CR>")
map("x", "<leader>l", "<Cmd>call funcs#print_curr_vars(1, 0)<CR>")
map("n", "<leader>L", "<Cmd>call funcs#print_curr_vars(0, 1)<CR>")
map("x", "<leader>L", "<Cmd>call funcs#print_curr_vars(1, 1)<CR>")
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
    "empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'",
    {expr = true, noremap = true}
)
map(
    "n",
    "yol",
    "empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'",
    {expr = true, noremap = true}
)
map(
    "n",
    "yof",
    "winnr('$') > 1 ? '<Cmd>let g:temp = winsaveview() <bar> -tabedit %<CR><Cmd>call winrestview(g:temp) <bar> let b:is_zoomed = 1<CR>' : get(b:, 'is_zoomed', 0) ? '<Cmd>tabclose<CR>' : ''",
    {expr = true, noremap = true}
)
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
map("n", "<leader>tt", "<Cmd>Tnew<CR>")
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
    [[<Cmd>let g:lf_selection_path = tempname() <bar> call quickui#terminal#open('sh -c "lf -last-dir-path=\"$HOME/.cache/lf_dir\" -selection-path='. shellescape(g:lf_selection_path). ' \"'. expand('%'). '\""', {'h': &lines * 3/4, 'w': &columns * 4/5, 'line': &lines * 1/8, 'callback': 'funcs#lf_edit_callback'})<CR>]]
)

-- kommentary
map("n", "gc", "<Plug>kommentary_motion_default", {})
-- map("n", "gcc", "<Plug>kommentary_line_default", {}) -- doesn't repeat https://github.com/b3nj5m1n/kommentary/issues/41
map("n", "gcc", "<Plug>kommentary_motion_defaultl", {})
map("x", "gc", "<Plug>kommentary_visual_default<Esc>", {})

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
map("", "<leader>j", "<Cmd>HopLine<CR>")
map("", "<leader>k", "<Cmd>HopLine<CR>")

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
map(
    "n",
    "<C-p>",
    "<Cmd>lua require('telescope.builtin').find_files({hidden = true, cwd = require('lspconfig.util').root_pattern('.git')(vim.fn.expand('%:p'))})<CR>"
)
map("n", "<leader>fs", "<C-p>", {})
map(
    "n",
    "<leader>fd",
    "<Cmd>lua require('telescope.builtin').file_browser({cwd = vim.fn.expand('%:h'), hidden = true})<CR>"
)
map("n", "<leader>fm", "<Cmd>lua require('telescope.builtin').oldfiles({include_current_session = true})<CR>")
map("n", "<leader>fb", "<Cmd>lua require('telescope.builtin').buffers()<CR>")
map(
    "n",
    "<leader>fu",
    "<Cmd>lua require('telescope.builtin')[next(vim.lsp.buf_get_clients()) == nil and 'treesitter' or 'lsp_document_symbols']()<CR>"
)
map("n", "<leader>fU", "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>")
-- TODO visual grep pending on https://github.com/neovim/neovim/pull/13896, https://github.com/nvim-telescope/telescope.nvim/pull/494
map("n", "<leader>fg", ":lua require('utils').telescope_grep(true, [[]])<Left><Left><Left>", {noremap = true})
map(
    "x",
    "<leader>fg",
    ":<C-u>lua require('utils').telescope_grep(false, [[<C-r>=funcs#get_visual_selection()<CR>]])<Left><Left><Left>",
    {noremap = true}
)
map(
    "n",
    "<leader>fj",
    ":lua require('utils').telescope_grep(true, [[\\b<C-r>=expand('<cword>')<CR>\\b]])<CR>",
    {noremap = true, silent = true}
)
map(
    "x",
    "<leader>fj",
    ":lua require('utils').telescope_grep(false, [[<C-r>=funcs#get_visual_selection()<CR>]])<CR>",
    {noremap = true, silent = true}
)
map("n", "<leader>fq", "<Cmd>lua require('telescope.builtin').quickfix()<CR>")
map("n", "<leader>fl", "<Cmd>lua require('telescope.builtin').loclist()<CR>")
map(
    "n",
    "<leader>fL",
    "<Cmd>lua require('telescope.builtin').live_grep({cwd = require('lspconfig.util').root_pattern('.git')(vim.fn.expand('%:p'))})<CR>",
    {noremap = true, silent = true}
)
map("n", "<leader>fa", "<Cmd>lua require('telescope.builtin').commands()<CR>")
map("n", "<leader>ft", "<Cmd>lua require('telescope.builtin').filetypes()<CR>")
map("n", "<leader>ff", "<Cmd>lua require('telescope.builtin').builtin()<CR>")
map("n", "<leader>f/", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
map("n", "<leader>fr", "<Cmd>lua require('telescope.builtin').registers()<CR>")
map("n", "<leader>fh", "<Cmd>lua require('telescope.builtin').command_history()<CR>")
map("n", "<leader>fy", "<Cmd>lua require('telescope').extensions.yank.history()<CR>")

-- lsp
map(
    "n",
    "gd",
    "<Cmd>lua if next(vim.lsp.buf_get_clients()) == nil then vim.cmd('normal! gd') else vim.lsp.buf.definition() end<CR>"
)
map("n", "<leader>d", "<Cmd>lua require('lspsaga.provider').preview_definition()<CR>")
map("n", "gR", "<Cmd>lua vim.lsp.buf.references()<CR>")
map("n", "gr", "<Cmd>TroubleToggle lsp_references<CR>")
map("n", "<leader>a", "<Cmd>lua require('lspsaga.codeaction').code_action()<CR>")
map("x", "<leader>a", ":<C-u>lua require('lspsaga.codeaction').range_code_action()<CR>")
map("n", "gh", "<Cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>")
map("n", "<leader>R", "<Cmd>lua require('lspsaga.rename').rename()<CR>")
map("n", "[a", "<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>")
map("n", "]a", "<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>")
map("n", "<leader>tb", "<Cmd>TroubleToggle<CR>")
map("n", "<leader>td", "<Cmd>TroubleToggle lsp_workspace_diagnostics<CR>")
