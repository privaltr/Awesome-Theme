local beautiful = require("beautiful")
local awful = require("awful")
local redflat = require("redflat")
local wibox = require("wibox")
local naughty = require("naughty")

local gears = require("gears")
local lain  = require("lain")

local string, os = string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.icon_dir                                  = os.getenv("HOME") .. "/.config/awesome/theme/icons"
theme.wallpaper                                 = os.getenv("HOME") .. "/.config/awesome/theme/wall.png"
theme.font                                      = "Roboto Bold 10"
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
theme.awesome_icon                              = theme.icon_dir .. "/awesome_icon_white.png"
theme.awesome_icon_launcher                     = theme.icon_dir .. "/awesome_icon.png"
theme.taglist_bg_empty                          = "png:" .. theme.icon_dir .. "/taglist/empty.png"
theme.taglist_bg_occupied                       = "png:" .. theme.icon_dir .. "/taglist/occupied.png"
theme.taglist_bg_urgent                         = "png:" .. theme.icon_dir .. "/taglist/urgent.png"
theme.taglist_bg_focus                          = "png:" .. theme.icon_dir .. "/taglist/focus.png"
theme.taglist_squares_sel                       = theme.icon_dir .. "/taglist/square_sel.png"
theme.taglist_squares_unsel                     = theme.icon_dir .. "/taglist/square_unsel.png"
theme.spr_space                                 = theme.icon_dir .. "/spr_space.png"
theme.spr_small                                 = theme.icon_dir .. "/spr_small.png"
theme.spr_very_small                            = theme.icon_dir .. "/spr_very_small.png"
theme.spr_right                                 = theme.icon_dir .. "/spr_right.png"
theme.spr_bottom_right                          = theme.icon_dir .. "/spr_bottom_right.png"
theme.spr_left                                  = theme.icon_dir .. "/spr_left.png"
theme.bar                                       = theme.icon_dir .. "/bar.png"
theme.bottom_bar                                = theme.icon_dir .. "/bottom_bar.png"
theme.ac                                        = theme.icon_dir .. "/ac.png"
theme.bat                                       = theme.icon_dir .. "/bat.png"
theme.bat_low                                   = theme.icon_dir .. "/bat_low.png"
theme.bat_no                                    = theme.icon_dir .. "/bat_no.png"
theme.task                                      = theme.icon_dir .. "/task.png"
theme.clock                                     = theme.icon_dir .. "/clock.png"
theme.calendar                                  = theme.icon_dir .. "/cal.png"
theme.cpu                                       = theme.icon_dir .. "/cpu.png"
theme.net_up                                    = theme.icon_dir .. "/net_up.png"
theme.net_down                                  = theme.icon_dir .. "/net_down.png"
theme.calendar                                  = theme.icon_dir ..  "/cal.png"
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

theme.musicplr = string.format("%s -e ncmpcpp", awful.util.terminal)

local markup = lain.util.markup
local blue   = "#80CCE6"
local space3 = markup.font("Roboto 3", " ")

-- Clock
local mytextclock = wibox.widget.textclock(markup("#FFFFFF", space3 .. "%I:%M %p  " .. markup.font("Roboto 4", " ")))
mytextclock.font = theme.font
local clock_icon = wibox.widget.imagebox(theme.clock)
local clockbg = wibox.container.background(mytextclock, theme.bg_focus, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, 0, 3, 5, 5)

-- Calendar
local mytextcalendar = wibox.widget.textclock(markup.fontfg(theme.font, "#FFFFFF", space3 .. "%d %b " .. markup.font("Roboto 5", " ")))
local calendar_icon = wibox.widget.imagebox(theme.calendar)
local calbg = wibox.container.background(mytextcalendar, theme.bg_focus, gears.shape.rectangle)
local calendarwidget = wibox.container.margin(calbg, 0, 0, 5, 5)
--theme.cal = lain.widget.cal({
--      attach_to = { mytextclock, mytextcalendar },
--      notification_preset = {
--         fg = "#FFFFFF",
--         bg = theme.bg_normal,
--         position = "top_right",
--         font = "Sarasa Mono H Bold 10"
--      },
--      followtag = true
--})

---- Battery
--local baticon = wibox.widget.imagebox(theme.bat)
--local batbar = wibox.widget {
--   forced_height    = 0,
--   forced_width     = 80,
--   color            = "#80CCE6",
--   background_color = "#383838",
--   margins          = 5,
--   paddings         = 0,
--   ticks            = false,
--   widget           = wibox.widget.progressbar,
--}
--
--local batbg = wibox.container.background(batbar, "#303030", gears.shape.rectangle)
--local batwidget = wibox.container.margin(batbg, 0, 0, 5, 5)
--
---- Battery tooltip on bar
--batwidget.tooltip = awful.tooltip({ objects = { batbar } })
--batwidget.tooltip.wibox.fg = theme.fg_normal
--batwidget.tooltip.wibox.font = "Roboto Condensed Bold 8"
---- Initial message
--batwidget.tooltip:set_text("Setting Up...")
--
--local batupd = lain.widget.bat({
--      settings = function()
--         if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then return end
--
--         if bat_now.status == "Charging" then
--            baticon:set_image(theme.ac)
--            batwidget.tooltip:set_text(string.format("Charging: %d", bat_now.perc))
--            if bat_now.perc >= 98 then
--               batbar:set_color("#80CCE6")
--            elseif bat_now.perc > 50 then
--               batbar:set_color("#80CCE6")
--            elseif bat_now.perc > 15 then
--               batbar:set_color("#80CCE6")
--
--            else
--               batbar:set_color("#80CCE6")
--            end
--         elseif bat_now.status == "Full" then
--            baticon:set_image(theme.ac)
--            batwidget.tooltip:set_text("Full")
--            batbar:set_color("#80E687")
--         else
--            batwidget.tooltip:set_text(string.format("Discharging: %d", bat_now.perc))
--            if bat_now.perc >= 98 then
--               batbar:set_color("#80CCE6")
--               baticon:set_image(theme.bat)
--            elseif bat_now.perc > 25 then
--               batbar:set_color("#80CCE6")
--               baticon:set_image(theme.bat)
--            elseif bat_now.perc > 15 then
--               batbar:set_color("#ECEA88")
--               baticon:set_image(theme.bat_low)
--            else
--               batbar:set_color("#FF9F9F")
--               baticon:set_image(theme.bat_no)
--            end
--         end
--         batbar:set_value(bat_now.perc / 100)
--      end
--})

