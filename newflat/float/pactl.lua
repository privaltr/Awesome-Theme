-----------------------------------------------------------------------------------------------------------------------
--                                        RedFlat pactl control widget                                          --
-----------------------------------------------------------------------------------------------------------------------
-- Volume control using pactl
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
-----------------------------------------------------------------------------------------------------------------------
local string = string
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local rednotify = require("newflat.float.notify")
local redutil = require("redflat.util")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local pactl = { }

local defaults = { down = false, step = 10 }

-- Generate default theme vars
-----------------------------------------------------------------------------------------------------------------------
local function default_style()
	local style = {
		notify = {},
	}
	return redutil.table.merge(style, redutil.table.check(beautiful, "float.volume") or {})
end

-- Change volume level
-----------------------------------------------------------------------------------------------------------------------


-- Change with pactl
------------------------------------------------------------
function pactl:increase_with_pactl(args)
	args = redutil.table.merge(defaults, args or {})

	volume = pactl.volume_with_pactl()
	if volume+args.step >= 100 then
		volume = 100
	else
		volume = volume +args.step
	end

	--local command = string.format("pactl -- set-sink-volume 0 +%d%%", args.step)
  local command = string.format("pactl -- set-sink-volume 0 %d%%", volume)

	awful.spawn.with_shell(command)

	red = true
	muted = pactl.status_with_pactl()
	if muted then
		red = false
	end

	if not pactl.style then pactl.style = default_style() end
	rednotify:show(redutil.table.merge(
		{ value = volume / 100, text = string.format('%.0f', volume) .. "%", red = red },
		pactl.style.notify
	))
end


-- Change with pactl
------------------------------------------------------------
function pactl:decrease_with_pactl(args)
	args = redutil.table.merge(defaults, args or {})

	volume = pactl.volume_with_pactl()
	if volume-args.step <= 0 then
		volume = 00
	else
		volume =volume-args.step
	end

	--local command = string.format("pactl -- set-sink-volume 0 -%d%%", args.step )
	local command = string.format("pactl -- set-sink-volume 0 %d%%", volume)

	awful.spawn.with_shell(command)

	red = true
	muted = pactl.status_with_pactl()
	if  muted then
		red = false
	end

	if not pactl.style then pactl.style = default_style() end
	rednotify:show(redutil.table.merge(
		{ value = volume / 100, text = string.format('%.0f', volume) .. "%", red = red },
		pactl.style.notify
	))
end

function pactl:toggle_with_pactl(args)
	cmd="pacmd list-sinks | awk '/muted/ { print $2 }'"
	local f = assert(io.popen(cmd, 'r'))
	s = assert(f:read('*a'))
	f:close()

	awful.spawn.with_shell("pactl list sinks | grep -q Mute:.no && pactl set-sink-mute 0 1 || pactl set-sink-mute 0 0")

	message = ""
	if string.match(s, "no") then
		message = "Muted"
		red=true
	elseif string.match(s, "yes") then
		message = "Unmuted"
		red=false
	end

	volume = pactl.volume_with_pactl()

	if not pactl.style then pactl.style = default_style() end
	rednotify:show(redutil.table.merge(
		{ value = volume / 100, text = message, red=red },
		pactl.style.notify
	))
end

function pactl.status_with_pactl()
	cmd="pacmd list-sinks | awk '/muted/ { print $2 }'"
	local f = assert(io.popen(cmd, 'r'))
	s = assert(f:read('*a'))
	f:close()

	message = ""
	muted  = false
	if string.match(s, "no") then
		muted=true
	elseif string.match(s, "yes") then
		muted=false
	end
	--naughty.notify({ text = string.format("%s", muted) })
	return muted
end


function pactl.volume_with_pactl()
	cmd ="pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \\([0-9][0-9]*\\)%.*,\\1,'"
	local f = assert(io.popen(cmd, 'r'))
	s = assert(f:read('*a'))
	f:close()
	return tonumber(s)
end

-----------------------------------------------------------------------------------------------------------------------
return pactl
