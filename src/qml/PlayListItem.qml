/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import FishUI 1.0 as FishUI
import org.kde.haruna 1.0
import Haruna.Components 1.0

Item {
    id: root

    property bool isPlaying: model.isPlaying
    property string rowNumber: (index + 1).toString()
    property var alpha: PlaylistSettings.overlayVideo ? 0.6 : 1

    height: label.font.pointSize * 3 + PlaylistSettings.rowHeight
    width: ListView.view.width

    signal doubleClicked()

    Rectangle {
        anchors.fill: parent
        color: FishUI.Theme.backgroundColor
        opacity: 0.5
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onDoubleClicked: {
            root.doubleClicked()

            mpv.playlistModel.setPlayingVideo(index)
            mpv.loadFile(path, !isYouTubePlaylist)
            mpv.pause = false
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: FishUI.Units.largeSpacing

        Label {
            text: pad(root.rowNumber, playlistView.count.toString().length)
            visible: PlaylistSettings.showRowNumber
            font.pointSize: (window.isFullScreen() && playList.bigFont)
                            ? FishUI.Units.gridUnit
                            : FishUI.Units.gridUnit - 6
            horizontalAlignment: Qt.AlignCenter
            Layout.leftMargin: FishUI.Units.largeSpacing

            function pad(number, length) {
                while (number.length < length)
                    number = "0" + number;
                return number;
            }
        }

        FishUI.IconItem {
            source: "media-playback-start"
            width: FishUI.Units.iconSizes.small
            height: FishUI.Units.iconSizes.small
            visible: isPlaying
            Layout.leftMargin: PlaylistSettings.showRowNumber ? 0 : FishUI.Units.largeSpacing
        }

        LabelWithTooltip {
            id: label

            toolTipFontSize: label.font.pointSize + 2

            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideRight
            font.pointSize: (window.isFullScreen() && playList.bigFont)
                            ? FishUI.Units.gridUnit
                            : FishUI.Units.gridUnit - 6
            font.weight: Font.Normal
            color: isPlaying ? FishUI.Theme.highlightColor : FishUI.Theme.textColor
            text: PlaylistSettings.showMediaTitle ? model.title : model.name
            layer.enabled: true
            Layout.fillWidth: true
            Layout.leftMargin: PlaylistSettings.showRowNumber || isPlaying ? 0 : FishUI.Units.largeSpacing
        }

        Label {
            text: model.duration
            visible: model.duration.length > 0
            font.pointSize: (window.isFullScreen() && playList.bigFont)
                            ? FishUI.Units.gridUnit
                            : FishUI.Units.gridUnit - 6
            horizontalAlignment: Qt.AlignCenter
            Layout.margins: FishUI.Units.largeSpacing
        }
    }
}
