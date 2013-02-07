import QtQuick 2.0

Item {

    property int index: hours.currentIndex

    width: mainWindow.width
    height: mainWindow.height*(1/4)

    Image { id: bg
        source: "../images/swipe_bg2.png"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ListModel { id: hoursModel }

    Component { id: highlighter
        Rectangle { width: 80; height: 80; color: "lightsteelblue"; opacity: .5}
    }

    Component { id: pathDelegate;
        Item {
            width: 90; height: 45
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: hour
                font.pixelSize: 25
                color: "white"
                rotation: PathView.itemRotationasdf
            }
        }
    }

    PathView { id: hours

        anchors.fill: parent
        highlight: highlighter
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        model: hoursModel
        delegate: pathDelegate

        path: Path { id: path
            startX: -700; startY: 500
            PathAttribute { name: "itemRotation"; value: 30 }
            PathQuad { x: mainWindow.width+760; y: 500; controlX: mainWindow.width/2; controlY: -460}
            PathAttribute { name: "itemRotation"; value: 30 }
        }

        onCurrentIndexChanged: resetHour(currentIndex)
    }

    Text { id: today
        text: "Today"
        font.pixelSize: 25
        color: "white"
        anchors { horizontalCenter: parent.horizontalCenter; horizontalCenterOffset: -240 }
        anchors { verticalCenter: parent.verticalCenter }
        MouseArea {
            anchors.fill: parent
            onClicked: hours.currentIndex = 0;
        }
    }
    Text { id: tomorrow
        text: "Tomorrow"
        font.pixelSize: 25
        color: "white"
        anchors { left: today.right; leftMargin: 160 }
        anchors { verticalCenter: parent.verticalCenter; verticalCenterOffset: -20 }
        MouseArea {
            anchors.fill: parent
            onClicked: { hours.currentIndex = hours.currentIndex + 24
                console.log("Clicked");
            }
        }
    }
    Text { id: second_day
        text: "2daysaway"
        font.pixelSize: 25
        color: "white"
        anchors { left: tomorrow.right; leftMargin: 160 }
        anchors { verticalCenter: parent.verticalCenter }
        MouseArea {
            anchors.fill: parent
            onClicked: hours.currentIndex + 30
        }
    }

    function populate_hours(num_hours, cur_hour){

        for( var i=0; i<num_hours; i++ ){
            hoursModel.append({"hour": to_civil_time(i+cur_hour)})
        }
    }

    function to_civil_time(offset){

        if(offset <= 12){
            return offset + ":00\n am";
        }else if(offset > 12 && offset < 24){
            offset = offset - 12;
            return offset + ":00\n pm";
        }else{
            offset = offset - 24;
            console.log(offset)
            return to_civil_time(offset);
        }
    }

    function resetHour(x){
        main_stats.setVars(x)
    }
}
