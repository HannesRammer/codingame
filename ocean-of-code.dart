import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
List map = [];
List water = [];
List possibleEnemy = [];
List possiblePath = [];
List visited = [];
void main() {
    List inputs;
    inputs = stdin.readLineSync().split(' ');
    int width = int.parse(inputs[0]);
    int height = int.parse(inputs[1]);
    int myId = int.parse(inputs[2]);
    for (int i = 0; i < height; i++) {
        String line = stdin.readLineSync();
        for(int j=0;j<line.length;j++){
            if(line[j] == "."){
                water.add("${j} ${i}");
                possibleEnemy.add([j,i]);
                //.dtxt("add x${j} y${i} to unseen");
            }
        }
        dxt(line);
        map.add(line);
    }

    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    print(water[0]);

    // game loop
    while (true) {
        inputs = stdin.readLineSync().split(' ');
        int x = int.parse(inputs[0]);
        int y = int.parse(inputs[1]);
        int myLife = int.parse(inputs[2]);
        int oppLife = int.parse(inputs[3]);
        int torpedoCooldown = int.parse(inputs[4]);
        int sonarCooldown = int.parse(inputs[5]);
        int silenceCooldown = int.parse(inputs[6]);
        int mineCooldown = int.parse(inputs[7]);
        String sonarResult = stdin.readLineSync();
        String opponentOrders = stdin.readLineSync();

        // Write an action using print()
        // To debug: stderr.writeln('Debug messages...');
        visited.add("${x} ${y}");
        String direction = "N";
        stderr.writeln('Opponent orders  ${opponentOrders}');
        if(opponentOrders.contains("MOVE ")){
            possiblePath.add(opponentOrders.split("MOVE ")[1]);
        }else{
            possiblePath = [];
            possibleEnemy = [];
        }
        stderr.writeln('Opponent path ${possiblePath}');

        List pos = getClosestPos(x, y, water);
        dxt("${pos}");
        if(pos != null){

            if(pos[0] > x){
                direction = "E";
            }
            if(pos[0] < x){
                direction = "W";
            }
            if(pos[1] < y){
                direction = "N";
            }
            if(pos[1] > y){
                direction = "S";
            }
            print('MOVE ${direction} TORPEDO');
        }else{
            visited = [];
            print('SURFACE');
        }

    }
}

dxt(String text){
    stderr.writeln(text);
}

List getClosestPos(int myX, int myY, List positions) {
    num shortestDistance = -1;
    int targetId = -1;
    int x, y;
    List targetField;
    for (int i = 0; i < positions.length; i++) {
        List pos = positions[i].split(" ");
        int tx = int.parse(pos[0]);
        int ty = int.parse(pos[1]);

        //.dtxt('pellet ${targetPellet},${pellet.x},${myX},${myY}');
        //if(goals.indexOf("${pellet.x} ${pellet.y}") == -1 && ignoredFields.indexOf("${pellet.x} ${pellet.y}") == -1 ){
        // dxt('tx ${tx == myX} ty ${ty == myY}');
        num distance = getDistance(tx, ty, myX, myY);

        //dxt('distance ${distance == 1}, i:${ i}');
        if ( visited.indexOf("${tx} ${ty}") == -1 && distance == 1 ) {
            dxt('distance ${distance }');
            shortestDistance = distance;
            targetField = [tx,ty];//tmpField;
            x = tx;
            y = ty;
            dxt('tx ${tx} ty ${ty}');
        }

        //}

    }

    return targetField;
}


num getDistance(int xA, int yA, int xB, int yB) {
    return sqrt((pow((xA - xB), 2) + pow((yA - yB), 2)));
}
