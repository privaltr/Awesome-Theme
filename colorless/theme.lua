-----------------------------------------------------------------------------------------------------------------------
--                                                Colorless theme                                                    --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

local theme = {}
local wa = mouse.screen.workarea

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
	shadow4   = "#767676"

}


-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "colorless"
theme.homedir = os.getenv("HOME")


-- Exitscreen
-----------------------------------------------------------------------------------------------------------------------
theme.icon_path = theme.path .. "/icons/exitscreen/"
theme.background_hue_800 = theme.color.bg_second .. "FC"
theme.power = theme.icon_path .. 'power.svg'
theme.suspend = theme.icon_path .. 'power-suspend.svg'
theme.hibernate = theme.icon_path .. 'power-sleep.svg'
theme.restart = theme.icon_path .. 'restart.svg'
theme.logout = theme.icon_path .. 'logout.svg'
theme.lock = theme.icon_path .. 'lock.svg'
theme.exit_screen_icon_size = 130


-- Main config
------------------------------------------------------------
theme.panel_height        = 32
theme.border_width        = 4
theme.useless_gap         = 10
theme.useless_gap_naughty = 0

theme.wallpaper = theme.path .. "/icons/wallpaper/plasma.png"

-- Fonts
------------------------------------------------------------
theme.fonts = {
	main     = "sans 12",      -- main font
	menu     = "sans 12",      -- main menu font
	tooltip  = "sans 12",      -- tooltip font
	notify   = "sans bold 10", -- redflat notify popup font
	clock    = "sans bold 12", -- textclock widget font
	qlaunch  = "sans bold 14", -- quick launch key label font
	title    = "sans bold 12", -- widget titles font
	keychain = "sans bold 14", -- key sequence tip font
	titlebar = "sans bold 12", -- client titlebar font
	hotkeys = {
		main  = "sans 10",      -- hotkeys helper main font
		key   = "mono 10",      -- hotkeys helper key font (use monospace for align)
		title = "sans bold 12", -- hotkeys helper group title font
	},
	player   = {
    main = "Play bold 13", -- player widget main font
    time = "Play bold 15", -- player widget current time font
  },
}

