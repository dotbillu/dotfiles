import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../theme"
import "../../widgets"

Rectangle {
    id: root

    property var panelWindow: null

    implicitWidth: 40
    implicitHeight: 40
    radius: 20
    color: Theme.colors.surface

    Text {
        anchors.centerIn: parent
        text: "󰣇"
        color: Theme.colors.accent
        font.pixelSize: 18
    }

    // Which widget is open (only one at a time)
    property bool statsOpen: false

    function toggleStats() {
        if (statsOpen) {
            statsOpen = false
            statsWidget.hide()
        } else {
            statsOpen = true
            statsWidget.show()
        }
    }

    // Hover / close logic
    HoverHandler {
        id: launcherHover
        onHoveredChanged: {
            if (hovered) closeDelay.stop()
            else if (root.statsOpen && !statsWidget.popupHovered) closeDelay.restart()
        }
    }

    Timer {
        id: closeDelay
        interval: 1200
        onTriggered: {
            if (!launcherHover.hovered && !statsWidget.popupHovered) {
                root.statsOpen = false
                statsWidget.hide()
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggleStats()
    }

    StatsWidget {
        id: statsWidget
        anchor.window: root.panelWindow
        anchor.rect.x: 8
        anchor.rect.y: 44
        onPopupHoveredChanged: {
            if (popupHovered) closeDelay.stop()
            else if (!launcherHover.hovered) closeDelay.restart()
        }
    }
}
