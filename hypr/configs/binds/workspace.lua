local mainMod = "SUPER"

hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })

-- HDMI-A-1 Workspaces
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + w", hl.dsp.focus({ workspace = 20 }))

-- Move Active Window to Workspace
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = true }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = true }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = true }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = true }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = true }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = true }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = true }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = true }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = true }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = true }))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = 20, follow = true }))
