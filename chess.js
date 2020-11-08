let chessBoardMap = {};
let chessBoardList = [];

let rubikDirections = ["up", "right", "down", "left", "clockwise", "anticlockwise"];
let rubikDirectionsCounter = 0;
let board = [["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"],

    ["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"],

    ["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"],

    ["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"]];

class ChessBoard {
    chessFields = [];
    colorToMove = "white";

    constructor(chessFields) {
        this.chessFields = chessFields;
    }
}

class ChessField {

    x;
    y;
    xyPosition;
    chessPosition;
    color;
    figure;
    rubikField;
    marker;

    constructor(x, y, xyPosition, chessPosition, color, figure, rubikField, marker) {
        this.id = `c_${x}${y}`;
        this.x = x;
        this.y = y;
        this.xyPosition = xyPosition;
        this.chessPosition = chessPosition;
        this.color = color;
        this.figure = figure;
        this.rubikField = rubikField;
        this.marker = marker;
    }

    toString() {
        return `xy:${this.xyPosition} color:${this.color} marker:${this.marker} 
                 |----figure:${this.rubikField} 
                 |----rubikField:${this.rubikField.toString()} `;

    }
}

class RubikField {
    x;
    y;
    special;
    color;

    constructor(x, y, special) {
        this.x = x;
        this.y = y;
        this.special = special;
    }

    toString() {
        return `xy:${this.x}${this.y} special:${this.special}`;
    }
}

class Figure {
    className;
    type;
    color;
    value = 0;
    calculated = false;
    hasMoved = false;

    constructor(type, color) {
        this.className = `${type}_${color}`;
        this.type = type;
        this.color = color;
        let multi = 1;
        if (color === "black") {
            multi = multi * -1;
        }
        if (type === "rock") {
            this.value = multi * 50;
        } else if (type === "knight") {
            this.value = multi * 30;
        } else if (type === "bishop") {
            this.value = multi * 30;
        } else if (type === "queen") {
            this.value = multi * 90;
        } else if (type === "king") {
            this.value = multi * 900;
        } else if (type === "pawn") {
            this.value = multi * 10;
        }
    }

    toString() {
        return `type:${this.type} color:${this.color}`;
    }
}

function calcPos(x, y) {
    return (y * 8) + (x + 1) - 1;
}

function getChessField(chessBoard, pos) {
    return chessBoard.chessFields[pos];
}

