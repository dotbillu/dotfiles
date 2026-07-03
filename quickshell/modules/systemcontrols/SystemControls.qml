import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Io

import "../../theme"
import "../../widgets"
import "../../services"
import "../battery"

// One shared pill island containing WiFi + Bluetooth + Sound
Rectangle {
    id: root

    property var panelWindow: null
    property int barScreenX: 0

    implicitHeight: 40
    implicitWidth: row.implicitWidth + 20
    radius: 20
    color: Theme.colors.surface

    // ── shared state ──────────────────────────────────────────────────────────

    // WiFi
    property var wifiDevice: {
        let devs = Networking.devices.values;
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wifi)
                return devs[i];
        }
        return null;
    }
    property bool wifiConnected: {
        if (!wifiDevice)
            return false;
        let nets = wifiDevice.networks.values;
        return nets.some(n => n.connected);
    }
    property real wifiSignal: {
        if (!wifiDevice)
            return 0;
        let nets = wifiDevice.networks.values;
        let c = nets.find(n => n.connected);
        return c?.signalStrength ?? 0;
    }

    // Bluetooth
    property var btAdapter: Bluetooth.defaultAdapter
    property bool btOn: btAdapter?.enabled ?? false
    property bool btHasConn: (btAdapter?.devices?.values ?? []).some(d => d.connected)

    // Sound
    property var sink: Pipewire.defaultAudioSink
    property var sinkAudio: sink ? sink.audio : null
    property real sinkVol: sinkAudio ? sinkAudio.volume : 0
    property bool sinkMute: sinkAudio ? sinkAudio.muted : false

    // Battery state now handled by global BatteryMonitor

    // Which widget is open (only one at a time)
    property string openWidget: ""  // "wifi" | "bt" | "sound" | "battery" | ""

    function openOnly(name) {
        if (openWidget === name) {
            openWidget = "";
            wifiWidget.hide();
            btWidget.hide();
            soundWidget.hide();
            batteryWidget.hide();
        } else {
            openWidget = name;
            if (name !== "wifi")
                wifiWidget.hide();
            if (name !== "bt")
                btWidget.hide();
            if (name !== "sound")
                soundWidget.hide();
            if (name !== "battery")
                batteryWidget.hide();
            if (name === "wifi") {
                wifiWidget.show();
            }
            if (name === "bt") {
                btWidget.show();
            }
            if (name === "sound") {
                soundWidget.show();
            }
            if (name === "battery") {
                batteryWidget.show();
            }
        }
    }

    // ── island row ────────────────────────────────────────────────────────────
    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 0

        // ── WiFi button ──────────────────────────────────────────────────────
        Item {
            id: wifiBtn
            implicitWidth: 38
            implicitHeight: 38
            Layout.alignment: Qt.AlignVCenter

            Text {
                anchors.centerIn: parent
                font.pixelSize: 15
                color: root.wifiConnected ? Theme.colors.accent : Theme.colors.textMuted
                text: {
                    if (!Networking.wifiEnabled)
                        return "󰖪";
                    let s = root.wifiSignal;
                    if (s > 0.75)
                        return "󰤨";
                    if (s > 0.5)
                        return "󰤥";
                    if (s > 0.25)
                        return "󰤢";
                    if (s > 0)
                        return "󰤟";
                    return "󰤭";
                }
            }
            // Disconnected dot
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 9
                anchors.rightMargin: 6
                width: 5
                height: 5
                radius: 3
                color: Theme.colors.error
                visible: Networking.wifiEnabled && !root.wifiConnected
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openOnly("wifi")
            }
        }

        // ── Separator ────────────────────────────────────────────────────────
        Rectangle {
            width: 1
            height: 18
            color: Theme.colors.border
            opacity: 0.5
            Layout.alignment: Qt.AlignVCenter
        }

        // ── Bluetooth button ─────────────────────────────────────────────────
        Item {
            id: btBtnItem
            implicitWidth: 38
            implicitHeight: 38
            Layout.alignment: Qt.AlignVCenter

            Text {
                anchors.centerIn: parent
                font.pixelSize: 15
                color: root.btHasConn ? Theme.colors.accent : Theme.colors.textMuted
                text: !root.btOn ? "󰂲" : root.btHasConn ? "󰂱" : "󰂰"
            }
            // Connected dot
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 9
                anchors.rightMargin: 6
                width: 5
                height: 5
                radius: 3
                color: Theme.colors.accent
                visible: root.btHasConn
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openOnly("bt")
            }
        }

        // ── Separator ────────────────────────────────────────────────────────
        Rectangle {
            width: 1
            height: 18
            color: Theme.colors.border
            opacity: 0.5
            Layout.alignment: Qt.AlignVCenter
        }

        // ── Sound button ─────────────────────────────────────────────────────
        Item {
            id: soundBtnItem
            implicitWidth: 38
            implicitHeight: 38
            Layout.alignment: Qt.AlignVCenter

            Text {
                anchors.centerIn: parent
                font.pixelSize: 15
                color: root.sinkMute ? Theme.colors.textMuted : Theme.colors.textPrimary
                text: {
                    if (root.sinkMute || root.sinkVol === 0)
                        return "󰖁";
                    if (root.sinkVol < 0.33)
                        return "󰕿";
                    if (root.sinkVol < 0.66)
                        return "󰖀";
                    return "󰕾";
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openOnly("sound")
            }
        }

        // ── Separator ────────────────────────────────────────────────────────
        Rectangle {
            width: 1
            height: 18
            color: Theme.colors.border
            opacity: 0.5
            Layout.alignment: Qt.AlignVCenter
        }

        // ── Battery button ───────────────────────────────────────────────────
        Item {
            id: batteryBtnItem
            implicitWidth: batteryRow.implicitWidth + 24
            implicitHeight: 38
            Layout.alignment: Qt.AlignVCenter

            Row {
                id: batteryRow
                anchors.centerIn: parent
                spacing: 2

                Text {
                    font.pixelSize: 15
                    color: {
                        let charging = (BatteryMonitor.pluggedIn || BatteryMonitor.status.toLowerCase().includes("charg")) && BatteryMonitor.capacity < 100;
                        return charging ? Theme.colors.accentStrong : (BatteryMonitor.capacity <= 20 ? Theme.colors.error : Theme.colors.textPrimary);
                    }
                    text: {
                        let charging = (BatteryMonitor.pluggedIn || BatteryMonitor.status.toLowerCase().includes("charg")) && BatteryMonitor.capacity < 100;
                        if (charging) {
                            if (BatteryMonitor.capacity > 90)
                                return "󰂅";
                            if (BatteryMonitor.capacity > 80)
                                return "󰂋";
                            if (BatteryMonitor.capacity > 70)
                                return "󰂊";
                            if (BatteryMonitor.capacity > 60)
                                return "󰢞";
                            if (BatteryMonitor.capacity > 50)
                                return "󰂉";
                            if (BatteryMonitor.capacity > 40)
                                return "󰢝";
                            if (BatteryMonitor.capacity > 30)
                                return "󰂈";
                            if (BatteryMonitor.capacity > 20)
                                return "󰂇";
                            if (BatteryMonitor.capacity > 10)
                                return "󰂆";
                            return "󰢜";
                        }
                        if (BatteryMonitor.capacity >= 100)
                            return "󰁹";
                        if (BatteryMonitor.capacity > 90)
                            return "󰂂";
                        if (BatteryMonitor.capacity > 80)
                            return "󰂁";
                        if (BatteryMonitor.capacity > 70)
                            return "󰂀";
                        if (BatteryMonitor.capacity > 60)
                            return "󰁿";
                        if (BatteryMonitor.capacity > 50)
                            return "󰁾";
                        if (BatteryMonitor.capacity > 40)
                            return "󰁽";
                        if (BatteryMonitor.capacity > 30)
                            return "󰁼";
                        if (BatteryMonitor.capacity > 20)
                            return "󰁻";
                        if (BatteryMonitor.capacity > 10)
                            return "󰁺";
                        return "󰂎";
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openOnly("battery")
            }
        }
    }

    // ── hover / close logic ───────────────────────────────────────────────────
    HoverHandler {
        id: islandHover
        onHoveredChanged: {
            if (hovered)
                closeDelay.stop();
            else if (root.openWidget !== "" && !anyWidgetHovered())
                closeDelay.restart();
        }
    }

    function anyWidgetHovered() {
        return wifiWidget.popupHovered || btWidget.popupHovered || soundWidget.popupHovered || batteryWidget.popupHovered;
    }

    Timer {
        id: closeDelay
        interval: 100
        onTriggered: {
            if (!islandHover.hovered && !root.anyWidgetHovered()) {
                root.openWidget = "";
                wifiWidget.hide();
                btWidget.hide();
                soundWidget.hide();
                batteryWidget.hide();
            }
        }
    }

    // ── popup widgets ─────────────────────────────────────────────────────────
    WifiWidget {
        id: wifiWidget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40
        onPopupHoveredChanged: {
            if (popupHovered)
                closeDelay.stop();
            else if (!islandHover.hovered)
                closeDelay.restart();
        }
    }

    BluetoothWidget {
        id: btWidget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40
        onPopupHoveredChanged: {
            if (popupHovered)
                closeDelay.stop();
            else if (!islandHover.hovered)
                closeDelay.restart();
        }
    }

    SoundWidget {
        id: soundWidget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40
        onPopupHoveredChanged: {
            if (popupHovered)
                closeDelay.stop();
            else if (!islandHover.hovered)
                closeDelay.restart();
        }
    }

    BatteryWidget {
        id: batteryWidget
        anchor.window: root.panelWindow
        anchor.rect.x: root.barScreenX
        anchor.rect.y: 40
        onPopupHoveredChanged: {
            if (popupHovered)
                closeDelay.stop();
            else if (!islandHover.hovered)
                closeDelay.restart();
        }
    }
}
