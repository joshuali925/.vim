require("session"):setup({ sync_yanked = true }) -- enable cross instance yank paste
require("smart-enter"):setup({ open_multi = true })
require("change-dir"):setup()

-- https://yazi-rs.github.io/docs/tips#user-group-in-status
Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil or ya.target_family() ~= "unix" then
        return ui.Line({})
    end
    return ui.Line({
        ui.Span(" "),
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ui.Span(":"),
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
    })
end, 1500, Status.RIGHT)

Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil then return ui.Line("") end
    local time = (h.cha.mtime or 0) // 1
    if time == 0 then return ui.Line("") end
    return ui.Line({
        ui.Span(os.date(nil, time)):fg("cyan"),
        ui.Span(" "),
    })
end, 500, Status.RIGHT)
