import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Dialog {
    id: root
    title: "Edit Device"
    modal: true
    anchors.centerIn: parent
    width: 500
    height: 350
    
    property string deviceId: ""
    property string deviceName: ""
    property string otaUrl: ""
    property string macAddress: ""
    
    background: Rectangle {
        color: Theme.backgroundColor
        border.width: 0
        radius: 5
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // Device name input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            
            Text {
                text: "Device Name:"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.textColor
            }
            
            TextField {
                id: deviceNameField
                Layout.fillWidth: true
                placeholderText: "Please enter device name"
                text: root.deviceName
            }
        }
        
        // OTA URL input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            
            Text {
                text: "OTA Server URL:"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.textColor
            }
            
            TextField {
                id: otaUrlField
                Layout.fillWidth: true
                placeholderText: "https://api.tenclass.net/xiaozhi/ota/"
                text: root.otaUrl
            }
        }
        
        // MAC address display (read-only)
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            
            Text {
                text: "MAC Address (cannot be modified):"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.textColor
            }
            
            TextField {
                id: macAddressField
                Layout.fillWidth: true
                text: root.macAddress
                readOnly: true
                opacity: 0.6
            }
        }
        
        // Error message
        Text {
            id: errorText
            Layout.fillWidth: true
            text: ""
            color: Theme.errorColor
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            visible: text !== ""
        }
        
        Item {
            Layout.fillHeight: true
        }
        
        // Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Item {
                Layout.fillWidth: true
            }
            
            Button {
                text: "Cancel"
                onClicked: root.close()
            }
            
            Button {
                text: "Save"
                highlighted: true
                onClicked: {
                    // Validate input
                    var errors = []
                    
                    if (deviceNameField.text.trim() === "") {
                        errors.push("Device name cannot be empty")
                    }
                    
                    var otaUrl = otaUrlField.text.trim()
                    if (!otaUrl.startsWith("http://") && !otaUrl.startsWith("https://")) {
                        errors.push("Invalid OTA URL format (must start with http:// or https://)")
                    }
                    
                    if (errors.length > 0) {
                        errorText.text = errors.join("\n")
                        return
                    }
                    
                    // Update device (requires calling AppModel method)
                    appModel.updateDevice(
                        root.deviceId,
                        deviceNameField.text.trim(),
                        otaUrl
                    )
                    
                    errorText.text = ""
                    root.close()
                }
            }
        }
    }
    
    onOpened: {
        deviceNameField.text = root.deviceName
        otaUrlField.text = root.otaUrl
        macAddressField.text = root.macAddress
        errorText.text = ""
    }
}