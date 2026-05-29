import QtQuick
import QtQuick.Layouts

import "../../theme"

Rectangle {
    id: root

    implicitWidth: row.width + 24
    implicitHeight: 40

    radius: 20

    color: Theme.colors.surface
    // border.color: Theme.colors.border

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: 8

        Text {
            id: timeText

            color: Theme.colors.textPrimary

            font.pixelSize: 14
            font.bold: true

            text: Qt.formatTime(
                root.date,
                "hh:mm AP"
            )
        }

        Rectangle {
            width: 4
            height: 4

            radius: 999

            color: Theme.colors.textMuted
        }

        Text {
            color: Theme.colors.textSecondary

            font.pixelSize: 13

            text: Qt.formatDate(
                root.date,
                "ddd dd MMM"
            )
        }
    }

    property var panelWindow: null
    property int barScreenX: 0
    property bool widgetOpen: false

    property date date: new Date()

    Timer {
        id: clock
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.date = new Date()
        }
    }

    HoverHandler {
        id: rootHover
        onHoveredChanged: {
            if (hovered) closeDelay.stop()
            else if (root.widgetOpen && !calendarWidget.popupHovered) closeDelay.restart()
        }
    }

    Timer {
        id: closeDelay
        interval: 400
        onTriggered: {
            if (!rootHover.hovered && !calendarWidget.popupHovered) {
                root.widgetOpen = false
                calendarWidget.hide()
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.widgetOpen) {
                root.widgetOpen = false
                calendarWidget.hide()
            } else {
                root.widgetOpen = true
                calendarWidget.show()
            }
        }
    }

    CalendarWidget {
        id: calendarWidget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40
        onPopupHoveredChanged: {
            if (popupHovered) closeDelay.stop()
            else if (!rootHover.hovered) closeDelay.restart()
        }
    }
}
