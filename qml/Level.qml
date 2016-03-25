import QtQuick 2.0
import VPlay 2.0

EntityBase {
    //0: Game hasn't started yet
    //1: Enemies spawned and are now moving into the screen
    //2: Enemies are shooting
    //3: Enemies are moving towards the left screen border
    //4: Either all enemies have been killed or left the screen,
    //   waiting for a new wave to spawn
    property int stage: 4
    property int currentEnemies: 0
    property Scene gameScreen
    property EntityManager enemyManager
    entityType: "Level"
    id: level

    Timer{
        id: levelTimer
        //5 second timer
        interval: 5000
        //no cycle, we want to start it manually from our functions
        repeat: false
        //don't trigger automatically
        triggeredOnStart: false
        running: stage == 4 || stage == 1
        //handle trigger
        onTriggered:{
            switch(stage){
            case 4:
                //all enemies are either dead or have left the screen
                //5 seconds have passed after that
                spawnEnemies();
                stage = 1;
                break;
            case 2:
                //enemies have been shooting for 5 seconds
                //change the stage so they start moving
                var entities = enemyManager.getEntityArrayByType("Raven");
                for(var i = 0; i < entities.length; i++){
                    entities[i].startMoving();
                    entities[i].stopShooting();
                }

                stage = 3;
            }
        }
    }

    //spawns a wave of enemies
    function spawnEnemies(){
        //Define how many enemies could spawn at a maximum
        var positions = 6;

        //Variable to count the spawned enemies
        var newEnemies = 0;

        //divide the screen vertically by the amount of positions
        var enemyDistance = gameScreen.height / positions;

        //Try spawning enemies until at least one spawns
        while(newEnemies == 0){

            //loop through the positions
            for(var i = 0; i < positions; i++){

                //Create a random integer that can either be 1 or 2
                var spawn = Math.floor((Math.random()*2)+1);

                //50% chance per position to spawn an enemy
                if(spawn == 1){

                    //spawn one enemy at its position
                    spawnEnemy(gameScreen.width + 100, enemyDistance * i);
                    newEnemies++;
                }
            }
            //set the amount of spawned enemies as the current amount
            currentEnemies = newEnemies;
        }
    }

    //spawns a single enemy
    function spawnEnemy(x, y){
        //Set the properties of the new raven
        var newEntityProperties = {
            waypoints: [
                Qt.point(x, y),
                Qt.point(gameScreen.width - 80, y),
                Qt.point(-50, y)
            ],
            level: level,
            z: 2,
            x: x,
            y: y,
            rotation: 0

        }
        //Spawn an enemy from the Raven.qml file with our properties
        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Raven.qml"),
                    newEntityProperties);
    }

    //starts the LevelTimer
    function startTimer(){
        levelTimer.start();
    }
}
