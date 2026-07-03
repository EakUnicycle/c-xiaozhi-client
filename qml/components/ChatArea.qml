import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    color: Theme.backgroundColor
    border.width: 0
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Status information bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70  // Slightly increased height to provide more space for the button
            color: Theme.highlightColor
            radius: 8  // Increased corner radius to match the button

            RowLayout {
                anchors.fill: parent
                anchors.margins: 18  // Increased margins for more breathing room
                spacing: 20  // Increased spacing between elements to avoid visual crowding

                Text {
                    text: "Status:"
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.textColor
                }

                Text {
                    text: appModel.statusMessage
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    color: appModel.connected ? Theme.successColor : Theme.textColor
                }

                // Use spacing instead of a divider line
                Item {
                    Layout.preferredWidth: 1
                    visible: appModel.conversationManager !== null
                }

                Text {
                    text: {
                        if (!appModel.conversationManager) return ""
                        switch(appModel.conversationManager.state) {
                            case 0: return "💤 Idle"
                            case 1: return "👂 Listening"
                            case 2: return "🗣️ Speaking"
                            default: return ""
                        }
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    color: {
                        if (!appModel.conversationManager) return Theme.textColor
                        switch(appModel.conversationManager.state) {
                            case 1: return "#4CAF50"  // Green (Listening)
                            case 2: return "#2196F3"  // Blue (Speaking)
                            default: return Theme.textColor
                        }
                    }
                    visible: appModel.conversationManager !== null
                }
                
                Item {
                    Layout.fillWidth: true
                }
                
                // Connect button (triggers complete OTA flow: OTA -> MQTT -> UDP automatic establishment)
                Button {
                    text: appModel.connected ? "🔌 Disconnect" : "🔗 Connect"
                    Layout.preferredHeight: 40  // Increased height for better integration into the status bar
                    Layout.preferredWidth: 120
                    Layout.alignment: Qt.AlignVCenter  // Vertically centered
                    font.pixelSize: Theme.fontSizeMedium
                    
                    background: Rectangle {
                        // Optimized background color for better visual integration
                        color: {
                            if (parent.hovered) {
                                return appModel.connected ? "#ff6b6b" : "#4CAF50"  // Status color when hovered
                            } else {
                                return appModel.connected ? "#e8f4fd" : "#e8f4fd"  // Default light blue to match status bar
                            }
                        }
                        radius: 8  // Increased radius for a modern look
                        border.width: 1
                        border.color: {
                            if (parent.hovered) {
                                return appModel.connected ? "#e53e3e" : "#45a049"
                            } else {
                                return appModel.connected ? "#d1d5db" : "#d1d5db"
                            }
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: {
                            if (parent.parent.hovered) {
                                return "#FFFFFF"  // White text when hovered
                            } else {
                                return appModel.connected ? Theme.textColor : Theme.textColor  // Default text color
                            }
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: parent.font.pixelSize
                        font.bold: (parent.parent && parent.parent.hovered) || false
                    }
                    
                    // Added smooth transition animation
                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    
                    // Hover effect
                    onHoveredChanged: {
                        if (hovered) {
                            scale = 1.05
                        } else {
                            scale = 1.0
                        }
                    }
                    
                    onClicked: {
                        if (appModel.connected) {
                            appModel.disconnectDevice(appModel.currentDeviceId)
                        } else {
                            // Connect: Get OTA config -> Auto-connect MQTT -> Auto-send hello -> Auto-establish UDP
                            appModel.connectDevice(appModel.currentDeviceId)
                        }
                    }
                }
            }
        }
        
        // Chat message list (replaces original log display)
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ListView {
                id: chatListView
                spacing: 8
                
                model: appModel.chatMessages  // Bound to AppModel
                
                delegate: ChatBubble {
                    width: chatListView.width
                    // Use modelData to access fields in QVariantMap
                    messageId: (modelData && modelData.id) ? modelData.id : -1
                    isUser: modelData && (modelData.messageType === "stt" || 
                                          modelData.messageType === "text" || 
                                          modelData.messageType === "image")
                    messageText: (modelData && modelData.textContent) ? modelData.textContent : ""
                    audioPath: (modelData && modelData.audioFilePath) ? modelData.audioFilePath : ""
                    imagePath: (modelData && modelData.imagePath) ? modelData.imagePath : ""
                    isPlaying: (modelData && modelData.isPlaying) ? modelData.isPlaying : false
                    timestamp: (modelData && modelData.timestamp) ? modelData.timestamp : 0
                    messageType: (modelData && modelData.messageType) ? modelData.messageType : ""
                }
                
                // Auto-scroll to bottom
                onCountChanged: {
                    Qt.callLater(() => {
                        chatListView.positionViewAtEnd()
                    })
                }
            }
        }
    }
    
    // Listen for device switching to refresh chat history
    Connections {
        target: appModel
        function onCurrentDeviceIdChanged() {
            // AppModel internally handles loading chat history for the new device
        }
    }
}