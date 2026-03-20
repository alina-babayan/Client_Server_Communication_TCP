#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QTcpSocket>

class Client : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY statusChanged)

public:
    explicit Client(QObject *parent = nullptr);

    QString status() const;
    bool connected() const;

signals:
    void messageReceived(QString msg);
    void messageSent(QString msg);
    void systemMessage(QString msg);
    void statusChanged();

public slots:
    void connectToServer(QString host, int port);
    void sendMessage(QString msg);

private:
    QTcpSocket socket;
    QString m_status;
};

#endif
