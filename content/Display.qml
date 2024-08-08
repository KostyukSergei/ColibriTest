pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window

Item {
    id: display
    property int fontSize: 22
    readonly property int maxDigits: 25
    readonly property color backgroundColor: "#04BFAD"
    readonly property color qtGreenColor: "#2CDE85"
    property string displayedOperand: ""
    readonly property string errorString: qsTr("ERROR")
    readonly property bool isError: displayedOperand === errorString
    property bool enteringDigits: false
    readonly property font expressionFont: ({
        family: "Open Sans",
        pointSize: 20,
        bold: "Semibold"
    })
    readonly property font answerFont: ({
        family: "Open Sans",
        pointSize: 50,
        bold: "Semibold"
    })

    function displayOperator(operator) {
        calculationsListView.model.append({ "operator": operator, "operand": "", "answer": "0" })
        enteringDigits = true
        calculationsListView.positionViewAtEnd()
    }

    function newLine(operator, operand, answer) {
        let displayedAnswer = displayNumber(answer)
        displayedOperand = operand
        calculationsListView.model.append({ "operator": operator, "answer": displayedAnswer, "operand": operand })
        enteringDigits = false
        calculationsListView.positionViewAtEnd()
    }

    function appendDigit(digit) {
        if (!enteringDigits)
            calculationsListView.model.append({ "operator": "", "operand": "", "answer": "0" })
        const i = calculationsListView.model.count - 1
        calculationsListView.model.get(i).operand = calculationsListView.model.get(i).operand + digit
        enteringDigits = true
        calculationsListView.positionViewAtEnd()
    }

    function setDigit(digit) {
        const i = calculationsListView.model.count - 1
        calculationsListView.model.get(i).operand = digit
        calculationsListView.positionViewAtEnd()
    }

    function backspace() {
        const i = calculationsListView.model.count - 1
        if (i >= 0) {
            let operand = calculationsListView.model.get(i).operand
            calculationsListView.model.get(i).operand = operand.toString().slice(0, -1)
            return
        }
        return
    }

    function isOperandEmpty() {
        const i = calculationsListView.model.count - 1
        return i >= 0 ? calculationsListView.model.get(i).operand === "" : true
    }

    function isDisplayEmpty() {
        const i = calculationsListView.model.count - 1
        return i == -1 ? true : (i == 0 ? calculationsListView.model.get(0).operand === ""  : false)
    }

    function clear() {
        displayedOperand = ""
        if (enteringDigits) {
            const i = calculationsListView.model.count - 1
            if (i >= 0)
                calculationsListView.model.remove(i)
            enteringDigits = false
        }
    }

    function allClear()
    {
        display.clear()
        calculationsListView.model.clear()
        enteringDigits = false
    }

    function displayNumber(num) {
        if (typeof(num) !== "number")
            return errorString

        // deal with the absolute
        const abs = Math.abs(num)

        if (abs.toString().length <= maxDigits) {
            return isFinite(num) ? num.toString() : errorString
        }

        if (abs < 1) {
            if (Math.floor(abs * 100000) === 0) {
                const expVal = num.toExponential(maxDigits - 6).toString()
                if (expVal.length <= maxDigits + 1)
                    return expVal

            } else {
                // the first two digits are zero and .
                return num.toFixed(maxDigits - 2)
            }
        } else {
            // if the integer part of num is greater than maxDigits characters, use exp form
            const intAbs = Math.floor(abs)
            if (intAbs.toString().length <= maxDigits)
                return parseFloat(num.toPrecision(maxDigits - 1)).toString()

            const expVal = num.toExponential(maxDigits - 6).toString()
            if (expVal.length <= maxDigits + 1)
                return expVal
        }
        return errorString
    }

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            topLeftRadius: 0
            topRightRadius: 0
            bottomLeftRadius: 30
            bottomRightRadius: 30
            color: display.backgroundColor

            ListView {
                id: calculationsListView
                x: 5
                y: 10
                width: parent.width
                height: parent.height - 2 * y
                clip: true
                delegate: Item {
                    // height: display.fontSize * 1.1
                    height: display.answerFont.pixelSize
                    width: calculationsListView.width

                    required property string operator
                    required property string answer
                    required property string operand

                    Text {
                        x: 6
                        font.pixelSize: display.expressionFont.pixelSize
                        color: "white"
                        text: parent.operator
                    }
                    Text {
                        font: display.answerFont
                        anchors.right: parent.right
                        anchors.rightMargin: 45
                        anchors.top: parent.top
                        anchors.topMargin: 80
                        text: parent.answer
                        color: "white"
                    }
                    Text {
                        font: display.expressionFont
                        anchors.right: parent.right
                        anchors.rightMargin: 45
                        anchors.top: parent.top
                        anchors.topMargin: 30
                        text: parent.operand
                        color: "white"
                    }
                }
                model: ListModel { }
                onHeightChanged: positionViewAtEnd()
            }
        }
    }
}
