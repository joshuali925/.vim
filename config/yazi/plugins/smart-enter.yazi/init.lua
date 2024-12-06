--- @sync entry

-- https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi
return {
    entry = function()
        local h = cx.active.current.hovered
        ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = false })
    end,
}
