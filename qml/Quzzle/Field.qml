// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "Field.js" as FieldJS

Rectangle {
    id: root;
    color: "white";
    width: 350;
    height: 350;
    z: 0;
    Image {
        id: border
        z: 2
        source: "../Images/border.png"
        anchors.fill: parent
    }

    Item {
        id: field;
        property variant outerLeftQuzzle
        property variant outerRightQuzzle
        property variant outerTopQuzzle
        property variant outerBottomQuzzle
        width: 300
        height: 300
        anchors.centerIn: parent
        MouseArea {
            id: mouseArea
            property variant clickedQuzzle;
            property variant dragDirection: Drag.XandYAxis;
            property int initialColumn: 0;
            property int initialRow: 0;
            property int dragThreshold: 10;
            property int xDiff: 0;
            property int yDiff: 0;

            anchors.fill: parent
            onPressed: {
                FieldJS.storeBoard()
                initialColumn = Math.floor(mouseX / FieldJS.quzzleSize)
                initialRow = Math.floor(mouseY / FieldJS.quzzleSize)
//                console.log("x: " + mouseX + " y: " + mouseY + "\ncolumn: " + initialColumn + " row: " + initialRow)
                field.outerLeftQuzzle.y = initialRow * FieldJS.quzzleSize;
                field.outerLeftQuzzle.type = FieldJS.board[FieldJS.index(FieldJS.maxColumn - 1, initialRow)].type;
                field.outerRightQuzzle.y = initialRow * FieldJS.quzzleSize;
                field.outerRightQuzzle.type = FieldJS.board[FieldJS.index(0, initialRow)].type;
                field.outerTopQuzzle.x = initialColumn * FieldJS.quzzleSize
                field.outerTopQuzzle.type = FieldJS.board[FieldJS.index(initialColumn, FieldJS.maxRow - 1)].type;
                field.outerBottomQuzzle.x = initialColumn * FieldJS.quzzleSize
                field.outerBottomQuzzle.type = FieldJS.board[FieldJS.index(initialColumn, 0)].type;
                clickedQuzzle = FieldJS.board[FieldJS.index(initialColumn, initialRow)];
                clickedQuzzle.clickedX = clickedQuzzle.x;
                clickedQuzzle.clickedY = clickedQuzzle.y;
                xDiff = mouseX - clickedQuzzle.x
                yDiff = mouseY - clickedQuzzle.y
                clickedQuzzle.state = "clicked"
            }
            onReleased: {
                if (clickedQuzzle != null)
                    clickedQuzzle.state = ""


                if (dragDirection == Drag.XAxis) {
                    for (var i = 0; i < FieldJS.maxColumn; ++i)
                        FieldJS.board[FieldJS.index(i, initialRow)].state = "";
                } else if (dragDirection == Drag.YAxis) {
                    for (var i = 0; i < FieldJS.maxRow; ++i)
                        FieldJS.board[FieldJS.index(initialColumn, i)].state = "";
                }
                dragDirection = Drag.XandYAxis
                initialColumn = -1
                initialRow = -1
            }
            onMousePositionChanged: {
                if (clickedQuzzle == null)
                    return;

                if (dragDirection == Drag.XandYAxis) {
                    if (Math.abs(clickedQuzzle.clickedX - clickedQuzzle.x) > dragThreshold) {
                        dragDirection = Drag.XAxis;
                        for (var i = 0; i < FieldJS.maxColumn; ++i) {
                            var daQuzzle = FieldJS.board[FieldJS.index(i, initialRow)];
                            if (daQuzzle != clickedQuzzle) {
                                clickedQuzzle.y = daQuzzle.y
                                daQuzzle.clickedX = daQuzzle.x;
                                daQuzzle.clickedY = daQuzzle.y
                                daQuzzle.state = "clicked";
                                daQuzzle.x = mouseX - i * FieldJS.quzzleSize + xDiff
                            }
                        }
                    } else if (Math.abs(clickedQuzzle.clickedY - clickedQuzzle.y) > dragThreshold) {
                        dragDirection = Drag.YAxis;
                        for (var i = 0; i < FieldJS.maxRow; ++i) {
                            var daQuzzle = FieldJS.board[FieldJS.index(initialColumn, i)];
                            if (daQuzzle != clickedQuzzle) {
                                clickedQuzzle.x = daQuzzle.x
                                daQuzzle.clickedX = daQuzzle.x;
                                daQuzzle.clickedY = daQuzzle.y
                                daQuzzle.state = "clicked";
                                daQuzzle.y = mouseY - i * FieldJS.quzzleSize + yDiff
                            }
                        }
                    } else {
                        clickedQuzzle.y = mouseY - yDiff
                        clickedQuzzle.x = mouseX - xDiff
                    }
                } else if (dragDirection == Drag.XAxis) {
                    for (var i = 0; i < FieldJS.maxColumn; ++i) {
                        var daQuzzle = FieldJS.board[FieldJS.index(i, initialRow)];
                        daQuzzle.x = (i - initialColumn) * FieldJS.quzzleSize + mouseX - xDiff
                    }
                } else if (dragDirection == Drag.YAxis) {
                    for (var i = 0; i < FieldJS.maxRow; ++i) {
                        var daQuzzle = FieldJS.board[FieldJS.index(initialColumn, i)];
                        daQuzzle.y = (i - initialRow) * FieldJS.quzzleSize + mouseY - yDiff
                    }
                }
            }
        }

        Component.onCompleted: {
            FieldJS.fill();
            var component = Qt.createComponent("Quzzle.qml");
            if (component.status != Component.Ready) {
                console.log("Could not create Component")
                return;
            }

            if (field.outerLeftQuzzle == null) {
                field.outerLeftQuzzle = component.createObject(field)
            }
            if (field.outerLeftQuzzle == null) {
                console.log("error creating left quzzle")
                console.log(component.errorString());
                return false;
            }
            field.outerLeftQuzzle.x = -FieldJS.quzzleSize
            field.outerLeftQuzzle.z = 1

            if (field.outerRightQuzzle == null)
                field.outerRightQuzzle = component.createObject(field)
            if (outerRightQuzzle == null) {
                console.log("error creating right quzzle")
                console.log(component.errorString());
                return false;
            }
            field.outerRightQuzzle.x = field.width
            field.outerRightQuzzle.z = 1

            if (field.outerTopQuzzle == null)
                field.outerTopQuzzle = component.createObject(field)
            if (outerTopQuzzle == null) {
                console.log("error creating top quzzle")
                console.log(component.errorString());
                return false;
            }
            field.outerTopQuzzle.y = -FieldJS.quzzleSize
            field.outerTopQuzzle.z = 1

            if (field.outerBottomQuzzle == null)
                field.outerBottomQuzzle = component.createObject(field)
            if (field.outerBottomQuzzle == null) {
                console.log("error creating right quzzle")
                console.log(component.errorString());
                return false;
            }
            field.outerBottomQuzzle.y = field.height
            field.outerBottomQuzzle.z = 1
        }


    }
}
