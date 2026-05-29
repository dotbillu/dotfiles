pragma Singleton
import QtQuick

// Global icon name resolver — maps app class/identity names to icon theme names.
// Used by both Workspace and Stats so the mapping stays in one place.
QtObject {
    id: root

    // Map from lowercase app class (Hyprland) or identity (MPRIS) to icon name.
    // Add entries here whenever a new app needs a custom mapping.
    readonly property var iconMap: ({
        // terminals
        "foot":              "org.codeberg.dnkl.foot",
        "kitty":             "kitty",
        "kitty-dropterm":    "kitty",
        "alacritty":         "Alacritty",
        "wezterm":           "org.wezfurlong.wezterm",

        // editors / IDEs
        "code-oss":          "visual-studio-code",
        "vscodium":          "vscodium",
        "code":              "visual-studio-code",
        "neovide":           "neovide",

        // browsers
        "brave-browser":     "brave-desktop",
        "brave":             "brave-desktop",
        "zen":               "zen-browser",
        "zen-browser":       "zen-browser",
        "firefox":           "firefox",
        "chromium":          "chromium",
        "google-chrome":     "google-chrome",

        // media
        "spotify":           "spotify",
        "vlc":               "vlc",
        "mpv":               "mpv",
        "rhythmbox":         "rhythmbox",
        "elisa":             "elisa",

        // tools
        "mongodb compass":   "mongodb-compass",
        "mongodb-compass":   "mongodb-compass",
        "obsidian":          "obsidian",
        "discord":           "discord",
        "vesktop":           "discord",
        "telegram":          "telegram",
        "thunar":            "thunar",
        "nautilus":          "org.gnome.Nautilus",
        "dolphin":           "system-file-manager",
        "gimp":              "gimp",
        "inkscape":          "inkscape",
        "blender":           "blender",
    })

    // Returns the icon source URL for use in Image { source: ... }
    // Pass the lowercase app class or player identity string.
    function iconSource(appName) {
        if (!appName) return ""
        let key = appName.toLowerCase()
        let mapped = iconMap[key] || key
        return "image://icon/" + mapped
    }
}
