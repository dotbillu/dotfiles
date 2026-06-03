pragma Singleton
import QtQuick

QtObject {

    // base
    readonly property color black: "#000000"
    readonly property color white: "#FFFFFF"

    // grayscale ramp – shifted much darker
    readonly property color gray50: "#D0D0D0"
    readonly property color gray100: "#B0B0B0"
    readonly property color gray200: "#8A8A8A"
    readonly property color gray300: "#6E6E6E"
    readonly property color gray400: "#525252"
    readonly property color gray500: "#3A3A3A"
    readonly property color gray600: "#282828"
    readonly property color gray700: "#1C1C1C"
    readonly property color gray800: "#121212"
    readonly property color gray900: "#0A0A0A"

    // glass / alpha variants
    readonly property color glassLight: "#33FFFFFF"
    readonly property color glassMedium: "#22FFFFFF"
    readonly property color glassDark: "#88000000"

    // accents – same sage green, slightly boosted for contrast on darker bg
    readonly property color accent: "#D4E0C8"
    readonly property color accentMuted: "#66D4E0C8"
    readonly property color accentStrong: "#AAD4E0C8"

    // semantic surfaces – deep blacks
    readonly property color surface: "#1A1A1A"
    readonly property color surfaceAlt: "#141414"
    readonly property color surfaceContainer: "#0E0E0E"

    readonly property color border: "#30FFFFFF"
    readonly property color borderActive: accentStrong

    readonly property color textPrimary: "#E8E8E8"
    readonly property color textSecondary: "#9E9E9E"
    readonly property color textMuted: "#5A5A5A"

    readonly property color success: "#7FD48B"
    readonly property color warning: "#F2C14E"
    readonly property color error: "#E57373"

    // shadows – heavier for deep dark
    readonly property color shadowLight: "#33000000"
    readonly property color shadowMedium: "#66000000"
    readonly property color shadowHeavy: "#AA000000"

    // overlays
    readonly property color overlayLight: "#15FFFFFF"
    readonly property color overlayDark: "#55000000"

    // utility
    readonly property color transparent: "transparent"
}
