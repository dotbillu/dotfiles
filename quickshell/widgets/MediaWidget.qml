import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

import "../theme"
import "../services"

PopupWindow {
    id: popup

    property bool popupHovered: false
    property int barWidth: 300
    property var players: []
    property int activePlayerIndex: 0
    property var activePlayer: null

    signal prevPlayerRequested
    signal nextPlayerRequested
    width: barWidth
    height: card.implicitHeight
    visible: false
    color: "transparent"

    function show() {
        visible = true;
        card.opacity = 0;
        card.scale = 0.97;
        entryAnim.start();
    }
    function hide() {
        exitAnim.start();
    }

    ParallelAnimation {
        id: entryAnim
        NumberAnimation {
            target: card
            property: "opacity"
            to: 1
            duration: 180
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: card
            property: "scale"
            to: 1.0
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    SequentialAnimation {
        id: exitAnim
        ParallelAnimation {
            NumberAnimation {
                target: card
                property: "opacity"
                to: 0
                duration: 130
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: card
                property: "scale"
                to: 0.97
                duration: 130
                easing.type: Easing.InCubic
            }
        }
        ScriptAction {
            script: popup.visible = false
        }
    }

    HoverHandler {
        onHoveredChanged: popup.popupHovered = hovered
    }

    Rectangle {
        id: card
        width: popup.width
        implicitHeight: col.implicitHeight + 24
        transformOrigin: Item.Top   // scale from top (bar edge)
        opacity: 0

        // full rounded corners, distinct from the bar but touching it
        bottomLeftRadius: 20
        bottomRightRadius: 20
        topLeftRadius: 5
        topRightRadius: 5
        color: Theme.colors.surface
        border.color: Theme.colors.border
        border.width: 1


        ColumnLayout {
            id: col
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            anchors.topMargin: 12
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 6

            // ── album art centred ─────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                implicitHeight: artBox.height

                Rectangle {
                    id: artBox
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 60
                    height: 60
                    radius: 8
                    color: Theme.colors.surfaceAlt
                    clip: true

                    Image {
                        id: artImg
                        anchors.fill: parent
                        source: popup.activePlayer?.trackArtUrl ?? ""
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        mipmap: true
                        visible: status === Image.Ready
                    }

                    // app icon when no art
                    Image {
                        anchors.centerIn: parent
                        width: 32
                        height: 32
                        source: {
                            let p = popup.activePlayer;
                            if (!p)
                                return "";
                            let e = (p.desktopEntry || "").toLowerCase();
                            return e !== "" ? AppIcons.iconSource(e) : AppIcons.iconSource(p.identity || "");
                        }
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        visible: artImg.status !== Image.Ready && source !== ""
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "󰎆"
                        color: Theme.colors.textMuted
                        font.pixelSize: 24
                        visible: artImg.status !== Image.Ready
                    }

                    // app icon badge (bottom-right, only when art showing)
                    Rectangle {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: -2
                        width: 16
                        height: 16
                        radius: 4
                        color: Theme.colors.surface
                        visible: artImg.status === Image.Ready
                        Image {
                            anchors.fill: parent
                            anchors.margins: 3
                            source: {
                                let p = popup.activePlayer;
                                if (!p)
                                    return "";
                                let e = (p.desktopEntry || "").toLowerCase();
                                return e !== "" ? AppIcons.iconSource(e) : AppIcons.iconSource(p.identity || "");
                            }
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                        }
                    }
                }

                // prev/next arrows at far left/right
                NavArrow {
                    anchors.left: parent.left
                    anchors.verticalCenter: artBox.verticalCenter
                    icon: "󰒮"
                    enabled: popup.players.length > 1
                    onClicked: popup.prevPlayerRequested()
                }
                NavArrow {
                    anchors.right: parent.right
                    anchors.verticalCenter: artBox.verticalCenter
                    icon: "󰒭"
                    enabled: popup.players.length > 1
                    onClicked: popup.nextPlayerRequested()
                }
            }

            // track title
            Text {
                Layout.fillWidth: true
                text: popup.activePlayer?.trackTitle || "No media"
                color: Theme.colors.textPrimary
                font.pixelSize: 15
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            // artist · album
            Text {
                Layout.fillWidth: true
                text: {
                    let a = popup.activePlayer?.trackArtist || "";
                    let b = popup.activePlayer?.trackAlbum || "";
                    if (a && b)
                        return a + "  ·  " + b;
                    return a || b || "";
                }
                color: Theme.colors.textSecondary
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
                visible: text !== ""
            }

            // progress bar
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                Rectangle {
                    Layout.fillWidth: true
                    height: 3
                    radius: 2
                    color: Theme.colors.overlayLight

                    Rectangle {
                        width: {
                            let p = popup.activePlayer;
                            if (!p || !p.lengthSupported || p.length <= 0)
                                return 0;
                            return parent.width * Math.min(p.position / p.length, 1.0);
                        }
                        height: parent.height
                        radius: parent.radius
                        color: Theme.colors.accent
                        Behavior on width {
                            SmoothedAnimation {
                                velocity: 80
                            }
                        }
                    }

                    Timer {
                        interval: 1000
                        running: popup.activePlayer?.isPlaying ?? false
                        repeat: true
                        onTriggered: {
                            if (popup.activePlayer)
                                popup.activePlayer.positionChanged();
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: {
                            let p = popup.activePlayer;
                            if (!p || !p.positionSupported)
                                return "0:00";
                            let s = Math.floor(p.position);
                            return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
                        }
                        color: Theme.colors.textMuted
                        font.pixelSize: 9
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Text {
                        text: {
                            let p = popup.activePlayer;
                            if (!p || !p.lengthSupported)
                                return "0:00";
                            let s = Math.floor(p.length);
                            return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
                        }
                        color: Theme.colors.textMuted
                        font.pixelSize: 9
                    }
                }
            }

            // transport controls
            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Item {
                    Layout.fillWidth: true
                }

                CtrlBtn {
                    icon: "󰒝"
                    size: 15
                    active: popup.activePlayer?.shuffle ?? false
                    onClicked: {
                        if (popup.activePlayer?.shuffleSupported)
                            popup.activePlayer.shuffle = !popup.activePlayer.shuffle;
                    }
                }
                Item {
                    width: 6
                }
                CtrlBtn {
                    icon: "󰒮"
                    size: 19
                    enabled: popup.activePlayer?.canGoPrevious ?? false
                    onClicked: popup.activePlayer?.previous()
                }
                Item {
                    width: 6
                }
                CtrlBtn {
                    icon: popup.activePlayer?.isPlaying ? "󰏤" : "󰐊"
                    size: 26
                    accent: true
                    enabled: popup.activePlayer?.canTogglePlaying ?? false
                    onClicked: popup.activePlayer?.togglePlaying()
                }
                Item {
                    width: 6
                }
                CtrlBtn {
                    icon: "󰒭"
                    size: 19
                    enabled: popup.activePlayer?.canGoNext ?? false
                    onClicked: popup.activePlayer?.next()
                }
                Item {
                    width: 6
                }
                CtrlBtn {
                    icon: (popup.activePlayer?.loopState ?? MprisLoopState.None) === MprisLoopState.Track ? "󰑘" : "󰑖"
                    size: 15
                    active: (popup.activePlayer?.loopState ?? MprisLoopState.None) !== MprisLoopState.None
                    onClicked: {
                        let p = popup.activePlayer;
                        if (!p?.loopSupported)
                            return;
                        if (p.loopState === MprisLoopState.None)
                            p.loopState = MprisLoopState.Playlist;
                        else if (p.loopState === MprisLoopState.Playlist)
                            p.loopState = MprisLoopState.Track;
                        else
                            p.loopState = MprisLoopState.None;
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            Item {
                height: 4
            }
        }
    }

    component NavArrow: Rectangle {
        property string icon: "󰒮"
        signal clicked
        width: 22
        height: 36
        radius: 6
        color: nh.hovered ? Theme.colors.overlayLight : Theme.colors.transparent
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
        Text {
            anchors.centerIn: parent
            text: icon
            font.pixelSize: 13
            color: parent.enabled ? Theme.colors.textSecondary : Theme.colors.textMuted
        }
        HoverHandler {
            id: nh
            cursorShape: Qt.PointingHandCursor
        }
        TapHandler {
            enabled: parent.enabled
            onTapped: parent.clicked()
        }
    }

    component CtrlBtn: Rectangle {
        property string icon: ""
        property int size: 20
        property bool accent: false
        property bool active: false
        signal clicked
        implicitWidth: size + 12
        implicitHeight: size + 12
        radius: (size + 12) / 2
        color: ch.hovered ? (accent ? Theme.colors.accentStrong : Theme.colors.overlayLight) : Theme.colors.transparent
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
        Text {
            anchors.centerIn: parent
            text: icon
            font.pixelSize: size
            color: !parent.enabled ? Theme.colors.textMuted : parent.accent ? Theme.colors.accent : parent.active ? Theme.colors.accentStrong : Theme.colors.textSecondary
        }
        HoverHandler {
            id: ch
            cursorShape: Qt.PointingHandCursor
        }
        TapHandler {
            enabled: parent.enabled
            onTapped: parent.clicked()
        }
    }
}
