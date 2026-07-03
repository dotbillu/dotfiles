import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

import "../theme"
import "../services"

PopupWindow {
    id: popup

    property bool popupHovered: false
    readonly property int widgetWidth: 300

    // "main" = output+mic sliders + source pickers
    // "apps" = per-app volume
    property string view: "main"

    width:   widgetWidth
    height:  card.implicitHeight
    visible: false
    color:   "transparent"

    function show() {
        view = "main"
        visible = true; card.opacity = 0; card.scale = 0.97; entryAnim.start()
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

    // Must track objects so Pipewire populates their audio properties
    PwObjectTracker {
        objects: {
            let list = [...Pipewire.nodes.values]
            if (popup.sink)   list.push(popup.sink)
            if (popup.source) list.push(popup.source)
            return list
        }
    }

    // ── audio nodes ───────────────────────────────────────────────────────────
    property var  sink:       Pipewire.defaultAudioSink
    property var  source:     Pipewire.defaultAudioSource

    // Explicit intermediate refs so QML tracks volumesChanged properly
    property var  sinkAudio:   sink   ? sink.audio   : null
    property var  sourceAudio: source ? source.audio : null

    property real sinkVol:    sinkAudio   ? sinkAudio.volume   : 0
    property bool sinkMuted:  sinkAudio   ? sinkAudio.muted    : false
    property real sourceVol:  sourceAudio ? sourceAudio.volume : 0
    property bool sourceMuted: sourceAudio ? sourceAudio.muted : false

    // All audio sinks (hardware output devices)
    property var allSinks: []
    // All audio sources (hardware input devices)
    property var allSources: []
    // Application output streams
    property var appStreams: []

    Timer {
        interval: 250
        running: true
        repeat: true
        onTriggered: {
            let nodes = Pipewire.nodes.values || [];
            let sinks = [];
            let sources = [];
            let apps = [];
            
            for (let i = 0; i < nodes.length; i++) {
                let n = nodes[i];
                if (!n || n.audio === null) continue;
                
                let nName = (n.nickname || n.description || n.name || "").toLowerCase();
                if (nName === "speech-dispatcher" || nName === "xdg-desktop-portal") continue;
                
                if (n.isStream && n.isSink) {
                    apps.push(n);
                } else if (!n.isStream) {
                    if (n.isSink) sinks.push(n);
                    else sources.push(n);
                }
            }
            
            popup.allSinks = sinks;
            popup.allSources = sources;
            popup.appStreams = apps;
        }
    }

    // ── card ──────────────────────────────────────────────────────────────────
    Rectangle {
        id: card
        width:          popup.width
        implicitHeight: mainView.implicitHeight + 20
        transformOrigin: Item.Top
        opacity: 0
        radius:  16
        color:   Theme.colors.surface
        border.color: Theme.colors.border
        border.width: 1

        Behavior on implicitHeight { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

        // ── MAIN VIEW ─────────────────────────────────────────────────────────
        ColumnLayout {
            id: mainView
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors.topMargin: 14; anchors.leftMargin: 14; anchors.rightMargin: 14
            spacing: 10

            // Header
            RowLayout {
                Layout.fillWidth: true
                Text { text: "󰕾  Sound"; color: Theme.colors.textPrimary; font.pixelSize: 13; font.bold: true }
            }

            // ── Output slider ──────────────────────────────────────────
            VolumeRow {
                Layout.fillWidth: true
                icon: popup.sinkMuted ? "󰖁"
                    : popup.sinkVol < 0.33 ? "󰕿"
                    : popup.sinkVol < 0.66 ? "󰖀" : "󰕾"
                iconColor: popup.sinkMuted ? Theme.colors.error : Theme.colors.textPrimary
                label: popup.sink?.nickname || popup.sink?.description || popup.sink?.name || "Output"
                volume: popup.sinkVol
                muted:  popup.sinkMuted
                onMuteToggled: if (popup.sinkAudio) popup.sinkAudio.muted = !popup.sinkAudio.muted
                onVolumeSet: (v) => { if (popup.sinkAudio) popup.sinkAudio.volume = v }
            }

            // ── Mic slider ─────────────────────────────────────────────
            VolumeRow {
                Layout.fillWidth: true
                icon: popup.sourceMuted ? "󰍭" : "󰍬"
                iconColor: popup.sourceMuted ? Theme.colors.error : Theme.colors.textPrimary
                label: popup.source?.nickname || popup.source?.description || popup.source?.name || "Microphone"
                volume: popup.sourceVol
                muted:  popup.sourceMuted
                accentColor: Theme.colors.accentMuted
                onMuteToggled: if (popup.sourceAudio) popup.sourceAudio.muted = !popup.sourceAudio.muted
                onVolumeSet: (v) => { if (popup.sourceAudio) popup.sourceAudio.volume = v }
            }

            // ── Divider ────────────────────────────────────────────────
            Rectangle { 
                Layout.fillWidth: true; height: 1; color: Theme.colors.border 
                visible: popup.appStreams.length > 0
            }

            // ── App stream list ────────────────────────────────────────
            Text { 
                text: "Applications"; color: Theme.colors.textPrimary; font.pixelSize: 10; font.bold: true; topPadding: 2
                visible: popup.appStreams.length > 0
            }

            Repeater {
                model: popup.appStreams
                delegate: VolumeRow {
                    required property var modelData
                    Layout.fillWidth: true
                    
                    property string appName: {
                        if (modelData.client && modelData.client.properties) {
                            if (modelData.client.properties["application.process.binary"]) return modelData.client.properties["application.process.binary"];
                            if (modelData.client.properties["application.name"]) return modelData.client.properties["application.name"];
                        }
                        if (modelData.properties && modelData.properties["application.name"]) return modelData.properties["application.name"];
                        let name = modelData.nickname || modelData.description || modelData.name || "";
                        
                        // Heuristic fallback: audio-src on Linux is overwhelmingly Spotify's CEF wrapper
                        if (name.toLowerCase() === "audio-src") {
                            if (typeof Mpris !== "undefined" && Mpris.players && Mpris.players.values) {
                                let mprisPlayers = Mpris.players.values;
                                for (let i = 0; i < mprisPlayers.length; i++) {
                                    if (mprisPlayers[i] && mprisPlayers[i].identity && mprisPlayers[i].identity.toLowerCase().includes("spotify")) {
                                        return "spotify";
                                    }
                                }
                            }
                        }
                        return name;
                    }
                    property string mediaName: modelData.properties ? (modelData.properties["media.name"] || "") : ""
                    
                    icon:      "󰓃"
                    imageIcon: AppIcons.iconSource(appName)
                    iconColor: Theme.colors.textSecondary
                    label: {
                        // 1. Check MPRIS first for rich track titles (e.g. Spotify)
                        if (typeof Mpris !== "undefined" && Mpris.players && Mpris.players.values) {
                            let mprisPlayers = Mpris.players.values;
                            for (let i = 0; i < mprisPlayers.length; i++) {
                                let mp = mprisPlayers[i];
                                if (mp && mp.identity && mp.trackTitle) {
                                    let mIdent = mp.identity.toLowerCase();
                                    let aIdent = appName.toLowerCase();
                                    if (mIdent === aIdent || mIdent.includes(aIdent) || aIdent.includes(mIdent)) {
                                        let t = String(mp.trackTitle).trim();
                                        if (t !== "" && t !== "null" && t !== "undefined") {
                                            return t;
                                        }
                                    }
                                }
                            }
                        }

                        // 2. Fallback to Pipewire native properties (e.g. Brave)
                        let m = mediaName.trim();
                        let a = appName.trim();
                        if (m !== "" && m !== a && m !== "AudioStream") {
                            return m;
                        }
                        return a || "Unknown App";
                    }
                    volume:    modelData.audio?.volume ?? 0
                    muted:     modelData.audio?.muted  ?? false
                    onMuteToggled: if (modelData.audio) modelData.audio.muted = !modelData.audio.muted
                    onVolumeSet: (v) => { if (modelData.audio) modelData.audio.volume = v }
                }
            }

            // ── Divider ────────────────────────────────────────────────
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.colors.border }

            // ── Output device picker ───────────────────────────────────
            Text { text: "Output Device"; color: Theme.colors.textPrimary; font.pixelSize: 10; font.bold: true }

            Repeater {
                model: popup.allSinks
                delegate: DeviceRow {
                    required property var modelData
                    Layout.fillWidth: true
                    label:    modelData.nickname || modelData.description || modelData.name
                    selected: popup.sink?.id === modelData.id
                    onPickDevice: Pipewire.preferredDefaultAudioSink = modelData
                }
            }

            // ── Input device picker ────────────────────────────────────
            Text { text: "Input Device"; color: Theme.colors.textPrimary; font.pixelSize: 10; font.bold: true; topPadding: 2 }

            Repeater {
                model: popup.allSources
                delegate: DeviceRow {
                    required property var modelData
                    Layout.fillWidth: true
                    label:    modelData.nickname || modelData.description || modelData.name
                    selected: popup.source?.id === modelData.id
                    onPickDevice: Pipewire.preferredDefaultAudioSource = modelData
                }
            }

            Item { height: 2 }
        }
    }

    // ── Reusable: volume row ───────────────────────────────────────────────────
    component VolumeRow : ColumnLayout {
        id: vrow
        property string icon:        "󰕾"
        property color  iconColor:   Theme.colors.textPrimary
        property string label:       ""
        property real   volume:      0
        property bool   muted:       false
        property color  accentColor: Theme.colors.accent
        property string imageIcon:   ""

        signal muteToggled()
        signal volumeSet(real v)

        spacing: 4

        RowLayout {
            Layout.fillWidth: true; spacing: 6

            // Mute / icon button
            Rectangle {
                width: 28; height: 28; radius: 14
                color: iconBtn.containsMouse ? Theme.colors.overlayLight : "transparent"
                Behavior on color { ColorAnimation { duration: 100 } }
                
                Image {
                    id: imgIcon
                    anchors.centerIn: parent
                    width: 14; height: 14
                    source: vrow.imageIcon
                    visible: status === Image.Ready && vrow.imageIcon !== ""
                    smooth: true; mipmap: true
                }
                
                Text {
                    anchors.centerIn: parent
                    text: vrow.icon
                    font.pixelSize: 14
                    color: vrow.iconColor
                    visible: imgIcon.status !== Image.Ready || vrow.imageIcon === ""
                }
                
                MouseArea {
                    id: iconBtn; anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    onClicked: vrow.muteToggled()
                }
            }

            Text {
                Layout.fillWidth: true
                text:  vrow.label; elide: Text.ElideRight
                color: Theme.colors.textPrimary; font.pixelSize: 12; font.bold: true
            }

            Text {
                text:  Math.round(vrow.volume * 100) + "%"
                color: Theme.colors.textMuted; font.pixelSize: 11
                Layout.minimumWidth: 32; horizontalAlignment: Text.AlignRight
            }
        }

        // Slider
        Item {
            Layout.fillWidth: true; height: 20

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width; height: 4; radius: 2
                color: Theme.colors.overlayLight

                Rectangle {
                    width:  Math.min(parent.width * vrow.volume, parent.width)
                    height: parent.height; radius: parent.radius
                    color:  vrow.muted ? Theme.colors.textMuted : vrow.accentColor
                    Behavior on width { SmoothedAnimation { velocity: 300 } }
                }
            }

            // Thumb
            Rectangle {
                id: thumb
                x: Math.min(parent.width * vrow.volume, parent.width) - width / 2
                anchors.verticalCenter: parent.verticalCenter
                width: 14; height: 14; radius: 7
                color: Theme.colors.textPrimary
                scale: sliderArea.pressed ? 1.2 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
                Behavior on x { SmoothedAnimation { velocity: 300 } }
            }

            MouseArea {
                id: sliderArea
                anchors.fill: parent; cursorShape: Qt.SizeHorCursor
                onPressed:       vrow.volumeSet(Math.max(0, Math.min(1, mouseX / width)))
                onPositionChanged: if (pressed) vrow.volumeSet(Math.max(0, Math.min(1, mouseX / width)))
            }
        }
    }

    // ── Reusable: device row ───────────────────────────────────────────────────
    component DeviceRow : Rectangle {
        id: drow
        property string label:    ""
        property bool   selected: false
        signal pickDevice()

        implicitHeight: dRowLayout.implicitHeight + 8
        radius: 8
        color: selected ? Theme.colors.overlayLight
             : dArea.containsMouse ? "#11FFFFFF" : "transparent"
        Behavior on color { ColorAnimation { duration: 100 } }

        RowLayout {
            id: dRowLayout
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
            anchors.leftMargin: 8; anchors.rightMargin: 8
            spacing: 8

            Rectangle {
                width: 8; height: 8; radius: 4
                color: drow.selected ? Theme.colors.accent : Theme.colors.textMuted
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Text {
                Layout.fillWidth: true
                text:  drow.label; elide: Text.ElideRight
                color: drow.selected ? Theme.colors.textPrimary : Theme.colors.textSecondary
                font.pixelSize: 12
            }
        }

        MouseArea {
            id: dArea; anchors.fill: parent
            cursorShape: Qt.PointingHandCursor; hoverEnabled: true
            enabled: !drow.selected
            onClicked: drow.pickDevice()
        }
    }
}
