import QtQuick 2.0
import VPlay 2.0

EntityBase {
    //Entity type, used for collision detection
    entityType: "Hawk"

    //size relative to the parent - in our case, the scene. This makes these "logical" pixels.
    height: 60
    width: 60

    //EntityManager responsible for spawning missiles
    property EntityManager missileManager;

    //The scene the hawk is in
    property Scene hawkScene

    //How many missiles are left
    property int rockets: 5

    //How many lives the player has left
    property int lives: 3

    //How many health the player currently has
    property int health: 100

    ParticleVPlay {
        id: engineParticle
        //Position relative to the parent
        x: 10
        y: parent.height / 2
        //Gravity emitter
        emitterType: 0.0
        //Pull the particles WAY strong to the left
        gravity : Qt.point(-1000.0, 0.0)
        angle: 180
        //Start the effect automatically
        autoStart: true
        //Some color settings
        startColor : "#e6e0fa"
        startColorAlpha : 0.2
        startColorVariance : "#000000"
        startColorVarianceAlpha : 0.1
        //Our particle texture
        textureFileName: "../assets/particleNapalm.png"
        //Make the effect visible
        visible: true

        //Now follow some settings about size and speed
        //The rocket has different values here
        //Everything above is the same
        startParticleSize : 7.0
        startParticleSizeVariance: 2.0
        speed : 70.0
        maxParticles : 190.0
        particleLifespan : 0.2
        particleLifespanVariance : 0.005
    }

    //The hawk image
    Image{
        id: hawkImage
        source: "../assets/hawk.png"

        //bind the size to the EntityBase's size - they'll always be the same
        height: parent.height
        width: parent.width
    }

    function shootRocket(){
        //Do we even have rockets?
        if(rockets > 0 ){
            //Set the properties of the new rocket
            var newEntityProperties = {
                waypoints: [
                    Qt.point(hawk.x + hawk.width * 0.6, hawk.y + (hawk.height/2) - 5),
                    Qt.point(scene.width, hawk.y + (hawk.height/2) - 5)
                ],
                z: 1
            }
            //Spawn a rocket from the Rocket.qml file with our properties
            entityManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("Rocket.qml"),
                        newEntityProperties);
            //Reduce the amount of rockets left
            rockets--;
        }
    }

    function shootLaser(){
        //Set the properties of the new laser
        var newEntityProperties = {
            waypoints: [
                Qt.point(x + width * 0.6, y + (height/2) - 1),
                Qt.point(hawkScene.width, y + (height/2) - 1)
            ],
            z: 1
        }
        //Spawn a rocket from the Laser.qml file with our properties
        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Laser.qml"),
                    newEntityProperties);
    }

    function loseHealth(amount){
        health -= amount;
        if(health <= 0)
        {
            lives--;
            health = 100;
            x = 20;
            y = 130;
        }
        if(lives <= 0){
            //scene.gameOver();
        }
    }

}
