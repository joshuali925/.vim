-- icon: https://raw.githubusercontent.com/DinkDonk/kitty-icon/HEAD/kitty-dark.png
local wezterm = require("wezterm")
local light_theme = false -- sync with system theme: https://wezfurlong.org/wezterm/config/lua/window/get_appearance.html
local mux = wezterm.mux
local config = wezterm.config_builder()
local uploading_host = nil

-- config.animation_fps = 240
-- config.max_fps = 240
-- config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"

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
config.macos_fullscreen_extend_behind_notch = true
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- disable ligatures
config.warn_about_missing_glyphs = false
-- config.custom_block_glyphs = false
config.window_decorations = "RESIZE|MACOS_FORCE_SQUARE_CORNERS"
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
config.window_content_alignment = { horizontal = "Center", vertical = "Center" }
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
    { key = "t", mods = "CMD|SHIFT", action = wezterm.action.SpawnCommandInNewTab({ args = { os.getenv("HOME") .. "/.local/bin/nu" }, domain = "CurrentPaneDomain" }) },
    {
        key = "v",
        mods = "CMD|SHIFT",
        action = wezterm.action_callback(function(window, pane)
            local info = pane:get_foreground_process_info()
            if not info or not info.executable:match("/ssh$") then return window:perform_action(wezterm.action.SendKey({ key = "v", mods = "CTRL" }), pane) end
            uploading_host = nil
            local i = 2
            while not uploading_host and i <= #info.argv do
                if info.argv[i]:match("^%-[bcDEeFIiJLlmOopQRSWw]$") then
                    i = i + 2
                elseif info.argv[i]:sub(1, 1) == "-" then
                    i = i + 1
                else
                    uploading_host = info.argv[i]
                end
            end
            if not uploading_host then return end
            wezterm.emit("update-status", window, pane)
            local ok_info, out_info, _ = wezterm.run_child_process({ "sh", "-c", "pbpaste | wc -c" }) -- unreliable but faster than osascript -e clipboard info
            if not ok_info or tonumber(out_info) ~= 0 then
                uploading_host = nil
                return
            end
            pane:send_text("/tmp/clipboard.jpg ")
            wezterm.time.call_after(0.05, function()
                local ok, _, _ = wezterm.run_child_process({
                    "sh", "-c",
                    ([[osascript -e 'tell application "System Events" to write (the clipboard as «class PNGf») to (open for access POSIX file "/tmp/clipboard.png" with write permission)' && scp /tmp/clipboard.png %s:/tmp/clipboard.png && rm -f /tmp/clipboard.png && ssh %s '.vim/bin/ffmpeg -y -i /tmp/clipboard.png -vf "scale='"'"'min(1568,iw)'"'"':'"'"'min(1568,ih)'"'"':force_original_aspect_ratio=decrease" -q:v 10 /tmp/clipboard.jpg && rm -f /tmp/clipboard.png']]):format(uploading_host, uploading_host),
                })
                uploading_host = nil
                wezterm.emit("update-status", window, pane)
                if not ok then pane:send_text("Wait, upload failed!") end
            end)
        end),
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
        tabline_x = {
            function() return uploading_host and ("󰘿 %s "):format(uploading_host) or "" end,
            "cpu",
        },
        tabline_y = { "battery" },
        tabline_z = { { "datetime", style = "%I:%M %p" } },
    },
})

return config
