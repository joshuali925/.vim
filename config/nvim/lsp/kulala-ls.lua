---@type vim.lsp.Config
return {
    cmd = { "kulala-ls", "--stdio" },
    filetypes = { "http" },
    root_markers = { ".git" },
}
