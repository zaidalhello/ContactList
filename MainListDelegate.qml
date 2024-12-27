import QtQuick

Item {
    
    width: mainData.width
    height: 80
    anchors.margins: 25
    Rectangle {
        height: 50
        width: 60
        color:"#f5f5f5"
        Rectangle {
            anchors.leftMargin:  25
            anchors.right: parent.right
            id:letterContanerID
            height: 50
            width: 50
            color: "#3a7bd5"
            radius: 25
            border.color: "#3a6073"
            border.width: 2
            Text {
                anchors.centerIn: parent
                text: model.firstLetter
                font.bold: true
                font.pixelSize: 30
                color: "white"
            }
        }
    }
    Column {
        anchors.margins: 25
        anchors.right: parent.right
        spacing: 8
        width: parent.width-90
        Text {
            text: model.name
            font.bold: true
            font.pixelSize: 18
            color: "#333"
            width: parent.width - 80
        }
        Text {
            text: model.phonenumber
            font.pixelSize: 14
            color: "#555"
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            addEditContacts.append({firstLetter: model.firstLetter, name: model.name, phonenumber: model.phonenumber,contactId:model.contactId,contactIndex:index})

            mainContactId=model.contactId;
            editName= model.name
            editPhone= model.phonenumber
            console.log("model.phonenumber->"+mainContactId)
            addEditData.visible=true
            mainData.visible=false
            isEditMode=true
        }
    }

}
