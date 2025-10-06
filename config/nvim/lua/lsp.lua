local M = {}

local required_servers = {
    "typos_lsp",
    "marksman",
    "lua_ls",
    "vimls",
    "yamlls",
    "bashls",
    "basedpyright", -- to change max line length: printf '[pycodestyle]\nmax-line-length = 150' >> setup.cfg
    "eslint",
    -- lsp servers not installed by mason
    "jsonls", -- use eslint-lsp package for json, html, css lsps
    "html",
    "cssls",
    "kulala_ls", -- kulala-ls not in mason registry https://github.com/mason-org/mason-registry/pull/7477
}
local required_packages = {
    "typos-lsp",
    "marksman",
    "lua-language-server",
    "vim-language-server",
    "yaml-language-server",
    "bash-language-server",
    "basedpyright",
    "eslint-lsp",
    -- lsp servers configured not using lspconfig
    "typescript-language-server", -- typescript-language-server is setup using typescript-tools
    "jdtls",                      -- jdtls is setup using ../ftplugin/java.lua
    -- tools
    "prettier",
    "shellcheck",
}
local extra_servers = {                                    -- packages need to be manual installed on demand
    ["kotlin-language-server"] = "kotlin_language_server", -- gd not working in official lsp https://github.com/Kotlin/kotlin-lsp/issues/44
    gopls = "gopls",
    clangd = "clangd",
}

function M.install_packages()
    local installed = require("mason-registry").get_installed_package_names()
    local not_installed = vim.tbl_filter(function(package) return not vim.tbl_contains(installed, package) end, required_packages)
    if #not_installed > 0 then
        vim.cmd.MasonInstall({ args = not_installed })
        vim.notify("Installing kulala-ls...") -- kulala-ls not in mason registry https://github.com/mason-org/mason-registry/pull/7477
        vim.system({ "npm", "install", "-g", "@mistweaverco/kulala-ls" }, { text = true }, function() vim.notify("installed kulala-ls") end)
        local install_path = vim.fn.stdpath("data") .. "/mason"
        vim.fn.mkdir(install_path .. "/bin", "p")
        vim.uv.fs_symlink(install_path .. "/packages/eslint-lsp/node_modules/.bin/vscode-css-language-server", install_path .. "/bin/vscode-css-language-server")
        vim.uv.fs_symlink(install_path .. "/packages/eslint-lsp/node_modules/.bin/vscode-html-language-server", install_path .. "/bin/vscode-html-language-server")
        vim.uv.fs_symlink(install_path .. "/packages/eslint-lsp/node_modules/.bin/vscode-json-language-server", install_path .. "/bin/vscode-json-language-server")
    else
        vim.cmd.Mason()
    end
end

