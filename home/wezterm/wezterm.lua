local wezterm = require("wezterm")

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Gruvbox Dark"
	else
		return "Gruvbox Light"
	end
end

wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

local split_horizontal = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } })
local split_vertical = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } })

return {
	automatically_reload_config = true,

	term = "wezterm",
	default_prog = { "/run/current-system/sw/bin/fish", "--login" },

	font = wezterm.font("Iosevka Nerd Font Mono"),
	font_size = 16,

	window_background_opacity = 1.0,
	adjust_window_size_when_changing_font_size = false,

	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = true,

	leader = { key = "a", mods = "CTRL" },
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },

		-- Emulate my Tmux/Screen muscle memory
		-- Shift mod is needed due to: https://github.com/wez/wezterm/issues/394
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "|", mods = "LEADER|SHIFT", action = split_horizontal },
		{ key = '"', mods = "LEADER|SHIFT", action = split_vertical },
		{ key = "LeftArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "DownArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "UpArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "RightArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

		-- Emulate Vim
		{ key = "_", mods = "LEADER|SHIFT", action = "TogglePaneZoomState" },
		{ key = "s", mods = "LEADER", action = split_horizontal },
		{ key = "v", mods = "LEADER", action = split_vertical },
		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	},

	hyperlink_rules = {
		{
			-- Linkify things that look like URLs
			-- This is actually the default if you don't specify any hyperlink_rules
			regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},
		{
			-- Make task, diff and paste numbers clickable
			regex = "\\b([tTdDpP]\\d+)\\b",
			format = "https://fburl.com/b/$1",
		},
	},

	quick_select_patterns = {
		-- Make task, diff and paste numbers quick-selectable
		"\\b([tTdDpP]\\d+)\\b",
	},
}
