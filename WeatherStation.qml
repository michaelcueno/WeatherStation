/****************************************************************************
**
** Copyright (C) 2012 Michael Cueno.
** Contact: mcueno2@uic.edu
**
** This is the main QML file for the WeatherStation application developed for
** User Interface Design (CS422) @ UIC
**
**
****************************************************************************/

import QtQuick 2.0
import "qml"

Rectangle {

    property int metric: 0               // 0 = farenheit / 1 = celcius
    property int language: 1             // 1 = English / 2 = Swedish
    property string bg_source: ""        // Source image for background
    property string current_city: ""     // contains the name of the current city
    property int daytime: 0              // 0 = nighttime / 1 = Daytime
    property int cur_time                // Hour 1-24 (constant)
    property int cosmo_constant          // Used for positioning the sun/moon (Based off the cur_time)

    Component.onCompleted: init()

    id: mainWindow
    width: 1200
    height: 800

    // Changes based on day or night. TODO: Make different backgrounds for each condition
    Image { id: bg
        source: bg_source
    }

    Text { id: city_name
        text: current_city
        font.pixelSize: 30
        anchors { left: parent.left; top: parent.top; leftMargin: 30; topMargin: 30 }
        color: (daytime==0)? "white":"black"
    }

    // Includes Temp, day, condition.. etc. Center of the screen in the main view
    MainStats { id: main_stats;
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter; verticalCenterOffset: -80 }
        onCompleted: swiper.populate_hours(main_stats.num_hours, cur_time)
    }

    Image { id: cosmic_object   // either the sun or the moon
        source: (daytime==0)?"images/moon_unit.png":"images/sun.png"
        y: {var time = (swiper.index%12);
            var offset = time-7;
            if(offset==0){return mainWindow.height+500;}
            if(offset<0){
                offset = time + 5;
            }
            return ((mainWindow.height/11)*offset) - 200
        }
        x: mainWindow.width * (5/7)
        transitions: Transition {
            PropertyAnimation { properties: "x,y"; easing.type: Easing.Linear }
        }
    }

    // Settings/Dashboard accessor
    Image { id: drag_hook
        anchors {top: parent.top; horizontalCenter: parent.horizontalCenter }
        anchors.bottomMargin: drag_hook.height/2
        source: "images/dragger.png"

        MouseArea { id: dash_mouse_area
            anchors.fill: parent
            onClicked: dash.state = (dash.state==="focused")? "" : "focused";
            enabled: (dash.state==="focused")? false: true;
        }
    }

    // Hourly swiper that changes the hourly stats in mainStats
    Swiper {id: swiper; anchors.bottom: parent.bottom; anchors.left: parent.left; }

    Text { id: indoor
        text: (metric == 0)?"Indoor Temp: 72\u00b0f":"Indoor Temp: 22\u00b0c"
        color: (daytime==0)?"white":"black"
        font.pixelSize: 25
        anchors {bottom: parent.bottom; bottomMargin: 20; horizontalCenter: parent.horizontalCenter }
    }


    // Settings and cities view (this is where the user can change the city to focus on)
    Dashboard {id: dash; state: ""}

    function init(){
        main_stats.load("60607",0)  // Downloads json and sets environment variables
        current_city = "Chicago"
        reDraw()
        // Uncomment for populated hours and data when not connected to api
        // swiper.populate_hours(240, 1)
        // main_stats.synthData()
    }

    function reDraw(){
        bg_source = (daytime==0)?"images/nightsky.png":"images/blue-sky.jpg"
    }
}
