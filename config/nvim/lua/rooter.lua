local M = {}
local patterns = { ".git" }
local whitelisted_buf_type = { "", "acwrite" }
local enabled = true

function M.root()
    if enabled and vim.tbl_contains(whitelisted_buf_type, vim.api.nvim_get_option_value("buftype", { buf = 0 })) then
        local ok, dir = pcall(vim.api.nvim_buf_get_var, 0, "rooter")
        if not ok then
            dir = vim.fs.root(0, patterns)
            vim.api.nvim_buf_set_var(0, "rooter", dir)
        end
        if dir then
            vim.api.nvim_set_current_dir(dir)
        end
    end
end

function M.toggle()
    enabled = not enabled
    if enabled then
        M.root()
    else -- set working directory to directory of current file or directory where nvim was started. do not use uv.chdir, otherwise file path will be incorrect if vim is opened in a subdirectory
        vim.api.nvim_set_current_dir(vim.fn.expand("%") == "" and vim.env.PWD or vim.fn.expand("%:p:h"))
    end
    vim.notify("Current directory: " .. vim.fn.fnamemodify(vim.uv.cwd() or ".", ":~"), vim.log.levels.INFO, { title = "Rooter is " .. (enabled and "enabled" or "disabled"), icon = "" })
end

function M.setup()
    vim.api.nvim_create_augroup("Rooter", {})
    vim.api.nvim_create_autocmd("BufEnter", { group = "Rooter", callback = require("rooter").root, nested = true })
end

return M
