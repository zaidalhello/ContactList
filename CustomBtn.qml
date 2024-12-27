import QtQuick

Row{
    property string btnColor:"red"
    property string btnText:"Error"
    property var btnOnClick
    width: parent.width
    Rectangle{
        width: parent.width
        height: 40
        color: btnColor
        radius: 20
        Text{
            anchors.fill:parent
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignHCenter
            text: btnText
            font.pixelSize: 14
            font.bold:true
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked:btnOnClick()
            }
        }
    }
}
