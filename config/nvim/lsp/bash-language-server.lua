---@type vim.lsp.Config
return {
    cmd = { "bash-language-server", "start" },
    settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" },
}
