function _G.lsp_install_all()
    local required_servers = {"sumneko_lua", "vimls", "jsonls", "yamlls", "html", "cssls", "tsserver", "pyright"}
    local lsp_installer_servers = require("nvim-lsp-installer.servers")
    for _, required_server in pairs(required_servers) do
        local ok, server = lsp_installer_servers.get_server(required_server)
        if ok and not server:is_installed() then
            server:install()
        end
    end
    vim.cmd("LspInstallInfo")
end
vim.cmd("command! LspInstallAll call v:lua.lsp_install_all()")

local timer = vim.loop.new_timer()
local function on_attach(client, bufnr)
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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
    sumneko_lua = {
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
    tsserver = {
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

-- https://github.com/neovim/nvim-lspconfig/issues/69#issuecomment-789541466
function _G.quickfix_all_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get_all()
    local qflist = {}
    for bufnr, diagnostic in pairs(diagnostics) do
        for _, d in ipairs(diagnostic) do
            table.insert(
                qflist,
                {
                    bufnr = bufnr,
                    lnum = d.range.start.line + 1,
                    col = d.range.start.character + 1,
                    text = d.message
                }
            )
        end
    end
    vim.lsp.util.set_qflist(qflist)
end

-- 0.6.0 breaking:
-- https://www.reddit.com/r/neovim/comments/pymf0t/neovim_not_displaying_custom_diagnostic_symbols/
-- https://www.reddit.com/r/neovim/comments/qd3v4h/psa_vimdiagnostics_api_has_changed_a_little_bit/
vim.fn.sign_define("LspDiagnosticsSignError", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = ""})
vim.fn.sign_define("LspDiagnosticsSignOther", {text = "﫠"})
vim.cmd("highlight LspDiagnosticsVirtualTextHint guifg=#666666")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
