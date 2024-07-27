local M = {}

local disabled_servers = {
    -- "tsserver",
    -- "eslint",
    -- "jdtls",
    -- "kotlin_language_server",
}
function M.lsp_install_all()
    local required = {
        "lua_ls",
        "bashls",
        "vimls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "tsserver",
        "eslint",
        "pyright", -- to change max line length: printf '[pycodestyle]\nmax-line-length = 150' >> setup.cfg
        "jdtls",
        "kotlin_language_server",
    }
    local installed = require("mason-lspconfig").get_installed_servers()
    local not_installed = vim.tbl_filter(function(server) return not vim.tbl_contains(installed, server) end, required)
    if #not_installed > 0 then
        vim.cmd.LspInstall({ args = not_installed })
    else
        vim.cmd.Mason()
    end
    vim.cmd.MasonInstall({ args = { "prettier", "shellcheck", "black" } })
end

function M.init()
    local function make_config()
        -- https://github.com/hrsh7th/cmp-nvim-lsp/blob/5af77f54de1b16c34b23cba810150689a3a90312/lua/cmp_nvim_lsp/init.lua#L24
        local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
            textDocument = {
                completion = {
                    dynamicRegistration = false,
                    completionItem = {
                        snippetSupport = true,
                        commitCharactersSupport = true,
                        deprecatedSupport = true,
                        preselectSupport = true,
                        tagSupport = { valueSet = { 1 } },
                        insertReplaceSupport = true,
                        resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits", "sortText", "filterText", "insertText", "textEdit", "insertTextFormat", "insertTextMode" } },
                        insertTextModeSupport = { valueSet = { 1, 2 } },
                        labelDetailsSupport = true,
                    },
                    contextSupport = true,
                    insertTextMode = 1,
                    completionList = { itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" } },
                },
            },
        })
        return { capabilities = capabilities, flags = { debounce_text_changes = 250 } }
    end

    local function register_server(server, server_config)
        if not vim.tbl_contains(disabled_servers, server) then
            local config = vim.tbl_deep_extend("force", make_config(), server_config or {})
            require("lspconfig")[server].setup(config)
        end
    end

    require("mason").setup({ ui = { border = "rounded" } })
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers({
        register_server,
        jdtls = function()
            local project_name = vim.fn.fnamemodify(vim.uv.cwd(), ":p:h:t")
            local workspace_dir = vim.fn.stdpath("cache") .. "/java/workspace/" .. project_name
            os.execute("mkdir -p " .. workspace_dir)
            local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
            local os = vim.fn.has("macunix") and "mac" or "linux"
            register_server("jdtls", {
                -- https://astronvim.com/nightly/Recipes/advanced_lsp#java-nvim-jdtls
                cmd = {     -- needs python3.9+ if not using custom cmd, or remove `action=argparse.BooleanOptionalAction` in ~/.local/share/nvim/mason/packages/jdtls/bin/jdtls.py
                    "java", -- needs java 17, or use :LspInstall jdtls@1.12.0
                    -- vim.uv.os_homedir() .. "/.asdf/installs/java/corretto-17.0.4.8.1/bin/java",
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Dlog.protocol=true",
                    "-Dlog.level=ALL",
                    "-javaagent:" .. install_path .. "/lombok.jar",
                    "-Xms1g",
                    "--add-modules=ALL-SYSTEM",
                    "--add-opens",
                    "java.base/java.util=ALL-UNNAMED",
                    "--add-opens",
                    "java.base/java.lang=ALL-UNNAMED",
                    "-jar",
                    vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                    "-configuration",
                    install_path .. "/config_" .. os,
                    "-data",
                    workspace_dir,
                },
                settings = {
                    java = { sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } } },
                },
            })
        end,
        tsserver = function()
            if not vim.tbl_contains(disabled_servers, "tsserver") then
                require("typescript-tools").setup({
                    settings = {
                        expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused" },
                        tsserver_file_preferences = {
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
            end
        end,
        eslint = function()
            register_server("eslint", {
                on_attach = function(client, bufnr)
                    local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
                    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", { group = group, buffer = bufnr, command = "EslintFixAll" })
                end,
            })
        end,
        yamlls = function()
            register_server("yamlls", { settings = { yaml = { keyOrdering = false } } })
        end,
        lua_ls = function()
            register_server("lua_ls", {
                on_attach = function(client, bufnr)
                    local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
                    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = group,
                        buffer = bufnr,
                        callback = function() require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 3000 }) end,
                    })
                end,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                        diagnostics = { globals = { "vim" }, neededFileStatus = { ["codestyle-check"] = "Any" } },
                        telemetry = { enable = false },
                        IntelliSense = { traceLocalSet = true },
                        workspace = {
                            -- library = vim.api.nvim_get_runtime_file("", true), -- index library files
                            library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true },
                        },
                        format = { enable = true, defaultConfig = { quote_style = "double", max_line_length = "unset", align_array_table = "false" } },
                        hint = { enable = true },
                    },
                },
            })
        end,
        pyright = function()
            register_server("pyright", {
                commands = {
                    PythonOrganizeImports = {
                        function()
                            vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
                                command = "pyright.organizeimports",
                                arguments = { vim.uri_from_bufnr(0) },
                            }, 3000)
                        end,
                        description = "Organize Imports",
                    },
                },
            })
        end,
    })

    vim.diagnostic.config({
        virtual_text = { prefix = "●" },
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
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#666666", bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticVirtualTextHint" })
end

function M.organize_imports_and_format()
    local active_clients = vim.tbl_map(function(client) return client.name end, vim.lsp.get_clients({ bufnr = 0 }))
    if vim.tbl_contains(active_clients, "typescript-tools") then
        local ok, res = pcall(require("typescript-tools.api").organize_imports, true)
        if not ok then vim.notify(res, vim.log.levels.WARN, { annote = "Failed to organize imports" }) end
    elseif vim.tbl_contains(active_clients, "pyright") then
        vim.cmd("silent PythonOrganizeImports")
    end
    if vim.tbl_contains(active_clients, "eslint") then
        vim.schedule(function() vim.cmd("EslintFixAll") end)
    else
        require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 3000 })
    end
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

return M
