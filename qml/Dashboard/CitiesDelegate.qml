import QtQuick 2.0

Rectangle { id: container

    property string tmp_f
    property string tmp_c
    property string icn_url

    // Object to hold json values
    property var jsonObject

    Component.onCompleted: load()

    width: 240
    height: 350
    radius: 10

    MouseArea { id: city_mouse_area
        anchors.fill: parent
        onClicked: {
            current_city = name
            main_stats.load(name,0)
            setMainStats()
            dash.state = ""
        }
        onPressAndHold: prompt_remove()
    }



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

    Rectangle { id: delete_me
        anchors.fill: parent
        color: "black"
        opacity: .8
        visible: false
        radius: 10

        Text { id: prompt
            text: "Delete This City?"
            font.pixelSize: 30;
            color: "white"
            anchors{ verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter; verticalCenterOffset: -50}
        }
        Image { id: del_btn
            source: "../../images/delete_up.png"
            anchors { top:prompt.bottom; topMargin: 20; left: parent.left; leftMargin:10 }
            MouseArea{
                enabled: delete_me.visible
                anchors.fill:parent
                onClicked: {
                    citiesModel.remove(this)
                }
            }
        }
        Image { id: cancel_btn
            source: "../../images/cancel_up.png"
            anchors { top:prompt.bottom; topMargin: 20; left: del_btn.right; leftMargin: 10; }
            MouseArea{
                enabled: delete_me.visible
                anchors.fill:parent
                onClicked: {
                    delete_me.visible = false
                }
            }
        }
    }

    function load() {

        var doc = new XMLHttpRequest();
        doc.open("GET", "http://free.worldweatheronline.com/feed/weather.ashx?key=3ae2e2fe7b212608132801&q="+name+"&3&format=json");
        doc.onreadystatechange = function(){
            if ( doc.readyState == XMLHttpRequest.DONE)
            {
                jsonObject = JSON.parse(doc.responseText);
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
        setMainStats()
    }

    function setMainStats(){

        main_stats.high_f = jsonObject.data.weather[0].tempMaxF
        main_stats.high_c = jsonObject.data.weather[0].tempMaxC
        main_stats.low_f = jsonObject.data.weather[0].tempMinF
        main_stats.low_c = jsonObject.data.weather[0].tempMinC
        main_stats.windspeedKmph = jsonObject.data.weather[0].windspeedKmph
        main_stats.windspeedMiles = jsonObject.data.weather[0].windspeedMiles
    }

    function prompt_remove(){
        delete_me.visible = true
    }

    function setCondition(x){

        switch (x){
        case '113':
            container.color = "#0099CC"; // Sunny
            icon.source = "../../images/Sunny.png"
            break
        case '116': // Partly Cloudy
            container.color = "#AEC5DF"
            icon.source = "../../images/PartlyCloudy.png"
            break
        case '119': // cloudy 
        case '122': 
        case '143': 
        case '248': 
            container.color = "grey"
            icon.source = "../../images/Cloudy.png"
            break
        case '176': // Rain
        case '182':
        case '185':
        case '266':
        case '263':
        case '281':
        case '284':
        case '293':
        case '296':
        case '299':
        case '302':
        case '305':
        case '308':
        case '311':
        case '317':
        case '320':
        case '353':
        case '356':
        case '359':
        case '362':
        case '365':
            container.color = "blue"
            icon.source = "../../images/Rain.png"
            break
        case '179':  // Snow 
        case '227':
        case '230':
        case '323':
        case '326':
        case '329':
        case '332':
        case '335':
        case '338':
        case '350':
        case '368':
        case '371':
        case '374':
        case '377':
            container.color = "white"
            icon.source = "../../images/Snow.png"
            break
        case '200': // Storm
        case '386':
        case '389':
        case '392':
        case '395':
            container.color = "dark_grey"
            icon.source = "../../images/Storm.png"
            break
        default:
            console.log(x);
            break

        }
    }
}
