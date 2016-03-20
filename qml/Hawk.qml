import QtQuick 2.0
import VPlay 2.0

EntityBase{
    id: hawk
    entityType: "player"

    height: 60
    width: 60

    property int speed: 150
    property int health: 100
    property int shield: 0
    property int rockets: 5
    property int laserDamage: 10
    property int laserType: 1
    property int lives: 3

    Image{
        id: hawkImage
        source: "../assets/hawk.png"
        height: parent.height
        width: parent.width
    }
}
