local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')
local keygrabber = require('awful.keygrabber')

-- Appearance
local icon_size = beautiful.exit_screen_icon_size or 140




function clickable_container(widget)
    local container =
        wibox.widget {
        widget,
        widget = wibox.container.background
    }
    local old_cursor, old_wibox

    container:connect_signal(
        'mouse::enter',
        function()
            container.bg = '#ffffff11'
            -- Hm, no idea how to get the wibox from this signal's arguments...
            local w = _G.mouse.current_wibox
            if w then
                old_cursor, old_wibox = w.cursor, w
                w.cursor = 'hand1'
            end
        end
    )

    container:connect_signal(
        'mouse::leave',
        function()
            container.bg = '#ffffff00'
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end
    )

    container:connect_signal(
        'button::press',
        function()
            container.bg = '#ffffff22'
        end
    )

    container:connect_signal(
        'button::release',
        function()
            container.bg = '#ffffff11'
        end
    )

    return container
end



local buildButton =
  function(icon, tooltipText)

  local abutton =
    wibox.widget {
    wibox.widget {
      wibox.widget {
        wibox.widget {
          image = icon,
          widget = wibox.widget.imagebox
        },
        top = 16,
        bottom = 16,
        left = 16,
        right = 16,
        widget = wibox.container.margin
      },
      shape = gears.shape.circle,
      forced_width = icon_size,
      forced_height = icon_size,
      widget = clickable_container
    },
    left = 24,
    right = 24,
    widget = wibox.container.margin
  }

  return abutton
end

function suspend_command()
  exit_screen_hide()
  awful.spawn.with_shell('dm-tool switch-to-greeter' .. ' & systemctl suspend')
end
function hibernate_command()
  exit_screen_hide()
  awful.spawn.with_shell('dm-tool switch-to-greeter' .. ' & systemctl hibernate')
end
function exit_command()
  awesome.quit()
end
function lock_command()
  exit_screen_hide()
  awful.spawn.with_shell('sh ~/.config/awesome/colorless/scripts/lock.sh')
end
function poweroff_command()
  awful.spawn.with_shell('systemctl poweroff')
  awful.keygrabber.stop(exit_screen_grabber)
end
function reboot_command()
  awful.spawn.with_shell('systemctl reboot')
  awful.keygrabber.stop(exit_screen_grabber)
end

local poweroff = buildButton(beautiful.power, 'Shutdown')
poweroff:connect_signal(
  'button::release',
  function()
    poweroff_command()
  end
)

local reboot = buildButton(beautiful.restart, 'Restart')
reboot:connect_signal(
  'button::release',
  function()
    reboot_command()
  end
)

local suspend = buildButton(beautiful.suspend, 'Suspend')
suspend:connect_signal(
  'button::release',
  function()
    suspend_command()
  end
)

local hibernate = buildButton(beautiful.hibernate, 'Hibernate')
hibernate:connect_signal(
  'button::release',
  function()
    hibernate_command()
  end
)

local exit = buildButton(beautiful.logout, 'Logout')
exit:connect_signal(
  'button::release',
  function()
    exit_command()
  end
)

local lock = buildButton(beautiful.lock, 'Lock')
lock:connect_signal(
  'button::release',
  function()
    lock_command()
  end
)

-- Get screen geometry
local screen_geometry = awful.screen.focused().geometry

-- Create the widget
exit_screen =
  wibox(
  {
    x = screen_geometry.x,
    y = screen_geometry.y,
    visible = false,
    ontop = true,
    type = 'splash',
    height = screen_geometry.height,
    width = screen_geometry.width
  }
)

exit_screen.bg = beautiful.background_hue_800
exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or '#FEFEFE'

local exit_screen_grabber

function exit_screen_hide()
  awful.keygrabber.stop(exit_screen_grabber)
  exit_screen.visible = false
end

function exit_screen_show()
  exit_screen_grabber =
    awful.keygrabber.run(
    function(_, key, event)
      if event == 'release' then
        return
      end

      if key == 's' then
        suspend_command()
      elseif key == 'h' then
        hibernate_command()
      elseif key == 'e' then
        exit_command()
      elseif key == 'l' then
        lock_command()
      elseif key == 'p' then
        poweroff_command()
      elseif key == 'r' then
        reboot_command()
      elseif key == 'Escape' or key == 'q' or key == 'x' or key == '`' then
        exit_screen_hide()
      end
    end
  )
  exit_screen.visible = true
end

exit_screen:buttons(
  gears.table.join(
    -- Middle click - Hide exit_screen
    awful.button(
      {},
      2,
      function()
        exit_screen_hide()
      end
    ),
    -- Right click - Hide exit_screen
    awful.button(
      {},
      3,
      function()
        exit_screen_hide()
      end
    )
  )
)

-- Item placement
exit_screen:setup {
  nil,
  {
    nil,
    {
      -- {
      poweroff,
      reboot,
      suspend,
      hibernate,
      exit,
      lock,
      layout = wibox.layout.fixed.horizontal
      -- },
      -- widget = exit_screen_box
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.horizontal
  },
  nil,
  expand = 'none',
  layout = wibox.layout.align.vertical
}
