/* Copyright 2015 Robert Schroll
*
* This file is part of Beru and is distributed under the terms of
* the GPL. See the file LICENSE for full details.
*/

import QtQuick 2.4
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3

Page {
   header: PageHeader {
      id: info_header
      title: "Planarity"
   }
   Rectangle {
      id: header
      anchors {
         left: parent.left
         right: parent.right
         bottom: parent.bottom
         top: info_header.bottom
         margins: units.gu(2)
      }
      // color: "white"

      // FastBlur {
      //    id: blur
      //    source: boardContainer
      //    x: 0
      //    y: 0
      //    width: boardContainer.width
      //    height: boardContainer.height
      //    radius: 40
      //    visible: false
      // }
      // ColorOverlay {
      //    id: overlay
      //    anchors.fill: blur
      //    source: blur
      //    color: "#80ffffff"
      // }

      Flickable {
         id: infoFlickable
         anchors {
            horizontalCenter: parent.horizontalCenter
         }
         width: Math.min(parent.width - units.gu(2), units.gu(60))
         height: Math.min(parent.height - units.gu(6), about_col.height)
         // x: -units.gu(2)
         contentHeight: about_col.height
         clip: true
         Column {
            id: about_col
            spacing: units.gu(2)
            ProportionalShape {
               anchors.horizontalCenter: parent.horizontalCenter
               aspect: UbuntuShape.DropShadow
               height: units.gu(15)
               source: Image {
                  source: Qt.resolvedUrl("../assets/planarityDouble.svg")
               }
            }

            Text {
               id: infoText
               width: infoFlickable.width
               textFormat: Text.RichText
               wrapMode: Text.Wrap
               color: Theme.palette.selected.backgroundText
               text: /*/ All text in InfoText.qml appears in a single block. /*/
               i18n.tr("Untangle the graph: Drag the vertices to get rid of crossed lines. " +
               "All graphs can be completely untangled, but it may take some time!") +
               "</p><p>" +
               i18n.tr("Vertices may be dragged individually, or you can draw a lasso around " +
               "vertices to be moved together.  Two finger gestures pan and zoom the graph.") +
               "</p><p>" +
               i18n.tr("If your efforts have made things worse, use the reset button in the " +
               "upper left to move things back to the start.  The shuffle button will "+
               "generate a new puzzle.") +
               "</p><p>" +
               i18n.tr("The difficulty of the puzzle can be adjusted with the control in the " +
               "upper right.  Note that the number of vertices scales with the square " +
               "of the difficulty, so things get complicated quickly!") +
               "</p><p>" +
               /*/ "%1" replaced by hyperlink with author's name as anchor text. /*/
               i18n.tr("Original Flash game by %1.").arg("<a href='http://planarity.net/'>John Tantalo</a>") +
               "</p><p>" +
               /*/ "%1" replaced by hyperlink with author's name as anchor text. /*/
               i18n.tr("Based on gPlanarity by %1.").arg("<a href='http://web.mit.edu/xiphmont/Public/gPlanarity.html'>Monty</a>") +
               "</p><p>" +
               /*/ "&copy;" is copyright symbol. /*/
               i18n.tr("This implentation &copy; 2015 by Robert Schroll and released under the GPL.") + "</p><p>" +
               i18n.tr("Now maintained &copy; 2018 by Michele Castellazzi.") + "</p>"

               onLinkActivated: Qt.openUrlExternally(link)
            }
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

         onClicked: mainStack.pop()
      }
      Component.onCompleted: console.log(mainStack.currentPage)
      // onVisibleChanged: Database.setSetting("showInfo", visible)
   }
}
