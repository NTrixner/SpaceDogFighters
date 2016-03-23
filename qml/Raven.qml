import QtQuick 2.0
import VPlay 2.0

EntityBase{
    entityType: "Raven"
    height: 50
    width: 50
    property int health: 50
    property Scene scene
    property Timer waveTimer

    Image{
        height: parent.height
        width: parent.width
        source: "../assets/raven.png"
    }

    PathMovement{
        velocity: 150
        waypoints: [
            {x: parent.x, y: parent.y},
            {x: 0 - parent.width, y: parent.y}
        ]
        onPathCompleted: destroyRaven();
    }

    BoxCollider{
        height: parent.height
        width: parent.width

        collidesWith: Box.Category4 | Box.Category1
        collisionTestingOnlyMode: true
        categories: Box.Category3
        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;

            if(collidedEntityType == "player"){
                collidedEntity.health -= 20;
                health -= 50;
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
    function destroyRaven(){
        removeEntity();
        scene.enemyAmount--;
        if(scene.enemyAmount == 0){
            scene.inWave = false;
            waveTimer.restart();
        }
    }
}
