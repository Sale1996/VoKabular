import QtQuick
import QtQuick.Controls

Frame {
    //id: categoriesFrameComponent
    property var categories;

    signal categoryChecked(var text, var checked)

    /*
    Sta je ideja napisacu ovde...

    Problem, kako azurirati svojstva komponenti unutar jedne komponente...
    Ideja je da se to radi preko State-ova... mi imamo vise stateova kao FSM...
    tipa za centralni deo, kada damo tacan odgovor, kada damo netacna odgovor,
    kada je pocetno stanje itd...

    E sad promenu state-ova mozemo uraditi tako sto cemo izloziti jednu javascript funciju
    na izlaz ove komponente... i onda samo preko nje menjati state-ove...

    */

    //Frame {
        id: categoriesFrame
        width: 200
        height: 200

        ScrollView {
            id: categoriesScrollView
            anchors.fill: parent
            smooth: false
            contentWidth: 160
            padding: 5

            ListView {
                visible: true
                model: categories
                clip: true
                delegate: CheckDelegate {
                    id: categoriesCheckDelegate
                    width: 160
                    height: 30
                    text: modelData
                    onCheckedChanged: {
                        //wordFrame.changeState(wordFrame.wordFrameStates.)
                        //textField.enabled = true
                        //text -> sta je checkirano
                        //checked -> da li je checkirano ili unchekirano
                        categoryChecked(text, checked)
                        //backend.chosenCategoriesUpdated(text, checked)
                        //console.log(checked)
                    }
                }
            }
        }
   // }
}
