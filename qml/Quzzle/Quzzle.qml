// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    property int type;
    property int attachedSameType: 0
    property int clickedX
    property int clickedY
    id: quzzle
    source: getImage();
    width: 50
    height: 50

    function getImage() {
        var returnString = "../Images/Quzzle_";
        switch (type)
        {
        case 0:
            returnString = returnString.concat("blue.png")
            break;
        case 1:
            returnString = returnString.concat("gray.png")
            break;
        case 2:
            returnString = returnString.concat("green.png")
            break;
        case 3:
            returnString = returnString.concat("orange.png")
            break;
        case 4:
            returnString = returnString.concat("red.png")
            break;
        case 5:
            returnString = returnString.concat("white.png")
            break;
        case 6:
            returnString = returnString.concat("yellow.png")
            break;
        }
        return returnString;
    }

    Image {
        id: eyes
        source: "../Images/Eyes_open.png"
        anchors.fill: parent
    }

    SequentialAnimation on x{
        id: wiggle
        running: false
        loops: Animation.Infinite
        PropertyAnimation { to: x - 2; duration: 50 }
        PropertyAnimation { to: x + 2; duration: 50 }
    }

    states: [
        State {
            name: ""
            PropertyChanges { target: quzzle; x: clickedX; y: clickedY }
        },
        State {
            name: "clicked"
            PropertyChanges { target: eyes; source: "../Images/Eyes_closed.png" }
        },
        State {
            name: "readyToBurst"
            PropertyChanges { target: wiggle; running: true }
            PropertyChanges { target: eyes; source: "../Images/Eyes_closed.png" }
        }
    ]

    transitions: [
    Transition {
            to: ""
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutElastic; duration: 500}
        }
    ]

    //SequentialAnimation {
    //    id: animation
    //    running: mouseArea.pressed
    //    loops: Animation.Infinite
    //    PropertyAnimation { target: quzzle; property: "x"; to: x-3; duration: 50}
    //    PropertyAnimation { target: quzzle; property: "x"; to: x+3; duration: 25}
    //   PropertyAnimation { target: quzzle; property: "x"; to: x; duration: 25}
    //}
}