theme.cairo_fonts = {
	tag         = { font = "Sans", size = 16, face = 1 }, -- tag widget font
	appswitcher = { font = "Sans", size = 22, face = 1 }, -- appswitcher widget font
	navigator   = {
		title = { font = "Sans", size = 28, face = 1, slant = 0 }, -- window navigation title font
		main  = { font = "Sans", size = 22, face = 1, slant = 0 }  -- window navigation  main font
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


-- Widget icons
--------------------------------------------------------------------------------
theme.icon.widget = {
        battery  = theme.path .. "/icons/widget/battery.svg",
        wireless = theme.path .. "/icons/widget/wireless.svg",
        monitor  = theme.path .. "/icons/widget/monitor.svg",
}

-- Desktop config
-----------------------------------------------------------------------------------------------------------------------
theme.desktop = { common = {} }

-- Common
--------------------------------------------------------------------------------
theme.desktop.line_height = 18

theme.desktop.color = {
        main  = theme.color.main,
        gray  = theme.color.gray_desktop or "#404040",
        wibox = theme.color.bg .. "00"
}

-- Textbox
------------------------------------------------------------
theme.desktop.common.textbox = {
        font = { font = "prototype", size = 24, face = 0 }
}

-- Dashbar
------------------------------------------------------------
theme.desktop.common.dashbar = {
        bar = { width = 6, gap = 6 }
}

-- Barpack
------------------------------------------------------------
theme.desktop.common.barpack = {
        label_style = { width = 68, draw = "by_width" },
        text_style  = { width = 94, draw = "by_edges" },
        line_height = theme.desktop.line_height,
        text_gap    = 14,
        label_gap   = 14,
        color       = theme.desktop.color
}

-- Widgets
--------------------------------------------------------------------------------


-- Disks
------------------------------------------------------------
theme.desktop.dashpack = {
        color = theme.desktop.color
}

-- Thermal
------------------------------------------------------------
theme.desktop.sline = {
        digit_num = 2,
        lbox      = { draw = "by_width", width = 50 },
        rbox      = { draw = "by_edges", width = 60 },
        icon      = theme.path .. "/icons/desktop/fire.svg",
        iwidth    = 142,
        color     = theme.desktop.color
}

-- Widgets placement
--------------------------------------------------------------------------------
theme.desktop.grid = {
        width  = { 480, 480, 480 },
        height = { 180, 150, 150, 138, 18 },
        edge   = { width = { 80, 80 }, height = { 50, 50 } }
}

theme.desktop.places = {
        netspeed = { 1, 1 },
        ssdspeed = { 2, 1 },
        hddspeed = { 3, 1 },
        cpumem   = { 1, 2 },
        transm   = { 1, 3 },
        disks    = { 1, 4 },
        thermal  = { 1, 5 }
}


-- Service utils config
-----------------------------------------------------------------------------------------------------------------------
theme.service = {}

-- Window control mode appearance
--------------------------------------------------------------------------------
theme.service.navigator = {
	border_width = 0,
	gradstep     = 60,
	marksize     = { width = 160, height = 80, r = 20 },
	linegap      = 32,
	titlefont    = theme.cairo_fonts.navigator.title,
	font         = theme.cairo_fonts.navigator.main,
	color        = { border = theme.color.main, mark = theme.color.gray, text = theme.color.wibox,
	                 fbg1 = theme.color.main .. "40",   fbg2 = theme.color.main .. "20",
	                 hbg1 = theme.color.urgent .. "40", hbg2 = theme.color.urgent .. "20",
	                 bg1  = theme.color.gray .. "40",   bg2  = theme.color.gray .. "20" }
}

-- layout hotkeys helper size
theme.service.navigator.keytip = {}
theme.service.navigator.keytip["fairv"] = { geometry = { width = 600, height = 360 }, exit = true }
theme.service.navigator.keytip["fairh"] = theme.service.navigator.keytip["fairv"]
theme.service.navigator.keytip["spiral"] = theme.service.navigator.keytip["fairv"]
theme.service.navigator.keytip["dwindle"] = theme.service.navigator.keytip["fairv"]

theme.service.navigator.keytip["tile"] = { geometry = { width = 600, height = 480 }, exit = true }
theme.service.navigator.keytip["tileleft"]   = theme.service.navigator.keytip["tile"]
theme.service.navigator.keytip["tiletop"]    = theme.service.navigator.keytip["tile"]
theme.service.navigator.keytip["tilebottom"] = theme.service.navigator.keytip["tile"]

theme.service.navigator.keytip["cornernw"] = { geometry = { width = 600, height = 440 }, exit = true }
theme.service.navigator.keytip["cornerne"] = theme.service.navigator.keytip["cornernw"]
theme.service.navigator.keytip["cornerse"] = theme.service.navigator.keytip["cornernw"]
theme.service.navigator.keytip["cornersw"] = theme.service.navigator.keytip["cornernw"]

theme.service.navigator.keytip["magnifier"] = { geometry = { width = 600, height = 360 }, exit = true }

theme.service.navigator.keytip["grid"] = { geometry = { width = 1400, height = 440 }, column = 2, exit = true }
theme.service.navigator.keytip["usermap"] = { geometry = { width = 1400, height = 480 }, column = 2, exit = true }

-- Desktop file parser
--------------------------------------------------------------------------------
theme.service.dfparser = {
	desktop_file_dirs = {
		'/usr/share/applications/',
		'/usr/local/share/applications/',
		'~/.local/share/applications',
	},
	icons = {
		df_icon       = "/usr/share/icons/ACYLS/scalable/mimetypes/application-x-executable.svg",
		theme         = "/usr/share/icons/ACYLS",
		custom_only   = true,
		scalable_only = true
	}
}


-- Menu config
-----------------------------------------------------------------------------------------------------------------------
theme.menu = {
	border_width = 4,
	screen_gap   = theme.useless_gap + theme.border_width,
	height       = 32,
	width        = 250,
	icon_margin  = { 8, 8, 8, 8 },
	ricon_margin = { 9, 9, 9, 9 },
	font         = theme.fonts.menu,
	keytip       = { geometry = { width = 400, height = 460 } },
	hide_timeout = 1,
	submenu_icon = theme.path .. "/icons/common/submenu.svg"
}

theme.menu.color = {
	border       = theme.color.wibox,
	text         = theme.color.text,
	highlight    = theme.color.highlight,
	main         = theme.color.main,
	wibox        = theme.color.wibox,
	submenu_icon = theme.color.icon
}


-- Gauge style
-----------------------------------------------------------------------------------------------------------------------
theme.gauge = { tag = {}, task = {}, monitor = {}, graph = {}, icon = {}, audio = {}}

-- Separator
------------------------------------------------------------
theme.gauge.separator = {
	marginv = { 2, 2, 4, 4 },
	marginh = { 6, 6, 3, 3 },
	color  = theme.color
}

-- Icon indicator
------------------------------------------------------------
theme.gauge.icon.single = {
        color  = theme.color
}

-- Monitor
------------------------------------------------------------
theme.gauge.monitor.dash = {
        width    = 10,
        line     = { num = 5, width = 3 },
        color    = theme.color
}
theme.gauge.monitor.double = {
        width    = 90,
        line     = { v_gap = 6 },
        dmargin  = { 10, 0, 0, 0 },
        color    = theme.color
}

-- Double icon indicator
--------------------------------------------------------------
theme.gauge.icon.double = {
        icon1       = theme.path .. "/icons/widget/down.svg",
        icon2       = theme.path .. "/icons/widget/up.svg",
        is_vertical = true,
        igap        = -6,
        color       = theme.color
}


-- Tag
------------------------------------------------------------
theme.gauge.tag.orange = {
	width        = 22,
	line_width   = 2,
	iradius      = 3,
	radius       = 6,
	hilight_min  = false,
	color        = theme.color
}

-- Task
------------------------------------------------------------
theme.gauge.task.blue = {
	width    = 70,
	show_min = true,
	font     = theme.cairo_fonts.tag,
	point    = { width = 70, height = 3, gap = 27, dx = 5 },
	text_gap = 20,
	color    = theme.color
}

-- Monitor
--------------------------------------------------------------
theme.gauge.monitor.plain = {
        width    = 90,
        line     = { v_gap = 6 },
        dmargin  = { 10, 0, 0, 0 },
        color    = theme.color
}

-- Dotcount
------------------------------------------------------------
theme.gauge.graph.dots = {
	column_num   = { 3, 5 }, -- { min, max }
	row_num      = 3,
	dot_size     = 4,
	dot_gap_h    = 3,
	color        = theme.color
}

theme.gauge.graph.bar = {
	color = theme.color
}
-- Volume indicator
------------------------------------------------------------
theme.gauge.audio.red = {
        icon = {
                ready = theme.path .. "/icons/widget/audio.svg",
                mute  = theme.path .. "/icons/widget/mute.svg"
        },
        color = {
                main = theme.color.main,
                icon = theme.color.icon,
                mute = theme.color.urgent,
        }
}
-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------
theme.widget = {}

-- individual margins for palnel widgets
------------------------------------------------------------
theme.widget.wrapper = {
	network     = { 6, 6, 8, 8 },
	volume	    = {	12, 10, 3, 3 },
	cpu         = { 10, 2, 8, 8 },
  ram         = { 2, 2, 8, 8 },
  battery     = { 6, 6, 8, 8 },
	cpuram      = { 10, 10, 5, 5 },
	keyboard = { 10, 10, 4, 4 },
  mainmenu    = { 12, 10, 6, 6 },
	layoutbox   = { 10, 10, 6, 6 },
	textclock   = { 12, 12, 0, 0 },
	taglist     = { 4, 4, 0, 0 },
	tray        = { 10, 12, 7, 7 },
}
-- Pulseaudio volume control
------------------------------------------------------------
theme.widget.pulse = {
        notify      = { icon = theme.path .. "/icons/widget/audio.svg" }
}

-- Brightness control
--
theme.widget.brightness = {
	notify = { icon = theme.path .. "/icons/widget/brightness.svg"}
}


-- Textclock
------------------------------------------------------------
theme.widget.textclock = {
	font  = theme.fonts.clock,
	color = { text = theme.color.icon } }

-- Keyboard layout indicator
------------------------------------------------------------
theme.widget.keyboard = {
	icon         = theme.path .. "/icons/widget/keyboard.svg",
	micon        = theme.icon,
	layout_color = { theme.color.icon, theme.color.main }
}

theme.widget.keyboard.menu = {
	width        = 180,
	color        = { right_icon = theme.color.icon },
	nohide       = true
}

-- Minitray
------------------------------------------------------------
-- theme.widget.minitray = {
-- 	border_width = 0,
-- 	geometry     = { height = 40 },
-- 	screen_gap   = nil,--2 * theme.useless_gap,
-- 	color        = { wibox = theme.color.wibox, border = theme.color.wibox },
-- 	--position		 = { x = mouse.screen.workarea.x + 1200, y = mouse.screen.workarea.y + mouse.screen.workarea.height - 95},
-- 	position		 = { x = mouse.screen.workarea.x + mouse.screen.workarea.width, y = mouse.screen.workarea.y }, --+ mouse.screen.workarea.height },
-- 	set_position = function()
-- 		return { x = mouse.screen.workarea.x + 1120,--+ mouse.screen.workarea.width - 43 ,
-- 		         y = mouse.screen.workarea.y + mouse.screen.workarea.height - 45 }--3}--+ mouse.screen.workarea.height }
-- 	end,
-- }


