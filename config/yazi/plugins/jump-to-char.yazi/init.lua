-- https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi
local AVAILABLE_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789."

local changed = ya.sync(function(st, new)
    local b = st.last ~= new
    st.last = new
    return b or not cx.active.finder
end)

local escape = function(s) return s == "." and "\\." or s end

return {
    entry = function()
        local cands = {}
        for i = 1, #AVAILABLE_CHARS do
            cands[#cands + 1] = { on = AVAILABLE_CHARS:sub(i, i) }
        end

        local idx = ya.which { cands = cands, silent = true }
        if not idx then
            return
        end

        local kw = escape(cands[idx].on)
        if changed(kw) then
            ya.manager_emit("find_do", { ("^[%s%s]"):format(kw:lower(), kw:upper()) })
        else
            ya.manager_emit("find_arrow", {})
        end
    end,
}
