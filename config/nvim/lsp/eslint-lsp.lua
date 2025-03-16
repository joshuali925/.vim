---@type vim.lsp.Config
return {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
    root_markers = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        "eslint.config.ts",
        "eslint.config.mts",
        "eslint.config.cts",
    },
    settings = {
        validate = "on",
        packageManager = nil,
        useESLintClass = false,
        experimental = { useFlatConfig = false },
        codeActionOnSave = { enable = false, mode = "all" },
        format = true,
        quiet = false,
        onIgnoredFiles = "off",
        rulesCustomizations = {},
        run = "onType",
        problems = { shortenToSingleLine = false },
        nodePath = "",
        workingDirectory = { mode = "location" },
        codeAction = { disableRuleComment = { enable = true, location = "separateLine" }, showDocumentation = { enable = true } },
    },
    handlers = {
        ["eslint/openDoc"] = function(_, result)
            if result then vim.ui.open(result.url) end
            return {}
        end,
        ["eslint/confirmESLintExecution"] = function(_, result)
            if not result then return end
            return 4 -- approved
        end,
        ["eslint/probeFailed"] = function()
            vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
            return {}
        end,
        ["eslint/noLibrary"] = function()
            vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
            return {}
        end,
    },

    on_attach = function(client, bufnr)
        local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                client.request_sync("workspace/executeCommand", {
                    command = "eslint.applyAllFixes",
                    arguments = { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } },
                }, 3000, bufnr)
            end,
        })
    end,
}
