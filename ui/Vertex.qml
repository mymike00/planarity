/* Copyright 2015 Robert Schroll
 *
 * This file is part of Beru and is distributed under the terms of
 * the GPL. See the file LICENSE for full details.
 */

import QtQuick 2.4
import Lomiri.Components 1.3

import "database.js" as Database


Item {
    id: vertex

    property double size: units.gu(3)
    property var edges: []
    property double originalX
    property double originalY
    property bool selected: mouseArea.pressed || multiSelect
    property bool multiSelect: false
    property int neighborCount: 0
    property int n

    width: size
    height: size
    z: 2
    scale: 1 / board.scale
    transform: Translate {
        x: -size / 2
        y: -size / 2
    }

    function reset() {
        x = originalX
        y = originalY
    }

    Component.onCompleted: {
        originalX = x
        originalY = y
    }

    MouseArea {
        id: mouseArea
        anchors.fill: vertex
        drag {
            target: multiSelect ? undefined : vertex
            threshold: 0
        }

        drag.onActiveChanged: {
            if (!drag.active) {
                board.onVertexDragEnd()
                Database.updateVertices([vertex])
            }
        }

        onPressed: {
            if (!multiSelect) {
                board.unselectVertices()
            } else {
                board.multiDrag = true
                mouse.accepted = false
            }
        }
    }

    Rectangle {
        id: rect

        property double size: units.gu(2)

        width: size
        height: size
        radius: size/2
        x: (vertex.size - size) / 2
        y: (vertex.size - size) / 2
        color: "#335280"
      //   border.color: "black"
      //   border.width: units.dp(1)
    }

    states: [
        State {
            name: "Selected"
            when: selected
            PropertyChanges {
                target: rect
                color: LomiriColors.green
            }
        },
        State {
            name: "Neighbor"
            when: neighborCount > 0 && !selected
            PropertyChanges {
                target: rect
                color: "#F99b0F"//LomiriColors.red //"#C7162B"
            }
        }
    ]

    transitions: [
      Transition {
         from: "Neighbor"
         to: ""
         ColorAnimation {
             duration: 700
         }
      },
      Transition {
          from: "Selected"
          to: ""
          ColorAnimation {
              duration: 1000
          }
      }
    ]
}
