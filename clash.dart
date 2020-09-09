import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    List inputs;
    int N = 2;
    //int N = int.parse(stdin.readLineSync());
    List countList = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    //inputs = stdin.readLineSync().split(' ');
    inputs = "1 8".split(' ');
    for (int i = 0; i < N; i++) {
        int sampleValue = int.parse(inputs[i]);
        countList[sampleValue - 1] += 1;
    }
    for (var i = 0; i < countList.length; i++) {
        int starCount = countList[i];
        String scs = "";
        for (var j = 0; j < starCount; j++) {
            scs += "*";
        }

        print("${i + 1}:$scs");
    }
}