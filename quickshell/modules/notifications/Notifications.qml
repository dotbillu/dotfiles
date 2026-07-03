import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../theme"

Rectangle {
    id: root

    property int unreadCount: 0

    implicitWidth: 40
    implicitHeight: 40
    radius: 20
    color: Theme.colors.surface

    Text {
        anchors.centerIn: parent
        text: root.unreadCount > 0 ? "󰂞" : "󰂚"
        color: Theme.colors.textPrimary
        font.pixelSize: 16
    }

    // Unread dot indicator
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 10
        width: 6
        height: 6
        radius: 3
        color: Theme.colors.accent
        visible: root.unreadCount > 0
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!toggleProc.running) {
                toggleProc.running = true
            }
        }
    }

    Process {
        id: toggleProc
        command: ["swaync-client", "-t"]
    }

    Process {
        id: countProc
        command: ["swaync-client", "-c"]
        stdout: StdioCollector {
            onStreamFinished: {
                let cnt = parseInt(this.text.trim())
                if (!isNaN(cnt)) {
                    root.unreadCount = cnt
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (!countProc.running) {
                countProc.running = true
            }
        }
    }
}
