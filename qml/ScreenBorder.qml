import QtQuick 2.0
import VPlay 2.0

EntityBase{
    id: border
    property Scene scene

    BoxCollider{
        collidesWith: Box.Category1
        categories: Box.Category5
        id: topCollider
        width: scene.width
        height: 20
        y: -20
        x: 0
        bodyType: Body.Static
    }
    BoxCollider{
        collidesWith: Box.Category1
        categories: Box.Category5
        id: bottomCollider
        width: scene.width
        height: 20
        y: scene.height
        x: 0
        bodyType: Body.Static
    }
    BoxCollider{
        collidesWith: Box.Category1
        categories: Box.Category5
        id: leftCollider
        width: 20
        height: scene.height
        y: 0
        x: -20
        bodyType: Body.Static
    }
    BoxCollider{
        collidesWith: Box.Category1
        categories: Box.Category5
        id: rightCollider
        width: 20
        height: scene.height
        y: 0
        x: scene.width
        bodyType: Body.Static
    }
}
