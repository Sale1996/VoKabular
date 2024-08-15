import QtQuick
import QtQuick.Controls

Frame {
    id: wordFrame
    width: 480
    height: 400

    property var wordFrameStates: ({
        DefaultState: "DefaultState",
        ReadyForInputState: "ReadyForInputState",
        CorrectAnswerState: "CorrectAnswerState",
        WrongAnswerState: "WrongAnswerState"
    })

    property bool testStarted: false

    function changeState(nextState)
    {
        if(wordFrameStates.hasOwnProperty(nextState))
        {
            wordFrameStateGroup.state = nextState
        }
    }

    function setWordLabel(label)
    {
        wordLabel.text = label;
    }

    function setTextFieldText(text)
    {
        textField.text = text;
    }

    function activateKeyboardHanlder()
    {
        keyboardHandler.focus = true;
    }

    function activateTestTimer()
    {
        testTimer.visible = true;
        testTimer.text = qsTr("Enter first answer to start")
    }

    function updateTestTimer(secondsLeft)
    {
        testTimer.text = secondsLeft //from signal data
        if (secondsLeft === 0){
            testTimer.visible = false;
        }
    }

    function cancelTestTimer()
    {
        testTimer.visible = false
    }

    signal inputKeyboardReturnPressed();
    signal inputKeyboardSpacePressed();
    signal textFieldSubmitted(var inputText);

    background: Rectangle {
        id: frameBackground
        color: "white"
        border.color: "black"
        border.width: 1
    }

    FocusScope {
        id: keyboardHandler
        anchors.fill: parent
        focus: true

        //Enter button handle
        Keys.onReturnPressed: {
            inputKeyboardReturnPressed();
        }
        //Space button handle
        Keys.onSpacePressed: {
            inputKeyboardSpacePressed();
       }
    }

    TextField {
        id: textField
        x: 94
        y: 186
        width: 272
        height: 85
        anchors.top: wordLabel.bottom
        anchors.topMargin: 40
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 30
        placeholderText: qsTr("")
        enabled: false
        onAccepted: {
            textFieldSubmitted(textField.text)
        }
    }

    Label {
        id: testTimer
        color:"#040404"
        text: qsTr("Enter first answer to start")
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pointSize: 20
        visible: false
    }

    Label {
        id: wordLabel
        color: "#040404"
        anchors.top: testTimer.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pointSize: 30
        text: qsTr("Choose word category")
    }

    StateGroup {
        id: wordFrameStateGroup
        states: [
            State {
                name: wordFrameStates.ReadyForInputState

                PropertyChanges {
                    target: frameBackground
                    color: "white"
                    border.color: "black"
                    border.width: 1
                }

                PropertyChanges {
                    target: textField
                    text: ""
                    enabled: true
                    focus: true
                }
            },
            State {
                name: wordFrameStates.CorrectAnswerState

                PropertyChanges {
                    target: frameBackground
                    color: "lightgreen"
                    border.color: "green"
                    border.width: 4
                }

                PropertyChanges {
                    target: textField
                    enabled: false
                }
            },
            State {
                name: wordFrameStates.WrongAnswerState

                PropertyChanges {
                    target: frameBackground
                    color: "#f06e6e"
                    border.color: "red"
                    border.width: 4
                }

                PropertyChanges {
                    target: textField
                    enabled: false
                }
            },
            State {
                name: wordFrameStates.DefaultState

                PropertyChanges {
                    target: frameBackground
                    color: "white"
                    border.color: "black"
                    border.width: 1
                }

                PropertyChanges {
                    target: textField
                    text: ""
                    enabled: false
                }

                PropertyChanges {
                    target: wordLabel
                    text: "Choose word category"
                }
            }
        ]
    }

}
