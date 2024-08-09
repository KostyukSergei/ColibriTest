// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound

import QtQuick
import "calculator.js" as CalcEngine
import QtQuick.Layouts

Item {
    id: controller
    // implicitWidth: isPortraitMode ? portraitModeWidth : landscapeModeWidth
    implicitWidth: portraitModeWidth
    implicitHeight: mainGrid.height

    readonly property color qtGreenColor: "#2CDE85"
    readonly property int spacing: 24

    // property bool isPortraitMode: root.isPortraitMode
    property bool isPortraitMode: true
    property int portraitModeWidth: mainGrid.width
    // property int landscapeModeWidth: scientificGrid.width + mainGrid.width

    function updateDimmed(){
        for (let i = 0; i < mainGrid.children.length; i++){
            mainGrid.children[i].dimmed = root.isButtonDisabled(mainGrid.children[i].text)
        }
    }

    component DigitButton: CalculatorButton {
        onReleased: {
            root.digitPressed(text)
            updateDimmed()
        }
    }

    component OperatorButton: CalculatorButton {
        onReleased: {
            root.operatorPressed(text)
            updateDimmed()
        }
        textColor: "#FFFFFF"
        implicitWidth: 48
        dimmable: true
    }

    Component.onCompleted: updateDimmed()

    Rectangle {
        id: numberPad
        anchors.fill: parent
        radius: 8
        color: "transparent"

        RowLayout {
            spacing: controller.spacing

            GridLayout {
                id: mainGrid
                columns: 4
                columnSpacing: controller.spacing
                rowSpacing: controller.spacing

                OperatorButton {
                    text: "()"
                    implicitWidth: 60
                    backgroundColor: "#0889A6"
                }
                OperatorButton {
                    text: "±"
                    implicitWidth: 60
                    backgroundColor: "#0889A6"
                }
                OperatorButton {
                    text: "%"
                    implicitWidth: 60
                    backgroundColor: "#0889A6"
                }
                OperatorButton {
                    text: "÷"
                    implicitWidth: 60
                    backgroundColor: "#0889A6"
                }

                DigitButton { text: "7" }
                DigitButton { text: "8" }
                DigitButton { text: "9" }
                OperatorButton {
                    text: "×"
                    implicitWidth: 60
                    backgroundColor: "#0889A6"
                }

                DigitButton { text: "4" }
                DigitButton { text: "5" }
                DigitButton { text: "6" }
                OperatorButton {
                    text: "−"
                    implicitWidth: 60
                    backgroundColor: "#0889A6"
                }

                DigitButton { text: "1" }
                DigitButton { text: "2" }
                DigitButton { text: "3" }
                OperatorButton {
                    text: "+"
                    implicitWidth: 60
                    backgroundColor: "#0889A6"
                }

                OperatorButton {
                    text: "C"
                    implicitWidth: 60
                    backgroundColor: "#00F79C"
                }
                DigitButton { text: "0" }
                DigitButton {
                    text: "."
                    implicitWidth: 60
                    dimmable: true
                }
                OperatorButton {
                    text: "="
                    implicitWidth: 60
                    backgroundColor: "#0889A6"

                    Timer {
                        id: passwordTimer

                        interval: 5000
                        repeat: false
                        running: false
                    }

                    Timer {
                        id: longPressTimer

                        interval: 4000
                        repeat: false
                        running: false

                        onTriggered: {
                            function Timer() {
                                return Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
                            }

                            passwordTimer.running = true;
                            let checker = new Timer();
                            checker.interval = 50;
                            checker.repeat = true;
                            checker.triggered.connect(function () {
                                if(CalcEngine.checkPassword() === true){
                                    root.visible = false;
                                    secretWindow.visible = true;
                                    checker.stop();
                                }
                                else {
                                    if (passwordTimer.running === false)
                                        checker.stop();
                                };
                            });
                            checker.start();
                        }
                    }

                    onPressedChanged: {
                        if ( pressed ) {
                            longPressTimer.running = true;
                        } else {
                            longPressTimer.running = false;
                        }
                    }
                }
            }
        }
    }
}
