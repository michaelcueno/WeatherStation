import QtQuick 2.0

Item { id: container

    Item {
        id:comboBox
        property int selectedItem: 0;
        property alias selectedIndex: listView.currentIndex;
        signal comboClicked;
        width: 120;
        height: 30;
        z: 100;
        smooth:true;

        onComboClicked: {
            mainWindow.language = selectedItem
        }

        Rectangle {
            id:chosenItem
            width:parent.width;
            height:comboBox.height;
            color: "#0090ff"
            smooth:true;
            radius: 6
            Text {
                anchors.centerIn: parent;
                anchors.margins: 8;
                id:chosenItemText
                text: "English"
                font.family: "Arial"
                font.pointSize: 20;
                smooth:true
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    comboBox.state = comboBox.state==="dropDown"?"":"dropDown"
                }
            }
        }

        Rectangle {
            id:dropDown
            width:comboBox.width;
            height:0;
            clip:true;
            anchors.top: chosenItem.bottom;
            anchors.margins: 2;
            color: "lightgray"

            ListView {
                id:listView
                height:500;
                model: languages
                currentIndex: 0
                delegate: Item{
                    width:comboBox.width;
                    height: comboBox.height;

                    Text {
                        text: name
                        anchors.centerIn: parent
                        font.pixelSize: 20
                    }
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            comboBox.state = ""
                            var prevSelection = chosenItemText.text
                            chosenItemText.text = name
                            comboBox.selectedItem = number
                            if(chosenItemText.text != prevSelection){
                                comboBox.comboClicked();
                            }
                            listView.currentIndex = index;
                        }
                    }
                }
            }
        }

        Component {
            id: highlight
            Rectangle {
                width:comboBox.width;
                height:comboBox.height;
                color: "red";
            }
        }

        states: State {
            name: "dropDown";
            PropertyChanges { target: dropDown; height:30*languages.count }
        }

        transitions: Transition {
            NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
        }
    }

    ListModel { id: languages
        ListElement {
            name: "English"
            number: 1;
        }
        ListElement {
            name: "Swedish"
            number: 2;
        }
        ListElement {
            name: "French"
            number: 3;
        }
        ListElement {
            name: "Spanish"
            number:4;
        }
        ListElement {
            name: "Korean"
            number: 5;
        }
        ListElement {
            name: "Spanglish"
            number: 6;
        }
        ListElement {
            name: "Turkish"
            number: 7;
        }
        ListElement {
            name: "Arabic"
            number: 8;
        }
        ListElement {
            name: "Chinese"
            number: 9;
        }
        ListElement {
            name: "Clingon"
            number: 10;
        }
    }

}
