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

    constructor(x, y, xyPosition, chessPosition, color, figure, rubikfield) {
        this.x = x;
        this.y = y;
        this.xyPosition = xyPosition;
        this.chessPosition = chessPosition;
        this.color = color;
        this.figure = figure;
        this.rubikField = rubikfield;
    }

    toString() {
        return `xy:${this.xyPosition} color:${this.color} 
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
    x;
    y;
    type;
    color;
    hasMoved = false;

    constructor(x, y, type, color) {
        this.x = x;
        this.y = y;
        this.type = type;
        this.color = color;
    }

    toString() {
        return `xy:${this.x}${this.y} type:${this.type} color:${this.color}`;
    }
}

function calcPos(x, y) {
    return (y * 8) + (x + 1) - 1;
}

function getChessField(x, y) {
    return chessBoard.chessFields[calcPos(x, y)];
}

function getRockMoves(rock) {
    let possibleMoves = [];
    let possibleAttacks = [];
debugger;
    for (let y = rock.y + 1; y < 8; y++) {//below rock

        let chessField = getChessField(rock.x, y);
        let chessFieldFigure = chessField.figure;
        let isEmpty = chessFieldFigure === undefined ? true : false;

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color ? true : false;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }
    for (let y = rock.y - 1; y >= 0; y--) {//above rock

        let chessField = getChessField(rock.x, y);
        let chessFieldFigure = chessField.figure;
        let isEmpty = chessFieldFigure === undefined ? true : false;

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color ? true : false;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    for (let x = rock.x - 1; x >= 0; x--) {//left of rock

        let chessField = getChessField(x, rock.y);
        let chessFieldFigure = chessField.figure;
        let isEmpty = chessFieldFigure === undefined ? true : false;

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color ? true : false;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }

    for (let x = rock.x + 1; x < 8; x++) {//left of rock

        let chessField = getChessField(x, rock.y);
        let chessFieldFigure = chessField.figure;
        let isEmpty = chessFieldFigure === undefined ? true : false;

        if (isEmpty) {
            possibleMoves.push(chessField);
        } else {
            let isEnemy = chessFieldFigure.color !== rock.color ? true : false;
            if (isEnemy) {
                possibleAttacks.push(chessField);
            }
            break;
        }
    }
    return [possibleMoves, possibleAttacks];

}


function getPawnMoves(pawn, x, y) {
   // y = switchY(y);
    let possibleMoves = [];
    let possibleAttacks = [];

// debugger;
//move one field
    let chessField = getChessField(pawn.x, pawn.y - 1);
    let chessFieldFigure = chessField.figure;
    let isEmpty = chessFieldFigure === undefined ? true : false;

    if (isEmpty) {
        possibleMoves.push(chessField);
    }
//move two field

    if (!pawn.hasMoved) {
        let chessField1 = getChessField(pawn.x, pawn.y - 1);
        let chessField2 = getChessField(pawn.x, pawn.y - 2);
        let chessFieldFigure1 = chessField1.figure;
        let chessFieldFigure2 = chessField2.figure;
        let isEmpty1 = chessFieldFigure1 === undefined ? true : false;
        let isEmpty2 = chessFieldFigure2 === undefined ? true : false;
        if (isEmpty1 && isEmpty2) {
            possibleMoves.push(chessField2);
        }
    }
//attack right
    chessField = getChessField(pawn.x + 1, pawn.y - 1);
    chessFieldFigure = chessField.figure;
    isEmpty = chessFieldFigure === undefined ? true : false;

    if (!isEmpty) {
        let isEnemy = chessFieldFigure.color !== pawn.color ? true : false;
        if (isEnemy) {
            possibleAttacks.push(chessField);
        }
    }
//attack left
    chessField = getChessField(pawn.x + 1, pawn.y - 1);
    chessFieldFigure = chessField.figure;
    isEmpty = chessFieldFigure === undefined ? true : false;

    if (!isEmpty) {
        let isEnemy = chessFieldFigure.color !== pawn.color ? true : false;
        if (isEnemy) {
            possibleAttacks.push(chessField);
        }
    }
    return [possibleMoves, possibleAttacks];
}

let whiteFiguresCode = {"king": "&#x2654;", "queen": "&#x2655;", "rock": "&#x2656;", "bishop": "&#x2657;", "knight": "&#x2658;", "pawn": "&#x2659;"};
let blackFiguresCode = {"king": "&#x265A;", "queen": "&#x265B;", "rock": "&#x265C;", "bishop": "&#x265D;", "knight": "&#x265E;", "pawn": "&#x265F;"};

let  topFigures = ["rock", "knight", "bishop", "queen", "king", "bishop", "knight", "rock",
    "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn"];

let bottomFigures= ["pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn",
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

    for (let y = 0; y <8; y++) {//row
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
                figure = new Figure(x, y, topFigures.splice(0, 1)[0], "black");
            }
            if (calcPos(x, y) >= 48) {
                figure = new Figure(x, y, bottomFigures.splice(0, 1)[0], "white");
            }
            let chessField = new ChessField(x, y, [x, y], `${x} ${letter}`, board[y][x], figure, rubikField);


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

function createFigureDiv(figure, x, y) {
    let figureDiv = document.createElement("div");
    figureDiv.id = `figure_${figure.id}`;
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
        let moveList=[];
        if (figure.type === "rock") {
            moveList = getRockMoves(figure);
        } else if (figure.type === "knight") {
            //moveRight(y);
        } else if (figure.type === "bishop") {
            //moveDown(x);
        } else if (figure.type === "queen") {
            //moveLeft(y);
        } else if (figure.type === "king") {
            //moveClockwise(x, y);
        } else if (figure.type === "pawn") {
            moveList = getPawnMoves(figure, x, y);

        }
        if(moveList.length > 0){
            moveList[0].forEach(element => console.log(`moveList:${element}`) );
            moveList[1].forEach(element => console.log(`attackList:${element}`) );
        }

    };
    return figureDiv;

}


function createRubikFieldDiv(rubikField, x, y) {
    let rubikFieldDiv = document.createElement("div");
    rubikFieldDiv.style.width = "30px";
    rubikFieldDiv.style.height = "30px";
    rubikFieldDiv.onclick = function () {
        if (rubikField.special === "up") {
            moveUp(x);
        } else if (rubikField.special === "right") {
            moveRight(y);
        } else if (rubikField.special === "down") {
            moveDown(x);
        } else if (rubikField.special === "left") {
            moveLeft(y);
        } else if (rubikField.special === "clockwise") {
            moveClockwise(x, y);
        } else if (rubikField.special === "anticlockwise") {
            moveAntiClockwise(x, y);
        }
        update();
    };
    // debugger;
    if (rubikField.x !== undefined) {
        // rubikFieldDiv.id = `r_${rubikField.x}${rubikField.y}`;

        rubikFieldDiv.className = `rubik_field ${rubikField.special}`;
        //rubikFieldDiv.style.float = "left";
        rubikFieldDiv.style.textAlign = "center";
        rubikFieldDiv.style.paddingTop = "3px";
        rubikFieldDiv.style.boxSizing = "border-box";

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

    return chessFieldDiv;

}


function renderBoard() {
    document.body.innerHTML = "";
    let chessBoardDiv = createBoardDiv();
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
        console.log('%d: %s', i, chessField.toString());
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
    style.innerHTML = '.up { background: red !important; }' +
        '.right { background: green !important; }' +
        '.down { background: blue !important; }' +
        '.left { background: yellow !important; }' +
        '.clockwise { background: pink !important; }' +
        '.anticlockwise { background: orange !important; }' +
        '.black { background: black; border: 10px solid black; }' +
        '.white { background: white; border: 10px solid white;}' +
        '.figure {     width: 25px;\n' +
        '    height: 25px;\n' +
        '    opacity: 1;\n' +
        '    transform: scale(2);\n' +
        '    vertical-align: middle;\n' +
        '    position: absolute;\n' +
        '    left: 7px;\n' +
        '    top: 0;\n' +
        '    left: 0;}' +
        '.chess_field { position: relative;\n' +
        '    top: 0;\n' +
        '    left: 0;}';

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

init();


