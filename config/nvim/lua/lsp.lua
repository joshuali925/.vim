local M = {}

local disabled_servers = {
    -- "tsserver",
    "eslint",
    -- "jdtls",
    -- "kotlin_language_server",
}
function M.lsp_install_all()
    local required = {
        "lua_ls",
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
        -- https://github.com/hrsh7th/cmp-nvim-lsp/blob/389f06d3101fb412db64cb49ca4f22a67882e469/lua/cmp_nvim_lsp/init.lua#L24
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
        capabilities.textDocument.completion.completionItem.deprecatedSupport = true
        capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
        capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
        capabilities.textDocument.completion.completionItem.preselectSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } }
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
        capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
        return { capabilities = capabilities, flags = { debounce_text_changes = 250 } }
    end

    local present, mason = pcall(require, "mason")
    if not present then
        return
    end
    mason.setup()
    local function register_server(server, server_config)
        if not vim.tbl_contains(disabled_servers, server) then
            local config = vim.tbl_deep_extend("force", make_config(), server_config or {})
            if server == "tsserver" then
                require("typescript").setup({ server = config })
            else
                require("lspconfig")[server].setup(config)
            end
        end
    end

    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers({
        register_server,
        jdtls = function()
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = vim.fn.stdpath("cache") .. "/java/workspace/" .. project_name
            os.execute("mkdir -p " .. workspace_dir)
            local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
            local os = vim.fn.has("macunix") and "mac" or "linux"
            register_server("jdtls", {
                -- https://astronvim.com/nightly/Recipes/advanced_lsp#java-nvim-jdtls
                cmd = {     -- needs python3.9+ if not using custom cmd, or remove `action=argparse.BooleanOptionalAction` in ~/.local/share/nvim/mason/packages/jdtls/bin/jdtls.py
                    "java", -- needs java 17, or use :LspInstall jdtls@1.12.0
                    -- vim.loop.os_homedir() .. "/.asdf/installs/java/corretto-17.0.4.8.1/bin/java",
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
        yamlls = function()
            register_server("yamlls", { settings = { yaml = { keyOrdering = false } } })
        end,
        lua_ls = function()
            register_server("lua_ls", {
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
                    },
                },
            })
        end,
        tsserver = function()
            register_server("tsserver", {
                init_options = { preferences = { importModuleSpecifierPreference = "relative" } },
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

    local null_ls = require("null-ls")
    local null_ls_sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.shellcheck,
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
                "sh",     -- prettier-plugin-sh (cd ~/.local/share/nvim/mason/packages/prettier; npm install prettier-plugin-sh)
                "bash",
                "java",   -- prettier-plugin-java
                "kotlin", -- prettier-plugin-kotlin
            },
        }),
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.sqlformat.with({ extra_args = { "-rsk", "upper" } }),
        require("typescript.extensions.null-ls.code-actions"),
    }
    if require("mason-registry").is_installed("shellcheck") then
        table.insert(null_ls_sources, null_ls.builtins.diagnostics.shellcheck)
    end
    null_ls.setup({ sources = null_ls_sources })

    vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError", numhl = "DiagnosticError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticHint", numhl = "DiagnosticHint" })
    vim.fn.sign_define("DiagnosticSignOther", { text = "󰗡", texthl = "DiagnosticOther", numhl = "DiagnosticOther" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#666666", bg = vim.api.nvim_get_hl_by_name("Normal", true).background })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticVirtualTextHint" })
    vim.diagnostic.config({ virtual_text = { prefix = "●" } })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
end

local formatting_lsps = { "null-ls", "lua_ls" }
function M.organize_imports_and_format()
    local active_clients = vim.tbl_map(function(client) return client.name end, vim.lsp.get_active_clients({ bufnr = 0 }))
    if vim.tbl_contains(active_clients, "tsserver") then
        local ok, resp = pcall(require("typescript").actions.organizeImports, { sync = true })
        if not ok then vim.notify(resp, vim.log.levels.ERROR, { title = "Organize imports failed" }) end
    elseif vim.tbl_contains(active_clients, "pyright") then
        vim.cmd("silent PythonOrganizeImports")
    end
    if not vim.tbl_isempty(vim.tbl_filter(function(name) return vim.tbl_contains(formatting_lsps, name) end, active_clients)) then
        vim.lsp.buf.format({ filter = function(client) return vim.tbl_contains(formatting_lsps, client.name) end, timeout_ms = 3000 })
    else
        vim.cmd.Prettier()
    end
end

function M.toggle_diagnostics()
    if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

function M.is_active()
    for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
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
    vim.cmd.copen()
end

return M
