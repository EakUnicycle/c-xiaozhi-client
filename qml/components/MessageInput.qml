import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    color: Theme.backgroundColor
    border.width: 0
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        
        // Text input field
        TextField {
            id: messageTextField
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            placeholderText: "Enter text to send......"

            background: Rectangle {
                color: Theme.backgroundColor
                radius: 6
                border.width: 1
                border.color: parent.activeFocus ? Theme.primaryColor : (parent.hovered ? Theme.borderColor : "#e0e0e0")
            }

            Keys.onReturnPressed: {
                sendMessage()
            }
        }
        
        // Send button
        Button {
            text: "📤"
            width: 50
            height: 40
            font.pixelSize: 20
            ToolTip.visible: hovered
            ToolTip.text: "Send message"

            background: Rectangle {
                color: parent.hovered ? Theme.primaryColor : Theme.buttonColor
                radius: 6
                border.width: 1
                border.color: parent.hovered ? Theme.primaryColor : "#d1d5db"
            }

            contentItem: Text {
                text: parent.text
                color: parent.hovered ? "#FFFFFF" : Theme.textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.font.pixelSize
            }

            onClicked: sendMessage()
        }
        
        // Right-side function buttons
        Row {
            spacing: 8  // Increase button spacing for a cleaner interface

            // Microphone button (Recording)
            Button {
                width: 50
                height: 40
                text: appModel.conversationManager && appModel.conversationManager.isRecording ? "⏹️" : "🎤"
                font.pixelSize: 20
                ToolTip.visible: hovered
                ToolTip.text: appModel.conversationManager && appModel.conversationManager.isRecording ? "Stop recording" : "Start conversation"
                enabled: appModel.connected  // Available after MQTT is connected

                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? Theme.highlightColor : Theme.buttonColor) : "transparent"
                    radius: 6
                    border.width: 1
                    border.color: parent.enabled ? (parent.hovered ? Theme.highlightColor : "#d1d5db") : "transparent"
                }

                onClicked: {
                    if (appModel.conversationManager) {
                        if (appModel.conversationManager.isRecording) {
                            appModel.conversationManager.stopRecording()
                        } else {
                            // Click to start conversation, automatically establish UDP (if not already established)
                            appModel.conversationManager.startConversation()
                        }
                    }
                }
            }

            // Abort button (Visible during speaking state)
            Button {
                width: 50
                height: 40
                text: "⏸️"
                font.pixelSize: 20
                ToolTip.visible: hovered
                ToolTip.text: "Abort speaking"
                visible: appModel.conversationManager && appModel.conversationManager.state === 2  // Speaking = 2
                enabled: appModel.conversationManager !== null

                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? Theme.warningColor : Theme.buttonColor) : "transparent"
                    radius: 6
                    border.width: 1
                    border.color: parent.enabled ? (parent.hovered ? Theme.warningColor : "#d1d5db") : "transparent"
                }

                onClicked: {
                    if (appModel.conversationManager) {
                        appModel.conversationManager.abortSpeaking()
                    }
                }
            }
        }
    }
    
    function sendMessage() {
        var text = messageTextField.text.trim()
        if (text !== "") {
            appModel.sendTextMessage(text)
            messageTextField.text = ""
        }
    }
    
}