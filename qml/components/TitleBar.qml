import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    color: Theme.backgroundColor
    border.width: 0
    
    // Window drag area
    MouseArea {
        id: dragArea
        anchors.fill: parent
        anchors.rightMargin: controlButtons.width
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        
        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                Window.window.startSystemMove()
            }
        }
        
        onDoubleClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                if (Window.window.visibility === Window.Maximized) {
                    Window.window.showNormal()
                } else {
                    Window.window.showMaximized()
                }
            }
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15
        
        // Left: Application Name and Version
        Row {
            spacing: 15
            Layout.fillWidth: true
            
            // App Icon
            Rectangle {
                width: 32
                height: 32
                radius: 16
                color: Theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "智"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#FFFFFF"
                }
            }
            
            // Program Name and Version
            Text {
                text: appModel.getAppTitle()
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
                color: Theme.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Right: Control Buttons
        Row {
            id: controlButtons
            spacing: 5
            
            // Settings Button
            Button {
                text: "⚙️"
                width: 35
                height: 35
                onClicked: settingsDialog.open()
                ToolTip.visible: hovered
                ToolTip.text: "Settings"
                ToolTip.delay: 500
            }
            
            // Theme Toggle Button
            Button {
                text: appModel.isDarkTheme ? "☀" : "🌙"
                width: 35
                height: 35
                onClicked: appModel.toggleTheme()
                ToolTip.visible: hovered
                ToolTip.text: appModel.isDarkTheme ? "Switch to light theme" : "Switch to dark theme"
                ToolTip.delay: 500
            }
            
            // Minimize Button
            Button {
                text: "—"
                width: 35
                height: 35
                onClicked: Window.window.showMinimized()
            }
            
            // Maximize/Restore Button
            Button {
                text: Window.window.visibility === Window.Maximized ? "❐" : "□"
                width: 35
                height: 35
                onClicked: {
                    if (Window.window.visibility === Window.Maximized) {
                        Window.window.showNormal()
                    } else {
                        Window.window.showMaximized()
                    }
                }
            }
            
            // Close Button
            Button {
                text: "✕"
                width: 35
                height: 35
                onClicked: Qt.quit()
                
                background: Rectangle {
                    color: parent.hovered ? Theme.errorColor : Theme.backgroundColor
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#FFFFFF" : Theme.errorColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    
  }