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
    property string wind_mph
    property string pressure_in
    property string colour          // Either black or white
    property string civil           // Pretty time format
    property string condition
    property string sky             // Sky condition
    property string humidity
    property string pop             // Not sure yet

    // Other properties
    property int num_hours

    // JSON Object (needed globally to not make repeated calls to the API)
    property var jsonObject


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
        anchors {top: outdoor_temp.bottom; horizontalCenter: parent.horizontalCenter }
        font.pixelSize: 30
        color: colour
    }
    Text { id: condion_text
        text: condition
        anchors { top: weekday.bottom; horizontalCenter: parent.horizontalCenter; }
        font.pixelSize: 30
        color: colour
    }
    Text { id: selected_hour
        text: civil
        anchors {top: weekday.top; left: weekday.right; leftMargin: 10; }
        font.pixelSize: 40
        color: colour
    }
    Text { id: sky_text
        text: sky
        anchors {top: selected_hour.bottom; horizontalCenter: parent.horizontalCenter}
        font.pixelSize: 40
        color: colour
    }
    Text { id: humidity_text
        text: humidity
        anchors {top: sky_text.bottom; horizontalCenter: parent.horizontalCenter }
        font.pixelSize: 40
        color: colour
    }
    Text { id: pop_text
        text: pop
        anchors {top: humidity_text.bottom; horizontalCenter: parent.horizontalCenter }
        font.pixelSize: 40
        color: colour
    }





    function load(name, index) {

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
                completed();
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
        day = jsonObject.hourly_forecast[index].FCTTIME.weekday_name_abbrev
        hour = jsonObject.hourly_forecast[index].FCTTIME.hour
        civil = jsonObject.hourly_forecast[index].FCTTIME.civil
        condition = jsonObject.hourly_forecast[index].condition
        sky = jsonObject.hourly_forecast[index].sky
        humidity = jsonObject.hourly_forecast[index].humidity
        pop = jsonObject.hourly_forecast[index].pop
        day = jsonObject.hourly_forecast[index].FCTTIME.weekday_name_abbrev

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
        if(day=="Mon") swiper.current_day = 0;
        if(day=="Tue") swiper.current_day = 1;
        if(day=="Wed") swiper.current_day = 2;
        if(day=="Thu") swiper.current_day = 3;
        if(day=="Fri") swiper.current_day = 4;
        if(day=="Sat") swiper.current_day = 5;
        if(day=="Sun") swiper.current_day = 6;
    }
}
