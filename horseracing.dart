import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    int N = int.parse(stdin.readLineSync());
    stderr.writeln('n: ${N}');
    List l = [];
    for (int i = 0; i < N; i++) {
        int Pi = int.parse(stdin.readLineSync());
        l.add(Pi);
    }
    l.sort();

    int maxDif = 10000000;
    for (int i = 0; i < l.length-1; i++) {
        int power1 = l[i];
        int power2 = l[i+1];
        stderr.writeln('max: $maxDif');
        stderr.writeln('p1: ${power1}');
        stderr.writeln('p2: ${power2}');

        var dif= (power1 - power2).abs();
        if (dif <= maxDif) {
            maxDif = dif;
        }

    }
    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    print(maxDif);
}