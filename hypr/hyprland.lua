-- hl.plugin.load("/var/cache/hyprpm/abhay/hyprexpo/hyprexpo.so")
-- hl.plugin.load("/var/cache/hyprpm/abhay/hyprland-plugins/hyprfocus.so")
require("configs.import")
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@100",
	position = "-1920x0",
	scale = 1,
})
hl.config({
	-- dwindle = {
	-- 	preserve_split = true,
	-- },
	master = {
		new_status = "master",
	},
	misc = {
		animate_manual_resizes = true,
		force_default_wallpaper = 0,
		disable_hyprland_logo = false,
		-- focus_on_activate = false,
	},
	input = {
		kb_layout = "us",
		repeat_rate = 100,
		repeat_delay = 200,
		follow_mouse = 1,
		sensitivity = 1,
		touchpad = {
			natural_scroll = false,
		},
	},
	cursor = {
		no_hardware_cursors = true,
		-- no_warps = true,
	},
	plugin = {
		-- hyprexpo = {
		-- 	columns = 3,
		-- 	gaps_in = 5,
		-- 	gaps_out = 0,
		-- 	bg_col = "rgb(111111)",
		-- 	gesture_distance = 200,
		-- 	cancel_key = "escape",
		-- 	show_cursor = 1,
		-- },
		-- hyprfocus = {
		-- 	mode = "bounce",
		-- 	bounce_strength = 20,
		-- 	fade_opacity = 0.5,
		-- 	only_on_monitor_change = false,
		-- },
	},
})

------------------
---- GESTURES ----
------------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

------------------
---- DEVICES -----
------------------
hl.device({
	name = "epic-mouse-v1",
	sensitivity = 0,
})
