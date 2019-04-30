-----------------------------------------------------------------------------------------------------------------------
--                                          Hotkeys and mouse buttons config                                         --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local table = table
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local redflat = require("redflat")
-- Load the widget.


local lain          = require("lain")
-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = { mouse = {}, raw = {}, keys = {}, fake = {} }

-- key aliases
local appswitcher = redflat.float.appswitcher
local current = redflat.widget.tasklist.filter.currenttags
local allscr = redflat.widget.tasklist.filter.allscreen
local laybox = redflat.widget.layoutbox
local redtip = redflat.float.hotkeys
local laycom = redflat.layout.common
local redtitle = redflat.titlebar

-- Key support functions
-----------------------------------------------------------------------------------------------------------------------
local focus_switch_byd = function(dir)
	return function()
		awful.client.focus.bydirection(dir)
		if client.focus then client.focus:raise() end
	end
end

local function minimize_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) then c.minimized = true end
	end
end

local function minimize_all_except_focused()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c ~= client.focus then c.minimized = true end
	end
end

local function restore_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c.minimized then c.minimized = false end
	end
end

local function kill_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and not c.sticky then c:kill() end
	end
end

local function focus_to_previous()
	awful.client.focus.history.previous()
	if client.focus then client.focus:raise() end
end

local function restore_client()
	local c = awful.client.restore()
	if c then client.focus = c; c:raise() end
end

local function toggle_placement(env)
	env.set_slave = not env.set_slave
	redflat.float.notify:show({ text = (env.set_slave and "Slave" or "Master") .. " placement" })
end

local function tag_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then action(tag) end
		end
	)
end

local function client_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then action(tag) end
			end
		end
	)
end

local brightness = function(arg)
	redflat.float.brightness:change_with_xbacklight(arg)