-- Layoutbox
------------------------------------------------------------
theme.widget.layoutbox = {
	micon = theme.icon,
	color = theme.color
}

theme.widget.layoutbox.icon = {
	floating          = theme.path .. "/icons/layouts/floating.svg",
	max               = theme.path .. "/icons/layouts/max.svg",
	fullscreen        = theme.path .. "/icons/layouts/fullscreen.svg",
	tilebottom        = theme.path .. "/icons/layouts/tilebottom.svg",
	tileleft          = theme.path .. "/icons/layouts/tileleft.svg",
	tile              = theme.path .. "/icons/layouts/tile.svg",
	tiletop           = theme.path .. "/icons/layouts/tiletop.svg",
	fairv             = theme.path .. "/icons/layouts/fair.svg",
	fairh             = theme.path .. "/icons/layouts/fair.svg",
	grid              = theme.path .. "/icons/layouts/grid.svg",
	usermap           = theme.path .. "/icons/layouts/map.svg",
	magnifier         = theme.path .. "/icons/layouts/magnifier.svg",
	spiral            = theme.path .. "/icons/layouts/spiral.svg",
	cornerne          = theme.path .. "/icons/layouts/cornerne.svg",
	cornernw          = theme.path .. "/icons/layouts/cornernw.svg",
	cornerse          = theme.path .. "/icons/layouts/cornerse.svg",
	cornersw          = theme.path .. "/icons/layouts/cornersw.svg",
	unknown           = theme.path .. "/icons/common/unknown.svg",
}

