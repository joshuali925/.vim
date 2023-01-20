return {
    {
        "rcarriga/nvim-notify", -- TODO https://github.com/folke/noice.nvim
        config = function()
            vim.api.nvim_create_user_command("NotificationsDismiss", function() require("notify").dismiss({ silent = true, pending = true }) end, {})
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        opts = {
            func_map = {
                prevfile = "", --     to filter: :g/pattern/lua require('bqf.qfwin.handler').signToggle(1)
                nextfile = "", --     press zn to create new list with marked items
                pscrolldown = ",", -- press zN to create new list excluding marked items
                pscrollup = ".", --   press < and > to switch between lists
                ptoggleitem = "P", -- press z<Tab> to clear marks
                ptoggleauto = "p",
            },
        }
    },
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
        cmd = "TermExec",
        keys = {
            { "<C-b>", "<Cmd>ToggleTerm<CR>" },
            { "<leader>to", "<Cmd>execute 'ToggleTerm dir='. expand('%:p:h')<CR>" },
            { "<leader>tv", "<Cmd>execute 'ToggleTerm direction=vertical size='. &columns / 2<CR>" },
            { "<leader>tt", "<Cmd>ToggleTerm direction=tab<CR>" },
            { "<leader>tp", "<Cmd>ToggleTerm direction=float<CR>" },
            { "<leader>te", "<Cmd>lua require('utils').send_to_toggleterm()<CR>g@" },
            { "<leader>tee", "<Cmd>ToggleTermSendCurrentLine<CR>" },
            { "<leader>te", "<Cmd>ToggleTermSendVisualSelection<CR>", { mode = "x" } },
            { "<C-o>", "<Cmd>lua require('utils').toggle_lf()<CR>" },
        },
        opts = {
            on_open = function(_) vim.cmd.startinsert({ bang = true }) end,
            open_mapping = "<C-b>",
            start_in_insert = false,
            auto_scroll = false,
            winbar = { enabled = true },
        },
    },
    {
        "kyazdani42/nvim-tree.lua",
        keys = { { "<leader>b", "expand('%') == '' ? '<Cmd>NvimTreeOpen<CR>' : '<Cmd>NvimTreeFindFile<CR>'", expr = true, replace_keycodes = false } },
        config = function()
            local tree_cb = require("nvim-tree.config").nvim_tree_callback
            require("nvim-tree").setup({
                hijack_cursor = true,
                hijack_netrw = false,
                git = { ignore = false },
                actions = { open_file = { resize_window = false } },
                renderer = { highlight_git = true, full_name = true },
                view = {
                    mappings = {
                        list = {
                            { key = { "?" }, cb = tree_cb("toggle_help") },
                            { key = { "i" }, cb = tree_cb("toggle_ignored") },
                            { key = { "r" }, cb = tree_cb("refresh") },
                            { key = { "R" }, cb = tree_cb("rename") },
                            { key = { "x" }, cb = tree_cb("remove") },
                            { key = { "d" }, cb = tree_cb("cut") },
                            { key = { "y" }, cb = tree_cb("copy") },
                            { key = { "yy" }, cb = tree_cb("copy_absolute_path") },
                            { key = { "C" }, cb = tree_cb("cd") },
                            { key = { "s" }, cb = tree_cb("split") },
                            { key = { "h" }, cb = tree_cb("close_node") },
                            { key = { "l" }, cb = tree_cb("edit") },
                            { key = { "zM" }, cb = tree_cb("collapse_all") },
                            { key = { "zR" }, cb = tree_cb("expand_all") },
                            { key = { "[g" }, cb = tree_cb("prev_git_item") },
                            { key = { "]g" }, cb = tree_cb("next_git_item") },
                            { key = { "q" }, cb = "<Cmd>execute 'NvimTreeResize '. winwidth(0) <bar> NvimTreeClose<CR>" },
                            { key = { "<Left>" }, cb = "<Cmd>normal! zh<CR>" },
                            { key = { "<Right>" }, cb = "<Cmd>normal! zl<CR>" },
                            { key = { "-" }, cb = "<Cmd>normal! $<CR>" },
                            { key = { "H" }, cb = "<Cmd>normal! H<CR>" },
                            { key = { "<C-e>" }, cb = "<Cmd>normal! <C-e><CR>" },
                        },
                    },
                },
            })
        end,
    },
    {
        "goolord/alpha-nvim",
        lazy = vim.fn.argc() ~= 0 or vim.fn.line2byte("$") ~= -1,
        config = function()
            local theme = require("alpha.themes.startify")
            theme.section.header.val = {
                [[    ⢀⣀⣀⡀          ⣀⣀⣀                       ⢀⣀⣀⡀                      ⣤⣤    ]],
                [[    ⣿⣿⣿⣿⣷⣄      ⣰⣿⠟⠛⢿⣷⡄                    ⣼⣿⠟⠛⠟                      ⣿⣿    ]],
                [[⢠   ⠙⠻⠿⢿⣿⣿⡆    ⢰⣿⡏   ⣿⣷⢸⣿⣴⠿⣿⣧ ⢠⣾⠟⢿⣦⡀⢸⣷⡼⠿⣿⣦ ⢿⣿⣄   ⣴⣿⠿⣿⣦ ⠰⠿⠿⢿⣷⡀⣿⣧⡾⠿⢠⣾⡿⠿⠇⣿⣿⡾⠿⣿⣦]],
                [[⣿⣶⣄⡀    ⠈⠻⡇ ⣶  ⢸⣿⡇   ⣿⣿⢸⣿⡇ ⢸⣿⡇⣿⣿⣤⣬⣿⡇⢸⣿⠁ ⢹⣿ ⠈⠛⢿⣷⣆⢰⣿⣧⣤⣼⣿⡇⢀⣤⣤⣼⣿⡇⣿⣿  ⣿⣿   ⣿⣿  ⣿⣿]],
                [[⠸⣿⣿⣿⣿⣷⣦    ⢀⡏  ⠈⣿⣧  ⢀⣿⡏⢸⣿⡇ ⢸⣿⡇⣿⣿⠉⠉⠉⠁⢸⣿  ⢸⣿    ⣻⣿⠸⣿⣏⠉⠉⠉⢱⣿⡟⠁⢸⣿⡇⣿⣿  ⣿⣿   ⣿⣿  ⣿⣿]],
                [[ ⠈⠻⢿⣿⡿⠏   ⣠⠟    ⠘⠿⣿⣾⡿⠟⠁⢸⣿⡟⢶⣿⠟ ⠘⠿⣷⣶⡾ ⠸⠿  ⠸⠿ ⠿⣷⣾⡿⠏ ⠙⢿⣶⣶⠾⠈⢿⣿⡶⠛⠿⠇⠿⠿  ⠘⠿⣷⣶⠇⠿⠿  ⠿⠿]],
                [[     ⣀⣀⣠⡴⠞⠁            ⢸⣿⡇                                                  ]],
                [[     ⠉⠁                ⠘⠛⠃                                                  ]],
            }
            theme.section.top_buttons.val = {}
            theme.section.bottom_buttons.val = {
                theme.button("!", "Git unstaged changes", "<Cmd>args `git ls-files --modified --others --exclude-standard` | Git difftool<CR>"),
                theme.button("+", "Git HEAD changes", "<Cmd>args `git diff HEAD --name-only` | Git difftool HEAD<CR>"),
                theme.button("~", "Git conflicts", "<Cmd>Git mergetool<CR>"),
                theme.button("?", "Git diff HEAD", "<Cmd>DiffviewOpen<CR>"),
                theme.button("*", "Git diff remote", "<Cmd>DiffviewOpen @{upstream}..HEAD<CR>"),
                theme.button("o", "Git log", "<Cmd>Flog<CR>"),
                theme.button("f", "Find files", "<Cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>"),
                theme.button("m", "Find MRU", "<Cmd>lua require('telescope.builtin').oldfiles()<CR>"),
                theme.button("c", "Edit vimrc", "<Cmd>edit $MYVIMRC<CR>"),
                theme.button("\\", "Open quickui", "<Cmd>Lazy load vim-quickui <bar> call quickui#menu#open('normal')<CR>"),
                theme.button("s", "Open Mason UI", "<Cmd>Mason<CR>"),
                theme.button("l", "Open Lazy UI", "<Cmd>Lazy<CR>"),
                theme.button("p", "Open Lazy Profile", "<Cmd>Lazy profile<CR>"),
                theme.button("E", "Load from previous session", "<Cmd>silent SessionLoad<CR>"),
            }
            theme.mru_opts.ignore = function(path, ext)
                return string.find(path, "vim/.*/doc/.*%.txt") or string.find(path, "/.git/")
            end
            require("alpha").setup(theme.config)
            vim.api.nvim_create_augroup("AlphaAutoCommands", {})
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "alpha",
                group = "AlphaAutoCommands",
                callback = function()
                    vim.b.RestoredCursor = 1 -- do not restore cursor position
                    vim.keymap.set("n", "v", require("alpha").queue_press, { buffer = true })
                    vim.keymap.set("n", "q", [[len(getbufinfo({"buflisted":1})) == 0 ? "<Cmd>quit<CR>" : "<Cmd>call plugins#bbye#bdelete('bdelete', '', '')<CR>"]], { buffer = true, expr = true, replace_keycodes = false })
                    vim.keymap.set("n", "e", "<Cmd>enew<CR>", { buffer = true })
                    vim.keymap.set("n", "i", "<Cmd>enew <bar> startinsert<CR>", { buffer = true })
                end,
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
        keys = {
            { "<C-p>", "<Cmd>lua require('telescope.builtin').find_files()<CR>" },
            { "<C-p>", ":<C-u>lua require('telescope.builtin').find_files({initial_mode = 'normal', default_text = vim.fn['funcs#get_visual_selection']()})<CR>", mode = "x", silent = true },
            { "<leader><C-p>", "<Cmd>lua require('telescope.builtin').resume({initial_mode = 'normal'})<CR>" },
            { "<leader>fs", "<C-p>", remap = true },
            { "<leader>fm", "<Cmd>lua require('telescope.builtin').oldfiles()<CR>" },
            { "<leader>fM", "<Cmd>lua require('telescope.builtin').jumplist({initial_mode = 'normal'})<CR>" },
            { "<leader>fb", "<Cmd>lua require('telescope.builtin').buffers({initial_mode = 'normal'})<CR>" },
            { "<leader>fu", "<Cmd>lua require('telescope.builtin')[require('lsp').is_active() and 'lsp_document_symbols' or 'treesitter']()<CR>" },
            { "<leader>fU", "<Cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>" },
            { "<leader>fg", ":RgRegex " },
            { "<leader>fg", ":<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR>", mode = "x" },
            { "<leader>fj", ":RgRegex \\b<C-r>=expand('<cword>')<CR>\\b<CR>" },
            { "<leader>fj", ":<C-u>RgNoRegex <C-r>=funcs#get_visual_selection()<CR><CR>", mode = "x" },
            { "<leader>fq", "<Cmd>lua require('telescope.builtin').quickfix()<CR>" },
            { "<leader>fl", "<Cmd>lua require('telescope.builtin').loclist()<CR>" },
            { "<leader>fL", "<Cmd>lua require('telescope.builtin').live_grep()<CR>" },
            { "<leader>fa", "<Cmd>lua require('telescope.builtin').commands()<CR>" },
            { "<leader>ft", "<Cmd>lua require('telescope.builtin').filetypes()<CR>" },
            { "<leader>ff", "<Cmd>lua require('telescope.builtin').builtin()<CR>" },
            { "<leader>f/", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>" },
            { "<leader>fr", "<Cmd>lua require('telescope.builtin').registers()<CR>" },
            { "<leader>fh", "<Cmd>lua require('telescope.builtin').command_history()<CR>" },
            { "<leader>fy", "<Cmd>lua require('telescope').extensions.neoclip.default({initial_mode = 'normal'})<CR>" },
            { "<leader>fy", "dh<leader>fy", mode = "x", remap = true },
        },
        config = function()
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local git_diff_ref = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection ~= nil then
                    actions.close(prompt_bufnr)
                    vim.schedule(function()
                        vim.cmd.Gdiffsplit(selection.value .. ":%")
                    end)
                end
            end
            -- TODO https://github.com/nvim-telescope/telescope.nvim/issues/416
            require("telescope").setup({
                defaults = {
                    mappings = {
                        n = {
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            [","] = actions.preview_scrolling_down,
                            ["."] = actions.preview_scrolling_up,
                            ["o"] = actions.select_default,
                            ["q"] = actions.close,
                        },
                        i = {
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<Esc>"] = actions.close,
                            ["<C-u>"] = function() vim.cmd.stopinsert() end,
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
                    layout_strategy = "vertical",
                    layout_config = { vertical = { preview_height = 0.3 } },
                    file_ignore_patterns = { ".git/", "node_modules/", "venv/", "vim/.*/doc/.*%.txt" },
                    dynamic_preview_title = true,
                    path_display = { "truncate" },
                },
                pickers = {
                    buffers = { mappings = { n = { ["dd"] = actions.delete_buffer } } },
                    find_files = { hidden = true, find_command = { "fd", "--type", "f", "--strip-cwd-prefix" } },
                    filetypes = { theme = "dropdown" },
                    registers = { theme = "dropdown" },
                    git_branches = { mappings = { i = { ["<C-e>"] = git_diff_ref } } },
                    git_commits = { mappings = { i = { ["<C-e>"] = git_diff_ref } } },
                },
                extensions = {
                    fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },
    { "skywind3000/asyncrun.vim", cmd = "AsyncRun", config = function() vim.g.asyncrun_open = 12 end },
    {
        "skywind3000/vim-quickui",
        keys = {
            { "<CR>", "<Cmd>call quickui#menu#open('normal')<CR>" },
            { "<CR>", "<Esc><Cmd>Lazy load vim-quickui <bar> call quickui#menu#open('visual')<CR>", mode = "x" },
            {
                "K",
                function()
                    local content = {
                        { "Docu&mentation", "Lspsaga hover_doc", "Show documentation" },
                        { "&Preview definition", "Lspsaga peek_definition", "Preview definition" },
                        { "Reference &finder", "Lspsaga lsp_finder", "Find references" },
                        { "&Signautre", "lua vim.lsp.buf.signature_help()", "Show function signature help" },
                        { "Implementation", "lua vim.lsp.buf.implementation()", "Go to implementation" },
                        { "Declaration", "lua vim.lsp.buf.declaration()", "Go to declaration" },
                        { "Type definition", "lua vim.lsp.buf.type_definition()", "Go to type definition" },
                        { "Hover diagnostic", "Lspsaga show_line_diagnostics", "Show diagnostic of current line" },
                        { "Incoming calls", "Lspsaga incoming_calls", "Run lsp callhierarchy incoming_calls" },
                        { "Outgoing calls", "Lspsaga outgoing_calls", "Run lsp callhierarchy outgoing_calls" },
                        { "G&enerate doc", "lua require('neogen').generate()", "Generate annotations with neogen" },
                        { "--", "" },
                        { "Git hunk &diff", "lua require('gitsigns').preview_hunk()", "Git preview hunk" },
                        { "Git hunk &undo", "lua require('gitsigns').reset_hunk()", "Git undo hunk" },
                        { "Git hunk &add", "lua require('gitsigns').stage_hunk()", "Git stage hunk" },
                        { "Git hunk reset", "lua require('gitsigns').undo_stage_hunk()", "Git undo stage hunk" },
                        { "Git buffer reset", "lua require('gitsigns').reset_buffer_index()", "Git reset buffer index" },
                        { "Git &blame", "lua require('gitsigns').blame_line({full = true})", "Git blame of current line" },
                        { "Git &remote", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | if $SSH_CLIENT == "" | .GBrowse | else | let @x=split(execute(".GBrowse!"), "\n")[-1] | execute "lua require('utils').copy_with_osc_yank_script(vim.fn.getreg('x'))" | endif]], "Open remote url in browser, or copy to clipboard if over ssh" },
                        { "--", "" },
                    }
                    local conflict_state = vim.fn["funcs#get_conflict_state"]()
                    if conflict_state ~= "" then
                        if conflict_state == "Ourselves" or conflict_state == "Themselves" then
                            table.insert(content, { "Git &conflict get", "ConflictMarker" .. conflict_state, "Get change from " .. conflict_state })
                        end
                        table.insert(content, { "Git conflict get all", "ConflictMarkerBoth", "Get change from ours and theirs" })
                        table.insert(content, { "Git conflict remove", "ConflictMarkerNone", "Remove conflict" })
                        table.insert(content, { "--", "" })
                    end
                    local ccc_state = require("lazy.core.config").plugins["ccc.nvim"]
                    if ccc_state and ccc_state._.loaded then
                        table.insert(content, { "&Color picker", "CccPick", "Open color picker, control: hjkl, 1-9" })
                        table.insert(content, { "Color convert", "CccConvert", "Convert color between hex, rgb, hsl" })
                        table.insert(content, { "--", "" })
                    end
                    table.insert(content, { "Built-in d&ocs", 'execute "normal! K"', "Open vim built in help" })
                    vim.fn["quickui#context#open"](content, { index = vim.g["quickui#context#cursor"] or -1 })
                end,
            },
        },
        init = function()
            vim.g.quickui_show_tip = 1
            vim.g.quickui_border_style = 2
        end,
        config = function()
            vim.fn["quickui#menu#switch"]("normal")
            vim.fn["quickui#menu#reset"]()
            vim.fn["quickui#menu#install"]("&Actions", {
                { "Insert line", [[execute "lua require('lazy').load({plugins = 'kommentary'})" | execute "normal! o\<Space>\<BS>\<Esc>55a=" | execute "normal \<Plug>kommentary_line_default"]], "Insert a dividing line" },
                { "Insert time", [[put=strftime('%x %X')]], "Insert MM/dd/yyyy hh:mm:ss tt" },
                { "&Trim spaces", [[keeppatterns %s/\s\+$//e | silent! execute "normal! ``"]], "Remove trailing spaces" },
                { "Re&indent", [[let g:temp = getcurpos() | Sleuth | execute "normal! gg=G" | call setpos('.', g:temp)]], "Recalculate indent with Sleuth and reindent whole file" },
                { "Ded&up lines", [[%!awk '\!x[$0]++']], "Remove duplicated lines and preserve order" },
                { "Du&plicated lines", [[sort | let @/ = '\C^\(.*\)$\n\1$' | set hlsearch]], "Sort and search duplicated lines" },
                { "Calculate line &=", [[let @x = getline(".")[max([0, matchend(getline("."), ".*=")]):] | execute "normal! A = \<C-r>=\<C-r>x\<CR>"]], 'Calculate expression from previous "=" or current line' },
                { "--", "" },
                { "&Word count", [[call feedkeys("g\<C-g>")]], "Show document details" },
                { "Cou&nt occurrences", [[echo searchcount({'maxcount': 0})]], "Count occurrences of current search pattern (:%s/pattern//gn also works)" },
                { "Search in &buffers", [[execute "cexpr [] | bufdo vimgrepadd //g %" | copen]], "Grep current search pattern in all buffers, add to quickfix" },
                { "Search non-ascii", [[let @/ = '[^\d0-\d127]' | set hlsearch]], "Search all non-ascii characters" },
                { "Fold unmatched lines", [[setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2 foldmethod=manual]], "Fold lines that don't have a match for the current search phrase" },
                { "&Diff unsaved", [[execute "diffthis | topleft vnew | setlocal buftype=nofile bufhidden=wipe filetype=". &filetype. " | read ++edit # | 0d_ | diffthis"]], "Diff current buffer with file on disk (similar to DiffOrig command)" },
                { "Enable colori&zer", [[CccHighlighterEnable]], "Enable colorizer" },
                { "--", "" },
                { "Move tab left &-", [[-tabmove]] },
                { "Move tab right &+", [[+tabmove]] },
                { "&Refresh screen", [[execute "IndentBlanklineRefresh" | execute "ScrollViewRefresh | nohlsearch | syntax sync fromstart | diffupdate | let @/=\"QWQ\" | normal! \<C-l>"]], "Clear search, refresh screen, scrollbar and colorizer" },
                { "--", "" },
                { "Open &Alpha", [[Lazy! load alpha-nvim | Alpha]], "Open Alpha" },
                { "&Save session", [[SessionSave]], "Save session to .cache/nvim/session.vim, will overwrite" },
                { "Load s&ession", [[SessionLoad]], "Load session from .cache/nvim/session.vim" },
                { "--", "" },
                { "Edit Vimr&c", [[edit $MYVIMRC]] },
                { "GB18030 to utf-8", [[edit ++enc=GB18030 | set fileencoding=utf8]], "Edit as GB18030 (edit ++enc=GB18030) for Chinese characters and reset file format back to utf-8" },
                { "Open in &VSCode", [[execute "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!]] },
            })
            vim.fn["quickui#menu#install"]("&Git", {
                { "Git checko&ut", [[Gread]], "Checkout current file from index and load as unsaved buffer (Gread)" },
                { "Git checkout HEAD", [[Gread HEAD:%]], "Checkout current file from HEAD and load as unsaved buffer (Gread HEAD:%)" },
                { "Git &blame", [[Git blame]], "Git blame of current file" },
                { "Git &diff", [[Gdiffsplit]], "Diff current file with last staged version (Gdiffsplit)" },
                { "Git diff H&EAD", [[Gdiffsplit HEAD:%]], "Diff current file with last committed version (Gdiffsplit HEAD:%)" },
                { "Git &file history", [[vsplit | execute "lua require('lazy').load({plugins = 'vim-flog'})" | 0Gclog]], "Browse previously committed versions of current file" },
                { "Diffview file history", [[DiffviewFileHistory % --follow]], "Browse previously committed versions of current file with Diffview" },
                { "--", "" },
                { "Git &toggle deleted", [[lua require("gitsigns").toggle_deleted()]], "Show deleted lines with gitsigns" },
                { "Git toggle &word diff", [[lua require("gitsigns").toggle_word_diff()]], "Show word diff with gitsigns" },
                { "Git toggle blame", [[lua require("gitsigns").toggle_current_line_blame()]], "Show blame of current line with gitsigns" },
                { "Git hunks against HEAD", [[lua require("gitsigns").change_base("HEAD", true)]], "Show hunks based on HEAD instead of staged, to reset run :Gitsigns change_base" },
                { "--", "" },
                { "Git &status", [[Git]], "Git status" },
                { "Git &changed files", [[Git! difftool --name-status]], "Load unstaged files into quickfix (Git! difftool --name-status)" },
                { "Git unstaged changes", [[Git! difftool]], "Load unstaged changes into quickfix (Git! difftool)" },
                { "Git HEAD changes", [[Git! difftool HEAD]], "Load changes from HEAD into quickfix (Git! difftool HEAD)" },
                { "Diff&view HEAD", [[DiffviewOpen]], "Diff files with HEAD, use :DiffviewOpen ref..ref<CR> to speficy commits" },
                { "Git l&og", [[Flog]], "Show git logs with vim-flog" },
                { "--", "" },
                { "Git search &all", [[call feedkeys(":Git log --all --full-history --name-status -S \"\"\<Left>", "n")]], 'Search a string in all committed versions of files, command: git log -p --all -S "<pattern>" --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>' },
                { "Git gre&p all", [[call feedkeys(":Git log --all --full-history --name-status -i -G \"\"\<Left>", "n")]], 'Search a regex in all committed versions of files, command: git log -p --all -i -G "<pattern>" --since=<yyyy.mm.dd> --until=<yyyy.mm.dd> -- <path>' },
                { "Git fi&nd files all", [[call feedkeys(":Git log --all --full-history --name-status -- \"**\"\<Left>\<Left>", "n")]], "Grep file names in all commits" },
                { "Git root", [[Grt]], "Change current directory to git root" },
            })
            vim.fn["quickui#menu#install"]("&Toggle", {
                { 'Quickfix             %{empty(filter(getwininfo(), "v:val.quickfix")) ? "[ ]" : "[x]"}', [[execute empty(filter(getwininfo(), "v:val.quickfix")) ? "copen" : "cclose"]] },
                { 'Location list        %{empty(filter(getwininfo(), "v:val.loclist")) ? "[ ]" : "[x]"}', [[execute empty(filter(getwininfo(), "v:val.loclist")) ? "lopen" : "lclose"]] },
                { 'Set &diff             %{&diff ? "[x]" : "[ ]"}', [[execute &diff ? "windo diffoff" : len(filter(nvim_list_wins(), 'nvim_win_get_config(v:val).relative == ""')) == 1 ? "vsplit | bnext | windo diffthis" : "windo diffthis"]], "Toggle diff in current tab, split next buffer if only one window" },
                { 'Set scr&ollbind       %{&scrollbind ? "[x]" : "[ ]"}', [[execute &scrollbind ? "windo set noscrollbind" : "windo set scrollbind"]], "Toggle scrollbind in current tab" },
                { 'Set &wrap             %{&wrap ? "[x]" : "[ ]"}', [[set wrap!]], "Toggle wrap lines" },
                { 'Set &paste            %{&paste ? "[x]" : "[ ]"}', [[execute &paste ? "set nopaste number mouse=a signcolumn=yes" : "set paste nonumber norelativenumber mouse= signcolumn=no"]], "Toggle paste mode" },
                { 'Set &spelling         %{&spell ? "[x]" : "[ ]"}', [[set spell!]], "Toggle spell checker (z= to auto correct current word)" },
                { 'Set &virtualedit      %{&virtualedit=~#"all" ? "[x]" : "[ ]"}', [[execute &virtualedit=~#"all" ? "set virtualedit=block" : "set virtualedit=all"]], "Toggle virtualedit" },
                { 'Set previ&ew          %{&completeopt=~"preview" ? "[x]" : "[ ]"}', [[execute &completeopt=~"preview" ? "set completeopt-=preview \<bar> pclose" : "set completeopt+=preview"]], "Toggle function preview" },
                { 'Set &cursorline       %{&cursorline ? "[x]" : "[ ]"}', [[set cursorline!]], "Toggle cursorline" },
                { 'Set cursorcol&umn     %{&cursorcolumn ? "[x]" : "[ ]"}', [[set cursorcolumn!]], "Toggle cursorcolumn" },
                { 'Set light &background %{&background=~"light" ? "[x]" : "[ ]"}', [[let &background = &background=="dark" ? "light" : "dark"]], "Toggle background color" },
                { 'Reader &mode          %{get(g:, "ReaderMode", 0) == 0 ? "[ ]" : "[x]"}', [[execute get(g:, "ReaderMode", 0) == 0 ? "nnoremap <nowait> d <C-d>\<bar>nnoremap u <C-u>" : "nunmap d\<bar>nunmap u" | let g:ReaderMode = 1 - get(g:, "ReaderMode", 0) | lua vim.notify("Reader mode " .. (vim.g.ReaderMode == 1 and "on" or "off"))]], "Toggle using 'd' and 'u' for '<C-d>' and '<C-u>' scrolling" },
                { "--", "" },
                { "&Indent line", [[IndentBlanklineToggle]], "Toggle indent lines" },
                { "&Rooter", [[lua require("rooter").toggle()]], "Toggle automatically change root directory" },
            })
            vim.fn["quickui#menu#install"]("Ta&bles", {
                { "Table &mode", [[TableModeToggle]], "Toggle TableMode" },
                { "&Reformat table", [[TableModeRealign]], "Reformat table" },
                { "&Format to table", [[Tableize]], "Format to table, use <leader>T to set delimiter" },
                { "Delete row", [[execute "normal \<Plug>(table-mode-delete-row)"]], "Delete row" },
                { "Delete column", [[execute "normal \<Plug>(table-mode-delete-column)"]], "Delete column" },
                { "Show cell &position", [[execute "normal \<Plug>(table-mode-echo-cell)"]], "Show cell index number" },
                { "--", "" },
                { "&Add formula", [[TableAddFormula]], "Add formula to current cell, i.e. Sum(r1,c1:r2,c2)" },
                { "&Evaluate formula", [[TableEvalFormulaLine]], "Evaluate formula" },
                { "--", "" },
                { "Align using = (delimiter fixed)", [[Tabularize /=\zs]], [[Tabularize /=\zs]] },
                { "Align using , (delimiter fixed)", [[Tabularize /,\zs]], [[Tabularize /,\zs]] },
                { "Align using # (delimiter fixed)", [[Tabularize /\#\zs]], [[Tabularize /\#\zs]] },
                { "Align using : (delimiter fixed)", [[Tabularize /:\zs]], [[Tabularize /:\zs]] },
                { "--", "" },
                { "Align using = (delimiter aligned)", [[Tabularize /=]], "Tabularize /=" },
                { "Align using , (delimiter aligned)", [[Tabularize /,]], "Tabularize /," },
                { "Align using # (delimiter aligned)", [[Tabularize /\#]], "Tabularize /\\#" },
                { "Align using : (delimiter aligned)", [[Tabularize /:]], "Tabularize /:" },
                { "--", "" },
                { "&CSV show column", [[CSVWhatColumn!]], "Show column title under cursor" },
                { "CSV arrange column", [[execute "lua require('lazy').load({plugins = 'csv.vim'})" | 1,$CSVArrangeColumn!]], "Align csv columns" },
                { "CSV to table", [[execute "lua require('lazy').load({plugins = 'csv.vim'})" | CSVTabularize]], "Convert csv to table" },
            })
            vim.fn["quickui#menu#install"]("L&SP", {
                { "Workspace &diagnostics", [[lua require("lsp").quickfix_all_diagnostics()]], "Show workspace diagnostics in quickfix (run :bufdo edit<CR> to load all buffers)" },
                { "Workspace warnings and errors", [[lua require("lsp").quickfix_all_diagnostics(vim.diagnostic.severity.WARN)]], "Show workspace warnings and errors in quickfix" },
                { "&Toggle virtual text", [[lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })]], "Toggle LSP diagnostic virtual texts" },
                { "Toggle diagnostics", [[lua require("lsp").toggle_diagnostics()]], "Toggle LSP diagnostics" },
                { "--", "" },
                { "Show folders in workspace", [[lua vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))]], "Show folders in workspace for LSP" },
                { "Add folder to workspace", [[lua vim.lsp.buf.add_workspace_folder()]], "Add folder to workspace for LSP" },
                { "Remove folder from workspace", [[lua vim.lsp.buf.remove_workspace_folder()]], "Remove folder from workspace for LSP" },
            })
            vim.fn["quickui#menu#install"]("&Packages", {
                { "Lazy &status", [[Lazy]], "Lazy status" },
                { "Lazy clean", [[Lazy clean]], "Lazy clean plugins" },
                { "Lazy &update", [[Lazy update]], "Lazy update plugins" },
                { "--", "" },
                { "&Mason status", [[Mason]], "Mason status" },
                { "Mason &install all", [[execute "lua require('lsp').lsp_install_all()"]], "Install commonly used servers (LspInstallAll) + linters, formatters" },
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
                { "&Format JSON", [['<,'>Prettier json]], "Use prettier to format selected text as JSON" },
                { "Base64 &encode", [[let @x = system('base64 | tr -d "\r\n"', funcs#get_visual_selection()) | execute 'S put x' | file base64_encode]], "Use base64 to encode selected text" },
                { "Base64 &decode", [[let @x = system('base64 --decode', funcs#get_visual_selection()) | execute 'S put x' | file base64_decode]], "Use base64 to decode selected text" },
                { "--", "" },
                { "OSC &yank", [[lua require("utils").copy_with_osc_yank_script(require("utils").get_visual_selection())]], "Use oscyank script to copy" },
                { "--", "" },
                { "Search in selection", [[call feedkeys('/\%>'. (line("'<") - 1). 'l\%<'. (line("'>") + 1). 'l')]], [[Search in selected lines, to search in previous visual selection use /\%V]] },
            })
            vim.fn["quickui#menu#install"]("&Git", {
                { "Git &file history", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | vsplit | '<,'>Gclog]], "Browse previously committed versions of selected range" },
                { "Git l&og", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | '<,'>Flogsplit]], "Show git log of selected range with vim-flog" },
                { "--", "" },
                { "Git open &remote", [[execute "lua require('lazy').load({plugins = 'vim-flog'})" | if $SSH_CLIENT == "" | '<,'>GBrowse | else | let @x=split(execute("'<,'>GBrowse!"), "\n")[-1] | execute "lua require('utils').copy_with_osc_yank_script(vim.fn.getreg('x'))" | endif]], "Open remote url in browser" },
            })
            vim.fn["quickui#menu#install"]("Ta&bles", {
                { "Reformat table", [['<,'>TableModeRealign]], "Reformat table" },
                { "Format to table", [['<,'>Tableize]], "Format to table, use <leader>T to set delimiter" },
                { "--", "" },
                { "Align using = (delimiter fixed)", [['<,'>Tabularize /=\zs]], "'<,'>Tabularize /=\\zs" },
                { "Align using , (delimiter fixed)", [['<,'>Tabularize /,\zs]], "'<,'>Tabularize /,\\zs" },
                { "Align using # (delimiter fixed)", [['<,'>Tabularize /\#\zs]], "'<,'>Tabularize /\\#\\zs" },
                { "Align using : (delimiter fixed)", [['<,'>Tabularize /:\zs]], "'<,'>Tabularize /:\\zs" },
                { "--", "" },
                { "Align using = (delimiter aligned)", [['<,'>Tabularize /=]], "'<,'>Tabularize /=" },
                { "Align using , (delimiter aligned)", [['<,'>Tabularize /,]], "'<,'>Tabularize /," },
                { "Align using # (delimiter aligned)", [['<,'>Tabularize /\#]], "'<,'>Tabularize /\\#" },
                { "Align using : (delimiter aligned)", [['<,'>Tabularize /:]], "'<,'>Tabularize /:" },
                { "--", "" },
                { "Sort asc", [['<,'>sort]], "Sort in ascending order (sort)" },
                { "Sort desc", [['<,'>sort!]], "Sort in descending order (sort!)" },
                { "Sort num asc", [['<,'>sort n]], "Sort numerically in ascending order (sort n)" },
                { "Sort num desc", [['<,'>sort! n]], "Sort numerically in descending order (sort! n)" },
            })
        end,
    },
}
