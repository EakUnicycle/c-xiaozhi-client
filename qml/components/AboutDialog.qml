/*
Project: jtxiaozhi-client
Version: v0.1.0
Author: jtserver team
Email: jwhna1@gmail.com
Updated: 2025-01-13T15:35:00Z
File: AboutDialog.qml
Desc: About dialog component – displays application information and version details.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../theme"

Popup {
    id: aboutDialog
    width: 800
    height: 600
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    // Use window Overlay for full-window centering
    anchors.centerIn: Overlay.overlay
    
    // Dialog background
    background: Rectangle {
        color: Theme.backgroundColor
        border.width: 0
        radius: 12
        
        // Add drag functionality
        MouseArea {
            anchors.fill: parent
            drag.target: root
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: (Overlay.overlay ? Overlay.overlay.width - root.width : 0)
            drag.maximumY: (Overlay.overlay ? Overlay.overlay.height - root.height : 0)
            cursorShape: Qt.SizeAllCursor
            acceptedButtons: Qt.LeftButton
        }
    }
    
    // Title bar
    Rectangle {
        id: titleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        color: "transparent"
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
            
            // Application icon
            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 16
                color: Theme.primaryColor
                
                Text {
                    anchors.centerIn: parent
                    text: "AI"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#FFFFFF"
                }
            }
            
            Text {
                text: "About Xiaozhi Cross-Platform Client"
                font.pixelSize: 18
                font.bold: true
                color: Theme.textColor
                Layout.fillWidth: true
            }
            
            // Close button
            Button {
                text: "✕"
                width: 28
                height: 28
                font.pixelSize: 14
                background: Rectangle {
                    color: parent.hovered ? "#ff6b6b" : "transparent"
                    radius: 14
                }
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#FFFFFF" : Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: aboutDialog.close()
            }
        }
    }
    
    // Main content area
    ScrollView {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footerBar.top
        clip: true
        
        ColumnLayout {
            width: aboutDialog.width - 32
            spacing: 16
            anchors.margins: 16
            
            // App info card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4

                    TextEdit {
                        text: appModel.getAppTitle()
                        font.pixelSize: 18
                        font.bold: true
                        color: Theme.textColor
                        Layout.alignment: Qt.AlignHCenter
                        readOnly: true
                        selectByMouse: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    TextEdit {
                        text: "Inspired by the xiaozhi-esp32 open-source firmware | Free to Use"
                        font.pixelSize: 12
                        color: Theme.textColor
                        Layout.alignment: Qt.AlignHCenter
                        readOnly: true
                        selectByMouse: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
            
            // Server compatibility notice
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    TextEdit {
                        text: "Server Compatibility Notice"
                        font.pixelSize: 16
                        font.bold: true
                        color: Theme.textColor
                        readOnly: true
                        selectByMouse: true
                    }

                    TextEdit {
                        text: "• Official Xiaozhi Server: https://xiaozhi.me/\n• Xinnan-Tech Open Source Server: https://github.com/xinnan-tech/xiaozhi-esp32-server\n• jtxiaozhi-server commercial version: Supports advanced features and customized optimizations. Contact us for commercial licensing.\n• Other versions: Not yet tested. Please provide feedback if you encounter compatibility issues, and we will work on support."
                        font.pixelSize: 11
                        color: Theme.textColor
                        wrapMode: TextEdit.WordWrap
                        Layout.fillWidth: true
                        readOnly: true
                        selectByMouse: true
                    }
                }
            }
            
            // Important links
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4

                    TextEdit {
                        text: "Relevant Links"
                        font.pixelSize: 16
                        font.bold: true
                        color: Theme.textColor
                        readOnly: true
                        selectByMouse: true
                    }

                    GridLayout {
                        columns: 2
                        rowSpacing: 4
                        columnSpacing: 12
                        Layout.fillWidth: true

                        TextEdit { text: "ESP32 Firmware Source:"; color: Theme.textColor; font.pixelSize: 11; font.bold: true; readOnly: true; selectByMouse: true }
                        TextEdit {
                            Layout.fillWidth: true
                            text: "https://github.com/78/xiaozhi-esp32"
                            font.pixelSize: 11
                            color: Theme.primaryColor
                            readOnly: true
                            selectByMouse: true
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Qt.openUrlExternally("https://github.com/78/xiaozhi-esp32")
                            }
                        }

                        TextEdit { text: "Open Source Server:"; color: Theme.textColor; font.pixelSize: 11; font.bold: true; readOnly: true; selectByMouse: true }
                        TextEdit {
                            Layout.fillWidth: true
                            text: "https://github.com/xinnan-tech/xiaozhi-esp32-server"
                            font.pixelSize: 11
                            color: Theme.primaryColor
                            readOnly: true
                            selectByMouse: true
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Qt.openUrlExternally("https://github.com/xinnan-tech/xiaozhi-esp32-server")
                            }
                        }

                        TextEdit { text: "GitHub Repository:"; color: Theme.textColor; font.pixelSize: 11; font.bold: true; readOnly: true; selectByMouse: true }
                        TextEdit {
                            Layout.fillWidth: true
                            text: "https://github.com/jwhna1"
                            font.pixelSize: 11
                            color: Theme.primaryColor
                            readOnly: true
                            selectByMouse: true
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Qt.openUrlExternally("https://github.com/jwhna1")
                            }
                        }

                        TextEdit { text: "Bilibili Channel:"; color: Theme.textColor; font.pixelSize: 11; font.bold: true; readOnly: true; selectByMouse: true }
                        TextEdit {
                            Layout.fillWidth: true
                            text: "https://space.bilibili.com/298384872"
                            font.pixelSize: 11
                            color: Theme.primaryColor
                            readOnly: true
                            selectByMouse: true
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Qt.openUrlExternally("https://space.bilibili.com/298384872")
                            }
                        }
                    }
                }
            }
            
            // Contact information
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4

                    TextEdit {
                        text: "Contact Us"
                        font.pixelSize: 16
                        font.bold: true
                        color: Theme.textColor
                        readOnly: true
                        selectByMouse: true
                    }

                    GridLayout {
                        columns: 2
                        rowSpacing: 2
                        columnSpacing: 12
                        Layout.fillWidth: true

                        TextEdit { text: "Development Team:"; color: Theme.textColor; font.pixelSize: 11; font.bold: true; readOnly: true; selectByMouse: true }
                        TextEdit { text: "Zeng Neng-Hun"; color: Theme.primaryColor; font.pixelSize: 11; readOnly: true; selectByMouse: true; Layout.fillWidth: true }

                        TextEdit { text: "Business Email:"; color: Theme.textColor; font.pixelSize: 11; font.bold: true; readOnly: true; selectByMouse: true }
                        TextEdit { text: "jwhna1@gmail.com"; color: Theme.primaryColor; font.pixelSize: 11; readOnly: true; selectByMouse: true; Layout.fillWidth: true }

                        TextEdit { text: "Contact:"; color: Theme.textColor; font.pixelSize: 11; font.bold: true; readOnly: true; selectByMouse: true }
                        TextEdit { text: "QQ: 7280051 | WeChat: cxshow066 (Please state your purpose when adding)"; color: Theme.primaryColor; font.pixelSize: 11; readOnly: true; selectByMouse: true; Layout.fillWidth: true; wrapMode: TextEdit.Wrap }
                    }
                }
            }
            
            // This software is completely free to use. We do not charge any fees or use deceptive sales tactics.
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    TextEdit {
                        text: "Free Usage Statement"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#e74c3c"
                        readOnly: true
                        selectByMouse: true
                    }

                    TextEdit {
                        text: "This program is free to use, and our communication is open and without tricks. Any behavior charging you for this service is unrelated to our team. We promise the software is permanently free and will not charge for usage in any form. If you encounter anyone charging fees, please be alert and report it to us."
                        font.pixelSize: 11
                        color: Theme.textColor
                        wrapMode: TextEdit.WordWrap
                        Layout.fillWidth: true
                        readOnly: true
                        selectByMouse: true
                    }

                    TextEdit {
                        text: "© 2025 jtserver Team. All rights reserved."
                        font.pixelSize: 10
                        color: Theme.timestampColor
                        Layout.alignment: Qt.AlignHCenter
                        readOnly: true
                        selectByMouse: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
    
    // Bottom button
    Rectangle {
        id: footerBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "transparent"
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
            
            Item { Layout.fillWidth: true }

            Button {
                text: "Check for Updates"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 32
                visible: appModel && appModel.updateManager

                background: Rectangle {
                    color: parent.hovered ? "#4CAF50" : Theme.buttonColor
                    radius: 6
                    border.width: 1
                    border.color: parent.hovered ? "#45a049" : "#d1d5db"
                }

                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#FFFFFF" : Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                }

                onClicked: {
                    if (appModel && appModel.updateManager) {
                        var updateDialog = Qt.createQmlObject(
                            'import QtQuick 6.5; import "../components"; UpdateDialog { updateManager: appModel.updateManager }',
                            parent,
                            'dynamicUpdateDialog'
                        )
                        updateDialog.checkForUpdates()
                    }
                }
            }

            Button {
                text: "OK"
                Layout.preferredWidth: 80
                Layout.preferredHeight: 32
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryColor : Theme.buttonColor
                    radius: 6
                    border.width: 0
                }
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#FFFFFF" : Theme.buttonTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }
                onClicked: aboutDialog.close()
            }
        }
    }
}