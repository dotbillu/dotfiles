hl.bind(mainMod .. " + SHIFT + P", hl.dsp.submap("enter_screenShot_mode"))

hl.define_submap("enter_screenShot_mode", "reset", function()
	hl.bind("1", hl.dsp.exec_cmd("hyprshot -m output -m HDMI-A-1 -c -o" .. HYPRSHOT_DIR))
	hl.bind("2", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 -c -o" .. HYPRSHOT_DIR))

	hl.bind("3", hl.dsp.exec_cmd("hyprshot -zm window -c -o " .. HYPRSHOT_DIR))
	hl.bind("4", hl.dsp.exec_cmd("hyprshot -m region -c -o " .. HYPRSHOT_DIR))
  hl.bind("5",hl.dsp.exec_cmd("~/.config/hypr/scripts/lastScreenShot.sh"))
end)
