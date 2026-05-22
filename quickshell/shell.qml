import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 42
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            radius: 16
            color: "#cc111111"

            Row {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                spacing: 12

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Hyprland"
                    color: "white"
                    font.pixelSize: 14
                }

                Repeater {
                    model: Hyprland.workspaces

                    Rectangle {
                        required property var modelData

                        width: 28
                        height: 28
                        radius: 14

                        color: modelData.active
                            ? "#ffffff"
                            : "#33ffffff"

                        Text {
                            anchors.centerIn: parent
                            text: modelData.id
                            color: modelData.active
                                ? "black"
                                : "white"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                modelData.activate()
                            }
                        }
                    }
                }
            }
        }
    }
}
