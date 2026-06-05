import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import "../../theme"
import "../../services"

Row {
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: Hyprland.refreshToplevels()
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: innerRow.width > 10 ? innerRow.width + 10 : 35
        height: 32

        radius: 18

        color: Theme.colors.surface
        border.color: Theme.colors.border
        border.width: 1

        Row {
            id: innerRow

            spacing: 8
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

                    radius: 18

                    color: isActive ? Theme.colors.accentStrong : "transparent"

                    border.color: isActive ? Theme.colors.borderActive : "transparent" 

                    Rectangle {
                        id: oneWorkSpaceRec

                        anchors.centerIn: parent

                        color: Theme.colors.transparent

                        width: appRow.width + 8
                        height: appRow.height < 1 ? 0 : appRow.height + 8

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

                                        width: visible ? 16 : 0
                                        height: visible ? 16 : 0

                                        Rectangle {
                                            id: imageMask

                                            anchors.fill: parent

                                            radius: 20
                                            visible: false
                                        }
                                        Image {
                                            id: myIcon

                                            source: {
                                                let app = ipc?.class?.toLowerCase();
                                                if (!app)
                                                    return "";
                                                return AppIcons.iconSource(app);
                                            }

                                            anchors.fill: parent

                                            sourceSize.width: 16
                                            sourceSize.height: 16

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

                                    width: visible ? 20 : 0
                                    height: visible ? 16 : 0

                                    radius: 8

                                    color: Theme.colors.surfaceAlt

                                    Text {
                                        anchors.centerIn: parent

                                        text: "+" + overflowBadge.extraCount

                                        color: Theme.colors.textPrimary

                                        font.pixelSize: 10
                                        font.bold: true

                                        visible: overflowBadge.visible
                                    }
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            dotItem.modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
