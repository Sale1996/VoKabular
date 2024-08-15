import QtQuick
import QtQuick.Controls


Frame {
    id: gameModeButtonsFrame
    x: 760
    width: 200
    height: 200
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    anchors.rightMargin: 20

    signal matcherModeButtonClicked()
    signal trainingModeButtonClicked()
    signal testModeButtonClicked()

    function enableButtons()
    {
        trainingButton.enabled = true
        testButton.enabled = true
        wordMatcherButton.enabled = true
    }

    function disableButtons()
    {
        trainingButton.enabled = false
        testButton.enabled = false
        wordMatcherButton.enabled = false
    }

    function areButtonsEnabled()
    {
        //Since all buttons should be ENABLED or DISABLED, we can use one for the query.
        return trainingButton.enabled;
    }

    Column {
        id: gameModeButtonsColumn
        anchors.fill: parent
        spacing: 30

        Button {
            id: wordMatcherButton
            width: 150
            height: 40
            text: qsTr("Word matcher")
            font.capitalization: Font.AllUppercase
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                matcherModeButtonClicked();
            }
        }

        Button {
            id: trainingButton
            width: 150
            height: 40
            text: qsTr("Training")
            font.capitalization: Font.AllUppercase
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                trainingModeButtonClicked();
            }
        }

        Button {
            id: testButton
            width: 150
            height: 40
            text: qsTr("Test")
            font.capitalization: Font.AllUppercase
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                testModeButtonClicked();
                /*
                testTimer.visible = true
                testMode = true

                stateGroup.state = "defaultState";
                backend.getNewWordPair();
                textField.focus = true
                */
            }
        }
    }
}
