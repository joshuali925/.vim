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
            format = {
                enable = true,
                defaultConfig = { -- https://raw.githubusercontent.com/CppCXY/EmmyLuaCodeStyle/HEAD/docs/format_config.md
                    quote_style = "double",
                    max_line_length = "unset",
                    align_continuous_assign_statement = "false",
                    align_continuous_rect_table_field = "false",
                    align_if_branch = "false",
                    align_array_table = "false",
                    trailing_table_separator = "smart",
                },
            },
            hint = { enable = true },
        },
    },
}
