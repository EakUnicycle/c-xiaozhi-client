import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    color: Theme.sidebarBackgroundColor
    border.width: 0
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        // Top: User Avatar + Add Device Button
        Row {
            Layout.fillWidth: true
            spacing: 10
            
            // User Avatar
            Rectangle {
                width: 50
                height: 50
                radius: 25
                color: Theme.borderColor
                
                Text {
                    anchors.centerIn: parent
                    text: "Me"
                    font.pixelSize: 20
                    color: Theme.textColor
                }
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            // Add Device Button
            Button {
                text: "+"
                width: 40
                height: 40
                font.pixelSize: 24
                enabled: appModel.deviceList.length < 2
                opacity: enabled ? 1.0 : 0.5
                onClicked: {
                    if (enabled) {
                        addDeviceDialog.open()
                    }
                }
                
                // ToolTip
                ToolTip.visible: !enabled && hovered
                ToolTip.text: "Maximum of 2 agents can be added"
            }
        }
        
        // Device Count Hint
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: Theme.highlightColor
            radius: 4
            visible: appModel.deviceList.length >= 1
            
            Text {
                anchors.centerIn: parent
                text: "Agent: " + appModel.deviceList.length + "/2"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textColor
            }
        }
        
        // Device List
        ListView {
            id: deviceListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 5
            
            model: ListModel {
                id: deviceListModel
            }
            
            delegate: DeviceItem {
                width: deviceListView.width
                deviceId: model.deviceId
                deviceName: model.deviceName
                connected: model.connected
                selected: appModel.currentDeviceId === model.deviceId
                
                onClicked: {
                    appModel.selectDevice(model.deviceId)
                }
                
                onDoubleClicked: {
                    // Double click device to auto-connect OTA
                    appModel.selectDevice(model.deviceId)
                    appModel.connectDevice(model.deviceId)
                }
                
                onDeleteClicked: {
                    appModel.removeDevice(model.deviceId)
                }
                
                onEditClicked: {
                    var deviceInfo = appModel.getDeviceInfo(model.deviceId)
                    editDeviceDialog.deviceId = deviceInfo.deviceId
                    editDeviceDialog.deviceName = deviceInfo.deviceName
                    editDeviceDialog.otaUrl = deviceInfo.otaUrl
                    editDeviceDialog.macAddress = deviceInfo.macAddress
                    editDeviceDialog.open()
                }
            }
        }
        
        // Bottom: About Button
        Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            text: "ℹ About"
            font.pixelSize: Theme.fontSizeMedium
            
            background: Rectangle {
                color: parent.hovered ? Theme.highlightColor : Theme.buttonColor
                radius: 6
                border.width: 0
            }
            
            contentItem: Text {
                text: parent.text
                color: parent.hovered ? Theme.textColor : Theme.buttonTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.font.pixelSize
            }
            
            onClicked: aboutDialog.open()
        }
    }
    
    // Add Device Dialog
    AddDeviceDialog {
        id: addDeviceDialog
    }
    
    // About Dialog
    AboutDialog {
        id: aboutDialog
    }
    
    // Edit Device Dialog
    EditDeviceDialog {
        id: editDeviceDialog
    }
    
    // Listen to device list changes
    Connections {
        target: appModel
        function onDeviceListChanged() {
            updateDeviceList()
        }
        
        // Listen to connection status changes
        function onConnectedChanged() {
            updateDeviceList()
        }
        
        function onUdpConnectedChanged() {
            updateDeviceList()
        }
    }
    
    // Update Device List
    function updateDeviceList() {
        deviceListModel.clear()
        var devices = appModel.deviceInfoList
        for (var i = 0; i < devices.length; i++) {
            deviceListModel.append(devices[i])
        }
    }
    
    Component.onCompleted: {
        updateDeviceList()
    }
}