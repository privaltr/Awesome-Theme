-----------------------------------------------------------------------------------------------------------------------
--                                               Titlebar config                                                     --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
-- local redflat = require("redflat")
local redtitle = require("redflat.titlebar")
local clientmenu = require("redflat.float.clientmenu")

local beautiful = require("beautiful")
-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local titlebar = {}

local my_table      = awful.util.table or gears.table

-- Support functions
-----------------------------------------------------------------------------------------------------------------------
local function title_buttons(c)
	return awful.util.table.join(
		awful.button({ }, 1, function()
	        local c = mouse.object_under_pointer()
	        client.focus = c
	        c:raise()
	        local function single_tap()
	          awful.mouse.client.move(c)
	        end
	        local function double_tap()
	          gears.timer.delayed_call(function()
	              c.maximized = not c.maximized
	          end)
	        end
	        single_double_tap(single_tap, double_tap)
	    end),
			-- Middle button - close
		awful.button({ }, 2, function ()
				window_to_kill = mouse.object_under_pointer()
				window_to_kill:kill()
		end),
		awful.button({ }, 3, function()
        c = mouse.object_under_pointer()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
    end)
	)
end

local double_tap_timer = nil
function single_double_tap(single_tap_function, double_tap_function)
  if double_tap_timer then
    double_tap_timer:stop()
    double_tap_timer = nil
    double_tap_function()
    return
  end

  double_tap_timer =
    gears.timer.start_new(0.20, function()
                            double_tap_timer = nil
                            single_tap_function()
                            return false
    end)
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
function titlebar:init(args)

	local args = args or {}
	local style = {}

	style.light = args.light or redtitle.get_style()
	style.full = args.full or { size = 25, icon = { size = 30, gap = 0, angle = 0.5 } }

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
     awful.titlebar(c, {size = 26, fg_normal = beautiful.titlebar_fg_normal, fg_focus = beautiful.titlebar_fg_focus}) : setup {
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
