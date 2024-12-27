import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Phone Book")
    color: "#f5f5f5"

    Component.onCompleted: {
        fillMainContactList()
    }
    function fillMainContactList(){
        PhoneBook.requestPermission()
        PhoneBook.requestWritePermission()
        contacts.clear()
        var contactsList = PhoneBook.fetchContacts()
        for (var x = 0; x < contactsList.length; x++) {
            var parts = contactsList[x].toString().split(",")
            var phoneCleanString = parts[2].replace(/Phone: /, "");
            var nameCleanString = parts[1].replace(/Name: /, "");
            var firstLetter = nameCleanString.charAt(1).toUpperCase()
            var contactIdCleanString = parts[0].replace(/ID: /, "");
            contacts.append({firstLetter: firstLetter, name: nameCleanString, phonenumber: phoneCleanString,contactId:contactIdCleanString})
        }
        console.log(contactsList.length)
    }
    property ListModel contacts: ListModel {}
    property ListModel addEditContacts: ListModel {}
    property bool isEditMode: true
    property string editName: ""
    property string editPhone: ""
    property string mainContactId: ""
    ListView {
        id:mainData
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        model: contacts
        clip: true
        header: MainListHeader {}
        delegate: MainListDelegate {}
    }
    MyAddEditListData {id: addEditData}
}
