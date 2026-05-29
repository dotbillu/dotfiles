import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import "../../theme"
import "../../widgets"

Rectangle {
    id: root

    property var panelWindow: null
    property int barScreenX: 0

    property var  sink:   Pipewire.defaultAudioSink
    property real volume: sink?.audio?.volume ?? 0
    property bool muted:  sink?.audio?.muted  ?? false

    implicitWidth:  40
    implicitHeight: 40
    radius: 20
    color:  Theme.colors.surface

    // Volume icon
    Text {
        anchors.centerIn: parent
        font.pixelSize: 15
        color: root.muted ? Theme.colors.textMuted : Theme.colors.textPrimary
        text: {
            if (root.muted || root.volume === 0) return "󰖁"
            if (root.volume < 0.33)              return "󰕿"
            if (root.volume < 0.66)              return "󰖀"
            return "󰕾"
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: widget.visible ? widget.hide() : widget.show()
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
        onTriggered: if (!widget.popupHovered && !barHover.hovered) widget.hide()
    }

    SoundWidget {
        id: widget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40

        onPopupHoveredChanged: {
            if (popupHovered) closeDelay.stop()
            else if (widget.visible && !barHover.hovered) closeDelay.restart()
        }
    }
}
