#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QList>
#include <QMap>

class Server : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)

public:
    explicit Server(QObject *parent = nullptr);

    QString status() const;

signals:
    void clientConnected(QString addr);
    void clientDisconnected(QString addr);
    void messageReceived(QString msg);
    void statusChanged();

public slots:
    void start();

private:
    void updateStatus();

    QTcpServer server;
    QList<QTcpSocket*> clients;
    QMap<QTcpSocket*, QString> clientMap;

    QString m_status;
};

#endif
