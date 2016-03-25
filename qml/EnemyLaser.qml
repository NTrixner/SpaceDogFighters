import QtQuick 2.0
import VPlay 2.0

EntityBase{
    entityType: "EnemyLaser"
    height: 2
    width: 10

    //The path the laser should take
    property variant waypoints;

    Image{
        source: "../assets/enemylaser.png"
        height: parent.height
        width: parent.width
    }

    PathMovement{
        //set the laser's velocity
        velocity: 300
        //set the laser's path
        waypoints: parent.waypoints
        //on completion, remove the entity from the Entity Manager
        onPathCompleted: parent.removeEntity();
        rotationAnimationEnabled: false
    }

    BoxCollider{
        collidesWith: Box.Category1
        categories: Box.Category4
        width: parent.width; height: parent.height

        //add this line so the laser doesn't shove enemy ships around
        collisionTestingOnlyMode: true
        fixture.onBeginContact: {
            //find out who the "other" body is
            var body = other.getBody();
            //Get the entity that the other body owns
            var collidedEntity = body.target;
            //Find out what type of entity it is (gotta be that Hawk!)
            var collidedEntityType = collidedEntity.entityType;
            if(collidedEntityType == "Hawk"){
                collidedEntity.loseHealth(10);
                removeEntity();
            }
        }
    }


}
