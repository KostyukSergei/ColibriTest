import QtQuick
import QtQuick.Controls

RoundButton {
    id: button
    implicitWidth: 60
    implicitHeight: 60
    radius: buttonRadius
    text: "bs"

    property bool dimmable: true
    property bool dimmed: false
    readonly property color backgroundColor: "#00F79C"
    readonly property color borderColor: "#A9A9A9"
    readonly property color backspaceRedColor: "#DE2C2C"
    readonly property int buttonRadius: 100

    function getBackgroundColor() {
        if (button.dimmable && button.dimmed)
            return backgroundColor
        if (button.pressed)
            return backspaceRedColor
        return backgroundColor
    }

    function getBorderColor() {
        if (button.dimmable && button.dimmed)
            return borderColor
        if (button.pressed || button.hovered)
            return backspaceRedColor
        return borderColor
    }

    function getIconColor() {
        if (button.dimmable && button.dimmed)
            return Qt.darker(backspaceRedColor)
        if (button.pressed)
            return backgroundColor
        return backspaceRedColor
    }

    function getIcon() {
        if (button.dimmable && button.dimmed)
            return "images/backspace.svg"
        if (button.pressed)
            return "images/backspace_fill.svg"
        return "images/backspace.svg"
    }

    onReleased: {
        root.operatorPressed("AC")
        updateDimmed()
    }

    background: Rectangle {
        radius: button.buttonRadius
        color: getBackgroundColor()
        border.color: getBorderColor()
    }
}
