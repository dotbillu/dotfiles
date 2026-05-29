import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking

import "../../theme"
import "../../widgets"

Rectangle {
    id: root

    property var panelWindow: null
    property int barScreenX: 0

    // Find the first wifi device
    property var wifiDevice: {
        let devs = Networking.devices.values
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wifi) return devs[i]
        }
        return null
    }

    property bool wifiOn:      Networking.wifiEnabled
    property bool connected:   wifiDevice?.connected ?? false
    property var  activeNet:   {
        if (!wifiDevice) return null
        let nets = wifiDevice.networks.values
        for (let i = 0; i < nets.length; i++) {
            if (nets[i].connected) return nets[i]
        }
        return null
    }
    property real signalStr:   activeNet?.signalStrength ?? 0

    implicitWidth:  40
    implicitHeight: 40
    radius: 20
    color:  Theme.colors.surface

    // Wi-Fi icon
    Text {
        anchors.centerIn: parent
        font.pixelSize: 15
        color: root.connected ? Theme.colors.accent : Theme.colors.textMuted
        text: {
            if (!root.wifiOn) return "󰖪"
            let s = root.signalStr
            if (s > 0.75) return "󰤨"
            if (s > 0.5)  return "󰤥"
            if (s > 0.25) return "󰤢"
            if (s > 0)    return "󰤟"
            return "󰤭"
        }
    }

    // Disconnected dot
    Rectangle {
        anchors.top:         parent.top
        anchors.right:       parent.right
        anchors.topMargin:   10
        anchors.rightMargin: 10
        width: 6; height: 6; radius: 3
        color:   Theme.colors.error
        visible: root.wifiOn && !root.connected
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

    WifiWidget {
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
