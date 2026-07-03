import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

import "../../theme"
import "../../widgets"

Rectangle {
    id: root

    property var panelWindow: null
    property int barScreenX: 0

    property var adapter:     Bluetooth.defaultAdapter
    property bool btOn:       adapter?.enabled ?? false
    property var connectedDevices: {
        if (!adapter) return []
        let devs = adapter.devices.values
        return devs.filter(d => d.connected)
    }

    implicitWidth:  40
    implicitHeight: 40
    radius: 20
    color:  Theme.colors.surface

    // Bluetooth icon
    Text {
        anchors.centerIn: parent
        font.pixelSize: 15
        color: root.connectedDevices.length > 0 ? Theme.colors.accent : Theme.colors.textMuted
        text: {
            if (!root.btOn)                       return "󰂲"
            if (root.connectedDevices.length > 0) return "󰂱"
            return "󰂰"
        }
    }

    // Connected device dot
    Rectangle {
        anchors.top:         parent.top
        anchors.right:       parent.right
        anchors.topMargin:   10
        anchors.rightMargin: 10
        width: 6; height: 6; radius: 3
        color:   Theme.colors.accent
        visible: root.connectedDevices.length > 0
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: widget.visible ? widget.hide() : widget.show()
    }

    HoverHandler {
        id: barHover
        onHoveredChanged: {
            if (hovered) closeDelay.stop()
            else if (widget.visible && !widget.popupHovered) closeDelay.restart()
        }
    }

    Timer {
        id: closeDelay
        interval: 400
        onTriggered: if (!widget.popupHovered && !barHover.hovered) widget.hide()
    }

    BluetoothWidget {
        id: widget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40

        onPopupHoveredChanged: {
            if (popupHovered) closeDelay.stop()
            else if (widget.visible && !barHover.hovered) closeDelay.restart()
        }
    }
}