function getRockMoves(rock, x, y) {
    let possibleMoves = [];
    let possibleAttacks = [];

    for (let i = y + 1; i < 8; i++) {//below rock

        let chessField = getChessField(chessBoard, calcPos(x, i));
        let chessFieldFigure = chessField.figure;

        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }
    for (let i = y - 1; i >= 0; i--) {//above rock

        let chessField = getChessField(chessBoard, calcPos(x, i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    for (let i = x - 1; i >= 0; i--) {//left of rock

        let chessField = getChessField(chessBoard, calcPos(i, y));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    for (let i = x + 1; i < 8; i++) {//left of rock

        let chessField = getChessField(chessBoard, calcPos(i, y));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }
    return [possibleMoves, possibleAttacks];

}

function getBishopMoves(bishop, x, y) {
    let possibleMoves = [];
    let possibleAttacks = [];

    let distance = 0;
    let top = y;
    let bottom = 7 - y;
    let left = x;
    let right = 7 - x;

    //below right bishop
    if (right <= bottom) {
        distance = right;
    } else {
        distance = bottom;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x + i, y + i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== bishop.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    //below left bishop
    if (left <= bottom) {
        distance = left;
    } else {
        distance = bottom;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x - i, y + i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== bishop.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }


    //top left bishop
    if (left <= top) {
        distance = left;
    } else {
        distance = top;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x - i, y - i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== bishop.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    //top right bishop
    if (right <= top) {
        distance = right;
    } else {
        distance = top;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x + i, y - i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== bishop.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }


    return [possibleMoves, possibleAttacks];

}


function getQueenMoves(queen, x, y) {
    let possibleMoves = [];
    let possibleAttacks = [];

    //bishop
    let distance = 0;
    let top = y;
    let bottom = 7 - y;
    let left = x;
    let right = 7 - x;

    //below right queen
    if (right <= bottom) {
        distance = right;
    } else {
        distance = bottom;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x + i, y + i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    //below left queen
    if (left <= bottom) {
        distance = left;
    } else {
        distance = bottom;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x - i, y + i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }


    //top left queen
    if (left <= top) {
        distance = left;
    } else {
        distance = top;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x - i, y - i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    //top right queen
    if (right <= top) {
        distance = right;
    } else {
        distance = top;
    }

    for (let i = 1; i <= distance; i++) {
        let chessField = getChessField(chessBoard, calcPos(x + i, y - i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }
        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

//ROCK
    for (let i = y + 1; i < 8; i++) {//below queen

        let chessField = getChessField(chessBoard, calcPos(x, i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }
    for (let i = y - 1; i >= 0; i--) {//above queen

        let chessField = getChessField(chessBoard, calcPos(x, i));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    for (let i = x - 1; i >= 0; i--) {//left of queen

        let chessField = getChessField(chessBoard, calcPos(i, y));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    for (let i = x + 1; i < 8; i++) {//left of queen

        let chessField = getChessField(chessBoard, calcPos(i, y));
        let chessFieldFigure = chessField.figure;
        let isEmpty = false;

        if (chessFieldFigure === undefined || chessFieldFigure === null) {
            isEmpty = true;
        }

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== queen.color;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }
    return [possibleMoves, possibleAttacks];

}

function getKingMoves(king, x, y) {
    // y = switchY(y);
    let possibleMoves = [];
    let possibleAttacks = [];
    let kingMoves = [[x, y - 1], [x + 1, y - 1], [x + 1, y], [x + 1, y + 1], [x, y + 1], [x - 1, y + 1], [x - 1, y], [x - 1, y - 1]];
// debugger;

    kingMoves.forEach((position) => {
        if ((position[0] >= 0 && position[0] < 8) && (position[1] >= 0 && position[1] < 8)) {

            let chessField = getChessField(chessBoard, calcPos(position[0], position[1]));
            let chessFieldFigure = chessField.figure;
            let isEmpty = false;

            if (chessFieldFigure === undefined || chessFieldFigure === null) {
                isEmpty = true;
            }

            if (isEmpty) {
                possibleMoves.push(chessField);
            } else {
                let isEnemy = chessFieldFigure.color !== king.color;
                if (isEnemy) {
                    possibleAttacks.push(chessField);
                }
            }
        }
    });
    return [possibleMoves, possibleAttacks];

}

function getKnightMoves(knight, x, y) {
    // y = switchY(y);
    let possibleMoves = [];
    let possibleAttacks = [];
    let knightMoves = [[x - 1, y - 2], [x - 2, y - 1], [x - 2, y + 1], [x - 1, y + 2], [x + 1, y + 2], [x + 2, y + 1], [x + 2, y - 1], [x + 1, y - 2]];
// debugger;

    knightMoves.forEach((position) => {
        if ((position[0] >= 0 && position[0] < 8) && (position[1] >= 0 && position[1] < 8)) {
            let chessField = getChessField(chessBoard, calcPos(position[0], position[1]));
            let chessFieldFigure = chessField.figure;
            let isEmpty = false;

            if (chessFieldFigure === undefined || chessFieldFigure === null) {
                isEmpty = true;
            }

            if (isEmpty) {
                possibleMoves.push(chessField);
            } else {
                let isEnemy = chessFieldFigure.color !== knight.color;
                if (isEnemy) {
                    possibleAttacks.push(chessField);
                }
            }
        }

    });
    return [possibleMoves, possibleAttacks];

}


function getPawnMoves(pawn, x, y) {
    // y = switchY(y);
    let possibleMoves = [];
    let possibleAttacks = [];

// debugger;
//move one field
    let chessField;

    if (pawn.color === "white") {
        chessField = getChessField(chessBoard, calcPos(x, y - 1));
    } else {
        chessField = getChessField(chessBoard, calcPos(x, y + 1));
    }

    let chessFieldFigure = chessField.figure;
    let isEmpty = false;

    if (chessFieldFigure === undefined || chessFieldFigure === null) {
        isEmpty = true;
    }

    if (isEmpty) {
        possibleMoves.push(chessField);
    }
//move two field

    if (!pawn.hasMoved) {
        let chessField1;
        let chessField2;

        if (pawn.color === "white") {
            chessField1 = getChessField(chessBoard, calcPos(x, y - 1));
            chessField2 = getChessField(chessBoard, calcPos(x, y - 2));
        } else {
            chessField1 = getChessField(chessBoard, calcPos(x, y + 1));
            chessField2 = getChessField(chessBoard, calcPos(x, y + 2));
        }
        let chessFieldFigure1 = chessField1.figure;
        let chessFieldFigure2 = chessField2.figure;
        let isEmpty1 = chessFieldFigure1 === undefined;
        let isEmpty2 = chessFieldFigure2 === undefined;
        if (isEmpty1 && isEmpty2) {
            possibleMoves.push(chessField2);
        }
    }
//attack right


    if (pawn.color === "white") {
        chessField = getChessField(chessBoard, calcPos(x + 1, y - 1));
    } else {
        chessField = getChessField(chessBoard, calcPos(x + 1, y + 1));
    }

    chessFieldFigure = chessField.figure;
    if (chessFieldFigure === undefined || chessFieldFigure === null) {
        isEmpty = true;
    }

    if (!isEmpty) {
        let isEnemy = chessFieldFigure.color !== pawn.color;
        if (isEnemy) {
            possibleAttacks.push(chessField);
        }
    }
//attack left


    if (pawn.color === "white") {
        chessField = getChessField(chessBoard, calcPos(x - 1, y - 1));
    } else {
        chessField = getChessField(chessBoard, calcPos(x - 1, y + 1));
    }

    chessFieldFigure = chessField.figure;
    if (chessFieldFigure === undefined || chessFieldFigure === null) {
        isEmpty = true;
    }

    if (!isEmpty) {
        let isEnemy = chessFieldFigure.color !== pawn.color;
        if (isEnemy) {
            possibleAttacks.push(chessField);
        }
    }
    return [possibleMoves, possibleAttacks];
}

let whiteFiguresCode = {"king": "&#x2654;", "queen": "&#x2655;", "rock": "&#x2656;", "bishop": "&#x2657;", "knight": "&#x2658;", "pawn": "&#x2659;"};
let blackFiguresCode = {"king": "&#x265A;", "queen": "&#x265B;", "rock": "&#x265C;", "bishop": "&#x265D;", "knight": "&#x265E;", "pawn": "&#x265F;"};

let topFigures = ["rock", "knight", "bishop", "queen", "king", "bishop", "knight", "rock",
    "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn"];

let bottomFigures = ["pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn",
    "rock", "knight", "bishop", "queen", "king", "bishop", "knight", "rock"];
let chessBoard = new ChessBoard([]);

function switchY(y) {

    if (y === 0) {
        y = 7;
    } else if (y === 1) {
        y = 6;
    } else if (y === 2) {
        y = 5;
    } else if (y === 3) {
        y = 4;
    } else if (y === 4) {
        y = 3;
    } else if (y === 5) {
        y = 2;
    } else if (y === 6) {
        y = 1;
    } else if (y === 7) {
        y = 0;
    }
    return y;
}

function createBoard() {

    for (let y = 0; y < 8; y++) {//row
        let letter;
        if (y === 0) {
            letter = "a";
        } else if (y === 1) {
            letter = "b";
        } else if (y === 2) {
            letter = "c";
        } else if (y === 3) {
            letter = "d";
        } else if (y === 4) {
            letter = "e";
        } else if (y === 5) {
            letter = "f";
        } else if (y === 6) {
            letter = "g";
        } else if (y === 7) {
            letter = "h";
        }
        // for (let x = 0; x < 8; x++) {//column
        for (let x = 0; x < 8; x++) {//column
            let special = "";
            let rubikField = new RubikField();
            if (y === 0 || y === 1) {//top two rows
                special = "none";
            } else if (y === 6 || y === 7) {//bottom two rows
                special = "none";
            } else {
                special = rubikDirections[rubikDirectionsCounter];
                rubikField.x = x;
                rubikField.y = y;
                rubikField.special = special;
                if (rubikDirectionsCounter === 5) {
                    rubikDirectionsCounter = 0;
                } else {
                    rubikDirectionsCounter++;
                }
            }
            let figure;
            if (calcPos(x, y) < 16) {
                figure = new Figure(topFigures.splice(0, 1)[0], "black");
            }
            if (calcPos(x, y) >= 48) {
                figure = new Figure(bottomFigures.splice(0, 1)[0], "white");
            }
            let chessField = new ChessField(x, y, [x, y], `${x} ${letter}`, board[y][x], figure, rubikField, null);

            chessBoard.fromChessField = "";
            chessBoard.toChessField = "";
            chessBoardMap[`${x} ${letter}`] = chessField;
            chessBoardList.push(chessField);
            chessBoard.chessFields.push(chessField);


        }
    }
}

function createBoardDiv() {
    let boardDiv = document.createElement("div");
    boardDiv.id = "chess_board";
    boardDiv.style.width = "400px";
    boardDiv.style.height = "400px";
    return boardDiv

}

function addMove(chessField, marker) {
    chessField.marker = marker;

}

function makeMove(fromChessField, toChessField) {
    let figureCopy = {...fromChessField.figure};
    figureCopy.hasMoved = true;
    toChessField.figure = figureCopy;
    fromChessField.figure = undefined;
    chessBoard.colorToMove = chessBoard.colorToMove === "white" ? "black" : "white";
    removeMoves();
    let rubikFieldDiv = document.querySelector(`#${toChessField.id} .rubik_field`);//rubikField.click();
    if (rubikFieldDiv !== null) {
        rubikFieldDiv.click();
    }//rubikField.click();
    let rubikField = toChessField.rubikField;
    let x = toChessField.x;
    let y = toChessField.y;
    update();
    // rubikFieldDiv.onclick = function () {
    if (rubikField.special === "up") {
        setTimeout(function () {
            moveUp(x);
            update();
        }, 500);
    } else if (rubikField.special === "right") {
        setTimeout(function () {
            moveRight(y);
            update();
        }, 500);
    } else if (rubikField.special === "down") {
        setTimeout(function () {
            moveDown(x);
            update();
        }, 500);
    } else if (rubikField.special === "left") {
        setTimeout(function () {
            moveLeft(y);
            update();
        }, 500);
    } else if (rubikField.special === "clockwise") {
        setTimeout(function () {
            moveClockwise(x, y);
            update();
        }, 500);
    } else if (rubikField.special === "anticlockwise") {
        setTimeout(function () {
            moveAntiClockwise(x, y);
            update();
        }, 500);
    }

    // };
    // update();

}

function removeMoves() {
    chessBoard.chessFields.forEach(chessField => {
        chessField.marker = null;
    })

}


function createFigureDiv(figure, x, y) {
    let figureDiv = document.createElement("div");
    figureDiv.id = `figure_${figure.className}`;
    figureDiv.className = `figure f_${figure.color}_${figure.type}`;

//    figureDiv.style.background = `${figure.color}`;
    if (figure.color === "white") {
        figureDiv.innerHTML = `${whiteFiguresCode[figure.type]}`;
        figureDiv.style.textShadow = `1px 1px 1px white, 1px -1px 3px white, -1px 1px 1px white, -1px -1px 1px white`;

    } else {
        figureDiv.innerHTML = `${blackFiguresCode[figure.type]}`;
        figureDiv.style.textShadow = `1px 1px 1px white, 1px -1px 3px white, -1px 1px 1px white, -1px -1px 1px white`;

    }
    figureDiv.onclick = function () {
        // document.querySelector("#fromChessFieldDiv").setAttribute("value", calcPos(figure.x, figure.y));
        if (figure.color === chessBoard.colorToMove) {
            chessBoard.fromChessField = calcPos(x, y);
            // chessBoard.toChessField = "";

            removeMoves();
            let moveList = [];
            if (figure.type === "rock") {
                moveList = getRockMoves(figure, x, y);
            } else if (figure.type === "knight") {
                moveList = getKnightMoves(figure, x, y);
            } else if (figure.type === "bishop") {
                moveList = getBishopMoves(figure, x, y);
            } else if (figure.type === "queen") {
                moveList = getQueenMoves(figure, x, y);
            } else if (figure.type === "king") {
                moveList = getKingMoves(figure, x, y);
            } else if (figure.type === "pawn") {
                moveList = getPawnMoves(figure, x, y);
            }
            if (moveList.length > 0) {
                moveList[0].forEach((element) => {
                    addMove(element, "#00ff1461");
                    console.log(`moveList:${element}`)
                });
                moveList[1].forEach((element) => {
                    addMove(element, "#ff001842");
                    console.log(`attackList:${element}`)
                });
                update();
            }

        }

    };
    return figureDiv;

}


function createRubikFieldDiv(rubikField, x, y) {
    let rubikFieldDiv = document.createElement("div");
    rubikFieldDiv.style.width = "25px";
    rubikFieldDiv.style.height = "25px";

    // debugger;
    if (rubikField.x !== undefined) {
        // rubikFieldDiv.id = `r_${rubikField.x}${rubikField.y}`;

        rubikFieldDiv.className = `rubik_field ${rubikField.special}`;
        //rubikFieldDiv.style.float = "left";
        rubikFieldDiv.style.textAlign = "center";
        rubikFieldDiv.style.boxSizing = "border-box";
        rubikFieldDiv.style.position = "absolute";
        rubikFieldDiv.style.top = "12px";
        rubikFieldDiv.style.left = "12px";

        let arrow = "";
        if (rubikField.special === "up") {
            arrow = "&uarr;";
        } else if (rubikField.special === "right") {
            arrow = "&rarr;";
        } else if (rubikField.special === "down") {
            arrow = "&darr;";
        } else if (rubikField.special === "left") {
            arrow = "&larr;";
        } else if (rubikField.special === "clockwise") {
            arrow = "&#x21BB;";
        } else if (rubikField.special === "anticlockwise") {
            arrow = "&#x21BA;";
        }
        rubikFieldDiv.innerHTML = arrow;

    }
    return rubikFieldDiv;

}


function createChessFieldDiv(chessField) {


    let chessFieldDiv = document.createElement("div");
    chessFieldDiv.style.width = "50px";
    chessFieldDiv.style.height = "50px";
    chessFieldDiv.style.padding = "10px";
    // debugger;

    chessFieldDiv.id = `c_${chessField.x}${chessField.y}`;
    let chessFieldColor = chessField.color === "w" ? "white" : "black";
    // let cellColor = cell == "w" ? "white" : "black";


    chessFieldDiv.style.background = chessFieldColor;
    chessFieldDiv.className = `chess_field ${chessFieldColor}`;
    chessFieldDiv.x = chessField.x;
    chessFieldDiv.y = chessField.y;
    chessFieldDiv.style.float = "left";
    // chessFieldDiv.style.textAlign = "center";
    // chessFieldDiv.style.paddingTop = "3px";
    chessFieldDiv.style.boxSizing = "border-box";

    if (chessField.marker !== null) {
        let moveMarkerDiv = document.createElement("div");
        moveMarkerDiv.style.width = "50px";
        moveMarkerDiv.style.height = "50px";
        moveMarkerDiv.style.position = "absolute";
        moveMarkerDiv.style.zIndex = "99999";
        moveMarkerDiv.style.top = "0px";
        moveMarkerDiv.style.left = "0px";

        moveMarkerDiv.style.background = `${chessField.marker}`;
        //moveMarkerDiv.style.border = `2px solid black`;

        moveMarkerDiv.onclick = function () {

            let xyChessField = this.parentElement.id.split("_")[1];
            let x = parseInt(xyChessField[0]);
            let y = parseInt(xyChessField[1]);
            let toChessFieldPosition = calcPos(x, y);

            let fromChessFieldPosition = chessBoard.fromChessField;
            makeMove(getChessField(chessBoard, fromChessFieldPosition), getChessField(chessBoard, toChessFieldPosition));
            aiMove();
        };
        chessFieldDiv.appendChild(moveMarkerDiv);

    }
    return chessFieldDiv;

}

function aiMove() {
    let bestMove = chess_ai.calculateBestMove(chessBoard);
    let currentX = bestMove["x"];
    let currentY = bestMove["y"];
    let currentPos = calcPos(bestMove["x"], bestMove["y"]);

    let toField = bestMove[`${currentX}_${currentY}`];
    let toX = toField["x"];
    let toY = toField["y"];
    let toPos = calcPos(toField["x"], toField["y"]);
    debugger;
    makeMove(getChessField(chessBoard, currentPos), getChessField(chessBoard, toPos));

}


function renderBoard() {
    document.body.innerHTML = "";
    let chessBoardDiv = createBoardDiv();
    let fromChessFieldDiv = document.createElement("input");

    fromChessFieldDiv.id = "fromChessFieldDiv";
    fromChessFieldDiv.setAttribute("type", "hidden");
    let toChessFieldDiv = document.createElement("div");
    toChessFieldDiv.setAttribute("type", "hidden");
    toChessFieldDiv.id = "toChessFieldDiv";


    chessBoardDiv.appendChild(fromChessFieldDiv);
    chessBoardDiv.appendChild(toChessFieldDiv);

    chessBoard.chessFields.forEach(function (chessField, i) {
        let chessFieldDiv = createChessFieldDiv(chessField);
        let rubikFieldDiv = createRubikFieldDiv(chessField.rubikField, chessField.x, chessField.y);
        let figureDiv;

        chessFieldDiv.appendChild(rubikFieldDiv);
        if (chessField.figure !== undefined) {
            figureDiv = createFigureDiv(chessField.figure, chessField.x, chessField.y);
            chessFieldDiv.appendChild(figureDiv);
        }

        chessBoardDiv.appendChild(chessFieldDiv);
        // console.log('%d: %s', i, chessField.toString());
    });


    document.body.appendChild(chessBoardDiv);
}

function init() {
    appendStyle();
    createBoard();
    renderBoard();
}


function update() {
    renderBoard();
}

function appendStyle() {
    let style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = '.up { background: #ff8787 !important; }' + //red
        '.right { background: #7ab67a !important; }' + //green
        '.down { background: #9292ff !important; }' + //blue
        '.left { background: #e7e778 !important; }' + //yellow
        '.clockwise { background: #76f9ff !important; }' + //pink
        '.anticlockwise { background: #ffa500 !important; }' + //orange
        //'.black { background: black; border: 10px solid black; }' +
        //'.white { background: white; border: 10px solid white;}' +
        '.figure {     width: 25px;\n' +
        '    height: 25px;\n' +
        '    opacity: 1;\n' +
        '    transform: scale(2);\n' +
        '    vertical-align: middle;\n' +
        '    position: absolute;\n' +
        '    left: 16px;\n' +
        '    top: 8px;}' +
        '.chess_field { position: relative;\n' +
        '    top: 0px;\n' +
        '    left: 0px;}';

    document.getElementsByTagName('head')[0].appendChild(style);


}


function moveClockwise(x, y) {
    let poss = [];
    if (x === 0 && y === 2) { //1
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig3;
        chessBoard.chessFields[poss[2]].figure = fig1;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub3;
        chessBoard.chessFields[poss[2]].rubikField = rub1;

    } else if (x >= 1 && x <= 6 && y === 2) {//2
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig3;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig4;
        chessBoard.chessFields[poss[3]].figure = fig5;
        chessBoard.chessFields[poss[4]].figure = fig2;

        chessBoard.chessFields[poss[0]].rubikField = rub3;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub4;
        chessBoard.chessFields[poss[3]].rubikField = rub5;
        chessBoard.chessFields[poss[4]].rubikField = rub2;

    } else if (x === 7 && y === 2) {//3

        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig3;
        chessBoard.chessFields[poss[2]].figure = fig1;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub3;
        chessBoard.chessFields[poss[2]].rubikField = rub1;
    } else if ((x === 0 && y === 3) || (x === 0 && y === 4)) {//4

        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig4;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig2;
        chessBoard.chessFields[poss[3]].figure = fig5;
        chessBoard.chessFields[poss[4]].figure = fig3;

        chessBoard.chessFields[poss[0]].rubikField = rub4;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub2;
        chessBoard.chessFields[poss[3]].rubikField = rub5;
        chessBoard.chessFields[poss[4]].rubikField = rub3;

    } else if ((x >= 1 && x <= 6 && y === 3) || (x >= 1 && x <= 6 && y === 4)) {//5

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));

        let fig8 = chessBoard.chessFields[poss[7]].figure;
        let fig7 = chessBoard.chessFields[poss[6]].figure;
        let fig6 = chessBoard.chessFields[poss[5]].figure;
        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub8 = chessBoard.chessFields[poss[7]].rubikField;
        let rub7 = chessBoard.chessFields[poss[6]].rubikField;
        let rub6 = chessBoard.chessFields[poss[5]].rubikField;
        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig4;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig2;
        chessBoard.chessFields[poss[3]].figure = fig6;
        chessBoard.chessFields[poss[4]].figure = fig3;
        chessBoard.chessFields[poss[5]].figure = fig7;
        chessBoard.chessFields[poss[6]].figure = fig8;
        chessBoard.chessFields[poss[7]].figure = fig5;

        chessBoard.chessFields[poss[0]].rubikField = rub4;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub2;
        chessBoard.chessFields[poss[3]].rubikField = rub6;
        chessBoard.chessFields[poss[4]].rubikField = rub3;
        chessBoard.chessFields[poss[5]].rubikField = rub7;
        chessBoard.chessFields[poss[6]].rubikField = rub8;
        chessBoard.chessFields[poss[7]].rubikField = rub5;
    } else if ((x === 7 && y === 3) || (x === 7 && y === 4)) {//6

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig3;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig4;
        chessBoard.chessFields[poss[3]].figure = fig5;
        chessBoard.chessFields[poss[4]].figure = fig2;

        chessBoard.chessFields[poss[0]].rubikField = rub3;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub4;
        chessBoard.chessFields[poss[3]].rubikField = rub5;
        chessBoard.chessFields[poss[4]].rubikField = rub2;

    } else if (x === 0 && y === 5) {//7

        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x + 1, y));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig3;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig2;

        chessBoard.chessFields[poss[0]].rubikField = rub3;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub2;
    } else if (x >= 1 && x <= 6 && y === 5) {//8

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x + 1, y));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig4;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig2;
        chessBoard.chessFields[poss[3]].figure = fig5;
        chessBoard.chessFields[poss[4]].figure = fig3;

        chessBoard.chessFields[poss[0]].rubikField = rub4;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub2;
        chessBoard.chessFields[poss[3]].rubikField = rub5;
        chessBoard.chessFields[poss[4]].rubikField = rub3;

    } else if (x === 7 && y === 5) {//9

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x - 1, y));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig3;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig2;

        chessBoard.chessFields[poss[0]].rubikField = rub3;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub2;
    }

}

function moveAntiClockwise(x, y) {
    let poss = [];
    if (x === 0 && y === 2) { //1
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig3;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig2;

        chessBoard.chessFields[poss[0]].rubikField = rub3;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub2;

    } else if (x >= 1 && x <= 6 && y === 2) {//2
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig5;
        chessBoard.chessFields[poss[2]].figure = fig1;
        chessBoard.chessFields[poss[3]].figure = fig3;
        chessBoard.chessFields[poss[4]].figure = fig4;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub5;
        chessBoard.chessFields[poss[2]].rubikField = rub1;
        chessBoard.chessFields[poss[3]].rubikField = rub3;
        chessBoard.chessFields[poss[4]].rubikField = rub4;

    } else if (x === 7 && y === 2) {//3

        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig3;
        chessBoard.chessFields[poss[1]].figure = fig1;
        chessBoard.chessFields[poss[2]].figure = fig2;

        chessBoard.chessFields[poss[0]].rubikField = rub3;
        chessBoard.chessFields[poss[1]].rubikField = rub1;
        chessBoard.chessFields[poss[2]].rubikField = rub2;
    } else if ((x === 0 && y === 3) || (x === 0 && y === 4)) {//4

        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig3;
        chessBoard.chessFields[poss[2]].figure = fig5;
        chessBoard.chessFields[poss[3]].figure = fig1;
        chessBoard.chessFields[poss[4]].figure = fig4;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub3;
        chessBoard.chessFields[poss[2]].rubikField = rub5;
        chessBoard.chessFields[poss[3]].rubikField = rub1;
        chessBoard.chessFields[poss[4]].rubikField = rub4;

    } else if ((x >= 1 && x <= 6 && y === 3) || (x >= 1 && x <= 6 && y === 4)) {//5

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x + 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));
        poss.push(calcPos(x + 1, y + 1));

        let fig8 = chessBoard.chessFields[poss[7]].figure;
        let fig7 = chessBoard.chessFields[poss[6]].figure;
        let fig6 = chessBoard.chessFields[poss[5]].figure;
        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub8 = chessBoard.chessFields[poss[7]].rubikField;
        let rub7 = chessBoard.chessFields[poss[6]].rubikField;
        let rub6 = chessBoard.chessFields[poss[5]].rubikField;
        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig3;
        chessBoard.chessFields[poss[2]].figure = fig5;
        chessBoard.chessFields[poss[3]].figure = fig1;
        chessBoard.chessFields[poss[4]].figure = fig8;
        chessBoard.chessFields[poss[5]].figure = fig4;
        chessBoard.chessFields[poss[6]].figure = fig6;
        chessBoard.chessFields[poss[7]].figure = fig7;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub3;
        chessBoard.chessFields[poss[2]].rubikField = rub5;
        chessBoard.chessFields[poss[3]].rubikField = rub1;
        chessBoard.chessFields[poss[4]].rubikField = rub8;
        chessBoard.chessFields[poss[5]].rubikField = rub4;
        chessBoard.chessFields[poss[6]].rubikField = rub6;
        chessBoard.chessFields[poss[7]].rubikField = rub7;
    } else if ((x === 7 && y === 3) || (x === 7 && y === 4)) {//6

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x - 1, y + 1));
        poss.push(calcPos(x, y + 1));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig5;
        chessBoard.chessFields[poss[2]].figure = fig1;
        chessBoard.chessFields[poss[3]].figure = fig3;
        chessBoard.chessFields[poss[4]].figure = fig4;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub5;
        chessBoard.chessFields[poss[2]].rubikField = rub1;
        chessBoard.chessFields[poss[3]].rubikField = rub3;
        chessBoard.chessFields[poss[4]].rubikField = rub4;

    } else if (x === 0 && y === 5) {//7

        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x + 1, y));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig3;
        chessBoard.chessFields[poss[2]].figure = fig1;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub3;
        chessBoard.chessFields[poss[2]].rubikField = rub1;
    } else if (x >= 1 && x <= 6 && y === 5) {//8

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x + 1, y - 1));
        poss.push(calcPos(x - 1, y));
        poss.push(calcPos(x + 1, y));

        let fig5 = chessBoard.chessFields[poss[4]].figure;
        let fig4 = chessBoard.chessFields[poss[3]].figure;
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub5 = chessBoard.chessFields[poss[4]].rubikField;
        let rub4 = chessBoard.chessFields[poss[3]].rubikField;
        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig3;
        chessBoard.chessFields[poss[2]].figure = fig5;
        chessBoard.chessFields[poss[3]].figure = fig1;
        chessBoard.chessFields[poss[4]].figure = fig4;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub3;
        chessBoard.chessFields[poss[2]].rubikField = rub5;
        chessBoard.chessFields[poss[3]].rubikField = rub1;
        chessBoard.chessFields[poss[4]].rubikField = rub4;

    } else if (x === 7 && y === 5) {//9

        poss.push(calcPos(x - 1, y - 1));
        poss.push(calcPos(x, y - 1));
        poss.push(calcPos(x - 1, y));
        let fig3 = chessBoard.chessFields[poss[2]].figure;
        let fig2 = chessBoard.chessFields[poss[1]].figure;
        let fig1 = chessBoard.chessFields[poss[0]].figure;

        let rub3 = chessBoard.chessFields[poss[2]].rubikField;
        let rub2 = chessBoard.chessFields[poss[1]].rubikField;
        let rub1 = chessBoard.chessFields[poss[0]].rubikField;

        chessBoard.chessFields[poss[0]].figure = fig2;
        chessBoard.chessFields[poss[1]].figure = fig3;
        chessBoard.chessFields[poss[2]].figure = fig1;

        chessBoard.chessFields[poss[0]].rubikField = rub2;
        chessBoard.chessFields[poss[1]].rubikField = rub3;
        chessBoard.chessFields[poss[2]].rubikField = rub1;
    }

}


