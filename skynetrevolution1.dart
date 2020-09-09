import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    List inputs;
    inputs = stdin.readLineSync().split(' ');
    int N = int.parse(inputs[0]); // the total number of nodes in the level, including the gateways
    int L = int.parse(inputs[1]); // the number of links
    int E = int.parse(inputs[2]); // the number of exit gateways
    List ns = [];
    List links = [];
    for (int i = 0; i < L; i++) {
        String link = stdin.readLineSync();
        inputs = link.split(' ');
        int N1 = int.parse(inputs[0]); // N1 and N2 defines a link between these nodes
        int N2 = int.parse(inputs[1]);
        links.add(link);
    }
    List EIs = [];
    List linksToRemove = [];
    for (int i = 0; i < E; i++) {
        int EI = int.parse(stdin.readLineSync()); // the index of a gateway node
        EIs.add(EI);
        for (int i = 0; i < links.length; i++) {
            String link = links[i];
            if (link.startsWith("${EI} ")|| link.endsWith(" ${EI}")) {
                linksToRemove.add(link);
            }
        }
    }
    stderr.writeln(linksToRemove);
    // game loop
    while (linksToRemove.length>0) {
        int SI = int.parse(stdin.readLineSync()); // The index of the node on which the Skynet agent is positioned this turn
        // Write an action using print()
        // To debug: stderr.writeln('Debug messages...');
        String s = linksToRemove[0] ;
        String se = "";
        for (int i = 0; i < links.length; i++) {
            String link = links[i];
            for(int j = 0; j < EIs.length; j++) {
                var ei=EIs[j];

                se = "${ei} ${SI}";

                if (linksToRemove.contains(se)) {

                    s=se;
                    break;
                }
            }
            if(se != ""){
                if (linksToRemove.contains(se)) {
                    s=se;
                    break;
                }else{
                 //   s=linksToRemove[0];
                    break;
                }
            }else{
                if (link.startsWith("${SI} ") || link.endsWith(" ${SI}")) {
                    s=link;
                    break;
                }else{
                    s=linksToRemove[0];
                    break;
                }
            }

        }

        links.remove(s);
        linksToRemove.remove(s);
        // Example: 0 1 are the indices of the nodes you wish to sever the link between
        print(s);
    }
}