/*
Project: jtxiaozhi-client
Version: v0.1.0
Author: jtserver team
Email: jwhna1@gmail.com
Updated: 2025-10-18T11:15:00Z
File: UpdateDialog.qml
Desc: Version upgrade dialog
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import XiaozhiClient
import "../theme"

Dialog {
    id: root
    title: "🚀 Version Upgrade"
    modal: true
    width: 600
    height: 500
    anchors.centerIn: parent
    closePolicy: Dialog.CloseOnEscape | Popup.CloseOnPressOutside

    // Custom properties
    property var updateManager: null
    property alias downloadProgress: progressBar.value

    background: Rectangle {
        color: Theme.backgroundColor
        radius: 12
        border.width: 0
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Header Information
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            // Icon
            Rectangle {
                width: 48
                height: 48
                radius: 24
                color: Theme.primaryColor

                Text {
                    anchors.centerIn: parent
                    text: "🔄"
                    font.pixelSize: 24
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5

                Text {
                    text: "New version found"
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                    color: Theme.textColor
                }

                Text {
                    text: updateManager ? ("Current version: " + updateManager.currentVersion + " → Latest version: " + updateManager.latestVersion) :
                           "Checking version information..."
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                }
            }
        }

        // Version Information
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: Theme.highlightColor
            radius: 8
            border.width: 0

            ScrollView {
                anchors.fill: parent
                anchors.margins: 15

                TextArea {
                    id: releaseNotesText
                    text: (updateManager && updateManager.releaseInfo && updateManager.releaseInfo.isValid) ?
                          (updateManager.releaseInfo.body + "\n\n📂 Download Link: https://github.com/jwhna1/jtxiaozhi-client/releases") :
                          "Getting update content..."
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.textColor
                    wrapMode: TextArea.Wrap
                    readOnly: true
                    selectByMouse: true
                    background: Item {}

                    onLinkActivated: (link) => {
                        Qt.openUrlExternally(link)
                    }
                }
            }
        }

        // Download Progress
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            visible: updateManager && updateManager.status !== undefined && updateManager.status === UpdateManager.Downloading

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: updateManager ? (updateManager.updateStatusText || "Preparing download...") : "Preparing download..."
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.textColor
                }

                ProgressBar {
                    id: progressBar
                    Layout.fillWidth: true
                    Layout.preferredHeight: 8
                    value: updateManager ? (updateManager.downloadProgress || 0) : 0

                    background: Rectangle {
                        color: Theme.borderColor
                        radius: 4
                        border.width: 0
                    }

                    contentItem: Rectangle {
                        color: Theme.primaryColor
                        radius: 4
                        width: progressBar.visualPosition * progressBar.width
                    }
                }
            }
        }

        // Status Information
        Text {
            Layout.fillWidth: true
            text: updateManager ? (updateManager.updateStatusText || "") : ""
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.textColor
            visible: updateManager && updateManager.status !== undefined && updateManager.status !== UpdateManager.Downloading
            horizontalAlignment: Text.AlignHCenter
        }

        // Button Area
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight

            // GitHub Link Button
            Button {
                text: "📂 GitHub"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 36
                visible: updateManager && updateManager.status !== undefined && updateManager.status === UpdateManager.UpdateAvailable

                background: Rectangle {
                    color: parent.hovered ? "#24292e" : "#2f363d"
                    radius: 6
                    border.width: 1
                    border.color: "#d1d5db"
                }

                contentItem: Text {
                    text: parent.text
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                }

                onClicked: {
                    Qt.openUrlExternally("https://github.com/jwhna1/jtxiaozhi-client/releases")
                }
            }

            // Cancel Button
            Button {
                text: "Cancel"
                Layout.preferredWidth: 80
                Layout.preferredHeight: 36
                visible: updateManager && updateManager.status !== undefined && updateManager.status === UpdateManager.UpdateAvailable

                background: Rectangle {
                    color: parent.hovered ? Theme.buttonPressedColor : Theme.buttonColor
                    radius: 6
                    border.width: 1
                    border.color: "#d1d5db"
                }

                contentItem: Text {
                    text: parent.text
                    color: Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                }

                onClicked: root.close()
            }

            // Remind Me Later Button
            Button {
                text: "Remind Later"
                Layout.preferredWidth: 80
                Layout.preferredHeight: 36
                visible: updateManager && updateManager.status !== undefined && updateManager.status === UpdateManager.UpdateAvailable

                background: Rectangle {
                    color: parent.hovered ? Theme.highlightColor : Theme.buttonColor
                    radius: 6
                    border.width: 1
                    border.color: "#d1d5db"
                }

                contentItem: Text {
                    text: parent.text
                    color: Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                }

                onClicked: root.close()
            }

            // Download/Update Button
            Button {
                text: "Update Now"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 36
                visible: updateManager && updateManager.status !== undefined && updateManager.status === UpdateManager.UpdateAvailable
                enabled: updateManager && updateManager.releaseInfo && updateManager.releaseInfo.isValid

                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? Theme.primaryColor : "#4CAF50") : Theme.buttonColor
                    radius: 6
                    border.width: 1
                    border.color: parent.enabled ? (parent.hovered ? Theme.primaryColor : "#45a049") : "#d1d5db"
                }

                contentItem: Text {
                    text: parent.text
                    color: parent.enabled ? "#FFFFFF" : Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }

                onClicked: {
                    if (updateManager) {
                        updateManager.downloadUpdate()
                    }
                }
            }

            // Install Button
            Button {
                text: "Install Update"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 36
                visible: updateManager && updateManager.status !== undefined && updateManager.status === UpdateManager.InstallReady

                background: Rectangle {
                    color: parent.hovered ? Theme.primaryColor : "#4CAF50"
                    radius: 6
                    border.width: 1
                    border.color: parent.hovered ? Theme.primaryColor : "#45a049"
                }

                contentItem: Text {
                    text: parent.text
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }

                onClicked: {
                    if (updateManager) {
                        updateManager.installUpdate()
                        root.close()
                    }
                }
            }

            // Retry Button
            Button {
                text: "Retry"
                Layout.preferredWidth: 80
                Layout.preferredHeight: 36
                visible: updateManager && updateManager.status !== undefined && (updateManager.status === UpdateManager.DownloadFailed ||
                                        updateManager.status === UpdateManager.Checking)

                background: Rectangle {
                    color: parent.hovered ? Theme.warningColor : Theme.buttonColor
                    radius: 6
                    border.width: 1
                    border.color: parent.hovered ? Theme.warningColor : "#d1d5db"
                }

                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#FFFFFF" : Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                }

                onClicked: {
                    if (updateManager) {
                        updateManager.checkForUpdates(false)
                    }
                }
            }
        }
    }

    // Listen for update manager status changes
    Connections {
        target: updateManager

        function onStatusChanged() {
            if (!updateManager || updateManager.status === undefined) return

            switch(updateManager.status) {
                case UpdateManager.UpdateAvailable:
                    root.open()
                    break
                case UpdateManager.NoUpdateAvailable:
                    if (root.visible) {
                        root.close()
                    }
                    break
                case UpdateManager.InstallReady:
                    // Keep dialog open when installation is ready
                    break
                case UpdateManager.DownloadFailed:
                    // Keep dialog open on download failure to show retry button
                    break
            }
        }
    }

    // Manual check for updates
    function checkForUpdates() {
        if (updateManager) {
            root.open()
            updateManager.checkForUpdates(false)
        }
    }

    // Show update available
    function showUpdateAvailable() {
        root.open()
    }
}