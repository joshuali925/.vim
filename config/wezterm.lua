-- icon: https://raw.githubusercontent.com/DinkDonk/kitty-icon/HEAD/kitty-dark.png
local wezterm = require("wezterm")
local light_theme = false -- sync with system theme: https://wezfurlong.org/wezterm/config/lua/window/get_appearance.html
local mux = wezterm.mux
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

local search_mode = nil
if wezterm.gui then
    search_mode = wezterm.gui.default_key_tables().search_mode
    table.insert(search_mode, { key = "Enter", mods = "SHIFT", action = wezterm.action({ CopyMode = "PriorMatch" }) })
    table.insert(search_mode, { key = "Enter", mods = "NONE", action = wezterm.action({ CopyMode = "NextMatch" }) })
    table.insert(search_mode, { key = "w", mods = "CTRL", action = wezterm.action({ CopyMode = "ClearPattern" }) })
end

local tokyonight = wezterm.color.get_builtin_schemes()["tokyonight_storm"]
tokyonight.brights[1] = "#717993"

config.use_ime = true
config.font = wezterm.font_with_fallback({ { family = "JetBrainsMono Nerd Font", weight = "Medium" } })
config.font_size = 14
config.line_height = 1.1
config.use_fancy_tab_bar = false
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- disable ligatures
config.warn_about_missing_glyphs = false
-- config.custom_block_glyphs = false
config.window_decorations = "RESIZE"
config.text_blink_rate = 0
config.cursor_blink_rate = 0
config.force_reverse_video_cursor = light_theme
config.initial_cols = 105
config.initial_rows = 30
config.scrollback_lines = 9999
config.status_update_interval = 10000
config.check_for_updates_interval_seconds = 864000
config.audible_bell = "Disabled"
config.exit_behavior = "Close"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.color_schemes = { tokyonight = tokyonight }
config.color_scheme = light_theme and "Catppuccin Latte" or "tokyonight"
config.quick_select_patterns = {
    [[[\w\-.%/]*\.[\w\-.%/~]+]],
    -- TODO remove
    [[i-\w+]],
    [[\d+:[\w-]+]],
}
config.keys = {
    { key = "t", mods = "CMD", action = wezterm.action.SpawnCommandInNewTab({ domain = "CurrentPaneDomain" }) },
    { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
    { key = "d", mods = "CMD", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "k", mods = "CMD", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
    { key = "f", mods = "CMD", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
    { key = "[", mods = "CMD", action = wezterm.action.MoveTabRelative(-1) },
    { key = "]", mods = "CMD", action = wezterm.action.MoveTabRelative(1) },
    { key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
    {
        key = "'",
        mods = "META",
        action = wezterm.action.QuickSelectArgs({
            scope_lines = 0,
            action = wezterm.action_callback(function(window, pane)
                local text = window:get_selection_text_for_pane(pane)
                pane:send_text(text .. " ")
                window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)
                window:perform_action(wezterm.action.ClearSelection, pane)
            end),
        }),
    },
}
config.key_tables = { search_mode = search_mode }
config.set_environment_variables = { LIGHT_THEME = light_theme and "1" or "0" }

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez") -- install path: wezterm.plugin.list()
tabline.setup({
    options = {
        -- tabs_enabled = false, -- can't set title if enabled https://github.com/michaelbrusegard/tabline.wez/issues/56
        theme = config.color_scheme,
        section_separators = { left = wezterm.nerdfonts.ple_right_half_circle_thick, right = wezterm.nerdfonts.ple_left_half_circle_thick },
        component_separators = { left = wezterm.nerdfonts.ple_right_half_circle_thin, right = wezterm.nerdfonts.ple_left_half_circle_thin },
        tab_separators = { left = wezterm.nerdfonts.ple_right_half_circle_thick, right = wezterm.nerdfonts.ple_left_half_circle_thick },
    },
    sections = {
        tabline_a = {},
        tabline_b = {},
        tabline_c = {},
        tab_active = { "process" },
        tab_inactive = { "process" },
        tabline_x = { "cpu" },
        tabline_y = { "battery" },
        tabline_z = { { "datetime", style = "%I:%M %p" } },
    },
})

return config
