import QtQuick
import Quickshell

import "modules/workspace"
import "modules/clock"
import "modules/media"

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

                Row {
                    id: barRow
                    anchors.centerIn: parent
                    spacing: 10

                    Media {
                        id: mediaBar
                        panelWindow: bar
                        // x of Media within the PanelWindow = left edge of the centred Row
                        // Row.x is set by anchors.centerIn, so it's (bar.width - barRow.width) / 2
                        barScreenX: barRow.x
                    }

                    Workspace {}

                    Clock {}
                }
            }
        }
    }
}
