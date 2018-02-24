/* Copyright 2015 Robert Schroll
 *
 * This file is part of Beru and is distributed under the terms of
 * the GPL. See the file LICENSE for full details.
 */

import QtQuick 2.4
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Pickers 1.3

import "database.js" as Database

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "planarity.rschroll"

    width: units.gu(100)
    height: units.gu(75)

    Page {
        id: mainPage

        property int headerHeight: units.gu(8)

        Rectangle { //useful?!?
            id: background
            anchors.fill: parent
            color: "white"
        }

        Icon {
            id: tick
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width
            name: "tick"
            color: UbuntuColors.green
            opacity: 0
            visible: opacity > 0
            z:4

            states: [
                State {
                    name: "Completed"
                    when: board.intersections == 0
                }
            ]
            transitions: [
                Transition {
                    from: ""
                    to: "Completed"
                    SequentialAnimation {
                        UbuntuNumberAnimation {
                          easing.type: Easing.OutQuint
                            target: tick
                            property: "opacity"
                            from: 0
                            to: 1
                        }
                        UbuntuNumberAnimation {
                          easing.type: Easing.InCubic
                            target: tick
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 1000
                        }
                    }
                }

            ]
        }

        header: PageHeader {
           id: p_header
           title: i18n.tr("%1 intersection", "%1 intersections", board.intersections).arg(board.intersections)
           z:4
           
           trailingActionBar.actions: [
              Action {
                  iconName: "reload"
                  onTriggered: board.reset()
              },
               Action {
                  iconName: "info"
                  onTriggered: infoDialog.visible = !infoDialog.visible
              },
              Action {
                  id: generateAction
                  iconName: board.intersections ? "media-playlist-shuffle" : "media-playback-start"
                  // color: iconName="media-playback-start" ? UbuntuColors.green : UbuntuColors.silk
                  onTriggered: board.generate(orderPicker.selectedIndex + orderPicker.min)
              }
           ]

           extension: Sections {
                id: orderPicker
                anchors {
                    left: parent.left
                    right: parent.right
                }

                property int min: 4
                property int max: 15

                onSelectedIndexChanged: Database.setSetting("difficulty", selectedIndex)

                Component.onCompleted: {
                    var stack = []
                    for (var i=min; i<=max; i++)
                        stack.push(i)
                    model = stack
                    selectedIndex = Database.getSetting("difficulty", 0)
                }
            }
        }

        Rectangle {
            id: header
            anchors.fill: parent
            anchors.topMargin: p_header.bottom
            color: "white"
            z: 2
            FastBlur {
               id: blur
               source: boardContainer
               x: 0
               y: 0
               width: boardContainer.width
               height: boardContainer.height
               radius: 0
               visible: false
            }
            ColorOverlay {
               id: overlay
               anchors.fill: blur
               source: blur
               color: "#00ffffff"
            }


            Label {text: " "}

         }

        Item {
            id: boardContainer
            anchors.fill: parent
            anchors.topMargin: p_header.bottom

            Item {
                anchors {
                    fill: parent
                }
                z: 1

                Board {
                    id: board
                }
            }
        }

        Item {
            id: infoDialog
            visible: false
            anchors.fill: parent
            anchors.topMargin: p_header.bottom
            height: units.gu(100)
            z: 3

            Flickable {
                id: infoFlickable
                anchors.centerIn: parent
                width: Math.min(parent.width - units.gu(2), units.gu(60))
                height: Math.min(parent.height - 2 * mainPage.headerHeight, infoText.paintedHeight)
                contentHeight: infoText.paintedHeight
                clip: true

                InfoText {
                    id: infoText
                }
            }

         Button {
             anchors {
                 top: infoFlickable.bottom
                 topMargin: units.gu(1)
                 horizontalCenter: parent.horizontalCenter
             }
             width: units.gu(20)
             height: units.gu(6)
             color: "#40d9d9d9"    // To match header button over white, but be dark enough to
             text: i18n.tr("Play") // force the Button to use dark text.

             onClicked: infoDialog.visible = false
         }

            onVisibleChanged: Database.setSetting("showInfo", visible)
        }

        states: [
            State {
                when: infoDialog.visible
                PropertyChanges {
                    target: blur
                    radius: 40
                }
                PropertyChanges {
                   target: overlay
                   color: "#80ffffff"
                }
                PropertyChanges {
                    target: boardContainer
                    visible: false
                }
            }
        ]

        Component.onCompleted: {
            infoDialog.visible = (Database.getSetting("showInfo", true) != 0)
            Database.loadGraph(board.createGraph, generateAction.trigger)
        }
    }
}
