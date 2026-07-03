local function disable_blur(classes)
	for _, class in ipairs(classes) do
		hl.window_rule({
			match = { class = class },
			no_blur = true,
		})
	end
end

disable_blur({
	"",
	"firefox",
	"Google-chrome",
	"Brave-browser",
	"antigravity",
	"kiro",
	"org.kde.dolphin",
	"Spotify",
  "kitty",
  "Xdg-desktop-portal-gtk",
  ""
})

local function disable_blur(classes)
	for _, class in ipairs(classes) do
		hl.window_rule({
			match = { class = class },
			active_opacity=1
		})
	end
end


