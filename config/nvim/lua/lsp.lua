function _G.lsp_install_all()
    local required_servers = {"sumneko_lua", "vimls", "jsonls", "yamlls", "html", "cssls", "tsserver", "pyright"}
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
        vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end
end

local lsp_configs = {
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
                diagnostics = {globals = {"vim"}},
                IntelliSense = {traceLocalSet = true},
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                    }
                }
            }
        }
    },
    tsserver = {
        init_options = {preferences = {importModuleSpecifierPreference = "relative"}},
        commands = {
            OrganizeImports = {
                function()
                    vim.lsp.buf.execute_command {
                        command = "_typescript.organizeImports",
                        arguments = {vim.api.nvim_buf_get_name(0)},
                        title = ""
                    }
                end,
                description = "Organize Imports"
            }
        }
    }
}

local function make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.documentationFormat = {"markdown", "plaintext"}
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = {valueSet = {1}}
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {"documentation", "detail", "additionalTextEdits"}
    }
    return {
        capabilities = capabilities,
        flags = {debounce_text_changes = 150},
        on_attach = on_attach
    }
end

local present, lsp_installer = pcall(require, "nvim-lsp-installer")
if present then
    lsp_installer.on_server_ready(
        function(server)
            local config = make_config()

            if lsp_configs[server.name] ~= nil then
                for k, v in pairs(lsp_configs[server.name]) do
                    config[k] = v
                end
            end
            server:setup(config)
            vim.cmd("doautocmd User LspAttachBuffers")
        end
    )
end

function _G.organize_imports_and_format()
    if vim.fn.exists(":OrganizeImports") == 0 then
        vim.cmd("Neoformat")
    else
        vim.cmd("OrganizeImports")
        vim.defer_fn(
            function()
                vim.cmd("Neoformat")
            end,
            500
        )
    end
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

-- https://github.com/neovim/nvim-lspconfig/issues/69#issuecomment-789541466
function _G.quickfix_all_diagnostics(severity)
    severity = severity or 99
    local diagnostics = vim.lsp.diagnostic.get_all()
    local qflist = {}
    for bufnr, diagnostic in pairs(diagnostics) do
        for _, d in ipairs(diagnostic) do
            if d.severity <= severity then
                table.insert(
                    qflist,
                    {bufnr = bufnr, lnum = d.range.start.line + 1, col = d.range.start.character + 1, text = d.message}
                )
            end
        end
    end
    vim.lsp.util.set_qflist(qflist)
end

vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticError", numhl = "DiagnosticError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticHint", numhl = "DiagnosticHint"})
vim.fn.sign_define("DiagnosticSignOther", {text = "﫠", texthl = "DiagnosticOther", numhl = "DiagnosticOther"})
vim.cmd("highlight DiagnosticVirtualTextHint guifg=#666666")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
