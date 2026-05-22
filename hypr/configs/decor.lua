-----------------------------
---- CATPPUCCIN MOCHA COLS --
-----------------------------
local rosewater = 0xfff5e0dc
local flamingo  = 0xfff2cdcd
local pink      = 0xfff5c2e7
local mauve     = 0xffcba6f7
local red       = 0xfff38ba8
local maroon    = 0xffeba0ac
local peach     = 0xfffab387
local yellow    = 0xfff9e2af
local green     = 0xffa6e3a1
local teal      = 0xff94e2d5
local sky       = 0xff89dceb
local sapphire  = 0xff74c7ec
local blue      = 0xff89b4fa
local lavender  = 0xffb4bfe2
local text      = 0xffcdd6f4
local surface0  = 0xff313244
local base      = 0xff1e1e2e
local mantle    = 0xff181825
local crust     = 0xff11111b

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

-------------------------
---- BEZIER CURVES ------
-------------------------
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.85 }, { 0.03, 0.97} } })
hl.curve("winIn", { type = "bezier", points = { { 0.07, 0.88 }, { 0.04, 0.99 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.20, -0.15 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.12, 0 }, { 0, 1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.80 }, { 0.10, 0.97 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.20, 0 }, { 0.80, 0.08 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.85 }, { 0.07, 1.04 } } })
hl.curve("crazyshot", { type = "bezier", points = { { 0.10, 1.22 }, { 0.68, 0.98 } } })
hl.curve("hyprnostretch", { type = "bezier", points = { { 0.05, 0.82 }, { 0.03, 0.94 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.05, 0.82 }, { 0, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.20, 0 }, { 0.82, 0.10 } } })
hl.curve("easeInOutCirc", { type = "bezier", points = { { 0.78, 0 }, { 0.15, 1 } } })
hl.curve("easeOutCirc", { type = "bezier", points = { { 0, 0.48 }, { 0.38, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.10, 0.94 }, { 0.23, 0.98 } } })
hl.curve("softAcDecel", { type = "bezier", points = { { 0.20, 0.20 }, { 0.15, 1 } } })
hl.curve("md2", { type = "bezier", points = { { 0.30, 0 }, { 0.15, 1 } } })
hl.curve("OutBack", { type = "bezier", points = { { 0.28, 1.40 }, { 0.58, 1 } } })

-------------------------
---- ANIMATIONS ---------
-------------------------
hl.animation({ leaf = "border", enabled = true, speed = 1.6, bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 82, bezier = "liner", style = "loop" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.1, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.1, bezier = "easeOutCirc" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.0, bezier = "wind", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.8, bezier = "md3_decel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 0.8, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1.21, bezier = "quick", style = "fade" })
