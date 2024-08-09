import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import "content"
import "content/calculator.js" as CalcEngine

Window {
    visible: true
    minimumWidth: 360
    minimumHeight: 640
    maximumWidth: 360
    maximumHeight: 640
    color: root.backgroundColor

    Item {
        id: secretWindow
        visible: false
        anchors.fill: parent

        Text {
            anchors.top: parent.top
            anchors.topMargin: 200
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Open Sans Semibold"
            font.pointSize: 20
            color: "#FFFFFF"
            text: "Секретное меню"
        }

        CalculatorButton {
            text: "Назад"
            anchors.top: parent.top
            anchors.topMargin: 450
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            onClicked: {
                root.visible = true;
                secretWindow.visible = false;
            }
        }
    }

    Item {
        id: root
        visible: true
        anchors.fill: parent

        readonly property int margin: 24
        readonly property color backgroundColor: "#024873"
        readonly property int minLandscapeModeWidth: numberPad.landscapeModeWidth
                                                     + display.minWidth
                                                     + margin * 3
        // property bool isPortraitMode: width < minLandscapeModeWidth
        property bool isPortraitMode: true

        onIsPortraitModeChanged: {
            if (isPortraitMode) {
                portraitMode.visible = true
                landscapeMode.visible = false
            } else {
                portraitMode.visible = false
                landscapeMode.visible = true
            }
        }

        Display {
            id: display
            readonly property int minWidth: 210
            readonly property int minHeight: 60

            Layout.minimumWidth: minWidth
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 0
        }

        NumberPad {
            id: numberPad;
            Layout.margins: root.margin
        }

        // define the responsive layouts
        ColumnLayout {
            id: portraitMode
            anchors.fill: parent
            visible: true

            LayoutItemProxy {
                target: display
                Layout.minimumHeight: display.minHeight
            }
            LayoutItemProxy {
                target: numberPad
                Layout.alignment: Qt.AlignHCenter
            }
        }

        RowLayout {
            id: landscapeMode
            anchors.fill: parent
            visible: false

            LayoutItemProxy {
                target: display
            }
            LayoutItemProxy {
                target: numberPad
                Layout.alignment: Qt.AlignVCenter
            }
        }

        function operatorPressed(operator) {
            CalcEngine.operatorPressed(operator, display)
        }
        function digitPressed(digit) {
            CalcEngine.digitPressed(digit, display)
        }
        function isButtonDisabled(op) {
            // return CalcEngine.isOperationDisabled(op, display)
            return false
        }

        Keys.onPressed: function(event) {
            switch (event.key) {
                case Qt.Key_0: digitPressed("0"); break;
                case Qt.Key_1: digitPressed("1"); break;
                case Qt.Key_2: digitPressed("2"); break;
                case Qt.Key_3: digitPressed("3"); break;
                case Qt.Key_4: digitPressed("4"); break;
                case Qt.Key_5: digitPressed("5"); break;
                case Qt.Key_6: digitPressed("6"); break;
                case Qt.Key_7: digitPressed("7"); break;
                case Qt.Key_8: digitPressed("8"); break;
                case Qt.Key_9: digitPressed("9"); break;
                case Qt.Key_E: digitPressed("e"); break;
                case Qt.Key_P: digitPressed("π"); break;
                case Qt.Key_Plus: operatorPressed("+"); break;
                case Qt.Key_Minus: operatorPressed("-"); break;
                case Qt.Key_Asterisk: operatorPressed("×"); break;
                case Qt.Key_Slash: operatorPressed("÷"); break;
                case Qt.Key_Enter:
                case Qt.Key_Return: operatorPressed("="); break;
                case Qt.Key_Comma:
                case Qt.Key_Period: digitPressed("."); break;
            }
        }
    }
}
