pragma Singleton
import QtQuick

QtObject {

    // base
    readonly property color black: "#000000"
    readonly property color white: "#FFFFFF"

    // grayscale ramp
    readonly property color gray50: "#F5F5F5"
    readonly property color gray100: "#EAEAEA"
    readonly property color gray200: "#D5D5D5"
    readonly property color gray300: "#BDBDBD"
    readonly property color gray400: "#9E9E9E"
    readonly property color gray500: "#7A7A7A"
    readonly property color gray600: "#575757"
    readonly property color gray700: "#404040"
    readonly property color gray800: "#2B2B2B"
    readonly property color gray900: "#171717"

    // glass / alpha variants
    readonly property color glassLight: "#66FFFFFF"
    readonly property color glassMedium: "#44FFFFFF"
    readonly property color glassDark: "#66000000"

    // accents
    readonly property color accent: "#D4E0C8"
    readonly property color accentMuted: "#88D4E0C8"
    readonly property color accentStrong: "#BFD4E0C8"

    // semantic
    readonly property color surface: gray600
    readonly property color surfaceAlt: gray700
    readonly property color surfaceContainer: gray800

    readonly property color border: "#50FFFFFF"
    readonly property color borderActive: accentStrong

    readonly property color textPrimary: white
    readonly property color textSecondary: gray300
    readonly property color textMuted: gray500

    readonly property color success: "#7FD48B"
    readonly property color warning: "#F2C14E"
    readonly property color error: "#E57373"

    // shadows
    readonly property color shadowLight: "#22000000"
    readonly property color shadowMedium: "#44000000"
    readonly property color shadowHeavy: "#88000000"

    // overlays
    readonly property color overlayLight: "#22FFFFFF"
    readonly property color overlayDark: "#44000000"

    // utility
    readonly property color transparent: "transparent"
}
