/*
   Copyright (c) 2017 Marco Martin <mart@kde.org>

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License version 2 as published by the Free Software Foundation.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public License
   along with this library; see the file COPYING.LIB.  If not, write to
   the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
*/

import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2 as QtControls
import org.kde.kirigami 2.3 as Kirigami

/**
 * A ScrollView containing a GridView, with the default behavior about
 * sizing and background as recommended by the user interface guidelines
 * For most KControl modules, it's recommended to use instead the GridViewKCM
 * component as the root element of your module.
 * @see GridViewKCM
 */
QtControls.ScrollView {
    id: scroll

    /**
     * view: GridView
     * Exposes the internal GridView: in order to set a model or a delegate to it,
     * use the following code:
     * @code
     * import org.kde.kcm 1.1 as KCM
     * KCM.GridView {
     *     view.model: kcm.model
     *     view.delegate: KCM.GridDelegate {...}
     * }
     * @endcode
     */
    property alias view: view

    /**
     * The ideal width of the grid cells: the view will try to use
     * this size for delegates unless there is not enough room
     * For most uses, try to keep the default value
     * @since 5.57
     */
    property alias implicitCellWidth: view.implicitCellWidth

    /**
     * The ideal height of the grid cells: by default it will be a proportion of the width
     * For most uses, try to keep the default value
     * @since 5.57
     */
    property alias implicitCellHeight: view.implicitCellHeight

    activeFocusOnTab: false
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    Component.onCompleted: scroll.background.visible = true;

    GridView {
        id: view
        property int implicitCellWidth: Kirigami.Units.gridUnit * 10
        property int implicitCellHeight: Math.round(implicitCellWidth / 1.6) + Kirigami.Units.gridUnit*2

        onCurrentIndexChanged: positionViewAtIndex(currentIndex, GridView.Contain);

        QtObject {
            id: internal
            readonly property int availableWidth: scroll.width - internal.scrollBarSpace - 4
            readonly property int scrollBarSpace: scroll.QtControls.ScrollBar.vertical.width
        }
        anchors {
            fill: parent
            margins: 2
            leftMargin: scroll.QtControls.ScrollBar.vertical.visible ? 2 :  internal.scrollBarSpace/2 + 2
        }
        clip: true
        activeFocusOnTab: true

        cellWidth: Math.floor(internal.availableWidth / Math.max(Math.floor(internal.availableWidth / (implicitCellWidth + Kirigami.Units.gridUnit)), 2))
        cellHeight: Kirigami.Settings.isMobile ? cellWidth/1.6 + Kirigami.Units.gridUnit : implicitCellHeight

        keyNavigationEnabled: true
        keyNavigationWraps: true
        highlightMoveDuration: 0

        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "scale"; to: 0.5; duration: Kirigami.Units.longDuration }
                NumberAnimation { property: "opacity"; to: 0.0; duration: Kirigami.Units.longDuration }
            }
        }

        removeDisplaced: Transition {
            SequentialAnimation {
                // wait for the "remove" animation to finish
                PauseAnimation { duration: Kirigami.Units.longDuration }
                NumberAnimation { properties: "x,y"; duration: Kirigami.Units.longDuration }
            }
        }
    }
    QtControls.ScrollBar.horizontal.visible: false
}
