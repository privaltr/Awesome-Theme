-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")
local beautiful = require("beautiful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

rules.base_properties = {
	border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	focus        = awful.client.focus.filter,
	raise        = true,
	size_hints_honor = false,
	screen       = awful.screen.preferred,
	placement    = awful.placement.no_overlap + awful.placement.no_offscreen
}

rules.floating_any = {
	instance = { "DTA", "copyq", },
	class = {
		"Arandr", "Gpick", "Kruler", "MessageWin", "Sxiv", "Wpa_gui", "pinentry", "veromix", "floating",
		"xtightvncviewer"
	},
	name = { "Event Tester", },
	role = { "AlarmWindow", "pop-up", }
}

rules.grid_any = {
        name = {
                "floating",
        },
}

rules.maximized_any = {
        class = {
                "calcurse"
        },
				name = { "calcurse", },
}


-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:init(args)

	local args = args or {}
	self.base_properties.keys = args.hotkeys.keys.client
	self.base_properties.buttons = args.hotkeys.mouse.client


	-- Build rules
	--------------------------------------------------------------------------------
	self.rules = {
		{
			rule       = {},
			properties = args.base_properties or self.base_properties
		},
		{
			rule_any   = args.floating_any or self.floating_any,
			properties = { floating = true }
		},
		{
			rule_any   = { type = { "normal", "dialog" }},
			properties = { titlebars_enabled = true }
		},
		{
      rule_any   = args.grid_any or self.grid_any,
      properties = { floating = true, placement=nil }
    },
		{
			rule_any   = args.maximized_any or self.maximized_any,
			properties = { maximized=true }
		},

	}


	-- Set rules
	--------------------------------------------------------------------------------
	awful.rules.rules = rules.rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules
