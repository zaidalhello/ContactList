#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QJniObject>
#include <QDebug>
#include "PhoneBookAccess.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    PhoneBookAccess phoneBookAccess;

    engine.rootContext()->setContextProperty("PhoneBook", &phoneBookAccess);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("untitled7", "Main");

    return app.exec();
}
