--- @sync entry

-- https://github.com/yazi-rs/plugins/tree/main/max-preview.yazi
local function entry(st)
    if st.old then
        Tab.layout, st.old = st.old, nil
    else
        st.old = Tab.layout
        Tab.layout = function(self)
            self._chunks = ui.Layout()
                :direction(ui.Layout.HORIZONTAL)
                :constraints({
                    ui.Constraint.Percentage(0),
                    ui.Constraint.Percentage(0),
                    ui.Constraint.Percentage(100),
                })
                :split(self._area)
        end
    end
    ya.app_emit("resize", {})
end

local function enabled(st) return st.old ~= nil end

return { entry = entry, enabled = enabled }
