import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: testResultsPopup
    anchors.centerIn: parent
    width: 300
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property var correctTestAnswersMap
    property var wrongTestAnswersMap

    function openPopup(correctAnswers, wrongAnswers) {

        correctAnswersModel.clear();
        wrongAnswersModel.clear();

        correctTestAnswersMap = correctAnswers
        wrongTestAnswersMap = wrongAnswers

        Object.keys(correctAnswers).forEach(key => {
            correctAnswersModel.append({"key": key})
            console.log("kljuc correct ubacen" + key);
        });

        Object.keys(wrongAnswers).forEach(key => {
            wrongAnswersModel.append({"key": key})
            console.log("kljuc ubacen");
        });

        testResultsPopup.open();
    }

    Column {
        Label {
            id: labelPopup
            text: "Test finished!"
        }

        //ScrollView {
        Flickable {
            id: testResultScrollView
            //anchors.fill: parent
            width: 300
            height: 250
            smooth: false
            contentWidth: width
            contentHeight: columnCorrectAnswers.height
            clip: true

            ListModel {
                id: correctAnswersModel
            }

            ListModel {
                id: wrongAnswersModel
            }

            ColumnLayout {
                id: columnCorrectAnswers
                width: parent.width


                Repeater {
                    model: correctAnswersModel

                    Item {
                        //Layout.alignment: parent.horizontalCenter
                        //anchors.horizontalCenter: parent.horizontalCenter
                        height: 20
                        width: parent.width
                        Row {
                            id: delegateItem
                            width: parent.width
                            spacing: 10
                            height: parent.height

                            Text {
                                text: key
                                color: "green"
                                font.bold: true
                                font.pointSize: 15
                            }

                            ToolSeparator {}

                            Text {
                                text: correctTestAnswersMap[key]
                                //text: key
                                color: "green"
                                font.bold: true
                                font.pointSize: 15
                            }
                        }
                    }
                }

                Repeater {
                    model: wrongAnswersModel

                    Item {
                        //Layout.alignment: parent.horizontalCenter
                        height: 20
                        width: parent.width
                        Row {
                            id: wrongAnswerItem
                            width: parent.width
                            spacing: 5
                            height: parent.height

                            Text {
                                text: key

                                color: "red"
                                font.bold: true
                                font.pointSize: 15
                            }
                            Text {
                                text: correctTestAnswersMap[key]
                                //text: key
                                color: "red"
                                font.bold: true
                                font.pointSize: 15
                            }
                        }
                    }
                }
            }
        }

        Button {
            id: closePopupButton
            text: "Close"
            onClicked: {
                testResultsPopup.close()
            }
        }
    }
}
