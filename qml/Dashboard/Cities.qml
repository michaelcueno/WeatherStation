import QtQuick 2.0

Rectangle {
    width: mainWindow.width
    height: mainWindow.height*(12/13)

    Image { id: bg
        source: "../../images/black_lozenge.png"
        fillMode: Image.Tile
        anchors.fill: parent
    }

    GridView { id: cities
        anchors { centerIn: parent }
        width: parent.width-80; height: parent.height - 30
        model: citiesModel
        delegate: CitiesDelegate {}
        cellHeight: 370
        cellWidth: 280
    }

    ListModel {
        id: citiesModel
        ListElement {
            name: "Chicago"
        }
        ListElement {
            name: "Los Angeles"
        }
        ListElement {
            name: "Seattle, WA"
        }
        ListElement {
            name: "Seoul, Korea"
        }
        ListElement {
            name: "Denver, CO"
        }
    }

    // Called by the settingsBar when user enters a city and taps 'add'
    function addCity(city){
        citiesModel.append( { name: city } )
        cities.currentIndex = cities.count-1
        cities.currentItem.load()
    }
}
