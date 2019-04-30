-----------------------------------------------------------------------------------------------------------------------
--                                                Colorless config                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Load modules
-----------------------------------------------------------------------------------------------------------------------

-- Standard awesome library
------------------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

require("awful.autofocus")

-- User modules
------------------------------------------------------------
local redflat = require("redflat")

-- global module
timestamp = require("redflat.timestamp")

-- Error handling
-----------------------------------------------------------------------------------------------------------------------
require("colorless.ercheck-config") -- load file with error handling


-- Setup theme and environment vars
-----------------------------------------------------------------------------------------------------------------------
local env = require("colorless.env-config") -- load file with environment
env:init({ theme = "colorless" })


-- Layouts setup
-----------------------------------------------------------------------------------------------------------------------
local layouts = require("colorless.layout-config") -- load file with tile layouts setup
layouts:init()


-- Main menu configuration
-----------------------------------------------------------------------------------------------------------------------
local mymenu = require("colorless.menu-config") -- load file with menu configuration
mymenu:init({ env = env })


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- Separator
--------------------------------------------------------------------------------
local separator = redflat.gauge.separator.vertical()

-- Tasklist
--------------------------------------------------------------------------------
local tasklist = {}

tasklist.buttons = awful.util.table.join(
	awful.button({}, 1, redflat.widget.tasklist.action.select),
	--awful.button({}, 2, redflat.widget.tasklist.action.close), -- commented for locate-pointer program
	awful.button({}, 3, redflat.widget.tasklist.action.menu),
	awful.button({}, 4, redflat.widget.tasklist.action.switch_next),
	awful.button({}, 5, redflat.widget.tasklist.action.switch_prev)
)

-- Taglist widget
--------------------------------------------------------------------------------
local taglist = {}
taglist.style = { widget = redflat.gauge.tag.orange.new, show_tip = true }
taglist.buttons = awful.util.table.join(
awful.button({         }, 1, function(t) t:view_only() end),
awful.button({ env.mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
awful.button({         }, 2, awful.tag.viewtoggle),
awful.button({         }, 3, function(t) redflat.widget.layoutbox:toggle_menu(t) end),
awful.button({ env.mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
awful.button({         }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({         }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Textclock widget
--------------------------------------------------------------------------------
local textclock = {}
textclock.widget = redflat.widget.textclock({ timeformat = "%H:%M", dateformat = "%b  %d  %a" })

-- Layoutbox configure
--------------------------------------------------------------------------------
local layoutbox = {}

layoutbox.buttons = awful.util.table.join(
awful.button({ }, 1, function () awful.layout.inc( 1) end),
awful.button({ }, 3, function () redflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag) end),
awful.button({ }, 4, function () awful.layout.inc( 1) end),
awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

-- Tray widget
--------------------------------------------------------------------------------
local tray = {}
tray.widget = redflat.widget.minitray(nil, { double_wibox = true })

tray.buttons = awful.util.table.join(
	awful.button({}, 1, function() redflat.widget.minitray:toggle() end)
)

-- PA volume control
--------------------------------------------------------------------------------
local volume = {}
volume.widget = redflat.widget.pulse(nil, { widget = redflat.gauge.audio.red.new })

-- activate player widget
redflat.float.player:init({ name = env.player })

volume.buttons = awful.util.table.join(
	awful.button({}, 4, function() redflat.widget.pulse:change_volume()                end),
	awful.button({}, 5, function() redflat.widget.pulse:change_volume({ down = true }) end),
	awful.button({}, 2, function() redflat.widget.pulse:mute()                         end),
	awful.button({}, 3, function() redflat.float.player:show()                         end),
	awful.button({}, 1, function() redflat.float.player:action("PlayPause")            end),
	awful.button({}, 8, function() redflat.float.player:action("Previous")             end),
	awful.button({}, 9, function() redflat.float.player:action("Next")                 end)
)

-- System resource monitoring widgets
--------------------------------------------------------------------------------
local sysmon = { widget = {}, buttons = {} , icon = {}}

-- icons
sysmon.icon.battery = redflat.util.table.check(beautiful, "icon.widget.battery")
sysmon.icon.cpuram = redflat.util.table.check(beautiful, "icon.widget.monitor")

-- battery
sysmon.widget.battery = redflat.widget.sysmon(
        { func = redflat.system.pformatted.bat(25), arg = "BAT1" },
        { timeout = 60, widget = redflat.gauge.icon.single, monitor = { is_vertical = true, icon = sysmon.icon.battery } }
)

-- network speed
sysmon.widget.network = redflat.widget.net(
	{
		interface = "wlp5s0",
		speed = { up = 6 * 1024^2, down = 6 * 1024^2 },
		autoscale = false
	},
	{ timeout = 2, widget = redflat.gauge.icon.double }
)


-- Toppanel
-----------------------------------------------------------------------------------
local toppanel = require("colorless.top-panel")
toppanel:init({ env = env })

--------------

-- Exit screen
----------------------------------------------------------------------------------
require('colorless.exit-screen')

-- Sceeenshot
----------------------------------------------------------------------------------
require("colorless.scripts.screenshot")


-- Key bindings
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = require("colorless.keys-config") -- load file with hotkeys configuration
hotkeys:init({ env = env, menu = mymenu.mainmenu })


-- Rules
-----------------------------------------------------------------------------------------------------------------------
local rules = require("colorless.rules-config") -- load file with rules configuration
rules:init({ hotkeys = hotkeys})


-- Titlebar setup
-----------------------------------------------------------------------------------------------------------------------
local titlebar = require("colorless.titlebar-config") -- load file with titlebar configuration
titlebar:init()

-- Base signal set for awesome wm
-----------------------------------------------------------------------------------------------------------------------
local signals = require("colorless.signals-config") -- load file with signals configuration
signals:init({ env = env })


-- Change screen focus indicator
-----------------------------------------------------------------------------------------------------------------------
timer {
    timeout   = 0.1,
    call_now  = true,
    autostart = true,
    callback  = function()
        screen.emit_signal("request::activate", "screen-switch", {raise = true})
    end
}
-- Autostart user applications
-----------------------------------------------------------------------------------------------------------------------
local autostart = require("colorless.autostart-config") -- load file with autostart application list

if timestamp.is_startup() then
        autostart.run()
end
