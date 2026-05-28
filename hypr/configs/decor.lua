require("configs.animations.spring")
require("configs.animations.default")

-----------------------------
---- MONOCHROME SLATE ------
-----------------------------
local white = 0xfff2f2f2
local light_gray = 0xffd1d1d1
local soft_gray = 0xffa6a6a6
local gray = 0xff7a7a7a
local dark_gray = 0xff4d4d4d
local darker = 0xff2b2b2b
local black = 0xff121212

-------------------------
---- VISUAL DESIGN ------
-------------------------
hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 8,
		border_size = 1,
		float_gaps = 4,

		col = {
			active_border = light_gray,
			inactive_border = dark_gray,
			nogroup_border = darker,
			nogroup_border_active = soft_gray,
		},

		resize_on_border = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 14,
		rounding_power = 3,

		active_opacity = 1.0,
		inactive_opacity = 0.96,

		shadow = {
			enabled = true,
			range = 30,
			render_power = 3,
			color = 0xaa000000,
		},

		blur = {
			enabled = true,
			size = 5,
			passes = 2,
			new_optimizations = true,
			ignore_opacity = false,
		},
	},

	animations = {
		enabled = true,
	},
})
