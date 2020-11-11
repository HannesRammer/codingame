class ChessBoard {
    chessFields = [];
    colorToMove = "white";

    constructor(chessFields) {
        this.chessFields = chessFields;
    }

    getPossibleMoves() {
        let possibleMoves = [];
        let pMap = {};
        for (let x = 0; x < 8; x++) {
            for (let y = 0; y < 8; y++) {
                let pos = ChessBoard.calcPos(x, y);
                let figure = this.chessFields[pos].figure;
                if (figure !== undefined) {
                    possibleMoves = figure.getPossibleMoves(x, y,this);
                    pMap[`${x}_${y}`] = possibleMoves;
                }
            }
        }
        //return possibleMoves;
        return pMap;
    }

    removeMoves() {
        this.chessFields.forEach(chessField => {
            chessField.marker = null;
        })
    }

    getChessField(pos) {
        return this.chessFields[pos];
    }

    static calcPos(x, y) {
        return (y * 8) + (x + 1) - 1;
    }


    evaluateBoard() {
        let totalEvaluation = 0;
        let figCount = 0;
        for (let x = 0; x < 8; x++) {
            for (let y = 0; y < 8; y++) {
                let pos = ChessBoard.calcPos(x, y);
                let figure = this.chessFields[pos].figure;

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

    getPossibleMoves(x, y,chessBoard) {
        let possibleMoves = [];
        if (this.type === "rock") {
            possibleMoves = Figure.getRockMoves(this, x, y,chessBoard);
        } else if (this.type === "knight") {
            possibleMoves = Figure.getKnightMoves(this, x, y,chessBoard);
        } else if (this.type === "bishop") {
            possibleMoves = Figure.getBishopMoves(this, x, y,chessBoard);
        } else if (this.type === "queen") {
            possibleMoves = Figure.getQueenMoves(this, x, y,chessBoard);
        } else if (this.type === "king") {
            possibleMoves = Figure.getKingMoves(this, x, y,chessBoard);
        } else if (this.type === "pawn") {
            possibleMoves = Figure.getPawnMoves(this, x, y,chessBoard);
        }
        return possibleMoves;
    }

    static getRockMoves(rock, x, y, chessBoard) {
        let possibleMoves = [];
        let possibleAttacks = [];

        for (let i = y + 1; i < 8; i++) {//below rock

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x, i));
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

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x, i));
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

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(i, y));
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

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(i, y));
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

    static getBishopMoves(bishop, x, y, chessBoard) {
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x + i, y + i));
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x - i, y + i));
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x - i, y - i));
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x + i, y - i));
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


    static getQueenMoves(queen, x, y, chessBoard) {
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x + i, y + i));
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x - i, y + i));
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x - i, y - i));
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
            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x + i, y - i));
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

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x, i));
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

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(x, i));
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

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(i, y));
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

            let chessField = chessBoard.getChessField(ChessBoard.calcPos(i, y));
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

    static getKingMoves(king, x, y, chessBoard) {
        // y = switchY(y);
        let possibleMoves = [];
        let possibleAttacks = [];
        let kingMoves = [[x, y - 1], [x + 1, y - 1], [x + 1, y], [x + 1, y + 1], [x, y + 1], [x - 1, y + 1], [x - 1, y], [x - 1, y - 1]];
// debugger;

        kingMoves.forEach((position) => {
            if ((position[0] >= 0 && position[0] < 8) && (position[1] >= 0 && position[1] < 8)) {

                let chessField = chessBoard.getChessField(ChessBoard.calcPos(position[0], position[1]));
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

    static getKnightMoves(knight, x, y, chessBoard) {
        // y = switchY(y);
        let possibleMoves = [];
        let possibleAttacks = [];
        let knightMoves = [[x - 1, y - 2], [x - 2, y - 1], [x - 2, y + 1], [x - 1, y + 2], [x + 1, y + 2], [x + 2, y + 1], [x + 2, y - 1], [x + 1, y - 2]];
// debugger;

        knightMoves.forEach((position) => {
            if ((position[0] >= 0 && position[0] < 8) && (position[1] >= 0 && position[1] < 8)) {
                let chessField = chessBoard.getChessField(ChessBoard.calcPos(position[0], position[1]));
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


    static getPawnMoves(pawn, x, y, chessBoard) {
        let possibleMoves = [];
        let possibleAttacks = [];
//move one field
        let chessField;
        if (pawn.color === "white") {
            chessField = chessBoard.getChessField(ChessBoard.calcPos(x, y - 1));
        } else {
            chessField = chessBoard.getChessField(ChessBoard.calcPos(x, y + 1));
        }
        if (chessField !== undefined) {//no field for move one found;
            let chessFieldFigure = chessField.figure;
            let isEmpty = false;
            if (chessFieldFigure === undefined || chessFieldFigure === null) {
                isEmpty = true;
            } else {
                isEmpty = false;
            }
            if (isEmpty) {
                possibleMoves.push(chessField);
            }
//move two field
            if (!pawn.hasMoved) {
                let chessField1;
                let chessField2;
                if (pawn.color === "white") {
                    chessField1 = chessBoard.getChessField(ChessBoard.calcPos(x, y - 1));
                    chessField2 = chessBoard.getChessField(ChessBoard.calcPos(x, y - 2));
                } else {
                    chessField1 = chessBoard.getChessField(ChessBoard.calcPos(x, y + 1));
                    chessField2 = chessBoard.getChessField(ChessBoard.calcPos(x, y + 2));
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
                chessField = chessBoard.getChessField(ChessBoard.calcPos(x + 1, y - 1));
            } else {
                chessField = chessBoard.getChessField(ChessBoard.calcPos(x + 1, y + 1));
            }
            chessFieldFigure = chessField.figure;
            if (chessFieldFigure === undefined || chessFieldFigure === null) {
                isEmpty = true;
            } else {
                isEmpty = false;
            }
            if (!isEmpty) {
                let isEnemy = chessFieldFigure.color !== pawn.color;
                if (isEnemy) {
                    possibleAttacks.push(chessField);
                }
            }
//attack left
            isEmpty = false;
            if (pawn.color === "white") {
                chessField = chessBoard.getChessField(ChessBoard.calcPos(x - 1, y - 1));
            } else {
                chessField = chessBoard.getChessField(ChessBoard.calcPos(x - 1, y + 1));
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
        }
        return [possibleMoves, possibleAttacks];
    }


    toString() {
        return `type:${this.type} color:${this.color}`;
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


let whiteFiguresCode = {"king": "&#x2654;", "queen": "&#x2655;", "rock": "&#x2656;", "bishop": "&#x2657;", "knight": "&#x2658;", "pawn": "&#x2659;"};
let blackFiguresCode = {"king": "&#x265A;", "queen": "&#x265B;", "rock": "&#x265C;", "bishop": "&#x265D;", "knight": "&#x265E;", "pawn": "&#x265F;"};

let topFigures = ["rock", "knight", "bishop", "queen", "king", "bishop", "knight", "rock",
    "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn"];

let bottomFigures = ["pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn",
    "rock", "knight", "bishop", "queen", "king", "bishop", "knight", "rock"];
let chessBoard = new ChessBoard([]);

function deepCopy(obj) {
    let copy;

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
        for (let i = 0, len = obj.length; i < len; i++) {
            copy[i] = deepCopy(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        copy = {};
        for (let attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = deepCopy(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}


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
            if (ChessBoard.calcPos(x, y) < 16) {
                figure = new Figure(topFigures.splice(0, 1)[0], "black");
            }
            if (ChessBoard.calcPos(x, y) >= 48) {
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

function makeMove(fromChessField, toChessField, playerType) {
    let figureCopy = {...fromChessField.figure};
    figureCopy.hasMoved = true;
    toChessField.figure = figureCopy;
    fromChessField.figure = undefined;
    if (chessBoard.colorToMove === "white") {
        chessBoard.colorToMove = "black";
    } else if (chessBoard.colorToMove === "black") {
        chessBoard.colorToMove = "white";
    } else {
        alert("problem no color to move");
    }
    console.log(`chessBoard.colorToMove ${chessBoard.colorToMove}`);
    chessBoard.removeMoves();
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
            if (playerType === "human") {
                setTimeout(aiMove, 1000);
            }
        }, 500);
    } else if (rubikField.special === "right") {
        setTimeout(function () {
            moveRight(y);
            update();
            if (playerType === "human") {
                setTimeout(aiMove, 1000);
            }
        }, 500);
    } else if (rubikField.special === "down") {
        setTimeout(function () {
            moveDown(x);
            update();
            if (playerType === "human") {
                setTimeout(aiMove, 1000);
            }
        }, 500);
    } else if (rubikField.special === "left") {
        setTimeout(function () {
            moveLeft(y);
            update();
            if (playerType === "human") {
                setTimeout(aiMove, 1000);
            }
        }, 500);
    } else if (rubikField.special === "clockwise") {
        setTimeout(function () {
            moveClockwise(x, y);
            update();
            if (playerType === "human") {
                setTimeout(aiMove, 1000);
            }
        }, 500);
    } else if (rubikField.special === "anticlockwise") {
        setTimeout(function () {
            moveAntiClockwise(x, y);
            update();
            if (playerType === "human") {
                setTimeout(aiMove, 1000);
            }
        }, 500);
    }
    if (rubikField.special === undefined) {
        if (playerType === "human") {
            setTimeout(aiMove, 1000);
        }
    }

    // };
    // update();

}


function createFigureDiv(figure, x, y) {
    let figureDiv = document.createElement("div");
    figureDiv.id = `figure_${figure.className}`;
    figureDiv.className = `figure f_${figure.color}_${figure.type}`;
    if (figure.color === "white") {
        figureDiv.innerHTML = `${whiteFiguresCode[figure.type]}`;
        figureDiv.style.textShadow = `1px 1px 1px white, 1px -1px 3px white, -1px 1px 1px white, -1px -1px 1px white`;
    } else {
        figureDiv.innerHTML = `${blackFiguresCode[figure.type]}`;
        figureDiv.style.textShadow = `1px 1px 1px white, 1px -1px 3px white, -1px 1px 1px white, -1px -1px 1px white`;
    }
    figureDiv.onclick = function () {
        // document.querySelector("#fromChessFieldDiv").setAttribute("value", ChessBoard.calcPos(figure.x, figure.y));
        if (figure.color === chessBoard.colorToMove) {
            chessBoard.fromChessField = ChessBoard.calcPos(x, y);
            // chessBoard.toChessField = "";
            chessBoard.removeMoves();
            let moveList = figure.getPossibleMoves(x, y,chessBoard);
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
            let toChessFieldPosition = ChessBoard.calcPos(x, y);

            let fromChessFieldPosition = chessBoard.fromChessField;
            makeMove(chessBoard.getChessField(fromChessFieldPosition), chessBoard.getChessField(toChessFieldPosition), "human");

        };
        chessFieldDiv.appendChild(moveMarkerDiv);

    }
    return chessFieldDiv;

}

function aiMove() {
    let bestMove = chess_ai.calculateBestMove(chessBoard);
    let currentX = bestMove["x"];
    let currentY = bestMove["y"];
    let currentPos = ChessBoard.calcPos(bestMove["x"], bestMove["y"]);

    let toField = bestMove[`${currentX}_${currentY}`];
    let toX = toField["x"];
    let toY = toField["y"];
    let toPos = ChessBoard.calcPos(toField["x"], toField["y"]);
    // debugger;
    makeMove(chessBoard.getChessField(currentPos), chessBoard.getChessField(toPos), "ai");

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
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));
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
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));

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

        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));
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

        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));

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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));

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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));

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

        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y));
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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x + 1, y));

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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
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
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));
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
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));

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

        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));
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

        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));

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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x + 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));
        poss.push(ChessBoard.calcPos(x + 1, y + 1));

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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x - 1, y + 1));
        poss.push(ChessBoard.calcPos(x, y + 1));

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

        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y));
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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x + 1, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
        poss.push(ChessBoard.calcPos(x + 1, y));

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

        poss.push(ChessBoard.calcPos(x - 1, y - 1));
        poss.push(ChessBoard.calcPos(x, y - 1));
        poss.push(ChessBoard.calcPos(x - 1, y));
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
        let pos = ChessBoard.calcPos(x, y);
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
        let pos = ChessBoard.calcPos(x, y);
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
        let pos = ChessBoard.calcPos(x, y);
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
        let pos = ChessBoard.calcPos(x, y);
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
        positionCount: 0,
        getBestMove: function (calcBoard) {


            chess_ai.positionCount = 0;
            let depth = 3;
            // let depth = parseInt($('#search-depth').find(':selected').text());

            let d = new Date().getTime();
            let bestMove = chess_ai.minimaxRoot(depth, calcBoard, true);
            let d2 = new Date().getTime();
            let moveTime = (d2 - d);
            let positionsPerS = (chess_ai.positionCount * 1000 / moveTime);

            console.log(`chess_ai.positionCount ${chess_ai.positionCount}`);
            console.log(`positionsPerS ${positionsPerS}`);
            return bestMove;

        },
        calculateBestMove: function (calcBoard) {
            let bestMove = {};
            //use any negative large number
            let bestValue = 9999;
            let calcBoardCopy = deepCopy(calcBoard);
            // let calcBoardCopy = {...calcBoard};
            for (let x = 0; x < 8; x++) {
                for (let y = 0; y < 8; y++) {
                    let pos = ChessBoard.calcPos(x, y);
                    let figure = calcBoardCopy.chessFields[pos].figure;
                    if (figure !== undefined && figure.color === "black" && figure.calculated === false) {
                        let moves = figure.getPossibleMoves(x, y,chessBoard);
                        // for (let j = 0; j < moves.length; j++) {
                        for (let j = 1; j >= 0; j--) {
                            let moveList = moves[j];
                            for (let i = 0; i < moveList.length; i++) {
                                let field = moveList[i];
                                calcBoardCopy = deepCopy();
                                let currentChessField = chessBoard.getChessField(calcBoardCopy, ChessBoard.calcPos(x, y));
                                // debugger;

                                figure.calculated = true;
                                calcBoardCopy.chessFields[ChessBoard.calcPos(field.x, field.y)].figure = figure;
                                calcBoardCopy.chessFields[ChessBoard.calcPos(currentChessField.x, currentChessField.y)].figure = undefined;

                                let boardValue = calcBoardCopy.evaluateBoard();
                                calcBoardCopy = deepCopy();
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

        minimaxRoot: function (depth, calcBoard, isMaximisingPlayer) {
            let bestMove = {};
            //use any negative large number
            let bestValue = 9999;
            let calcBoardCopy = deepCopy();
            for (let x = 0; x < 8; x++) {
                for (let y = 0; y < 8; y++) {
                    let pos = ChessBoard.calcPos(x, y);
                    let figure = calcBoardCopy.chessFields[pos].figure;

                    if (figure !== undefined && figure.color === "black" && figure.calculated === false) {
                        let moves = figure.getPossibleMoves(x, y,chessBoard);
                        // for (let j = 0; j < moves.length; j++) {
                        for (let j = 1; j >= 0; j--) {
                            let moveList = moves[j];
                            for (let i = 0; i < moveList.length; i++) {
                                let field = moveList[i];
                                calcBoardCopy = deepCopy();
                                let currentChessField = calcBoardCopy.getChessField(ChessBoard.calcPos(x, y));
                                // debugger;

                                figure.calculated = true;
                                calcBoardCopy.chessFields[ChessBoard.calcPos(field.x, field.y)].figure = figure;
                                calcBoardCopy.chessFields[ChessBoard.calcPos(currentChessField.x, currentChessField.y)].figure = undefined;

                                let boardValue = calcBoardCopy.evaluateBoard();
                                calcBoardCopy = deepCopy();
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

        minimax: function (depth, calcBoardCopy, alpha, beta, isMaximisingPlayer) {
            chess_ai.positionCount++;
            if (depth === 0) {
                return calcBoardCopy.evaluateBoard();
            }

            let newGameMoves = chessBoard.getPossibleMoves();

            if (isMaximisingPlayer) {
                let bestMove = -9999;
                for (let i = 0; i < newGameMoves.length; i++) {
                    let newGameMove = newGameMoves[i];
                    calcBoardCopy.ugly_move(newGameMoves[i]);
                    bestMove = Math.max(bestMove, calcBoardCopy.minimax(depth - 1, calcBoardCopy, alpha, beta, !isMaximisingPlayer));
                    calcBoardCopy.undo();
                    alpha = Math.max(alpha, bestMove);
                    if (beta <= alpha) {
                        return bestMove;
                    }
                }
                return bestMove;
            } else {
                let bestMove = 9999;
                for (let i = 0; i < newGameMoves.length; i++) {
                    calcBoardCopy.ugly_move(newGameMoves[i]);
                    bestMove = Math.min(bestMove, calcBoardCopy.minimax(depth - 1, calcBoardCopy, alpha, beta, !isMaximisingPlayer));
                    calcBoardCopy.undo();
                    beta = Math.min(beta, bestMove);
                    if (beta <= alpha) {
                        return bestMove;
                    }
                }
                return bestMove;
            }
        },


    }
;


init();


/*   calculateBestMoveOld: function (game) {

   let newGameMoves = game.ugly_moves();
   let bestMove = null;
   //use any negative large number
   let bestValue = -9999;

   for (let i = 0; i < newGameMoves.length; i++) {
       let newGameMove = newGameMoves[i];
       game.ugly_move(newGameMove);

       //take the negative as AI plays as black
       let boardValue = -chess_ai.evaluateBoard(game.board());
       game.undo();
       if (boardValue > bestValue) {
           bestValue = boardValue;
           bestMove = newGameMove
       }
   }

   return bestMove;

},
*/

/*      minimaxRootOld: function (depth, calcBoard, isMaximisingPlayer) {

          let newGameMoves = game.ugly_moves();
          let bestMove = -9999;
          let bestMoveFound;

          for (let i = 0; i < newGameMoves.length; i++) {
              let newGameMove = newGameMoves[i];
              game.ugly_move(newGameMove);
              let value = minimax(depth - 1, calcBoard, -10000, 10000, !isMaximisingPlayer);
              game.undo();
              if (value >= bestMove) {
                  bestMove = value;
                  bestMoveFound = newGameMove;
              }
          }
          return bestMoveFound;
      },
      */

/*minimaxOld: function (depth, game, alpha, beta, isMaximisingPlayer) {
        chess_ai.positionCount++;
        if (depth === 0) {
            return -evaluateBoard(game.board());
        }

        let newGameMoves = game.ugly_moves();

        if (isMaximisingPlayer) {
            let bestMove = -9999;
            for (let i = 0; i < newGameMoves.length; i++) {
                game.ugly_move(newGameMoves[i]);
                bestMove = Math.max(bestMove, minimax(depth - 1, game, alpha, beta, !isMaximisingPlayer));
                game.undo();
                alpha = Math.max(alpha, bestMove);
                if (beta <= alpha) {
                    return bestMove;
                }
            }
            return bestMove;
        } else {
            let bestMove = 9999;
            for (let i = 0; i < newGameMoves.length; i++) {
                game.ugly_move(newGameMoves[i]);
                bestMove = Math.min(bestMove, minimax(depth - 1, game, alpha, beta, !isMaximisingPlayer));
                game.undo();
                beta = Math.min(beta, bestMove);
                if (beta <= alpha) {
                    return bestMove;
                }
            }
            return bestMove;
        }
    }
    ,
    */
