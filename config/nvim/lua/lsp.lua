function _G.lsp_install_all()
    local required_servers = {
        "sumneko_lua",
        "vimls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "tsserver",
        "pyright",
        "jdtls",
        "kotlin_language_server",
    }
    local lsp_installer_servers = require("nvim-lsp-installer.servers")
    for _, required_server in ipairs(required_servers) do
        local ok, server = lsp_installer_servers.get_server(required_server)
        if ok and not server:is_installed() then
            server:install()
        end
    end
    vim.cmd("LspInstallInfo")
end
vim.cmd("command! LspInstallAll call v:lua.lsp_install_all()")

local function on_attach(client, bufnr)
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
    end
    -- use null-ls for formatting
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
end

local lsp_configs = {
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                diagnostics = { globals = { "vim" } },
                IntelliSense = { traceLocalSet = true },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                },
            },
        },
    },
    tsserver = {
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
    },
}

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
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
    }
    return {
        capabilities = capabilities,
        flags = { debounce_text_changes = 250 },
        on_attach = on_attach,
    }
end

local present, lsp_installer = pcall(require, "nvim-lsp-installer")
if present then
    lsp_installer.on_server_ready(function(server)
        local config = make_config()
        if lsp_configs[server.name] ~= nil then
            for k, v in pairs(lsp_configs[server.name]) do
                config[k] = v
            end
        end
        server:setup(config)
        vim.cmd("doautocmd User LspAttachBuffers")
    end)
end

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.diagnostics.shellcheck,
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
        null_ls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
        null_ls.builtins.formatting.sqlformat.with({ extra_args = { "-rsk", "upper" } }),
    },
})

function _G.organize_imports_and_format()
    vim.cmd("silent! OrganizeImports")
    vim.lsp.buf.formatting_sync({}, 3000)
end

local diagnostics_on = true
function _G.toggle_diagnostics()
    if diagnostics_on then
        vim.diagnostic.disable()
    else
        vim.diagnostic.enable()
    end
    diagnostics_on = not diagnostics_on
end

function _G.quickfix_all_diagnostics(filter)
    local severity = filter and vim.diagnostic.severity.WARN or vim.diagnostic.severity.HINT
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
end

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError", numhl = "DiagnosticError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticHint", numhl = "DiagnosticHint" })
vim.fn.sign_define("DiagnosticSignOther", { text = "﫠", texthl = "DiagnosticOther", numhl = "DiagnosticOther" })
vim.cmd(
    "highlight DiagnosticVirtualTextHint guifg=#666666 guibg="
        .. vim.fn.printf("#%x", vim.api.nvim_get_hl_by_name("Normal", true).background)
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
