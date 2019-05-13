-----------------------------------------------------------------------------------------------------------------------
--                                                Colorless theme                                                    --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

local theme = {}

-- Color scheme
-----------------------------------------------------------------------------------------------------------------------
theme.color = {
	main      = "#4CB7DB",
	gray      = "#928374",
	bg        = "#282828",
	bg_second = "#181818",
	wibox     = "#282828",
	icon      = "#FFFFFF",
	icon_focus= "#4CB7DB",
	text      = "#FFFFFF",
	urgent    = "#CC241D",
	highlight = "#CCC11D",
	border    = "#404040",

	shadow1   = "#141414",
	shadow2   = "#313131",
	shadow3   = "#1c1c1c",
	shadow4   = "#767676",

	button    = "#575757",
	pressed   = "#404040",

	desktop_gray = "#404040",
	desktop_icon = "#606060",

  titlebar_fg_normal = "#606060",
	background = "#303030"
}

-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "colorless"
theme.homedir = os.getenv("HOME")

-- Main config
------------------------------------------------------------
theme.panel_height        = 32
theme.border_width        = 4
theme.useless_gap         = 10
theme.useless_gap_naughty = 0

theme.cellnum = { x = 96, y = 58 } -- grid layout property

theme.wallpaper = theme.path .. "/icons/wallpaper/plasma.png"

-- Fonts
------------------------------------------------------------
theme.fonts = {
	main     = "sans 12",      -- main font
	menu     = "sans 12",      -- main menu font
	tooltip  = "sans 12",      -- tooltip font
	notify   = "sans bold 10", -- redflat notify popup font
	clock    = "sans bold 12", -- textclock widget font
	time     = "Roboto Bold 10", -- texttime widget font
	qlaunch  = "sans bold 14", -- quick launch key label font
	title    = "sans bold 12", -- widget titles font
	keychain = "sans bold 14", -- key sequence tip font
	titlebar = "sans bold 12", -- client titlebar font
	hotkeys = {
		main  = "sans 10",      -- hotkeys helper main font
		key   = "mono 10",      -- hotkeys helper key font (use monospace for align)
		title = "sans bold 12", -- hotkeys helper group title font
	},
}

theme.cairo_fonts = {
	tag         = { font = "Roboto Bold", size = 12, face = 1 }, -- tag widget font
	--tag         = { font = "Sans", size = 16, face = 1 }, -- tag widget font
	appswitcher = { font = "Sans", size = 22, face = 1 }, -- appswitcher widget font
	navigator   = {
		title = { font = "Sans", size = 28, face = 1, slant = 0 }, -- window navigation title font
		main  = { font = "Sans", size = 22, face = 1, slant = 0 }  -- window navigation  main font
	},
	desktop = {
		textbox = { font = "Sans", size = 24, face = 1 },
	},
}

-- Shared icons
--------------------------------------------------------------------------------
theme.icon = {
	check    = theme.path .. "/icons/common/check.svg",
	blank    = theme.path .. "/icons/common/blank.svg",
	warning  = theme.path .. "/icons/common/warning.svg",
	awesome  = theme.path .. "/icons/common/awesome.svg",
}



