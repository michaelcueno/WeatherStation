import QtQuick 2.0

Item {
    width: 300
    height: 380

    signal completed

    // Properties declaration, All statistics used in all metrics
    property string temp_f
    property string temp_c
    property string day
    property string hour
    property string wind_mph
    property string pressure_in
    property string colour

    // Other properties
    property int num_hours


    Rectangle { id: shade
        anchors.fill: parent
        radius: 10
        smooth: true
        opacity: .2
        color: "black"
    }

    Text { id: outdoor_temp
        text: (mainWindow.metric===0)? temp_f:temp_c
        font.pixelSize:80
        anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; anchors.topMargin: 10;
        color: colour
    }
    Text { id: c_f;
        anchors.left: outdoor_temp.right; anchors.verticalCenter: outdoor_temp.verticalCenter
        text: (mainWindow.metric===0)? "\u00b0f":"\u00b0c"
        font.pixelSize: 60
        color: colour
    }
    Text { id: weekday
        text: day
        anchors {top: outdoor_temp.bottom; left: parent.left; leftMargin:20; }
        font.pixelSize: 40
        color: colour
    }
    Text { id: selected_hour
        text: hour
        anchors {top: weekday.top; left: weekday.right; leftMargin: 10; }
        font.pixelSize: 40
        color: colour
    }




    function load(name, index) {

        var path = "http://api.wunderground.com/api/9d27ba09f7bb4b6e/hourly/q/CA/"+name+".json"
        var doc = new XMLHttpRequest();
        doc.open("GET", path);
        doc.onreadystatechange = function(){
            if ( doc.readyState == XMLHttpRequest.DONE)
            {
                var jsonObject = JSON.parse(doc.responseText);
                loaded(jsonObject, index)
            }
        }
        doc.send();
        console.log(path)
    }

    function loaded(jsonObject, index){
        temp_f = jsonObject.hourly_forecast[index].temp.english
        temp_c = jsonObject.hourly_forecast[index].temp.metric
        day = jsonObject.hourly_forecast[index].FCTTIME.weekday_name_abbrev
        hour = jsonObject.hourly_forecast[index].FCTTIME.civil

        num_hours = jsonObject.hourly_forecast.length
        setColour(jsonObject.hourly_forecast[index].FCTTIME.hour)

        completed()
    }

    function setColour(hour){
        if(hour < 7 || hour > 19) { // Night
            colour = "white"
            mainWindow.daytime = 0
        }else{
            colour = "black"
            mainWindow.daytime = 1
        }
    }
}