end

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function hotkeys:init(args)

	-- Init vars
	------------------------------------------------------------
	local args = args or {}
	local env = args.env
	local mainmenu = args.menu

	self.mouse.root = (awful.util.table.join(
		awful.button({ }, 3, function () mainmenu:toggle() end) --,
		-- awful.button({ }, 4, awful.tag.viewnext),
		-- awful.button({ }, 5, awful.tag.viewprev)
	))

	-- Layouts
	--------------------------------------------------------------------------------
	-- this is exaple for layouts hotkeys setup, see other color configs for more

	local layout_tile = {
		{
			{ env.mod }, "l", function () awful.tag.incmwfact( 0.05) end,
			{ description = "Increase master width factor", group = "Layout" }
		},
		{
			{ env.mod }, "h", function () awful.tag.incmwfact(-0.05) end,
			{ description = "Decrease master width factor", group = "Layout" }
		},
		{
			{ env.mod }, "j", function () awful.client.incwfact( 0.05) end,
			{ description = "Increase window factor of a client", group = "Layout" }
		},
		{
			{ env.mod }, "k", function () awful.client.incwfact(-0.05) end,
			{ description = "Decrease window factor of a client", group = "Layout" }
		},
		{
			{ env.mod, "Shift" }, "h", function () awful.tag.incnmaster( 1, nil, true) end,
			{ description = "Increase the number of master clients", group = "Layout" }
		},
		{
			{ env.mod, "Shift" }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
			{ description = "Decrease the number of master clients", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "h", function () awful.tag.incncol( 1, nil, true) end,
			{ description = "Increase the number of columns", group = "Layout" }
		},
		{
			{ env.mod, "Control" }, "l", function () awful.tag.incncol(-1, nil, true) end,
			{ description = "Decrease the number of columns", group = "Layout" }
		},
	}

	laycom:set_keys(layout_tile, "tile")

	-- Keys for widgets
	--------------------------------------------------------------------------------


	-- Menu widget
	------------------------------------------------------------
	local menu_keys_move = {
		{
			{ env.mod }, "k", redflat.menu.action.down,
			{ description = "Select next item", group = "Navigation" }
		},
		{
			{ env.mod }, "j", redflat.menu.action.up,
			{ description = "Select previous item", group = "Navigation" }
		},
		{
			{ env.mod }, "h", redflat.menu.action.back,
			{ description = "Go back", group = "Navigation" }
		},
		{
			{ env.mod }, "l", redflat.menu.action.enter,
			{ description = "Open submenu", group = "Navigation" }
		},
	}

	redflat.menu:set_keys(awful.util.table.join(redflat.menu.keys.move, menu_keys_move), "move")

	-- Appswitcher
	------------------------------------------------------------
	appswitcher_keys_move = {
		{
			{ env.mod }, "a", function() appswitcher:switch() end,
			{ description = "Select next app", group = "Navigation" }
		},
		{
			{ env.mod }, "q", function() appswitcher:switch({ reverse = true }) end,
			{ description = "Select previous app", group = "Navigation" }
		},
	}

	appswitcher_keys_action = {
		{
			{ env.mod }, "Super_L", function() appswitcher:hide() end,
			{ description = "Activate and exit", group = "Action" }
		},
		{
			{}, "Escape", function() appswitcher:hide(true) end,
			{ description = "Exit", group = "Action" }
		},
	}

	appswitcher:set_keys(awful.util.table.join(appswitcher.keys.move, appswitcher_keys_move), "move")
	appswitcher:set_keys(awful.util.table.join(appswitcher.keys.action, appswitcher_keys_action), "action")


	-- Emacs like key sequences
	--------------------------------------------------------------------------------

	-- initial key
	-- first prefix key, no description needed here
	local keyseq = { { env.mod }, "c", {}, {} }

	-- second sequence keys
	keyseq[3] = {
		-- second and last key in sequence, full description and action is necessary
		{
			{}, "p", function () toggle_placement(env) end,
			{ description = "Switch master/slave window placement", group = "Clients managment" }
		},

		-- not last key in sequence, no description needed here
		{ {}, "k", {}, {} }, -- application kill group
		{ {}, "n", {}, {} }, -- application minimize group
		{ {}, "r", {}, {} }, -- application restore group

		-- { {}, "g", {}, {} }, -- run or rise group
		-- { {}, "f", {}, {} }, -- launch application group
	}

	-- application kill actions,
	-- last key in sequence, full description and action is necessary
	keyseq[3][2][3] = {
		{
			{}, "f", function() if client.focus then client.focus:kill() end end,
			{ description = "Kill focused client", group = "Kill application", keyset = { "f" } }
		},
		{
			{}, "a", kill_all,
			{ description = "Kill all clients with current tag", group = "Kill application", keyset = { "a" } }
		},
	}

	-- application minimize actions,
	-- last key in sequence, full description and action is necessary
	keyseq[3][3][3] = {
		{
			{}, "f", function() if client.focus then client.focus.minimized = true end end,
			{ description = "Minimized focused client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", minimize_all,
			{ description = "Minimized all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
		{
			{}, "e", minimize_all_except_focused,
			{ description = "Minimized all clients except focused", group = "Clients managment", keyset = { "e" } }
		},
	}

	-- application restore actions,
	-- last key in sequence, full description and action is necessary
	keyseq[3][4][3] = {
		{
			{}, "f", restore_client,
			{ description = "Restore minimized client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", restore_all,
			{ description = "Restore all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
	}

	-- quick launch key sequence actions, auto fill up last sequence key
	-- for i = 1, 9 do
	-- 	local ik = tostring(i)
	-- 	table.insert(keyseq[3][5][3], {
	-- 		{}, ik, function() qlaunch:run_or_raise(ik) end,
	-- 		{ description = "Run or rise application №" .. ik, group = "Run or Rise", keyset = { ik } }
	-- 	})
	-- 	table.insert(keyseq[3][6][3], {
	-- 		{}, ik, function() qlaunch:run_or_raise(ik, true) end,
	-- 		{ description = "Launch application №".. ik, group = "Quick Launch", keyset = { ik } }
	-- 	})
	-- end


	-- Global keys
	--------------------------------------------------------------------------------
	self.raw.root = {
			{
			 { env.mod }, "b",
			 function()
				 local s = awful.screen.focused()
				 s.panel.visible = not s.panel.visible
				 if beautiful.wibar_detached then
					 s.useless_wibar.visible = not s.useless_wibar.visible
				 end
			 end,
			 {description = "show or hide wibar", group = "awesome"},
		 },
		 {
 			{ env.mod }, "F9",  function() awful.util.spawn("urxvt -name floating -e calcurse") end, --function() awful.spawn(os.getenv("HOME") .. "/.config/awesome/scripts/evolution.sh") end,
 							{ description = "calcurse", group = "tag"},
 		},
		{
			{ env.mod,  "Shift" }, "=", function () lain.util.useless_gaps_resize(1) end,
							{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod,  "Shift" }, "-", function () lain.util.useless_gaps_resize(-1) end,
							{ description = "decrement useless gaps", group = "tag"},
		},
		{
			{ env.mod }, "s", function () awful.screen.focused().mypromptbox:run() end,
							{ description = "run prompt", group = "launcher"},
		},
		-- {
		-- 	--{ env.mod }, "grave", function() sidebar.visible = not sidebar.visible end,
		-- 	{ env.mod }, "grave", function() if exit_screen.visible == false then exit_screen_show() end  end,
		-- 					{ description = "Show exit screen", group = "Exit"},
		-- },
		{
			{env.mod}, "`", function () awful.screen.focus_relative( 1) screen.emit_signal("request::activate", "screen-switch", {raise = true}) end,
							{ description = "focus the next screen", group = "screen"},
		},
		{
			{env.mod, "Shift"}, "`", function () awful.screen.focus_relative(-1) screen.emit_signal("request::activate", "screen-switch", {raise = true}) end,
							{ description = "focus the next screen", group = "screen"},
		},
		{
			{}, "XF86AudioRaiseVolume", function() redflat.widget.pulse:change_volume() end,
          		{ description = "Raise audio volume", group = "Audio"},
		},

		{
			{}, "XF86AudioLowerVolume", function() redflat.widget.pulse:change_volume({ down = true }) end,
          		{ description = "Lower audio volume", group = "Audio"},
		},

		{
			{}, "XF86AudioMute", function() redflat.widget.pulse:mute()                         end,
          		{ description = "Mute audio volume", group = "Audio"},
		},
		{
			{}, "Print", scrot_full,
          		{ description = "Take a screenshot of entire screen", group = "Screenshot"},
		},
		{
			{ env.mod }, "Print", scrot_selection,
							{ description = "Take a screenshot of selection", group = "Screenshot"},
		},
		{
			{ "Shift" }, "Print", scrot_window,
          		{ description = "Take a screenshot of focused window", group = "Screenshot"},
		},
		{
      {}, "XF86MonBrightnessUp", function() brightness({ step = 5 }) end,
      				{ description = "Increase brightness", group = "Brightness control" }
    },
		{
      {}, "XF86MonBrightnessDown", function() brightness({ step = 5, down = true }) end,
              { description = "Reduce brightness", group = "Brightness control" }
    },
		{
      {}, "XF86ScreenSaver", function() awful.spawn("sh /home/rjmvisser/.config/awesome/colorless/scripts/lock.sh") end,
              { description = "Lock screen", group = "Screen control" }
    },
		{
			{ env.mod }, "F1", function() redtip:show() end,
			{ description = "Show hotkeys helper", group = "Main" }
		},
		{
			{ env.mod }, "F2", function () redflat.service.navigator:run() end,
			{ description = "Window control mode", group = "Main" }
		},
		{
			{ env.mod, "Control" }, "r", awesome.restart,
			{ description = "Reload awesome", group = "Main" }
		},
		{
			{ env.mod }, "c", function() redflat.float.keychain:activate(keyseq, "User") end,
			{ description = "User key sequence", group = "Main" }
		},
		{
			{ env.mod }, "Return", function() awful.spawn(env.terminal) end,
			{ description = "Open a terminal", group = "Main" }
		},
		{
      { env.mod }, "d", function() awful.spawn(os.getenv("HOME") .. "/.config/awesome/colorless/scripts/draw.sh") end,
      { description = "Draw a terminal", group = "Main" }
    },
		{
			{ env.mod }, "l", focus_switch_byd("right"),
			{ description = "Go to right client", group = "Client focus" }
		},
		{
			{ env.mod }, "h", focus_switch_byd("left"),
			{ description = "Go to left client", group = "Client focus" }
		},
		{
			{ env.mod }, "j", focus_switch_byd("up"),
			{ description = "Go to upper client", group = "Client focus" }
		},
		{
			{ env.mod }, "k", focus_switch_byd("down"),
			{ description = "Go to lower client", group = "Client focus" }
		},
		{
			{ env.mod }, "u", awful.client.urgent.jumpto,
			{ description = "Go to urgent client", group = "Client focus" }
		},
		{
			{ env.mod }, "Tab", focus_to_previous,
			{ description = "Go to previos client", group = "Client focus" }
		},

		{
			{ env.mod }, "w", function() mainmenu:show() end,
			{ description = "Show main menu", group = "Widgets" }
		},
		{
			{ env.mod }, "r", function() awful.spawn.with_shell("rofi -show combi") end,
			{ description = "Application launcher", group = "Widgets" }
		},
		{
			{ env.mod }, "p", function() redflat.float.prompt:run() end,
			{ description = "Show the prompt box", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "i", function ()
         awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible end,
			{ description = "Show minitray", group = "Widgets" }
		},
		{
			{ env.mod }, "F3", function() redflat.float.qlaunch:show() end,
			{ description = "Application quick launcher", group = "Main" }
		},

		{
			{ env.mod }, "t", function() redtitle.toggle(client.focus) end,
			{ description = "Show/hide titlebar for focused client", group = "Titlebar" }
		},
		{
			{ env.mod, "Control" }, "t", function() redtitle.switch(client.focus) end,
			{ description = "Switch titlebar view for focused client", group = "Titlebar" }
		},
		{
			{ env.mod, "Shift" }, "t", function() redtitle.toggle_all() end,
			{ description = "Show/hide titlebar for all clients", group = "Titlebar" }
		},
		{
			{ env.mod, "Control", "Shift" }, "t", function() redtitle.switch_all() end,
			{ description = "Switch titlebar view for all clients", group = "Titlebar" }
		},

		{
			{ env.mod }, "a", nil, function() appswitcher:show({ filter = current }) end,
			{ description = "Switch to next with current tag", group = "Application switcher" }
		},
		{
			{ env.mod }, "q", nil, function() appswitcher:show({ filter = current, reverse = true }) end,
			{ description = "Switch to previous with current tag", group = "Application switcher" }
		},
		{
			{ env.mod, "Shift" }, "a", nil, function() appswitcher:show({ filter = allscr }) end,
			{ description = "Switch to next through all tags", group = "Application switcher" }
		},
		{
			{ env.mod, "Shift" }, "q", nil, function() appswitcher:show({ filter = allscr, reverse = true }) end,
			{ description = "Switch to previous through all tags", group = "Application switcher" }
		},

		{
			{ env.mod }, "Escape",function () exit_screen_show() end,
      {description = "exit", group = "awesome"},
		},
		{
			{ env.mod }, "Right", awful.tag.viewnext,
			{ description = "View next tag", group = "Tag navigation" }
		},
		{
			{ env.mod }, "Left", awful.tag.viewprev,
			{ description = "View previous tag", group = "Tag navigation" }
		},

		{
			{ env.mod }, "y", function() laybox:toggle_menu(mouse.screen.selected_tag) end,
			{ description = "Show layout menu", group = "Layouts" }
		},
		{
			{ env.mod }, "Up", function() awful.layout.inc(1) end,
			{ description = "Select next layout", group = "Layouts" }
		},
		{
			{ env.mod }, "Down", function() awful.layout.inc(-1) end,
			{ description = "Select previous layout", group = "Layouts" }
		},
	}

	-- Client keys
	--------------------------------------------------------------------------------
	self.raw.client = {
		{
			{ env.mod }, "f", function(c) c.fullscreen = not c.fullscreen; c:raise() end,
			{ description = "Toggle fullscreen", group = "Client keys" }
		},
		{
			{ env.mod }, "F4", function(c) c:kill() end,
			{ description = "Close", group = "Client keys" }
		},
		{
			{ env.mod, "Control" }, "f", awful.client.floating.toggle,
			{ description = "Toggle floating", group = "Client keys" }
		},
		{
			{ env.mod, "Control" }, "o", function(c) c.ontop = not c.ontop end,
			{ description = "Toggle keep on top", group = "Client keys" }
		},
		{
			{ env.mod }, "n", function(c) c.minimized = true end,
			{ description = "Minimize", group = "Client keys" }
		},
		{
			{ env.mod }, "m", function(c) c.maximized = not c.maximized; c:raise() end,
			{ description = "Maximize", group = "Client keys" }
		},
		{
			{ env.mod, "Shift"   }, "z",      lain.util.magnify_client,
			{ description = "magnify client", group = "client" }
		},
		{
			{ env.mod  }, "j",  function (c)
         if c.floating == true then
            c:relative_move(  0,  20,   0,   0)
         else
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
         end
 	 			end,
			{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod }, "k",  function (c)
         if c.floating == true then
            c:relative_move(  0, -20,   0,   0)
         else
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
         end
 	 	end,
			{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod}, "h",  function (c)
         if c.floating == true then
            c:relative_move(-20,   0,   0,   0)
         else
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
         end
		end,
			{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod }, "l",  function (c)
         if c.floating == true then
            c:relative_move( 20,   0,   0,   0)
         else
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
         end
		end,
			{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod, "Shift"   }, "j", function (c)
         if c.floating == true then
            c:relative_move( 0,  0, 0, 40)
         else
            awful.client.incwfact(0.01)
         end
		end,
			{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod, "Shift"   }, "k", function (c)
         if c.floating == true then
            c:relative_move( 0, 0, 0, -40)
         else
            awful.client.incwfact(-0.01)
         end
		end,
			{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod, "Shift"   }, "h", function (c)
         if c.floating == true then
            c:relative_move( 0,  0, -40, 0)
         else
            awful.tag.incmwfact(-0.01)
         end
		end,
			{ description = "increment useless gaps", group = "tag"},
		},
		{
			{ env.mod, "Shift"   }, "l", function (c)
         if c.floating == true then
            c:relative_move( 0,  0, 40, 0)
         else
            awful.tag.incmwfact( 0.01)
         end
		end,
			{ description = "increment useless gaps", group = "tag"},
		}

	}

	self.keys.root = redflat.util.key.build(self.raw.root)
	self.keys.client = redflat.util.key.build(self.raw.client)

	-- Numkeys
	--------------------------------------------------------------------------------

	-- add real keys without description here
	for i = 1, 9 do
		self.keys.root = awful.util.table.join(
			self.keys.root,
			tag_numkey(i,    { env.mod },                     function(t) t:view_only()               end),
			tag_numkey(i,    { env.mod, "Control" },          function(t) awful.tag.viewtoggle(t)     end),
			client_numkey(i, { env.mod, "Shift" },            function(t) client.focus:move_to_tag(t) end),
			client_numkey(i, { env.mod, "Control", "Shift" }, function(t) client.focus:toggle_tag(t)  end)
		)
	end

	-- make fake keys with description special for key helper widget
	local numkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

	self.fake.numkeys = {
		{
			{ env.mod }, "1..9", nil,
			{ description = "Switch to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control" }, "1..9", nil,
			{ description = "Toggle tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Shift" }, "1..9", nil,
			{ description = "Move focused client to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control", "Shift" }, "1..9", nil,
			{ description = "Toggle focused client on tag", group = "Numeric keys", keyset = numkeys }
		},
	}

	-- Hotkeys helper setup
	--------------------------------------------------------------------------------
	redtip:set_pack("Main", awful.util.table.join(self.raw.root, self.raw.client, self.fake.numkeys), 2)
	--------------------------------------------------------------------------------
	self.mouse.client = awful.util.table.join(
		awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
		awful.button({ env.mod }, 1, awful.mouse.client.move),
		awful.button({ env.mod }, 3, awful.mouse.client.resize)
	)

	-- Set root hotkeys
	--------------------------------------------------------------------------------
	root.keys(self.keys.root)
	root.buttons(self.mouse.root)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys
