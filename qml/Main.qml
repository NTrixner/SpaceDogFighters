import VPlay 2.0
import QtQuick 2.0

GameWindow {
    //the identifier of the game window
    id: gameWindow

    //tell the game window to load our game as the active scene - this can be changed in order
    //to create menus etc.
    activeScene: scene

    //the initial size of the game window
    screenWidth: 960
    screenHeight: 640

    //our EntityManager
    EntityManager {
        id: entityManager
        //the scene for which the EntityManager manages entities
        entityContainer: scene
    }

    //our game will be created as this scene
    Scene {
        //the scene's identifier
        id: scene

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 480
        height: 320

        //Tell the scene to forward keyboard inputs to our TwoAxisController
        Keys.forwardTo: twoAxisController

        //make Physics happen!
        PhysicsWorld {
            id: world
            //physics should run at 60 fps
            updatesPerSecondForPhysics: 60
            //draw borders around colliders or not
            debugDrawVisible: false
        }

        //border to restrict player movement
        ScreenBorder{
            scene: scene
        }

        //create an image
        Image{
            //background id
            id: bg
            //source file
            source: "../assets/background.jpg"
            //make it fill the whole window
            anchors.fill: parent.gameWindowAnchorItem
            //make it the "lowest" image in the scene, meaning it gets drawn first
            z: 0
        }

        Level{
            enemyManager: entityManager
            gameScreen: scene
        }

        //add the player entity
        Hawk{
            id: hawk
            x: 20
            y: 130
            z: 2
            missileManager: entityManager
            hawkScene: scene

            BoxCollider {
                collidesWith: Box.Category2 | Box.Category4 | Box.Category5
                categories: Box.Category1
                id: hawkCollider
                width: parent.width; height: parent.height

                linearVelocity: Qt.point(150*twoAxisController.xAxis, -150*twoAxisController.yAxis)
            }
        }

        JoystickControllerHUD {
            id: joystickController
            //Anchor the joystick left bottom (for use with the left thumb)
            //Add a margin so it won't stick to the border of the screen
            anchors{
                left: scene.left
                bottom: scene.bottom
                leftMargin: 5
                bottomMargin: 5
            }

            //Set the controller's size
            width: 50; height: 50

            //Only show the controller on a debug build or when we are on anything
            //but a desktop
            visible: system.debugBuild || !system.desktopPlatform

            //onControllerXPositionChanged: twoAxisController.xAxis = controllerXPosition;
            //onControllerYPositionChanged: twoAxisController.yAxis = controllerYPosition;
        }

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
                    hawk.shootLaser();
                }
                if(actionName == "altfire") {
                    hawk.shootRocket();
                }
            }
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

            font.pixelSize: 30
            z: 10
        }
        Text {
            id: livesText
            text: "Lives: " + hawk.lives
            color: "white"
            anchors{
                right: parent.right
                top: parent.top
                rightMargin: 10
                topMargin: 10
            }
            font.pixelSize: 30
            z: 10
        }

        //Laser HUD
        Image{
            id: laserHUDImage
            source: "../assets/laser_HUD.png"
            anchors {
                bottom: parent.bottom
                right: parent.right
                rightMargin: 5
                bottomMargin: 5
            }
            width: 50; height: 50
            z: 10
            //This adds text on top of the image
            Text{
                id: laserText
                text: "∞"
                color: "white"
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: 4
                    bottomMargin: 4
                }
                font.pixelSize: 20
            }

            //This is a clickable mouse area, it can be activated by a mouse or by a touch
            MouseArea{
                height: parent.height
                width: parent.width
                onClicked:{
                    hawk.shootLaser();
                }
            }
        }

        //Rocket HUD
        Image{
            id: rocketHUDImage
            source: "../assets/rocket_HUD.png"
            anchors {
                bottom: parent.bottom
                right: laserHUDImage.left
                rightMargin: 5
                bottomMargin: 5
            }
            width: 50; height: 50
            z: 10
            //This adds text on top of the image
            Text{
                id: rocketText
                text: hawk.rockets
                color: "white"
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: 4
                    bottomMargin: 4
                }
                font.pixelSize: 20
            }

            //This is a clickable mouse area, it can be activated by a mouse or by a touch
            MouseArea{
                height: parent.height
                width: parent.width
                onClicked:{
                    hawk.shootRocket();
                }
            }
        }
    }
}
