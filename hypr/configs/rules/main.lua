hl.window_rule({
	match = {
		class = "^zen$",
	},
	no_blur = true,
	float = true,
	size = { 1300, 800 },
	center = true,
})

hl.window_rule({
	match = { class = "org.gnome.eog" },
	float = true,
	size = { 1200, 700 },
})

hl.window_rule({
	match = {
		class = "Xdg-desktop-portal-gtk",
		class = "",
	},
	border_size = 0,
	no_shadow = 1,
	move = { 100, 100 },
	float = true,
	no_blur = true,
})

hl.window_rule({
	match = {
		class = "Xdg-desktop-portal-gtk",
	},
	border_size = 0,
	no_shadow = 1,
	move = { 10, 10 },
	float = true,
	no_blur = true,
})

hl.window_rule({
	match = {
		class = "kitty",
	},
	no_blur = true,
})

hl.window_rule({
	match = {
		class = "google-chrome",
	},
	no_blur = true,
})

hl.window_rule({
	match = {
		class = "antigravity",
	},
	no_blur = true,
})

hl.window_rule({
	match = {
		class = "kiro",
	},
	no_blur = true,
})

hl.window_rule({
	match = {
		class = "pcmanfm-qt",
	},
	size = { 1200, 700 },
	move = { 500, 300 },
	no_blur = true,
	float = true,
})

hl.window_rule({
	match = {
		class = "kitty",
	},
	no_blur = true,
})
hl.window_rule({
	match = { class = "Spotify" },
	opacity = 0.8,
	size = { 1200, 700 },
	float = true,
	center = true,
})

hl.window_rule({
	match = {
		class = "lxqt-archiver",
	},
	no_blur = true,
	float = true,
	size = { 1200, 700 },
})

hl.window_rule({
	match = {
		class = "org.pulseaudio.pavucontrol",
	},
	no_blur = true,
	float = true,
	size = { 1200, 700 },
})
