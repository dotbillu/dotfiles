-- Super+Shift+L: hide the currently active special workspace (no-op if none open)
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("bash -c 'ws=$(hyprctl monitors -j | jq -r \".[] .specialWorkspace.name | select(length > 0)\" | head -1); [ -n \"$ws\" ] && hyprctl eval \"hl.dispatch(hl.dsp.workspace.toggle_special(\\\"${ws#special:}\\\"))\"'"))

-- Super+S: enter scratchpad picker submap (1-9,0 to toggle special workspaces)
hl.bind(mainMod .. " + S", hl.dsp.submap("scratchpad_pick"))

hl.define_submap("scratchpad_pick", "reset", function()
	for i = 1, 9 do
		local key = tostring(i)
		local name = tostring(i)
		hl.bind(key, function()
			hl.dispatch(hl.dsp.workspace.toggle_special(name))
			hl.dispatch(hl.dsp.submap("reset"))
		end)
	end
	-- 0 = workspace 10
	hl.bind("0", function()
		hl.dispatch(hl.dsp.workspace.toggle_special("10"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Super+L: enter move-to-scratchpad submap
hl.bind(mainMod .. " + L", hl.dsp.submap("scratchpad_move"))

hl.define_submap("scratchpad_move", "reset", function()
	for i = 1, 9 do
		local key = tostring(i)
		local name = tostring(i)
		hl.bind(key, function()
			hl.dispatch(hl.dsp.window.move({ workspace = "special:" .. name }))
			hl.dispatch(hl.dsp.submap("reset"))
		end)
	end
	-- 0 = workspace 10
	hl.bind("0", function()
		hl.dispatch(hl.dsp.window.move({ workspace = "special:10" }))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("escape", hl.dsp.submap("reset"))
end)