function moveUp(x) {
    let poss = [];
    for (let y = 2; y < 6; y++) {
        let pos = calcPos(x, y);
        poss.push(pos);
//        console.log(`pos ${pos}`);

    }

    let fig4 = chessBoard.chessFields[poss[3]].figure;
    let fig3 = chessBoard.chessFields[poss[2]].figure;
    let fig2 = chessBoard.chessFields[poss[1]].figure;
    let fig1 = chessBoard.chessFields[poss[0]].figure;

    let rub4 = chessBoard.chessFields[poss[3]].rubikField;
    let rub3 = chessBoard.chessFields[poss[2]].rubikField;
    let rub2 = chessBoard.chessFields[poss[1]].rubikField;
    let rub1 = chessBoard.chessFields[poss[0]].rubikField;

    chessBoard.chessFields[poss[0]].figure = fig2;
    chessBoard.chessFields[poss[1]].figure = fig3;
    chessBoard.chessFields[poss[2]].figure = fig4;
    chessBoard.chessFields[poss[3]].figure = fig1;

    chessBoard.chessFields[poss[0]].rubikField = rub2;
    chessBoard.chessFields[poss[1]].rubikField = rub3;
    chessBoard.chessFields[poss[2]].rubikField = rub4;
    chessBoard.chessFields[poss[3]].rubikField = rub1;

}

