-- Super+S: toggle special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Super+Shift+S: move window to special workspace
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pypr toggle mongodb-compass"))


