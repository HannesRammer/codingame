import'dart:io';

var a, b, c, d, E, w,i;

main() {
    s() {
        return stdin.readLineSync();
    }
    i = s().split(' ');
    t(x) {
        int.parse(x);
    }

    a = t(i[0]);
    b = t(i[1]);
    c = t(i[2]);
    d = t(i[3]);
    while (true) {
        E = t(s());
        w = "";
        if (d > b) {
            w += "N";
            d -= 1;
        } else if (d < b) {
            w += "S";
            d += 1;
        }
        if (c < a) {
            w += "E";
            c += 1;
        } else if (c > a) {
            w += "W";
            c -= 1;
        }
        print(w);
    }
}