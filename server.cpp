#include "server.h"
#include <QHostAddress>

Server::Server(QObject *parent)
    : QObject(parent), m_status("Stopped")
{
    connect(&server, &QTcpServer::newConnection, this, [this]() {
        while (server.hasPendingConnections()) {
            QTcpSocket *client = server.nextPendingConnection();
            clients.append(client);

            QString addr = client->peerAddress().toString();
            clientMap[client] = addr;

            emit clientConnected(addr);

            connect(client, &QTcpSocket::readyRead, this, [this, client]() {
                QByteArray data = client->readAll();
                QString msg = QString::fromUtf8(data);
                emit messageReceived(msg);
            });

            connect(client, &QTcpSocket::disconnected, this, [this, client]() {
                QString addr = clientMap.value(client);

                clients.removeAll(client);
                clientMap.remove(client);

                emit clientDisconnected(addr);

                client->deleteLater();
                updateStatus();
            });

            updateStatus();
        }
    });
}

QString Server::status() const {
    return m_status;
}

void Server::start() {
    if (!server.listen(QHostAddress::Any, 1234)) {
        m_status = "Error: " + server.errorString();
    } else {
        m_status = "Listening on port 1234";
    }
    emit statusChanged();
}

void Server::updateStatus() {
    m_status = QString("Clients connected: %1").arg(clients.size());
    emit statusChanged();
}
