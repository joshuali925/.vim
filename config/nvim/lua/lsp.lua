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

local timer = vim.loop.new_timer()
local function on_attach(client, bufnr)
    require("lsp_signature").on_attach({hint_enable = false}, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.document_highlight then
        function _G.lsp_document_highlight()
            timer:start(
                50,
                0,
                vim.schedule_wrap(
                    function()
                        vim.cmd("silent! lua vim.lsp.buf.clear_references()")
                        vim.cmd("silent! lua vim.lsp.buf.document_highlight()")
                    end
                )
            )
        end
        vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorMoved <buffer> call v:lua.lsp_document_highlight()
                autocmd CursorMovedI <buffer> call v:lua.lsp_document_highlight()
            augroup END
        ]]
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
            debounce_text_changes = 150
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

-- https://github.com/neovim/neovim/issues/14825
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
        vim.g.diagnostics_visible = false
        vim.lsp.diagnostic.clear(0)
        vim.lsp.handlers["textDocument/publishDiagnostics"] = function()
        end
    else
        vim.g.diagnostics_visible = true
        vim.lsp.handlers["textDocument/publishDiagnostics"] =
            vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            {
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false
            }
        )
    end
end

-- 0.6.0 breaking: https://www.reddit.com/r/neovim/comments/pymf0t/neovim_not_displaying_custom_diagnostic_symbols/
vim.fn.sign_define("LspDiagnosticsSignError", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignOther", {text = "﫠"})
vim.cmd("highlight LspDiagnosticsVirtualTextHint guifg=#666666")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
