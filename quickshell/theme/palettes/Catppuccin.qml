pragma Singleton
import QtQuick

QtObject {

    // base
    readonly property color black: "#11111B" // crust
    readonly property color white: "#CDD6F4" // text

    // grayscale ramp
    readonly property color gray50: "#CDD6F4"   // text
    readonly property color gray100: "#BAC2DE"  // subtext1
    readonly property color gray200: "#A6ADC8"  // subtext0
    readonly property color gray300: "#9399B2"  // overlay2
    readonly property color gray400: "#7F849C"  // overlay1
    readonly property color gray500: "#6C7086"  // overlay0
    readonly property color gray600: "#585B70"  // surface2
    readonly property color gray700: "#45475A"  // surface1
    readonly property color gray800: "#313244"  // surface0
    readonly property color gray900: "#1E1E2E"  // base

    // glass / alpha variants
    readonly property color glassLight: "#33CDD6F4"
    readonly property color glassMedium: "#22CDD6F4"
    readonly property color glassDark: "#8811111B"

    // accents (lavender)
    readonly property color accent: "#B4BEFE"
    readonly property color accentMuted: "#66B4BEFE"
    readonly property color accentStrong: "#AAB4BEFE"

    // semantic surfaces
    readonly property color surface: "#1E1E2E"          // base
    readonly property color surfaceAlt: "#181825"       // mantle
    readonly property color surfaceContainer: "#11111B" // crust

    readonly property color border: "#30BAC2DE"
    readonly property color borderActive: accentStrong

    readonly property color textPrimary: "#CDD6F4"
    readonly property color textSecondary: "#A6ADC8"
    readonly property color textMuted: "#6C7086"

    readonly property color success: "#A6E3A1" // green
    readonly property color warning: "#F9E2AF" // yellow
    readonly property color error: "#F38BA8"   // red

    // shadows
    readonly property color shadowLight: "#33000000"
    readonly property color shadowMedium: "#66000000"
    readonly property color shadowHeavy: "#AA000000"

    // overlays
    readonly property color overlayLight: "#15CDD6F4"
    readonly property color overlayDark: "#5511111B"

    // utility
    readonly property color transparent: "transparent"
}
