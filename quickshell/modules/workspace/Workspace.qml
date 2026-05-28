import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import Qt5Compat.GraphicalEffects

Row {
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: Hyprland.refreshToplevels()
    }

    Rectangle {
        width: innerRow.width + 12
        height: 40
        radius: 20
        color: "#33D4E0C8"
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
                    color: isActive ? "#BFD4E0C8" : "#66D4E0C8"

                    Rectangle {
                        id: oneWorkSpaceRec
                        anchors.centerIn: parent
                        color: "transparent"
                        width: appRow.width + 10
                        height: appRow.height < 1 ? 0 : appRow.height + 10
                        radius: 30

                        Row {
                            id: appRow
                            anchors.centerIn: parent
                            spacing: 3

                            Row {
                                spacing: 4

                                Repeater {
                                    id: windowRepeater
                                    model: dotItem.modelData.toplevels

                                    Item {
                                        required property var modelData
                                        required property int index

                                        property var ipc: modelData.lastIpcObject
                                        property bool isFloating: ipc?.floating === true

                                        // 2. Safe tracking: Binds to count to prevent load crashes
                                        property int tilingIndex: {
                                            let dummy = windowRepeater.count;
                                            let dummy2 = isFloating;

                                            let count = 0;
                                            for (let i = 0; i < index; i++) {
                                                let prevItem = windowRepeater.itemAt(i);
                                                if (prevItem && !prevItem.isFloating) {
                                                    count++;
                                                }
                                            }
                                            return count;
                                        }

                                        visible: !isFloating && tilingIndex < 3
                                        width: visible ? 20 : 0
                                        height: visible ? 20 : 0

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
                                                return app ? `../../icons/${app}.png` : "";
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

                                Rectangle {
                                    id: overflowBadge

                                    property int extraCount: {
                                        // Also binds to count so it doesn't loop forever
                                        let dummy = windowRepeater.count;
                                        let totalTiling = 0;
                                        for (let i = 0; i < windowRepeater.count; i++) {
                                            let item = windowRepeater.itemAt(i);
                                            if (item && item.ipc && !item.isFloating) {
                                                totalTiling++;
                                            }
                                        }
                                        return totalTiling - 3;
                                    }

                                    visible: extraCount > 0
                                    width: visible ? 24 : 0
                                    height: visible ? 20 : 0
                                    color: "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "+" + overflowBadge.extraCount
                                        color: "white"
                                        font.pixelSize: 12
                                        font.bold: true
                                        visible: overflowBadge.visible
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
