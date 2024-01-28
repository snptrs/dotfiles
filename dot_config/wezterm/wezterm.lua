-- Pull in the wezterm API
local wezterm = require("wezterm")

local colors = require("themes/rose-pine").colors()
local window_frame = require("themes/rose-pine").window_frame()

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "rose-pine"
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.set_environment_variables = { VTE_VERSION = "6003" }
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font_size = 13.5
config.line_height = 1.2
config.colors = colors
config.window_frame = window_frame

config.keys = {
	{ key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },
	{ key = "s", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
}

-- and finally, return the configuration to wezterm
return config
