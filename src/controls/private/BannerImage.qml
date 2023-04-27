/*
 *  SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.12 as Kirigami

/**
 * This Component is used as the header of GlobalDrawer and as the header
 * of Card, It can be accessed there as a grouped property but can never
 * be instantiated directly.
 * \private
 */
Kirigami.ShadowedImage {
    id: root

//BEGIN properties
    /**
     * @brief This property holds an icon to be displayed alongside the title.
     *
     * It can be a QIcon, a FreeDesktop-compatible icon name, or any URL understood by QtQuick.Image.
     *
     * @property var titleIcon
     */
    property alias titleIcon: headingIcon.source

    /**
     * @brief This property holds the title's text which is to be displayed on top.
     * of the image.
     * @see QtQuick.Text::text
     * @property string title
     */
    property alias title: heading.text

    /**
     * @brief This property holds the title's position.
     *
     * default: ``Qt.AlignTop | Qt.AlignLeft``
     *
     * @property Qt::Alignment titleAlignment
     */
    property int titleAlignment: Qt.AlignTop | Qt.AlignLeft

    /**
     * @brief This property holds the title's level.
     *
     * Available text size values range from 1 (largest) to 5 (smallest).
     *
     * default: ``1``
     *
     * @see org::kde::kirigami::Heading::level
     * @property int titleLevel
     */
    property alias titleLevel: heading.level

    /**
     * @brief This property holds the title's wrap mode.
     *
     * default: ``Text.NoWrap``
     *
     * @see QtQuick.Text::wrapMode
     * @property int titleWrapMode
     */
    property alias titleWrapMode: heading.wrapMode

    property int leftPadding: headingIcon.valid ? Kirigami.Units.smallSpacing * 2 : Kirigami.Units.largeSpacing
    property int topPadding: headingIcon.valid ? Kirigami.Units.smallSpacing * 2 : Kirigami.Units.largeSpacing
    property int rightPadding: headingIcon.valid ? Kirigami.Units.smallSpacing * 2 : Kirigami.Units.largeSpacing
    property int bottomPadding: headingIcon.valid ? Kirigami.Units.smallSpacing * 2 : Kirigami.Units.largeSpacing

    property int implicitWidth: Layout.preferredWidth

    readonly property bool empty: title.length === 0 &&             // string
                                  source.toString().length === 0 && // QUrl
                                  !titleIcon                        // QVariant hanled by Kirigami.Icon
//END properties

    Layout.fillWidth: true

    Layout.preferredWidth: titleLayout.implicitWidth || sourceSize.width
    Layout.preferredHeight: titleLayout.completed && source.toString() !== "" ? width/(sourceSize.width / sourceSize.height) : Layout.minimumHeight
    Layout.minimumHeight: titleLayout.implicitHeight > 0 ? titleLayout.implicitHeight + Kirigami.Units.smallSpacing * 2 : 0

    onTitleAlignmentChanged: {
        // VERTICAL ALIGNMENT
        titleLayout.anchors.top = undefined
        titleLayout.anchors.verticalCenter = undefined
        titleLayout.anchors.bottom = undefined
        shadowedRectangle.anchors.top = undefined
        shadowedRectangle.anchors.verticalCenter = undefined
        shadowedRectangle.anchors.bottom = undefined

        if (root.titleAlignment & Qt.AlignTop) {
            titleLayout.anchors.top = root.top
            shadowedRectangle.anchors.top = root.top
        }
        else if (root.titleAlignment & Qt.AlignVCenter) {
            titleLayout.anchors.verticalCenter = root.verticalCenter
            shadowedRectangle.anchors.verticalCenter = root.verticalCenter
        }
        else if (root.titleAlignment & Qt.AlignBottom) {
            titleLayout.anchors.bottom = root.bottom
            shadowedRectangle.anchors.bottom = root.bottom
        }

        // HORIZONTAL ALIGNMENT
        titleLayout.anchors.left = undefined
        titleLayout.anchors.horizontalCenter = undefined
        titleLayout.anchors.right = undefined
        if (root.titleAlignment & Qt.AlignRight) {
            titleLayout.anchors.right = root.right
        }
        else if (root.titleAlignment & Qt.AlignHCenter) {
            titleLayout.anchors.horizontalCenter = root.horizontalCenter
        }
        else if (root.titleAlignment & Qt.AlignLeft) {
            titleLayout.anchors.left = root.left
        }
    }
    fillMode: Image.PreserveAspectCrop
    asynchronous: true

    color: "transparent"

    Component.onCompleted: {
        titleLayout.completed = true;
    }

    Kirigami.ShadowedRectangle {
        id: shadowedRectangle
        anchors {
            left: parent.left
            right: parent.right
        }
        height: Math.min(parent.height, titleLayout.height * 1.5)

        opacity: 0.5
        color: "black"

        corners.topLeftRadius: root.titleAlignment & Qt.AlignTop ? root.corners.topLeftRadius : 0
        corners.topRightRadius: root.titleAlignment & Qt.AlignTop ? root.corners.topRightRadius : 0
        corners.bottomLeftRadius: root.titleAlignment & Qt.AlignBottom ? root.corners.bottomLeftRadius : 0
        corners.bottomRightRadius: root.titleAlignment & Qt.AlignBottom ? root.corners.bottomRightRadius : 0

        visible: root.source.toString().length !== 0 && root.title.length !== 0 && ((root.titleAlignment & Qt.AlignTop) || (root.titleAlignment & Qt.AlignVCenter) || (root.titleAlignment & Qt.AlignBottom))
    }

    RowLayout {
        id: titleLayout
        property bool completed: false
        anchors {
            leftMargin: root.leftPadding
            topMargin: root.topPadding
            rightMargin: root.rightPadding
            bottomMargin: root.bottomPadding
        }
        width: Math.min(implicitWidth, parent.width -root.leftPadding -root.rightPadding)
        height: Math.min(implicitHeight, parent.height -root.topPadding -root.bottomPadding)
        Kirigami.Icon {
            id: headingIcon
            Layout.minimumWidth: Kirigami.Units.iconSizes.large
            Layout.minimumHeight: width
            visible: valid
            isMask: false
        }
        Kirigami.Heading {
            id: heading
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            visible: text.length > 0
            level: 1
            color: root.source.toString() !== "" ? "white" : Kirigami.Theme.textColor
            wrapMode: Text.NoWrap
            elide: Text.ElideRight
        }
    }
}
