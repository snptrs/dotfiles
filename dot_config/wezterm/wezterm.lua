-- Pull in the wezterm API
local wezterm = require("wezterm")

local colors = require("themes/rose-pine").colors()
local window_frame = require("themes/rose-pine").window_frame()

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
workspace_switcher.set_zoxide_path(brew_path .. "zoxide")

config.set_environment_variables = { VTE_VERSION = "6003" }
config.font = wezterm.font_with_fallback({
	{
		family = "Lilex",
		harfbuzz_features = {
			"cv03", -- Low-stem g
			"cv09", -- Barless units
			-- "cv10", -- High asterisk
			"cv11", -- Connected bar
			"ss01", -- Arrows
			"ss03", -- Light double backslash
			"ss04", -- Broken hashes
		},
	},
	--[[ {
		family = "JetBrains Mono",
		harfbuzz_features = {
			"cv02", -- t
			"cv03", -- g
			-- "cv04", -- j
			-- "cv11", -- y
			"cv14", -- $
			"cv16", -- Q
			"cv17", -- f
			-- "cv18", -- 2, 6, 9
			"cv20", -- 5
		},
	}, ]]
	--[[ {
		family = "CommitMono",
		harfbuzz_features = {
			"ss01",
			"ss02",
			"ss03",
			"ss04",
			"ss05", -- intelligent spacing
			"cv07",
			"cv08",
		},
	}, ]]
})
config.font_size = 16
config.line_height = 1.15
config.colors = colors
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

config.mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
}

config.ssh_domains = {
	{
		name = "imac",
		remote_address = "imac",
		remote_wezterm_path = "/opt/homebrew/bin/wezterm",
	},
}

config.keys = {
	{ key = "l", mods = "SUPER", action = wezterm.action.ShowLauncher },
	{ key = "s", mods = "SUPER", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	{ key = "q", mods = "SHIFT|CTRL|OPT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{
		key = "v",
		mods = "SHIFT|CTRL|OPT",
		action = wezterm.action.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "s",
		mods = "SHIFT|CTRL|OPT",
		action = wezterm.action.SplitPane({
			direction = "Down",
		}),
	},
	{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
	{
		key = "s",
		mods = "OPT",
		action = workspace_switcher.switch_workspace(
			" | "
				.. brew_path
				.. "fd -d 1 -t d --hidden . ~/Code/Projects ~/Work/Code/Projects ~/Code/Projects/ipecs-connect 2>/dev/null"
		),
	},
}

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}
	table.insert(cells, window:active_workspace())
	table.insert(cells, pane:get_domain_name())

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
		if text == "imac" or text == "unix" then
			table.insert(elements, { Foreground = { Color = "#f6c177" } })
			table.insert(elements, { Background = { Color = colors[cell_no] } })
		else
			table.insert(elements, { Foreground = { Color = text_fg } })
			table.insert(elements, { Background = { Color = colors[cell_no] } })
		end
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
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

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return basename(tab_info.active_pane.foreground_process_name)
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

-- This is for zenmode.nvim
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

workspace_switcher.set_workspace_formatter(function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = "#f6c177" } },
		{ Text = "󱂬: " .. label },
	})
end)

-- and finally, return the configuration to wezterm
return config
