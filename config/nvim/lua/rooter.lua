local M = {}
local patterns = { ".git", "package.json", "gradlew", "Makefile" }
local whitelisted_buf_type = { "", "acwrite" }
local parent_pattern = "(.*)" .. (vim.fn.has("win32") > 0 and "\\" or "/")
local enabled = true

local function find_pattern_root()
    local curr_dir = vim.fn.expand("%:p:h")
    while curr_dir ~= "" do
        for _, pattern in ipairs(patterns) do
            if vim.fn.globpath(curr_dir, pattern) ~= "" then
                return curr_dir
            end
        end
        curr_dir = curr_dir:match(parent_pattern) or ""
    end
end

function M.root()
    if enabled and vim.tbl_contains(whitelisted_buf_type, vim.api.nvim_buf_get_option(0, "buftype")) then
        local ok, dir = pcall(vim.api.nvim_buf_get_var, 0, "rooter")
        if not ok then
            dir = find_pattern_root()
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
    else -- set working directory to directory of current file or directory where nvim was started
        vim.api.nvim_set_current_dir(vim.fn.expand("%") == "" and vim.env.PWD or vim.fn.expand("%:p:h"))
    end
    vim.notify("Current directory: " .. vim.fn.fnamemodify(vim.loop.cwd(), ":~"), vim.log.levels.INFO, { annote = "Rooter is " .. (enabled and "enabled" or "disabled"), icon = "" })
end

return M
