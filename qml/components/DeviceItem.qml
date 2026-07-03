import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    height: 70
    color: selected ? Theme.highlightColor : (mouseArea.containsMouse ? Theme.borderColor : "transparent")
    radius: 5
    
    property string deviceName: ""
    property string deviceId: ""
    property bool connected: false
    property bool selected: false
    
    signal clicked()
    signal doubleClicked()
    signal deleteClicked()
    signal editClicked()
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
        onDoubleClicked: root.doubleClicked()
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Device avatar
        Rectangle {
            width: 50
            height: 50
            radius: 25
            color: Theme.borderColor
            
            Text {
                anchors.centerIn: parent
                text: deviceName.substring(0, 2)
                font.pixelSize: 18
                color: Theme.textColor
            }
        }
        
        // Device information
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3
            
            Text {
                text: deviceName
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
                color: Theme.primaryColor
            }
            
            Text {
                text: connected ? "🟢 Connected" : "⚪ Disconnected"
                font.pixelSize: Theme.fontSizeSmall
                color: connected ? Theme.successColor : Theme.textColor
                opacity: 0.8
            }
        }
        
        // Action buttons
        Row {
            spacing: 5
            
            // Edit button
            Button {
                text: "✏️"
                width: 30
                height: 30
                font.pixelSize: 14
                ToolTip.visible: hovered
                ToolTip.text: "Edit device"
                onClicked: root.editClicked()
            }
            
            // Delete button
            Button {
                text: "🗑️"
                width: 30
                height: 30
                font.pixelSize: 14
                ToolTip.visible: hovered
                ToolTip.text: "Delete device"
                onClicked: {
                    deleteConfirmDialog.open()
                }
            }
        }
    }
    
    // Delete confirmation dialog
    Dialog {
        id: deleteConfirmDialog
        title: "Confirm Deletion"
        modal: true
        anchors.centerIn: parent
        width: 300
        height: 150
        
        contentItem: Text {
            text: "Are you sure you want to delete the device \"" + deviceName + "\"?\nThis cannot be undone."
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.textColor
        }
        
        standardButtons: Dialog.Ok | Dialog.Cancel
        
        onAccepted: {
            root.deleteClicked()
        }
    }
}