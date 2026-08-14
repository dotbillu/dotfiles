import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../theme"
import "../../widgets"
import "../../services"

PopupWindow {
    id: popup

    property bool popupHovered: false
    readonly property int widgetWidth: 320

    width: widgetWidth
    height: card.implicitHeight
    visible: false
    color: "transparent"

    function show() {
        visible = true;
        card.opacity = 0;
        card.scale = 0.97;
        entryAnim.start();
    }
    function hide() {
        exitAnim.start();
    }

    ParallelAnimation {
        id: entryAnim
        NumberAnimation {
            target: card
            property: "opacity"
            to: 1
            duration: 180
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: card
            property: "scale"
            to: 1.0
            duration: 180
            easing.type: Easing.OutCubic
        }
    }
    SequentialAnimation {
        id: exitAnim
        ParallelAnimation {
            NumberAnimation {
                target: card
                property: "opacity"
                to: 0
                duration: 130
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: card
                property: "scale"
                to: 0.97
                duration: 130
                easing.type: Easing.InCubic
            }
        }
        ScriptAction {
            script: popup.visible = false
        }
    }

    HoverHandler {
        onHoveredChanged: popup.popupHovered = hovered
    }

    Rectangle {
        id: card
        width: parent.width
        implicitHeight: col.implicitHeight + 28
        radius: 16
        color: Theme.colors.surfaceContainer
        border.color: Theme.colors.border
        border.width: 1
        transformOrigin: Item.TopRight

        ColumnLayout {
            id: col
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            anchors.margins: 14
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "Display & Color"
                    color: Theme.colors.textPrimary
                    font.pixelSize: 13
                    font.bold: true
                    Layout.fillWidth: true
                }

                // Read from SystemControls parent battery capacity
                Text {
                    text: BatteryMonitor.capacity + "%"
                    color: Theme.colors.textMuted
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.colors.border
            }

            // Internal Display
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text {
                    text: "Internal Display"
                    color: Theme.colors.textMuted
                    font.pixelSize: 10
                    font.bold: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: "󰃠"
                        font.pixelSize: 16
                        color: Theme.colors.accent
                    }
                    SliderControl {
                        Layout.fillWidth: true
                        value: DisplaySettings.intBright
                        accentColor: Theme.colors.accent
                        onValueSet: v => DisplaySettings.setIntBright(v)
                    }
                    Text {
                        text: Math.round(DisplaySettings.intBright * 100) + "%"
                        color: Theme.colors.textMuted
                        font.pixelSize: 11
                        Layout.preferredWidth: 32
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            // External Display
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                visible: DisplaySettings.extSupported
                Text {
                    text: "External Display"
                    color: Theme.colors.textMuted
                    font.pixelSize: 10
                    font.bold: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: "󰍹"
                        font.pixelSize: 16
                        color: "#B4BEFE"
                    }
                    SliderControl {
                        Layout.fillWidth: true
                        value: DisplaySettings.extBright
                        accentColor: "#B4BEFE"
                        onValueSet: v => DisplaySettings.setExtBright(v)
                    }
                    Text {
                        text: Math.round(DisplaySettings.extBright * 100) + "%"
                        color: Theme.colors.textMuted
                        font.pixelSize: 11
                        Layout.preferredWidth: 32
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }

    // Reusable slider component
    component SliderControl: Item {
        property real value: 0.0
        property color accentColor: Theme.colors.accent
        signal valueSet(real v)

        height: 20

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 4
            radius: 2
            color: Theme.colors.overlayLight

            Rectangle {
                width: parent.width * parent.parent.value
                height: parent.height
                radius: parent.radius
                color: parent.parent.accentColor
            }
        }

        // Thumb
        Rectangle {
            x: Math.max(0, Math.min(parent.width * parent.value - width / 2, parent.width - width))
            anchors.verticalCenter: parent.verticalCenter
            width: 12
            height: 12
            radius: 6
            color: Theme.colors.textPrimary
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onPositionChanged: mouse => {
                if (pressed) {
                    let pct = Math.max(0, Math.min(mouse.x / width, 1.0));
                    parent.valueSet(pct);
                }
            }
            onPressed: mouse => {
                let pct = Math.max(0, Math.min(mouse.x / width, 1.0));
                parent.valueSet(pct);
            }
        }
    }
}
