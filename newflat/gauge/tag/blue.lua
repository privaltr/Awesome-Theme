-----------------------------------------------------------------------------------------------------------------------
--                                                   RedFlat tag widget                                              --
-----------------------------------------------------------------------------------------------------------------------
-- Custom widget to display tag info
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
-----------------------------------------------------------------------------------------------------------------------
local setmetatable = setmetatable
local math = math

local wibox = require("wibox")
local beautiful = require("beautiful")
local color = require("gears.color")

local redutil = require("redflat.util")
local newutil = require("newflat.util")
-- Initialize tables for module
-----------------------------------------------------------------------------------------------------------------------
local bluetag = { mt = {} }

-- Generate default theme vars
-----------------------------------------------------------------------------------------------------------------------
local function default_style()
	local style = {
		width    = 80,
		font     = { font = "Sans", size = 16, face = 0, slant = 0 },
		text_gap = 32,
		point    = { height = 4, gap = 8, dx = 6, width = 40 },
		show_min = false,
		color    = { main   = "#b1222b", gray = "#575757", icon = "#a0a0a0", urgent = "#32882d",
		             wibox = "#303030", bg = "#303030" }
	}

	return redutil.table.merge(style, redutil.table.check(beautiful, "gauge.tag.blue") or {})
end


-- Create a new tag widget
-- @param style Table containing colors and geometry parameters for all elemets
-----------------------------------------------------------------------------------------------------------------------
function bluetag.new(style)

	-- Initialize vars
	--------------------------------------------------------------------------------
	local style = redutil.table.merge(default_style(), style or {})

	-- updating values
	local data = {
		state = { text = "TEXT" },
		width = style.width or nil
	}

	-- Create custom widget
	--------------------------------------------------------------------------------
	local widg = wibox.widget.base.make_widget()

	-- User functions
	------------------------------------------------------------
	function widg:set_state(state)
		data.state = state
		self:emit_signal("widget::updated")
	end

	function widg:set_width(width)
		data.width = width
		self:emit_signal("widget::updated")
	end

	-- Fit
	------------------------------------------------------------
	function widg:fit(_, width, height)
		if data.width then
			return math.min(width, data.width), height
		else
			return width, height
		end
	end

	-- Draw
	------------------------------------------------------------
	function widg:draw(_, cr, width)
		local n = #data.state.list


		if n > 0 then
			for i = 1, n do
				local cl = data.state.list[i].focus and "#303030" or
				           data.state.list[i].urgent and style.color.urgent or
				           data.state.list[i].minimized and style.show_min and style.color.gray or "#303030"
				cr:set_source(color(cl))
				cr:rectangle((i - 1) * (style.point.dx + width), 5, width, 22)
				cr:fill()
			end
		else
			cr:set_source(color(style.color.gray))
			cr:rectangle((width - style.point.width) / 2, 5, style.point.width, 20)
			cr:fill()
		end


		-- if n > 0 then
		-- 	for i = 1, n do
		-- 		local cl = data.state.list[i].focus and style.color.main or
		-- 		           data.state.list[i].urgent and style.color.urgent or
		-- 		           data.state.list[i].minimized and style.color.gray and style.color.gray or style.color.icon
		-- 		cr:set_source(color(cl))
		-- 		cr:rectangle((i - 1) * (style.point.dx + width), style.point.gap, width, style.point.height)
		-- 		cr:fill()
		-- 	end
		-- else
		-- 	cr:set_source(color(style.color.gray))
		-- 	cr:rectangle((width - style.point.width) / 2, style.point.gap, style.point.width, style.point.height)
		-- 	cr:fill()
		-- end

		if n > 0 then
			for i = 1, n do
				local cl = data.state.list[i].focus and style.color.main or
				           data.state.list[i].urgent and style.color.urgent or
				           data.state.list[i].minimized and style.color.gray and style.color.gray or style.color.icon
				cr:set_source(color(cl))
				cr:rectangle((i - 1) * (style.point.dx + 15), 6, 4, 20)
				cr:fill()
			end
		else
			cr:set_source(color(style.color.gray))
			cr:rectangle((width - style.point.height) / 2, style.point.gap, style.point.height, style.point.width)
			cr:fill()
		end

		-- text
		cr:set_source(color(
			data.state.active and style.color.main
			or (n == 0 or data.state.minimized) and style.color.gray
			or style.color.icon
		))
		newutil.cairo.set_font(cr, style.font)
		newutil.cairo.textcentre.horizontal(cr, { width / 2, style.text_gap }, data.state.text, width)

	end

	--------------------------------------------------------------------------------
	return widg
end

-- Config metatable to call bluetag module as function
-----------------------------------------------------------------------------------------------------------------------
function bluetag.mt:__call(...)
	return bluetag.new(...)
end

return setmetatable(bluetag, bluetag.mt)
