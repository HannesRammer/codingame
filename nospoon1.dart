import 'dart:io';
import 'dart:math';

List list = [];
/**
 * Don't let the machines win. You are humanity's last hope...
 **/
void main() {
    //int width = int.parse(stdin.readLineSync()); // the number of cells on the X axis
    int width = 5;
    //stderr.writeln('width:$width');
    //int height = int.parse(stdin.readLineSync()); // the number of cells on the Y axis
    //stderr.writeln('height:$height');
    int height = 1;
    /*for (int i = 0; i < height; i++) {
        String line = stdin.readLineSync(); // width characters, each either 0 or .
        list.add(line);
        stderr.writeln('line:$line');
    }*/

    list = ["0.0.0"];
    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');


    String x1 = "";
    String y1 = "";
    String x2 = "";
    String y2 = "";
    String x3 = "";
    String y3 = "";
    // Three coordinates: a node, its right neighbor, its bottom neighbor
    for (int row = 0; row < height; row++) {
        String text = list[row];

        for (int column = 0; column < width; column++) {
            String char = text[column]; // width characters, each either 0 or .
            String charRight = ""; // width characters, each either 0 or .
            String charBottom = ""; // width characters, each either 0 or .

            if (char == "0") {
                x1 = "$column";
                y1 = "$row";

                List nextNodeX = findNextRight(row, column, text);
                x2 = "${nextNodeX[0]}";
                y2 = "${nextNodeX[1]}";

                List nextNodeY = findNextBottom(row, column, list);
                x3 = "${nextNodeY[0]}";
                y3 = "${nextNodeY[1]}";
                print('$x1 $y1 $x2 $y2 $x3 $y3');
            }


        }
    }
}

List findNextRight(int row, int colStart, String text) {
    List nextNodeX = [-1, -1];
    for (var i = colStart + 1; i < text.length; i++) {
        var node = text[i];
        if (node == "0") {
            nextNodeX = [i, row];
            break;
        }
    }
    return nextNodeX;
}

List findNextBottom(int row, int column, List rows) {
    List nextNodeY = [-1, -1];

    for (var i = row + 1; i < rows.length; i++) {
        var node = rows[i][column];
        if (node == "0") {
            nextNodeY = [column, i];
            break;
        }
    }
    return nextNodeY;
}