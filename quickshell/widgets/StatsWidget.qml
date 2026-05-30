import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../theme"

PopupWindow {
    id: popup

    property bool popupHovered: false
    
    // Modern widescreen layout
    readonly property int widgetWidth: 480
    property int screenHeight: Quickshell.screens[0] ? Quickshell.screens[0].height : 1080

    width: widgetWidth
    height: card.implicitHeight
    visible: false
    color: "transparent"

    function show() {
        visible = true
        card.opacity = 0
        card.scale = 0.98
        entryAnim.start()
        updateStatsTimer.restart()
        recordingCheckTimer.start()
        detectMonitors()
    }
    function hide() {
        exitAnim.start()
        updateStatsTimer.stop()
        recordingCheckTimer.stop()
        showMonitorMenu = false
    }

    ParallelAnimation {
        id: entryAnim
        NumberAnimation { target: card; property: "opacity"; to: 1;   duration: 200; easing.type: Easing.OutCubic }
        NumberAnimation { target: card; property: "scale";   to: 1.0; duration: 200; easing.type: Easing.OutCubic }
    }
    SequentialAnimation {
        id: exitAnim
        ParallelAnimation {
            NumberAnimation { target: card; property: "opacity"; to: 0;    duration: 150; easing.type: Easing.InCubic }
            NumberAnimation { target: card; property: "scale";   to: 0.98; duration: 150; easing.type: Easing.InCubic }
        }
        ScriptAction { script: popup.visible = false }
    }

    HoverHandler { onHoveredChanged: popup.popupHovered = hovered }

    // Live Stats Properties
    property string uptime: "0:00"
    property real cpuUsage: 0.0
    property real ramUsage: 0.0
    property string ramText: "0 GB / 0 GB"
    property real diskUsage: 0.0
    property string diskText: "0 GB / 0 GB"
    property real tempValue: 0.0
    property string hostnameText: "arch"

    // GPU stats
    property real gpuUsage: 0.0
    property real gpuTemp: 0.0

    // Battery / Power stats
    property real batLevel: 1.0
    property string batStatus: "Full"

    // Recording State Tracker
    property bool isRecording: false
    property bool showMonitorMenu: false
    property var monitorsList: []

    // Monitor detection process
    Process {
        id: monitorDetectProc
        command: ["bash", "-c", "hyprctl monitors -j | jq -r '.[].name' 2>/dev/null || hyprctl monitors | grep 'Monitor' | awk '{print $2}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let textLines = this.text.trim().split("\n")
                let validMonitors = []
                for (let i = 0; i < textLines.length; i++) {
                    let mName = textLines[i].trim()
                    if (mName !== "") validMonitors.push(mName)
                }
                if (validMonitors.length === 0) {
                    validMonitors = ["eDP-1"]
                }
                popup.monitorsList = validMonitors
            }
        }
    }

    function detectMonitors() {
        if (!monitorDetectProc.running) {
            monitorDetectProc.running = true
        }
    }

    // Stats updating process
    Process {
        id: statsProc
        command: ["bash", "-c", "echo \"$(uptime -p | sed 's/up //')\"; echo \"$(grep 'cpu ' /proc/stat)\"; echo \"$(free -m | grep Mem)\"; echo \"$(df -m / | tail -n 1)\"; echo \"$(cat /sys/class/thermal/thermal_zone6/temp 2>/dev/null || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0)\"; echo \"$HOSTNAME\"; nvidia-smi --query-gpu=temperature.gpu,utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo \"none\"; cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100; cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Full"]
        
        property real prevIdle: 0
        property real prevTotal: 0

        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                if (lines.length < 8) return

                popup.uptime = lines[0].trim()

                // CPU
                let cpuParts = lines[1].trim().split(/\s+/)
                if (cpuParts.length >= 5) {
                    let user = parseInt(cpuParts[1])
                    let nice = parseInt(cpuParts[2])
                    let system = parseInt(cpuParts[3])
                    let idle = parseInt(cpuParts[4])
                    let iowait = cpuParts[5] ? parseInt(cpuParts[5]) : 0
                    let irq = cpuParts[6] ? parseInt(cpuParts[6]) : 0
                    let softirq = cpuParts[7] ? parseInt(cpuParts[7]) : 0
                    let steal = cpuParts[8] ? parseInt(cpuParts[8]) : 0

                    let total = user + nice + system + idle + iowait + irq + softirq + steal
                    let diffIdle = idle - statsProc.prevIdle
                    let diffTotal = total - statsProc.prevTotal

                    if (diffTotal > 0) {
                        popup.cpuUsage = 1.0 - (diffIdle / diffTotal)
                    }
                    statsProc.prevIdle = idle
                    statsProc.prevTotal = total
                }

                // RAM
                let memParts = lines[2].trim().split(/\s+/)
                if (memParts.length >= 3) {
                    let totalMem = parseInt(memParts[1])
                    let usedMem = parseInt(memParts[2])
                    popup.ramUsage = usedMem / totalMem
                    popup.ramText = (usedMem / 1024).toFixed(1) + "G / " + (totalMem / 1024).toFixed(1) + "G"
                }

                // Disk
                let dfParts = lines[3].trim().split(/\s+/)
                if (dfParts.length >= 4) {
                    let totalDisk = parseInt(dfParts[1])
                    let usedDisk = parseInt(dfParts[2])
                    popup.diskUsage = usedDisk / totalDisk
                    popup.diskText = (usedDisk / 1024).toFixed(0) + "G / " + (totalDisk / 1024).toFixed(0) + "G"
                }

                // Temp
                let rawTemp = parseInt(lines[4].trim())
                popup.tempValue = rawTemp / 1000.0

                popup.hostnameText = lines[5].trim()

                // GPU
                if (lines[6]) {
                    let gpuLine = lines[6].trim()
                    if (gpuLine !== "none" && gpuLine !== "") {
                        let gparts = gpuLine.split(",")
                        if (gparts.length >= 2) {
                            popup.gpuTemp = parseFloat(gparts[0].trim())
                            popup.gpuUsage = parseFloat(gparts[1].trim()) / 100.0
                        }
                    } else {
                        popup.gpuUsage = 0.0
                        popup.gpuTemp = 0.0
                    }
                }

                // Battery Status
                popup.batLevel = parseFloat(lines[7].trim()) / 100.0
                popup.batStatus = lines[8].trim()
            }
        }
    }

    Timer {
        id: updateStatsTimer
        interval: 1500
        repeat: true
        running: false
        onTriggered: if (!statsProc.running) statsProc.running = true
    }

    // Checking recording status (wf-recorder)
    Process {
        id: checkRecProc
        command: ["pgrep", "wf-recorder"]
        stdout: StdioCollector {
            onStreamFinished: {
                popup.isRecording = this.text.trim().length > 0
            }
        }
    }

    Timer {
        id: recordingCheckTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: if (!checkRecProc.running) checkRecProc.running = true
    }

    // Process executor for starting recording (independent of quickshell lifecycle)
    Process {
        id: recordStartProc
    }

    // Process executor for stopping recording
    Process {
        id: recordStopProc
    }

    // Process executor for other general tools
    Process {
        id: toolRunner
    }

    // Function to run a tool command and pipe its stdout directly to the clipboard
    function runToolAndCopy(commandText) {
        toolRunner.command = ["bash", "-c", commandText]
        toolRunner.startDetached()
    }

    // Screen Recording Activation Function
    function startRecording(monitorName) {
        let filename = "$HOME/recording_" + Math.floor(Date.now() / 1000) + ".mp4"
        recordStartProc.command = ["bash", "-c", "notify-send -a \"System Control\" \"Recording Started\" \"Capturing display " + monitorName + "...\" -i video-single-exporter && wf-recorder -o " + monitorName + " -f " + filename]
        recordStartProc.startDetached() // Keep it alive in the background detached!
        
        popup.isRecording = true
        popup.showMonitorMenu = false
        
        // Immediate status recheck in 200ms
        statusCheckDelay.restart()
    }

    function stopRecording() {
        recordStopProc.command = ["bash", "-c", "killall -INT wf-recorder && notify-send -a \"System Control\" \"Recording Saved\" \"Screen capture has been stored in your home directory.\" -i video-x-generic"]
        recordStopProc.running = true
        
        popup.isRecording = false
        
        // Immediate status recheck in 300ms
        statusCheckDelay.restart()
    }

    Timer {
        id: statusCheckDelay
        interval: 300
        repeat: false
        running: false
        onTriggered: if (!checkRecProc.running) checkRecProc.running = true
    }

    // System utility tools model
    property var quickTools: [
        { icon: "󰈊", color: "#B4BEFE", label: "Picker", action: "hyprpicker | wl-copy --trim-newline" },
        { icon: "󰑊", color: "#A6E3A1", label: "Record", action: "toggleRecording" }
    ]


    Rectangle {
        id: card
        width: popup.width
        implicitHeight: col.implicitHeight + 48

        transformOrigin: Item.Top
        opacity: 0
        radius: 20
        color: Theme.colors.surfaceContainer
        border.color: Theme.colors.border
        border.width: 1

        // Flat top edge touching the status bar
        topLeftRadius: 4
        topRightRadius: 20
        bottomLeftRadius: 20
        bottomRightRadius: 20

        ColumnLayout {
            id: col
            anchors.fill: parent
            anchors.leftMargin: 24; anchors.rightMargin: 24; anchors.topMargin: 24; anchors.bottomMargin: 24
            spacing: 20

            // ── TOP HEADER (With circular profile pic avatar!) ─────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Glow logo ring containing profile picture
                Rectangle {
                    width: 48; height: 48; radius: 24
                    color: "transparent"
                    clip: true

                    Image {
                        anchors.fill: parent
                        source: "../assets/dexterprofile.jpeg"
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        mipmap: true
                    }
                }

                ColumnLayout {
                    spacing: 1
                    Text {
                        text: "Dotbillu"
                        color: Theme.colors.textPrimary
                        font.pixelSize: 15; font.bold: true
                    }
                    Text {
                        text: "UPTIME • " + popup.uptime.toUpperCase()
                        color: Theme.colors.textMuted
                        font.pixelSize: 10; font.bold: true
                    }
                }

                Item { Layout.fillWidth: true }

                // System Actions: Sleep, Lock, Reboot, Shutdown
                RowLayout {
                    spacing: 4
                    
                    TextButton {
                        icon: "󰤄"
                        accentColor: "#B4BEFE"
                        action: "systemctl suspend"
                    }
                    TextButton {
                        icon: "󰌾"
                        accentColor: "#F9E2AF"
                        action: "hyprlock || swaylock || loginctl lock-session"
                    }
                    TextButton {
                        icon: "󰑓"
                        accentColor: "#A6E3A1"
                        action: "systemctl reboot"
                    }
                    TextButton {
                        icon: "󰐥"
                        accentColor: "#F38BA8"
                        action: "systemctl poweroff"
                    }
                }
            }

            // ── SYSTEM UTILITIES & MONITOR SELECTION ──────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: "SYSTEM UTILITIES"
                    color: Theme.colors.textMuted
                    font.pixelSize: 10; font.bold: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    Layout.alignment: Qt.AlignLeft

                    Repeater {
                        model: popup.quickTools
                        delegate: Rectangle {
                            required property var modelData
                            implicitWidth: 48; implicitHeight: 48; radius: 24
                            color: btnMouse.containsMouse ? Theme.colors.overlayLight : Theme.colors.surface
                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.action === "toggleRecording" && popup.isRecording ? "󰑋" : modelData.icon
                                font.pixelSize: 20
                                color: modelData.action === "toggleRecording" && popup.isRecording ? Theme.colors.error : (btnMouse.containsMouse ? modelData.color : Theme.colors.textSecondary)
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }

                            MouseArea {
                                id: btnMouse
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                                onClicked: {
                                    if (modelData.action === "toggleRecording") {
                                        if (popup.isRecording) {
                                            popup.stopRecording()
                                        } else {
                                            popup.showMonitorMenu = !popup.showMonitorMenu
                                        }
                                    } else {
                                        popup.showMonitorMenu = false
                                        popup.runToolAndCopy(modelData.action)
                                    }
                                }
                            }
                        }
                    }
                }

                // ── Monitor Selection popup ─────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    visible: popup.showMonitorMenu && !popup.isRecording
                    spacing: 8

                    Text {
                        text: "SELECT MONITOR TO RECORD"
                        color: Theme.colors.accent
                        font.pixelSize: 9; font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: popup.monitorsList
                            delegate: Rectangle {
                                required property var modelData
                                implicitWidth: textMonitor.implicitWidth + 24
                                implicitHeight: 28
                                radius: 8
                                color: monMouse.containsMouse ? Theme.colors.overlayLight : Theme.colors.surface

                                Text {
                                    id: textMonitor
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: monMouse.containsMouse ? Theme.colors.accent : Theme.colors.textSecondary
                                    font.pixelSize: 11
                                    font.bold: true
                                }

                                MouseArea {
                                    id: monMouse
                                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                                    onClicked: {
                                        popup.startRecording(modelData)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── QUICK DIRECTORIES SECTION ────────────────────────────
            ColumnLayout {
                spacing: 12
                Layout.fillWidth: true

                Text {
                    text: "QUICK DIRECTORIES"
                    color: Theme.colors.textMuted
                    font.pixelSize: 10; font.bold: true
                }

                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    DirBtn { Layout.fillWidth: true; label: "Downloads"; path: "/home/abhay/Downloads" }
                    DirBtn { Layout.fillWidth: true; label: "Desktop";   path: "/home/abhay/Desktop" }
                    DirBtn { Layout.fillWidth: true; label: "Pictures";  path: "/home/abhay/Pictures" }
                    DirBtn { Layout.fillWidth: true; label: "Videos";    path: "/home/abhay/Videos" }
                }
            }


            // ── LARGE MODERN PROGRESS STATS ────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 18

                Text {
                    text: "SYSTEM METRICS"
                    color: Theme.colors.textMuted
                    font.pixelSize: 10; font.bold: true
                }

                // CPU
                LargeStatBar {
                    Layout.fillWidth: true
                    title: "CPU (" + popup.tempValue.toFixed(0) + "°C)"
                    value: Math.round(popup.cpuUsage * 100) + "%"
                    progress: popup.cpuUsage
                    accentColor: Theme.colors.accent
                    icon: "󰍛"
                }

                // Memory
                LargeStatBar {
                    Layout.fillWidth: true
                    title: "RAM"
                    value: popup.ramText
                    progress: popup.ramUsage
                    accentColor: Theme.colors.accentStrong
                    icon: "󰘚"
                }

                // GPU
                LargeStatBar {
                    Layout.fillWidth: true
                    title: popup.gpuTemp > 0 ? "GPU (" + popup.gpuTemp.toFixed(0) + "°C)" : "GPU"
                    value: popup.gpuUsage > 0.00 ? Math.round(popup.gpuUsage * 100) + "%" : "0%"
                    progress: popup.gpuUsage > 0 ? popup.gpuUsage : 0.01 // give a tiny progress so it's not invisible
                    accentColor: "#F38BA8"
                    icon: "󰢮"
                }

                // Storage
                LargeStatBar {
                    Layout.fillWidth: true
                    title: "DISK"
                    value: popup.diskText
                    progress: popup.diskUsage
                    accentColor: Theme.colors.accent
                    icon: "󰋊"
                }
            }

            // Removed decorative subtext footer
        }
    }

    // Custom Component: Action System Buttons (Lock, Sleep, Reboot, Shutdown)
    component TextButton: Rectangle {
        property string icon: ""
        property string accentColor: ""
        property string action: ""
        implicitWidth: 32; implicitHeight: 32; radius: 16
        color: tbMouse.containsMouse ? Theme.colors.overlayLight : Theme.colors.surface
        Behavior on color { ColorAnimation { duration: 150 } }

        Text {
            anchors.centerIn: parent
            text: parent.icon
            font.pixelSize: 16
            color: tbMouse.containsMouse ? parent.accentColor : Theme.colors.textSecondary
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea {
            id: tbMouse
            anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
            onClicked: {
                popup.runToolAndCopy(parent.action)
                popup.hide()
            }
        }
    }

    // Custom Component: App Shortcut buttons (Spotify/Discord toggle)
    component AppShortcutBtn: Rectangle {
        property string icon: ""
        property string label: ""
        property string accentColor: ""
        property string action: ""

        implicitHeight: 38
        radius: 8
        color: appbMouse.containsMouse ? Theme.colors.overlayLight : Theme.colors.surface
        Behavior on color { ColorAnimation { duration: 150 } }

        RowLayout {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: icon
                font.pixelSize: 16
                color: appbMouse.containsMouse ? parent.accentColor : Theme.colors.textSecondary
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Text {
                text: label
                font.pixelSize: 12; font.bold: true
                color: appbMouse.containsMouse ? Theme.colors.textPrimary : Theme.colors.textSecondary
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        MouseArea {
            id: appbMouse
            anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
            onClicked: {
                popup.runToolAndCopy(parent.action)
                popup.hide()
            }
        }
    }

    // Custom Component: Directory buttons
    component DirBtn: Rectangle {
        property string label: ""
        property string path: ""

        implicitHeight: 32
        radius: 6
        color: dirbMouse.containsMouse ? Theme.colors.overlayLight : Theme.colors.surface
        Behavior on color { ColorAnimation { duration: 150 } }

        Text {
            anchors.centerIn: parent
            text: parent.label
            font.pixelSize: 11; font.bold: true
            color: dirbMouse.containsMouse ? Theme.colors.textPrimary : Theme.colors.textSecondary
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea {
            id: dirbMouse
            anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
            onClicked: {
                popup.runToolAndCopy("xdg-open " + parent.path)
                popup.hide()
            }
        }
    }

    // Custom Component: Large Stat Bar
    component LargeStatBar: ColumnLayout {
        id: lStat
        property string title: ""
        property string value: ""
        property real progress: 0.0
        property color accentColor: Theme.colors.accent
        property string icon: ""

        Layout.fillWidth: true
        spacing: 4

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text { 
                text: lStat.icon
                font.pixelSize: 16
                color: Theme.colors.textSecondary
                Layout.preferredWidth: 24
            }
            Text { 
                text: lStat.title
                color: Theme.colors.textPrimary
                font.pixelSize: 13
                font.bold: true
                Layout.preferredWidth: 60
            }
            Item { Layout.fillWidth: true }
            Text {
                text: lStat.value
                color: Theme.colors.textPrimary
                font.pixelSize: 12
                font.bold: true
                horizontalAlignment: Text.AlignRight
            }
        }

        Rectangle {
            id: barBg
            Layout.fillWidth: true; height: 12; radius: 6
            color: Theme.colors.overlayLight

            Rectangle {
                width: Math.max(0, Math.min(barBg.width * lStat.progress, barBg.width))
                height: parent.height; radius: parent.radius
                color: lStat.accentColor
                Behavior on width { SmoothedAnimation { velocity: 150 } }
            }
        }
    }
}
