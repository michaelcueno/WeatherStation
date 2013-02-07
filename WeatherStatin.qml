import QtQuick 2.0
import "qml"

Rectangle {

    property int metric: 0               // 0 = farenheit / 1 = celcius
    property string bg_source: ""        // Source image for background
    property string current_city: ""     // contains the name of the current city
    property int daytime: 0              // 0 = nighttime / 1 = Daytime
    property int cur_time // Hour 1-24
    property int cosmo_constant          // Used for positioning the sun/moon (Based off the cur_time)

    Component.onCompleted: init()

    id: mainWindow
    width: 1200
    height: 800

    Image { id: bg
        source: bg_source
    }



    Text { id: city_name
        text: current_city
        font.pixelSize: 30
        anchors { left: parent.left; top: parent.top; leftMargin: 30; topMargin: 30 }
        color: (daytime==0)? "white":"black"
    }

    // Gonna need a javascript model
    MainStats { id: main_stats;
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter; verticalCenterOffset: -80 }
        onCompleted: swiper.populate_hours(main_stats.num_hours, cur_time)
    }

    Image { id: cosmic_object   // either the sun or the moon
        source: (daytime==0)?"images/moonunit.png":"images/sun.png"
        y: {var time = (swiper.index%12);
            var offset = time-7;
            if(offset==0){return mainWindow.height+500;}
            if(offset<0){
                offset = time + 5;
            }
            return ((mainWindow.height/11)*offset) - 200
        }
        x: mainWindow.width * (3/5)
        transitions: Transition {
            PropertyAnimation { properties: "x,y"; easing.type: Easing.Linear }
        }
    }

    Image { id: drag_hook // This should be an image!
        anchors {top: parent.top; horizontalCenter: parent.horizontalCenter }
        anchors.bottomMargin: drag_hook.height/2
        source: "images/dragger.png"

        MouseArea { id: dash_mouse_area
            anchors.fill: parent
            onClicked: dash.state = (dash.state==="focused")? "" : "focused";
            enabled: (dash.state==="focused")? false: true;
        }
    }

    Swiper {id: swiper; anchors.bottom: parent.bottom; anchors.left: parent.left; }

    Text{ text: swiper.index % 12
        anchors.top: mainWindow.top
        font.pixelSize: 50;
        color: "gray"
    }

    Dashboard {id: dash; state: ""}


    function init(){
        main_stats.load("Chicago",0)  // Downloads json and sets environment variables
        current_city = "Chicago"
        reDraw()
        // toggle for populated hours when not connected to api
        // swiper.populate_hours(36, 1)
    }

    function reDraw(){
        bg_source = (daytime==0)?"images/nightsky.png":"images/blue-sky.jpg"
    }
}
