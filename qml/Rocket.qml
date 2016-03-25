import QtQuick 2.0
import VPlay 2.0

EntityBase{
    entityType: "Rocket"
    height: 10
    width: 20

    //The path the rocket should take
    property variant waypoints

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
        //The hawk has different values here
        //Everything above is the same
        startParticleSize : 4.0
        startParticleSizeVariance: 0.5
        speed : 30.0
        maxParticles : 90.0
        particleLifespan : 0.1
        particleLifespanVariance : 0.01
    }

    Image{
        source: "../assets/rocket.png"
        height: parent.height
        width: parent.width
    }

    BoxCollider{
        collidesWith: Box.Category2
        categories: Box.Category3
        width: parent.width; height: parent.height

        //Add this line so the rocket doesn't shove enemy ships around
        collisionTestingOnlyMode: true
    }

    PathMovement{
        //set the rocket's velocity
        velocity: 100
        //set the rocket's path
        waypoints: parent.waypoints
        //on completion, remove the entity from the Entity Manager
        onPathCompleted: parent.removeEntity();
    }
}
