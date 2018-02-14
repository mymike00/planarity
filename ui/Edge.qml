/* Copyright 2015 Robert Schroll
 *
 * This file is part of Beru and is distributed under the terms of
 * the GPL. See the file LICENSE for full details.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3


Rectangle {
    id: edge
    antialiasing: true

    property var v1
    property var v2

    width: Math.sqrt((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y))
    height: units.dp(1) / board.scale
    x: v1.x
    y: v1.y - height/2
    z: 1
    color: UbuntuColors.ash
    transform: Rotation {
        origin.x: 0
        origin.y: edge.height/2
        angle: Math.atan2(edge.v2.y - edge.v1.y, edge.v2.x - edge.v1.x) * 180 / Math.PI
    }

    Connections {
        target: v1
        onSelectedChanged: {
            if (v1.selected)
                v2.neighborCount += 1
            else
                v2.neighborCount -= 1
        }
    }

    Connections {
        target: v2
        onSelectedChanged: {
            if (v2.selected)
                v1.neighborCount += 1
            else
                v1.neighborCount -= 1
        }
    }

    states: [
        State {
            name: "Selected"
            when: (v1.state == "Selected" || v2.state == "Selected") && v1.state != v2.state
            PropertyChanges {
                target: edge
                color: UbuntuColors.blue
            }
            PropertyChanges {
                target: edge
                height: units.dp(2) / board.scale
            }
        }
    ]

    transitions: [
        Transition {
            to: ""
            ParallelAnimation {
               ColorAnimation {duration: 700;easing.type: Easing.InCubic}
               NumberAnimation {duration: 700; property: "height";easing.type: Easing.InCubic}
            }
        }
    ]
}