function moveDown(x) {
    let poss = [];
    for (let y = 2; y < 6; y++) {
        let pos = calcPos(x, y);
        poss.push(pos);
        console.log(`pos ${pos}`);

    }

    let fig4 = chessBoard.chessFields[poss[3]].figure;
    let fig3 = chessBoard.chessFields[poss[2]].figure;
    let fig2 = chessBoard.chessFields[poss[1]].figure;
    let fig1 = chessBoard.chessFields[poss[0]].figure;

    let rub4 = chessBoard.chessFields[poss[3]].rubikField;
    let rub3 = chessBoard.chessFields[poss[2]].rubikField;
    let rub2 = chessBoard.chessFields[poss[1]].rubikField;
    let rub1 = chessBoard.chessFields[poss[0]].rubikField;

    chessBoard.chessFields[poss[0]].figure = fig4;
    chessBoard.chessFields[poss[1]].figure = fig1;
    chessBoard.chessFields[poss[2]].figure = fig2;
    chessBoard.chessFields[poss[3]].figure = fig3;

    chessBoard.chessFields[poss[0]].rubikField = rub4;
    chessBoard.chessFields[poss[1]].rubikField = rub1;
    chessBoard.chessFields[poss[2]].rubikField = rub2;
    chessBoard.chessFields[poss[3]].rubikField = rub3;

}

