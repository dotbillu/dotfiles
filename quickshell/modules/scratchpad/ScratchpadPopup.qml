import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Qt5Compat.GraphicalEffects

import "../../theme"
import "../../services"

PopupWindow {
    id: popup

    // 10 special workspaces
    readonly property var scratchpads: [
        { name: "1" }, { name: "2" }, { name: "3" }, { name: "4" }, { name: "5" },
        { name: "6" }, { name: "7" }, { name: "8" }, { name: "9" }, { name: "10" }
    ]

    property bool popupHovered: false
    property string mode: "toggle"

    property var clientMap: ({})

    readonly property int cols: 10
    readonly property int cellSize: 72
    readonly property int cellGap: 6
    readonly property int pad: 14
    readonly property int popupWidth: cols * cellSize + (cols - 1) * cellGap + pad * 2
    readonly property int gridRows: Math.ceil(scratchpads.length / cols)
    readonly property int popupHeight: gridRows * cellSize + (gridRows - 1) * cellGap + pad * 2 + 24

    width: popupWidth
    height: popupHeight
    visible: false
    color: "transparent"

    function show() {
        visible = true;
        card.opacity = 0;
        card.scale = 0.95;
        entryAnim.start();
        refreshClients.running = true;
    }

    function hide() {
        exitAnim.start();
    }

    ParallelAnimation {
        id: entryAnim
        NumberAnimation { target: card; property: "opacity"; to: 1;   duration: 160; easing.type: Easing.OutCubic }
        NumberAnimation { target: card; property: "scale";   to: 1.0; duration: 160; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: exitAnim
        ParallelAnimation {
            NumberAnimation { target: card; property: "opacity"; to: 0;    duration: 120; easing.type: Easing.InCubic }
            NumberAnimation { target: card; property: "scale";   to: 0.95; duration: 120; easing.type: Easing.InCubic }
        }
        ScriptAction { script: popup.visible = false }
    }

    HoverHandler { onHoveredChanged: popup.popupHovered = hovered }

    Process {
        id: refreshClients
        command: ["bash", "-c", "hyprctl clients -j | jq -r '.[] | select(.workspace.name | startswith(\"special:\")) | \"\\(.workspace.name | sub(\"special:\";\"\"))\\t\\(.class)\"'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n");
                let map = {};
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim();
                    if (line === "") continue;
                    let parts = line.split("\t");
                    if (parts.length >= 2) {
                        let ws = parts[0];
                        let cls = parts[1];
                        if (!map[ws]) map[ws] = [];
                        if (cls && map[ws].indexOf(cls) === -1) {
                            map[ws].push(cls);
                        }
                    }
                }
                popup.clientMap = map;
            }
        }
    }

    Rectangle {
        id: card
        width: parent.width
        height: parent.height
        radius: 14
        color: "transparent"
        transformOrigin: Item.Center

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: popup.pad
            spacing: 8


            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: popup.cols
                columnSpacing: popup.cellGap
                rowSpacing: popup.cellGap

                Repeater {
                    model: popup.scratchpads

                    Rectangle {
                        id: cell
                        required property var modelData
                        required property int index

                        property var apps: popup.clientMap[modelData.name] || []
                        property bool hasApps: apps.length > 0

                        Layout.preferredWidth: popup.cellSize
                        Layout.preferredHeight: popup.cellSize
                        radius: 10
                        color: Theme.colors.surfaceAlt

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: modelData.name === "10" ? "0" : modelData.name
                                font.pixelSize: 18
                                font.bold: true
                                color: cell.hasApps ? Theme.colors.textPrimary : Theme.colors.textMuted
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Row {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 3
                                visible: cell.hasApps

                                Repeater {
                                    model: cell.apps

                                    Item {
                                        required property string modelData
                                        width: 18
                                        height: 18

                                        Rectangle {
                                            id: iconMask
                                            anchors.fill: parent
                                            radius: 20
                                            visible: false
                                        }

                                        Image {
                                            id: appIcon
                                            anchors.fill: parent
                                            source: AppIcons.iconSource(modelData)
                                            sourceSize.width: 18
                                            sourceSize.height: 18
                                            fillMode: Image.PreserveAspectFit
                                            mipmap: true
                                            smooth: true
                                            visible: false
                                        }

                                        OpacityMask {
                                            anchors.fill: parent
                                            source: appIcon
                                            maskSource: iconMask
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 5
                                height: 5
                                radius: 3
                                color: Theme.colors.gray400
                                visible: !cell.hasApps
                            }
                        }
                    }
                }
            }
        }
    }
}
