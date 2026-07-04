import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * Settings Dialog - Card-style design, supports future expansion
 */
Dialog {
    id: root
    
    title: "⚙️ Settings"
    modal: true
    width: 580
    height: 520
    anchors.centerIn: parent
    
    // Custom properties
    property var audioDeviceManager: null
    
    // Background
    background: Rectangle {
        color: "#f5f5f5"
        radius: 12
        border.width: 0
    }
    
    // Header
    header: Rectangle {
        height: 60
        color: "white"
        radius: 12
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 20
            
            Text {
                text: "⚙️ System Settings"
                font.pixelSize: 18
                font.bold: true
                color: "#333333"
                Layout.fillWidth: true
            }
            
            Button {
                text: "✖"
                flat: true
                font.pixelSize: 16
                onClicked: root.reject()
                
                background: Rectangle {
                    color: parent.hovered ? "#f0f0f0" : "transparent"
                    radius: 4
                }
            }
        }
    }
// Content area
    contentItem: Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height
        clip: true
        
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
        
        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 16
            
            // Audio settings card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: audioCard.height + 30
                color: "white"
                radius: 8
                
                ColumnLayout {
                    id: audioCard
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 15 }
                    spacing: 12
                    
                    RowLayout {
                        Text { text: "Audio Devices"; font.bold: true }
                    }
                    
                    // Input device
                    ColumnLayout {
                        Text { text: "🎤 Input Device (Microphone)" }
                        ComboBox { id: inputDeviceCombo }
                        Text { text: "Used for recording and sending voice"; font.pixelSize: 11; color: "#666666" }
                    }
                    
                    // Output device
                    ColumnLayout {
                        Text { text: "🔊 Output Device (Speaker)" }
                        ComboBox { id: outputDeviceCombo }
                        Text { text: "Used for playing received voice"; font.pixelSize: 11; color: "#666666" }
                    }
                }
            }
            
            // General settings card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: generalCard.height + 30
                color: "white"; radius: 8
                
                ColumnLayout {
                    id: generalCard
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 15 }
                    spacing: 12
                    
                    RowLayout {
                        Text { text: "General Settings"; font.bold: true }
                    }
                    
                    RowLayout {
                        ColumnLayout {
                            Text { text: "🌐 WebSocket Protocol"; font.bold: true }
                            Text { text: "Enabled to use WebSocket for audio calls (requires server support)"; font.pixelSize: 11; color: "#666666" }
                        }
                    }
                }
            }
        }
    }
// Bottom buttons
    footer: Rectangle {
        height: 70; color: "white"; radius: 12
        RowLayout {
            anchors { fill: parent; margins: 16 }; spacing: 12
            Item { Layout.fillWidth: true }
            
            Button { text: "Cancel"; onClicked: root.reject() }
            Button { text: "Confirm Save"; onClicked: confirmDialog.open() }
        }
    }
    
    // Confirm save dialog
    Dialog {
        id: confirmDialog
        title: "Confirm Save"
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Yes | Dialog.No
        
        Label {
            text: "Are you sure you want to save audio device settings?"
        }
        
        onAccepted: {
            // Save logic here
            root.accept()
        }
    }
