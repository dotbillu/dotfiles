import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import Qt5Compat.GraphicalEffects

Row {
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "openwindow" || event.name === "closewindow") {
                refreshTimer.restart();
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 50
        onTriggered: Hyprland.refreshToplevels()
    }

    Rectangle {
        width: innerRow.width + 20
        height: 40
        radius: 10
        color: "#BF191920"
        anchors.centerIn: parent

        Row {
            id: innerRow
            spacing: 10

            anchors.centerIn: parent

            Repeater {
                model: Hyprland.workspaces
                opacity: 1

                Rectangle {
                    id: dotItem
                    required property var modelData
                    property bool isActive: modelData.active

                    width: oneWorkSpaceRec.width 
                    height: oneWorkSpaceRec.height
                    radius: 20
                    color: !isActive ? "#BF191920" : "ffffff"

                    Rectangle {
                        id: oneWorkSpaceRec
                        anchors.centerIn: parent
                        color: "transparent"
                        width: appRow.width + 10
                        height: appRow.height < 1 ? 0 : appRow.height + 8
                        radius: 30
                        Row {
                            id: appRow
                            anchors.centerIn: parent
                            spacing: 3

                            Repeater {
                                model: dotItem.modelData.toplevels

                                Item {
                                    required property var modelData

                                    property var ipc: modelData.lastIpcObject

                                    width: 18
                                    height: 18

                                    Rectangle {
                                        id: imageMask
                                        anchors.fill: parent
                                        radius: 20
                                        visible: false
                                    }

                                    Image {
                                        id: myIcon
                                        source: {
                                            const app = ipc?.class?.toLowerCase();
                                            return app ? `../icons/${app}.png` : "";
                                        }
                                        anchors.fill: parent
                                        sourceSize.width: 20
                                        sourceSize.height: 20
                                        fillMode: Image.PreserveAspectFit
                                        mipmap: true
                                        smooth: true
                                        visible: false
                                    }

                                    OpacityMask {
                                        anchors.fill: parent
                                        source: myIcon
                                        maskSource: imageMask
                                    }
                                }
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            dotItem.modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
