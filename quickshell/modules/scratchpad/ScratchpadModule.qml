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

    // ── Watch Hyprland submap events to show/hide popup ──
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "submap") {
                let name = event.data;
                // Only show on the focused monitor
                let isFocused = root.panelWindow
                    && Hyprland.focusedMonitor
                    && Hyprland.monitorFor(root.panelWindow.screen) === Hyprland.focusedMonitor;
                if (name === "scratchpad_pick" && isFocused) {
                    scratchpadPopup.mode = "toggle";
                    scratchpadPopup.show();
                } else if (name === "scratchpad_move" && isFocused) {
                    scratchpadPopup.mode = "move";
                    scratchpadPopup.show();
                } else {
                    // submap reset (empty string) or any other submap
                    if (scratchpadPopup.visible)
                        scratchpadPopup.hide();
                }
            }
        }
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
