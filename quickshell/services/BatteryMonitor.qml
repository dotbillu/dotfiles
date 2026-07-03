pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property int capacity: 100
    property string status: "Full"
    property bool pluggedIn: true

    property bool notified20: false
    property bool notified5: false

    Process {
        id: batProc
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100; cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Full; cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n1 || echo 0"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                if (lines.length >= 2) {
                    root.capacity = parseInt(lines[0].trim()) || 0
                    root.status = lines[1].trim()
                }
                if (lines.length >= 3) {
                    root.pluggedIn = (lines[2].trim() === "1")
                }
                
                // Reset flags when plugged in or charging
                if (root.pluggedIn || root.status.toLowerCase().includes("charg")) {
                    root.notified20 = false
                    root.notified5 = false
                }
            }
        }
    }

    Timer {
        id: updateTimer
        interval: 15000
        running: true
        repeat: true
        onTriggered: {
            if (!batProc.running) batProc.running = true
        }
    }

    Component.onCompleted: batProc.running = true
}
