import QtQuick 2.0

Rectangle { id: container

    property string tmp_f
    property string tmp_c
    property string icn_url

    Component.onCompleted: load()

    width: 250
    height: 350
    radius: 10

    Text { id: city_name;
        anchors {top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 8 }
        width: 150
        text: name;
        font.pixelSize: 35
    }

    Text { id: temp
        anchors { top: city_name.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 20 }
        text: (mainWindow.metric==0)?tmp_f+"\u00b0f":tmp_c+"\u00b0c"
        font.pixelSize: 60
    }

    Image { id: icon
        anchors { top: temp.bottom; horizontalCenter: parent.horizontalCenter; topMargin: -20 }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            current_city = name
            main_stats.load(name,0)
            dash.state = ""

        }
    }

    function load() {

        var doc = new XMLHttpRequest();
        doc.open("GET", "http://free.worldweatheronline.com/feed/weather.ashx?key=3ae2e2fe7b212608132801&q="+name+"&3&format=json");
        doc.onreadystatechange = function(){
            if ( doc.readyState == XMLHttpRequest.DONE)
            {
                var jsonObject = JSON.parse(doc.responseText);
                loaded(jsonObject)
            }
        }
        doc.send();
    }

    function loaded(jsonObject)
    {
        tmp_f = jsonObject.data.current_condition[0].temp_F
        tmp_c = jsonObject.data.current_condition[0].temp_C

        setCondition(jsonObject.data.current_condition[0].weatherCode)
    }

    function setCondition(x){

        switch (x){
        case '113':
            container.color = "#0099CC"; // Sunny
            icon.source = "../../images/Sunny.png"
            break
        case '116': // Partly Cloudy
            container.color = "#AEC5DF"
            icon.source = "../../images/Cloudy.png"
            break
        case '119' || '122' || '143' || '248': // cloudy
            container.color = "grey"
            icon.source = "../../images/Cloudy.png"
            break
        case '176'||'182'||'185'||'266'||'263'||'281'||'284'||'293'||'296'||'299'||'302'||'305'||'308'||'311'||'317'||'320'||'353'||'356'||'359'||'362'||'365': // Rain
            container.color = "blue"
            icon.source = "../../images/Rain.png"
            break
        case '179' || '227' || '230'||'323'||'326'||'329'||'332'||'335'||'338'||'350'||'368'||'371'||'374'||'377': // Snow
            container.color = "white"
            icon.source = "../../images/Sunny.png"
            break
        case '200'||'386'||'389'||'392'||'395': // Storm
            container.color = "dark_grey"
            icon.source = "../../images/Storm.png"
            break

        }
    }
}
