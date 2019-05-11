-----------------------------------------------------------------------------------------------------------------------
--                                               RedFlat clock widget                                                --
-----------------------------------------------------------------------------------------------------------------------
-- Text clock widget with date in tooltip (optional)
-----------------------------------------------------------------------------------------------------------------------
-- Some code was taken from
------ awful.widget.texttime v3.5.2
------ (c) 2009 Julien Danjou
-----------------------------------------------------------------------------------------------------------------------

local setmetatable = setmetatable
local os = os
local textbox = require("wibox.widget.textbox")
local beautiful = require("beautiful")
local timer = require("gears.timer")

local tooltip = require("redflat.float.tooltip")
local redutil = require("redflat.util")
local wibox = require("wibox")
-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local texttime = { mt = {} }

-- Generate default theme vars
-----------------------------------------------------------------------------------------------------------------------
local function default_style()
	local style = {
		font  = "Sans 12",
		tooltip = {},
		color = { text = "#aaaaaa", background = "#ffffff" }
	}
	return redutil.table.merge(style, redutil.table.check(beautiful, "widget.texttime") or {})
end

-- Create a texttime widget. It draws the time it is in a textbox.
-- @param format The time format. Default is " %a %b %d, %H:%M ".
-- @param timeout How often update the time. Default is 60.
-- @return A textbox widget
-----------------------------------------------------------------------------------------------------------------------
function texttime.new(args, style)

	-- Initialize vars
	--------------------------------------------------------------------------------
	local args = args or {}
	local timeformat = args.timeformat or " %a %b %d, %H:%M "
	local timeout = args.timeout or 1
	local style = redutil.table.merge(default_style(), style or {})

	-- Create widget
	--------------------------------------------------------------------------------
	local widg = textbox()
	widg:set_font(style.font)


	-- Set tooltip if need
	--------------------------------------------------------------------------------
	local tp
	if args.dateformat then tp = tooltip({ objects = { widg } }, style.tooltip) end

	-- Set update timer
	--------------------------------------------------------------------------------
	local timer = timer({ timeout = timeout })
	timer:connect_signal("timeout",
		function()
			widg:set_markup('<span color="' .. style.color.text .. '" background="' .. style.color.background .. '" >' .. os.date(timeformat) .. "</span>")
			if args.dateformat then tp:set_text(os.date(args.dateformat)) end
		end)
	timer:start()
	timer:emit_signal("timeout")

	--------------------------------------------------------------------------------


	return wibox.container.margin(widg,3, 3, 3, 3,style.color.background)
end

-- Config metatable to call texttime module as function
-----------------------------------------------------------------------------------------------------------------------
function texttime.mt:__call(...)
	return texttime.new(...)
end

return setmetatable(texttime, texttime.mt)
