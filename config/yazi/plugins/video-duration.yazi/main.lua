local video = require("video")
local row = ui.Row

ui.Row = function(cells)
    if cells[1] == "  Duration:" then
        local minutes, seconds = tostring(cells[2]):match("^(%d+):(%d%d)$")
        minutes, seconds = tonumber(minutes), tonumber(seconds)

        if minutes and minutes >= 60 then
            cells[2] = string.format("%d:%02d:%02d", math.floor(minutes / 60), minutes % 60, seconds)
        end
    end
    return row(cells)
end

return video
