import QtQuick
import Quickshell
import "modules"

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        color: "transparent"
        implicitHeight: 42

        Rectangle {
            anchors.fill: parent
            color: "transparent"
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