theme.widget.layoutbox.menu = {
	icon_margin  = { 8, 12, 8, 8 },
	width        = 260,
	auto_hotkey  = true,
	nohide       = false,
	color        = { right_icon = theme.color.icon, left_icon = theme.color.icon }
}

theme.widget.layoutbox.name_alias = {
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
------------------------------------------------------------
theme.widget.tasklist = {
	char_digit  = 5,
	task        = theme.gauge.task.blue
}

-- main
theme.widget.tasklist.winmenu = {
	micon          = theme.icon,
	titleline      = { font = theme.fonts.title, height = 30 },
	menu           = { width = 220, color = { right_icon = theme.color.icon }, ricon_margin = { 9, 9, 10, 10 } },
	tagmenu        = { width = 160, color = { right_icon = theme.color.icon, left_icon = theme.color.icon },
	                   icon_margin = { 8, 10, 8, 8 } },
	state_iconsize = { width = 18, height = 18 },
	layout_icon    = theme.widget.layoutbox.icon,
	color          = theme.color
}

-- tasktip
theme.widget.tasklist.tasktip = {
	color = theme.color
}

-- menu
theme.widget.tasklist.winmenu.icon = {
	floating             = theme.path .. "/icons/common/window_control/floating.svg",
	sticky               = theme.path .. "/icons/common/window_control/pin.svg",
	ontop                = theme.path .. "/icons/common/window_control/ontop.svg",
	below                = theme.path .. "/icons/common/window_control/below.svg",
	close                = theme.path .. "/icons/common/window_control/close.svg",
	minimize             = theme.path .. "/icons/common/window_control/minimize.svg",
	maximized            = theme.path .. "/icons/common/window_control/maximized.svg",
}

-- task aliases
theme.widget.tasklist.appnames = {}
--theme.widget.tasklist.appnames["Firefox"            	] = "FIFOX"
--theme.widget.tasklist.appnames["Gnome-terminal"      	] = "GTERM"
--theme.widget.tasklist.appnames["kitty"      					] = "KITTER"
--theme.widget.tasklist.appnames["plexmediaplayer"      ] = "Plex"


-- Floating widgets
-----------------------------------------------------------------------------------------------------------------------
theme.float = { decoration = {} }

-- Client menu
------------------------------------------------------------
theme.float.clientmenu = {
	micon          = theme.icon,
	color          = theme.color,
	actionline     = { height = 28 },
	layout_icon    = theme.widget.layoutbox.icon,
	menu           = theme.widget.tasklist.winmenu.menu,
	state_iconsize = theme.widget.tasklist.winmenu.state_iconsize,
	tagmenu        = theme.widget.tasklist.winmenu.tagmenu,
	icon           = theme.widget.tasklist.winmenu.icon,
}

-- Audio player
------------------------------------------------------------
theme.float.player = {
        geometry     = { width = 490, height = 130 },
        screen_gap   = 2 * theme.useless_gap,
        border_gap   = { 15, 15, 15, 15 },
        elements_gap = { 15, 0, 0, 0 },
        control_gap  = { 0, 0, 14, 6 },
        line_height  = 26,
        bar_width    = 6,
        titlefont    = theme.fonts.player.main,
        artistfont   = theme.fonts.player.main,
        timefont     = theme.fonts.player.time,
	dashcontrol  = { color = theme.color, bar = { num = 7 } },
        progressbar  = { color = theme.color },
        border_width = 0,
        timeout      = 1,
        color        = theme.color


}
theme.float.player.icon = {
        cover   = theme.path .. "/icons/common/player/cover.svg",
        next_tr = theme.path .. "/icons/common/player/next.svg",
        prev_tr = theme.path .. "/icons/common/player/previous.svg",
        play    = theme.path .. "/icons/common/player/play.svg",
        pause   = theme.path .. "/icons/common/player/pause.svg"
}

-- Application switcher
------------------------------------------------------------
theme.float.appswitcher = {
	wibox_height   = 240,
	label_height   = 28,
	title_height   = 40,
	icon_size      = 96,
	border_margin  = { 10, 10, 0, 10 },
	preview_margin = { 15, 15, 15, 15 },
	preview_format = 16 / 10,
	title_font     = theme.fonts.title,
	border_width   = 0,
	update_timeout = 1 / 12,
	keytip         = { geometry = { width = 400, height = 320 }, exit = true },
	font           = theme.cairo_fonts.appswitcher,
	color          = theme.color
}

-- additional color
theme.float.appswitcher.color.preview_bg = theme.color.main .. "12"

-- hotkeys
theme.float.appswitcher.hotkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                                    "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12" }

