import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import "../../theme"
import "../../services"

Row {
    id: root
    spacing: 0

    readonly property var scratchpads: ["term", "zen", "spotify"]

    property var panelWindow: null

    function getAppClass(name) {
        let n = name.toLowerCase();
        if (n === "term")
            return "kitty";
        return n;
    }

    // ── Global shortcut: Super+L toggles scratchpad picker ──
    GlobalShortcut {
        name: "scratchpadPicker"
        description: "Toggle scratchpad picker overlay"
        onPressed: scratchpadPopup.toggleWith("toggle")
    }

    // ── Global shortcut: Super+Shift+M toggles move-to picker ──
    GlobalShortcut {
        name: "scratchpadMover"
        description: "Toggle move-to-scratchpad picker overlay"
        onPressed: scratchpadPopup.toggleWith("move")
    }

    // ── Bar icons ──
    Repeater {
        model: root.scratchpads
        delegate: Rectangle {
            required property string modelData
            implicitHeight: 40
            implicitWidth: 24
            color: "transparent"

            Image {
                anchors.centerIn: parent
                source: AppIcons.iconSource(root.getAppClass(modelData))
                sourceSize.width: 18
                sourceSize.height: 18
                fillMode: Image.PreserveAspectFit
                mipmap: true
                smooth: true
                opacity: itemHover.hovered ? 1.0 : 0.7
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }

            HoverHandler {
                id: itemHover
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    barToggleProcess.scratchpadName = modelData;
                    barToggleProcess.running = true;
                }
            }
        }
    }

    Process {
        id: barToggleProcess
        property string scratchpadName: ""
        command: ["bash", "-c", "hyprctl eval 'hl.dispatch(hl.dsp.workspace.toggle_special(\"" + scratchpadName + "\"))'"]
    }

    // ── Popup ──
    ScratchpadPopup {
        id: scratchpadPopup
        anchor.window: root.panelWindow
        anchor.rect.x: root.panelWindow ? (root.panelWindow.width / 2 - scratchpadPopup.width / 2) : 0
        anchor.rect.y: 44
    }
}
