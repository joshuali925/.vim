function _G.lsp_install_all()
    local required_servers = {"lua", "vim", "json", "yaml", "html", "css", "typescript", "python"}
    local installed_servers = require("lspinstall").installed_servers()
    for _, server in pairs(required_servers) do
        if not vim.tbl_contains(installed_servers, server) then
            require("lspinstall").install_server(server)
        end
    end
end
vim.cmd("command! LspInstallAll call v:lua.lsp_install_all()")

local function on_attach(client, bufnr)
    require("lsp_signature").on_attach()
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
            ]],
            false
        )
    end
end

local lsp_configs = {
    lua = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";")
                },
                diagnostics = {
                    globals = {"vim"}
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                    }
                }
            }
        }
    },
    -- https://github.com/theia-ide/typescript-language-server/pull/218
    typescript = {
        init_options = {
            preferences = {
                importModuleSpecifierPreference = "relative"
            }
        },
        commands = {
            OrganizeImports = {
                function()
                    vim.lsp.buf.execute_command(
                        {
                            command = "_typescript.organizeImports",
                            arguments = {vim.api.nvim_buf_get_name(0)},
                            title = ""
                        }
                    )
                end,
                description = "Organize Imports"
            }
        }
    }
}

local function make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
        on_attach = on_attach
    }
end

local function setup_servers()
    require("lspinstall").setup()
    local servers = require("lspinstall").installed_servers()

    for _, server in pairs(servers) do
        local config = make_config()
        if lsp_configs[server] ~= nil then
            for k, v in pairs(lsp_configs[server]) do
                config[k] = v
            end
        end
        require("lspconfig")[server].setup(config)
    end
end

setup_servers()

require("lspinstall").post_install_hook = function()
    setup_servers()
    vim.cmd("bufdo edit")
end

vim.fn.sign_define("LspDiagnosticsSignError", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignOther", {text = "﫠"})
