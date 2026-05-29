import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../theme"
import "../../widgets"

PopupWindow {
    id: popup

    property bool popupHovered: false
    readonly property int widgetWidth: 320

    width: widgetWidth
    height: card.implicitHeight
    visible: false
    color: "transparent"

    function show() {
        visible = true; card.opacity = 0; card.scale = 0.97; entryAnim.start()
        updateTimer.restart()
    }
    function hide() { exitAnim.start(); updateTimer.stop() }

    ParallelAnimation {
        id: entryAnim
        NumberAnimation { target: card; property: "opacity"; to: 1;   duration: 180; easing.type: Easing.OutCubic }
        NumberAnimation { target: card; property: "scale";   to: 1.0; duration: 180; easing.type: Easing.OutCubic }
    }
    SequentialAnimation {
        id: exitAnim
        ParallelAnimation {
            NumberAnimation { target: card; property: "opacity"; to: 0;    duration: 130; easing.type: Easing.InCubic }
            NumberAnimation { target: card; property: "scale";   to: 0.97; duration: 130; easing.type: Easing.InCubic }
        }
        ScriptAction { script: popup.visible = false }
    }

    HoverHandler { onHoveredChanged: popup.popupHovered = hovered }

    // Properties for UI
    property real intBright: 1.0
    property real extBright: 0.5
    property bool extSupported: true

    property bool sunsetEnabled: false
    property real sunsetTemp: 4500 // Min 2000, Max 8000

    // Fetch initial brightness values
    Process {
        id: fetchProc
        command: ["bash", "-c", "echo $(brightnessctl -m | awk -F, '{print $4}' | sed 's/%//'); ddcutil --display 1 getvcp 10 --terse 2>/dev/null | awk '{print $4}' || echo 'none'; pgrep hyprsunset > /dev/null && echo 'yes' || echo 'no'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                if (lines[0]) popup.intBright = parseInt(lines[0]) / 100.0
                if (lines[1]) {
                    let v = lines[1].trim()
                    if (v === "none" || v === "") {
                        popup.extSupported = false
                    } else {
                        popup.extSupported = true
                        popup.extBright = parseInt(v) / 100.0
                    }
                }
                if (lines[2]) popup.sunsetEnabled = (lines[2].trim() === "yes")
            }
        }
    }

    Timer {
        id: updateTimer
        interval: 10000; repeat: true; running: false
        onTriggered: if (!fetchProc.running) fetchProc.running = true
    }

    Component.onCompleted: fetchProc.running = true

    // Executors
    Process { id: intExec }
    Process { id: extExec }
    Process { id: sunsetExec }

    function setIntBright(pct) {
        popup.intBright = pct
        let val = Math.round(pct * 100)
        intExec.command = ["bash", "-c", "brightnessctl s " + val + "%"]
        if (!intExec.running) intExec.running = true
    }

    function setExtBright(pct) {
        popup.extBright = pct
        let val = Math.round(pct * 100)
        extExec.command = ["bash", "-c", "ddcutil --display 1 setvcp 10 " + val]
        if (!extExec.running) extExec.running = true
    }

    function toggleSunset() {
        popup.sunsetEnabled = !popup.sunsetEnabled
        applySunset()
    }

    function setSunsetTemp(t) {
        popup.sunsetTemp = t
        if (popup.sunsetEnabled) applySunset()
    }

    function applySunset() {
        if (popup.sunsetEnabled) {
            let t = Math.round(popup.sunsetTemp)
            sunsetExec.command = ["bash", "-c", "killall hyprsunset; hyprsunset -t " + t + " &"]
        } else {
            sunsetExec.command = ["bash", "-c", "killall hyprsunset"]
        }
        if (!sunsetExec.running) sunsetExec.running = true
    }

    Rectangle {
        id: card
        width: parent.width; implicitHeight: col.implicitHeight + 28
        radius: 16; color: Theme.colors.surfaceContainer
        border.color: Theme.colors.border; border.width: 1
        transformOrigin: Item.TopRight

        ColumnLayout {
            id: col
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors.margins: 14
            spacing: 14

            Text { text: "Display & Color"; color: Theme.colors.textPrimary; font.pixelSize: 13; font.bold: true }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.colors.border }

            // Internal Display
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text { text: "Internal Display"; color: Theme.colors.textMuted; font.pixelSize: 10; font.bold: true }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "󰃠"; font.pixelSize: 16; color: Theme.colors.accent }
                    SliderControl {
                        Layout.fillWidth: true
                        value: popup.intBright
                        accentColor: Theme.colors.accent
                        onValueSet: (v) => popup.setIntBright(v)
                    }
                    Text { text: Math.round(popup.intBright * 100) + "%"; color: Theme.colors.textMuted; font.pixelSize: 11; Layout.preferredWidth: 32; horizontalAlignment: Text.AlignRight }
                }
            }

            // External Display
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                visible: popup.extSupported
                Text { text: "External Display"; color: Theme.colors.textMuted; font.pixelSize: 10; font.bold: true }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "󰍹"; font.pixelSize: 16; color: "#B4BEFE" }
                    SliderControl {
                        Layout.fillWidth: true
                        value: popup.extBright
                        accentColor: "#B4BEFE"
                        onValueSet: (v) => popup.setExtBright(v)
                    }
                    Text { text: Math.round(popup.extBright * 100) + "%"; color: Theme.colors.textMuted; font.pixelSize: 11; Layout.preferredWidth: 32; horizontalAlignment: Text.AlignRight }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.colors.border }

            // Hyprsunset
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "Blue Light Filter"; color: Theme.colors.textMuted; font.pixelSize: 10; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        width: 32; height: 18; radius: 9
                        color: popup.sunsetEnabled ? Theme.colors.accentStrong : Theme.colors.surface
                        border.color: popup.sunsetEnabled ? "transparent" : Theme.colors.border; border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }
                        
                        Rectangle {
                            width: 14; height: 14; radius: 7
                            anchors.verticalCenter: parent.verticalCenter
                            x: popup.sunsetEnabled ? parent.width - width - 2 : 2
                            color: popup.sunsetEnabled ? Theme.colors.surfaceContainer : Theme.colors.textSecondary
                            Behavior on x { SmoothedAnimation { velocity: 150 } }
                        }
                        
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: popup.toggleSunset()
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    opacity: popup.sunsetEnabled ? 1.0 : 0.4
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    Text { text: "󰃠"; font.pixelSize: 16; color: "#F9E2AF" }
                    SliderControl {
                        Layout.fillWidth: true
                        // Map temp 2000-8000 to 0.0-1.0
                        value: (popup.sunsetTemp - 2000) / 6000
                        accentColor: "#F9E2AF"
                        onValueSet: (v) => {
                            let temp = 2000 + v * 6000
                            popup.setSunsetTemp(temp)
                        }
                    }
                    Text { text: Math.round(popup.sunsetTemp) + "K"; color: Theme.colors.textMuted; font.pixelSize: 11; Layout.preferredWidth: 36; horizontalAlignment: Text.AlignRight }
                }
            }
        }
    }

    // Reusable slider component
    component SliderControl: Item {
        property real value: 0.0
        property color accentColor: Theme.colors.accent
        signal valueSet(real v)

        height: 20

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width; height: 4; radius: 2
            color: Theme.colors.overlayLight

            Rectangle {
                width: parent.width * parent.parent.value
                height: parent.height; radius: parent.radius
                color: parent.parent.accentColor
            }
        }

        // Thumb
        Rectangle {
            x: Math.max(0, Math.min(parent.width * parent.value - width / 2, parent.width - width))
            anchors.verticalCenter: parent.verticalCenter
            width: 12; height: 12; radius: 6
            color: Theme.colors.textPrimary
        }

        MouseArea {
            anchors.fill: parent; cursorShape: Qt.SizeHorCursor
            onPositionChanged: (mouse) => {
                if (pressed) {
                    let pct = Math.max(0, Math.min(mouse.x / width, 1.0))
                    parent.valueSet(pct)
                }
            }
            onPressed: (mouse) => {
                let pct = Math.max(0, Math.min(mouse.x / width, 1.0))
                parent.valueSet(pct)
            }
        }
    }
}
