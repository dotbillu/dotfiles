-- Super+S: toggle special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Super+Shift+S: move window to special workspace
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
