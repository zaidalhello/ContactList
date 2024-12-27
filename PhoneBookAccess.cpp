#include "PhoneBookAccess.h"
#include <QGuiApplication>
#include <QDebug>
#include <QJniObject>
#include <QJniEnvironment>

PhoneBookAccess::PhoneBookAccess(QObject *parent) : QObject(parent) {}

PhoneBookAccess::~PhoneBookAccess() {}

void PhoneBookAccess::requestPermission() {
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    activity.callMethod<void>("checkContactPermissions", "()V");
}
void PhoneBookAccess::requestWritePermission() {
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    activity.callMethod<void>("checkEditContactPermissions", "()V");
}

void PhoneBookAccess::addContact(const QString &name, const QString &phone) {
    // Get the activity context
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    // Call the Java method addContact, passing the name and phone as arguments
    activity.callMethod<void>("addContact", "(Ljava/lang/String;Ljava/lang/String;)V",
                              QJniObject::fromString(name).object(),
                              QJniObject::fromString(phone).object());
}

QStringList PhoneBookAccess::editContact(const QString &contactId, const QString &newName, const QString &newPhone) {

    qDebug() << "Editing contact with ID:" << contactId << ", New Name:" << newName << ", New Phone:" << newPhone;

    // Get the activity context
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    // Call the Java editContact method, passing the contact ID, new name, and phone number
    QJniObject javaList =   activity.callObjectMethod("editContact", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;",
                              QJniObject::fromString(contactId).object<jstring>(),
                              QJniObject::fromString(newName).object<jstring>(),
                              QJniObject::fromString(newPhone).object<jstring>());



    QStringList contactList;


    if (!javaList.isValid()) {
        qWarning() << "Failed to fetch contacts.";
        return contactList;
    }

    // Convert Java List to QStringList
    QJniEnvironment env;
    jobject listObject = javaList.object();
    jclass listClass = env->GetObjectClass(listObject);
    jmethodID sizeMethod = env->GetMethodID(listClass, "size", "()I");
    jmethodID getMethod = env->GetMethodID(listClass, "get", "(I)Ljava/lang/Object;");

    jint size = env->CallIntMethod(listObject, sizeMethod);
    for (jint i = 0; i < size; i++) {
        QJniObject javaString = QJniObject(env->CallObjectMethod(listObject, getMethod, i));

        contactList.append(javaString.toString());



    }

    return contactList;


}

void PhoneBookAccess::deleteContact(const QString &contactId) {
    // Get the activity context
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    // Call the Java deleteContact method, passing the contact ID
    activity.callMethod<void>("deleteContact", "(Ljava/lang/String;)V",
                              QJniObject::fromString(contactId).object<jstring>());
}



QStringList PhoneBookAccess::fetchContacts() {
    QStringList contactList;

    // Get the activity context
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    // Call the Java fetchContacts method
    QJniObject javaList = activity.callObjectMethod("fetchContacts", "()Ljava/util/List;");

    if (!javaList.isValid()) {
        qWarning() << "Failed to fetch contacts.";
        return contactList;
    }

    // Convert Java List to QStringList
    QJniEnvironment env;
    jobject listObject = javaList.object();
    jclass listClass = env->GetObjectClass(listObject);
    jmethodID sizeMethod = env->GetMethodID(listClass, "size", "()I");
    jmethodID getMethod = env->GetMethodID(listClass, "get", "(I)Ljava/lang/Object;");

    jint size = env->CallIntMethod(listObject, sizeMethod);
    for (jint i = 0; i < size; i++) {
        QJniObject javaString = QJniObject(env->CallObjectMethod(listObject, getMethod, i));

        contactList.append(javaString.toString());



    }

    return contactList;
}


