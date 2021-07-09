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

import org.kde.haruna 1.0
import Haruna.Components 1.0

Item {
    id: root

    property alias progressBar: progressBar
    property alias footerRow: footerRow
    property alias timeInfo: timeInfo
    property alias playPauseButton: playPauseButton
    property alias volume: volume

    height: mainLayout.childrenRect.height + FishUI.Units.largeSpacing * 2
    visible: true
    opacity: mpv.mouseY > window.height - footer.height - FishUI.Units.largeSpacing * 3 ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: 180
        }
    }

    ShaderEffectSource {
        id: shaderEffect
        visible: true
        anchors.fill: parent
        sourceItem: mpv
        sourceRect: Qt.rect(0, 0, root.width, root.height)
    }

    FastBlur {
        visible: true
        anchors.fill: shaderEffect
        source: shaderEffect
        radius: 100
    }

    Rectangle {
        id: _background
        anchors.fill: parent
        color: FishUI.Theme.backgroundColor
        opacity: 0.8
    }

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Item {
            width: root.width
            height: root.height

            Rectangle {
                anchors.fill: parent
                radius: FishUI.Theme.bigRadius
            }
        }
    }

    Component {
        id: togglePlaylistButton

        ToolButton {
            action: actions.togglePlaylistAction
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: FishUI.Units.largeSpacing
        spacing: FishUI.Units.largeSpacing

        HProgressBar {
            id: progressBar
            Layout.fillWidth: true
        }

        RowLayout {
            id: footerRow

            ToolButton {
                id: playPreviousFile
                action: actions.playPreviousAction
                text: ""
                focusPolicy: Qt.NoFocus
                enabled: playList.playlistView.count > 1

                ToolTip {
                    text: qsTr("Play previous file")
                }
            }

            ToolButton {
                id: playPauseButton
                action: actions.playPauseAction
                text: ""
                icon.name: "media-playback-start"
                focusPolicy: Qt.NoFocus

                ToolTip {
                    id: playPauseButtonToolTip
                    text: mpv.pause ? qsTr("Start Playback") : qsTr("Pause Playback")
                }
            }

            ToolButton {
                id: playNextFile
                action: actions.playNextAction
                text: ""
                focusPolicy: Qt.NoFocus
                enabled: playList.playlistView.count > 1

                ToolTip {
                    text: qsTr("Play next file")
                }
            }

            LabelWithTooltip {
                id: timeInfo

                text: app.formatTime(mpv.position) + " / " + app.formatTime(mpv.duration)
                font.pointSize: FishUI.Units.gridUnit - 4
                toolTipText: qsTr("Remaining: ") + app.formatTime(mpv.remaining)
                toolTipFontSize: timeInfo.font.pointSize + 2
                alwaysShowToolTip: true
                horizontalAlignment: Qt.AlignHCenter
            }

            ToolButton {
                id: mute
                action: actions.muteAction
                text: ""
                focusPolicy: Qt.NoFocus

                ToolTip {
                    text: actions.muteAction.text
                }
            }

            VolumeSlider { id: volume }

            Loader {
                sourceComponent: togglePlaylistButton
                visible: true
            }
        }
    }
}
