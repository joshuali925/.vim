local M = {}

local disabled_servers = {
    -- "tsserver",
    -- "eslint",
    -- "jdtls",
    -- "kotlin_language_server",
}
function M.lsp_install_all()
    local required = {
        "sumneko_lua",
        "vimls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "tsserver",
        -- "eslint",
        "pyright",
        "jdtls",
        "kotlin_language_server",
    }
    local installed = require("mason-lspconfig").get_installed_servers()
    local not_installed = vim.tbl_filter(function(server)
        return not vim.tbl_contains(installed, server)
    end, required)
    if #not_installed > 0 then
        vim.cmd("LspInstall " .. table.concat(not_installed, " "))
    else
        vim.cmd("Mason")
    end
    vim.cmd("MasonInstall prettier shellcheck") -- TODO https://github.com/williamboman/mason.nvim/issues/103
end

-- TODO https://www.reddit.com/r/neovim/comments/vvtltr/remove_the_message_select_a_language_server/
-- https://www.reddit.com/r/neovim/comments/u5si2w/breaking_changes_inbound_next_few_weeks_for/
function M.init()
    local function on_attach(client, bufnr)
        -- use null-ls for formatting except on lua
        if client.name ~= "sumneko_lua" then
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
        end
        require("illuminate").on_attach(client)
    end

    local function make_config()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.preselectSupport = true
        capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
        capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
        capabilities.textDocument.completion.completionItem.deprecatedSupport = true
        capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
        capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
        capabilities.textDocument.completion.completionItem.resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } }
        return { capabilities = capabilities, flags = { debounce_text_changes = 250 }, on_attach = on_attach }
    end

    local present, mason = pcall(require, "mason")
    if not present then
        return
    end
    mason.setup()
    local function register_server(server, server_config)
        if not vim.tbl_contains(disabled_servers, server) then
            local config = make_config()
            if server_config ~= nil then
                for k, v in pairs(server_config) do
                    config[k] = v
                end
            end
            require("lspconfig")[server].setup(config)
        end
    end

    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers({
        register_server,
        jdtls = function()
            register_server("jdtls", { -- needs python3.9+, or remove `action=argparse.BooleanOptionalAction` in ~/.local/share/nvim/mason/packages/jdtls/bin/jdtls.py
                -- cmd_env = { -- jdtls requires java 17, or use :LspInstall jdtls@1.12.0
                --     JAVA_HOME = vim.loop.os_homedir() .. "/.asdf/installs/java/corretto-17.0.4.8.1"
                -- },
                -- initializationOptions = {
                --     bundles = { -- for debugger
                --         vim.loop.os_homedir() .. "/.vim/com.microsoft.java.debug.plugin-0.34.0.jar", -- https://repo1.maven.org/maven2/com/microsoft/java/com.microsoft.java.debug.plugin/0.34.0/com.microsoft.java.debug.plugin-0.34.0.jar
                --     },
                -- },
            })
        end,
        sumneko_lua = function()
            register_server("sumneko_lua", {
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
                        format = { enable = true, defaultConfig = { quote_style = "double", max_line_length = "unset" } },
                    },
                },
            })
        end,
        tsserver = function()
            register_server("tsserver", {
                init_options = { preferences = { importModuleSpecifierPreference = "relative" } },
                commands = {
                    OrganizeImports = {
                        function()
                            vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
                                command = "_typescript.organizeImports",
                                arguments = { vim.api.nvim_buf_get_name(0) },
                                title = "",
                            }, 3000)
                        end,
                        description = "Organize Imports",
                    },
                },
            })
        end,
    })

    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {
            null_ls.builtins.code_actions.gitrebase,
            null_ls.builtins.code_actions.shellcheck,
            null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.formatting.prettier.with({
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "vue",
                    "css",
                    "scss",
                    "less",
                    "html",
                    "json",
                    "yaml",
                    "markdown",
                    "graphql",
                    "sh", -- prettier-plugin-sh
                    "bash",
                    "java", -- prettier-plugin-java
                    "kotlin", -- prettier-plugin-kotlin
                },
            }),
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.sqlformat.with({ extra_args = { "-rsk", "upper" } }),
        },
    })

    vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError", numhl = "DiagnosticError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticHint", numhl = "DiagnosticHint" })
    vim.fn.sign_define("DiagnosticSignOther", { text = "﫠", texthl = "DiagnosticOther", numhl = "DiagnosticOther" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#666666", bg = vim.api.nvim_get_hl_by_name("Normal", true).background })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticVirtualTextHint" })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
end

function M.organize_imports_and_format()
    if next(vim.lsp.buf_get_clients()) ~= nil then
        vim.cmd("silent! OrganizeImports")
        vim.lsp.buf.formatting_sync({}, 3000)
    else
        vim.cmd("Prettier")
    end
end

function M.is_active()
    for _, client in ipairs(vim.lsp.buf_get_clients(0)) do
        if client.name ~= "null-ls" then
            return true
        end
    end
    return false
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
    vim.cmd("copen")
end

return M
