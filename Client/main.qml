import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 600
    height: 600
    title: "Chat Client"
    color: "#1E1E1E"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        Text {
            text: "CHAT CLIENT"
            color: "#AAAAAA"
            font.pixelSize: 25
            font.bold: true
        }

        Text {
            text: client.status
            color: client.connected ? "#4ecca3" : "#AAAAAA"
            font.pixelSize: 15
        }

        ListView {
            id: chatList
            Layout.fillHeight: true
            model: ListModel {}

            delegate: Rectangle {
                width: parent.width
                height: 40
                color: model.bg

                Text {
                    text: model.text
                    color: model.color
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: model.alignRight ? parent.right : undefined
                    anchors.left: model.alignRight ? undefined : parent.left
                    anchors.margins: 10
                }
            }
        }

        RowLayout {
            spacing: 8

            TextField {
                id: inputField
                placeholderText: "Type a message..."
                enabled: client.connected
                Layout.fillWidth: true

                background: Rectangle {
                    color: "#AAAAAA"
                    radius: 8
                    border.color: inputField.activeFocus ? "#AAAAAA" : "#1E1E1E"
                }

                onAccepted: sendBtn.clicked()
            }

            Button {
                id: sendBtn
                text: "Send"
                enabled: client.connected

                background: Rectangle {
                    color: enabled ?"#AAAAAA" : "#1E1E1E"
                    radius: 8
                }

                contentItem: Text {
                    text: "Send"
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    client.sendMessage(inputField.text)
                    inputField.clear()
                }
            }
        }
    }

    Component.onCompleted: {
        client.connectToServer("127.0.0.1", 12345)
    }

    Connections {
        target: client

        function now() {
            return Qt.formatTime(new Date(), "hh:mm")
        }

        function onMessageReceived(msg) {
            chatList.model.append({
                text: "[" + now() + "] " + msg,
                color: "#d0d0f0",
                bg: "#16213e",
                alignRight: false
            })
            chatList.positionViewAtEnd()
        }

        function onMessageSent(msg) {
            chatList.model.append({
                text: "You [" + now() + "] " + msg,
                color: "#6495ed",
                bg: "#0f2a1e",
                alignCenter: true
            })
            chatList.positionViewAtEnd()
        }

        function onSystemMessage(msg) {
            chatList.model.append({
                text: msg,
                color: "#a0a0c0",
                bg: "#1a1a2e",
                alignRight: false
            })
            chatList.positionViewAtEnd()
        }
    }
}
