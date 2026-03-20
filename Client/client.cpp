#include "client.h"
#include <QDateTime>

Client::Client(QObject *parent) : QObject(parent) {

    connect(&socket, &QTcpSocket::connected, this, [=]() {
        m_status = "Connected to server";
        emit statusChanged();
        emit systemMessage("Connected to server");
    });

    connect(&socket, &QTcpSocket::readyRead, this, [=]() {
        QString msg = QString::fromUtf8(socket.readAll()).trimmed();
        emit messageReceived(msg);
    });

    connect(&socket, &QTcpSocket::disconnected, this, [=]() {
        m_status = "Disconnected from server";
        emit statusChanged();
        emit systemMessage("Disconnected from server");
    });

    connect(&socket, &QAbstractSocket::errorOccurred, this, [=]() {
        m_status = "Error: " + socket.errorString();
        emit statusChanged();
    });
}

QString Client::status() const {
    return m_status;
}

bool Client::connected() const {
    return socket.state() == QAbstractSocket::ConnectedState;
}

void Client::connectToServer(QString host, int port) {
    m_status = "Connecting...";
    emit statusChanged();
    socket.connectToHost(host, port);
}

void Client::sendMessage(QString msg) {
    if (!connected() || msg.trimmed().isEmpty())
        return;

    socket.write((msg + "\n").toUtf8());
    socket.flush();

    emit messageSent(msg);
}
