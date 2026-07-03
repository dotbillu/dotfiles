import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../theme"

PopupWindow {
    id: popup

    property bool popupHovered: false
    readonly property int widgetWidth: 280

    width: widgetWidth
    height: card.implicitHeight
    visible: false
    color: "transparent"

    function show() {
        visible = true; card.opacity = 0; card.scale = 0.97; entryAnim.start()
        checkShutdown.running = true
        generateCalendar()
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

    property date currentDate: new Date()
    property var days: []
    
    function generateCalendar() {
        let d = new Date()
        let year = d.getFullYear()
        let month = d.getMonth()
        let firstDay = new Date(year, month, 1).getDay() // 0 = Sun, 1 = Mon
        let daysInMonth = new Date(year, month + 1, 0).getDate()
        
        let offset = firstDay === 0 ? 6 : firstDay - 1 // Make Monday = 0
        
        let newDays = []
        for (let i = 0; i < 42; i++) {
            let dayNum = i - offset + 1
            if (dayNum > 0 && dayNum <= daysInMonth) {
                newDays.push(dayNum)
            } else {
                newDays.push("")
            }
        }
        popup.days = newDays
    }

    // Shutdown Scheduler State
    property bool hasShutdown: false
    property string shutdownTime: ""
    property int shutdownMinutes: 60

    Process {
        id: checkShutdown
        command: ["bash", "-c", "cat /run/systemd/shutdown/scheduled 2>/dev/null | grep USEC | cut -d= -f2"]
        stdout: StdioCollector {
            onStreamFinished: {
                let txt = this.text.trim()
                if (txt !== "") {
                    let usec = parseInt(txt)
                    let d = new Date(usec / 1000)
                    popup.hasShutdown = true
                    popup.shutdownTime = Qt.formatTime(d, "hh:mm AP")
                } else {
                    popup.hasShutdown = false
                }
            }
        }
    }

    Process {
        id: setShutdown
    }

    function scheduleShutdown() {
        setShutdown.command = ["bash", "-c", "shutdown +" + popup.shutdownMinutes]
        setShutdown.running = true
        // Re-check after 500ms
        delayCheck.restart()
    }

    function cancelShutdown() {
        setShutdown.command = ["bash", "-c", "shutdown -c"]
        setShutdown.running = true
        delayCheck.restart()
    }

    Timer {
        id: delayCheck
        interval: 500
        onTriggered: checkShutdown.running = true
    }

    Timer {
        interval: 10000; repeat: true; running: popup.visible
        onTriggered: checkShutdown.running = true
    }

    Rectangle {
        id: card
        width: parent.width; implicitHeight: col.implicitHeight + 28
        radius: 16; color: Theme.colors.surfaceContainer
        border.color: Theme.colors.border; border.width: 1
        transformOrigin: Item.Top

        ColumnLayout {
            id: col
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors.margins: 14
            spacing: 14

            Text { 
                text: Qt.formatDate(popup.currentDate, "MMMM yyyy")
                color: Theme.colors.textPrimary; font.pixelSize: 14; font.bold: true 
                Layout.alignment: Qt.AlignHCenter
            }

            GridLayout {
                columns: 7
                rowSpacing: 4; columnSpacing: 4
                Layout.fillWidth: true

                Repeater {
                    model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                    delegate: Text {
                        text: modelData
                        color: Theme.colors.textMuted; font.pixelSize: 10; font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }

                Repeater {
                    model: popup.days
                    delegate: Rectangle {
                        width: 30; height: 30; radius: 15
                        color: (modelData === popup.currentDate.getDate()) ? Theme.colors.accent : "transparent"
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: (modelData === popup.currentDate.getDate()) ? Theme.colors.surfaceContainer : Theme.colors.textSecondary
                            font.pixelSize: 12
                            font.bold: (modelData === popup.currentDate.getDate())
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.colors.border }

            // Shutdown Scheduler
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                
                // Input box for minutes (hidden when active)
                Rectangle {
                    Layout.preferredWidth: 42
                    Layout.fillHeight: true
                    visible: !popup.hasShutdown
                    radius: 6; color: Theme.colors.surface
                    border.color: Theme.colors.border; border.width: 1
                    
                    TextInput {
                        anchors.fill: parent
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.colors.textPrimary
                        font.pixelSize: 12
                        text: popup.shutdownMinutes.toString()
                        validator: RegularExpressionValidator { regularExpression: /^[0-9]+$/ }
                        onTextChanged: {
                            let v = parseInt(text)
                            if (!isNaN(v)) popup.shutdownMinutes = v
                        }
                    }
                }

                Text { 
                    text: "min"
                    visible: !popup.hasShutdown
                    color: Theme.colors.textMuted
                    font.pixelSize: 12
                }

                // Action Button
                Rectangle {
                    Layout.fillWidth: true
                    height: 28; radius: 6
                    color: popup.hasShutdown ? Theme.colors.surface : Theme.colors.error
                    border.color: popup.hasShutdown ? Theme.colors.border : "transparent"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: popup.hasShutdown ? "Cancel Shutdown (" + popup.shutdownTime + ")" : "Schedule Shutdown"
                        color: popup.hasShutdown ? Theme.colors.textPrimary : Theme.colors.surfaceContainer
                        font.pixelSize: 12; font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (popup.hasShutdown) popup.cancelShutdown()
                            else popup.scheduleShutdown()
                        }
                    }
                }
            }
        }
    }

}
