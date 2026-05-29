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
                clock.date,
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
                clock.date,
                "ddd dd MMM"
            )
        }
    }

    property date date: new Date()

    Timer {
        id: clock

        interval: 1000

        running: true
        repeat: true

        property date date: new Date()

        onTriggered: {
            date = new Date()
        }
    }
}
