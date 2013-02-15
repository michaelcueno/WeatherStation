function Tr(text) {
    
    var path = "http://api.wunderground.com/api/9d27ba09f7bb4b6e/hourly10day/q/CA/"+name+".json"
    var doc = new XMLHttpRequest();
    doc.setRequestHeader("Client", "");
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
