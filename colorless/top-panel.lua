local beautiful = require("beautiful")
local awful = require("awful")
local redflat = require("redflat")

local wibox = require("wibox")
local naughty = require("naughty")

local newflat = require("newflat")

local gears = require("gears")

local string, os = string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility



-- Clock
local clock_icon = wibox.widget.imagebox(beautiful.clock)

-- textdate widget
--------------------------------------------------------------------------------
local texttime = {}
texttime.widget = newflat.widget.texttime({ timeformat = "%I:%M %p ", dateformat = "%H:%M:%S" })


-- Calendar
local calendar_icon = wibox.widget.imagebox(beautiful.calendar)
-- textdate widget
--------------------------------------------------------------------------------
local textdate = {}
textdate.widget = newflat.widget.texttime({ timeformat = "%d %b", dateformat = "%A %d-%m-%Y" })

textdate.buttons = awful.util.table.join(
	awful.button({}, 1, function() awful.util.spawn("urxvt -name floating -e calcurse") end)
)


-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local spr_space = wibox.widget.imagebox(beautiful.spr_space)
local spr_small = wibox.widget.imagebox(beautiful.spr_small)
local spr_very_small = wibox.widget.imagebox(beautiful.spr_very_small)
local spr_right = wibox.widget.imagebox(beautiful.spr_right)
local spr_bottom_right = wibox.widget.imagebox(beautiful.spr_bottom_right)
local spr_left = wibox.widget.imagebox(beautiful.spr_left)
local bar = wibox.widget.imagebox(beautiful.bar)
local bottom_bar = wibox.widget.imagebox(beautiful.bottom_bar)


local toppanel = {}
local env = {}



-- Layoutbox configure
--------------------------------------------------------------------------------
local layoutbox = {}

layoutbox.buttons = awful.util.table.join(
  awful.button({ }, 1, function () exit_screen_show() end),
  awful.button({ }, 3, function () newflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag) end),
  awful.button({ }, 4, function () awful.layout.inc( 1) end),
  awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

-- Taglist widget
--------------------------------------------------------------------------------
local taglist = {}
taglist.style = { widget = redflat.gauge.tag.orange.new, show_tip = true }
taglist.buttons = awful.util.table.join(
awful.button({         }, 1, function(t) t:view_only() end),
awful.button({ env.mod }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
awful.button({         }, 2, awful.tag.viewtoggle),
awful.button({         }, 3, function(t) newflat.widget.layoutbox:toggle_menu(t) end),
awful.button({ env.mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
awful.button({         }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({         }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Tasklist
--------------------------------------------------------------------------------
local tasklist = {}

tasklist.buttons = awful.util.table.join(
	awful.button({}, 1, newflat.widget.tasklist.action.select),
	--awful.button({}, 2, redflat.widget.tasklist.action.close),
  --awful.button({}, 2, function() awful.util.spawn("locate-pointer") end),
	awful.button({}, 3, newflat.widget.tasklist.action.menu),
	awful.button({}, 4, newflat.widget.tasklist.action.switch_next),
	awful.button({}, 5, newflat.widget.tasklist.action.switch_prev)
)


-- Tray widget
--------------------------------------------------------------------------------
local tray = {}
tray.widget = redflat.widget.minitray()

tray.buttons = awful.util.table.join(
	awful.button({}, 1, function() awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible end)
)


awful.util.tasklist_buttons = my_table.join(
   awful.button({ }, 1, function (c)
         if c == client.focus then
            c.minimized = true
         else
            c.minimized = false
            if not c:isvisible() and c.first_tag then
               c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
         end
   end),
   awful.button({ }, 2, function (c) c:kill() end),
   awful.button({ }, 3, function ()
         local instance = nil

         return function ()
            if instance and instance.wibox.visible then
               instance:hide()
               instance = nil
            else
               instance = awful.menu.clients({beautiful = {width = 250}})
            end
         end
   end),
   awful.button({ }, 5, function () awful.client.focus.byidx(1) end),
   awful.button({ }, 4, function () awful.client.focus.byidx(-1) end)
)


function toppanel:init(args)
  -- Init vars
	------------------------------------------------------------
	local args = args or {}
	local env = args.env




  awful.screen.connect_for_each_screen(function(s)
    -- wallpaper
    env.wallpaper(s)

    local tagnames = beautiful.tagnames or { "Tag1", "Tag2", "Tag3", "Tag4", "Tag5" }
    -- Create tags
    awful.tag.add(tagnames[1], {
                    layout = awful.layout.layouts[15],
                    screen = s,
                    selected = true,
    })
    awful.tag.add(tagnames[2], {
                    layout = awful.layout.layouts[1],
                    screen = s,
    })
    awful.tag.add(tagnames[3], {
                    layout = awful.layout.layouts[1],
                    screen = s,
    })
    awful.tag.add(tagnames[4], {
                    layout = awful.layout.layouts[1],
                    screen = s,
    })
    awful.tag.add(tagnames[5], {
                    layout = awful.layout.layouts[1],
                    screen = s,
    })
    -- layoutbox widget
    layoutbox[s] = newflat.widget.layoutbox({ screen = s })

    -- taglist widget
    taglist[s] = redflat.widget.taglist({ screen = s, buttons = taglist.buttons, hint = env.tagtip }, taglist.style)

    -- tasklist widget
    tasklist[s] = newflat.widget.tasklist({ screen = s, buttons = tasklist.buttons })

    s.systray = wibox.widget.systray()
    s.systray.visible = true


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    s.systray:set_base_size(18)
    s.my_sys = wibox.container.margin(s.systray, 0, 0, 5, 5)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { fg_focus = beautiful.color.text, bg_focus = beautiful.bg_focus, shape = gears.shape.rectangle, shape_border_width = 5, shape_border_color = beautiful.tasklist_bg_normal, align = "center" })

    -- Create the wibox
    --panel wibox
    s.panel = awful.wibar({ position = "top", screen = s, height = beautiful.panel_height or 32 })
    -- Add widgets to the wibox
    s.panel:setup {
       layout = wibox.layout.align.horizontal,
       { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          first,
          env.wrapper(layoutbox[s], "layoutbox", layoutbox.buttons),
          spr_space,
          env.wrapper(taglist[s], "taglist"),
          spr_space,
          spr_space,
          s.mypromptbox,
       },
			 tasklist[s],
       --s.mytasklist, -- Middle widget
       { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          env.wrapper(s.my_sys, "systray"),
          spr_right,
          calendar_icon,
          env.wrapper(textdate.widget, "texttime",textdate.buttons),
          bottom_bar,
          clock_icon,
          env.wrapper(texttime.widget, "texttime"),
          env.wrapper(tray.widget, "tray", tray.buttons),
          spr_space,
       },
    }
  end)
end



return toppanel
