import QtQuick 2.0
import "Dashboard"

Rectangle { id: dashboard

    width: mainWindow.width
    height: mainWindow.height

    y: -mainWindow.height


    Cities { id: cities;
        anchors { top: settings_bar.bottom; }
        width: parent.width
    }

    SettingsBar {id: settings_bar; x: 0; y:0}

    Rectangle { id: drag_hook // This should be an image!
        width: parent.width*(1/5); height: mainWindow.height*(1/12)
        anchors {bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }

        color: "red"

        MouseArea {
            anchors.fill: parent
            onClicked: dashboard.state = (dashboard.state==="focused")? "" : "focused";
        }
    }

    states: State { name: "focused"
        PropertyChanges { target: dashboard; y:0; }
    }

    transitions: Transition {
        NumberAnimation { target: dashboard; property: "y"; easing.type: Easing.OutCubic }
    }

    function addCity(city){
        cities.addCity(city)
    }

}
