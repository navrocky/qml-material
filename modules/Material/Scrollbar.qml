/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014 Michael Spencer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import Material 0.1

Item {
    id: root
    property Flickable flickableItem

    clip: true
    smooth: true
    visible: orientation === Qt.Vertical ? flickableItem.contentHeight > flickableItem.height
                                         : flickableItem.contentWidth > flickableItem.width

    anchors {
        top: orientation === Qt.Vertical ? flickableItem.top : undefined
        bottom: flickableItem.bottom
        left: orientation === Qt.Horizontal ? flickableItem.left : undefined
        right: flickableItem.right
        margins: 2
    }

    property int orientation: Qt.Vertical
    property int thickness: 5
    width: units.dp(thickness)
    height: units.dp(thickness)

    property bool moving: flickableItem.moving

    Component.onCompleted: hideAnimation.start()

    onMovingChanged: {
        if (moving) {
            hideAnimation.stop()
            showAnimation.start()
        } else {
            hideAnimation.start()
            showAnimation.stop()
        }
    }

    NumberAnimation {
        id: showAnimation
        target: scrollBar; property: "opacity"; to: 0.3; duration: 200; easing.type: Easing.InOutQuad
    }

    SequentialAnimation {
        id: hideAnimation

        NumberAnimation { duration: 500 }
        NumberAnimation { target: scrollBar; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
    }

    onOrientationChanged: {
        if (orientation == Qt.Vertical) {
            width = thickness
        } else {
            height = thickness
        }
    }

    Rectangle {
        id: scrollBar
        color: "black"//theme.foreground

        opacity: 0.3
        radius: thickness/2

        width: Math.max(orientation == Qt.Horizontal ? end - start : 0, thickness)
        height: Math.max(orientation == Qt.Vertical ? end - start : 0, thickness)
        x: orientation == Qt.Horizontal ? start : 0
        y: orientation == Qt.Vertical ? start : 0

        property int length: orientation == Qt.Vertical ? root.height : root.width;
        property int targetLength: orientation == Qt.Vertical ? flickableItem.height : flickableItem.width;
        property int contentStart: orientation == Qt.Vertical ? flickableItem.contentY : flickableItem.contentX;
        property int contentLength: orientation == Qt.Vertical ? flickableItem.contentHeight : flickableItem.contentWidth;

        property int start: Math.max(0, length * contentStart/contentLength);
        property int end: Math.min(length, length * (contentStart + targetLength)/contentLength)
    }
}
