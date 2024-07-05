-- https://yazi-rs.github.io/docs/tips#user-group-in-status
function Status:owner()
    local h = cx.active.current.hovered
    if h == nil or ya.target_family() ~= "unix" then return ui.Line("") end
    return ui.Line {
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ui.Span(":"),
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        ui.Span(" "),
    }
end

function Status:mtime()
    local h = cx.active.current.hovered
    if h == nil then return ui.Line("") end
    local time = (h.cha.modified or 0) // 1
    if time == 0 then return ui.Line("") end
    return ui.Line {
        ui.Span(os.date(nil, time)):fg("cyan"),
        ui.Span(" "),
    }
end

Status._right = {
    { "permissions", id = 4, order = 1000 },
    { "owner", id = 5, order = 2000 },
    { "mtime", id = 6, order = 3000 },
    { "percentage", id = 7, order = 4000 },
    { "position", id = 8, order = 5000 },
}

require("session"):setup({ sync_yanked = true })
