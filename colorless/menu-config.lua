-----------------------------------------------------------------------------------------------------------------------
--                                                  Menu config                                                      --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
local redflat = require("redflat")
local awful = require("awful")
local naughty = require("naughty")


-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local menu = {}

-- Build function
--------------------------------------------------------------------------------
function menu:init(args)

	-- vars
	local args = args or {}
	local env = args.env or {} -- fix this?
	local separator = args.separator or { widget = redflat.gauge.separator.horizontal() }
	local theme = args.theme or { auto_hotkey = true }
	local icon_style = args.icon_style or {}


	 -- icon finder
        local function micon(name)
                return redflat.service.dfparser.lookup_icon(name, icon_style)
        end

	-- Application submenu
	------------------------------------------------------------

	-- WARNING!
	-- 'dfparser' module used to parse available desktop files for building application list and finding app icons,
	-- it may cause significant delay on wm start/restart due to the synchronous type of the scripts.
	-- This issue can be reduced by using additional settings like custom desktop files directory
	-- and user only icon theme. See colored configs for more details.

	-- At worst, you can give up all applications widgets (appmenu, applauncher, appswitcher, qlaunch) in your config
	local appmenu = redflat.service.dfparser.menu({ icons = icon_style, wm_name = "awesome" })

	-- Awesome submenu
        ------------------------------------------------------------
        local awesomemenu = {
                { "Restart",         awesome.restart,                 micon("gnome-session-reboot") },
                separator,
                { "Awesome config",  env.fm .. " .config/awesome",        micon("folder-bookmarks") },
                { "Awesome lib",     env.fm .. " /usr/share/awesome/lib", micon("folder-bookmarks") }
        }

	 -- Exit submenu
        ------------------------------------------------------------
        local exitmenu = {
		        { "Reboot",          "systemctl reboot",          micon("gnome-session-reboot")  },
						{ "Suspend",         "systemctl suspend" ,        micon("gnome-session-suspend") },
						{ "Hibernate",       "systemctl hibernate" ,      micon("gnome-session-suspend") },
            { "Shutdown",        "systemctl poweroff" ,       micon("gnome-session-suspend") },
            { "Log out",         awesome.quit,                micon("exit")                },
        }

	-- Main menu
	------------------------------------------------------------
	self.mainmenu = redflat.menu({ theme = theme,
		items = {
			{ "Applications",  appmenu,      },
			{ "Application launcher", "rofi -show combi", },
			separator,
			{ "Terminal",      env.terminal, },
			--separator,
			--{ "Test Item 0", function() naughty.notify({ text = "Test menu 0" }) end,           },
			--{ "Test Item 1", function() naughty.notify({ text = "Test menu 1" }) end, key = "i" },
			--{ "Test Item 2", function() naughty.notify({ text = "Test menu 2" }) end, key = "m" },
			separator,
			{ "Reload", awesome.restart, },
      separator,
      { "Lock",     "sh /home/rjmvisser/.config/awesome/colorless/scripts/lock.sh", micon("gnome-session-switch")  },
			{ "Exit",     exitmenu,       micon("exit") },
		}
	})

	-- Menu panel widget
	------------------------------------------------------------

	-- theme vars
	local deficon = redflat.util.base.placeholder()
	local icon = redflat.util.table.check(beautiful, "icon.awesome") and beautiful.icon.awesome or deficon
	local color = redflat.util.table.check(beautiful, "color.icon") and beautiful.color.icon or nil

	-- widget
	self.widget = redflat.gauge.svgbox(icon, nil, color)
	self.buttons = awful.util.table.join(
		awful.button({ }, 1, function () self.mainmenu:toggle() end)
	)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return menu