function moveRight(y) {

    let poss = [];
    for (let x = 0; x < 8; x++) {
        let pos = calcPos(x, y);
        poss.push(pos);
        console.log(`pos ${pos}`);

    }

    let fig8 = chessBoard.chessFields[poss[7]].figure;
    let fig7 = chessBoard.chessFields[poss[6]].figure;
    let fig6 = chessBoard.chessFields[poss[5]].figure;
    let fig5 = chessBoard.chessFields[poss[4]].figure;
    let fig4 = chessBoard.chessFields[poss[3]].figure;
    let fig3 = chessBoard.chessFields[poss[2]].figure;
    let fig2 = chessBoard.chessFields[poss[1]].figure;
    let fig1 = chessBoard.chessFields[poss[0]].figure;

    let rub8 = chessBoard.chessFields[poss[7]].rubikField;
    let rub7 = chessBoard.chessFields[poss[6]].rubikField;
    let rub6 = chessBoard.chessFields[poss[5]].rubikField;
    let rub5 = chessBoard.chessFields[poss[4]].rubikField;
    let rub4 = chessBoard.chessFields[poss[3]].rubikField;
    let rub3 = chessBoard.chessFields[poss[2]].rubikField;
    let rub2 = chessBoard.chessFields[poss[1]].rubikField;
    let rub1 = chessBoard.chessFields[poss[0]].rubikField;

    chessBoard.chessFields[poss[0]].figure = fig8;
    chessBoard.chessFields[poss[1]].figure = fig1;
    chessBoard.chessFields[poss[2]].figure = fig2;
    chessBoard.chessFields[poss[3]].figure = fig3;
    chessBoard.chessFields[poss[4]].figure = fig4;
    chessBoard.chessFields[poss[5]].figure = fig5;
    chessBoard.chessFields[poss[6]].figure = fig6;
    chessBoard.chessFields[poss[7]].figure = fig7;

    chessBoard.chessFields[poss[0]].rubikField = rub8;
    chessBoard.chessFields[poss[1]].rubikField = rub1;
    chessBoard.chessFields[poss[2]].rubikField = rub2;
    chessBoard.chessFields[poss[3]].rubikField = rub3;
    chessBoard.chessFields[poss[4]].rubikField = rub4;
    chessBoard.chessFields[poss[5]].rubikField = rub5;
    chessBoard.chessFields[poss[6]].rubikField = rub6;
    chessBoard.chessFields[poss[7]].rubikField = rub7;

}

