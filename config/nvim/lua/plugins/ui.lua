return {
    {
        "simnalamburt/vim-mundo",
        keys = { { "<leader>u", "<Cmd>MundoToggle<CR>" } },
        config = function()
            vim.g.mundo_preview_bottom = 1
            vim.g.mundo_width = 30
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "TermExec" },
        keys = {
            { "<C-b>", "<Cmd>ToggleTerm<CR>" },
            { "<leader>to", "<Cmd>execute 'ToggleTerm dir=' . expand('%:p:h')<CR>" },
            { "<leader>tv", "<Cmd>execute 'ToggleTerm direction=vertical size=' . &columns / 2<CR>" },
            { "<leader>tt", "<Cmd>ToggleTerm direction=tab<CR>" },
            { "<leader>tp", "<Cmd>ToggleTerm direction=float<CR>" },
            { "<leader>te", "<Cmd>lua require('utils').send_to_toggleterm()<CR>g@" },
            { "<leader>tee", "<Cmd>ToggleTermSendCurrentLine<CR>" },
            { "<leader>te", "<Cmd>ToggleTermSendVisualSelection<CR>", mode = "x" },
            { "<C-o>", "<Cmd>lua require('utils').file_manager()<CR>" },
        },
        opts = {
            open_mapping = "<C-b>", -- <count><C-b> to open terminal in split
            auto_scroll = false,
            winbar = { enabled = true },
            on_create = function() vim.o.signcolumn = "no" end,
        },
    },
    {
        "MunifTanjim/nui.nvim",
        init = function()
            vim.ui.input = (function(overridden)
                return function(...)
                    local present = pcall(require, "nui.input")
                    if not present then vim.ui.input = overridden end
                    vim.ui.input(...)
                end
            end)(vim.ui.input)
        end,
        config = function() -- https://github.com/MunifTanjim/nui.nvim/wiki/vim.ui, https://github.com/MunifTanjim/dotfiles/tree/8c13a4e05359bb12f9ade5abc1baca6fcec372db/private_dot_config/nvim/lua/plugins/lsp/custom
            local function get_prompt_text(prompt)
                local prompt_text = prompt or "[Input]"
                if prompt_text:sub(-1) == ":" then prompt_text = "[" .. prompt_text:sub(1, -2) .. "]" end
                return prompt_text
            end
            local UIInput = require("nui.input"):extend("UIInput")
            local input_ui = nil
            function UIInput:init(opts, on_done)
                local default_value = tostring(opts.default or "")
                local params = vim.lsp.util.make_position_params()
                UIInput.super.init(self, {
                    relative = { type = "buf", position = { row = params.position.line, col = params.position.character } }, -- use buf to avoid cursor shifting before on_submit
                    position = { row = 2, col = 0 },
                    size = { width = math.max(20, vim.api.nvim_strwidth(default_value) + 15) },
                    border = { style = "rounded", text = { top = get_prompt_text(opts.prompt), top_align = "left" } },
                    win_options = { winhighlight = "NormalFloat:Normal,FloatBorder:Normal" },
                }, {
                    default_value = default_value,
                    on_close = function() on_done(nil) end,
                    on_submit = function(value) on_done(value) end,
                })
                self:map("n", "<CR>", function(value) on_done(value) end, { noremap = true, nowait = true })
                self:map("n", "<Esc>", function() on_done(nil) end, { noremap = true, nowait = true })
                self:map("n", "q", function() on_done(nil) end, { noremap = true, nowait = true })
                self:on(require("nui.utils.autocmd").event.BufLeave, function() on_done(nil) end, { once = true })
            end

            vim.ui.input = function(opts, on_confirm)
                assert(type(on_confirm) == "function", "missing on_confirm function")
                if input_ui then
                    vim.api.nvim_err_writeln("busy: another input is pending!")
                    return
                end
                input_ui = UIInput(opts, function(value)
                    if input_ui then input_ui:unmount() end
                    on_confirm(value)
                    input_ui = nil
                end)
                input_ui:mount()
            end
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = "MunifTanjim/nui.nvim",
        keys = { { "<leader>b", "<Cmd>Neotree reveal<CR>" }, { "gO", "<Cmd>Neotree source=document_symbols<CR>" } },
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
                        ["<C-b>"] = { function(state) vim.cmd.ToggleTerm("dir=" .. get_dir(state)) end, desc = "open_term_at_node" },
                        ["<C-p>"] = {
                            function(state)
                                local dir = get_dir(state)
                                require("telescope.builtin").fd({ cwd = dir, prompt_title = "Find Files: " .. dir })
                            end,
                            desc = "find_files_at_node",
                        },
                        ["t"] = {
                            function(state)
                                local dir = get_dir(state)
                                require("telescope.builtin").fd({ cwd = dir, prompt_title = "Find Files: " .. dir })
                            end,
                            desc = "find_files_at_node",
                        },
                        ["T"] = {
                            function(state)
                                local dir = get_dir(state)
                                require("telescope.builtin").fd({ cwd = dir, prompt_title = "Find Files (no ignore): " .. dir, no_ignore = true })
                            end,
                            desc = "find_files_no_ignore_at_node",
                        },
                        ["<leader>f/"] = {
                            function(state)
                                local dir = get_dir(state)
                                vim.cmd.execute([["normal! \<C-w>w"]]) -- blur neo-tree to allow jumping to the selected line
                                require("telescope.builtin").live_grep({ cwd = dir, prompt_title = "Live Grep: " .. dir })
                            end,
                            desc = "live_grep_at_node",
                        },
                        ["z"] = "none",
                        ["H"] = "none",
                        ["/"] = "none",
                    },
                },
                filesystem = {
                    filtered_items = { hide_dotfiles = false, hide_gitignored = false, hide_hidden = false },
                    hijack_netrw_behavior = "disabled",
                    window = { mappings = { ["-"] = "navigate_up", ["C"] = "set_root" } },
                },
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
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            {
                "danielfalk/smart-open.nvim",
                dependencies = "kkharji/sqlite.lua",
                event = "VeryLazy", -- load at start to record recent files
                config = function() -- load_extension("smart_open") is unnecessary and causes error when sqlite3 doesn't exist
                    if vim.fn.executable("sqlite3") == 1 then require("smart-open").setup({ match_algorithm = "fzf" }) end
                end,
            },
        },
        keys = {
            { "q", "<Cmd>lua require('telescope.cycle')('mru')<CR>" },
            { "<C-p>", function()
                if vim.fn.executable("sqlite3") == 1 then
                    vim.keymap.set("n", "<C-p>", "<Cmd>lua require('telescope.cycle')('smart_open')<CR>")
                    require("telescope.cycle")("smart_open")
                else
                    vim.keymap.set("n", "<C-p>", "<Cmd>lua require('telescope.builtin').fd()<CR>")
                    require("telescope.builtin").fd()
                end
            end },
            { "<C-p>", ":<C-u>lua require('telescope.builtin').fd({initial_mode = 'normal', default_text = require('utils').get_visual_selection()})<CR>", mode = "x", silent = true }, -- TODO https://github.com/nvim-telescope/telescope.nvim/pull/2092
            { "<leader><C-p>", "<Cmd>lua require('telescope.builtin').resume({initial_mode = 'normal'})<CR>" },
            { "<leader>fS", "<Cmd>lua require('utils').fzf()<CR>" },
            { "<leader>fS", ":<C-u>lua require('utils').fzf(true)<CR>", mode = "x" },
            { "<leader>fm", "<Cmd>lua require('telescope.builtin').oldfiles()<CR>" },
            { "<leader>f'", "<Cmd>lua require('telescope.builtin').jumplist({initial_mode = 'normal'})<CR>" },
            { "<leader>fb", "<Cmd>lua require('telescope.builtin').live_grep({grep_open_files = true})<CR>" },
            { "<leader>fb", ":<C-u>lua require('telescope.builtin').live_grep({grep_open_files = true, default_text = require('utils').get_visual_selection()})<CR>", mode = "x" },
            { "<leader>fu", "<Cmd>lua require('telescope.builtin')[require('lsp').is_active() and 'lsp_document_symbols' or 'treesitter']()<CR>" },
            { "<leader>fU", "<Cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({ symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Struct', 'Trait', 'Field', 'Property' } })<CR>" },
            { "<leader>fg", ":RgRegex " },
            { "<leader>fg", ":<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR>", mode = "x" },
            { "<leader>fj", ":RgRegex \\b<C-r>=expand('<cword>')<CR>\\b<CR>" },
            { "<leader>fj", ":<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>", mode = "x" },
            { "<leader>f!", "<Cmd>lua require('telescope.builtin').git_status({initial_mode = 'normal'})<CR>" },
            { "<leader>fq", "<Cmd>lua require('telescope.builtin').quickfix()<CR>" },
            { "<leader>fl", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>" },
            { "<leader>fL", "<Cmd>lua require('telescope.builtin').loclist()<CR>" },
            { "<leader>fa", "<Cmd>lua require('telescope.builtin').commands()<CR>" },
            { "<leader>ft", "<Cmd>lua require('telescope.builtin').filetypes()<CR>" },
            { "<leader>ff", "<Cmd>lua require('telescope.builtin').builtin()<CR>" },
            { "<leader>f/", "<Cmd>lua require('telescope.builtin').live_grep()<CR>" },
            { "<leader>fr", "<Cmd>lua require('telescope.builtin').registers()<CR>" },
            { "<leader>f:", "<Cmd>lua require('telescope.builtin').command_history()<CR>" },
            { "<leader>fy", "<Cmd>lua require('telescope').extensions.clips.clips({initial_mode = 'normal'})<CR>" },
            { "<leader>fy", '"xdh<leader>fy', mode = "x", remap = true },
            { "mf", "<Cmd>lua require('telescope').extensions.bookmarks.bookmarks({initial_mode = 'normal'})<CR>" }, -- ../telescope/_extensions/bookmarks.lua
            { "mF", "<Cmd>lua require('telescope').extensions.bookmarks.bookmarks({global = true})<CR>" },
        },
        config = function()
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local function git_diff_ref(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection ~= nil then
                    actions.close(prompt_bufnr)
                    vim.schedule(function() vim.cmd.Gdiffsplit(selection.value .. ":%") end)
                end
            end
            local function scroll_results(direction)
                return function(prompt_bufnr)
                    local status = require("telescope.state").get_status(prompt_bufnr)
                    local speed = status.picker.layout_config.scroll_speed or vim.api.nvim_win_get_height(status.results_win) / 2
                    require("telescope.actions.set").shift_selection(prompt_bufnr, math.floor(speed) * direction)
                end
            end
            local cycle = require("telescope.cycle")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        n = {
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-d>"] = scroll_results(1),
                            ["<C-u>"] = scroll_results(-1),
                            [","] = actions.preview_scrolling_down,
                            ["."] = actions.preview_scrolling_up,
                            ["o"] = actions.select_default,
                            ["q"] = actions.close,
                            ["<Tab>"] = function(prompt_bufnr)
                                local picker = action_state.get_current_picker(prompt_bufnr)
                                vim.keymap.set("n", "<Tab>", "<Cmd>noautocmd lua vim.api.nvim_set_current_win(" .. picker.prompt_win .. ")<CR>", { buffer = picker.previewer.state.bufnr })
                                vim.cmd("noautocmd lua vim.api.nvim_set_current_win(" .. picker.previewer.state.winid .. ")")
                            end,
                        },
                        i = {
                            ["<C-s>"] = actions.to_fuzzy_refine,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<Esc>"] = actions.close,
                            ["<C-u>"] = function() vim.cmd.stopinsert() end,
                            ["`"] = function() cycle.next("`") end,
                        },
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                    },
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    multi_icon = "  ",
                    layout_strategy = "vertical",
                    layout_config = { vertical = { prompt_position = "top", preview_height = 0.3 } },
                    sorting_strategy = "ascending",
                    file_ignore_patterns = { ".git/", "node_modules/", "venv/", "vim/.*/doc/.*%.txt" },
                    dynamic_preview_title = true,
                    path_display = { "filename_first" },
                },
                pickers = {
                    buffers = { mappings = { n = { ["dd"] = actions.delete_buffer } } },
                    find_files = { hidden = true, find_command = { "fd", "--type", "f", "--strip-cwd-prefix" } },
                    oldfiles = { sorter = require("telescope.sorters").get_substr_matcher() },
                    filetypes = { theme = "dropdown" },
                    registers = { theme = "dropdown" },
                    builtin = { theme = "dropdown" },
                    git_branches = { mappings = { i = { ["<C-e>"] = git_diff_ref } } },
                    git_commits = { mappings = { i = { ["<C-e>"] = git_diff_ref } } },
                },
            })
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("bookmarks") -- ../telescope/_extensions/bookmarks.lua
        end,
    },
    {
        "skywind3000/vim-quickui",
        keys = {
            { "<CR>", "<Cmd>call quickui#menu#open('normal')<CR>" },
            { "<CR>", "<Esc><Cmd>Lazy load vim-quickui <bar> call quickui#menu#open('visual')<CR>", mode = "x" },
            {
                "K",
                function()
                    vim.fn["quickui#context#open"]({
                        { "Docu&mentation", "lua vim.lsp.buf.hover()", "Show documentation" },
                        { "Declaration", "lua vim.lsp.buf.declaration()", "Go to declaration" },
                        { "Line diagnostic", "lua vim.diagnostic.open_float({ scope = 'line', border = 'single' })", "Show diagnostic of current line" },
                        { "G&enerate doc", "lua require('neogen').generate()", "Generate annotations with neogen" },
                        { "--", "" },
                        { "Built-in d&ocs", [[execute &filetype == "lua" ? "help " . expand('<cword>') : "normal! K"]], "Open vim built in help" },
                    }, { index = vim.g["quickui#context#cursor"] or -1 })
                end,
            },
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
                { "--", "" },
                { "Move tab left &-", [[-tabmove]] },
                { "Move tab right &+", [[+tabmove]] },
                { "&Refresh screen", [[execute "silent GuessIndent" | execute "ScrollViewRefresh | nohlsearch | syntax sync fromstart | diffupdate | let @/=\"QWQ\" | normal! \<C-l>"]], "Clear search, refresh screen, scrollbar and colorizer" },
                { "--", "" },
                { "Open d&ashboard", [[lua require('snacks.dashboard')()]], "Open dashboard" },
                { "&Save session", [[call feedkeys(":SessionSave", "n")]], "Save session to .cache/nvim/session_<name>.vim, will overwrite" },
                { "Load s&ession", [[call feedkeys(":SessionLoad", "n")]], "Load session from .cache/nvim/session_<name>.vim" },
                { "--", "" },
                { "Edit Vimr&c", [[edit $MYVIMRC]] },
                { "GB18030 to utf-8", [[edit ++enc=GB18030 | set fileencoding=utf8]], "Edit as GB18030 (edit ++enc=GB18030) for Chinese characters and reset file format back to utf-8" },
                { "Open in &VSCode", [[execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!]] },
            })
            vim.fn["quickui#menu#install"]("&Git", { -- GBrowse loaded on command won't include line number in URL, need to explicitly load it. Similar issues for other fugitive commands.
                { "Git checko&ut ref", [[call feedkeys(":Gread @:%\<Left>\<Left>", "n")]], "Checkout current file from ref and load as unsaved buffer (Gread HEAD:%)" },
                { "Git &blame", [[Git blame]], "Git blame of current file" },
                { "Git &diff", [[Gdiffsplit]], "Diff current file with last staged version (Gdiffsplit)" },
                { "Git diff H&EAD", [[Gdiffsplit HEAD:%]], "Diff current file with last committed version (Gdiffsplit HEAD:%)" },
                { "Git file history", [[vsplit | execute "lua require('lazy').load({plugins = 'vim-flog'})" | 0Gclog]], "Browse previously committed versions of current file" },
                { "Diffview &file history", [[DiffviewFileHistory % --follow]], "Browse previously committed versions of current file with Diffview" },
                { "--", "" },
                { "Git &status", [[Git]], "Git status" },
                { "Diff&view", [[DiffviewOpen]], "Diff files with HEAD, use :DiffviewOpen ref..ref<CR> to speficy commits" },
                { "Git l&og", [[Flog]], "Show git logs with vim-flog" },
                { "--", "" },
                { "Git search current", [[call feedkeys(":Git log --all --name-status -S '' -- %\<Left>\<S-Left>\<Left>\<Left>", "n")]], "Search a string in all committed versions of current file, command: git log -p --all -S '<pattern>' --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- %" },
                { "Git search &all", [[call feedkeys(":Git log --all --name-status -S ''\<Left>", "n")]], "Search a string in all committed versions of files, command: git log -p --all -S '<pattern>' --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>" },
                { "Git gre&p all", [[call feedkeys(":Git log --all --name-status -i -G ''\<Left>", "n")]], "Search a regex in all committed versions of files, command: git log -p --all -i -G '<pattern>' --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>" },
                { "Git fi&nd files all", [[call feedkeys(":Git log --all --name-status -- '**'\<Left>\<Left>", "n")]], "Grep file names in all commits" },
            })
            vim.fn["quickui#menu#install"]("&Tables", {
                { "&Venn ascii draw", [[lua require("utils").toggle_venn()]], "Toggle venn.nvim, use HJKL to draw arrow, select area and use v to draw box" },
                { "--", "" },
                { "Table &mode", [[TableModeToggle]], "Toggle TableMode" },
                { "&Reformat table", [[TableModeRealign]], "Reformat table" },
                { "&Format to table", [[Tableize]], "Format to table, use <leader>T to set delimiter" },
                { "Delete row", [[execute "normal \<Plug>(table-mode-delete-row)"]], "Delete row" },
                { "Delete column", [[execute "normal \<Plug>(table-mode-delete-column)"]], "Delete column" },
                { "Show cell &position", [[execute "normal \<Plug>(table-mode-echo-cell)"]], "Show cell index number" },
                { "--", "" },
                { "&Add formula", [[TableAddFormula]], "Add formula to current cell, i.e. Sum(r1,c1:r2,c2)" },
                { "&Evaluate formula", [[TableEvalFormulaLine]], "Evaluate formula" },
            })
            vim.fn["quickui#menu#install"]("L&SP", {
                { "Workspace &diagnostics", [[lua require("lsp").quickfix_all_diagnostics()]], "Show workspace diagnostics in quickfix (run :bufdo edit<CR> to load all buffers)" },
                { "Workspace warnings and errors", [[lua require("lsp").quickfix_all_diagnostics(vim.diagnostic.severity.WARN)]], "Show workspace warnings and errors in quickfix" },
                { "&Toggle diagnostics", [[lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())]], "Toggle LSP diagnostics" },
                { "Toggle virtual text", [[lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })]], "Toggle LSP diagnostic virtual texts" },
                { "Toggle &inlay hints", [[lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())]], "Toggle LSP inlay hints" },
                { "--", "" },
                { "Show folders in workspace", [[lua vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))]], "Show folders in workspace for LSP" },
                { "Add folder to workspace", [[lua vim.lsp.buf.add_workspace_folder()]], "Add folder to workspace for LSP" },
                { "Remove folder from workspace", [[lua vim.lsp.buf.remove_workspace_folder()]], "Remove folder from workspace for LSP" },
                { "--", "" },
                { "Clear LSP logs", [[lua vim.fn.writefile({}, vim.lsp.get_log_path())]], "Empty lsp.log" },
            })
            vim.fn["quickui#menu#install"]("&Packages", {
                { "Lazy &status", [[Lazy]], "Lazy status" },
                { "Lazy clean", [[Lazy clean]], "Lazy clean plugins" },
                { "Lazy &update", [[Lazy update]], "Lazy update plugins" },
                { "--", "" },
                { "&Mason status", [[Mason]], "Mason status" },
                { "Mason &install all", [[lua require('lsp').lsp_install_all()]], "Install commonly used servers, linters, and formatters" },
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
                { "Base64 &decode", [[lua local temp = require("utils").base64_decode(require("utils").get_visual_selection()); vim.cmd.S(); vim.api.nvim_put(temp, "", false, true); vim.api.nvim_buf_set_name(0, "base64_decode"); temp = nil]], "Decode selected text with base64" },
                { "Generate &snippet", [[let @x = substitute(escape(funcs#get_visual_selection(), '"$'), repeat(' ', &shiftwidth), '\\t', 'g') | execute 'S put x' | execute '%normal! gI"' | execute '%normal! A",' | execute 'normal! Gdd$x' | file snippet_body]], "Generate vscode compatible snippet body from selected text" },
                { "--", "" },
                { "Search in &buffers", [[execute 'cexpr []' | execute 'bufdo vimgrepadd /' . substitute(escape(funcs#get_visual_selection(), '/\.*$^~['), '\n', '\\n', 'g') . '/g %' | copen]], "Grep current search pattern in all buffers, add to quickfix" },
                { "Search in selection", [[call feedkeys('/\%>' . (line("'<") - 1) . 'l\%<' . (line("'>") + 1) . 'l')]], [[Search in selected lines, to search in previous visual selection use /\%V]] },
            })
            vim.fn["quickui#menu#install"]("&Git", {
                { "Git &file history", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | vsplit | '<,'>Gclog]], "Browse previously committed versions of selected range" },
                { "Git l&og", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | '<,'>Flogsplit]], "Show git log of selected range with vim-flog" },
                { "Git &search", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | execute "Git log --all --name-status -S '" . substitute(funcs#get_visual_selection(), "'", "''", 'g') . "'"]], "Search selected in all committed versions of files" },
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
