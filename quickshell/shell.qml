import QtQuick
import Quickshell
import "modules/workspace"

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 38

            color: "transparent"
            Rectangle {
                color: "transparent"
                anchors.fill: parent
                topLeftRadius: 20
                topRightRadius: 2

                Workspace {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                }
            }
        }
    }
}
