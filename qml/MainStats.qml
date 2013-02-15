import QtQuick 2.0

Item {
    width: 300
    height: 380

    signal completed

    // Properties declaration, All statistics used in all metrics
    property string temp_f
    property string temp_c
    property string day
    property string hour            // Military
    property string colour          // Either black or white
    property string civil           // Pretty time format
    property string condition


    // Other properties
    property int num_hours

    // JSON Object (needed globally to not make repeated calls to the API)
    property var jsonObject

    //Constants for the day (set in cities delegate)
    property string high_f
    property string high_c
    property string low_f
    property string low_c
    property string windspeedMiles
    property string windspeedKmph


    Rectangle { id: shade
        anchors.fill: parent
        radius: 10
        smooth: true
        opacity: .2
        color: (mainWindow.daytime==0)?"black":"white"
    }

    Text { id: weekday
        text: day + " " + civil
        anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; anchors.topMargin: 10;
        font.pixelSize: 30
        color: colour
    }

    Text { id: outdoor_temp
        text: (mainWindow.metric===0)? temp_f:temp_c
        font.pixelSize:80
        anchors.horizontalCenter: parent.horizontalCenter; anchors.top: weekday.top; anchors.topMargin: 30;
        color: colour
    }
    Text { id: c_f;
        anchors.left: outdoor_temp.right; anchors.verticalCenter: outdoor_temp.verticalCenter
        text: (mainWindow.metric===0)? "\u00b0f":"\u00b0c"
        font.pixelSize: 60
        color: colour
    }

    Text { id: condition_text
        text: condition
        anchors { top: outdoor_temp.bottom; horizontalCenter: parent.horizontalCenter; }
        font.pixelSize: 30
        color: colour
    }
    Rectangle { id: line_break
        color: colour
        width: parent.width
        height: 2
        anchors.top:condition_text.bottom; anchors.topMargin: 20
    }
    Text { id: today
        color: colour
        font.pixelSize: 30
        text: "Today's Predictions:"
        anchors { top: line_break.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 20 }
    }
    Text { id: high_low
        text: (mainWindow.metric==0)?high_f+"\u00b0f / "+low_f+"\u00b0f":temp_c+"\u00b0c /"+low_c+"\u00b0c"
        anchors { top: today.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 20 }
        font.pixelSize: 30
        color: colour
    }
    Text { id: wind_speed
        text: (mainWindow.metric==0)?"Wind: "+windspeedMiles+"mph":"wind: "+windspeedKmph+"kph"
        anchors { top: high_low.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 20 }
        font.pixelSize: 30
        color: colour
    }


    function load(name, index) {
        // Clear hours model so we don't just append
        swiper.clear()
        var path = "http://api.wunderground.com/api/9d27ba09f7bb4b6e/hourly10day/q/CA/"+name+".json"
        var doc = new XMLHttpRequest();
        doc.open("GET", path);
        doc.onreadystatechange = function(){
            if ( doc.readyState == XMLHttpRequest.DONE)
            {
                jsonObject = JSON.parse(doc.responseText);
                setVars(index)
                num_hours = jsonObject.hourly_forecast.length;
                mainWindow.cur_time = jsonObject.hourly_forecast[0].FCTTIME.hour
                swiper.static_cur_day = swiper.current_day
                completed();mainWindow.cur_time = hour
                mainWindow.reDraw()
            }
        }
        doc.send();
        console.log(path)

    }

    // Parses the JSON and sets the variables for use in QML
    // index: The hour to use for hourly, 0=current hour. Goes up to about 34
    function setVars(index){
        temp_f = jsonObject.hourly_forecast[index].temp.english
        temp_c = jsonObject.hourly_forecast[index].temp.metric
        day = jsonObject.hourly_forecast[index].FCTTIME.weekday_name
        hour = jsonObject.hourly_forecast[index].FCTTIME.hour
        civil = jsonObject.hourly_forecast[index].FCTTIME.civil
        condition = jsonObject.hourly_forecast[index].condition

        setHour(jsonObject.hourly_forecast[index].FCTTIME.hour)
    }

    // Sets the hour that we are currently using
    function setHour(hour){
        console.log("setColor: " + hour + " | <- thats the hour in military time")
        if(hour < 7 || hour > 19) { // Night
            colour = "white"
            mainWindow.daytime = 0
        }else{
            colour = "black"
            mainWindow.daytime = 1
        }
        mainWindow.reDraw()

        // Take care of setting the day
        if(day=="Monday") swiper.current_day = 0;
        if(day=="Tuesday") swiper.current_day = 1;
        if(day=="Wednesday") swiper.current_day = 2;
        if(day=="Thursday") swiper.current_day = 3;
        if(day=="Friday") swiper.current_day = 4;
        if(day=="Saturday") swiper.current_day = 5;
        if(day=="Sunday") swiper.current_day = 6;
    }

    function synthData(){
        temp_f = "72"
        day = "Thursday"
        hour = "6"           // Military
        setHour(hour)
        colour = "black"         // Either black or white
        civil = "4:00 PM"           // Pretty time format
        condition = "Sunny All Day"
        high_f = "80"
        low_f = "55"
        windspeedMiles = "10"
        windspeedKmph = "5"
    }


}
