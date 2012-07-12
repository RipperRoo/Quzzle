
var quzzleSize = 50;
var maxColumn = 6;
var maxRow = 6;
var maxIndex = maxColumn * maxRow;
var board = new Array(maxIndex)
var component;
var attempts = 0;

function index(column, row) {
    return column + row * maxColumn;
}

function fill() {
    for (var i = 0; i < maxIndex; ++i) {
        if (board[i] != null)
            board[i].destroy();
    }

    for (var column = 0; column < maxColumn; ++column) {
        for (var row = 0; row < maxRow; ++row) {
            board[index(column, row)] = null;
            createQuzzle(column, row);
            if (attempts == 50) {
                break;
            }
        }
    }
    if (attempts == 50)
        fill();
}

function createQuzzle(column, row) {
    if (component == null)
        component = Qt.createComponent("Quzzle.qml");

    if (component.status == Component.Ready) {
        var dynamicObject = component.createObject(field)
        if (dynamicObject == null) {
            console.log("error creating quzzle")
            console.log(component.errorString());
            return false;
        }
        var recreate = true;
        while (recreate && attempts < 50) {
            dynamicObject.type = Math.floor(Math.random() * 7)
            dynamicObject.attachedSameType = 0;
            var otherItem;
            if (column > 0) {
                otherItem = board[index(column - 1, row)];
                if (otherItem != null && otherItem.type == dynamicObject.type) {
                    dynamicObject.attachedSameType += otherItem.attachedSameType + 1;
                    otherItem.attachedSameType +=1;
                }
            }
            if (column < maxColumn - 1) {
                otherItem = board[index(column + 1, row)];
                if (otherItem != null && otherItem.type == dynamicObject.type) {
                    dynamicObject.attachedSameType += otherItem.attachedSameType + 1;
                    otherItem.attachedSameType +=1;
                }
            }
            if (row > 0) {
                otherItem = board[index(column, row - 1)];
                if (otherItem != null && otherItem.type == dynamicObject.type) {
                    dynamicObject.attachedSameType += otherItem.attachedSameType + 1;
                    otherItem.attachedSameType +=1;
                }
            }
            if (row < maxRow - 1) {
                otherItem = board[index(column, row + 1)];
                if (otherItem != null && otherItem.type == dynamicObject.type) {
                    dynamicObject.attachedSameType += otherItem.attachedSameType + 1;
                    otherItem.attachedSameType +=1;
                }
            }
            if (dynamicObject.attachedSameType < 2)
                recreate = false
            ++attempts;
        }
        if (attempts == 50)
            return false;

        dynamicObject.x = 25 + column * quzzleSize;
        dynamicObject.y = 25 + row * quzzleSize;
        dynamicObject.z = 1
        dynamicObject.width = quzzleSize;
        dynamicObject.height = quzzleSize;
        board[index(column, row)] = dynamicObject;
    } else  {
        console.log("Could not create Component")
        console.log(component.errorString())
        return false
    }
    return true;
}