function M.setup()
    vim.lsp.enable(required_servers)
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    require("typescript-tools").setup({
        settings = {
            tsserver_path = mason_path .. "/packages/typescript-language-server/node_modules/.bin/tsserver", -- manually specify path, otherwise mason needs to be loaded
            jsx_close_tag = { enable = true },
            expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused" },
            tsserver_file_preferences = {
                -- importModuleSpecifierPreference = "shortest",
                importModuleSpecifierPreference = "relative",
                includeInlayParameterNameHints = "all",
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
    })
    for executable, server in pairs(extra_servers) do
        vim.uv.fs_stat(mason_path .. "/bin/" .. executable, function(err, stat)
            if not err and stat then vim.lsp.enable(server) end
        end)
    end

    vim.diagnostic.config({
        float = { scope = "cursor", source = true },
        virtual_text = { prefix = "●", current_line = true },
        severity_sort = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
            numhl = {
                [vim.diagnostic.severity.ERROR] = "DiagnosticError",
                [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
                [vim.diagnostic.severity.HINT] = "DiagnosticHint",
                [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            },
        },
    })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "LspCodeLens" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticVirtualTextHint" })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(e)
            local client = assert(vim.lsp.get_client_by_id(e.data.client_id))
            if client:supports_method("textDocument/foldingRange") then vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()" end
            local opts = { buffer = e.buf }
            local diagnostic_win_id
            vim.keymap.set("n", "K", function()
                if vim.tbl_contains({ "vim", "help" }, vim.o.filetype) then return vim.cmd.normal({ args = { "K" }, bang = true }) end
                if diagnostic_win_id and vim.api.nvim_win_is_valid(diagnostic_win_id) then
                    vim.api.nvim_win_close(diagnostic_win_id, true)
                    vim.lsp.buf.hover()
                else
                    _, diagnostic_win_id = vim.diagnostic.open_float({ border = "single" })
                    if diagnostic_win_id == nil then vim.lsp.buf.hover() end
                end
            end, opts)
            vim.keymap.set("x", "K", ":<C-u>help <C-r>=funcs#get_visual_selection()<CR><CR>", { buffer = e.buf, silent = true })
            vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
            vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
            vim.keymap.set("n", "<leader>d", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { buffer = e.buf, nowait = true })
            vim.keymap.set({ "n", "x" }, "<leader>a", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            vim.keymap.set("n", "<leader>R", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
            vim.keymap.set("n", "[a", "<Cmd>lua vim.diagnostic.goto_prev({ float = { border = 'single' }, severity = { min = vim.diagnostic.severity[next(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })) ~= nil and 'ERROR' or 'HINT'] } })<CR>", opts)
            vim.keymap.set("n", "]a", "<Cmd>lua vim.diagnostic.goto_next({ float = { border = 'single' }, severity = { min = vim.diagnostic.severity[next(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })) ~= nil and 'ERROR' or 'HINT'] } })<CR>", opts)
            vim.keymap.set("n", "[A", "<Cmd>lua vim.diagnostic.goto_prev({ float = { border = 'single' } })<CR>", opts)
            vim.keymap.set("n", "]A", "<Cmd>lua vim.diagnostic.goto_next({ float = { border = 'single' } })<CR>", opts)
            vim.keymap.set("n", "g<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            vim.keymap.set("i", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        end,
    })
end

function M.organize_imports_and_format()
    local active_clients = vim.tbl_map(function(client) return client.name end, vim.lsp.get_clients({ bufnr = 0 }))
    if vim.tbl_contains(active_clients, "typescript-tools") then
        local ok, res = pcall(require("typescript-tools.api").organize_imports) -- sync organize imports always fails
        vim.cmd.sleep()
        if not ok then vim.notify(res, vim.log.levels.WARN, { title = "Failed to organize imports" }) end
    elseif vim.tbl_contains(active_clients, "basedpyright") then
        vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
            command = "basedpyright.organizeimports",
            arguments = { vim.uri_from_bufnr(0) },
        }, 3000)
    end
    vim.cmd.Conform()
end

function M.is_active()
    return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
end

function M.quickfix_all_diagnostics(filter)
    local severity = filter or vim.diagnostic.severity.HINT
    local diagnostics = vim.diagnostic.toqflist(vim.diagnostic.get(nil, { severity = { min = severity } }))
    local type_to_num = { E = 1, W = 2, I = 3, N = 4 }
    table.sort(diagnostics, function(a, b)
        local a_sev = type_to_num[a.type]
        local b_sev = type_to_num[b.type]
        if a_sev == b_sev and a.bufnr == b.bufnr then
            return a.lnum < b.lnum
        end
        return a_sev < b_sev
    end)
    vim.fn.setqflist(diagnostics, "r")
    vim.cmd.copen()
end

function M.get_diagnostics_in_buffers(filter)
    local severity_names = { "ERROR", "WARN", "INFO", "HINT" }
    local outputs = {}
    for _, bufnr in ipairs(vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf })
    end, vim.api.nvim_list_bufs())) do
        local diagnostics = vim.diagnostic.get(bufnr, { severity = { min = filter or vim.diagnostic.severity.WARN } })
        if #diagnostics > 0 then
            local diagnostics_by_line = {}
            for _, diagnostic in ipairs(diagnostics) do
                diagnostics_by_line[diagnostic.lnum] = diagnostics_by_line[diagnostic.lnum] or {}
                table.insert(diagnostics_by_line[diagnostic.lnum], string.format("[%s] %s", severity_names[diagnostic.severity], diagnostic.message))
            end
            local lines = {}
            for lnum, messages in pairs(diagnostics_by_line) do
                table.insert(lines, { lnum, string.format("%s:\n%d %s", table.concat(messages, "; "), lnum + 1, vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or "") })
            end
            table.sort(lines, function(a, b) return a[1] < b[1] end)
            table.insert(outputs, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~:.") .. ":\n" .. table.concat(vim.tbl_map(function(l) return l[2] end, lines), "\n"))
        end
    end
    return table.concat(outputs, "\n\n")
end

return M
