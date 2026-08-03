---@type vim.lsp.Config
return {
    on_attach = function(client, bufnr)
        local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", { group = group, buffer = bufnr, command = "Conform" })
    end,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { neededFileStatus = { ["codestyle-check"] = "Any" } },
            telemetry = { enable = false },
            IntelliSense = { traceLocalSet = true },
            workspace = { library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" } },
            format = { enable = true },
            hint = { enable = true },
        },
    },
}
