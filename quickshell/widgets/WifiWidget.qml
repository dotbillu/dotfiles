import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking

import "../theme"

PopupWindow {
    id: popup

    property bool popupHovered: false
    readonly property int widgetWidth: 290

    width:   widgetWidth
    height:  card.implicitHeight
    visible: false
    color:   "transparent"

    function show() { visible = true; card.opacity = 0; card.scale = 0.97; entryAnim.start() }
    function hide() { exitAnim.start() }

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

    property var wifiDevice: {
        let devs = Networking.devices.values
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wifi) return devs[i]
        }
        return null
    }

    // Enable scanning when widget is visible
    Binding {
        target:  popup.wifiDevice
        property: "scannerEnabled"
        value:   popup.visible
        when:    popup.wifiDevice !== null
    }

    Rectangle {
        id: card
        width:          popup.width
        implicitHeight: col.implicitHeight + 20
        transformOrigin: Item.Top
        opacity: 0
        radius:  16
        color:   Theme.colors.surface
        border.color: Theme.colors.border
        border.width: 1

        ColumnLayout {
            id: col
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors.topMargin: 12; anchors.leftMargin: 14; anchors.rightMargin: 14
            spacing: 8

            // ── Header ────────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "󰖩  Wi-Fi"
                    color: Theme.colors.textPrimary
                    font.pixelSize: 13; font.bold: true
                }
                Item { Layout.fillWidth: true }

                // Refresh button
                Rectangle {
                    width: 26; height: 26; radius: 13
                    color: refreshHover.containsMouse ? Theme.colors.overlayLight : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }
                    Text {
                        anchors.centerIn: parent
                        text: "󰑐"; font.pixelSize: 13
                        color: Theme.colors.textSecondary

                        RotationAnimation on rotation {
                            id: spinAnim
                            running: false
                            from: 0; to: 360; duration: 700
                            easing.type: Easing.InOutCubic
                        }
                    }
                    MouseArea {
                        id: refreshHover
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        onClicked: {
                            spinAnim.start()
                            if (popup.wifiDevice) {
                                popup.wifiDevice.scannerEnabled = false
                                popup.wifiDevice.scannerEnabled = true
                            }
                        }
                    }
                }

                // Toggle switch
                Rectangle {
                    width: 38; height: 22; radius: 11
                    color: Networking.wifiEnabled ? Theme.colors.accent : Theme.colors.overlayLight
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Rectangle {
                        width: 16; height: 16; radius: 8
                        color: Theme.colors.textPrimary
                        anchors.verticalCenter: parent.verticalCenter
                        x: Networking.wifiEnabled ? parent.width - width - 3 : 3
                        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                    }
                }
            }

            // ── Connected network highlight ────────────────────────────
            Repeater {
                model: {
                    if (!popup.wifiDevice || !Networking.wifiEnabled) return []
                    return popup.wifiDevice.networks.values.filter(n => n.connected)
                }
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: connRow.implicitHeight + 12
                    radius: 10
                    color:  Theme.colors.overlayLight

                    RowLayout {
                        id: connRow
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                        anchors.leftMargin: 10; anchors.rightMargin: 10
                        spacing: 8

                        Text { text: "󰤨"; color: Theme.colors.accent; font.pixelSize: 16 }
                        ColumnLayout {
                            spacing: 1
                            Text { text: modelData.name; color: Theme.colors.textPrimary; font.pixelSize: 12; font.bold: true }
                            Text { text: "Connected"; color: Theme.colors.accent; font.pixelSize: 10 }
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: Math.round(modelData.signalStrength * 100) + "%"
                            color: Theme.colors.textMuted; font.pixelSize: 10
                        }
                    }
                }
            }

            // ── Section label ──────────────────────────────────────────
            Text {
                text: "Available Networks"
                color: Theme.colors.textMuted
                font.pixelSize: 10; font.bold: true
                visible: Networking.wifiEnabled
                topPadding: 2
            }

            // ── Network list ───────────────────────────────────────────
            Repeater {
                model: {
                    if (!popup.wifiDevice || !Networking.wifiEnabled) return []
                    let nets = popup.wifiDevice.networks.values
                    return nets.slice().sort((a, b) => b.signalStrength - a.signalStrength).slice(0, 7)
                }
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: netRow.implicitHeight + 10
                    radius: 8
                    color: modelData.connected ? Theme.colors.overlayLight
                         : netArea.containsMouse ? "#11FFFFFF" : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    RowLayout {
                        id: netRow
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                        anchors.leftMargin: 8; anchors.rightMargin: 8
                        spacing: 8

                        Text {
                            font.pixelSize: 13
                            color: modelData.connected ? Theme.colors.accent : Theme.colors.textSecondary
                            text: {
                                let s = modelData.signalStrength
                                if (s > 0.75) return "󰤨"; if (s > 0.5) return "󰤥"
                                if (s > 0.25) return "󰤢"; return "󰤟"
                            }
                        }
                        Text {
                            Layout.fillWidth: true
                            text:  modelData.name
                            color: modelData.connected ? Theme.colors.textPrimary : Theme.colors.textSecondary
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                        Text {
                            text: "󰌾"; color: Theme.colors.textMuted; font.pixelSize: 10
                            visible: modelData.security !== WifiSecurityType.None
                        }
                    }
                    MouseArea {
                        id: netArea
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        enabled: !modelData.connected
                        onClicked: modelData.connectWithPsk("")
                    }
                }
            }

            // ── Empty state ────────────────────────────────────────────
            Text {
                Layout.fillWidth: true
                text: !Networking.wifiEnabled ? "Wi-Fi is off" : "No networks found"
                color: Theme.colors.textMuted; font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                visible: !Networking.wifiEnabled ||
                         (popup.wifiDevice?.networks?.values?.length ?? 0) === 0
                topPadding: 4; bottomPadding: 4
            }

            Item { height: 2 }
        }
    }
}
