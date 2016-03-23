import QtQuick 2.0
import VPlay 2.0

EntityBase{
    id: hawk
    entityType: "player"

    height: 60
    width: 60

    property int speed: 150
    property int health: 100
    property int shield: 0
    property int rockets: 5
    property int laserDamage: 10
    property int laserType: 1
    property int lives: 1
    property Scene scene

    Image{
        id: hawkImage
        source: "../assets/hawk.png"
        height: parent.height
        width: parent.width
    }

    function reduceHealth(amount){
        if(hawk.shield > 0){
            if(amount > hawk.shield){
                hawk.shield = 0;
                amount = amount - hawk.shield;
                hawk.reduceHealth(amount);
            }
            else{
                hawk.shield = hawk.shield - amount;
            }
        }
        else{
            hawk.health = hawk.health - amount;
        }
        if(hawk.health <= 0){
            hawk.lives--;
            hawk.health = 100;
            hawk.shield = 0;
            hawk.x = 20
            hawk.y = 130
        }
        if(hawk.lives == 0){
            scene.showGameOver();
        }
    }
}
