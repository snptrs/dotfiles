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
config.window_decorations = "RESIZE"
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = "0.5cell",
	bottom = "0.1 cell",
}
config.initial_rows = 32
config.initial_cols = 130

config.keys = {
	{ key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },
	{ key = "s", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
}

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}
	table.insert(cells, window:active_workspace())

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		"#31748f",
		"#3783A1",
		"#3D91B2",
		"#469DC0",
		"#57A6C5",
	}

	-- Foreground color for the text across the fade
	local text_fg = "#c0c0c0"

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	local function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

-- and finally, return the configuration to wezterm
return config
