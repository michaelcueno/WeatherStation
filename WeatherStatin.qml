import QtQuick 2.0
import "qml"

Rectangle {

    property int metric: 0   // 0 = farenheit / 1 = celcius
    property string bg_source: ""
    property string current_city: ""
    property int daytime: 0  // 0 = nighttime / 1 = Daytime

    Component.onCompleted: init()

    id: mainWindow
    width: 1200
    height: 800

    Image { id: bg
        source: bg_source
    }

    Rectangle { id: drag_hook // This should be an image!
        width: parent.width*(1/5); height: mainWindow.height*(1/12)
        anchors {top: parent.top; horizontalCenter: parent.horizontalCenter }
        anchors.bottomMargin: drag_hook.height/2
        color: "red"

        MouseArea { id: dash_mouse_area
            anchors.fill: parent
            onClicked: dash.state = (dash.state==="focused")? "" : "focused";
            enabled: (dash.state==="focused")? false: true;
        }
    }

    Text { id: city_name
        text: current_city
        font.pixelSize: 30
        anchors { left: parent.left; top: parent.top; leftMargin: 30; topMargin: 30 }
        color: (daytime==0)? "white":"black"
    }

    // Gonna need a javascript model
    MainStats {id: main_stats;
        anchors.centerIn:parent
        onCompleted: swiper.populate_hours(main_stats.num_hours)
    }

    Swiper {id: swiper; anchors.bottom: parent.bottom; anchors.left: parent.left; }

    Dashboard {id: dash; state: ""}

    function init(){
        bg_source = (daytime==1)?"images/nightsky.png":"images/blue-sky.jpg"
        current_city = "Chicago"
        main_stats.load("Chicago",0)
    }

}
