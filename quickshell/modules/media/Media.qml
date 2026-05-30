import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

import "../../theme"
import "../../services"

Rectangle {
    id: root
    visible: activePlayer != null

    property var panelWindow: null
    property int barScreenX:  0

    implicitWidth:  contentRow.implicitWidth + 32
    implicitHeight: 40
    radius: 20
    color:  Theme.colors.surface

    property var activePlayer: null
    property string targetPid: ""
    property var playingStates: ({})
    property int validPlayerCount: 0

    function getPid(p) {
        if (!p) return "";
        return (p.desktopEntry || "") + "|" + (p.identity || "");
    }

    function getTitle(p) {
        if (!p) return "";
        let t = String(p.trackTitle || "").trim();
        if (t === "null" || t === "undefined" || t === "") {
            t = String(p.identity || "").trim();
        }
        if (t === "null" || t === "undefined" || t === "") {
            t = "Unknown Media";
        }
        return t;
    }

    function isValidPlayer(p) {
        if (!p) return false;
        return root.getTitle(p) !== "Unknown Media";
    }

    Timer {
        interval: 250
        running: true
        repeat: true
        onTriggered: {
            let pVals = Mpris.players.values;
            let pList = [];
            if (pVals) {
                for (let i = 0; i < pVals.length; i++) {
                    if (root.isValidPlayer(pVals[i])) {
                        pList.push(pVals[i]);
                    }
                }
            }

            root.validPlayerCount = pList.length;

            if (pList.length === 0) {
                root.activePlayer = null;
                return;
            }

            let justStarted = "";
            let newStates = {};
            for (let i = 0; i < pList.length; i++) {
                let p = pList[i];
                let pid = root.getPid(p);
                if (pid === "|") continue;

                let isPlaying = p.isPlaying === true;
                let wasPlaying = root.playingStates[pid] === true;
                
                if (isPlaying && !wasPlaying) {
                    justStarted = pid;
                }
                newStates[pid] = isPlaying;
            }
            root.playingStates = newStates;

            if (justStarted !== "") {
                root.targetPid = justStarted;
            }

            let found = null;
            for (let i = 0; i < pList.length; i++) {
                let p = pList[i];
                if (root.getPid(p) === root.targetPid) {
                    found = p;
                    break;
                }
            }

            if (found) {
                root.activePlayer = found;
            } else if (pList.length > 0) {
                root.activePlayer = pList[0];
                root.targetPid = root.getPid(pList[0]);
            } else {
                root.activePlayer = null;
            }
        }
    }

    function changePlayer() {
        let pVals = Mpris.players.values;
        let pList = [];
        if (pVals) {
            for (let i = 0; i < pVals.length; i++) {
                if (root.isValidPlayer(pVals[i])) {
                    pList.push(pVals[i]);
                }
            }
        }
        
        if (pList.length < 2) return;

        pList.sort(function(a, b) {
            return root.getPid(a).localeCompare(root.getPid(b));
        });

        let currentIdx = 0;
        for (let i = 0; i < pList.length; i++) {
            if (root.getPid(pList[i]) === root.targetPid) {
                currentIdx = i;
                break;
            }
        }

        let nextIdx = (currentIdx + 1) % pList.length;
        root.targetPid = root.getPid(pList[nextIdx]);
        root.activePlayer = pList[nextIdx];
    }

    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        spacing: 16

        RowLayout {
            spacing: 8

            // Fixed-size container for icons to prevent width shifting
            Item {
                Layout.preferredWidth: 14
                Layout.preferredHeight: 14

                Image {
                    id: barIcon
                    anchors.fill: parent
                    source: {
                        let p = root.activePlayer
                        if (!p) return ""
                        let e = (p.desktopEntry || "").toLowerCase()
                        return e !== "" ? AppIcons.iconSource(e) : AppIcons.iconSource(p.identity || "")
                    }
                    fillMode: Image.PreserveAspectFit
                    smooth: true; mipmap: true
                    visible: status === Image.Ready
                }

                Text {
                    anchors.centerIn: parent
                    text: {
                        let p = root.activePlayer; if (!p) return "󰎆"
                        let n = (p.identity || "").toLowerCase()
                        if (n.includes("spotify"))  return "󰓇"
                        if (n.includes("firefox") || n.includes("chrome")) return "󰖟"
                        if (n.includes("mpv"))      return "󰐊"
                        if (n.includes("vlc"))      return "󰕼"
                        return "󰎆"
                    }
                    color: root.activePlayer?.isPlaying ? Theme.colors.accent : Theme.colors.textSecondary
                    font.pixelSize: 13
                    visible: barIcon.status !== Image.Ready

                    SequentialAnimation on opacity {
                        running: root.activePlayer?.isPlaying ?? false
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.4; duration: 900; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 900; easing.type: Easing.InOutSine }
                    }
                }
            }

            Text {
                Layout.preferredWidth: 70
                Layout.maximumWidth:   70
                text:                  root.getTitle(root.activePlayer)
                color:                 Theme.colors.textPrimary
                font.pixelSize:        13
                font.bold:             true
                elide:                 Text.ElideRight
                maximumLineCount:      1
                horizontalAlignment:   Text.AlignLeft
            }
        }

        RowLayout {
            spacing: 10

            Text {
                text: "󰒯"
                color: Theme.colors.textMuted
                font.pixelSize: 15
                visible: root.validPlayerCount > 1
                
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.changePlayer()
                }
            }
            
            Text {
                text: "󰒮"
                color: root.activePlayer?.canGoPrevious ? Theme.colors.textSecondary : Theme.colors.textMuted
                font.pixelSize: 15
                
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activePlayer?.previous()
                }
            }
            
            Text {
                text: root.activePlayer?.isPlaying ? "󰏤" : "󰐊"
                color: Theme.colors.textSecondary
                font.pixelSize: 17
                
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activePlayer?.togglePlaying()
                }
            }
            
            Text {
                text: "󰒭"
                color: root.activePlayer?.canGoNext ? Theme.colors.textSecondary : Theme.colors.textMuted
                font.pixelSize: 15
                
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activePlayer?.next()
                }
            }
        }
    }
}
