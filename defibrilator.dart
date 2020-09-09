import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    num LON = num.parse(stdin.readLineSync().replaceAll(",","."));
    num LAT = num.parse(stdin.readLineSync().replaceAll(",","."));
    int N = int.parse(stdin.readLineSync());
    List l = [];
    for (int i = 0; i < N; i++) {
        String DEFIB = stdin.readLineSync();
        l.add(DEFIB.split(";"));
    }
    num lonB;
    num latB;
    List ds=[];
    int closestI;
    num closestD=-1;
    for (int i = 0; i < l.length; i++) {
        List description = l[i];
        lonB = num.parse(description[description.length - 2].replaceAll(",","."));
        latB = num.parse(description[description.length - 1].replaceAll(",","."));

        num x = ((lonB - LON) * cos(((LAT + latB) / 2)));
        num y = (latB - LAT);
        var px = pow(x, 2);
        var py = pow(y, 2);
        num d = sqrt((px + py)) * 6371;
        ds.add(d);
        if (closestD==-1 || d<closestD){
            closestD=d;
            closestI=i;
        }

    }


    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    print(l[closestI][1]);

}