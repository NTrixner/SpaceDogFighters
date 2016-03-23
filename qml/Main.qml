import VPlay 2.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    // You get free licenseKeys from http://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from http://v-play.net/licenseKey>"

    activeScene: scene

    // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
    // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
    // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
    // this resolution is for iPhone 4 & iPhone 4S
    screenWidth: 960
    screenHeight: 640

    EntityManager {
        id: entityManager
        entityContainer: scene
    }

    Scene {
        id: scene
        Keys.forwardTo: twoAxisController

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 480
        height: 320
        property bool inWave: false;
        property int enemyAmount: 0;

        PhysicsWorld {
            id: world
            updatesPerSecondForPhysics: 60
            debugDrawVisible: false
        }

        Image{
            id: bg
            source: "../assets/152143.jpg"
            anchors.fill: parent.gameWindowAnchorItem
            z: 0
        }

        Hawk{
            id: hawk
            x: 20
            y: 130
            z: 2

            TwoAxisController {
                id: twoAxisController

                xAxis: joystickController.controllerXPosition
                yAxis: joystickController.controllerYPosition
                inputActionsToKeyCode: {
                    "fire": Qt.Key_Control,
                    "altfire": Qt.Key_Alt,
                    "up":Qt.Key_Up,
                    "down":Qt.Key_Down,
                    "left":Qt.Key_Left,
                    "right":Qt.Key_Right
                }
                onInputActionPressed: {
                    if(actionName == "fire") {
                        shootLaser();
                    }
                    if(actionName == "altfire") {
                        shootRocket();
                    }
                }
            }
            BoxCollider {
                collidesWith: Box.Category2 | Box.Category3
                categories: Box.Category1
                id: hawkCollider
                width: parent.width; height: parent.height

                linearVelocity: Qt.point(hawk.speed*twoAxisController.xAxis, -1*hawk.speed*twoAxisController.yAxis)
            }
        }

        EntityBase{
            id: border
            BoxCollider{
                collidesWith: Box.Category1
                categories: Box.Category2
                id: topCollider
                width: scene.width
                height: 20
                y: 0
                x: 0
                bodyType: Body.Static
            }
            BoxCollider{
                collidesWith: Box.Category1
                categories: Box.Category2
                id: bottomCollider
                width: scene.width
                height: 20
                y: scene.height - 20
                x: 0
                bodyType: Body.Static
            }
            BoxCollider{
                collidesWith: Box.Category1
                categories: Box.Category2
                id: leftCollider
                width: 20
                height: scene.height - 40
                y: 20
                x: 0
                bodyType: Body.Static
            }
            BoxCollider{
                collidesWith: Box.Category1
                categories: Box.Category2
                id: rightCollider
                width: 20
                height: scene.height - 40
                y: 20
                x: scene.width * 0.6
                bodyType: Body.Static
            }
        }
        //Enemy wave control
        Timer{
            id: waveTimer;
            interval: 5000; running: true; repeat: false
            onTriggered: {
                    var upperRange = 6;
                    var newEnemies = Math.floor((Math.random()*upperRange)+1);
                    var enemyDistance = scene.height / newEnemies;
                    for(var i = 0; i < newEnemies; i++){
                        spawnEnemy(scene.width + 100, enemyDistance * i);
                    }
                    scene.enemyAmount = newEnemies;
                    scene.inWave = true;
                }
        }

    }
    JoystickControllerHUD {
        id: joystickController

        anchors{
            left: parent.left
            bottom: parent.bottom
            leftMargin: 10
            bottomMargin: 10
        }

        width: parent.width * 0.1; height: parent.width * 0.1

        visible: true

        onControllerXPositionChanged: twoAxisController.xAxis = controllerXPosition;
        onControllerYPositionChanged: twoAxisController.yAxis = controllerYPosition;
    }
    //HUD
    Text {
        id: healthText
        text: "Health: " + hawk.health
        color: "white"
        anchors{
            left: parent.left
            top: parent.top
            leftMargin: 10
            topMargin: 10
        }

        font.pointSize: 30
    }
    Text {
        id: livesText
        text: "Lives: " + hawk.lives
        color: "white"
        anchors{
            right: parent.right
            top: parent.top
            leftMargin: 10
            topMargin: 10
        }
        font.pointSize: 30
    }

    //Rocket HUD
    Image{
        id: rocketHUDImage
        source: "../assets/rocket_HUD.png"
        anchors {
            bottom: parent.bottom
            right: laserHUDImage.left
            rightMargin: 10
            bottomMargin: 10
        }
        width: parent.width * 0.1; height: parent.width * 0.1
        MouseArea{
            height: parent.height
            width: parent.width
            onClicked:{
                shootRocket();
            }
        }
    }
    Text{
        id: rocketText
        text: hawk.rockets
        color: "white"
        anchors {
            bottom: rocketHUDImage.bottom
            right: rocketHUDImage.right
            rightMargin: rocketHUDImage.width * 0.08
            bottomMargin: rocketHUDImage.height * 0.08
        }
        font.pointSize: 30
    }
    //Laser HUD
    Image{
        id: laserHUDImage
        source: "../assets/laser_HUD.png"
        anchors {
            bottom: parent.bottom
            right: parent.right
            rightMargin: 10
            bottomMargin: 10
        }
        width: parent.width * 0.1; height: parent.width * 0.1
        MouseArea{
            height: parent.height
            width: parent.width
            onClicked:{
                shootLaser();
            }
        }
    }
    Text{
        id: laserText
        text: "∞"
        color: "white"
        anchors {
            bottom: laserHUDImage.bottom
            right: laserHUDImage.right
            rightMargin: laserHUDImage.width * 0.08
            bottomMargin: laserHUDImage.height * 0.08
        }
        font.pointSize: 30
    }



    function shootRocket(){
        if(hawk.rockets > 0 ){
            var newEntityProperties = {
                pointOfOrigin: Qt.point(
                    hawk.x + hawk.width * 0.6,
                    hawk.y + (hawk.height/2)),
                z: 1,
                scene: scene
            }

            entityManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("Rocket.qml"),
                        newEntityProperties);
            hawk.rockets--;
        }
    }

    function shootLaser(){
        var newEntityProperties = {
            pointOfOrigin: Qt.point(
                hawk.x + hawk.width * 0.6,
                hawk.y + (hawk.height/2)),
            z: 1,
            scene: scene
        }

        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Laser.qml"),
                    newEntityProperties);
    }

    function spawnEnemy(x, y){
        var newEntityProperties = {
            x: x,
            y: y,
            z: 2,
            scene: scene,
            waveTimer: waveTimer
        }
        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Raven.qml"),
                    newEntityProperties);
    }
}


