import QtQuick 2.0
import "../"

Item { id: container
    width: mainWindow.width
    height: mainWindow.height *(1/13);
    Image { id: bg
        source: "../../images/settings_bg.png"
    }


    LanguageSelector {id: lang_selector
        anchors { left: parent.left; leftMargin: 120; verticalCenter: container.verticalCenter}
        anchors.verticalCenterOffset: -15;
        width: 120;
    }

    Image { id: metric_selector
        source: "../../images/metric_f.png"
        anchors.centerIn: parent
        MouseArea {
            anchors {left: parent.left; right: parent.horizontalCenter; top:parent.top; bottom:parent.bottom}
            onClicked: {
                metric_selector.source = "../../images/metric_f.png"
                mainWindow.metric = 0
            }
        }
        MouseArea {
            anchors {left: parent.horizontalCenter; right: parent.right;  top:parent.top; bottom:parent.bottom}
            onClicked: {
                metric_selector.source = "../../images/metric_c.png"
                mainWindow.metric = 1
            }
        }

    }

    Text { id: new_city_title
        anchors { right: new_city.left; rightMargin: 20; verticalCenter: container.verticalCenter }
        text: "New City"
        font.pixelSize: 25
    }

    SearchBox { id: new_city
        anchors { right: parent.right; rightMargin: container.width/20; verticalCenter: container.verticalCenter }
        title: "City"
    }

    Rectangle { id: submit
        anchors { left: new_city.right; leftMargin: 15; verticalCenter: container.verticalCenter }
        width: 40
        height: 30
        radius: 8
        color: "#00ff18"
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
