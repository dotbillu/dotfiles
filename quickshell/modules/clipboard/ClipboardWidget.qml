import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../theme"

PopupWindow {
    id: popup

    property bool popupHovered: false
    readonly property int widgetWidth: 460

    width: widgetWidth
    height: card.implicitHeight
    visible: false
    color: "transparent"

    property var clipHistory: []

    function show() {
        visible = true; card.opacity = 0; card.scale = 0.97; entryAnim.start()
        refreshList.running = true
    }
    function hide() { exitAnim.start() }

    ParallelAnimation {
        id: entryAnim
        NumberAnimation { target: card; property: "opacity"; to: 1;   duration: 180; easing.type: Easing.OutCubic }
        NumberAnimation { target: card; property: "scale";   to: 1.0; duration: 180; easing.type: Easing.OutCubic }
    }
    SequentialAnimation {
        id: exitAnim
        ParallelAnimation {
            NumberAnimation { target: card; property: "opacity"; to: 0;    duration: 130; easing.type: Easing.InCubic }
            NumberAnimation { target: card; property: "scale";   to: 0.97; duration: 130; easing.type: Easing.InCubic }
        }
        ScriptAction { script: popup.visible = false }
    }

    HoverHandler { onHoveredChanged: popup.popupHovered = hovered }

    Process {
        id: refreshList
        command: ["bash", "-c", "mkdir -p /tmp/quickshell_cliphist && cliphist -preview-width 500 list | head -n 15 | while IFS=$'\\t' read -r id text; do if [[ \"$text\" == \"[[ binary data\"* ]]; then cliphist decode \"$id\" > \"/tmp/quickshell_cliphist/${id}.png\"; echo -e \"${id}\\t[[IMAGE]]/tmp/quickshell_cliphist/${id}.png\"; else echo -e \"${id}\\t${text}\"; fi; done"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                let newList = []
                for (let i = 0; i < lines.length; i++) {
                    if (lines[i].trim() === "") continue
                    let parts = lines[i].split("\t")
                    if (parts.length >= 2) {
                        let text = parts.slice(1).join("\t")
                        let isImage = text.startsWith("[[IMAGE]]")
                        newList.push({ 
                            id: parts[0], 
                            text: isImage ? text : text, 
                            isImage: isImage, 
                            imagePath: isImage ? text.replace("[[IMAGE]]", "") : "" 
                        })
                    }
                }
                popup.clipHistory = newList
            }
        }
    }

    Process {
        id: copyItem
        property string itemId: ""
        command: ["bash", "-c", "cliphist decode " + itemId + " | wl-copy"]
    }

    Process {
        id: clearHistory
        command: ["bash", "-c", "cliphist wipe"]
        onExited: refreshList.running = true
    }

    Rectangle {
        id: card
        width: parent.width
        implicitHeight: col.implicitHeight + 28
        radius: 16; color: Theme.colors.surfaceContainer
        border.color: Theme.colors.border; border.width: 1
        transformOrigin: Item.Top

        ColumnLayout {
            id: col
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors.margins: 14
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "CLIPBOARD HISTORY"
                    color: Theme.colors.textMuted
                    font.pixelSize: 10
                    font.bold: true
                    Layout.fillWidth: true
                }
                Row {
                    spacing: 8
                    Text {
                        text: "󰆴" // Trash icon
                        color: Theme.colors.textSecondary
                        font.pixelSize: 14
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: clearHistory.running = true
                        }
                    }
                    Text {
                        text: "󰑓" // Refresh icon
                        color: Theme.colors.textSecondary
                        font.pixelSize: 14
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: refreshList.running = true
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.colors.border }

            ScrollView {
                id: scrollView
                Layout.fillWidth: true
                Layout.maximumHeight: 400
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                GridLayout {
                    columns: 2
                    columnSpacing: 8
                    rowSpacing: 8
                    width: scrollView.width

                    Repeater {
                        model: popup.clipHistory
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            implicitHeight: 90
                            Layout.alignment: Qt.AlignTop
                            radius: 8
                            color: itemMouse.containsMouse ? Theme.colors.overlayLight : Theme.colors.surface
                            border.color: Theme.colors.border; border.width: 1

                            Text {
                                anchors { fill: parent; margins: 10 }
                                text: modelData.text
                                visible: !modelData.isImage
                                color: Theme.colors.textPrimary
                                font.pixelSize: 12
                                wrapMode: Text.Wrap
                                maximumLineCount: 4
                                elide: Text.ElideRight
                                lineHeight: 1.2
                            }

                            Image {
                                anchors { fill: parent; margins: 8 }
                                source: modelData.isImage ? "file://" + modelData.imagePath : ""
                                visible: modelData.isImage
                                fillMode: Image.PreserveAspectCrop
                            }

                            MouseArea {
                                id: itemMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: {
                                    popup.hide()
                                    copyItem.itemId = modelData.id
                                    copyItem.running = true
                                }
                            }
                        }
                    }

                    Text {
                        text: "Clipboard is empty"
                        visible: popup.clipHistory.length === 0
                        color: Theme.colors.textMuted
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignHCenter
                        Layout.columnSpan: 2
                    }
                }
            }
        }
    }
}
