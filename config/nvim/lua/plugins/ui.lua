return {
    {
        "folke/sidekick.nvim", -- TODO try https://github.com/carlos-algms/agentic.nvim
        enabled = vim.env.Q_SSO_URL ~= nil or vim.uv.fs_stat(vim.env.HOME .. "/.claude.json") ~= nil,
        keys = {
            { "<leader>c", "<Cmd>lua require('sidekick.cli').toggle({name = 'claude'})<CR>" },
            { "<leader>c", "<Cmd>lua require('sidekick.cli').send({name = 'claude', msg = '{this}'})<CR>", mode = { "x" } },
            { "<leader>h", "<Cmd>lua require('sidekick.cli').toggle({name = 'kiro'})<CR>" },
            { "<leader>h", "<Cmd>lua require('sidekick.cli').send({name = 'kiro', msg = '{this}'})<CR>", mode = { "x" } },
        },
        opts = {
            cli = {
                tools = {
                    claude = { cmd = { "claude", "--allow-dangerously-skip-permissions" } },
                    kiro = { cmd = { "kiro-cli", "chat", "--trust-all-tools" }, format = function(text, str) return str:gsub("@", "") end },
                },
                win = {
                    split = { width = 0.4 },
                    keys = {
                        buffers = { "<C-p>", "buffers", mode = "nt", desc = "open buffer picker" },
                        prompt = { "<C-b>", "prompt", mode = "t", desc = "insert prompt or context" },
                    },
                },
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = "MunifTanjim/nui.nvim",
        keys = { { "<leader>b", function()
            for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local success, source_name = pcall(vim.api.nvim_buf_get_var, vim.api.nvim_win_get_buf(winid), "neo_tree_source")
                if success then
                    if source_name ~= "filesystem" then return vim.api.nvim_set_current_win(winid) end
                    break
                end
            end
            vim.cmd.Neotree("reveal_force_cwd")
        end }, { "gO", "<Cmd>Neotree source=document_symbols<CR>" } },
        config = function()
            local function get_dir(state)
                local node = state.tree:get_node()
                local path = node.type == "file" and node:get_parent_id() or node.path
                return require("plenary").path:new(path):make_relative()
            end
            local events = require("neo-tree.events")
            local function on_move(data)
                require("snacks").rename.on_rename_file(data.source, data.destination)
            end
            require("neo-tree").setup({
                default_component_configs = { icon = { default = "" } },
                close_if_last_window = true,
                source_selector = {
                    winbar = true,
                    statusline = false,
                    sources = {
                        { source = "filesystem", display_name = " 󰉓 File " },
                        { source = "buffers", display_name = " 󰈚 Buf " },
                        { source = "git_status", display_name = " 󰊢 Git " },
                        { source = "document_symbols", display_name = "  Tag " },
                    },
                },
                window = {
                    mappings = {
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["<BS>"] = "prev_source",
                        ["\\"] = "next_source",
                        ["P"] = { "toggle_preview", config = { use_float = true } },
                        ["s"] = "open_split",
                        ["<C-v>"] = "open_vsplit",
                        ["zM"] = "close_all_nodes",
                        ["zR"] = "expand_all_nodes",
                        ["R"] = "rename",
                        ["r"] = "refresh",
                        ["x"] = "delete",
                        ["d"] = "cut_to_clipboard",
                        ["<C-b>"] = { function(state) require("snacks.terminal").open(nil, { cwd = get_dir(state) }) end, desc = "open_term_at_node" },
                        ["<C-p>"] = {
                            function(state) require("snacks.picker").files({ cwd = get_dir(state) }) end,
                            desc = "find_files_at_node",
                        },
                        ["t"] = {
                            function(state) require("snacks.picker").files({ cwd = get_dir(state) }) end,
                            desc = "find_files_at_node",
                        },
                        ["T"] = {
                            function(state) require("snacks.picker").files({ cwd = get_dir(state), ignored = true }) end,
                            desc = "find_files_no_ignore_at_node",
                        },
                        ["<leader>f/"] = { function(state) require("snacks.picker").grep({ cwd = get_dir(state) }) end, desc = "live_grep_at_node" },
                        ["z"] = "none",
                        ["H"] = "none",
                        ["/"] = "none",
                    },
                },
                filesystem = {
                    filtered_items = { hide_dotfiles = false, hide_gitignored = false, hide_hidden = false },
                    group_empty_dirs = true,
                    scan_mode = "deep",
                    hijack_netrw_behavior = "disabled",
                    window = { mappings = { ["-"] = "navigate_up", ["C"] = "set_root" } },
                },
                buffers = { window = { mappings = { ["-"] = "navigate_up", ["C"] = "set_root" } } },
                git_status = { group_empty_dirs = true },
                document_symbols = { window = { mappings = { ["x"] = "none", ["d"] = "none" } } },
                sources = { "filesystem", "buffers", "git_status", "document_symbols" },
                event_handlers = {
                    { event = events.FILE_MOVED, handler = on_move },
                    { event = events.FILE_RENAMED, handler = on_move },
                },
            })
        end,
    },
    {
        "skywind3000/vim-quickui",
        keys = {
            { "<CR>", "<Cmd>call quickui#menu#open('normal')<CR>" },
            { "<CR>", "<Esc><Cmd>Lazy load vim-quickui <bar> call quickui#menu#open('visual')<CR>", mode = "x" },
        },
        init = function()
            vim.g.quickui_show_tip = 1
            vim.g.quickui_border_style = 2
        end,
        config = function()
            vim.api.nvim_set_hl(0, "QuickBG", { link = "CursorLine" })
            vim.fn["quickui#menu#switch"]("normal")
            vim.fn["quickui#menu#reset"]()
            vim.fn["quickui#menu#install"]("&Actions", {
                { "Insert time", [[put=strftime('%x %X')]], "Insert MM/dd/yyyy hh:mm:ss tt" },
                { "Insert line", [[execute "lua require('lazy').load({plugins = 'kommentary'})" | execute "normal! o\<Space>\<BS>\<Esc>55a=" | execute "normal \<Plug>kommentary_line_default"]], "Insert a dividing line" },
                { "&Trim spaces", [[keeppatterns %s/\s\+$//e | silent! execute "normal! ``"]], "Remove trailing spaces" },
                { "Squeeze blank lines", [[keeppatterns %s/\v(\n\n)\n+/\1/e | silent! execute "normal! ``"]], "Reduce consecutive blank lines" },
                { "Ded&up lines", [[%!awk '\!x[$0]++']], "Remove duplicated lines and preserve order" },
                { "Du&plicated lines", [[sort | let @/ = '\C^\(.*\)$\n\1$' | set hlsearch]], "Sort and search duplicated lines" },
                { "Calculate line &=", [[let @x = getline(".")[max([0, matchend(getline("."), ".*=")]):] | execute "normal! A = \<C-r>=\<C-r>x\<CR>"]], "Calculate expression from previous '=' or current line" },
                { "--", "" },
                { "&Word count", [[call feedkeys("g\<C-g>")]], "Show document details" },
                { "Cou&nt search", [[echo searchcount({'maxcount': 0})]], "Count occurrences of current search pattern (:%s/pattern//gn also works)" },
                { "&Yank search matches", [[let @x = '' | %s//\=setreg('X', submatch(0), 'V')/gn | let @" = @x | let @x = '']], "Copy all strings matching current search pattern" },
                { "Search non-ascii", [[let @/ = '[^\d0-\d127]' | set hlsearch]], [[Search all non-ascii characters, in command line: rg '[^\x00-\x7F]']] },
                { "Search for red '&!'", [[RgNoRegex ❗]], [[Search for '❗' symbol]] },
                { "Search in &buffers", [[execute 'cexpr []' | call feedkeys(":bufdo vimgrepadd //g % | only | copen\<Home>\<S-Right>\<S-Right>\<Right>\<Right>", "n")]], "Search a pattern in all buffers, add to quickfix" },
                { "Fold unmatched lines", [[setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2 foldmethod=manual]], "Fold lines that don't have a match for the current search phrase" },
                { "&Diff unsaved", [[execute "diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype=" . &filetype . " | read ++edit # | 0d_ | diffthis"]], "Diff current buffer with file on disk (similar to DiffOrig command)" },
                { "Diff next buffer", [[execute &diff ? "windo diffoff" : len(filter(nvim_list_wins(), 'nvim_win_get_config(v:val).relative == ""')) == 1 ? "vsplit | bnext | windo diffthis" : "windo diffthis"]], "Toggle diff in current tab, split next buffer if only one window" },
                { "Diff directories", [[call feedkeys(":CodeDiff dir ", "n")]], "Run DirDiff to compare two directories" }, -- TODO(0.12) https://www.reddit.com/r/neovim/comments/1ov1gtr/difftool_wrapper/
                { "--", "" },
                { "Move tab left &-", [[-tabmove]] },
                { "Move tab right &+", [[+tabmove]] },
                { "&Refresh screen", [[execute "silent GuessIndent" | execute "ScrollViewRefresh | nohlsearch | syntax sync fromstart | diffupdate | let @/=\"QWQ\" | normal! \<C-l>"]], "Clear search, refresh screen, scrollbar and colorizer" },
                { "--", "" },
                { "Open d&ashboard", [[lua require("snacks.dashboard")()]], "Open dashboard" },
                { "&Save session", [[call feedkeys(":SessionSave", "n")]], "Save session to .cache/nvim/session_<name>.vim, will overwrite" },
                { "Load s&ession", [[call feedkeys(":SessionLoad", "n")]], "Load session from .cache/nvim/session_<name>.vim" },
                { "--", "" },
                { "Edit Vimr&c", [[edit ~/.vim/config/nvim/init.lua]] },
                { "GB18030 to utf-8", [[edit ++enc=GB18030 | set fileencoding=utf8]], "Edit as GB18030 (edit ++enc=GB18030) for Chinese characters and reset file format back to utf-8" },
                { "Open in &VSCode", [[execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!]] },
            })
            vim.fn["quickui#menu#install"]("&Git", {
                { "Git checko&ut ref", [[call feedkeys(":Git restore --source=@ -- %\<Left>\<Left>\<Left>\<Left>\<Left>", "n")]], "Show current file from ref" },
                { "Git &blame", [[lua require("gitsigns").blame()]], "Git blame of current file" },
                { "Git &change base", [[call feedkeys(":Gitsigns change_base @^ true\<Left>\<Left>\<Left>\<Left>\<Left>", "n")]], "Gitsigns show hunk based on ref" },
                { "Git reset base", [[lua require("gitsigns").reset_base(true)]], "Gitsigns reset changed base" },
                { "--", "" },
                { "Git &diff", [[call feedkeys(":CodeDiff file @", "n")]], "Diff current file with ref" },
                { "Git &toggle deleted", [[lua require("gitsigns").toggle_deleted()]], "Show deleted lines with gitsigns" },
                { "Git toggle &word diff", [[lua require("gitsigns").toggle_word_diff()]], "Show word diff with gitsigns" },
                { "Git &file history", [[CodeDiff history %]], "Browse previously committed versions of current file" },
                { "Git file l&og", [[Git log --graph --pretty=plain -- %]], "Show git log for current file using mini.git" },
                { "--", "" },
                { "&View diff page", [[CodeDiff]], "Diff repo" },
                { "Open changed files (&!)", [[call feedkeys(":argadd `git diff --name-only --diff-filter=d @`\<Left>", "n")]], "Open modified files against ref" },
                { "Git &issues", [[lua require("snacks.picker").gh_issue({state = "all"})]], "Pick GitHub issues" },
                { "Git &PRs", [[lua require("snacks.picker").gh_pr({state = "all"})]], "Pick GitHub pull requests" },
            })
            vim.fn["quickui#menu#install"]("&Format", {
                { "Fold with &treesitter", [[setlocal foldexpr=v:lua.vim.treesitter.foldexpr()]], "Use treesitter to fold, this can be slow" },
                { "&Venn ascii draw", [[lua require("utils").toggle_venn()]], "Toggle venn.nvim, use HJKL to draw arrow, select area and use v to draw box" },
                { "--", "" },
                { "Table &mode", [[TableModeToggle]], "Toggle TableMode" },
                { "&Reformat table", [[TableModeRealign]], "Reformat table" },
                { "&Format to table", [[Tableize]], "Format to table, use <leader>T to set delimiter" },
                { "Delete row", [[execute "normal \<Plug>(table-mode-delete-row)"]], "Delete row" },
                { "Delete column", [[execute "normal \<Plug>(table-mode-delete-column)"]], "Delete column" },
                { "Show cell &position", [[execute "normal \<Plug>(table-mode-echo-cell)"]], "Show cell index number" },
                { "&Add formula", [[TableAddFormula]], "Add formula to current cell, i.e. Sum(r1,c1:r2,c2)" },
                { "&Evaluate formula", [[TableEvalFormulaLine]], "Evaluate formula" },
            })
            vim.fn["quickui#menu#install"]("L&SP", {
                { "Workspace &diagnostics", [[lua require("lsp").quickfix_all_diagnostics()]], "Show workspace diagnostics in quickfix (run :bufdo edit<CR> to load all buffers)" },
                { "Workspace warnings and errors", [[lua require("lsp").quickfix_all_diagnostics(vim.diagnostic.severity.WARN)]], "Show workspace warnings and errors in quickfix" },
                { "&Yank diagnostics", [[lua vim.fn.setreg("+", require("lsp").get_diagnostics_in_buffers()); vim.notify("Copied warnings and errors")]], "Copy warnings and errors in open buffers" },
                { "--", "" },
                { "&Toggle diagnostics", [[lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())]], "Toggle LSP diagnostics" },
                { "Toggle virtual lines", [[lua vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })]], "Toggle LSP diagnostic virtual lines" },
                { "Toggle virtual text", [[lua vim.diagnostic.config({ virtual_text = { prefix = "●", current_line = not vim.diagnostic.config().virtual_text.current_line } })]], "Toggle LSP diagnostic virtual lines" },
                { "Toggle &inlay hints", [[lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())]], "Toggle LSP inlay hints" },
                { "--", "" },
                { "Show folders in workspace", [[lua vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))]], "Show folders in workspace for LSP" },
                { "Add folder to workspace", [[lua vim.lsp.buf.add_workspace_folder()]], "Add folder to workspace for LSP" },
                { "Remove folder from workspace", [[lua vim.lsp.buf.remove_workspace_folder()]], "Remove folder from workspace for LSP" },
                { "--", "" },
                { "Clear LSP logs", [[lua vim.fn.writefile({}, vim.lsp.get_log_path())]], "Empty lsp.log" },
            })
            vim.fn["quickui#menu#install"]("&Packages", {
                { "Lazy &packages", [[Lazy]], "Lazy packages" },
                { "Lazy clean", [[Lazy clean]], "Lazy clean plugins" },
                { "Lazy &update", [[Lazy update]], "Lazy update plugins" },
                { "--", "" },
                { "Ma&son packages", [[Mason]], "Mason packages" },
                { "Mason &install", [[lua require('lsp').install_packages()]], "Install commonly used servers, linters, and formatters" },
            })
            local quickui_theme_list = {}
            local used_chars = "hjklqg"
            local category = "(Dark) "
            local theme_list = require("themes").theme_list
            local keys = {}
            for index in pairs(theme_list) do
                table.insert(keys, index)
            end
            table.sort(keys)
            local len_negative = math.abs(keys[1])
            for i = 1, len_negative / 2 do -- reverse negative keys
                keys[i], keys[len_negative - i + 1] = keys[len_negative - i + 1], keys[i]
            end
            for _, index in ipairs(keys) do
                local theme = theme_list[index]
                if index == 0 then
                    table.insert(quickui_theme_list, { "--", "" })
                    category = "(Light) "
                end
                local hint_pos = vim.regex("\\c[^" .. used_chars .. "]"):match_str(theme)
                local display = theme
                if hint_pos ~= nil then
                    used_chars = used_chars .. theme:sub(hint_pos + 1, hint_pos + 1)
                    display = theme:sub(1, hint_pos) .. "&" .. theme:sub(hint_pos + 1)
                end
                table.insert(quickui_theme_list, { category .. display, string.format("lua require('themes').switch(%s)", index) })
            end
            vim.fn["quickui#menu#install"]("&Colors", quickui_theme_list)
            vim.fn["quickui#menu#switch"]("visual")
            vim.fn["quickui#menu#reset"]()
            vim.fn["quickui#menu#install"]("&Actions", {
                { "&Minimize JSON", [['<,'>!jq -c .]], "Use jq to minimize selected JSON" },
                { "Base64 &encode", [[execute "lua vim.fn.setreg('x', vim.base64.encode(require('utils').get_visual_selection()))" | execute 'S put x' | file base64_encode]], "Use base64 to encode selected text" },
                { "Base&64 decode", [[lua local temp = require("utils").base64_decode(require("utils").get_visual_selection()); vim.cmd.S(); vim.api.nvim_put(temp, "", false, true); vim.api.nvim_buf_set_name(0, "base64_decode"); temp = nil]], "Decode selected text with base64" },
                { "Generate &snippet", [[let @x = substitute(escape(funcs#get_visual_selection(), '"$'), repeat(' ', &shiftwidth), '\\t', 'g') | execute 'S put x' | execute '%normal! gI"' | execute '%normal! A",' | execute 'normal! Gdd$x' | file snippet_body]], "Generate vscode compatible snippet body from selected text" },
                { "&Delete comments", [[lua require("utils").delete_comments(vim.fn.line("'<"), vim.fn.line("'>"))]], "Delete comments from selected lines" },
                { "--", "" },
                { "Search in &buffers", [[execute 'cexpr []' | execute 'bufdo vimgrepadd /' . substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g') . '/g %' | copen]], "Grep current search pattern in all buffers, add to quickfix" },
            })
            vim.fn["quickui#menu#install"]("&Git", {
                { "Git &file history", [[lua require("mini.git").show_range_history({ line_start = vim.fn.line("'<"), line_end = vim.fn.line("'>"), log_args = { "--follow" } })]], "Browse previously committed versions of selected lines" },
            })
            vim.fn["quickui#menu#install"]("Ta&bles", {
                { "Reformat table", [['<,'>TableModeRealign]], "Reformat table" },
                { "Format to table", [['<,'>Tableize]], "Format to table, use <leader>T to set delimiter" },
                { "--", "" },
                { "Sort asc", [['<,'>sort]], "Sort in ascending order (sort)" },
                { "Sort desc", [['<,'>sort!]], "Sort in descending order (sort!)" },
                { "Sort num asc", [['<,'>sort n]], "Sort numerically in ascending order (sort n)" },
                { "Sort num desc", [['<,'>sort! n]], "Sort numerically in descending order (sort! n)" },
            })
        end,
    },
}
