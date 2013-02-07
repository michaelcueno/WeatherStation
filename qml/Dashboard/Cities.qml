import QtQuick 2.0

Rectangle {
    width: mainWindow.width
    height: mainWindow.height*(12/13)

    Image { id: bg
        source: "../../images/black_lozenge.png"
        fillMode: Image.Tile
        anchors.fill: parent
    }

    ListView { id: cities
        width: parent.width; height: parent.height
        model: citiesModel
        delegate: CitiesDelegate {}

    }

    ListModel {
        id: citiesModel
        ListElement {
            name: "Chicago"
        }
       /* ListElement {
            name: "Los_Angeles"
        } */
    }

    function addCity(city){
        citiesModel.append( { name: city } )
        cities.currentIndex = cities.count-1
        cities.currentItem.load()
    }
}
