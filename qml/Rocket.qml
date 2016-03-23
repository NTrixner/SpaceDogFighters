import QtQuick 2.0
import VPlay 2.0

EntityBase {
    entityType: "Rocket"
    height: 10
    width: 20
    property point pointOfOrigin
    property Scene scene

    Image{
        source: "../assets/rocket.png"
        height: parent.height
        width: parent.width
    }

    PathMovement{
        velocity: 100
        waypoints: [
            {x: pointOfOrigin.x, y: pointOfOrigin.y - (parent.height / 2)},
            {x: scene.width, y: pointOfOrigin.y - (parent.height / 2)}
        ]
        onPathCompleted: parent.removeEntity();
    }

    BoxCollider{
        collidesWith: Box.Category3
        categories: Box.Category4
        width: parent.width; height: parent.height
        linearVelocity: Qt.point(100, 0)
        collisionTestingOnlyMode: true
    }

}
