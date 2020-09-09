import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
List abc = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
List ROWS = [];

void main() {
    int L = int.parse(stdin.readLineSync());
    stderr.writeln('L:$L');
    int H = int.parse(stdin.readLineSync());
    stderr.writeln('H:$H');
    String T = stdin.readLineSync();
    stderr.writeln('T:$T');

    for (int i = 0; i < H; i++) {
        String ROW = stdin.readLineSync();
        ROWS.add(ROW);
        stderr.writeln('Row:$ROW');

    }

    for (var i = 0; i < ROWS.length; i++) {
        String outputStr = "";
        String row = ROWS[i];
        stderr.writeln('row:$row');
        for (var j = 0; j < T.length; j++) {
            String checkChar = T[j];
            stderr.writeln('checkChar:$checkChar');
            int index = abc.indexOf(checkChar.toLowerCase());
            stderr.writeln('index:$index');
            if(index == -1){
                outputStr+=row.substring(26*L,26*L+L);
            }else{
                outputStr+=row.substring(index*L,index*L+L);
            }
        }
        print(outputStr);

    }
    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

}