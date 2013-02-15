import QtQuick 2.0
import "Dashboard"

Rectangle { id: dashboard

    width: mainWindow.width
    height: mainWindow.heigh

    y: -mainWindow.height


    Cities { id: cities;
        anchors { top: settings_bar.bottom; }
        width: parent.width
    }

    SettingsBar {id: settings_bar; x: 0; y:0}

    Image { id: drag_hook // This should be an image!
        anchors {bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        source: "../images/dragger.png"
        rotation: 180;
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
