import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Dialog {
    id: root
    title: "Add Agent Device"
    modal: true
    anchors.centerIn: parent
    width: 500
    height: 400
    
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
                placeholderText: "Please enter device name (e.g., Agent Xiaozhi)"
                text: ""
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
                text: "https://api.tenclass.net/xiaozhi/ota/"
            }
        }
        
        // MAC address input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            
            Text {
                text: "MAC Address:"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.textColor
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                TextField {
                    id: macAddressField
                    Layout.fillWidth: true
                    placeholderText: "02:xx:xx:xx:xx:xx"
                    text: appModel.generateRandomMac()
                }
                
                Button {
                    text: "Random Generate"
                    onClicked: {
                        macAddressField.text = appModel.generateRandomMac()
                    }
                }
            }
        }
        
        // Restriction notice
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Theme.highlightColor
            radius: 4
            border.width: 0
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4
                
                Text {
                    Layout.fillWidth: true
                    text: " Agent Addition Rules:"
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    color: Theme.textColor
                }
                
                Text {
                    Layout.fillWidth: true
                    text: "• You can only add up to 2 agents"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textColor
                }
                
                Text {
                    Layout.fillWidth: true
                    text: "• Only 1 agent can be added to the official server"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textColor
                }
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
                text: "OK"
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
                    
                    var mac = macAddressField.text.trim().toLowerCase()
                    var macRegex = /^([0-9a-f]{2}:){5}[0-9a-f]{2}$/
                    if (!macRegex.test(mac)) {
                        errors.push("Invalid MAC address format (must be lowercase xx:xx:xx:xx:xx:xx format)")
                    }
                    
                    if (errors.length > 0) {
                        errorText.text = errors.join("\n")
                        return
                    }
                    
                    // Check addition limits
                    var checkResult = appModel.canAddDevice(otaUrl)
                    if (!checkResult.canAdd) {
                        errorText.text = checkResult.errorMessage
                        return
                    }
                    
                    // Add device
                    appModel.addDevice(
                        deviceNameField.text.trim(),
                        otaUrl,
                        mac
                    )
                    
                    // Clear form
                    deviceNameField.text = ""
                    otaUrlField.text = "https://api.tenclass.net/xiaozhi/ota/"
                    macAddressField.text = appModel.generateRandomMac()
                    errorText.text = ""
                    
                    root.close()
                }
            }
        }
    }
}