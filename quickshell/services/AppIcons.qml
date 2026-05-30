pragma Singleton
import QtQuick

QtObject {
    id: root
    readonly property var iconMap: ({
            "foot": "org.codeberg.dnkl.foot",
            "kitty": "kitty",
            "kitty-dropterm": "kitty",
            "alacritty": "Alacritty",
            "wezterm": "org.wezfurlong.wezterm",

            "code-oss": "visual-studio-code",
            "vscodium": "vscodium",
            "code": "visual-studio-code",
            "neovide": "neovide",

            "brave-browser": "brave-desktop",
            "brave": "brave-desktop",
            "zen": "zen-browser",
            "zen-browser": "zen-browser",
            "firefox": "firefox",
            "chromium": "chromium",
            "google-chrome": "google-chrome",
            "chrome": "google-chrome",

            "spotify": "spotify",
            "vlc": "vlc",
            "mpv": "mpv",
            "rhythmbox": "rhythmbox",
            "elisa": "elisa",
            "obs": "com.obsproject.Studio",
            "obs-studio": "com.obsproject.Studio",

            "mongodb compass": "mongodb-compass",
            "mongodb-compass": "mongodb-compass",
            "obsidian": "obsidian",
            "discord": "discord",
            "vesktop": "discord",
            "telegram": "telegram",
            "thunar": "thunar",
            "nautilus": "org.gnome.Nautilus",
            "dolphin": "system-file-manager",
            "gimp": "gimp",
            "inkscape": "inkscape",
            "blender": "blender",
            "cursor": "co.anysphere.cursor"
        })

    // Returns the icon source URL for use in Image { source: ... }
    // Pass the lowercase app class or player identity string.
    function iconSource(appName) {
        if (!appName)
            return "";
        let key = appName.toLowerCase();
        
        if (key.includes("brave")) key = "brave";
        else if (key.includes("chromium")) key = "chromium";
        else if (key.includes("chrome")) key = "chrome";
        else if (key.includes("firefox")) key = "firefox";
        
        let mapped = iconMap[key] || key;
        return "image://icon/" + mapped;
    }
}
