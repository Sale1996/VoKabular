import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import com.vokabular.backend

Window {
    id: window
    width: 960
    height: 720
    visible: true
    title: qsTr("VoKabular")

    Component.onCompleted: {
        wordFrame.changeState(wordFrame.wordFrameStates.DefaultState);
        gameModeButtonsFrame.disableButtons();
    }

    property bool canStartTest: false;

    Backend {
        id: backend
        onWordChanged: {
            if(word.length != 0)
            {
                wordFrame.setWordLabel(word);
                wordFrame.changeState(wordFrame.wordFrameStates.ReadyForInputState);
                if(!gameModeButtonsFrame.areButtonsEnabled())
                {
                    gameModeButtonsFrame.enableButtons();
                }
            }
        }
        onCorrectAnswer: userAnswer => {
            wordFrame.changeState(wordFrame.wordFrameStates.CorrectAnswerState);
            wordFrame.setTextFieldText(userAnswer);
            wordFrame.activateKeyboardHanlder();
        }
        onWrongAnswer: userAnswer => {
            wordFrame.changeState(wordFrame.wordFrameStates.WrongAnswerState);
            wordFrame.setTextFieldText(userAnswer);
            wordFrame.activateKeyboardHanlder();
        }
        onTimerSecondPassed: secondsLeft => {
            wordFrame.updateTestTimer(secondsLeft);
        }
        onTestFinished: (correctAnswers, wrongAnswers) => {
            testPopup.openPopup(correctAnswers, wrongAnswers)
        }
        onMatcherWordsPrepared: (matcherWords,matcherTranslations) => {
            if(matcherWords.length !== 0  && matcherTranslations.length !== 0 ){
                wordMatcher.fillNewWords(matcherWords, matcherTranslations);
                gameModeButtonsFrame.enableMatcherButton();
            }
            else if (backend.categories.lenght !== 0)
            {
                if(wordMatcher.visible)
                {
                    wordMatcher.visible = false;
                    wordFrame.visible = true;
                }
                gameModeButtonsFrame.disableMatcherButton();
            }
        }
        onMatchResult: (result) => {
            wordMatcher.onMatchingResult(result);
        }
        onCategoriesListEmpty: {
            if(wordMatcher.visible)
            {
                wordMatcher.visible = false;
                wordFrame.visible = true;
            }
            wordFrame.changeState(wordFrame.wordFrameStates.DefaultState);
            gameModeButtonsFrame.disableButtons()
        }

        //BUG2 kada odcekujemo sve kategorije, tebi pukne aplikacija!
        //IMAS BUG, KADA SI U STATEU ZA TACAN ILI NETACAN ODGOVOR I KLIKNES START TEST
    }

    TestPopup {
        id: testPopup
    }

    WordFrame {
        id: wordFrame
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        onInputKeyboardReturnPressed: {
            backend.getNewWordPair();
        }
        onInputKeyboardSpacePressed: {
            backend.getNewWordPair();
        }
        onTextFieldSubmitted: (inputText) => {
            if(canStartTest)
            {
                backend.startTest();
                canStartTest = false;
            }

            backend.submitAnswer(inputText)
        }
    }

    WordMatcher {
        id: wordMatcher
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        onCheckWordPair: (firstWord, secondWord) => {
            backend.submitMatch(firstWord, secondWord);
        }
        onRefreshMatcher: {
            backend.getMatcherWords();
        }
    }

    TrainingButtonsFrame {
        id: gameModeButtonsFrame
        x: 760
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        onTestModeButtonClicked: {
            if(wordMatcher.visible){
                wordFrame.visible = true;
                wordMatcher.visible = false;
            }
            wordFrame.activateTestTimer();
            backend.getNewWordPair();
            wordFrame.changeState(wordFrame.wordFrameStates.ReadyForInputState);
            canStartTest = true;
        }
        onTrainingModeButtonClicked: {
            if(wordMatcher.visible){
                wordFrame.visible = true;
                wordMatcher.visible = false;
            }
            wordFrame.cancelTestTimer();
            backend.cancelTest();
            wordFrame.changeState(wordFrame.wordFrameStates.ReadyForInputState);
            canStartTest = false;
        }
        onMatcherModeButtonClicked: {
            wordFrame.visible = false;
            wordMatcher.visible = true;
            wordMatcher.resetMatcher();
            backend.getMatcherWords();
        }
    }

    CategoriesFrame {
        id: categoriesFrame
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20

        categories: backend.categories
        onCategoryChecked: (text, checked) => {
            wordFrame.changeState(wordFrame.wordFrameStates.ReadyForInputState);
            backend.chosenCategoriesUpdated(text, checked)
            backend.getMatcherWords();
        }
    }

    Button {
        id: settingsButton
        width: 150
        height: 40
        anchors.top: categoriesFrame.bottom
        anchors.horizontalCenter: categoriesFrame.horizontalCenter
        anchors.topMargin: 30
        font.capitalization: Font.AllUppercase
        text: qsTr("Settings")
    }

}
