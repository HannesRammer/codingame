import 'dart:io';
import 'dart:math';

List l = [" ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];

List abc = [];
var count = 0;
String direction = "";
String lastLetter = "";
int lastLetterIndex = 0;
int x = 0;

void main() {
    String magicPhrase = stdin.readLineSync();
    stderr.writeln('sentence: ${magicPhrase}');


    for (int i = 0; i < magicPhrase.length; i++) {
        String letter = magicPhrase[i].toLowerCase();

        int position = l.indexOf(letter);
        stderr.writeln('0letter:${letter}');
        //stderr.writeln(abc.length);
        if (abc.length == 0) {
            direction += createLetter(i, position, letter);
            //stderr.writeln('1letter:${letter}');
        } else {
            //stderr.writeln("ELSE");
            int newLetterDistance = (((abc.length - x).abs() + position) + 1).abs();
            int useLetterDistance = ((abc.length - x).abs() + 1).abs();
            int modifyLetterDistance = (l.indexOf(abc.elementAt(x)) - position + 1).abs();
            String mod="";
            //stderr.writeln('#newLetterDistance: ${newLetterDistance}');
            //stderr.writeln('#useLetterDistance: ${useLetterDistance}');
            //stderr.writeln('#modifyLetterDistance: ${modifyLetterDistance}');
            //stderr.writeln('#aei: ${l.indexOf(abc.elementAt(x))}');
            //stderr.writeln('2letter:${letter}');
            //stderr.writeln('2abc.indexOf(letter):${abc.indexOf(letter)}');
            //stderr.writeln('abc.indexOf(letter):${abc.indexOf(letter)==-1}');
            if (abc.indexOf(letter) == -1) {
                if (newLetterDistance <= modifyLetterDistance) {
                   mod = "new";
                }
                if (modifyLetterDistance <= newLetterDistance) {
                    mod = "modify";
                }
                //stderr.writeln('mod:${mod}');
                if (mod == "new") {
                    direction += createLetter(i, position, letter);
                } else if (mod == "modify") {
                    direction += modifyLetter(position, letter);
                }
            } else {
                //direction += modifyLetter(position, letter);
                    direction += useLetter(letter);

            }
        }

        // Write an action using print()
        // To debug: stderr.writeln('Debug messages...');
       // UMNE TALMAR RAHTAINE NIXENEN UMIR
        lastLetter = letter;
        lastLetterIndex = l.indexOf(letter.toLowerCase());
    }


    stderr.writeln('direction: ${direction}');
    print(direction);
}


String createLetter(int i, int position, String letter) {
    //stderr.writeln('create------------');
    String direction = "";
    stderr.writeln('i ${i}');
    if (i > 0) {
        direction += ">";
        x += 1;
    }
    var goalIndex = abc.length;
    var dif = goalIndex - x; //(count-position);
    //go right

    if (dif > 0) {
        direction += new List.filled(dif.abs(), ">").join();
        x += dif;
    }

    if (position <= 13) {
        direction += new List.filled(position, "+").join();
        direction += ".";
    } else if (position > 13) {
        direction += new List.filled(27 - position, "-").join();
        direction += ".";
    }
    abc.add(letter);
    //stderr.writeln('create--------END');
    return direction;
}

String useLetter(letter) {
    //stderr.writeln('use------------');
    String direction = "";
    var goalIndex = abc.indexOf(letter);
    if (goalIndex < (x)) {
        var dif = x - goalIndex; //(count-position);
        stderr.writeln('Dif: ${dif}');

        direction += new List.filled(dif.abs(), "<").join();
        direction += ".";
        x = x - dif;
    } else if (goalIndex > (x)) {
        var dif = goalIndex - x; //(count-position);
        direction += new List.filled(dif, ">").join();
        direction += ".";
        x = x + dif;
    } else {
        direction += ".";
    }
    //stderr.writeln('use--------END');
    return direction;
}

modifyLetter(position, letter) {
    stderr.writeln('modify------------');
    String direction = "";
    var dif = l.indexOf(abc.elementAt(x)) - position;
    //stderr.writeln('abc.elementAt(x):${abc.elementAt(x)}');
    //stderr.writeln('l.indexOf(abc.elementAt(x)):${l.indexOf(abc.elementAt(x))}');
    //stderr.writeln('position:${position}');
    //stderr.writeln('letter:${letter}');
    //stderr.writeln('dif:$dif');

    if (dif < 0) {
        if (dif.abs() <= 13) {
            direction += new List.filled(dif.abs(), "+").join();
            direction += ".";
        } else {
            direction += new List.filled(27 - dif.abs(), "-").join();
            direction += ".";
        }
    } else if (dif > 0) {
        if (dif <= 13) {
            direction += new List.filled(dif, "-").join();
            direction += ".";
        } else {
            direction += new List.filled(27 - dif, "+").join();
            direction += ".";
        }
    } else {
        direction += ".";
    }

    abc[x] = letter;
    stderr.writeln('modify--------END');
    return direction;
}