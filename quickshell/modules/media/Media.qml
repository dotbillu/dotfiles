import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

import "../../theme"
import "../../services"
import "../../widgets"

Rectangle {
    id: root

    property var panelWindow: null
    property int barScreenX:  0    // set from shell.qml: bar's x in window coords

    // widget matches bar width exactly
    readonly property int barWidth: contentRow.implicitWidth + 28

    implicitWidth:  barWidth
    implicitHeight: 40
    radius: 20
    color:  Theme.colors.surface

    property int activePlayerIndex: 0
    property var players: Mpris.players.values

    property var activePlayer: {
        if (!players || players.length === 0) return null
        return players[Math.min(activePlayerIndex, players.length - 1)]
    }

    function prevPlayer() {
        if (players.length < 2) return
        activePlayerIndex = (activePlayerIndex - 1 + players.length) % players.length
    }
    function nextPlayer() {
        if (players.length < 2) return
        activePlayerIndex = (activePlayerIndex + 1) % players.length
    }

    // ── bar content ───────────────────────────────────────────────────────────
    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        spacing: 8



        Item {
            Layout.preferredWidth: 200
            Layout.preferredHeight: 20

            RowLayout {
                anchors.centerIn: parent
                spacing: 8

                // app icon — small, 14×14, right next to text
                Image {
                    id: barIcon
                    Layout.preferredWidth:  14
                    Layout.preferredHeight: 14
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

                // fallback glyph
                Text {
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

                // title
                Text {
                    Layout.maximumWidth:   178
                    text:                  root.activePlayer?.trackTitle || "No media"
                    color:                 Theme.colors.textPrimary
                    font.pixelSize:        13
                    font.bold:             true
                    elide:                 Text.ElideRight
                    maximumLineCount:      1
                    horizontalAlignment:   Text.AlignLeft
                }
            }
        }

        // play/pause button
        Text {
            text: root.activePlayer?.isPlaying ? "󰏤" : "󰐊"
            color: Theme.colors.textMuted
            font.pixelSize: 14
            visible: root.activePlayer != null
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: 24
            Layout.fillHeight: true
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.activePlayer?.togglePlaying()
            }
        }
    }

    TapHandler {
        onTapped: {
            if (widget.visible) widget.hide()
            else { widget.show(); closeDelay.stop() }
        }
    }

    HoverHandler {
        id: barHover
        onHoveredChanged: {
            if (hovered) closeDelay.stop()
            else if (widget.visible && !widget.popupHovered) closeDelay.restart()
        }
    }

    Timer {
        id: closeDelay
        interval: 400
        onTriggered: {
            if (!widget.popupHovered && !barHover.hovered) widget.hide()
        }
    }

    MediaWidget {
        id: widget

        anchor.window: root.panelWindow

        // Use barScreenX passed from shell.qml — reliable window-relative x
        anchor.rect.x: root.barScreenX

        // Widget top flush with bar bottom — grows downward
        anchor.rect.y: 40

        // match bar width exactly
        barWidth: root.barWidth

        players:           root.players
        activePlayerIndex: root.activePlayerIndex
        activePlayer:      root.activePlayer

        onPrevPlayerRequested: root.prevPlayer()
        onNextPlayerRequested: root.nextPlayer()

        onPopupHoveredChanged: {
            if (popupHovered) closeDelay.stop()
            else if (widget.visible && !barHover.hovered) closeDelay.restart()
        }
    }
}
