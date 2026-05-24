hl.on("hyprland.start", function()
	-- Core components & panels
	-- hl.exec_cmd("hyprpanel")
	hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg")
	hl.exec_cmd("wayscriber --daemon")
	hl.exec_cmd("pypr")
	hl.exec_cmd("~/.local/bin/headset-media")

	-- Indicators & environment setups
	hl.exec_cmd('bash -c "sleep 5 && kdeconnect-indicator"')
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user restart xdg-desktop-portal")
	hl.exec_cmd("swww-daemon")
	hl.exec_cmd("sleep 2 && hyprctl reload")

	-- Theme setups (Catppuccin)
	hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-macchiato-flamingo-standard+default"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')

	-- Web apps / Specific workspace setups
	hl.exec_cmd("google-chrome --profile-directory=Default --app-id=hnpfjngllnobngcgfapefoaidbinmjnm", { 
		workspace = "20 silent" 
	})
end)

hl.exec_cmd("swww img ~/.config/hypr/wallpapers/dexter.jpg --outputs eDP-1")
hl.exec_cmd("swww img ~/.config/hypr/wallpapers/oversized-cat.jpg --outputs HDMI-A-1")

hl.exec_cmd("swaync")
