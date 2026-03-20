import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 600
    height: 600
    title: "Chat Server"

    color: "#1E1E1E"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 6

        Text {
            text: "CHAT SERVER"
            color: "#AAAAAA"
            font.pixelSize: 25
            font.bold: true
        }

        Text {
            text: server.status
            color: "#AAAAAA"
            font.pixelSize: 15
        }

        Text {
            text: "CONNECTED CLIENTS"
            color: "#AAAAAA"
            font.pixelSize: 15
            font.bold: true
        }

        ListView {
            id: clientList
            height: 120
            model: ListModel {}

            delegate: Rectangle {
                width: parent.width
                height: 30
                color: "#16213e"

                Text {
                    text: model.text
                    color: "#4ecca3"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Text {
            text: "MESSAGE LOG"
            color: "#AAAAAA"
            font.pixelSize: 15
            font.bold: true
        }

        ListView {
            id: logList
            Layout.fillHeight: true
            model: ListModel {}

            delegate: Rectangle {
                width: parent.width
                height: 28
                color: "#16213e"

                Text {
                    text: model.text
                    color: "#AAAAAA"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Connections {
        target: server

        function onClientConnected(addr) {
            clientList.model.append({ text: addr })
            logList.model.append({ text: "Connected: " + addr })
        }

        function onClientDisconnected(addr) {
            logList.model.append({ text: "Disconnected: " + addr })
        }

        function onMessageReceived(msg) {
            logList.model.append({ text: msg })
        }
    }
}
