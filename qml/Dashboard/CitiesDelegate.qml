import QtQuick 2.0

Rectangle {

    Component.onCompleted: load()

    width: mainWindow.width
    height: 100
    Text { id: city_name;
        width: 150
        text: name; }

    ListModel { id: weeklyModel }

    ListView { id: visualModel;
        anchors {top: parent.top; bottom: parent.bottom; left: city_name.right; right: parent.right}
        delegate: DashCityDelegate {}
        orientation: ListView.Horizontal
        clip: true
        model: weeklyModel
    }

    function load() {

        weeklyModel.clear();
        var doc = new XMLHttpRequest();
        doc.open("GET", "http://api.wunderground.com/api/9d27ba09f7bb4b6e/forecast10day/q/CA/"+name+".json");
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
        for ( var index in jsonObject.forecast.simpleforecast.forecastday )
        {
            weeklyModel.append({
                             "high_f" : jsonObject.forecast.simpleforecast.forecastday[index].high.fahrenheit,
                             "high_c" : jsonObject.forecast.simpleforecast.forecastday[index].high.celsius
                               })
        }


    }
}
