import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    List inputs;
    int N = int.parse(stdin.readLineSync()); // Number of elements which make up the association table.
    int Q = int.parse(stdin.readLineSync()); // Number Q of file names to be analyzed.

    Map m = {};
    for (int i = 0; i < N; i++) {
        inputs = stdin.readLineSync().split(' ');

        if(inputs != null){
            stderr.writeln('inputs ${inputs}');
            String EXT = inputs[0].toLowerCase(); // file extension
            String MT = inputs[1]; // MIME type.
            stderr.writeln('EXT ${EXT}');
            stderr.writeln('MT ${MT}');
            if(EXT != null){
                m[EXT]=MT;
            }
        }
    }
    List files = [];
    for (int i = 0; i < Q; i++) {
        String FNAME = stdin.readLineSync(); // One file name per line.
        stderr.writeln('FNAME ${FNAME}');
        files.add(FNAME);
        List nameParts = FNAME.split(".");
        if(nameParts.length >= 2){
            String extension = nameParts[nameParts.length-1].toLowerCase();
            if(FNAME.toLowerCase().contains(extension.toLowerCase())){

                stderr.writeln('extension ${extension}');
                if(m[extension] == null){
                    print('UNKNOWN');
                }else{
                    print(m[extension]);
                }
            }else{
                print('UNKNOWN');
            }
        }else{
            print('UNKNOWN');
        }
    }


    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');


    // For each of the Q filenames, display on a line the corresponding MIME type. If there is no corresponding type, then display UNKNOWN.
}