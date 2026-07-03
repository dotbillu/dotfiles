import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../theme"

Rectangle {
    id: root

    property var panelWindow: null
    property int barScreenX: 0

    implicitHeight: 40
    implicitWidth: row.implicitWidth + 24
    radius: 20
    color: Theme.colors.surface

    property int capacity: 100
    property string status: "Full"
    property bool isPluggedIn: false
    property bool widgetOpen: false

    Process {
        id: batProc
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100; cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Full; cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n1 || echo 0"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                if (lines.length >= 2) {
                    root.capacity = parseInt(lines[0].trim()) || 0
                    root.status = lines[1].trim()
                }
                if (lines.length >= 3) {
                    root.isPluggedIn = (lines[2].trim() === "1")
                }
            }
        }
    }

    Timer {
        interval: 15000 // every 15 seconds
        running: true
        repeat: true
        onTriggered: {
            if (!batProc.running) batProc.running = true
        }
    }

    Component.onCompleted: batProc.running = true

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            font.pixelSize: 15
            color: (root.isPluggedIn || root.status.toLowerCase().includes("charg")) ? Theme.colors.accentStrong : (root.capacity <= 20 ? Theme.colors.error : Theme.colors.textPrimary)
            text: {
                if (root.isPluggedIn || root.status.toLowerCase().includes("charg")) return "󰂄"
                if (root.capacity > 90) return "󰁹"
                if (root.capacity > 80) return "󰂂"
                if (root.capacity > 70) return "󰂁"
                if (root.capacity > 60) return "󰂀"
                if (root.capacity > 50) return "󰁿"
                if (root.capacity > 40) return "󰁾"
                if (root.capacity > 30) return "󰁽"
                if (root.capacity > 20) return "󰁼"
                if (root.capacity > 10) return "󰁻"
                return "󰂎"
            }
        }
    }

    HoverHandler {
        id: rootHover
        onHoveredChanged: {
            if (hovered) closeDelay.stop()
            else if (root.widgetOpen && !batteryWidget.popupHovered) closeDelay.restart()
        }
    }

    Timer {
        id: closeDelay
        interval: 400
        onTriggered: {
            if (!rootHover.hovered && !batteryWidget.popupHovered) {
                root.widgetOpen = false
                batteryWidget.hide()
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.widgetOpen) {
                root.widgetOpen = false
                batteryWidget.hide()
            } else {
                root.widgetOpen = true
                batteryWidget.show()
            }
        }
    }

    BatteryWidget {
        id: batteryWidget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40
        onPopupHoveredChanged: {
            if (popupHovered) closeDelay.stop()
            else if (!rootHover.hovered) closeDelay.restart()
        }
    }
}
