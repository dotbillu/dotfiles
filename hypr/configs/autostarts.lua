hl.on("hyprland.start", function()
	-- Core components & panels
	-- hl.exec_cmd("hyprpanel")
	hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("wayscriber --daemon")
	hl.exec_cmd("pypr")
	hl.exec_cmd("~/.local/bin/headset-media")

	-- Indicators & environment setups
	hl.exec_cmd('bash -c "sleep 5 && kdeconnect-indicator"')
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user restart xdg-desktop-portal")
	hl.exec_cmd("swww-daemon")
	hl.exec_cmd("sleep 2 && hyprctl reload")

	hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-macchiato-flamingo-standard+default"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("swaync")
	hl.exec_cmd("qs")
	hl.exec_cmd("sleep 2 && swww img ~/.config/hypr/wallpapers/gray.jpg")
end)
