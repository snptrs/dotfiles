-- Pull in the wezterm API
local wezterm = require("wezterm")

local colors = require("themes/rose-pine").colors()
local window_frame = require("themes/rose-pine").window_frame()

local function get_basename(s)
	local trimmed = string.gsub(s, "(.*)/$", "%1")
	local basename = string.gsub(trimmed, "(.*/)(.*)$", "%2")
	return basename
end

-- This table will hold the configuration.
local config = {}
local brew_path = ""

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "rose-pine"
if wezterm.target_triple == "x86_64-apple-darwin" then
	brew_path = "/usr/local/bin/"
	config.default_prog = { brew_path .. "fish", "-l" }
else
	brew_path = "/opt/homebrew/bin/"
	config.default_prog = { brew_path .. "fish", "-l" }
end

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.zoxide_path = brew_path .. "zoxide"

config.leader = {
	key = "Space",
	mods = "OPT",
	timeout_milliseconds = 2000,
}

config.set_environment_variables = { VTE_VERSION = "6003" }

config.font = wezterm.font_with_fallback({ "TX-02", "Symbols Nerd Font Mono" })
config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font({
			family = "TX-02",
			weight = "Bold",
			italic = false,
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = "TX-02",
			weight = "Bold",
			italic = true,
		}),
	},
}

config.font_size = 15.8
config.line_height = 1.1
config.colors = colors
config.colors.compose_cursor = "orange"
config.default_cursor_style = "BlinkingBar"
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
config.scrollback_lines = 3000
config.quit_when_all_windows_are_closed = false
config.force_reverse_video_cursor = false

config.mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
}

config.ssh_domains = {
	{
		name = "mac",
		remote_address = "mac",
		remote_wezterm_path = "/opt/homebrew/bin/wezterm",
	},
}

config.keys = {
	{ key = "l", mods = "LEADER", action = wezterm.action.ShowLauncher },
	-- { key = "s", mods = "SUPER", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	{ key = "w", mods = "SUPER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{
		key = "d",
		mods = "SUPER",
		action = wezterm.action.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "d",
		mods = "SUPER|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
		}),
	},
	{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
	{
		key = "s",
		mods = "SUPER",
		action = workspace_switcher.switch_workspace({
			extra_args = " | "
				.. brew_path
				.. "fd -d 1 -t d --hidden . ~/Code/Projects ~/Work/Code/Projects ~/Code/Projects/ipecs-connect 2>/dev/null",
		}),
	},
}

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	local active_workspace = get_basename(window:active_workspace())
	table.insert(cells, get_basename(active_workspace))

	local domain_name = pane:get_domain_name()
	if domain_name ~= "local" then
		table.insert(cells, pane:get_domain_name())
	end

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local status_colors = {
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
		if text == "mac" or text == "unix" then
			text = "󰢹 " .. text
			table.insert(elements, { Foreground = { Color = "#f6c177" } })
			table.insert(elements, { Background = { Color = status_colors[cell_no] } })
		else
			table.insert(elements, { Foreground = { Color = text_fg } })
			table.insert(elements, { Background = { Color = status_colors[cell_no] } })
		end

		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = status_colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
			num_cells = num_cells + 1
		end
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	local process_name = tab_info.active_pane.foreground_process_name
	return get_basename(process_name)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if tab.active_pane.title:find("^Copy mode") ~= nil then
		local title = "📋 COPY MODE"
		return {
			{ Background = { Color = "#eb6f92" } },
			{ Text = " " .. tab.tab_index + 1 .. ": " .. title .. " " },
		}
	else
		local title = tab_title(tab)
		return {
			{ Text = " " .. tab.tab_index + 1 .. ": " .. title .. " " },
		}
	end
end)

workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = "#f6c177" } },
		{ Text = "󱂬: " .. label },
	})
end

-- and finally, return the configuration to wezterm
return config
