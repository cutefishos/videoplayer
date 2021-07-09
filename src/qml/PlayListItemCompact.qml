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
import Haruna.Components 1.0 as HC

Item {
    id: root

    property bool isPlaying: model.isPlaying
    property string rowNumber: (index + 1).toString()
    property var alpha: PlaylistSettings.overlayVideo ? 0.6 : 1

    label: mainText()
    subtitle: model.duration
    icon: model.isPlaying ? "media-playback-start" : ""
    backgroundColor: {
        let color = model.isPlaying ? FishUI.Theme.highlightColor : FishUI.Theme.backgroundColor
        Qt.hsla(color.hslHue, color.hslSaturation, color.hslLightness, alpha)
    }

    onDoubleClicked: {
        mpv.playlistModel.setPlayingVideo(index)
        mpv.loadFile(path, !isYouTubePlaylist)
        mpv.pause = false
    }

    ToolTip {
        text: (PlaylistSettings.showMediaTitle ? model.title : model.name)
        visible: root.containsMouse
        font.pointSize: FishUI.Units.gridUnit - 5
    }

    function mainText() {
        const rowNumber = pad(root.rowNumber, playlistView.count.toString().length) + ". "

        if(PlaylistSettings.showRowNumber) {
            return rowNumber + (PlaylistSettings.showMediaTitle ? model.title : model.name)
        }
        return (PlaylistSettings.showMediaTitle ? model.title : model.name)
    }

    function pad(number, length) {
        while (number.length < length)
            number = "0" + number;
        return number;
    }
}
