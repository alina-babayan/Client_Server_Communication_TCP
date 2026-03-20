QT += core network
QT += core gui widgets network
QT += qml
CONFIG += console c++11
CONFIG -= app_bundle
SOURCES += main.cpp \
    client.cpp
HEADERS += \
    client.h

RESOURCES += \
    qrc.qrc
