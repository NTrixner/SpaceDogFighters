import QtQuick 2.0
import VPlay 2.0

EntityBase{
    entityType: "Raven"
    height: 50
    width: 50
    property int health: 50
    property variant waypoints
    property Level level


    Image{
        height: parent.height
        width: parent.width
        source: "../assets/raven.png"
    }


    PathMovement{
        id: ravenMovement
        velocity: 150
        waypoints: parent.waypoints
        onPathCompleted: destroyRaven();
        running: true;
        rotationAnimationEnabled: false
        onWaypointReached:{
            if(waypointIndex == 1)
            {
                level.stage = 2;
                level.startTimer();
                ravenMovement.running = false;
                shootingTimer.running = true;
            }
        }
    }

    Timer{
        id: shootingTimer
        interval: 300 + utils.generateRandomValueBetween(100, 600)
        repeat: true
        running: false
        onTriggered: shootLaser();
    }

    function stopShooting(){
        shootingTimer.running = false;
    }

    function startMoving(){
        ravenMovement.running = true;
    }

    function destroyRaven(){
        level.currentEnemies--;
        if(level.currentEnemies == 0){
            level.stage = 4;
            level.startTimer();
        }
        removeEntity();
    }

    BoxCollider{
        height: parent.height
        width: parent.width

        collidesWith: Box.Category1 | Box.Category3
        collisionTestingOnlyMode: true
        categories: Box.Category2

        fixture.onBeginContact: {
            //find out who the "other" body is
            var body = other.getBody();
            //Get the entity that the other body owns
            var collidedEntity = body.target;
            //Find out what type of entity it is (gotta be that Hawk!)
            var collidedEntityType = collidedEntity.entityType;
            if(collidedEntityType == "Hawk"){
                collidedEntity.loseHealth(40);
                health = 0;
            }
            else if (collidedEntityType == "Laser"){
                health -= 20;
                collidedEntity.removeEntity();
            }
            else if(collidedEntityType == "Rocket"){
                health -= 50;
                collidedEntity.removeEntity();
            }
            if(health <= 0){
                destroyRaven();
            }
        }
    }

    function shootLaser(){
        //Set the properties of the new laser
        var newEntityProperties = {
            waypoints: [
                Qt.point(x + width * 0.6, y + (height/2) - 1),
                Qt.point(-10, y + (height/2) - 1)
            ],
            z: 1
        }
        //Spawn a rocket from the Laser.qml file with our properties
        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("EnemyLaser.qml"),
                    newEntityProperties);
    }
}
