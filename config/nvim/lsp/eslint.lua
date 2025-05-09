---@type vim.lsp.Config
return {
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(0, "LspEslintFixAll", function()
            client:exec_cmd({
                title = "Fix all Eslint errors for current buffer",
                command = "eslint.applyAllFixes",
                arguments = { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } },
            }, { bufnr = bufnr })
        end, {})

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
