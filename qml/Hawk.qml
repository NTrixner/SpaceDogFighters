import QtQuick 2.0
import VPlay 2.0

EntityBase{
    id: hawk
    entityType: "player"

    height: 60
    width: 60

    Image{
        id: hawkImage
        source: "../assets/hawk.png"
        height: parent.height
        width: parent.width
    }
}
