pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property real intBright: 1.0
    property real extBright: 0.5
    property bool extSupported: true

    property bool sunsetEnabled: false
    property real sunsetTemp: 4500 // Min 2000, Max 8000

    Process {
        id: fetchProc
        command: [
            "bash", "-c", 
            "echo $(brightnessctl -m | awk -F, '{print $4}' | sed 's/%//'); ddcutil --display 1 getvcp 10 --terse 2>/dev/null | awk '{print $4}' || echo 'none'; ps -eo cmd | grep '[h]yprsunset' | sed -n 's/.*-t \\([0-9]*\\).*/\\1/p' | head -n 1"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                if (lines[0]) root.intBright = parseInt(lines[0]) / 100.0
                if (lines[1]) {
                    let v = lines[1].trim()
                    if (v === "none" || v === "") {
                        root.extSupported = false
                    } else {
                        root.extSupported = true
                        root.extBright = parseInt(v) / 100.0
                    }
                }
                if (lines[2] && lines[2].trim() !== "") {
                    root.sunsetEnabled = true
                    root.sunsetTemp = parseInt(lines[2].trim())
                } else {
                    root.sunsetEnabled = false
                }
            }
        }
    }

    Timer {
        id: updateTimer
        interval: 10000; repeat: true; running: true
        onTriggered: if (!fetchProc.running) fetchProc.running = true
    }

    Component.onCompleted: fetchProc.running = true

    Process { id: intExec }
    Process { id: extExec }
    Process { id: sunsetExec }

    function setIntBright(pct) {
        root.intBright = pct
        let val = Math.round(pct * 100)
        intExec.command = ["bash", "-c", "brightnessctl s " + val + "%"]
        if (!intExec.running) intExec.running = true
    }

    function setExtBright(pct) {
        root.extBright = pct
        let val = Math.round(pct * 100)
        extExec.command = ["bash", "-c", "ddcutil --display 1 setvcp 10 " + val]
        if (!extExec.running) extExec.running = true
    }

    function toggleSunset() {
        root.sunsetEnabled = !root.sunsetEnabled
        root.applySunset()
    }

    function setSunsetTemp(t) {
        root.sunsetTemp = t
        if (root.sunsetEnabled) root.applySunset()
    }

    function applySunset() {
        sunsetExec.running = false
        if (root.sunsetEnabled) {
            let t = Math.round(root.sunsetTemp)
            sunsetExec.command = ["hyprsunset", "-t", t.toString()]
            sunsetExec.running = true
        }
    }
}
