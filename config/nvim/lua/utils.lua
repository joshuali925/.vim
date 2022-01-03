local M = {}

function M.untildone(command, message)
    local timer = vim.loop.new_timer()
    vim.g.untildone_count = vim.g.untildone_count + 1
    vim.notify(command, "INFO", {title = "Loop started"})
    timer:start(
        1000,
        1000,
        function()
            local handle = io.popen(command .. " 2>&1; echo $?")
            local result = handle:read("*a")
            handle:close()
            if result:match(".*%D(%d+)") == "0" then
                vim.g.untildone_count = vim.g.untildone_count - 1
                vim.notify(message or "Command succeeded", "INFO", {title = "Loop stopped", icon = ""})
                timer:close()
            end
        end
    )
end

return M
