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
    implicitWidth: 40
    radius: 20
    color: "transparent"

    property bool widgetOpen: false

    Text {
        anchors.centerIn: parent
        text: "󰅍"
        font.pixelSize: 18
        color: rootHover.hovered || widgetOpen ? Theme.colors.accent : Theme.colors.textSecondary
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    HoverHandler {
        id: rootHover
        onHoveredChanged: {
            if (hovered) closeDelay.stop()
            else if (root.widgetOpen && !clipboardWidget.popupHovered) closeDelay.restart()
        }
    }

    Timer {
        id: closeDelay
        interval: 400
        onTriggered: {
            if (!rootHover.hovered && !clipboardWidget.popupHovered) {
                root.widgetOpen = false
                clipboardWidget.hide()
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.widgetOpen) {
                root.widgetOpen = false
                clipboardWidget.hide()
            } else {
                root.widgetOpen = true
                clipboardWidget.show()
            }
        }
    }

    ClipboardWidget {
        id: clipboardWidget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40
        onPopupHoveredChanged: {
            if (popupHovered) closeDelay.stop()
            else if (!rootHover.hovered) closeDelay.restart()
        }
    }
}
