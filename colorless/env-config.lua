-----------------------------------------------------------------------------------------------------------------------
--                                                  Environment config                                               --
-----------------------------------------------------------------------------------------------------------------------

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local env = {}

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function env:init(args)

	-- init vars
	local args = args or {}
	local theme = args.theme or "colorless"


	-- environment vars
	self.terminal = args.terminal or "urxvt"
	self.mod = args.mod or "Mod4"
	self.fm = args.fm or "nemo"
	self.home = os.getenv("HOME")
	self.themedir = awful.util.get_configuration_dir() .. theme
	self.sloppy_focus = true
	self.color_border = false
	self.set_slave = true

	-- theme setup

	if not beautiful.init(env.themedir .. "/theme.lua") then
	    naughty.notify({text = "no theme found"})
	end
	beautiful.init(env.themedir .. "/theme.lua")

	-- naughty config
	--naughty.config.padding = beautiful.useless_gap and 2 * beautiful.useless_gap or 0
	naughty.config.padding = beautiful.useless_gap_naughty and beautiful.useless_gap_naughty or 0

	if beautiful.naughty then
		naughty.config.presets.normal   = redflat.util.table.merge(beautiful.naughty.base, beautiful.naughty.normal)
		naughty.config.presets.critical = redflat.util.table.merge(beautiful.naughty.base, beautiful.naughty.critical)
		naughty.config.presets.low      = redflat.util.table.merge(beautiful.naughty.base, beautiful.naughty.low)

		-- dirty fix to ignore forced geometry for critical preset
		-- For the sake of laziness I prefer fix some parameters after inherit than write pure table without inherit
		naughty.config.presets.critical.height, naughty.config.presets.critical.width = nil, nil
	end
end

-- Common functions
-----------------------------------------------------------------------------------------------------------------------

-- Wallpaper setup
--------------------------------------------------------------------------------
env.wallpaper = function(s)
	if beautiful.wallpaper then
		if awful.util.file_readable(beautiful.wallpaper) then
			gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		else
			gears.wallpaper.set(beautiful.color.bg)
		end
	end
end

-- Tag tooltip text generation
--------------------------------------------------------------------------------
env.tagtip = function(t)
	local layname = awful.layout.getname(awful.tag.getproperty(t, "layout"))
	if redflat.util.table.check(beautiful, "widget.layoutbox.name_alias") then
		layname = beautiful.widget.layoutbox.name_alias[layname] or layname
	end
	return string.format("%s (%d apps) [%s]", t.name, #(t:clients()), layname)
end

-- Panel widgets wrapper
--------------------------------------------------------------------------------
env.wrapper = function(widget, name, buttons)
	local margin = { 4, 4, 8, 8 }

  --naughty.notify({text = name})


	if redflat.util.table.check(beautiful, "widget.wrapper") and beautiful.widget.wrapper[name] then
		margin = beautiful.widget.wrapper[name]
	end
	if buttons then
		widget:buttons(buttons)
	end

	return wibox.container.margin(widget, unpack(margin))
end

-- Changing spotify notifications.
naughty.config.presets.spotify = {
    -- if you want to disable Spotify notifications completely, return false
    callback = function(args)
        return true
    end,

    -- Adjust the size of the notification
    height = 100,
    width  = 400,
    -- Guessing the value, find a way to fit it to the proper size later
    icon_size = 90
}
table.insert(naughty.dbus.config.mapping, {{appname = "Spotify"}, naughty.config.presets.spotify})
-- End
-----------------------------------------------------------------------------------------------------------------------

return env
