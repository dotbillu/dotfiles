import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../theme"
import "../../services"

Row {
    id: root
    spacing: 0

    property var scratchpads: []

    Process {
        id: loadScratchpads
        running: true
        command: ["bash", "-c", "for f in ~/.config/pypr/config.toml ~/.config/hypr/pyprland.toml ~/.pyprland.toml ~/.config/pypr/pyprland.json; do if [ -f \"$f\" ]; then grep '^\\[scratchpads\\.' \"$f\"; exit 0; fi; done"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n");
                let list = [];
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim();
                    // line should look like: [scratchpads.term]
                    if (line.startsWith("[scratchpads.")) {
                        let name = line.substring(13, line.indexOf("]"));
                        if (name) {
                            list.push(name);
                        }
                    }
                }
                root.scratchpads = list;
            }
        }
    }

    function getAppClass(name) {
        let n = name.toLowerCase();
        if (n === "term")
            return "kitty";
        return n;
    }

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
                    toggleProcess.scratchpadName = modelData;
                    toggleProcess.running = true;
                }
            }
        }
    }

    Process {
        id: toggleProcess
        property string scratchpadName: ""
        command: ["pypr", "toggle", scratchpadName]
    }
}
