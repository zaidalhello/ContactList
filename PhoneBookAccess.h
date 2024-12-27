#ifndef PHONEBOOKACCESS_H
#define PHONEBOOKACCESS_H

#include <QObject>
#include <QJniObject>

class PhoneBookAccess : public QObject
{
    Q_OBJECT
public:
    explicit PhoneBookAccess(QObject *parent = nullptr);
    ~PhoneBookAccess();
    Q_INVOKABLE void requestPermission();
    Q_INVOKABLE QStringList fetchContacts();

    Q_INVOKABLE void addContact(const QString &name, const QString &phone);
    Q_INVOKABLE QStringList editContact(const QString &contactId, const QString &newName, const QString &newPhone);

   Q_INVOKABLE void deleteContact(const QString &contactId);
    Q_INVOKABLE void requestWritePermission();
private:
    void getContactNames(); // Helper function to get contact names
};

#endif // PHONEBOOKACCESS_H
