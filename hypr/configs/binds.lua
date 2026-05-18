hl.config({
	binds = {
		drag_threshold = 10,
	},
})

local terminal = "kitty"
local fileManager = "nemo"
local mainMod = "SUPER"
local HYPRSHOT_DIR = "~/Pictures/Screenshots"
local menu = "tofi-drun --drun-launch=true"

hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("prime-run kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

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

-- Moving Windows to Workspaces
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

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + M", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "e-0" }))

-- Mouse Scroll Wheel Workspace Toggling
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse Left/Right Click Window Controls
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Keyboard Arrow Resizing
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

-- Session Lifecycle
hl.bind("CTRL + ALT + backspace", hl.dsp.exit())

-- System Audio Keybinds
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Display Brightness Keybinds
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"))

-- Media Daemon Control Keybinds
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("ALT + SHIFT + P", hl.dsp.exec_cmd("playerctl play-pause"))

-- Screen Capture Keybinds (Hyprshot)
hl.bind("CTRL + ALT + O", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 -c -o " .. HYPRSHOT_DIR))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -zm output -m eDP-1 -c -o " .. HYPRSHOT_DIR))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd("hyprshot -zm window -c -o " .. HYPRSHOT_DIR))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprshot -zm region -c -o " .. HYPRSHOT_DIR))

-- Custom Optimization/Maintenance Utilities
hl.bind("CTRL + ALT + K", hl.dsp.exec_cmd("~/.config/hypr/scripts/lastScreenShot.sh"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("~/.config/hypr/scripts/sunsetToggle.sh"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("pkill -SIGUSR1 wayscriber"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprpaneltoggle.sh"))
hl.bind("CTRL + SUPER + backspace", hl.dsp.exec_cmd("systemctl poweroff"))
