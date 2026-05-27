require("configs.animations.spring")
require("configs.animations.default")

-----------------------------
---- CATPPUCCIN MOCHA COLS --
-----------------------------
local rosewater = 0xfff5e0dc
local flamingo = 0xfff2cdcd
local pink = 0xfff5c2e7
local mauve = 0xffcba6f7
local red = 0xfff38ba8
local maroon = 0xffeba0ac
local peach = 0xfffab387
local yellow = 0xfff9e2af
local green = 0xffa6e3a1
local teal = 0xff94e2d5
local sky = 0xff89dceb
local sapphire = 0xff74c7ec
local blue = 0xff89b4fa
local lavender = 0xffb4bfe2
local text = 0xffcdd6f4
local surface0 = 0xff313244
local base = 0xff1e1e2e
local mantle = 0xff181825
local crust = 0xff11111b

-------------------------
---- VISUAL DESIGN ------
-------------------------
hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 1,
		float_gaps = 0,
		col = {
			active_border = 0xffb4bfe2,
			inactive_border = surface0,
			nogroup_border = surface0,
			nogroup_border_active = 0xffb4bfe2,
		},
		resize_on_border = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 100,
			render_power = 4,
			color = 0xee1a1a1a,
		},
		blur = {
			enabled = false,
			size = 3,
			passes = 2,
			new_optimizations = true,
			ignore_opacity = false,
		},
	},
	animations = {
		enabled = true,
	},
})
