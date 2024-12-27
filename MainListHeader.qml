import QtQuick
Item {
    width: parent.width
    height: 100
    Rectangle{
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#638B95" } // Start color
            GradientStop { position: 1.0; color: "#1F7C93" } // End color
        }
        width: parent.width/2
        height: 80
        Text{
            anchors.margins: 30
            anchors.fill:parent
            horizontalAlignment: TextInput.AlignHCenter
            text: "Contect APP"
            font.pixelSize: 30
            font.bold:true
            color: "white"
        }
    }
    Rectangle{
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#638B95" } // Start color
            GradientStop { position: 1.0; color: "#1F7C93" }
        }
        width: parent.width/2
        height: 80
        anchors.right: parent.right
        Text{
            anchors.topMargin:  40
            anchors.fill:parent
            anchors.leftMargin:  40
            horizontalAlignment: TextInput.AlignHCenter
            text: "Add Contact"
            font.pixelSize: 15
            font.bold:true
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    addEditContacts.append({firstLetter: "", name: "", phonenumber: "",contactId:""})
                    mainContactId="";
                    editName= ""
                    editPhone= ""
                    addEditData.visible=true
                    mainData.visible=false
                    isEditMode=false
                }
            }
        }
    }
}

