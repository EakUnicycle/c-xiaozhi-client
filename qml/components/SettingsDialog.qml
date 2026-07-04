import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root

    title: "⚙️ Settings"
    modal: true
    width: 580
    height: 520
    anchors.centerIn: parent

    property var audioDeviceManager: null

    background: Rectangle {
        color: "#f5f5f5"
        radius: 12
    }

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
                onClicked: root.reject()
            }
        }
    }

    contentItem: Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height
        clip: true

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                color: "white"
                radius: 8

                ColumnLayout {
                    anchors.margins: 15
                    spacing: 12

                    Text {
                        text: "Audio Devices"
                        font.bold: true
                    }

                    ColumnLayout {
                        Text { text: "🎤 Input Device (Microphone)" }
                        ComboBox { }
                    }

                    ColumnLayout {
                        Text { text: "🔊 Output Device (Speaker)" }
                        ComboBox { }
                    }
                }
            }
        }
    }

    footer: Rectangle {
        height: 70
        color: "white"
        radius: 12

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16

            Item { Layout.fillWidth: true }

            Button {
                text: "Cancel"
                onClicked: root.reject()
            }

            Button {
                text: "Confirm Save"
                onClicked: confirmDialog.open()
            }
        }
    }

    Dialog {
        id: confirmDialog
        title: "Confirm Save"
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Yes | Dialog.No

        onAccepted: {
            root.accept()
        }
    }
}