-- Quick launcher
------------------------------------------------------------
theme.float.qlaunch = {
	geometry      = { width = 1400, height = 170 },
	border_margin = { 5, 5, 12, 15 },
	border_width  = 0,
	appline       = { iwidth = 140, im = { 5, 5, 0, 0 }, igap = { 0, 0, 5, 15 }, lheight = 26 },
	state         = { gap = 5, radius = 5, size = 10,  height = 14 },
	-- df_icon       = theme.homedir .. "/.icons/ACYLS/scalable/mimetypes/application-x-executable.svg",
	-- no_icon       = theme.homedir .. "/.icons/ACYLS/scalable/apps/question.svg",
	df_icon       = theme.icon.warning,
	keytip        = { geometry = { width = 600, height = 260 } },
	no_icon       = theme.path .. "/icons/common/unknown.svg",
	label_font    = theme.fonts.qlaunch,
	color         = theme.color,
}

-- Hotkeys helper
------------------------------------------------------------
theme.float.hotkeys = {
	geometry      = { width = 1400, height = 600 },
	border_margin = { 20, 20, 10, 10 },
	border_width  = 0,
	is_align      = true,
	separator     = { marginh = { 0, 0, 2, 6 } },
	font          = theme.fonts.hotkeys.main,
	keyfont       = theme.fonts.hotkeys.key,
	titlefont     = theme.fonts.hotkeys.title,
	color         = theme.color
}

