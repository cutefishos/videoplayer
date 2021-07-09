/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.12

import FishUI 1.0 as FishUI
import org.kde.haruna 1.0

Slider {
    id: root

    from: 0
    to: 100
    value: mpv.volume
    implicitWidth: 100
    implicitHeight: 25
    wheelEnabled: true
    leftPadding: 0
    rightPadding: 0

    onValueChanged: {
        mpv.volume = value.toFixed(0)
        GeneralSettings.volume = value.toFixed(0)
        GeneralSettings.save()
    }
}
