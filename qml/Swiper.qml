import QtQuick 2.0

Item {
    width: mainWindow.width
    height: mainWindow.height*(1/4)

    Image { id: bg
        source: "../images/swipe_bg.png"
    }

    ListModel { id: hoursModel }

    PathView { id: hours

        anchors.fill: parent
        model: hoursModel
        delegate: Item {
            width: 50; height: 30
            Text {
                text: hour
                font.pixelSize: 30
                color: "white"
            }
        }
        path: Path {
            startX: mainWindow.width/2; startY: 20
            PathQuad { x: mainWindow.width/2; y: mainWindow.height*(1/4)+80; controlX: 1700; controlY: 150}
        }
    }

    function populate_hours(num_hours){

        for( var i=0; i<num_hours; i++ ){
            hoursModel.append({"hour": i})
            console.log(i)

        }
    }
}