-- Main theme settings
-- Make it updatabele since it may depends on common
-----------------------------------------------------------------------------------------------------------------------
function theme:init()

	-- Service utils config
	----------------------------------------------------------------------------------
	self.service = {}

	-- Window control mode appearance
	--------------------------------------------------------------------------------
	self.service.navigator = {
		border_width = 0,  -- window placeholder border width
		gradstep     = 60, -- window placeholder background stripes width
		marksize = {       -- window information plate size
			width  = 160, -- width
			height = 80,  -- height
			r      = 20   -- corner roundness
		},
		linegap   = 32, -- gap between two lines on window information plate
		timeout   = 1,  -- highlight duration
		notify    = {}, -- redflat notify style (see theme.float.notify)
		titlefont = self.cairo_fonts.navigator.title, -- first line font on window information plate
		font      = self.cairo_fonts.navigator.main,  -- second line font on window information plate

		-- array of hot key marks for window placeholders
		num = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "F1", "F3", "F4", "F5" },

		-- colors
		color = {
			border = self.color.main,         -- window placeholder border color
			mark = self.color.gray,           -- window information plate background color
			text = self.color.wibox,          -- window information plate text color
			fbg1 = self.color.main .. "40",   -- first background color for focused window placeholder
			fbg2 = self.color.main .. "20",   -- second background color for focused window placeholder
			hbg1 = self.color.urgent .. "40", -- first background color for highlighted window placeholder
			hbg2 = self.color.urgent .. "20", -- second background color for highlighted window placeholder
			bg1  = self.color.gray .. "40",   -- first background color for window placeholder
			bg2  = self.color.gray .. "20"    -- second background color for window placeholder
		}
	}

	-- layout hotkeys helper settings
	self.service.navigator.keytip = {}

	-- this one used as fallback when style for certain layout missed
	self.service.navigator.keytip["base"] = { geometry = { width = 600 }, exit = true }

	-- styles for certain layouts
	self.service.navigator.keytip["fairv"] = { geometry = { width = 600}, exit = true }
	self.service.navigator.keytip["fairh"] = self.service.navigator.keytip["fairv"]
	self.service.navigator.keytip["spiral"] = self.service.navigator.keytip["fairv"]
	self.service.navigator.keytip["dwindle"] = self.service.navigator.keytip["fairv"]

	self.service.navigator.keytip["tile"] = { geometry = { width = 600 }, exit = true }
	self.service.navigator.keytip["tileleft"]   = self.service.navigator.keytip["tile"]
	self.service.navigator.keytip["tiletop"]    = self.service.navigator.keytip["tile"]
	self.service.navigator.keytip["tilebottom"] = self.service.navigator.keytip["tile"]

	self.service.navigator.keytip["cornernw"] = { geometry = { width = 600 }, exit = true }
	self.service.navigator.keytip["cornerne"] = self.service.navigator.keytip["cornernw"]
	self.service.navigator.keytip["cornerse"] = self.service.navigator.keytip["cornernw"]
	self.service.navigator.keytip["cornersw"] = self.service.navigator.keytip["cornernw"]

	self.service.navigator.keytip["magnifier"] = { geometry = { width = 600}, exit = true }

	self.service.navigator.keytip["grid"] = { geometry = { width = 1400 }, column = 2, exit = true }
	self.service.navigator.keytip["usermap"] = { geometry = { width = 1400 }, column = 2, exit = true }

	-- Desktop file parser
	--------------------------------------------------------------------------------
	self.service.dfparser = {
		-- list of path to check desktop files
		desktop_file_dirs = {
			'/usr/share/applications/',
			'/usr/local/share/applications/',
			'~/.local/share/applications',
		},
		-- icon theme settings
		icons = {
			theme         = nil, -- user icon theme path
			--theme         = "/usr/share/icons/ACYLS", -- for example
			df_icon       = self.icon.system, -- default (fallback) icon
			custom_only   = false, -- use icons from user theme (no system fallback like 'hicolor' allowed) only
			scalable_only = false  -- use vector(svg) icons (no raster icons allowed) only
		},
		wm_name = nil -- window manager name
	}


	-- Menu config
	--------------------------------------------------------------------------------
	self.menu = {
		border_width = 4, -- menu border width
		screen_gap   = self.useless_gap + self.border_width, -- minimal space from screen edge on placement
		height       = 32,  -- menu item height
		width        = 250, -- menu item width
		icon_margin  = { 8, 8, 8, 8 }, -- space around left icon in menu item
		ricon_margin = { 9, 9, 9, 9 }, -- space around right icon in menu item
		nohide       = false, -- do not hide menu after item activation
		auto_expand  = true,  -- show submenu on item selection (without item activation)
		auto_hotkey  = false, -- automatically set hotkeys for all menu items
		select_first = true,  -- auto select first item when menu shown
		hide_timeout = 1,     -- auto hide timeout (auto hide disables if this set to 0)
		font         = self.fonts.menu,   -- menu font
		submenu_icon = self.icon.submenu, -- icon for submenu items
		keytip       = { geometry = { width = 400 } }, -- hotkeys helper settings
		shape        = nil, -- wibox shape
		svg_scale    = { false, false }, -- use vector scaling for left, right icons in menu item
	}

	self.menu.color = {
		border       = self.color.wibox,     -- menu border color
		text         = self.color.text,      -- menu text color
		highlight    = self.color.highlight, -- menu text and icons color for selected item
		main         = self.color.main,      -- menu selection color
		wibox        = self.color.wibox,     -- menu background color
		submenu_icon = self.color.icon,      -- submenu icon color
		right_icon   = nil,                  -- right icon color in menu item
		left_icon    = nil,                  -- left icon color in menu item
	}


	-- Gauge (various elements that used as component for other widgets) style
	--------------------------------------------------------------------------------
	self.gauge = { tag = {}, task = {}, icon = {}, audio = {}, monitor = {}, graph = {} }

	-- Plain progressbar element
	------------------------------------------------------------
	self.gauge.graph.bar = {
		color = self.color -- colors (main used)
}

	-- Icon indicator (decoration in some panel widgets)
	------------------------------------------------------------
	self.gauge.icon.single = {
		icon        = self.icon.system,  -- default icon
		is_vertical = false,             -- use vertical gradient (horizontal if false)
		step        = 0.02,              -- icon painting step
		color       = self.color         -- colors (main used)
	}

	-- Double icon indicator
	--------------------------------------------------------------
	self.gauge.icon.double = {
		icon1       = self.icon.system,  -- first icon
		icon2       = self.icon.system,  -- second icon
		is_vertical = true,              -- use vertical gradient (horizontal if false)
		igap        = 4,                 -- gap between icons
		step        = 0.02,              -- icon painting step
		color       = self.color         -- colors (main used)
	}

	-- Separator (decoration used on panel, menu and some other widgets)
	------------------------------------------------------------
	self.gauge.separator = {
		marginv = { 2, 2, 4, 4 }, -- margins for vertical separator
		marginh = { 6, 6, 3, 3 }, -- margins for horizontal separator
		color  = self.color       -- color (secondary used)
	}

	-- Step like dash bar (user for volume widgets)
	------------------------------------------------------------
	self.gauge.graph.dash = {
		bar = {
			width = 4, -- dash element width
			num   = 10 -- number of dash elements
		},
		color = self.color -- color (main used)
	}

	-- Dotcount (used in minitray widget)
	------------------------------------------------------------
	self.gauge.graph.dots = {
		column_num   = { 3, 5 },  -- amount of dot columns (min/max)
		row_num      = 3,         -- amount of dot rows
		dot_size     = 4,         -- dots size
		dot_gap_h    = 3,         -- horizontal gap between dot (with columns number it'll define widget width)
		color        = self.color -- colors (main used)
	}

	-- Circle shaped monitor
	--------------------------------------------------------------
	self.gauge.monitor.circle = {
		width        = 22,        -- widget width
		line_width   = 2,         -- width of circle
		iradius      = 3,         -- radius for center point
		radius       = 6,        -- circle radius
		step        = 0.05,       -- circle painting step
		color        = self.color -- colors (main used)
	}

	-- Tag (base element of taglist)
	------------------------------------------------------------
	self.gauge.tag.orange = {
		width        = 22,                                   -- widget width
		line_width   = self.gauge.monitor.circle.line_width, -- width of arcs
		iradius      = self.gauge.monitor.circle.iradius,    -- radius for center point
		radius       = self.gauge.monitor.circle.radius,     -- arcs radius
		cgap         = 0.314,                                -- gap between arcs in radians
		min_sections = 1,                                    -- minimal amount of arcs
		show_min     = false,                                -- indicate minimized apps by color
		color        = self.color                            -- colors (main used)
	}


	-- Task (base element of tasklist)
	------------------------------------------------------------

	-- the same structure as blue tag
	self.gauge.task.blue = {
		width      = 70,
		show_min   = true,
		text_shift = 20,
		color      = self.color,
		font       = self.cairo_fonts.tag,
		point    = { width = 70, height = 3, gap = 27, dx = 5 },
	}



	-- Panel widgets
	--------------------------------------------------------------------------------
	self.widget = {}

	-- individual margins for panel widgets
	------------------------------------------------------------
	self.widget.wrapper = {
		mainmenu    = { 12, 10, 6, 6 },
		layoutbox   = { 10, 10, 6, 6 },
		textclock   = { 12, 12, 0, 0 },
		texttime   = { 0, 0, 5, 5 },
		taglist     = { 4, 4, 0, 0 },
		tray        = { 10, 12, 7, 7 },
		systray	       = { 0, 0, 2, 0 },
		-- tasklist    = { 0, 70, 0, 0 }, -- centering tasklist widget
	}

	-- Textclock
	------------------------------------------------------------
	self.widget.textclock = {
		font    = self.fonts.clock,          -- font
		tooltip = {},                        -- redflat tooltip style (see theme.float.tooltip)
		color   = { text = self.color.icon } -- colors
	}

	-- Texttime
	------------------------------------------------------------
	self.widget.texttime = {
		font    = self.fonts.time,          -- font
		tooltip = {},                        -- redflat tooltip style (see theme.float.tooltip)
		color   = { text = self.color.icon, background = "#303030" } -- colors
	}

	-- Minitray
	------------------------------------------------------------
	self.widget.minitray = {
		geometry     = { width = 40 }
	}

	-- Layoutbox
	------------------------------------------------------------
	self.widget.layoutbox = {
		micon = self.icon,  -- some common menu icons (used: 'blank', 'check')
		color = self.color  -- colors (main used)
	}

	-- layout icons
	self.widget.layoutbox.icon = {
		floating          = self.path .. "/icons/layouts/floating.svg",
		max               = self.path .. "/icons/layouts/max.svg",
		fullscreen        = self.path .. "/icons/layouts/fullscreen.svg",
		tilebottom        = self.path .. "/icons/layouts/tilebottom.svg",
		tileleft          = self.path .. "/icons/layouts/tileleft.svg",
		tile              = self.path .. "/icons/layouts/tile.svg",
		tiletop           = self.path .. "/icons/layouts/tiletop.svg",
		fairv             = self.path .. "/icons/layouts/fair.svg",
		fairh             = self.path .. "/icons/layouts/fair.svg",
		grid              = self.path .. "/icons/layouts/grid.svg",
		usermap           = self.path .. "/icons/layouts/map.svg",
		magnifier         = self.path .. "/icons/layouts/magnifier.svg",
		spiral            = self.path .. "/icons/layouts/spiral.svg",
		cornerne          = self.path .. "/icons/layouts/cornerne.svg",
		cornernw          = self.path .. "/icons/layouts/cornernw.svg",
		cornerse          = self.path .. "/icons/layouts/cornerse.svg",
		cornersw          = self.path .. "/icons/layouts/cornersw.svg",
		unknown           = self.icon.unknown,  -- this one used as fallback
	}

	-- redflat menu style (see theme.menu)
	self.widget.layoutbox.menu = {
		icon_margin  = { 8, 12, 8, 8 },
		width        = 260,
		auto_hotkey  = true,
		nohide       = false,
		color        = { right_icon = self.color.icon, left_icon = self.color.icon }
	}

	-- human readable aliases for layout names (displayed in menu and tooltip)
	self.widget.layoutbox.name_alias = {
		floating          = "Floating",
		fullscreen        = "Fullscreen",
		max               = "Maximized",
		grid              = "Grid",
		usermap           = "User Map",
		tile              = "Right Tile",
		fairv             = "Fair Tile",
		tileleft          = "Left Tile",
		tiletop           = "Top Tile",
		tilebottom        = "Bottom Tile",
		magnifier         = "Magnifier",
		spiral            = "Spiral",
		cornerne          = "Corner NE",
		cornernw          = "Corner NW",
		cornerse          = "Corner SE",
		cornersw          = "Corner SW",
	}

	-- Tasklist
	--------------------------------------------------------------

	-- main settings
	self.widget.tasklist = {
		need_group  = false,  -- group application instances into one task element
		task        = self.gauge.task.blue -- style for task gauge widget
	}

	-- menu settings
	self.widget.tasklist.winmenu = {
		micon          = self.icon, -- some common menu icons
		titleline      = {
			font = self.fonts.title, -- menu title height
			height = 25              -- menu title font
		},
		stateline      = { height = 30 },              -- height of menu item with state icons
		state_iconsize = { width = 18, height = 18 },  -- size for state icons
		layout_icon    = self.widget.layoutbox.icon,   -- list of layout icons
		separator      = { marginh = { 3, 3, 5, 5 } }, -- redflat separator style (see theme.gauge.separator)
		color          = self.color,                   -- colors (main used)

		-- main menu style (see theme.menu)
		menu = { width = 200, color = { right_icon = self.color.icon }, ricon_margin = { 9, 9, 9, 9 } },

		-- tag action submenu style (see theme.menu)
		tagmenu = { width = 160, color = { right_icon = self.color.icon, left_icon = self.color.icon },
		            icon_margin = { 9, 9, 9, 9 } },

		-- set which action will hide menu after activate
		hide_action = { min = true, move = true, max = false, add = false, floating = false, sticky = false,
		                ontop = false, below = false, maximized = false },
	}

	-- menu icons
	self.widget.tasklist.winmenu.icon = {
		floating             = theme.path .. "/icons/common/window_control/floating.svg",
		sticky               = theme.path .. "/icons/common/window_control/pin.svg",
		ontop                = theme.path .. "/icons/common/window_control/ontop.svg",
		below                = theme.path .. "/icons/common/window_control/below.svg",
		close                = theme.path .. "/icons/common/window_control/close.svg",
		minimize             = theme.path .. "/icons/common/window_control/minimize.svg",
		maximized            = theme.path .. "/icons/common/window_control/maximized.svg",

		unknown   = self.icon.unknown, -- this one used as fallback
	}

	-- multiline task element tip
	self.widget.tasklist.tasktip = {
		border_width = 2,                -- tip border width
		margin       = { 10, 10, 5, 5 }, -- margins around text in tip lines
		timeout      = 0.5,              -- hide timeout
		shape        = nil,              -- wibox shape
		sl_highlight = false,            -- highlight application state when it's single line tip
		color = self.color,              -- colors (main used)
	}

	-- task text aliases
	self.widget.tasklist.appnames = {}
	-- self.widget.tasklist.appnames["Firefox"             ] = "FIFOX"
	-- self.widget.tasklist.appnames["Gnome-terminal"      ] = "GTERM"


	-- Floating widgets
	--------------------------------------------------------------------------------
	self.float = { decoration = {} }

	-- Brightness control
	------------------------------------------------------------
	self.float.brightness = {
		notify = { icon = theme.path .. "/icons/widget/brightness.svg"} -- redflat notify style (see theme.float.notify)
	}

	-- Client menu
	------------------------------------------------------------
	self.float.clientmenu = {
		actionline      = { height = 28 },             -- height of menu item with action icons
		action_iconsize = { width = 18, height = 18 }, -- size for action icons
		stateline       = { height = 30 },             -- height of menu item with state icons

		-- redflat separator style(see theme.gauge.separator)
		separator       = { marginh = { 3, 3, 5, 5 }, marginv = { 3, 3, 3, 3 } },

		-- same elements as for task list menu
		icon            = self.widget.tasklist.winmenu.icon,
		micon           = self.widget.tasklist.winmenu.micon,
		layout_icon     = self.widget.layoutbox.icon,
		menu            = self.widget.tasklist.winmenu.menu,
		state_iconsize  = self.widget.tasklist.winmenu.state_iconsize,
		tagmenu         = self.widget.tasklist.winmenu.tagmenu,
		hide_action     = self.widget.tasklist.winmenu.hide_action,
		color           = self.color,
	}

	-- Top processes
	------------------------------------------------------------
	self.float.top = {
		geometry      = { width = 460, height = 400 }, -- widget size
		screen_gap    = 2 * self.useless_gap,          -- minimal space from screen edge on floating widget placement
		border_margin = { 20, 20, 10, 0 },             -- margins around widget content
		button_margin = { 140, 140, 18, 18 },          -- margins around kill button
		title_height  = 40,                            -- widget title height
		border_width  = 0,                             -- widget border width
		bottom_height = 70,                            -- kill button area height
		list_side_gap = 8,                             -- left/rigth borger margin for processes list
		title_font    = self.fonts.title,              -- widget title font
		timeout       = 2,                             -- widget update timeout
		shape         = nil,                           -- wibox shape
		color         = self.color,                    -- color (main used)

		-- list columns width
		labels_width  = { num = 30, cpu = 70, mem = 120 },

		-- redflat key tip settings
		keytip        = { geometry = { width = 400 } },

		-- placement function
		set_position  = nil,
	}


	-- Application swit`cher
	------------------------------------------------------------
	self.float.appswitcher = {
		wibox_height    = 240, -- widget height
		label_height    = 28,  -- height of the area with application mark(key)
		title_height    = 40,  -- height of widget title line (application name and tag name)
		icon_size       = 96,  -- size of the application icon in preview area
		preview_gap     = 20,  -- gap between preview areas
		shape           = nil, -- wibox shape

		-- desktop file parser settings (see theme.service.dfparser)
		parser = {
			desktop_file_dirs = awful.util.table.join(
				self.service.dfparser.desktop_file_dirs,
				{ '~/.local/share/applications-fake' }
			)
		},

		border_margin   = { 10, 10, 0, 10 },  -- margins around widget content
		preview_margin  = { 15, 15, 15, 15 }, -- margins around application preview
		preview_format  = 16 / 10,            -- preview acpect ratio
		title_font      = self.fonts.title,   -- font of widget title line
		border_width    = 0,                  -- widget border width
		update_timeout  = 1 / 12,             -- application preview update timeout
		min_icon_number = 4,                  -- this one will define the minimal widget width
		                                      -- (widget will not shrink if number of apps items less then this)
		color           = self.color,         -- colors (main used)
		font            = self.cairo_fonts.appswitcher, -- font of application mark(key)

		-- redflat key tip settings
		keytip         = { geometry = { width = 400 }, exit = true },
	}

	-- additional color
	self.float.appswitcher.color.preview_bg = self.color.main .. "12"

	-- application marks(keys) list
	self.float.appswitcher.hotkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
	                                   "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12" }

	-- Quick launcher
	------------------------------------------------------------
	self.float.qlaunch = {
		geometry      = { width = 1400, height = 170 }, -- widget size

		border_width  = 0,                   -- widget border width
		border_margin = { 5, 5, 12, 15 },    -- margins around widget content
		notify        = {},                  -- redflat notify style (see theme.float.notify)
		shape         = nil,                 -- wibox shape
		recoloring    = false,               -- apply redflat recoloring feature on application icons
		label_font    = self.fonts.qlaunch,  -- font of application mark(key)
		color         = self.color,          -- colors (main used)
		df_icon       = self.icon.system,    -- fallback application icon
		no_icon       = self.icon.unknown,   -- icon for unused application slot

		-- desktop file parser settings (see theme.service.dfparser)
		parser = {
			desktop_file_dirs = awful.util.table.join(
				self.service.dfparser.desktop_file_dirs,
				{ '~/.local/share/applications-fake' }
			)
		},

		appline       = {
			iwidth = 140,           -- application item width
			im = { 5, 5, 0, 0 },    -- margins around application item area
			igap = { 0, 0, 5, 15 }, -- margins around application icon itself (will affect icon size)
			lheight = 26            -- height of application mark(key) area
		},
		state         = {
			gap = 5,    -- space between application state marks
			radius = 5, -- application state mark radius
			size = 10,  -- application state mark size
			height = 14 -- height of application state marks area
		},

		-- redflat key tip settings
		keytip        = { geometry = { width = 600 } },

		-- file to store widget data
		-- this widget is rare one which need to keep settings between sessions
		configfile      = os.getenv("HOME") .. "/.cache/awesome/applist",
	}

	-- Hotkeys helper
	------------------------------------------------------------
	self.float.hotkeys = {
		geometry      = { width = 1400 }, -- widget size
		border_margin = { 20, 20, 8, 10 },              -- margins around widget content
		border_width  = 0,                              -- widget border width
		delim         = "   ",                          -- text separator between key and description
		tspace        = 5,                              -- space between lines in widget title
		is_align      = true,                           -- align keys description (monospace font required)
		separator     = { marginh = { 0, 0, 3, 6 } },   -- redflat separator style (see theme.gauge.separator)
		font          = self.fonts.hotkeys.main,        -- keys description font
		keyfont       = self.fonts.hotkeys.key,         -- keys font
		titlefont     = self.fonts.hotkeys.title,       -- widget title font
		shape         = nil,                            -- wibox shape
		color         = self.color,                     -- colors (main used)

		-- manual setup for expected text line heights
		-- used for auto adjust widget height
		heights       = {
			key   = 20, -- hotkey tip line height
			title = 22  -- group title height
		},
	}

	-- Titlebar helper
	------------------------------------------------------------
	self.float.bartip = {
		geometry      = { width = 260, height = 40 }, -- widget size
		border_margin = { 10, 10, 10, 10 },           -- margins around widget content
		border_width  = 0,                            -- widget border widthj
		font          = self.fonts.title,             -- widget font
		set_position  = nil,                          -- placement function
		shape         = nil,                          -- wibox shape
		names         = { "Mini", "Plain", "Full" },  -- titlebar layout names
		color         = self.color,                   -- colors (main used)

		-- margin around widget elements
		margin        = { icon = { title = { 10, 10, 8, 8 }, state = { 10, 10, 8, 8 } } },

		-- widget icons
		icon          = {
			title    = self.path .. "/icons/titlebar/title.svg",
			active   = self.path .. "/icons/titlebar/active.svg",
			hidden   = self.path .. "/icons/titlebar/hidden.svg",
			disabled = self.path .. "/icons/titlebar/disabled.svg",
			absent   = self.path .. "/icons/titlebar/absent.svg",
			unknown  = self.icon.unknown,
		},

		-- redflat key tip settings
		keytip        = { geometry = { width = 540 } },
	}

	-- Floating window control helper
	------------------------------------------------------------
	self.float.control = {
		geometry      = { width = 260, height = 48 }, -- widget size
		border_margin = { 10, 10, 10, 10 },           -- margins around widget content
		border_width  = 0,                            -- widget border widthj
		font          = self.fonts.title,             -- widget font
		steps         = { 1, 10, 25, 50, 200 },       -- move/resize step
		default_step  = 3,                            -- select default step by index
		onscreen      = true,                         -- no off screen for window placement
		set_position  = nil,                          -- widget placement function
		shape         = nil,                          -- wibox shape
		color         = self.color,                   -- colors (main used)

		-- margin around widget elements
		margin = { icon = { onscreen = { 10, 10, 8, 8 }, mode = { 10, 10, 8, 8 } } },

		-- widget icons
		icon = {
			onscreen = self.icon.system,
			resize   = {},
		},

		-- redflat key tip settings
		keytip = { geometry = { width = 540 } },
	}

	-- Key sequence tip
	------------------------------------------------------------
	self.float.keychain = {
		geometry        = { width = 250, height = 56 }, -- default widget size
		font            = self.fonts.keychain,          -- widget font
		border_width    = 2,                            -- widget border width
		shape           = nil,                          -- wibox shape
		color           = self.color,                   -- colors (main used)

		-- redflat key tip settings
		keytip          = { geometry = { width = 600 }, column = 1 },
	}

	-- Tooltip
	------------------------------------------------------------
	self.float.tooltip = {
		timeout      = 0,                  -- show delay
		shape        = nil,                -- wibox shapea
		font         = self.fonts.tooltip, -- widget font
		border_width = 2,                  -- widget border width
		set_position = nil,                -- function to setup tooltip position when shown
		color        = self.color,         -- colors (main used)

		-- padding around widget content
		padding      = { vertical = 3, horizontal = 6 },
	}

	-- Floating prompt
	------------------------------------------------------------
	self.float.prompt = {
		geometry     = { width = 620, height = 120 }, -- widget size
		border_width = 0,                             -- widget border width
		margin       = { 20, 20, 40, 40 },            -- margins around widget content
		field        = nil,                           -- redflat text field style (see theme.float.decoration.field)
		shape        = nil,                           -- wibox shape
		naughty      = {},                            -- awesome notification style
		color        = self.color,                    -- colors (main used)
	}

	-- Notify (redflat notification widget)
	------------------------------------------------------------
	self.float.notify = {
		geometry        = { width = 484, height = 106 }, -- widget size
		screen_gap      =  5,--2 * self.useless_gap,          -- screen edges gap on placement
		border_margin   = { 20, 20, 20, 20 },            -- margins around widget content
		elements_margin = { 20, 0, 10, 10 },             -- margins around main elements (text and bar)
		font            = self.fonts.notify,             -- widget font
		icon            = self.icon.warning,             -- default widget icon
		border_width    = 0,                             -- widget border width
		timeout         = 5,                             -- hide timeout
		shape           = nil,                           -- wibox shape
		color           = self.color,                    -- colors (main used)

		-- progressbar is optional element used for some notifications
		bar_width       = 30,                             -- progressbar width
		progressbar     = {},                            -- redflat progressbar style (see theme.gauge.graph.bar)

		-- placement function
		set_position = function(wibox)
			wibox:geometry({ x = mouse.screen.workarea.x + mouse.screen.workarea.width, y = mouse.screen.workarea.y })
		end,
	}

	-- Decoration (various elements that used as component for other widgets) style
	--------------------------------------------------------------------------------
	self.float.decoration.button = {
		color = self.color  -- colors (secondary used)
	}

	self.float.decoration.field = {
		color = self.color  -- colors (secondary used)
	}


	-- Titlebar
	--------------------------------------------------------------------------------
	self.titlebar = {}

	self.titlebar.base = {
		position      = "top",               -- titlebar position
		font          = self.fonts.titlebar, -- titlebar font
		border_margin = { 0, 0, 0, 4 },      -- margins around titlebar active area
		color         = self.color,          -- colors (main used)
	}

	-- application state marks settings
	self.titlebar.mark = {
		color = self.color, -- colors (main used)
	}

	-- application control icon settings
	self.titlebar.icon = {
		color = self.color, -- colors (main used)

		-- icons list
		list = {
			focus     = self.path .. "/icons/titlebar/focus.svg",
			floating  = self.path .. "/icons/titlebar/floating.svg",
			ontop     = self.path .. "/icons/titlebar/ontop.svg",
			below     = self.path .. "/icons/titlebar/below.svg",
			sticky    = self.path .. "/icons/titlebar/pin.svg",
			maximized = self.path .. "/icons/titlebar/maximized.svg",
			minimized = self.path .. "/icons/titlebar/minimize.svg",
			close     = self.path .. "/icons/titlebar/close.svg",
			menu      = self.path .. "/icons/titlebar/menu.svg",

			unknown   = self.icon.unknown, -- this one used as fallback
		}
	}



	-- Individual styles for certain widgets
	--------------------------------------------------------------------------------
	self.individual = { desktop = {} }

	-- Default awesome theme vars
	--------------------------------------------------------------------------------

	-- colors
	self.bg_normal     = self.color.wibox
	self.bg_focus      = self.color.main
	self.bg_urgent     = self.color.urgent
	self.bg_minimize   = self.color.gray

	self.fg_normal     = self.color.text
	self.fg_focus      = self.color.highlight
	self.fg_urgent     = self.color.highlight
	self.fg_minimize   = self.color.highlight

	self.border_normal = self.color.wibox
	self.border_focus  = self.color.wibox
	self.border_marked = self.color.main

	-- font
	self.font = self.fonts.main

	-- standart awesome notification widget
	self.naughty = {}

	self.naughty.base = {
		timeout      = 10,
		margin       = 12,
		icon_size    = 80,
		font         = self.fonts.main,
		bg           = self.color.wibox,
		fg           = self.color.text,

		border_width = 4,
		border_color = self.color.wibox
	}

	self.naughty.normal = {
		height = self.float.notify.geometry.height,
		width = self.float.notify.geometry.width,
	}

	self.naughty.low = {
		timeout = 5,
		height = self.float.notify.geometry.height,
		width = self.float.notify.geometry.width,
	}

	self.naughty.critical = {
		timeout = 0,
		border_color = self.color.main
	}
	-- Exitscreen
	-----------------------------------------------------------------------------------------------------------------------
	self.exitscreen = {
		background_hue_800 = self.color.bg_second .. "FC",
		power = self.path .. '/icons/exitscreen/power.svg',
		suspend = self.path .. '/icons/exitscreen/power-suspend.svg',
		hibernate = self.path .. '/icons/exitscreen/power-sleep.svg',
		restart = self.path .. '/icons/exitscreen/restart.svg',
		logout = self.path .. '/icons/exitscreen/logout.svg',
		lock = self.path .. '/icons/exitscreen/lock.svg',
		exit_screen_icon_size = 130,
	}

end

-- End
-----------------------------------------------------------------------------------------------------------------------


theme:init()





-----top pannel
theme.icon_dir                                  = theme.path .. "/icons"
theme.font                                      = "Roboto Bold 8"
theme.font_tray                                 = "Roboto Bold 10"
theme.taglist_font                              = "Roboto Condensed Bold 8, Sarasa Mono H Bold 9"
theme.fg_normal                                 = "#FFFFFF"
theme.fg_focus                                  = "#5AB5D4"
theme.bg_focus                                  = "#303030"
theme.bg_normal                                 = "#242424"
theme.fg_urgent                                 = "#CC9393"
theme.bg_urgent                                 = "#006B8E"
theme.border_width                              = 0
theme.border_normal                             = "#252525"
theme.border_focus                              = "#80CCE6"
theme.taglist_fg_focus                          = "#FFFFFF"
theme.tasklist_bg_normal                        = "#242424"
theme.tasklist_fg_focus                         = "#4CB7DB"
theme.tooltip_bg                                = "#242424"
theme.tooltip_fg                                = "#ffffff"
theme.tooltip_border_color                      = "#242424"
theme.tooltip_border_color                      = "#242424"
theme.tooltip_font                              = "Roboto Condensed Bold 8"
theme.notification_max_height                   = 200
theme.notification_max_width                    = 700
theme.menu_height                               = 30
theme.menu_width                                = 160
theme.menu_icon_size                            = 32
theme.spr_space                                 = theme.icon_dir .. "/widget/spr_space.png"
theme.spr_small                                 = theme.icon_dir .. "/widget/spr_small.png"
theme.spr_very_small                            = theme.icon_dir .. "/widget/spr_very_small.png"
theme.spr_right                                 = theme.icon_dir .. "/widget/spr_right.png"
theme.spr_bottom_right                          = theme.icon_dir .. "/widget/spr_bottom_right.png"
theme.spr_left                                  = theme.icon_dir .. "/widget/spr_left.png"
theme.bar                                       = theme.icon_dir .. "/widget/bar.png"
theme.bottom_bar                                = theme.icon_dir .. "/widget/bottom_bar.png"
theme.clock                                     = theme.icon_dir .. "/widget/clock.png"
theme.calendar                                  = theme.icon_dir .. "/widget/cal.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 10
theme.titlebar_close_button_normal              = theme.icon_dir .. "/titlebar/close_normal.svg"
theme.titlebar_close_button_focus               = theme.icon_dir .. "/titlebar/close_focus.svg"
theme.titlebar_minimize_button_normal           = theme.icon_dir .. "/titlebar/minimize_normal.svg"
theme.titlebar_minimize_button_focus            = theme.icon_dir .. "/titlebar/minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive     = theme.icon_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.icon_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.icon_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.icon_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.icon_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.icon_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.icon_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.icon_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.icon_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.icon_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.icon_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.icon_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.icon_dir .. "/titlebar/maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive  = theme.icon_dir .. "/titlebar/maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active   = theme.icon_dir .. "/titlebar/maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active    = theme.icon_dir .. "/titlebar/maximized_focus_active.svg"
--



return theme
