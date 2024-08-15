import QtQuick
import QtQuick.Controls

Button {
    id: wordMatcherButton
    width: 150
    height: 50

    function getTextItem() {
        return buttonText.text;
    }

    function setTextItem(newText) {
        buttonText.text = newText;
    }

    function changeColor(newColor) {
        buttonBackground.color = newColor;
    }

    contentItem: Text {
        id: buttonText
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: "Word matcher"
        fontSizeMode: Text.HorizontalFit
        minimumPixelSize: 8
        font.pixelSize: 20
        color: "white"
    }

    background: Rectangle {
        id: buttonBackground
        color: "black"
    }
}
