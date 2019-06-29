-----------------------------------------------------------------------------------------------------------------------
--                                              Autostart app list                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local autostart = {}

-- Application list function
--------------------------------------------------------------------------------
function autostart.run()
	-- utils
	awful.spawn.with_shell("compton --config /home/rjmvisser/.config/compton/compton.conf")
	awful.spawn.with_shell("xbindkeys -p")
	awful.spawn.with_shell("start-pulseaudio-x11")
	awful.spawn.with_shell("pa-applet")
	awful.spawn.with_shell("blueman-applet")
	awful.spawn.with_shell("nm-applet")
	awful.spawn.with_shell("redshift-gtk -c ~/.config/redshift.conf")
	awful.spawn.with_shell("xfce4-power-manager")
	awful.spawn.with_shell("kdeconnect-indicator")
    awful.spawn.with_shell("sleep 3 && birdtray")
	awful.spawn.with_shell("simplescreenrecorder --start-hidden")
    awful.spawn.with_shell("octopi-notifier")

	awful.spawn.with_shell("synclient MinSpeed=1.3")
	awful.spawn.with_shell("synclient TapButton1=1")
	awful.spawn.with_shell("synclient TouchpadOff=1")


end

-- Read and commads from file and spawn them
--------------------------------------------------------------------------------
function autostart.run_from_file(file_)
	local f = io.open(file_)
	for line in f:lines() do
		if line:sub(1, 1) ~= "#" then awful.spawn.with_shell(line) end
	end
	f:close()
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return autostart