-- Key sequence tip
------------------------------------------------------------
theme.float.keychain = {
	geometry        = { width = 250, height = 54 },
	font            = theme.fonts.keychain,
	-- border_width    = 0,
	keytip          = { geometry = { width = 600, height = 400 }, column = 1 },
	color           = theme.color,
}

-- Tooltip
------------------------------------------------------------
theme.float.tooltip = {
	margin       = { 6, 6, 4, 4 },
	timeout      = 0,
	font         = theme.fonts.tooltip,
	border_width = 2,
	color        = theme.color
}

-- Floating prompt
------------------------------------------------------------
theme.float.prompt = {
	border_width = 0,
	color        = theme.color
}

-- Notify
------------------------------------------------------------
theme.float.notify = {
	geometry     = { width = 450, height = 105 },
	screen_gap   = 2, --2 * theme.useless_gap,
	font         = theme.fonts.notify,
	icon         = theme.icon.warning,
	border_width = 5,
	color        = theme.color,
	set_position = function()
		return { x = mouse.screen.workarea.x + mouse.screen.workarea.width, y = mouse.screen.workarea.y }
		--return { x = mouse.screen.workarea.x + mouse.screen.workarea.width, y = mouse.screen.workarea.y }
	end,
}

-- Decoration elements
------------------------------------------------------------
theme.float.decoration.button = {
	color = {
		shadow3 = theme.color.shadow3,
		shadow4 = theme.color.shadow4,
		gray    = theme.color.gray,
		text    = "#cccccc"
	},
}

theme.float.decoration.field = {
	color = theme.color
}


-- Titlebar
-----------------------------------------------------------------------------------------------------------------------
theme.titlebar = {
	size          = 8,
	position      = "top",
	font          = theme.fonts.titlebar,
	icon          = { size = 30, gap = 10 },
	border_margin = { 0, 0, 0, 4 },
	color         = theme.color,
}

-- Naughty config
-----------------------------------------------------------------------------------------------------------------------
theme.naughty = {}

theme.naughty.base = {
	timeout      = 10,
	margin       = 12,
	icon_size    = 80,
	font         = theme.fonts.main,
	bg           = theme.color.wibox,
	fg           = theme.color.text,
	height       = theme.float.notify.geometry.height,
	width        = theme.float.notify.geometry.width,
	border_width = 4,
	border_color = theme.color.wibox
}

theme.naughty.normal = {}
theme.naughty.critical = { timeout = 0, border_color = theme.color.main }
theme.naughty.low = { timeout = 5 }

-- Default awesome theme vars
-----------------------------------------------------------------------------------------------------------------------

-- colors
theme.bg_normal     = theme.color.wibox
theme.bg_focus      = theme.color.main
theme.bg_urgent     = theme.color.urgent
theme.bg_minimize   = "#242424"

theme.fg_normal     = theme.color.text
theme.fg_focus      = theme.color.highlight
theme.fg_urgent     = theme.color.highlight
theme.fg_minimize   = "#606060"--theme.color.highlight

theme.border_normal = theme.color.wibox
theme.border_focus  = theme.color.wibox
theme.border_marked = theme.color.main

-- font
theme.font = theme.fonts.main

-- End
-----------------------------------------------------------------------------------------------------------------------

theme.titlebar_fg_normal = "#606060"
theme.titlebar_fg_focus = "#FFFFFF"
theme.panel_fg_focus = "#FFFFFF"


-----other heeme
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
