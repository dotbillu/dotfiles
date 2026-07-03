pragma Singleton
import QtQuick

QtObject {

    // base
    readonly property color black: "#000000"
    readonly property color white: "#FFFFFF"

    // grayscale ramp – ultra dark
    readonly property color gray50: "#B8B8B8"
    readonly property color gray100: "#969696"
    readonly property color gray200: "#747474"
    readonly property color gray300: "#565656"
    readonly property color gray400: "#3E3E3E"
    readonly property color gray500: "#2A2A2A"
    readonly property color gray600: "#1A1A1A"
    readonly property color gray700: "#101010"
    readonly property color gray800: "#080808"
    readonly property color gray900: "#030303"

    // glass / alpha variants
    readonly property color glassLight: "#22FFFFFF"
    readonly property color glassMedium: "#18FFFFFF"
    readonly property color glassDark: "#99000000"

    // accents
    readonly property color accent: "#D4E0C8"
    readonly property color accentMuted: "#55D4E0C8"
    readonly property color accentStrong: "#CCD4E0C8"

    // semantic surfaces – near pure black
    readonly property color surface: "#0D0D0D"
    readonly property color surfaceAlt: "#080808"
    readonly property color surfaceContainer: "#040404"

    readonly property color border: "#25FFFFFF"
    readonly property color borderActive: accentStrong

    readonly property color textPrimary: "#F0F0F0"
    readonly property color textSecondary: "#A0A0A0"
    readonly property color textMuted: "#606060"

    readonly property color success: "#7FD48B"
    readonly property color warning: "#F2C14E"
    readonly property color error: "#E57373"

    // shadows
    readonly property color shadowLight: "#44000000"
    readonly property color shadowMedium: "#77000000"
    readonly property color shadowHeavy: "#CC000000"

    // overlays
    readonly property color overlayLight: "#10FFFFFF"
    readonly property color overlayDark: "#66000000"

    // utility
    readonly property color transparent: "transparent"
}
