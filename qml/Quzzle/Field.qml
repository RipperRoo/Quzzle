// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "Field.js" as FieldJS

Rectangle {
    color: "white";
    width: 350;
    height: 350;
    z: 0;
    Component.onCompleted: fill();
    Image {
        id: border
        z: 2
        source: "../Images/border.png"
        anchors.fill: parent
    }

    function fill() {
        FieldJS.fill()
    }
}
