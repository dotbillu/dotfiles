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

    // ── Manually defined scratchpads ──
    readonly property var scratchpads: [
        { name: "term" },
        { name: "zen" },
        { name: "spotify" }
    ]

    property bool popupHovered: false
    property string mode: "toggle"  // "toggle" or "move"

    // ── Client data polled from hyprctl ──
    property var clientMap: ({})

    readonly property int cols: scratchpads.length
    readonly property int cellSize: 88
    readonly property int cellGap: 8
    readonly property int pad: 16
    readonly property int popupWidth: cols * cellSize + (cols - 1) * cellGap + pad * 2
    readonly property int popupHeight: cellSize + pad * 2 + 28

    width: popupWidth
    height: popupHeight
    visible: false
    color: "transparent"

    function toggleWith(m) {
        if (visible && mode === m) {
            hide();
        } else {
            mode = m;
            show();
        }
    }

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

    // ── Fetch clients in special workspaces ──
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

    // ── Toggle process ──
    Process {
        id: toggleProcess
        property string scratchpadName: ""
        command: ["bash", "-c", "hyprctl eval 'hl.dispatch(hl.dsp.workspace.toggle_special(\"" + scratchpadName + "\"))'"]
    }

    // ── Move process ──
    Process {
        id: moveProcess
        property string scratchpadName: ""
        command: ["bash", "-c", "hyprctl eval 'hl.dispatch(hl.dsp.window.move({ workspace = \"special:" + scratchpadName + "\" }))'"]
    }

    // ── Card ──
    Rectangle {
        id: card
        width: parent.width
        height: parent.height
        radius: 14
        color: Theme.colors.surface
        transformOrigin: Item.Center

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: popup.pad
            spacing: 10

            // ── Header ──
            Text {
                text: popup.mode === "move" ? "MOVE TO" : "SCRATCHPADS"
                color: Theme.colors.textMuted
                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1.5
            }

            // ── Row of scratchpad cells ──
            Row {
                Layout.fillWidth: true
                spacing: popup.cellGap

                Repeater {
                    model: popup.scratchpads

                    Rectangle {
                        id: cell
                        required property var modelData
                        required property int index

                        property var apps: popup.clientMap[modelData.name] || []
                        property bool hasApps: apps.length > 0

                        width: popup.cellSize
                        height: popup.cellSize
                        radius: 10
                        color: cellMouse.containsMouse ? Theme.colors.glassMedium : Theme.colors.surfaceAlt

                        Behavior on color { ColorAnimation { duration: 120 } }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 8

                            // Number
                            Text {
                                text: (cell.index + 1).toString()
                                font.pixelSize: 20
                                font.bold: true
                                color: cellMouse.containsMouse ? Theme.colors.accent : Theme.colors.textSecondary
                                Layout.alignment: Qt.AlignHCenter
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }

                            // ── Active app icons ──
                            Row {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 3
                                visible: cell.hasApps

                                Repeater {
                                    model: cell.apps

                                    Item {
                                        required property string modelData
                                        width: 20
                                        height: 20

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
                                            sourceSize.width: 20
                                            sourceSize.height: 20
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

                            // Empty state
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 5
                                height: 5
                                radius: 3
                                color: Theme.colors.gray400
                                visible: !cell.hasApps
                            }
                        }

                        MouseArea {
                            id: cellMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                if (popup.mode === "move") {
                                    moveProcess.scratchpadName = modelData.name;
                                    moveProcess.running = true;
                                } else {
                                    toggleProcess.scratchpadName = modelData.name;
                                    toggleProcess.running = true;
                                }
                                popup.hide();
                            }
                        }
                    }
                }
            }
        }
    }
}