-- ALSA volume bar
-- theme.volume = lain.widget.alsabar({
--       -- notification_preset = { font = "Monospace 9"},
--       notification_preset = { font = "Sarasa Mono H Bold 9", position = "top_right" },
--       --togglechannel = "IEC958,3",
--       width = 80, height = 10, border_width = 0,
--       colors = {
--          background = "#383838",
--          unmute     = "#80CCE6",
--          mute       = "#FF9F9F"
--       },
-- })
--
-- theme.volume.bar.paddings = 0
-- theme.volume.bar.margins = 5
-- local volumewidget = wibox.container.background(theme.volume.bar, theme.bg_focus, gears.shape.rectangle)
-- volumewidget = wibox.container.margin(volumewidget, 0, 0, 5, 5)
--
-- theme.volume.bar:buttons(my_table.join (
--                             awful.button({}, 3, function()
--                                   awful.spawn(string.format("%s -e alsamixer", awful.util.terminal))
--                                   -- theme.volume.update()
--                                   theme.volume.notify()
--                             end),
--                             awful.button({}, 2, function()
--                                   os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
--                                   -- theme.volume.update()
--                                   theme.volume.notify()
--                             end),
--                             awful.button({}, 1, function()
--                                   os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
--                                   -- theme.volume.update()
--                                   theme.volume.notify()
--                             end),
--                             awful.button({}, 4, function()
--                                   awful.spawn.with_shell("$HOME/.bin/volume/up")
--                                   -- theme.volume.update()
--                                   theme.volume.notify()
--                             end),
--                             awful.button({}, 5, function()
--                                   awful.spawn.with_shell("$HOME/.bin/volume/down")
--                                   -- theme.volume.update()
--                                   theme.volume.notify()
--                             end)
-- ))

-- CPU
-- local cpu_icon = wibox.widget.imagebox(theme.cpu)
-- local cpu = lain.widget.cpu({
--       settings = function()
--          widget:set_markup(space3 .. markup.font(theme.font, "CPU " .. cpu_now.usage
--                                                     .. "% ") .. markup.font("Roboto 5", " "))
--       end
-- })
-- local cpubg = wibox.container.background(cpu.widget, theme.bg_focus, gears.shape.rectangle)
-- local cpuwidget = wibox.container.margin(cpubg, 0, 0, 5, 5)

-- Net
-- local netdown_icon = wibox.widget.imagebox(theme.net_down)
-- local netup_icon = wibox.widget.imagebox(theme.net_up)
-- local net = lain.widget.net({
--       settings = function()
--          widget:set_markup(markup.font("Roboto 1", " ") .. markup.font(theme.font, net_now.received .. " - "
--                                                                           .. net_now.sent) .. markup.font("Roboto 2", " "))
--       end
-- })
-- local netbg = wibox.container.background(net.widget, theme.bg_focus, gears.shape.rectangle)
-- local networkwidget = wibox.container.margin(netbg, 0, 0, 5, 5)

-- Weather
-- theme.weather = lain.widget.weather({
--       city_id = 2643743, -- placeholder (London)
--       notification_preset = { font = "Sarasa Mono H Bold 9", position = "top_right" },
-- })

-- Launcher
local mylauncher = awful.widget.button({ image = theme.awesome_icon_launcher })
mylauncher:connect_signal("button::press", function() awful.util.mymainmenu:toggle() end)

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local spr_space = wibox.widget.imagebox(theme.spr_space)
local spr_small = wibox.widget.imagebox(theme.spr_small)
local spr_very_small = wibox.widget.imagebox(theme.spr_very_small)
local spr_right = wibox.widget.imagebox(theme.spr_right)
local spr_bottom_right = wibox.widget.imagebox(theme.spr_bottom_right)
local spr_left = wibox.widget.imagebox(theme.spr_left)
local bar = wibox.widget.imagebox(theme.bar)
local bottom_bar = wibox.widget.imagebox(theme.bottom_bar)

local barcolor  = gears.color({
      type  = "linear",
      from  = { 32, 0 },
      to    = { 32, 32 },
      stops = { {0, theme.bg_focus}, {0.25, "#505050"}, {1, theme.bg_focus} }
})

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
               instance = awful.menu.clients({theme = {width = 250}})
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
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { fg_focus = beautiful.panel_fg_focus, bg_focus = theme.bg_focus, shape = gears.shape.rectangle, shape_border_width = 5, shape_border_color = theme.tasklist_bg_normal, align = "center" })

    -- Create the wibox
    --s.panel = awful.wibar({ position = "top", screen = s, height = 32 })
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
          --volumewidget,
          --bar,
          --spr_very_small,
          --baticon,
          --batwidget,
          --bottom_bar,
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
