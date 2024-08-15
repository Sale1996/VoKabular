import QtQuick
import QtQuick.Controls

Frame {
    id: wordFrame
    width: 480
    height: 400

    property var firstMatcher: notInitialized;
    property var secondMatcher: notInitialized;
    property int matchesLeft: 6

    signal checkWordPair(string firstWord, string secondWord);
    signal refreshMatcher();

    function fillNewWords(matcherWords,matcherTranslations){
        button1.setTextItem(matcherWords[0]);
        button2.setTextItem(matcherTranslations[0]);
        button3.setTextItem(matcherWords[1]);
        button4.setTextItem(matcherTranslations[1]);
        button5.setTextItem(matcherWords[2]);
        button6.setTextItem(matcherTranslations[2]);
        button7.setTextItem(matcherWords[3]);
        button8.setTextItem(matcherTranslations[3]);
        button9.setTextItem(matcherWords[4]);
        button10.setTextItem(matcherTranslations[4]);
        button11.setTextItem(matcherWords[5]);
        button12.setTextItem(matcherTranslations[5]);
    }

    function clickedButton(button)
    {
        button.changeColor("gray");

        if(firstMatcher == notInitialized)
            firstMatcher = button;
        else
        {
            secondMatcher = button;
            checkWordPair(firstMatcher.getTextItem(), secondMatcher.getTextItem());

            //reset values
            firstMatcher = notInitialized;
            secondMatcher = notInitialized;
        }
    }

    function onMatchingResult(result)
    {
        if(result)
        {
            firstMatcher.enabled = false;
            secondMatcher.enabled = false;
            firstMatcher.changeColor("darkgreen");
            secondMatcher.changeColor("darkgreen");
            matchesLeft--;
        }
        else
        {
            //put default background
            firstMatcher.changeColor("black");
            secondMatcher.changeColor("black");
        }

        if (matchesLeft == 0)
        {
            resetMatcher();
            refreshMatcher();
        }
    }

    function resetMatcher(){
        matchesLeft = 6;
        button1.changeColor("black");
        button1.enabled = true;
        button2.changeColor("black");
        button2.enabled = true;
        button3.changeColor("black");
        button3.enabled = true;
        button4.changeColor("black");
        button4.enabled = true;
        button5.changeColor("black");
        button5.enabled = true;
        button6.changeColor("black");
        button6.enabled = true;
        button7.changeColor("black");
        button7.enabled = true;
        button8.changeColor("black");
        button8.enabled = true;
        button9.changeColor("black");
        button9.enabled = true;
        button10.changeColor("black");
        button10.enabled = true;
        button11.changeColor("black");
        button11.enabled = true;
        button12.changeColor("black");
        button12.enabled = true;
    }


    Grid {
        anchors.centerIn: parent
        rowSpacing: 10
        columnSpacing: 60
        rows: 6
        columns: 2

        Item {
            id: notInitialized
        }

        MatcherButton {
            id: button1
            onClicked: {
                clickedButton(button1);
            }
        }
        MatcherButton {
            id: button2
            onClicked: {
                clickedButton(button2);
            }
        }
        MatcherButton {
            id: button3
            onClicked: {
                clickedButton(button3);
            }
        }
        MatcherButton {
            id: button4
            onClicked: {
                clickedButton(button4);
            }
        }
        MatcherButton {
            id: button5
            onClicked: {
                clickedButton(button5);
            }
        }
        MatcherButton {
            id: button6
            onClicked: {
                clickedButton(button6);
            }
        }
        MatcherButton {
            id: button7
            onClicked: {
                clickedButton(button7);
            }
        }
        MatcherButton {
            id: button8
            onClicked: {
                clickedButton(button8);
            }
        }
        MatcherButton {
            id: button9
            onClicked: {
                clickedButton(button9);
            }
        }
        MatcherButton {
            id: button10
            onClicked: {
                clickedButton(button10);
            }
        }
        MatcherButton {
            id: button11
            onClicked: {
                clickedButton(button11);
            }
        }
        MatcherButton {
            id: button12
            onClicked: {
                clickedButton(button12);
            }
        }

    }
}
