let chessBoardMap = {};
let chessBoardList = [];

let rubicDirections = ["up", "right","down", "left", "clockwise", "anticlockwise"];
let rubicDirectionsCounter = 0;
let board = [["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"],

    ["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"],

    ["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"],

    ["w", "s", "w", "s", "w", "s", "w", "s"],
    ["s", "w", "s", "w", "s", "w", "s", "w"]];

function createBoard() {
    for (let y = 0; y < 8; y++) {//row
        let letter;
        if (y == 0) {
            letter = "a";
        } else if (y == 1) {
            letter = "b";
        } else if (y == 2) {
            letter = "c";
        } else if (y == 3) {
            letter = "d";
        } else if (y == 4) {
            letter = "e";
        } else if (y == 5) {
            letter = "f";
        } else if (y == 6) {
            letter = "g";
        } else if (y == 7) {
            letter = "h";
        }
        // for (let x = 0; x < 8; x++) {//column
        for (let x = 7; x >= 0; x--) {//column
            let special = "";
            if (y == 0 || y == 1) {//top two rows
                special = "none";
            }
            else if (y == 6 || y == 7) {//bottom two rows
                special = "none";
            }else{
                special = rubicDirections[rubicDirectionsCounter];
                if (rubicDirectionsCounter == 5) {
                    rubicDirectionsCounter = 0;
                }else{
                    rubicDirectionsCounter++;
                }
            }

            let cell = {
                "x": x,
                "y": y,
                "xyPosition": [x, y],
                "chessPosition": `${x} ${letter}`,
                "special": special,
                "chessColor": board[y][x],
            };

            chessBoardMap[`${x} ${letter}`] = cell;
            chessBoardList.push(cell);


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


function createCellDiv(cell) {
    let cellDiv = document.createElement("div");
    cellDiv.style.width = "50px";
    cellDiv.style.height = "50px";
    // debugger;

    cellDiv.id = `c_${cell["x"]}${cell["y"]}`;
    let cellColor = cell["chessColor"] == "w" ? "white" : "black";
    // let cellColor = cell == "w" ? "white" : "black";


    cellDiv.style.background = cellColor;
    cellDiv.className = `cell ${cellColor} ${cell["special"]}`;
    cellDiv.style.float = "left";
    cellDiv.style.textAlign= "center";
    cellDiv.style.paddingTop= "3px";
    cellDiv.style.boxSizing= "border-box";

    let arrow = "";
    if(cell["special"]== "up"){
        arrow = "&uarr;";
    }else if(cell["special"]== "right"){
        arrow = "&rarr;";
    }else if(cell["special"]== "down"){
        arrow = "&darr;";
    }else if(cell["special"]== "left"){
        arrow = "&larr;";
    }else if(cell["special"]== "clockwise"){
        arrow = "&#x21BB;";
    }else if(cell["special"]== "anticlockwise"){
        arrow = "&#x21BA;";
    }
    cellDiv.innerHTML = arrow;
    return cellDiv;

}

function renderBoard() {
    debugger;
    let boardDiv = createBoardDiv();
    chessBoardList.forEach(function (cell, i) {
        let cellDiv = createCellDiv(cell);
        boardDiv.appendChild(cellDiv);
        console.log('%d: %s', i, cell);
    });


    document.body.appendChild(boardDiv);
}

function init() {
    appendStyle();
    createBoard();
    renderBoard();
}
function appendStyle(){
    let style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = '.up { background: red !important; }' +
        '.right { background: green !important; }' +
        '.down { background: blue !important; }' +
        '.left { background: yellow !important; }'+
        '.clockwise { background: pink !important; }'+
        '.anticlockwise { background: orange !important; }'+
        '.black { background: black; border: 10px solid black; }'+
        '.white { background: white; border: 10px solid white;}';
    document.getElementsByTagName('head')[0].appendChild(style);


}


init();


