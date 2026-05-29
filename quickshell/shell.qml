import QtQuick
import Quickshell

import "modules/workspace"
import "modules/clock"
import "modules/media"
import "modules/systemcontrols"
import "modules/notifications"

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

                    Clock {}
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

                    Notifications {}
                }
            }
        }
    }
}
