--- @sync entry

local function parent(offset)
    local parent = cx.active.parent
    if not parent then return end

    local start = parent.cursor + 1 + offset
    local finish = offset < 0 and 1 or #parent.files
    local step = offset < 0 and -1 or 1
    for i = start, finish, step do
        local target = parent.files[i]
        if target and target.cha.is_dir then
            return ya.mgr_emit("cd", { target.url })
        end
    end
end

local function follow()
    local h = cx.active.current.hovered
    if h.link_to ~= nil then return ya.mgr_emit("reveal", { tostring(h.link_to) }) end
end


return {
    entry = function(_, job)
        if job.args[1] == "parent" then return parent(tonumber(job.args[2])) end
        if job.args[1] == "follow" then return follow() end
    end,
}
