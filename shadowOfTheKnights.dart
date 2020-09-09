import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    List inputs;
    inputs = stdin.readLineSync().split(' ');
    int W = int.parse(inputs[0]); // width of the building.
    int H = int.parse(inputs[1]); // height of the building.
    int turns = int.parse(stdin.readLineSync()); // maximum number of turns before game over.
    inputs = stdin.readLineSync().split(' ');
    int X0 = int.parse(inputs[0]);
    int Y0 = int.parse(inputs[1]);
    List bomb = [-1, -1];
    List lt = [0, 0],
            rt = [0, W];
    List lb = [H, 0],
            rb = [H, W];
    List wd = [-1, -1];
    var was = [-1, -1];
    var target = [0, 0];
// game loop
    while (true) {
        String bombDir = stdin.readLineSync(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

        // Write an action using print()
        // To debug: stderr.writeln('Debug messages...');

        var move = 2;
        String word = "";
        if (bombDir.contains("U")) {
            stderr.writeln('U');
            if (was[1] == -1) {
                target[1] = (Y0 / 2).toInt();
            } else {
                target[1] = (was[1] / 2).toInt();
            }
        } else if (bombDir.contains("D")) {
            stderr.writeln('D');
            if (was[1] == -1) {
                target[1] = ((Y0 + H) / 2).toInt();
            } else {
                target[1] = ((Y0 + was[1]) / 2).toInt();
            }
        }
        if (bombDir.contains("R")) {
            stderr.writeln('R');
            if (was[0] == -1) {
                target[0] = ((X0 + W) / 2).toInt();
            } else {
                target[0] = ((X0 + was[0]) / 2).toInt();
            }
        } else if (bombDir == "L") {
            stderr.writeln('L');
            if (was[0] == -1) {
                target[0] = (X0 / 2).toInt();
            } else {
                target[0] = ((was[1] + X0) / 2).toInt();
            }


//target[1]=Y0;
        }
        was = [X0, Y0];
        X0 = target[0];
        Y0 = target[1];
        print("${target[0]} ${target[1]}");
// the location of the next window Batman should jump to.
//print('0 0');
    }
}