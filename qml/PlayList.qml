/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 * SPDX-FileCopyrightText: 2021 Reion Wong <aj@cutefishos.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import FishUI 1.0 as FishUI
import mpv 1.0

Item {
    id: control
    height: mpv.height - FishUI.Units.largeSpacing * 2
    width: FishUI.Units.gridUnit * 16
    z: 9999
    x: parent.width
    y: FishUI.Units.largeSpacing
    state: "hidden"

    property string position: "right"
    property alias scrollPositionTimer: scrollPositionTimer
    property alias playlistView: playlistView

    Label {
        anchors.centerIn: parent
        z: 999
        text: qsTr("Playlist is empty")
        visible: playlistView.count == 0
    }

    ScrollView {
        id: playlistScrollView

        z: 20
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ListView {
            id: playlistView
            model: mpv.playlistModel
            spacing: 1
            delegate: PlayListItem {
                onDoubleClicked: control.state = "hidden"
            }
        }
    }

    Timer {
        id: scrollPositionTimer
        interval: 50
        running: true
        repeat: true

        onTriggered: {
            setPlayListScrollPosition()
            scrollPositionTimer.stop()
        }
    }

    ShaderEffectSource {
         id: shaderEffect

         anchors.fill: playlistScrollView
         sourceItem: mpv
         sourceRect: position === "right"
                     ? Qt.rect(mpv.width - control.width, mpv.y, control.width, control.height)
                     : Qt.rect(0, 0, control.width, control.height)
     }

     FastBlur {
         anchors.fill: shaderEffect
         radius: 100
         source: shaderEffect
     }

     Rectangle {
         anchors.fill: parent
         color: FishUI.Theme.backgroundColor
         opacity: 0.7
     }

     states: [
         State {
             name: "hidden"
             PropertyChanges { target: control; x: position === "right" ? parent.width : -width }
             PropertyChanges { target: control; visible: false }
         },
         State {
             name : "visible"
             PropertyChanges { target: control; x: position === "right" ? parent.width - control.width - FishUI.Units.largeSpacing : 0 }
             PropertyChanges { target: control; visible: true }
         }
     ]

     transitions: [
         Transition {
             from: "visible"
             to: "hidden"

             SequentialAnimation {
                 NumberAnimation {
                     target: control
                     property: "x"
                     duration: 150
                     easing.type: Easing.InQuad
                 }
                 PropertyAction {
                     target: control
                     property: "visible"
                     value: false
                 }
             }
         },
         Transition {
             from: "hidden"
             to: "visible"

             SequentialAnimation {
                 PropertyAction {
                     target: control
                     property: "visible"
                     value: true
                 }
                 NumberAnimation {
                     target: control
                     property: "x"
                     duration: 150
                     easing.type: Easing.OutQuad
                 }
             }
         }
     ]

     layer.enabled: true
     layer.effect: OpacityMask {
         maskSource: Item {
             width: control.width
             height: control.height

             Rectangle {
                 anchors.fill: parent
                 radius: FishUI.Theme.bigRadius
             }
         }
     }

     function setPlayListScrollPosition() {
         playlistView.positionViewAtIndex(playlistView.model.playingVideo, ListView.Beginning)
     }
}
