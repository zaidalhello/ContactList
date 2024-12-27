import QtQuick 2.15

ListView {
    id: addEditData
    visible: false
    width: parent.width
    height: parent.height
    model: addEditContacts

    delegate: Item {
        width: parent.width
        height: parent.height

        Rectangle {
            width: 50
            height: 80
            anchors.left: parent.left
            anchors.margins: 10
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: "<"
                font.pixelSize: 20
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addEditContacts.clear()
                    addEditData.visible = false
                    mainData.visible = true
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            text: isEditMode ? "Edit Contact" : "Add Contact"
            font.pixelSize: 30
            color: "Black"
            font.bold: true
        }

        Rectangle {
            width: parent.width * 0.9
            height: 35
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            color: "#d3d3d3"
            radius: 30
            clip: true
            Row {
                width: parent.width
                height: 35
                spacing:3
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    radius: 30
                    color:  "#d3d3d3"
                    width: 65
                    height: 35

                    Text {
                        anchors.fill:parent
                        anchors.leftMargin:  10
                        text: "Name:"
                        font.pixelSize: 20
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                Rectangle {
                    color:  "#d3d3d3"
                    width:  parent.width - 65
                    height: 35
                    clip: true
                    radius: 30
                    TextInput {
                        verticalAlignment: Text.AlignVCenter
                        id: name
                        anchors.fill:parent
                        text: model.name
                        font.pixelSize: 20
                        color: "#a8a8a8"
                        onTextChanged: {
                            if (model.name !== text) {
                                model.name = text;
                            }
                        }
                    }}
            }
        }

        Rectangle {
            id :phoneNumberId
            width: parent.width * 0.9
            height: 35
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 150
            color: "#d3d3d3"
            radius: 30
            clip: true
            Row {
                width: parent.width
                height: 35
                spacing: 30
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    radius: 30
                    color:  "#d3d3d3"
                    width: 120
                    height: 35
                    Text {
                        anchors.fill:parent
                        anchors.leftMargin:  10
                        width: parent.width
                        text: "Phone Number:"
                        font.pixelSize: 20
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                Rectangle {
                    radius: 30
                    color:   "#d3d3d3"
                    width:  parent.width - 150
                    height: 35
                    clip: true
                    TextInput {
                        inputMethodHints: Qt.ImhDigitsOnly
                        anchors.fill:parent
                        verticalAlignment: Text.AlignVCenter
                        id: phoneNum

                        text: model.phonenumber
                        font.pixelSize: 20
                        color: "#a8a8a8"
                        onTextChanged: {
                            if (model.phonenumber !== text) {
                                model.phonenumber = text;
                            }
                        }
                    }

                }
            }
        }

        CustomBtn {
            width: parent.width * 0.8
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            y:700
            btnColor: "green"
            btnText: isEditMode ? "Save" : "Add"
            btnOnClick: () => {
                            if (isEditMode) {
                                  var contactsList =   PhoneBook.editContact(model.contactId, model.name, model.phonenumber)
                                for (var x = 0; x < contactsList.length; x++) {
                                    var parts = contactsList[x].toString().split(",")
                                    var phoneCleanString = parts[2].replace(/Phone: /, "");
                                    var nameCleanString = parts[1].replace(/Name: /, "");
                                    var firstLetter = nameCleanString.charAt(1).toUpperCase()
                                    var contactIdCleanString = parts[0].replace(/ID: /, "");
                                    contacts.set( model.contactIndex,   {firstLetter: firstLetter, name: nameCleanString, phonenumber: phoneCleanString,contactId:contactIdCleanString})
                                }


                            } else {



                             PhoneBook.addContact(model.name, model.phonenumber)
                                 fillMainContactList()

                            }
                            addEditContacts.clear()

                            addEditData.visible = false
                            mainData.visible = true
                        }
        }

        CustomBtn {
            width: parent.width * 0.8
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            y:650
            anchors.bottomMargin: 10
            visible: isEditMode
            btnColor: "red"
            btnText: "Delete"
            btnOnClick: () => {
                            PhoneBook.deleteContact(model.contactId)
                            addEditContacts.clear()
                            fillMainContactList()
                            addEditData.visible = false
                            mainData.visible = true
                        }
        }
    }
}