function moveLeft(y) {

    let poss = [];
    for (let x = 0; x < 8; x++) {
        let pos = calcPos(x, y);
        poss.push(pos);
        console.log(`pos ${pos}`);

    }

    let fig8 = chessBoard.chessFields[poss[7]].figure;
    let fig7 = chessBoard.chessFields[poss[6]].figure;
    let fig6 = chessBoard.chessFields[poss[5]].figure;
    let fig5 = chessBoard.chessFields[poss[4]].figure;
    let fig4 = chessBoard.chessFields[poss[3]].figure;
    let fig3 = chessBoard.chessFields[poss[2]].figure;
    let fig2 = chessBoard.chessFields[poss[1]].figure;
    let fig1 = chessBoard.chessFields[poss[0]].figure;

    let rub8 = chessBoard.chessFields[poss[7]].rubikField;
    let rub7 = chessBoard.chessFields[poss[6]].rubikField;
    let rub6 = chessBoard.chessFields[poss[5]].rubikField;
    let rub5 = chessBoard.chessFields[poss[4]].rubikField;
    let rub4 = chessBoard.chessFields[poss[3]].rubikField;
    let rub3 = chessBoard.chessFields[poss[2]].rubikField;
    let rub2 = chessBoard.chessFields[poss[1]].rubikField;
    let rub1 = chessBoard.chessFields[poss[0]].rubikField;

    chessBoard.chessFields[poss[0]].figure = fig2;
    chessBoard.chessFields[poss[1]].figure = fig3;
    chessBoard.chessFields[poss[2]].figure = fig4;
    chessBoard.chessFields[poss[3]].figure = fig5;
    chessBoard.chessFields[poss[4]].figure = fig6;
    chessBoard.chessFields[poss[5]].figure = fig7;
    chessBoard.chessFields[poss[6]].figure = fig8;
    chessBoard.chessFields[poss[7]].figure = fig1;

    chessBoard.chessFields[poss[0]].rubikField = rub2;
    chessBoard.chessFields[poss[1]].rubikField = rub3;
    chessBoard.chessFields[poss[2]].rubikField = rub4;
    chessBoard.chessFields[poss[3]].rubikField = rub5;
    chessBoard.chessFields[poss[4]].rubikField = rub6;
    chessBoard.chessFields[poss[5]].rubikField = rub7;
    chessBoard.chessFields[poss[6]].rubikField = rub8;
    chessBoard.chessFields[poss[7]].rubikField = rub1;

}


