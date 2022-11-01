-- icon: https://raw.githubusercontent.com/DinkDonk/kitty-icon/HEAD/kitty-dark.png
local wezterm = require("wezterm")

-- wezterm.on("update-right-status", function(window, pane)
--     local date = wezterm.strftime("%a %m/%d %I:%M %p")
--     local battery = ""
--     for _, b in ipairs(wezterm.battery_info()) do
--         local icon
--         if b.state_of_charge > 0.90 then
--             icon = "  "
--         elseif b.state_of_charge > 0.75 then
--             icon = "  "
--         elseif b.state_of_charge > 0.5 then
--             icon = "  "
--         elseif b.state_of_charge > 0.25 then
--             icon = "  "
--         elseif b.state_of_charge > 0.05 then
--             icon = "  "
--         end
--         battery = string.format("%.0f%%", b.state_of_charge * 100) .. icon
--     end
--     window:set_right_status(wezterm.format({ { Text = battery .. "   " .. date } }))
-- end)

return {
    use_ime = true,
    font = wezterm.font("JetBrainsMono Nerd Font"),
    font_size = 14,
    use_fancy_tab_bar = false,
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" }, -- disable ligatures
    warn_about_missing_glyphs = false,
    -- custom_block_glyphs = false,
    window_decorations = "RESIZE",
    text_blink_rate = 0,
    cursor_blink_rate = 0,
    -- force_reverse_video_cursor = true,
    initial_cols = 105,
    initial_rows = 30,
    scrollback_lines = 9999,
    status_update_interval = 10000,
    audible_bell = "Disabled",
    exit_behavior = "Close",
    window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
    -- color_scheme = "AtomOneLight",
    colors = {
        -- derived from OneHalfDark
        foreground = "#dcdfe4",
        background = "#35353b",
        cursor_bg = "#a3b3cc",
        cursor_border = "#a3b3cc",
        cursor_fg = "#dcdfe4",
        selection_bg = "#474e5d",
        selection_fg = "#dcdfe4",
        ansi = { "#000000", "#e06c75", "#98c379", "#e5c07b", "#61afef", "#c678dd", "#56b6c2", "#dcdfe4" },
        brights = { "#7a7a7a", "#e06c75", "#98c379", "#e5c07b", "#61afef", "#c678dd", "#56b6c2", "#dcdfe4" },
        tab_bar = {
            background = "#0b0022",
            active_tab = { bg_color = "#202022", fg_color = "#c0c0c0" },
            inactive_tab = { bg_color = "#101012", fg_color = "#808080" },
            inactive_tab_hover = { bg_color = "#1b1032", fg_color = "#808080" },
            new_tab = { bg_color = "#1b1032", fg_color = "#808080" },
            new_tab_hover = { bg_color = "#1b1032", fg_color = "#808080" },
        },
    },
    keys = {
        { key = "t", mods = "CMD", action = wezterm.action({ SpawnCommandInNewTab = { cwd = "" } }) },
        { key = "d", mods = "CMD", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
        { key = "k", mods = "CMD", action = wezterm.action({ ClearScrollback = "ScrollbackAndViewport" }) },
        { key = "f", mods = "CMD", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
        { key = "[", mods = "CMD", action = wezterm.action({ MoveTabRelative = -1 }) },
        { key = "]", mods = "CMD", action = wezterm.action({ MoveTabRelative = 1 }) },
        { key = "Enter", mods = "CMD", action = "ToggleFullScreen" },
    },
    key_tables = {
        search_mode = {
            { key = "Escape", mods = "NONE", action = wezterm.action { CopyMode = "Close" } },
            { key = "UpArrow", mods = "NONE", action = wezterm.action { CopyMode = "PriorMatch" } },
            { key = "p", mods = "CTRL", action = wezterm.action { CopyMode = "PriorMatch" } },
            { key = "PageUp", mods = "NONE", action = wezterm.action { CopyMode = "PriorMatchPage" } },
            { key = "PageDown", mods = "NONE", action = wezterm.action { CopyMode = "NextMatchPage" } },
            { key = "n", mods = "CTRL", action = wezterm.action { CopyMode = "NextMatchPage" } },
            { key = "DownArrow", mods = "NONE", action = wezterm.action { CopyMode = "NextMatch" } },
            { key = "r", mods = "CTRL", action = wezterm.action { CopyMode = "CycleMatchType" } },
            { key = "Enter", mods = "SHIFT", action = wezterm.action { CopyMode = "PriorMatch" } },
            { key = "Enter", mods = "NONE", action = wezterm.action { CopyMode = "NextMatch" } },
            { key = "w", mods = "CTRL", action = wezterm.action { CopyMode = "ClearPattern" } },
        }
    }
}
