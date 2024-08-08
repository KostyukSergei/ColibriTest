import QtQuick
import QtQuick.Controls

RoundButton {
    id: button
    implicitWidth: 60
    implicitHeight: 60
    radius: buttonRadius

    FontLoader { id: webFont; source: "fonts/OpenSans-SemiBold.ttf" }

    property bool dimmable: false
    property bool dimmed: false
    readonly property int fontSize: 24
    readonly property int buttonRadius: 100
    property color textColor: "#024873"
    property color accentColor: "#F7E425"
    property color backgroundColor: "#B0D1D8"
    readonly property color borderColor: "#A9A9A9"
    readonly property font buttonFont: ({
        family: "Open Sans",
        pointSize: 20,
        bold: "Semibold"
    })

    function getBackgroundColor() {
        if (button.dimmable && button.dimmed)
            return backgroundColor
        if (button.pressed)
            return accentColor
        return backgroundColor
    }

    function getBorderColor() {
        if (button.dimmable && button.dimmed)
            return borderColor
        if (button.pressed || button.hovered)
            return accentColor
        return borderColor
    }

    function getTextColor() {
        return textColor
    }

    background: Rectangle {
        radius: button.buttonRadius
        color: getBackgroundColor()
    }

    contentItem: Text {
        text: button.text
        font: button.buttonFont
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: getTextColor()
        Behavior on color {
            ColorAnimation {
                duration: 120
                easing.type: Easing.OutElastic
            }
        }
    }
}
