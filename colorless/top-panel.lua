local beautiful = require("beautiful")
local awful = require("awful")
local redflat = require("redflat")
local wibox = require("wibox")
local naughty = require("naughty")

local gears = require("gears")
local lain  = require("lain")

local string, os = string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local markup = lain.util.markup
local space3 = markup.font("Roboto 3", " ")

-- Clock
local mytextclock = wibox.widget.textclock(markup("#FFFFFF", space3 .. "%I:%M %p  " .. markup.font("Roboto 4", " ")))
mytextclock.font = beautiful.font_tray
local clock_icon = wibox.widget.imagebox(beautiful.clock)
local clockbg = wibox.container.background(mytextclock, beautiful.bg_focus, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, 0, 3, 5, 5)

-- Calendar
local mytextcalendar = wibox.widget.textclock(markup.fontfg(beautiful.font_tray, "#FFFFFF", space3 .. "%d %b " .. markup.font("Roboto 5", " ")))
local calendar_icon = wibox.widget.imagebox(beautiful.calendar)
local calbg = wibox.container.background(mytextcalendar, beautiful.bg_focus, gears.shape.rectangle)
local calendarwidget = wibox.container.margin(calbg, 0, 0, 5, 5)


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
  awful.button({ }, 3, function () redflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag) end),
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
awful.button({         }, 3, function(t) redflat.widget.layoutbox:toggle_menu(t) end),
awful.button({ env.mod }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
awful.button({         }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({         }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Tasklist
--------------------------------------------------------------------------------
local tasklist = {}

tasklist.buttons = awful.util.table.join(
	awful.button({}, 1, redflat.widget.tasklist.action.select),
	--awful.button({}, 2, redflat.widget.tasklist.action.close),
  --awful.button({}, 2, function() awful.util.spawn("locate-pointer") end),
	awful.button({}, 3, redflat.widget.tasklist.action.menu),
	awful.button({}, 4, redflat.widget.tasklist.action.switch_next),
	awful.button({}, 5, redflat.widget.tasklist.action.switch_prev)
)

-- Tray widget
--------------------------------------------------------------------------------
local tray = {}
tray.widget = redflat.widget.minitray(nil, { double_wibox = true })

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
    layoutbox[s] = redflat.widget.layoutbox({ screen = s })

    -- taglist widget
    taglist[s] = redflat.widget.taglist({ screen = s, buttons = taglist.buttons, hint = env.tagtip }, taglist.style)

    -- tasklist widget
    tasklist[s] = redflat.widget.tasklist({ screen = s, buttons = tasklist.buttons })

    s.systray = wibox.widget.systray()
    s.systray.visible = true


    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    s.systray = wibox.widget.systray()
    s.systray:set_base_size(18)
    s.my_sys = wibox.container.margin(s.systray, 0, 0, 5, 5)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { fg_focus = beautiful.panel_fg_focus, bg_focus = beautiful.bg_focus, shape = gears.shape.rectangle, shape_border_width = 5, shape_border_color = beautiful.tasklist_bg_normal, align = "center" })

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
       s.mytasklist, -- Middle widget
       { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          s.my_sys,
          spr_right,
          calendar_icon,
          calendarwidget,
          bottom_bar,
          clock_icon,
          clockwidget,
          env.wrapper(tray.widget, "tray", tray.buttons),
          spr_space,
       },
    }
  end)
end



return toppanel
