import QtQuick 2.0
import VPlay 2.0

EntityBase {
    entityType: "Rocket"
    height: 10
    width: 20
    property point pointOfOrigin
    x: pointOfOrigin.x
    y: pointOfOrigin.y - (height / 2)
    property Scene scene

    Image{
        source: "../assets/rocket.png"
        height: parent.height
        width: parent.width
    }
    BoxCollider{
        collidesWith: Box.Category3
        categories: Box.Category4
        width: parent.width; height: parent.height
        linearVelocity: Qt.point(100, 0)
    }
    Timer{
        interval: 500; running: true; repeat: true
        onTriggered: {
            if(x > scene.width)
                removeEntity()
        }
    }
}
