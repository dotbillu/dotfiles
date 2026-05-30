import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../theme"
import "../../services"

PanelWindow {
    id: warningWindow

    anchors {
        top: true; bottom: true; left: true; right: true
    }
    
    exclusionMode: ExclusionMode.Ignore
    color: "#B3000000"
    visible: false

    property bool isCritical: false
    property int shutdownTime: 120

    Timer {
        id: shutdownTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            warningWindow.shutdownTime -= 1
            if (warningWindow.shutdownTime <= 0) {
                running = false
                shutdownProc.running = true
            }
        }
    }

    Process {
        id: shutdownProc
        command: ["shutdown", "now"]
    }

    // Monitor the global battery state
    Connections {
        target: BatteryMonitor
        function onCapacityChanged() { checkBattery() }
        function onPluggedInChanged() { checkBattery() }
        function onStatusChanged() { checkBattery() }
    }

    function checkBattery() {
        if (BatteryMonitor.pluggedIn || BatteryMonitor.status.toLowerCase().includes("charg")) {
            // Cancel everything if plugged in
            warningWindow.visible = false
            shutdownTimer.running = false
            return
        }

        if (BatteryMonitor.capacity <= 5 && !BatteryMonitor.notified5) {
            BatteryMonitor.notified5 = true
            warningWindow.isCritical = true
            warningWindow.shutdownTime = 120
            warningWindow.visible = true
            shutdownTimer.running = true
        } else if (BatteryMonitor.capacity <= 20 && !BatteryMonitor.notified20 && BatteryMonitor.capacity > 5) {
            BatteryMonitor.notified20 = true
            warningWindow.isCritical = false
            warningWindow.visible = true
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 400; height: 220
        radius: 16
        color: Theme.colors.surface
        border.color: Theme.colors.border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: warningWindow.isCritical ? "󰂎 CRITICAL BATTERY" : "󰁺 LOW BATTERY"
                color: Theme.colors.error
                font.pixelSize: 22
                font.bold: true
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: warningWindow.isCritical 
                      ? "Battery is at " + BatteryMonitor.capacity + "%. Please connect charger immediately.\nSystem will automatically shutdown in " + warningWindow.shutdownTime + " seconds."
                      : "Battery is at " + BatteryMonitor.capacity + "%. Please connect charger."
                color: Theme.colors.textPrimary
                font.pixelSize: 16
            }

            Item { Layout.fillHeight: true }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 120; height: 40
                radius: 8
                color: Theme.colors.surfaceContainer
                border.color: Theme.colors.border
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: Theme.colors.textPrimary
                    font.pixelSize: 15
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        warningWindow.visible = false
                        shutdownTimer.running = false
                    }
                }
            }
        }
    }
}
