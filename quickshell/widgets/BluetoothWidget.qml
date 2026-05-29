import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

import "../theme"

PopupWindow {
    id: popup

    property bool popupHovered: false
    readonly property int widgetWidth: 270

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

    property var  adapter: Bluetooth.defaultAdapter
    property bool btOn:    adapter?.enabled ?? false

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
                    text: "󰂯  Bluetooth"
                    color: Theme.colors.textPrimary
                    font.pixelSize: 13; font.bold: true
                }
                Item { Layout.fillWidth: true }

                // Refresh / scan button
                Rectangle {
                    width: 26; height: 26; radius: 13
                    color: scanHover.containsMouse ? Theme.colors.overlayLight : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }
                    visible: popup.btOn

                    Text {
                        anchors.centerIn: parent
                        text: "󰑐"; font.pixelSize: 13
                        color: Theme.colors.textSecondary
                        RotationAnimation on rotation {
                            id: btSpinAnim; running: false
                            from: 0; to: 360; duration: 700; easing.type: Easing.InOutCubic
                        }
                    }
                    MouseArea {
                        id: scanHover
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        onClicked: {
                            btSpinAnim.start()
                            if (popup.adapter) {
                                popup.adapter.discovering = false
                                popup.adapter.discovering = true
                            }
                        }
                    }
                }

                // Toggle switch
                Rectangle {
                    width: 38; height: 22; radius: 11
                    color: popup.btOn ? Theme.colors.accent : Theme.colors.overlayLight
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Rectangle {
                        width: 16; height: 16; radius: 8; color: Theme.colors.textPrimary
                        anchors.verticalCenter: parent.verticalCenter
                        x: popup.btOn ? parent.width - width - 3 : 3
                        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: if (popup.adapter) popup.adapter.enabled = !popup.adapter.enabled
                    }
                }
            }

            // ── Device list ───────────────────────────────────────────
            Text {
                text: "Paired Devices"
                color: Theme.colors.textMuted; font.pixelSize: 10; font.bold: true
                visible: popup.btOn && (popup.adapter?.devices?.values?.length ?? 0) > 0
                topPadding: 2
            }

            Repeater {
                model: popup.btOn ? (popup.adapter?.devices?.values ?? []) : []
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: devRow.implicitHeight + 10
                    radius: 8
                    color: modelData.connected ? Theme.colors.overlayLight : "transparent"

                    RowLayout {
                        id: devRow
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                        anchors.leftMargin: 8; anchors.rightMargin: 8
                        spacing: 8

                        Text {
                            font.pixelSize: 16
                            color: modelData.connected ? Theme.colors.accent : Theme.colors.textMuted
                            text: {
                                let n = (modelData.name || "").toLowerCase()
                                if (n.includes("headphone") || n.includes("earphone") || n.includes("buds") || n.includes("airpod")) return "󰋋"
                                if (n.includes("keyboard")) return "󰌌"
                                if (n.includes("mouse"))    return "󰍽"
                                if (n.includes("speaker") || n.includes("sound")) return "󰓃"
                                if (n.includes("phone"))    return "󰄜"
                                if (n.includes("watch"))    return "󰑓"
                                return "󰂱"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 1
                            Text {
                                Layout.fillWidth: true
                                text: modelData.name || "Unknown Device"
                                color: Theme.colors.textPrimary
                                font.pixelSize: 12; font.bold: true
                                elide: Text.ElideRight
                            }
                            Text {
                                text: modelData.connected ? "Connected" : "Paired"
                                color: modelData.connected ? Theme.colors.accent : Theme.colors.textMuted
                                font.pixelSize: 10
                            }
                        }

                        // Connect / Disconnect
                        Rectangle {
                            implicitWidth:  btnLabel.implicitWidth + 12; implicitHeight: 22; radius: 11
                            color: btnHover.containsMouse
                                   ? (modelData.connected ? Theme.colors.error : Theme.colors.accent)
                                   : Theme.colors.overlayLight
                            Behavior on color { ColorAnimation { duration: 100 } }
                            Text {
                                id: btnLabel; anchors.centerIn: parent
                                text: modelData.connected ? "Disconnect" : "Connect"
                                color: Theme.colors.textPrimary; font.pixelSize: 10
                            }
                            MouseArea {
                                id: btnHover; anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                                onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
                            }
                        }
                    }
                }
            }

            // ── Empty / off state ─────────────────────────────────────
            Text {
                Layout.fillWidth: true
                text: !popup.btOn ? "Bluetooth is off" : "No paired devices"
                color: Theme.colors.textMuted; font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                visible: !popup.btOn || (popup.adapter?.devices?.values?.length ?? 0) === 0
                topPadding: 4; bottomPadding: 4
            }

            Item { height: 2 }
        }
    }
}
