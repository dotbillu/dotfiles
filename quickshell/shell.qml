import QtQuick
import Quickshell

import "modules/workspace"
import "modules/clock"
import "modules/media"
import "modules/systemcontrols"
import "modules/notifications"
import "modules/battery"

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData

            screen: modelData

            anchors {
                top:   true
                left:  true
                right: true
            }

            implicitHeight: 38

            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: "transparent"

                // Far left: Arch Launcher
                Row {
                    id: leftControls
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    ArchLauncher {
                        panelWindow: bar
                    }
                }

                // Center modules
                Row {
                    id: barRow
                    anchors.centerIn: parent
                    spacing: 10

                    Media {
                        id: mediaBar
                        panelWindow: bar
                        barScreenX: barRow.x
                    }

                    Workspace {}

                    Clock {
                        id: clockItem
                        panelWindow: bar
                        barScreenX: barRow.x + clockItem.x
                    }
                }

                // Right-side island + notifications
                Row {
                    id: rightControls
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    SystemControls {
                        panelWindow: bar
                        barScreenX:  rightControls.x
                    }

                    Battery {
                        panelWindow: bar
                        barScreenX: rightControls.x
                    }

                    Notifications {}
                }
            }
        }
    }
}
