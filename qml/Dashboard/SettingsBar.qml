import QtQuick 2.0
import "../"

Rectangle { id: container
    width: mainWindow.width
    height: mainWindow.height *(1/13);
    color: "grey"

    Text { id: language_title
        anchors { left: container.left; leftMargin: container.width/20; verticalCenter: container.verticalCenter }
        text: qsTr("Language")
        font.pixelSize: 20;
    }

    LanguageSelector {id: lang_selector
        anchors { left: language_title.right; leftMargin: 20; verticalCenter: container.verticalCenter; }
        anchors.verticalCenterOffset: -15;
        width: 120;
    }

    Text { id: metric_title
        anchors { horizontalCenter: container.horizontalCenter; verticalCenter: container.verticalCenter }
        anchors.horizontalCenterOffset: -50;
        text: "Metric"
        font.pixelSize: 20
    }

    Item { id: metric_selector
        anchors { horizontalCenter: container.horizontalCenter; verticalCenter: container.verticalCenter }
        anchors.verticalCenterOffset: -15;
        anchors.horizontalCenterOffset: 50;

        Rectangle { id: celcius
            width: 30; height: 30
            anchors {left: metric_selector.left}
            radius: 7
            smooth: true
            Text {
                anchors.centerIn: parent
                text: "C"
                font.pixelSize: 20;
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    current.state = "c"
                    mainWindow.metric = 1
                }
            }

        }

        Rectangle { id: farenheit
            width: 30; height: 30
            anchors {right: celcius.left; rightMargin: 15; }
            radius: 7
            Text {
                anchors.centerIn: parent
                text: "F"
                font.pixelSize: 20;
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    current.state = ""
                    mainWindow.metric = 0
                }
            }
        }

        Rectangle { id: current
            width: 36; height: 36
            opacity: .6
            anchors.centerIn: farenheit
            color: "steelblue"
            radius: 7

            states: State { name: "c"
                PropertyChanges { target: current; anchors.centerIn: celcius }
            }

            transitions: Transition { AnchorAnimation {duration: 10}}
        }
    }

    Text { id: new_city_title
        anchors { right: new_city.left; rightMargin: 20; verticalCenter: container.verticalCenter }
        text: "New City"
        font.pixelSize: 20
    }

    SearchBox { id: new_city
        anchors { right: parent.right; rightMargin: container.width/20; verticalCenter: container.verticalCenter }
        title: "City"
    }

    Rectangle { id: submit
        anchors { left: new_city.right; leftMargin: 15; verticalCenter: container.verticalCenter }
        width: 30
        height: 20
        Text {
            anchors.centerIn: parent
            text: "Add"
            font.pixelSize: 20
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                new_city.updateTitle()
                addCity(new_city.title)
            }
        }
    }

}
