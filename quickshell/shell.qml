import QtQuick
import Quickshell

import "modules/workspace"
import "modules/clock"
import "modules/media"
import "modules/systemcontrols"
import "modules/notifications"
import "modules/clipboard"
import "modules/expose"
import "modules/battery"
import "modules/scratchpad"
import "theme"

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            exclusionMode: ExclusionMode.Ignore

            property bool barVisible: false
            property bool anyWidgetOpen: systemControls.openWidget !== "" || clockModule.widgetOpen || clipboardModule.widgetOpen || archLauncher.statsOpen
            onAnyWidgetOpenChanged: {
                if (!anyWidgetOpen && !barHover.hovered) {
                    barHideDelay.restart();
                }
            }

            implicitHeight: barVisible ? 38 : 1

            color: "transparent"

            // Invisible trigger zone – top-right corner only
            Item {
                id: triggerZone
                anchors.top: parent.top
                anchors.left: parent.left
                width: 200
                height: Math.max(parent.height, 1)  // 1px when bar hidden, full bar when visible

                HoverHandler {
                    id: triggerHover
                    onHoveredChanged: {
                        if (hovered) {
                            barHideDelay.stop();
                            bar.barVisible = true;
                        }
                    }
                }
            }

            // Full-bar hover handler – keeps bar open while cursor is anywhere inside
            HoverHandler {
                id: barHover
                onHoveredChanged: {
                    if (hovered) {
                        barHideDelay.stop();
                    } else {
                        barHideDelay.restart();
                    }
                }
            }

            Timer {
                id: barHideDelay
                interval: 100
                onTriggered: {
                    if (!barHover.hovered && !triggerHover.hovered && !bar.anyWidgetOpen)
                        bar.barVisible = false;
                }
            }

            Rectangle {
                bottomLeftRadius: 200
                bottomRightRadius: 200
                width: parent.width
                height: 38
                anchors.bottom: parent.bottom
                color: Theme.colors.surface

                // Far left: Arch Launcher
                Row {
                    id: leftControls
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    ArchLauncher {
                        id: archLauncher
                        panelWindow: bar
                    }

                    Rectangle {
                        height: 35
                        width: toolsRow.implicitWidth + 12
                        radius: 18
                        anchors.verticalCenter: parent.verticalCenter
                        color: Theme.colors.surface

                        Row {
                            id: toolsRow
                            anchors.centerIn: parent
                            spacing: 0

                            ClipboardModule {
                                id: clipboardModule
                                panelWindow: bar
                                barScreenX: leftControls.x + 48 // Approximate absolute offset
                            }

                            Item {
                                width: 6
                            }
                            Rectangle {
                                width: 1
                                height: 14
                                color: Theme.colors.border
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Item {
                                width: 6
                            }

                            ExposeModule {
                                panelWindow: bar
                                barScreenX: leftControls.x + 88 // Approximate absolute offset
                            }


                            ScratchpadModule {
                                panelWindow: bar
                                visible: false
                            }
                        }
                    }
                }

                // Center modules
                Row {
                    id: barRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Media {
                        id: mediaBar
                        anchors.verticalCenter: parent.verticalCenter
                        panelWindow: bar
                        barScreenX: barRow.x
                    }

                    Workspace {
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Clock {
                        id: clockModule
                        anchors.verticalCenter: parent.verticalCenter
                        panelWindow: bar
                        barScreenX: barRow.x + clockModule.x
                    }
                }

                // Right-side island + notifications
                Row {
                    id: rightControls
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    SystemControls {
                        id: systemControls
                        panelWindow: bar
                        barScreenX: rightControls.x
                    }

                    Notifications {}
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens
        BatteryWarning {
            required property var modelData
            screen: modelData
        }
    }
}
