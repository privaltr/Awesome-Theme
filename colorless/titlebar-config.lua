
-----------------------------------------------------------------------------------------------------------------------
--                                               Titlebar config                                                     --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- local redflat = require("redflat")
local redtitle = require("redflat.titlebar")
local redutil = require("redflat.util")
local clientmenu = require("redflat.float.clientmenu")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local titlebar = {}
local my_table      = awful.util.table or gears.table
-- Support functions
-----------------------------------------------------------------------------------------------------------------------
local function title_buttons(c)
	return awful.util.table.join(
		awful.button(
			{ }, 1,
			function()
				client.focus = c;  c:raise()
				awful.mouse.client.move(c)
			end
		),
		awful.button(
			{ }, 3,
			function()
				client.focus = c;  c:raise()
				clientmenu:show(c)
			end
		)
	)
end

local function on_maximize(c)
	-- hide/show title bar
	local is_max = c.maximized_vertical or c.maximized
	local action = is_max and "cut_all" or "restore_all"
	redtitle[action]({ c })

	-- dirty size correction
	local model = redtitle.get_model(c)
	if model and not model.hidden then
		c.height = c:geometry().height + (is_max and model.size or -model.size)
		if is_max then c.y = c.screen.workarea.y end
	end
end

-- Connect titlebar building signal
-----------------------------------------------------------------------------------------------------------------------
function titlebar:init()

	local style = {}

	-- titlebar schemes
	style.base   = redutil.table.merge(redutil.table.check(beautiful, "titlebar.base") or {}, { size = 8 })
	style.iconic = redutil.table.merge(style.base, { size = 24 })

	-- titlebar elements styles
	style.mark_mini = redutil.table.merge(
		redutil.table.check(beautiful, "titlebar.mark") or {},
		{ size = 30, gap = 10, angle = 0 }
	)
	style.icon = redutil.table.merge(
		redutil.table.check(beautiful, "titlebar.icon") or {},
		{ gap = 10 }
)

	-- client.connect_signal(
	-- 	"request::titlebars",
	-- 	function(c)
	-- 		-- build titlebar and mouse buttons for it
	-- 		local buttons = title_buttons(c)
	-- 		local bar = redtitle(c)
	--
	-- 		-- build light titlebar model
	-- 		local light = wibox.widget({
	-- 			nil,
	-- 			{
	-- 				right = style.light.icon.gap,
	-- 				redtitle.icon.focus(c),
	-- 				layout = wibox.container.margin,
	-- 			},
	-- 			{
	-- 				redtitle.icon.property(c, "floating"),
	-- 				redtitle.icon.property(c, "sticky"),
	-- 				redtitle.icon.property(c, "ontop"),
	-- 				spacing = style.light.icon.gap,
	-- 				layout = wibox.layout.fixed.horizontal()
	-- 			},
	-- 			buttons = buttons,
	-- 			layout  = wibox.layout.align.horizontal,
	-- 		})
	--
	-- 		-- build full titlebar model
	-- 		local full = wibox.widget({
	-- 			redtitle.icon.focus(c, style.full),
	-- 			redtitle.icon.label(c, style.full),
	-- 			{
	-- 				redtitle.icon.property(c, "floating", style.full),
	-- 				redtitle.icon.property(c, "sticky", style.full),
	-- 				redtitle.icon.property(c, "ontop", style.full),
	-- 				spacing = style.full.icon.gap,
	-- 				layout = wibox.layout.fixed.horizontal()
	-- 			},
	-- 			buttons = buttons,
	-- 			layout  = wibox.layout.align.horizontal,
	-- 		})
	--
	-- 		-- Set both models to titlebar
	-- 		redtitle.add_layout(c, nil, full, style.full.size)
	-- 		redtitle.add_layout(c, nil, light)
	--
	-- 		-- hide titlebar when window maximized
	-- 		if c.maximized_vertical or c.maximized then on_maximize(c) end
	--
	-- 		c:connect_signal("property::maximized_vertical", on_maximize)
	-- 		c:connect_signal("property::maximized", on_maximize)
	-- 	end
	-- )

	client.connect_signal("request::titlebars", function(c)
     if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
     end
		 local buttons = my_table.join(
				awful.button({ }, 1, function()
							c:emit_signal("request::activate", "titlebar", {raise = true})
							awful.mouse.client.move(c)
				end),
				-- awful.button({ }, 2, function() c:kill() end),
				awful.button({ }, 3, function()
							c:emit_signal("request::activate", "titlebar", {raise = true})
							awful.mouse.client.resize(c)
				end)
		 )
     awful.titlebar(c, {size = 26, fg_normal = beautiful.color.titlebar_fg_normal, fg_focus = beautiful.color.text}) : setup {
        { -- Left
           awful.titlebar.widget.stickybutton   (c),
           awful.titlebar.widget.ontopbutton    (c),
           awful.titlebar.widget.floatingbutton (c),
           -- buttons = buttons,
           layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
           { -- Title
              align  = "center",
              widget = awful.titlebar.widget.titlewidget(c)
           },
           buttons = buttons,
           layout  = wibox.layout.flex.horizontal
        },
        { -- Right
           awful.titlebar.widget.minimizebutton(c),
           awful.titlebar.widget.maximizedbutton(c),
           awful.titlebar.widget.closebutton    (c),
           layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
                                            }
	end)



end

-- End
-----------------------------------------------------------------------------------------------------------------------
return titlebar
