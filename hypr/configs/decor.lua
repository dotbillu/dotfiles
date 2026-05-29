require("configs.animations.spring")
require("configs.animations.default")

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 8,
		border_size = 2,
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
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 30,
			render_power = 3,
			color = 0xaa000000,
		},

		blur = {
			enabled = false,
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
