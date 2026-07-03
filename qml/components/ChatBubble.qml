/*
Project: jtxiaozhi-client
Version: v0.1.0
Author: jtserver team
Email: jwhna1@gmail.com
Updated: 2025-01-12T08:30:00Z
File: ChatBubble.qml
Desc: Chat bubble component (supports text and audio playback)
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "../theme"

Rectangle {
    id: root
    
    // Properties
    property bool isUser: false      // true=User(right), false=Agent(left)
    property string messageText: ""
    property string audioPath: ""    // Audio file path
    property string imagePath: ""    // Image file path
    property bool hasAudio: audioPath !== ""
    property bool hasImage: imagePath !== ""
    property bool isPlaying: false
    property int messageId: -1
    property int timestamp: 0        // Message timestamp
    property string messageType: ""  // Message type, used to identify activation code messages
    
    width: parent.width
    height: bubbleColumn.height + 20
    color: "transparent"
    
    RowLayout {
        anchors.fill: parent
        spacing: 10
        
        // Left spacer (User is on the right → requires left stretch)
        Item { 
            Layout.fillWidth: root.isUser
            visible: root.isUser
        }
        
        // Bubble container
        Rectangle {
            Layout.preferredWidth: Math.min(bubbleColumn.implicitWidth + 20, root.width * 0.7)
            Layout.preferredHeight: bubbleColumn.height + 20
            radius: 10
            color: root.isUser ? Theme.userBubbleColor : Theme.aiBubbleColor
            border.width: 0
            
            ColumnLayout {
                id: bubbleColumn
                anchors.centerIn: parent
                width: parent.width - 20
                spacing: 8
                
                // Text content (uses TextEdit for text selection and copying)
                TextEdit {
                    id: messageTextEdit
                    Layout.fillWidth: true
                    text: root.messageText
                    wrapMode: TextEdit.Wrap
                    color: root.isUser ? Theme.userTextColor : Theme.aiTextColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.family: Theme.fontFamily
                    readOnly: true
                    selectByMouse: true
                    selectByKeyboard: true
                    
                    // Right-click menu
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onClicked: {
                            contextMenu.popup()
                        }
                    }
                    
                    Menu {
                        id: contextMenu
                        MenuItem {
                            text: "Copy"
                            enabled: messageTextEdit.selectedText !== ""
                            onTriggered: {
                                messageTextEdit.copy()
                            }
                        }
                        MenuItem {
                            text: "Select All"
                            onTriggered: {
                                messageTextEdit.selectAll()
                            }
                        }
                    }
                }
                
                // Special handling for activation code messages - simplified version, displays raw text
                Rectangle {
                    visible: root.messageType === "activation"
                    Layout.fillWidth: true
                    Layout.preferredHeight: activationText.implicitHeight + 30
                    color: Theme.highlightColor
                    radius: 8
                    border.width: 0
                    
                    TextEdit {
                        id: activationText
                        anchors.fill: parent
                        anchors.margins: 15
                        text: root.messageText
                        wrapMode: TextEdit.Wrap
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.textColor
                        readOnly: true
                        selectByMouse: true
                        selectByKeyboard: true
                        
                        // Right-click menu
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            onClicked: {
                                activationContextMenu.popup()
                            }
                        }
                        
                        Menu {
                            id: activationContextMenu
                            MenuItem {
                                text: "Copy"
                                enabled: activationText.selectedText !== ""
                                onTriggered: {
                                    activationText.copy()
                                }
                            }
                            MenuItem {
                                text: "Select All"
                                onTriggered: {
                                    activationText.selectAll()
                                }
                            }
                        }
                    }
                }
                
                // Image preview (if applicable)
                Rectangle {
                    visible: root.hasImage
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 150
                    color: "transparent"
                    border.width: 0
                    radius: 5
                    clip: true
                    
                    Image {
                        id: previewImage
                        anchors.fill: parent
                        anchors.margins: 2
                        source: root.hasImage ? ("file:///" + root.imagePath) : ""
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        cache: false
                        
                        // Loading indicator
                        BusyIndicator {
                            anchors.centerIn: parent
                            running: previewImage.status === Image.Loading
                            visible: running
                        }
                        
                        // Load failure prompt
                        Text {
                            anchors.centerIn: parent
                            visible: previewImage.status === Image.Error
                            text: "❌ Image failed to load"
                            color: Theme.textColor
                        }

                        // Error handling: stop retry loading
                        onStatusChanged: {
                            if (status === Image.Error) {
                                // Delay clearing source to stop retry and prevent continuous errors
                                errorTimer.restart()
                            }
                        }

                        Timer {
                            id: errorTimer
                            interval: 100
                            onTriggered: {
                                if (previewImage.status === Image.Error) {
                                    previewImage.source = ""
                                }
                            }
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: imageViewWindow.show()
                    }
                }
                
                // Audio playback button
                Button {
                    visible: root.hasAudio
                    Layout.alignment: Qt.AlignRight
                    text: root.isPlaying ? "⏸ Stop" : "▶ Play Audio"
                    font.pixelSize: Theme.fontSizeSmall
                    font.family: Theme.fontFamily
                    
                    background: Rectangle {
                        color: parent.pressed ? Theme.buttonPressedColor : Theme.buttonColor
                        radius: 5
                        border.width: 0
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: Theme.buttonTextColor
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        if (root.isPlaying) {
                            appModel.stopAudioPlayback()
                        } else {
                            appModel.playAudioMessage(root.messageId)
                        }
                    }
                }
                
                // Timestamp
                Text {
                    Layout.alignment: Qt.AlignRight
                    text: {
                        if (root.timestamp > 0) {
                            var date = new Date(root.timestamp);
                            return Qt.formatDateTime(date, "hh:mm:ss");
                        }
                        return "";
                    }
                    color: Theme.timestampColor
                    font.pixelSize: Theme.fontSizeSmall
                    font.family: Theme.fontFamily
                }
            }
        }
        
        // Right spacer (Agent is on the left → requires right stretch)
        Item { 
            Layout.fillWidth: !root.isUser
            visible: !root.isUser
        }
    }
    
    // Animation effect
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
    
    // Hover effect (does not block children clicks)
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton  // Only for hover, do not accept clicks to prevent swallowing button clicks
        propagateComposedEvents: true
        onEntered: {
            if (root.hasAudio) root.opacity = 0.9
        }
        onExited: root.opacity = 1.0
    }
    
    // Image viewer window (independent window, movable, resizable, supports zooming)
    Window {
        id: imageViewWindow
        title: "Image Preview"
        modality: Qt.ApplicationModal
        flags: Qt.Window | Qt.FramelessWindowHint  // Frameless window
        color: "transparent"
        
        property real zoomScale: 0.5  // Scaling ratio (default 50%)
        
        // Adaptive window size based on image (default 50%)
        width: {
            if (fullImage.status === Image.Ready && fullImage.implicitWidth > 0) {
                return Math.min(fullImage.implicitWidth * 0.5 + 40, Screen.width * 0.9)
            }
            return 600
        }
        height: {
            if (fullImage.status === Image.Ready && fullImage.implicitHeight > 0) {
                return Math.min(fullImage.implicitHeight * 0.5 + 120, Screen.height * 0.9)
            }
            return 500
        }
        
        // Centered display
        Component.onCompleted: {
            x = (Screen.width - width) / 2
            y = (Screen.height - height) / 2
        }
        
        Rectangle {
            anchors.fill: parent
            color: Theme.backgroundColor  // Solid background: light theme white, dark theme black
            
            // Custom title bar (draggable)
            Rectangle {
                id: titleBar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 40
                color: Theme.backgroundColor  // Same color as main background
                
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 15
                    text: "📷 Image Preview"
                    color: Theme.textColor
                    font.pixelSize: 14
                    font.bold: true
                }
                
                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    spacing: 5
                    
                    // Minimize button
                    Button {
                        width: 30
                        height: 30
                        text: "─"
                        font.pixelSize: 16
                        
                        background: Rectangle {
                            color: parent.hovered ? Qt.rgba(0, 0, 0, 0.1) : "transparent"
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: Theme.textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font: parent.font
                        }
                        
                        onClicked: imageViewWindow.showMinimized()
                    }
                    
                    // Maximize/Restore button
                    Button {
                        width: 30
                        height: 30
                        text: imageViewWindow.visibility === Window.Maximized ? "❐" : "□"
                        font.pixelSize: 16
                        
                        background: Rectangle {
                            color: parent.hovered ? Qt.rgba(0, 0, 0, 0.1) : "transparent"
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: Theme.textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font: parent.font
                        }
                        
                        onClicked: {
                            if (imageViewWindow.visibility === Window.Maximized) {
                                imageViewWindow.showNormal()
                            } else {
                                imageViewWindow.showMaximized()
                            }
                        }
                    }
                    
                    // Close button
                    Button {
                        width: 30
                        height: 30
                        text: "×"
                        font.pixelSize: 20
                        font.bold: true
                        
                        background: Rectangle {
                            color: parent.hovered ? "#ff4444" : "transparent"
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: parent.parent.hovered ? "white" : Theme.textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font: parent.font
                        }
                        
                        onClicked: imageViewWindow.close()
                    }
                }
                
                // Dragging area
                MouseArea {
                    anchors.fill: parent
                    anchors.rightMargin: 120
                    property point clickPos: Qt.point(0, 0)
                    
                    onPressed: {
                        clickPos = Qt.point(mouse.x, mouse.y)
                    }
                    
                    onPositionChanged: {
                        if (pressed) {
                            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                            imageViewWindow.x += delta.x
                            imageViewWindow.y += delta.y
                        }
                    }
                    
                    onDoubleClicked: {
                        if (imageViewWindow.visibility === Window.Maximized) {
                            imageViewWindow.showNormal()
                        } else {
                            imageViewWindow.showMaximized()
                        }
                    }
                }
            }
            
            // Toolbar (Zoom controls)
            Rectangle {
                id: toolbar
                anchors.top: titleBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 60
                color: Theme.backgroundColor  // Same color as main background
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    
                    Text {
                        text: "Zoom:"
                        color: Theme.textColor
                    }
                    
                    Button {
                        text: "-"
                        implicitWidth: 30
                        onClicked: {
                            if (zoomSlider.value > zoomSlider.from) {
                                zoomSlider.value -= 0.25
                            }
                        }
                    }
                    
                    Slider {
                        id: zoomSlider
                        Layout.fillWidth: true
                        from: 0.25
                        to: 4.0
                        value: 0.5  // Default 50%
                        stepSize: 0.25
                        
                        onValueChanged: {
                            imageViewWindow.zoomScale = value
                        }
                    }
                    
                    Button {
                        text: "+"
                        implicitWidth: 30
                        onClicked: {
                            if (zoomSlider.value < zoomSlider.to) {
                                zoomSlider.value += 0.25
                            }
                        }
                    }
                    
                    Text {
                        text: Math.round(zoomSlider.value * 100) + "%"
                        color: Theme.textColor
                        Layout.preferredWidth: 50
                    }
                    
                    Button {
                        text: "Fit"
                        onClicked: {
                            zoomSlider.value = 1.0
                        }
                    }
                    
                    Button {
                        text: "Original"
                        onClicked: {
                            if (fullImage.status === Image.Ready && fullImage.implicitWidth > 0) {
                                var fitScale = Math.min(
                                    (imageFlickable.width - 40) / fullImage.implicitWidth,
                                    (imageFlickable.height - 40) / fullImage.implicitHeight
                                )
                                zoomSlider.value = 1.0 / fitScale
                            }
                        }
                    }
                }
            }
            
            Flickable {
                id: imageFlickable
                anchors.top: toolbar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                contentWidth: fullImage.width
                contentHeight: fullImage.height
                clip: true
                
                ScrollBar.vertical: ScrollBar { }
                ScrollBar.horizontal: ScrollBar { }
                
                Image {
                    id: fullImage
                    source: root.hasImage ? ("file:///" + root.imagePath) : ""
                    fillMode: Image.PreserveAspectFit  // Maintain ratio, display fully
                    smooth: true
                    cache: false
                    
                    // Adjust display area size according to scaling ratio
                    width: implicitWidth * imageViewWindow.zoomScale
                    height: implicitHeight * imageViewWindow.zoomScale
                    
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: fullImage.status === Image.Loading
                        visible: running
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        visible: fullImage.status === Image.Error
                        text: "❌ Image failed to load\nPath: " + root.imagePath
                        color: Theme.textColor
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Error handling: stop retry loading
                    onStatusChanged: {
                        if (status === Image.Error) {
                            // Delay clearing source to stop retry and prevent continuous errors
                            fullImageErrorTimer.restart()
                        }
                    }

                    Timer {
                        id: fullImageErrorTimer
                        interval: 100
                        onTriggered: {
                            if (fullImage.status === Image.Error) {
                                fullImage.source = ""
                            }
                        }
                    }
                }
            }
        }
    }
}