let chess_ai = {
        calculateBestMove: function (calcBoard) {


            let bestMove = {};
            //use any negative large number
            let bestValue = 9999;

            let calcBoardCopy = deepCopy(calcBoard);

            // let calcBoardCopy = {...calcBoard};

            for (let x = 0; x < 8; x++) {
                for (let y = 0; y < 8; y++) {
                    let pos = calcPos(x, y);
                    let figure = calcBoardCopy.chessFields[pos].figure;

                    if (figure !== undefined && figure.color === "black" && figure.calculated === false) {
                        let moves = chess_ai.getPossibleMovesForFigure(figure, x, y);
                        // for (let j = 0; j < moves.length; j++) {
                        for (let j = 1; j >=0; j--) {
                            let moveList = moves[j];
                            for (let i = 0; i < moveList.length; i++) {
                                let field = moveList[i];
                                calcBoardCopy = deepCopy(calcBoard);
                                let currentChessField = getChessField(calcBoardCopy, calcPos(x, y));
                                debugger;

                                figure.calculated = true;
                                calcBoardCopy.chessFields[calcPos(field.x, field.y)].figure = figure;
                                calcBoardCopy.chessFields[calcPos(currentChessField.x, currentChessField.y)].figure = undefined;

                                let boardValue = chess_ai.evaluateBoard(calcBoardCopy);
                                calcBoardCopy = deepCopy(calcBoard);
                                if (boardValue < bestValue) {
                                    bestValue = boardValue;
                                    bestMove[`${x}_${y}`] = field;
                                    bestMove['x'] = x;
                                    bestMove['y'] = y;
                                }
                            }
                        }


                    }

                }
            }
            console.log(`bestMove ${bestMove.toString()}`);

            return bestMove;

        },
        calculateBestMoveOld: function (game) {

            var newGameMoves = game.ugly_moves();
            var bestMove = null;
            //use any negative large number
            var bestValue = -9999;

            for (var i = 0; i < newGameMoves.length; i++) {
                var newGameMove = newGameMoves[i];
                game.ugly_move(newGameMove);

                //take the negative as AI plays as black
                var boardValue = -chess_ai.evaluateBoard(game.board());
                game.undo();
                if (boardValue > bestValue) {
                    bestValue = boardValue;
                    bestMove = newGameMove
                }
            }

            return bestMove;

        }
        ,
        evaluateBoard: function (chessBoard) {
            let totalEvaluation = 0;
            let figCount = 0;
            for (let x = 0; x < 8; x++) {
                for (let y = 0; y < 8; y++) {
                    let pos = calcPos(x, y);
                    let figure = chessBoard.chessFields[pos].figure;

                    if (figure !== undefined && figure !== null) {
                        figCount++;
                        let value = figure.value;
                        totalEvaluation = totalEvaluation + value;
                    }

                }
            }
            console.log(`totalEvaluation ${totalEvaluation} figCount ${figCount}`);
            return totalEvaluation;
        }
        ,
        getPossibleMovesForFigure: function (figure, x, y) {
            let possibleMoves = [];
            let pMap = {};


            if (figure.type === "rock") {
                possibleMoves = getRockMoves(figure, x, y);

            } else if (figure.type === "knight") {
                possibleMoves = getKnightMoves(figure, x, y);
            } else if (figure.type === "bishop") {
                possibleMoves = getBishopMoves(figure, x, y);
            } else if (figure.type === "queen") {
                possibleMoves = getQueenMoves(figure, x, y);
            } else if (figure.type === "king") {
                possibleMoves = getKingMoves(figure, x, y);
            } else if (figure.type === "pawn") {
                possibleMoves = getPawnMoves(figure, x, y);
            }
            pMap[`${x}_${y}`] = possibleMoves;//[moves,attacks]
            return possibleMoves;//[moves,attacks]
        }
        ,
        getPossibleMoves: function (chessBoard, color) {
            let possibleMoves = [];
            let pMap = {};
            for (let x = 0; x < 8; x++) {
                for (let y = 0; y < 8; y++) {
                    let pos = calcPos(x, y);
                    let figure = chessBoard.chessFields[pos].figure;

                    if (figure !== undefined) {


                        if (figure.type === "rock") {
                            possibleMoves = getRockMoves(figure, x, y);

                        } else if (figure.type === "knight") {
                            possibleMoves = getKnightMoves(figure, x, y);
                        } else if (figure.type === "bishop") {
                            possibleMoves = getBishopMoves(figure, x, y);
                        } else if (figure.type === "queen") {
                            possibleMoves = getQueenMoves(figure, x, y);
                        } else if (figure.type === "king") {
                            possibleMoves = getKingMoves(figure, x, y);
                        } else if (figure.type === "pawn") {
                            possibleMoves = getPawnMoves(figure, x, y);
                        }
                        pMap[`${x}_${y}`] = possibleMoves;


                    }

                }
            }
            //return possibleMoves;

            return pMap;

        }

    }
;


function deepCopy(obj) {
    var copy;

    // Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;

    // Handle Date
    if (obj instanceof Date) {
        copy = new Date();
        copy.setTime(obj.getTime());
        return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
        copy = [];
        for (var i = 0, len = obj.length; i < len; i++) {
            copy[i] = deepCopy(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        copy = {};
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = deepCopy(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}

init();


