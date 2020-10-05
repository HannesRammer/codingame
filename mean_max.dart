import 'dart:io';
import 'dart:math';

List wrecks = [];
List tankers = [];
Map myUnits = {};
/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    List inputs;

    // game loop
    while (true) {
        myUnits={};
        wrecks=[];
        tankers=[];
        int myScore = int.parse(stdin.readLineSync());
        int enemyScore1 = int.parse(stdin.readLineSync());
        int enemyScore2 = int.parse(stdin.readLineSync());
        int myRage = int.parse(stdin.readLineSync());
        int enemyRage1 = int.parse(stdin.readLineSync());
        int enemyRage2 = int.parse(stdin.readLineSync());
        int unitCount = int.parse(stdin.readLineSync());
        for (int i = 0; i < unitCount; i++) {
            inputs = stdin.readLineSync().split(' ');
            int unitId = int.parse(inputs[0]);
            int unitType = int.parse(inputs[1]);
            int player = int.parse(inputs[2]);
            double mass = double.parse(inputs[3]);
            int radius = int.parse(inputs[4]);
            int x = int.parse(inputs[5]);
            int y = int.parse(inputs[6]);
            int vx = int.parse(inputs[7]);
            int vy = int.parse(inputs[8]);
            int extra = int.parse(inputs[9]);
            int extra2 = int.parse(inputs[10]);
            Unit u = Unit(unitId, unitType,player,radius,vx,vy,extra,extra2,x,y,mass);
            if(unitType==4){
                wrecks.add(u);
            }
            if(unitType==3){
                tankers.add(u);
            }
            if(player == 0){
                myUnits[unitType] = u;
            }

        }
        Unit myReaper = myUnits[0];
        Unit myDestroyer = myUnits[1];
        Unit reaperTarget = null;
        if(wrecks.length == 0){
            reaperTarget = myDestroyer;// getClosestUnit(myReaper.x,myReaper.y,wrecks);
        }else{
            reaperTarget = getClosestUnit(myReaper.x,myReaper.y,wrecks);
        }

        Unit destroyerTarget = getClosestUnit(myDestroyer.x,myDestroyer.y,tankers);
        // Write an action using print()
        // To debug: stderr.writeln('Debug messages...');


        print('${reaperTarget.pos.x - myReaper.vx} ${reaperTarget.pos.y - myReaper.vy} 300 DUMMY');
        print('${destroyerTarget.pos.x} ${reaperTarget.pos.y} 300');
        print('WAIT');
    }
}

class Unit{
    int id, type, player, radius, vx, vy, extra, extra2, x, y ;
    num mass;
    Pos pos = null;
    Unit(this.id, this.type,this.player,this.radius,this.vx,this.vy,this.extra,this.extra2,this.x,this.y,this.mass){
        pos = Pos(x,y);
    }
}
num getDistance(int xA, int yA, int xB, int yB) {
    return sqrt((pow((xA - xB), 2) + pow((yA - yB), 2)));
}

Unit getClosestUnit(int myX, int myY, List units) {
    num shortestDistance = -1;
    int targetId = -1;
    int x, y;
    Unit targetUnit;
    for (int i = 0; i < units.length; i++) {
        Pos pos = units[i].pos;
        int tx = pos.x;
        int ty = pos.y;

        //.dtxt('pellet ${targetPellet},${pellet.x},${myX},${myY}');
        //if(goals.indexOf("${pellet.x} ${pellet.y}") == -1 && ignoredFields.indexOf("${pellet.x} ${pellet.y}") == -1 ){
        // dxt('tx ${tx == myX} ty ${ty == myY}');
        num distance = getDistance(tx, ty, myX, myY);
        if ((shortestDistance == -1 || distance < shortestDistance)) {
            shortestDistance = distance;
            targetUnit = units[i];
        }
    }

    return targetUnit;
}


class Pos{
    int x,y;
    Pos(this.x, this.y);
    String sPos(){
        return "$x $y";
    }



}
