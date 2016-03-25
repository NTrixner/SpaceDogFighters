import QtQuick 2.0
import VPlay 2.0

EntityBase{
    entityType: "Laser"
    height: 2
    width: 10

    //The path the laser should take
    property variant waypoints;

    Image{
        source: "../assets/laser.png"
        height: parent.height
        width: parent.width
    }

    BoxCollider{
        collidesWith: Box.Category2
        categories: Box.Category3
        width: parent.width; height: parent.height

        //add this line so the laser doesn't shove enemy ships around
        collisionTestingOnlyMode: true
    }

    PathMovement{
        //set the laser's velocity
        velocity: 300
        //set the laser's path
        waypoints: parent.waypoints
        //on completion, remove the entity from the Entity Manager
        onPathCompleted: parent.removeEntity();
    }
}
