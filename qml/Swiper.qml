import QtQuick 2.0

Item {

    property int index: hours.currentIndex
    property int current_day                        // 0=monday, 1=tuesday ...
    property int static_cur_day                            // Never changes, this is today

    width: mainWindow.width
    height: mainWindow.height*(1/4)

    Image { id: bg
        source: "../images/swipe_bg.png"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ListModel { id: hoursModel }

    Component { id: pathDelegate;
        Item {
            width: 90; height: 45
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: hour
                font.pixelSize: 25
                color: "white"
            }
        }
    }

    PathView { id: hours

        anchors.fill: parent
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        model: hoursModel
        delegate: pathDelegate

        path: Path { id: path
            startX: -8000; startY: 23100
            PathAttribute { name: "itemRotation"; value: 30 }
            PathQuad { x: mainWindow.width+8000; y: 23100; controlX: mainWindow.width/2; controlY: -23018}
            PathAttribute { name: "itemRotation"; value: 30 }
        }
        onCurrentIndexChanged: resetHour(currentIndex)
    }

    //--------------------------------- DAY BUTTONS -------------------------------------//
    Text { id: monday
        text: (mainWindow.language==1)?"Monday":"Måndag"
        font.pixelSize: 25;
        color: (current_day == 0)?"#1afffc":"white"
        anchors { left: parent.left; leftMargin: 125; bottom: parent.bottom; bottomMargin: 20 }
        rotation: -17;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                set_day(0);
            }
        }
    }
    Text { id: tuesday
        text: (mainWindow.language==1)?"Tuesday":"Tisdag"
        font.pixelSize: 25;
        color: (current_day == 1)?"#1afffc":"white"
        anchors { left: monday.left; leftMargin: 140; bottom: parent.bottom; bottomMargin: 50 }
        rotation: -10;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                set_day(1);
            }
        }
    }
    Text { id: wednesday
        text: (mainWindow.language==1)?"Wednesday":"Onsdag"
        font.pixelSize: 25;
        color: (current_day == 2)?"#1afffc":"white"
        anchors { left: tuesday.left; leftMargin: 140; bottom: parent.bottom; bottomMargin: 68 }
        rotation: -4;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                set_day(2);
            }
        }
    }
    Text { id: thursday
        text: (mainWindow.language==1)?"Thursday":"Torsdag"
        font.pixelSize: 25;
        color: (current_day == 3)?"#1afffc":"white"
        anchors { left: wednesday.left; leftMargin: 180; bottom: parent.bottom; bottomMargin: 72 }
        rotation: 1;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                set_day(3);
            }
        }
    }
    Text { id: friday
        text: (mainWindow.language==1)?"Friday":"​​Fredag"
        font.pixelSize: 25;
        color: (current_day == 4)?"#1afffc":"white"
        anchors { left: thursday.left; leftMargin: 150; bottom: parent.bottom; bottomMargin: 65 }
        rotation: 4.5;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                set_day(4);
            }
        }
    }
    Text { id: saturday
        text: (mainWindow.language==1)?"Saturday":"Lördag"
        font.pixelSize: 25;
        color: (current_day == 5)?"#1afffc":"white"
        anchors { left: friday.left; leftMargin: 110; bottom: parent.bottom; bottomMargin: 49 }
        rotation: 8.5;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                set_day(5);
            }
        }
    }
    Text { id: sunday
        text: (mainWindow.language==1)?"Sunday":"Söndag"
        font.pixelSize: 25;
        color: (current_day == 6)?"#1afffc":"white"
        anchors { left: saturday.left; leftMargin: 140; bottom: parent.bottom; bottomMargin: 22 }
        rotation: 15;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                set_day(6);
            }
        }
    }

    // Used for placement of the cosmic unit
    function set_day(day){

        var multiplier = day - static_cur_day
        if(multiplier<0){
            multiplier = multiplier + 7;
        }
        hours.currentIndex = 24*multiplier;
    }

    // Loads the hours into the swiper after downloading hourly data set
    function populate_hours(num_hours, cur_hour){

        for( var i=0; i<num_hours; i++ ){
            hoursModel.append({"hour": to_civil_time(i+cur_hour)})
        }
    }

    // Used to convert index (0-240) in the hours data to a readable time
    function to_civil_time(offset){

        if(offset <= 12){
            return offset + ":00\n am";
        }else if(offset > 12 && offset < 25){
            offset = offset - 12;
            return offset + ":00\n pm";
        }else{
            offset = offset - 24;
            return to_civil_time(offset);
        }
    }

    // Update main stats
    function resetHour(x){
        main_stats.setVars(x)

    }

    function clear(){
        hoursModel.clear()
    }
}
