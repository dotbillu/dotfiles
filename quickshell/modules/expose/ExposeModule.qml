import QtQuick
import Quickshell
import Quickshell.Io

import "../../theme"

Rectangle {
    id: root

    property var panelWindow: null
    property int barScreenX: 0

    implicitHeight: 40
    implicitWidth: 40
    radius: 20
    color: "transparent"

    Text {
        anchors.centerIn: parent
        text: "󱂬"
        font.pixelSize: 18
        color: rootHover.hovered ? Theme.colors.accent : Theme.colors.textSecondary
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    HoverHandler { id: rootHover }

    Process {
        id: exposeProcess
        command: ["bash", "-c", "hyprctl eval 'hl.plugin.hyprexpo.expo(\"toggle\")'"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: exposeProcess.running = true
    }
}
