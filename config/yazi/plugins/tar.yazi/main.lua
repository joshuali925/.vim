local M = {}

function M:peek(job)
    local child = Command("tar")
        :args({ "tf", tostring(job.file.url) })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()
    local limit = job.area.h
    local files = {}
    local num_lines = 0
    local num_skip = 0
    repeat
        local line, event = child:read_line()
        if event == 1 then
            ya.err(tostring(event))
        elseif event ~= 0 then
            break
        end

        if num_skip >= job.skip then
            table.insert(files, line)
            num_lines = num_lines + 1
        else
            num_skip = num_skip + 1
        end
    until num_lines >= limit

    child:start_kill()
    if job.skip > 0 and num_lines < limit then
        ya.mgr_emit("peek", { math.max(0, job.skip - (limit - num_lines)), only_if = job.file.url, upper_bound = true })
    else
        ya.preview_widgets(job, { ui.Text(files):area(job.area) })
    end
end

function M:seek(job) require("code"):seek(job) end

return M
