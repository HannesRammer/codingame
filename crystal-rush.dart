import 'dart:io';
import 'dart:math';

/**
 * Deliver more ore to hq (left side of the map) than your opponent. Use radars to find ore but beware of traps!
 **/

Map lastEnemyPositions = Map();
Map lastStateOfEnemySurroundings = Map();
Map robots = Map();
num whishedEnemyDeath = 2;
List takenDigs = [];
num enemyConcentrationCount = 3;
bool activateStriker = false;
bool activateStrikerValue = false;
Map chargedEnemy = {
    "0": false,
    "1": false,
    "2": false,
    "3": false,
    "4": false,
    "5": false,
    "6": false,
    "7": false,
    "8": false,
    "9": false,
    "10": false,
    "11": false,
    "12": false,
    "13": false,
    "14": false
};
num strikerCounter = 0;
List trapOrRadar = new List();
//List radarPos= [[9,7],[14,7],[5,12],[19,7],[6,3],[10,8],[14,4],[15,11],[20,4],[20,7],[20,11],[25,7],[25,3],[6,3],[25,11],[12,3]];
dt(String text) {
    //stderr.writeln(text);
}

List radarPosTest = [

    [13, 5],
    [14, 11],
    [19, 8],
    [19, 2],
    [23, 12],
    [26, 6],
    [4, 6],
    [6, 2],
    [5, 11],
    [9, 7]

];
List radarPos = [
    [5, 9],
    [9, 4],

    [14, 11],
    [17, 6],

    [23, 12],
    [15, 2],

    [21, 2],
    [10, 7],
    [26, 6],
    [4, 6],

    [6, 2],
    [5, 11],

    [1, 14]
];
List oldRadarPos = [
    [5, 4],
    [10, 8],
    [14, 4],
    [15, 10],
    [20, 4],
    [22, 9],
    [25, 4],
    [25, 11],
    [28, 6],
    [3, 1]
];
List radarTopBottom = [
    [5, 4],
    [14, 4],
    [10, 8],
    [15, 10],
    [20, 4],
    [22, 9],
    [25, 4],
    [25, 11],
    [28, 6],
    [3, 1]
];
List radarBottomTop = [
    [10, 8],
    [15, 10],
    [14, 4],
    [22, 9],
    [25, 11],
    [5, 4],
    [20, 4],
    [25, 4],
    [28, 6],
    [3, 1]
];
List dmgArea = List();
Map myDeathCount = Map();
Map enemyDeathCount = Map();
List hunterField = [
    [2, 9],
    [2, 10],
    [3, 10],
    [3, 11],
    [3, 12] /*,

  [5, 11],
  [4, 12],
  [4, 13]*/
];
List OLDhunterFieldTop = [
    //[2, 2],
    //[2, 3],
    //[3, 3],
    [3, 4], [2, 4], [3, 5], [2, 5], [2, 6], [1, 6], [1, 7]
    /*,
  [4, 4],
  [5, 11],
  [4, 12],
  [4, 13]*/
];

List oldhunterFieldMiddle = [
    [3, 6],
    [3, 7],
    [2, 7],
    [2, 8],
    [1, 8],
    [1, 9] /*,
  [2, 9],
  [2, 10],
  [3,9]


  [4, 11],
  [5, 11],
  [4, 12],
  [4, 13]*/
];
List oldhunterFieldBottom = [
    [3, 10],
    [2, 10],
    [2, 11],
    [3, 9],
    [4, 9]
];
num X = 0;
List hunterFieldTop = [
    [1 + X, 6],
    [1 + X, 5],
    [2 + X, 5],
    [2 + X, 4],
    [2 + X, 3],
    [3 + X, 3]
];

List hunterFieldMiddle = [
    [1 + X, 7],
    [2 + X, 7],
    [1 + X, 8],
    [2 + X, 8],
    [2 + X, 9]
];

List hunterFieldBottom = [
    [3 + X, 9],
    [2 + X, 10],
    [2 + X, 11],
    [3 + X, 11]
];
List enemyRadar = List();
List myTraps = List();
List myActiveTraps = List();
List enemyDigs = List();
List myDigs = List();
List allDigs = List();
Map enemyRobots = Map();
List strikePosition = List();
//
List validOreList = List();
List map = List();
Map mapWithStateOfHole = Map();
List oreMap = List();
List oreList = List();
Map focusedOre = Map();
List startGoal = List();
int scoutCounter = 0;
int sniperCounter = 0;
int oreLimit = 10;
List safeYPosInFirstRow = List();
int radarCooldown = 0;
int trapCooldown = 0;
var rng = new Random();
List validRobotIds = List();
int round = 0;
List luckyPos = List();
List luckyTrapPos = List();
List enemyConcentrationList = List();
num enemyConcentration = -1;
List countEnemyInRows = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

num scanStep = 2;
List areaScans = [13, 13, 13];
List yRange = [
    [3, 5],
    [6, 8],
    [10, 12]
];
num hunterCounter = 0;
List possibleEnemyRadar = List();

bool xIsXAndYIsY(List pos1, List pos2) {
    return (pos1[0] == pos2[0] && pos1[1] == pos2[1]);
}

List enemyRadarGuess = List();

removeEnemyRadar() {
    dt("-----------Remove nemy radar");

    for (int i = 0; i < enemyDigs.length; i++) {
        List enemyDig = enemyDigs[i];
        for (int j = 0; j < areaScans.length; j++) {
            dt("enemyDig :${enemyDig}");
            dt("areaScans[j] :${areaScans[j]}");

            if (enemyDig[0] > areaScans[j] && enemyDig[1] >= yRange[j][0] && enemyDig[1] <= yRange[j][1]) {
                enemyRadarGuess.add(enemyDig);
                areaScans[j] = enemyDig[0] + 3;
            }
        }
    }
}

List lastPosition = [];
List enemyItems = [];

void main() {
    List inputs;
    inputs = stdin.readLineSync().split(' ');
    int width = int.parse(inputs[0]);
    int height = int.parse(inputs[1]); // size of the map
    round = 0;
    enemyDigs = List();
    List robotsWithItem = [];

    // game loop
    while (true) {
        countEnemyInRows = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        myDeathCount = Map();
        enemyDeathCount = Map();
        safeYPosInFirstRow = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
        allDigs = List();
        //todo test
        //takenDigs = [];
        luckyPos = List();
        luckyTrapPos = List();
        //enemyConcentration = -1;
        //focusedOre = Map();
        dmgArea = List();
        dt("scoutCounter:$scoutCounter");

        oreList = List();
        inputs = stdin.readLineSync().split(' ');
        int myScore = int.parse(inputs[0]); // Amount of ore delivered
        int opponentScore = int.parse(inputs[1]);
        for (int i = 0; i < height; i++) {
            inputs = stdin.readLineSync().split(' ');
            //dt('$inputs');
            for (int j = 0; j < width; j++) {
                String ore = inputs[2 * j]; // amount of ore or "?" if unknown
                int hole = int.parse(inputs[2 * j + 1]); // 1 if cell has a hole
                if (j == 1 && hole == 1) {
                    safeYPosInFirstRow.remove(i - 1);

                    safeYPosInFirstRow.remove(i);
                    safeYPosInFirstRow.remove(i + 1);
                }
                if (ore != "?" && ore != "0") {
                    // && hole == 0){
                    oreList.add([j, i, ore]);
                }
                if (ore == "?" && hole == 0) {
                    // && hole == 0){
                    if (j >= 5 && j < 27 && i >= 2 && i < 12) {
                        luckyPos.add([j, i]);
                    }
                    if (j >= 1 && j < 3 && i >= 0 && i < 14) {
                        luckyTrapPos.add([j, i]);
                    }
                }
                if (hole == 1) {
                    allDigs.add([j, i]);
                }

                mapWithStateOfHole["${j}_${i}"] = hole;
            }
        }
        //  dt('aFTER safeYPosInFirstRow:$safeYPosInFirstRow');
        List foundDigs = [false, false, false];

        dt("possibleEnemyRadar:$possibleEnemyRadar");

        inputs = stdin.readLineSync().split(' ');
        int entityCount = int.parse(inputs[0]); // number of entities visible to you
        radarCooldown = int.parse(inputs[1]); // turns left until a new radar can be requested
        trapCooldown = int.parse(inputs[2]) * 2; // turns left until a new trap can be requested
        validRobotIds = List();
        myTraps = List();
        for (int i = 0; i < entityCount; i++) {
            inputs = stdin.readLineSync().split(' ');
            int id = int.parse(inputs[0]); // unique id of the entity
            int type = int.parse(inputs[1]); // 0 for your robot, 1 for other robot, 2 for radar, 3 for trap
            int x = int.parse(inputs[2]);
            int y = int.parse(inputs[3]); // position of the entity

            int item = int.parse(inputs[4]); // if this entity is a robot, the item it is carrying (-1 for NONE, 2 for RADAR, 3 for TRAP, 4 for ORE)

            if (type == 2) {
                //dt("####ENTITY: x:$x y:$y id:$id type:RADAR");

            } else if (type == 3) {
                //dt("####ENTITY: x:$x y:$y id:$id type:TRAP");
            }

            if (item == 3) {
                // trap
                myTraps.add([x, y]);

                safeYPosInFirstRow.remove(y - 1);
                safeYPosInFirstRow.remove(y);
                safeYPosInFirstRow.remove(y + 1);
            }
            if (round == 0) {
                if (type == 0) {
                    robots["$id"] = new Robot(id, "SCOUT", x, y, item);
                    validRobotIds.add("$id");
                }
                if (type == 1) {
                    //enemyRobot
                    enemyRobots["$id"] = new Robot(id, "SCOUT", x, y, item);
                    lastEnemyPositions["$id"] = [x, y];
                    for (String posState in ["${x}_${y}", "${x - 1}_${y}", "${x + 1}_${y}", "${x}_${y - 1}", "${x}_${y + 1}"]) {
                        lastStateOfEnemySurroundings[posState] = mapWithStateOfHole[posState];
                    }
                }
            } else {
                if (type == 0) {
                    Robot tmpBot = robots["$id"];
                    tmpBot.x = x;
                    tmpBot.y = y;
                    tmpBot.item = item;
                    //dt('myRobot $id AT x:$x y:$y item:$item');

                    if (x != -1) {
                        validRobotIds.add("$id");
                    }
                    robots["$id"] = tmpBot;
                }
                if (type == 1) {
                    //enemyRobot
                    Robot tmpBot = enemyRobots["$id"];
                    tmpBot.x = x;
                    tmpBot.y = y;
                    tmpBot.item = item;
                    enemyRobots["$id"] = tmpBot;
                    //enemyYs.add(y);
                    if (y > -1) {
                        countEnemyInRows[y] += 1;
                    }
                    //dt('enemy $id AT x:$x y:$y item:$item');
                    //SCAN FOR ENEMY DIG
                    lastPosition = lastEnemyPositions["$id"];
                    //  if(lastPosition[0] == 0 && x == 0 ){
                    //robot gets item
                    //      robotsWithItem.add(tmpBot);
                    //  }
                    if (lastPosition[0] == x && lastPosition[1] == y) {
                        //robot digs item
                        if (x == 0) { //charge robot with radar or trap REMEMBER first charge at 0 charge second is dropping
                            stderr.writeln('robot receives item');
                            chargedEnemy["${id}"] = true;
                        } else if (chargedEnemy["${id}"] == true && x != 0) {
                            stderr.writeln('robot digs item');
                            enemyItems.add([x,y]);
                            for (List posStateList in [
                                [x, y],
                                [x - 1, y],
                                [x+1, y],
                                [x, y - 1],
                                [x, y + 1]
                            ]) {
                                if (posStateList[0] >= 1 && !posInsideList(posStateList, enemyItems)) {
                                    enemyItems.add(posStateList);
                                    stderr.writeln('!!!!!!!!!1ENEMY ITEM AT:$posStateList');
                                }
                                dt('chargedEnemy:$chargedEnemy');
                            }
                            chargedEnemy["${id}"] = false;
                        }
                    }
                    lastEnemyPositions["$id"] = [x, y];

                }
            }
            //dt('robots:$robots');
        }
        stderr.writeln('!!!!!!!!!1ENEMY ITEM AT:$enemyItems');
        for (num i = 0; i < myActiveTraps.length; i++) {
            bool trapStillActive = false;
            for (List trap in myTraps) {
                if (xIsXAndYIsY(myActiveTraps[i], trap)) {
                    trapStillActive = true;
                }
            }
            if (!trapStillActive) {
                myActiveTraps.removeAt(i);
            }
        }
        for (List activeTrap in myActiveTraps) {
            dmgArea.add(activeTrap);
            stderr.writeln("activeTrap $activeTrap");
            num activeTrapX = activeTrap[0];
            num activeTrapY = activeTrap[1];
            dmgArea.add([activeTrapX - 1, activeTrapY]);
            dmgArea.add([activeTrapX + 1, activeTrapY]);
            dmgArea.add([activeTrapX, activeTrapY - 1]);
            dmgArea.add([activeTrapX, activeTrapY + 1]);

            dmgArea.add([activeTrapX - 1, activeTrapY-1]);
            dmgArea.add([activeTrapX + 1, activeTrapY-1]);
            dmgArea.add([activeTrapX-1, activeTrapY + 1]);
            dmgArea.add([activeTrapX + 1 , activeTrapY + 1]);
        }

        for (String enemyKey in enemyRobots.keys.toList()) {
            Robot tmpRobot = enemyRobots[enemyKey];
            if (posInsideList([tmpRobot.x, tmpRobot.y], dmgArea)) {
                enemyDeathCount['${tmpRobot.id}'] = true;
            }
        }

        for (String myKey in robots.keys.toList()) {
            Robot tmpRobot = robots[myKey];
            if (posInsideList([tmpRobot.x, tmpRobot.y], dmgArea)) {
                myDeathCount['${tmpRobot.id}'] = true;
            }
        }
        dt('DMGAREA:$dmgArea');
        dt('myDeathCount:$myDeathCount');
        dt('enemyDeathCount:$enemyDeathCount');
        dt('myTraps:$myTraps');

        dt("validRobotIds:$validRobotIds ");
        scoutCounter = 0;
        hunterCounter = 0;
        strikerCounter = 0;
        sniperCounter = 0;
        for (int i = 0; i < validRobotIds.length; i++) {
            Robot bot = robots[validRobotIds[i]];
            if (bot.role == "SCOUT") {
                scoutCounter += 1;
            }
            if (bot.role == "HUNTER") {
                hunterCounter += 1;
            }
            if (bot.role == "STRIKER") {
                strikerCounter += 1;
            }
            if (bot.role == "SNIPER") {
                sniperCounter += 1;
            }
        }
        dt("hunterCounter:$hunterCounter ");
        dt("strikerCounter:$strikerCounter ");
        dt("scoutCounter:$scoutCounter ");
        stderr.writeln("sniperCounter:$sniperCounter ");

        if (enemyConcentration == -1) {
            for (int i = 1; i < countEnemyInRows.length - 1; i++) {
                if (countEnemyInRows[i] + countEnemyInRows[i - 1] + countEnemyInRows[i + 1] >= enemyConcentrationCount) {
                    enemyConcentration = i;
                    if (enemyConcentration < 5) {
                        //radarPos = radarTopBottom;
                        hunterField = hunterFieldTop;
                        //hunterField = new List.from(hunterFieldTop)..addAll(hunterFieldMiddle)..addAll(hunterFieldBottom);
                    } else if (enemyConcentration >= 5 && enemyConcentration <= 8) {
                        //radarPos = radarBottomTop;
                        hunterField = hunterFieldMiddle;
                        //hunterField = new List.from(hunterFieldMiddle)..addAll(hunterFieldTop)..addAll(hunterFieldBottom);
                    } else {
                        //radarPos = radarBottomTop;
                        hunterField = hunterFieldBottom;
                        //hunterField = new List.from(hunterFieldTop)..addAll(hunterFieldMiddle)..addAll(hunterFieldBottom);
                    }
                }
            }
        }

        //removeEnemyRadar();
        //dt("enemyRadarGuess:$enemyRadarGuess");

        var botKeys = robots.keys.toList();
        round += 1;
        // List agents = ["SCOUT","MINER","MINER","MINER","MINER"];
        for (int i = 0; i < botKeys.length; i++) {
            Robot bot = robots[botKeys[i]];
            /*if(round == 1){
                scoutCounter=1;
                dt('setting agent role ${agents[i]}');
                bot.role = agents[i];
            }*/
            dt('bot.role == ${bot.role} radarPos not empty:${radarPos.isNotEmpty} oreList.length:${oreList.length} scoutCounter: ${scoutCounter}');
            if (bot.role == "MINER" && radarPos.isNotEmpty && validOreList.length < oreLimit && scoutCounter < 1 && bot.x != -1) {
                dt('bot $bot radarPos not empty:${radarPos.isNotEmpty} oreList.length:${oreList.length} scoutCounter: ${scoutCounter}');

                activateScoutClosestToBase();
            }
            if (false && bot.role == "MINER" && sniperCounter < 1 && bot.x != -1) {
                stderr.writeln("switch to sniper");
                bot.addSniper();
            }

            /*if (activateStriker) {
        if (bot.role != "SCOUT" &&hunterField.isNotEmpty && strikerCounter == 0 && bot.x != -1) {
          dt("!!!!!!!!!!!!!!!!activateStriker");
          bot.role = "STRIKER";
          strikerCounter = 1;
        }
      } else {

      }*/

            if (validRobotIds.length > 4 && enemyConcentration > -1 && round < 20 && bot.role != "SCOUT"
                /*&&hunterField.isNotEmpty*/
                && hunterCounter == 0 && bot.x != -1) {
//            bot.role = "HUNTER";
//            hunterCounter = 1;
            }
            print(bot.act());
        }
        // for (int i = 0; i < 4/*5*/; i++) {

        // Write an action using print()
        // To debug: dt('Debug messages...');

        //        print('WAIT'); // WAIT|MOVE x y|DIG x y|REQUEST item
        //  }

    }
}

num getDistance(List me, List entity) {
    num result = 0;
    result = (me[0] - entity[0]).abs() + (me[1] - entity[1]).abs();
    return result;
}

num getMDistance(List me, List entity) {
    num result = 0;
    num powX = pow((entity[0] - me[0]), 2);
    num powY = pow((entity[1] - me[1]), 2);
    result = sqrt(powX + powY);
    return result;
}

List getNewDistanceInlineIfCloser(List myRobot, List goal, num shortestDistance, List nearestPoint) {
    num tmpDistance = getDistance([myRobot[0], myRobot[1]], goal);
    if (tmpDistance < shortestDistance) {
        // dt('not in focus already');
        shortestDistance = tmpDistance;
        nearestPoint = goal;
    }
    return [shortestDistance, nearestPoint];
}

List getBestPos(List pos, List posList) {
    num shortestDistance = 9999;
    List nearestPoint = List();
    for (List tmpPos in posList) {
        bool isEnemyDig = posInsideList(tmpPos, enemyDigs);
        bool isEnemyItem = posInsideList(tmpPos, enemyItems);
        bool isTrap = posInsideList(tmpPos, dmgArea);
        if (!isEnemyItem && !isEnemyDig && !isTrap) {
            List distanceSet = getNewDistanceInlineIfCloser(
                //pos,
                [0, pos[1]],
                        tmpPos,
                        shortestDistance,
                        nearestPoint);
            shortestDistance = distanceSet[0];
            nearestPoint = distanceSet[1];
        }
    }

    return nearestPoint;
}

activateScoutClosestToBase() {
    int closestPos = 99999;
    Robot closestBot = null;
    var botKeys = robots.keys.toList();
    // List agents = ["SCOUT","MINER","MINER","MINER","MINER"];
    for (int i = 0; i < botKeys.length; i++) {
        Robot bot = robots[botKeys[i]];
        if (bot.x != -1 && bot.x < closestPos) {
            closestPos = bot.x;
            closestBot = bot;
        }
    }

    closestBot.switchToScout();
}

bool posInsideList(List pos, List posList) {
    bool isInsideList = false;
    if (pos.isNotEmpty) {
        for (List listPos in posList) {
            if (listPos.isNotEmpty) {
                if (xIsXAndYIsY(pos, listPos)) {
                    isInsideList = true;
                    break;
                }
            } else {
                //dt("______CHECK WHY listpos EMPTY ARRAY ????");
            }
        }
    } else {
        //dt("______CHECK WHY EMPTY ARRAY ????");
    }

    return isInsideList;
}

class Robot {
    int id;
    int item;
    String role = "MINER"; //scout trapper miner

    int x;
    int y;

    bool getRadar = true;
    bool buryRadar = false;

    bool getOre = true;
    bool returnOre = false;

    bool getEnemyPos = true;
    //  bool getEnemyPos = true;

    bool goToMarkingPos = true;
    bool markWithDig = false;
    List markingGoal = List();

    bool readyToDropStrikerTrap = false;
    bool strike = false;

    //bool returnOre=false;
    int hunterCounter = 0;

    Robot(this.id, this.role, this.x, this.y, this.item);

    List getLuckyPos() {
        num shortestDistance = 9999;
        List nearestPoint = List();
        for (List pos in luckyPos) {
            List distanceSet = getNewDistanceInlineIfCloser(
                    [x, y],
                    //[0, pos[1]],
                    pos,
                    shortestDistance,
                    nearestPoint);
            shortestDistance = distanceSet[0];
            nearestPoint = distanceSet[1];
        }

        return nearestPoint;
    }

    List getClosestOre() {
        dt('getClosestOre');
        num shortestDistance = 9999;
        List nearestPoint = List();
        List keys = focusedOre.keys.toList();
        dt('focusedOre : $focusedOre');
        dt('focusedOre : ${focusedOre[id]}');
        //dt('enemyDigs : $enemyDigs');
        validOreList = List();
        for (int i = 0; i < oreList.length; i++) {
            List ore = oreList[i];
            //dt('shortestOreDistance = $shortestDistance');
            List tmpList = List();
            tmpList = enemyDigs;
            bool isEnemyDig = posInsideList(ore, tmpList);
            bool isEnemyItem = posInsideList(ore, enemyItems );

            bool isTrap = posInsideList(ore, dmgArea);
            bool isTaken = posInsideList(ore, takenDigs);
            if (!isEnemyItem && !isEnemyDig && !isTrap && !isTaken) {
                validOreList.add(oreList[i]);
            }
        }
        bool findClosestOre = false;

        List focusedPos = focusedOre[id];

        if (focusedPos == null || focusedPos == [] || focusedPos != null && focusedPos.isNotEmpty && !posInsideList(focusedPos, oreList)) {
            findClosestOre = true;
        }
        dt('focusPos1 :$focusedPos ');
        if (focusedPos != null && focusedPos.isNotEmpty) {
            dt('focusPos2 :$focusedPos ');
            nearestPoint = focusedPos;
        } else {
            findClosestOre = true;
        }
        if (findClosestOre) {
            for (List pos in validOreList) {
                List distanceSet = getNewDistanceInlineIfCloser(
                        [x, y],
                        //[0, pos[1]],
                        pos,
                        shortestDistance,
                        nearestPoint);
                shortestDistance = distanceSet[0];
                nearestPoint = distanceSet[1];
            }
        }
        focusedOre[id] = nearestPoint;
        dt('nearest be4 pil : ${nearestPoint} taken $takenDigs');
        bool pil = posInsideList(nearestPoint, takenDigs);
        dt('pil : $pil');
        if (!pil) {
            takenDigs.add(nearestPoint);
        }
        dt('takenDigs1 : $takenDigs');
        dt('takenDigs orePos : ${nearestPoint}');
        return nearestPoint;
    }

    List getClosestOre2() {
        stderr.writeln('getClosestOre2');
        stderr.writeln('dmgArea $dmgArea');
        num shortestDistance = 9999;
        List nearestPoint = List();
        List keys = focusedOre.keys.toList();
        dt('focusedOre : $focusedOre');
        dt('focusedOre : ${focusedOre[id]}');
        //dt('enemyDigs : $enemyDigs');
        validOreList = List();
        for (int i = 0; i < oreList.length; i++) {
            List ore = oreList[i];
            //dt('shortestOreDistance = $shortestDistance');
            List tmpList = List();
            tmpList = enemyDigs;
            bool isEnemyDig = posInsideList(ore, tmpList);
            bool isEnemyItem = posInsideList(ore, enemyItems);

            bool isTrap = posInsideList(ore, dmgArea);
            bool isTaken = posInsideList(ore, takenDigs);
            if ((ore[2] == "2" /*|| ore[2] == "3" */)&&!isEnemyItem  && !isEnemyDig && !isTrap && !isTaken) {
                validOreList.add(oreList[i]);
            }
        }
        bool findClosestOre = false;

        List focusedPos = focusedOre[id];

        if (focusedPos == null || focusedPos == [] || focusedPos != null && focusedPos.isNotEmpty && !posInsideList(focusedPos, oreList)) {
            findClosestOre = true;
        }
        dt('focusPos1 :$focusedPos ');
        if (focusedPos != null && focusedPos.isNotEmpty) {
            dt('focusPos2 :$focusedPos ');
            nearestPoint = focusedPos;
        } else {
            findClosestOre = true;
        }
        if (findClosestOre) {
            for (List pos in validOreList) {
                List distanceSet = getNewDistanceInlineIfCloser(
                        [x, y],
                        //[0, pos[1]],
                        pos,
                        shortestDistance,
                        nearestPoint);
                shortestDistance = distanceSet[0];
                nearestPoint = distanceSet[1];
            }
        }
        focusedOre[id] = nearestPoint;
        dt('nearest be4 pil : ${nearestPoint} taken $takenDigs');
        bool pil = posInsideList(nearestPoint, takenDigs);
        dt('pil : $pil');
        if (!pil) {
            takenDigs.add(nearestPoint);
        }
        dt('takenDigs1 : $takenDigs');
        dt('takenDigs orePos : ${nearestPoint}');
        return nearestPoint;
    }

    List getOreClosestToBase() {
        dt('getOreClosestToBase');
        dt('focusedOre : ${focusedOre[id]}');
        dt('focusedOre : ${focusedOre}');
        validOreList = List();
        for (int i = 0; i < oreList.length; i++) {
            List ore = oreList[i];

            bool isTaken = posInsideList(ore, takenDigs);
            if (!isTaken) {
                validOreList.add(oreList[i]);
            }
        }
        int distanceFromBase = 999;
        List foundOre = [];
        for (List pos in validOreList) {
            if (pos[0] < distanceFromBase) {
                distanceFromBase = pos[0];
                foundOre = pos;
            }
        }
        focusedOre["$id"] = foundOre;
        dt('closestOre found : $foundOre');
        return foundOre;
    }

    String act() {
        String action = "WAIT";

        if (x == -1) {
            action = "WAIT DEAD";
        } else {
            dt('######################################################');
            dt('############start action for Robot $id ###############');
            if (startGoal.isNotEmpty) {
                action = "MOVE ${startGoal[0] + 1} ${y + 1} STARTGOAL";
            } else {
                action = "WAIT manual";
                if (true) {
                    List orePos = getBestPos([x, y], luckyPos);
                    //bool isInFocused = isInsideList(orePos, focusedPos);
                    if (orePos.isNotEmpty) {
                        if (x != (orePos[0] ) || y != orePos[1]) {
                            action = "MOVE ${orePos[0]} ${orePos[1]} GOTO Lucky";
                        } else {
                            action = "DIG ${x} $y Lucky DIG ";
                            myDigs.add([x, y]);
                        }
                    } else {
                        switchToMiner();
                    }
                }
            }

            dt('x:$x y:$y role:$role');

            dt('safeYPosInFirstRow:$safeYPosInFirstRow');

            //dt('enemyDigs:$enemyDigs');
            int safeY = 0;
            int bestY = 0;

            if (safeYPosInFirstRow.isNotEmpty) {
                safeY = safeYPosInFirstRow[rng.nextInt(safeYPosInFirstRow.length)];
                bestY = 0;
                int distanceY = 9999;
                for (int i = 0; i < safeYPosInFirstRow.length; i++) {
                    num tmpDistance = (y - safeYPosInFirstRow[i]).abs();
                    if (tmpDistance <= distanceY) {
                        distanceY = tmpDistance;
                        bestY = safeYPosInFirstRow[i];
                        //dt('bestY:$bestY');
                    }
                }
            } else {
                bestY = y;
            }
            //safeYPosInFirstRow.remove(bestY);
            if (role == "SCOUT") {
                dt('scout');
                //1.check if radar spot is free
                if (radarPos.isNotEmpty && validOreList.length < oreLimit) {
                    // if(radarPos.isNotEmpty){
                    //2.GoTo headquater
                    dt('check if radar spot is free');
                    if (getRadar) {
                        if (x > 0) {
                            //if not at headquater
                            dt('GoTo headquater');
                            action = "MOVE 0 $y GOTO HEADQUATER";
                        } else {
                            //if at headquater
                            //3.Get Radar
                            dt('Get Radar');
                            if (radarCooldown == 0) {
                                action = "REQUEST RADAR GET RADAR";
                                getRadar = false;
                                buryRadar = true;
                                radarCooldown = 99;
                            } else {
                                switchToMiner();
                            }
                        }
                    }
                    if (item == 2 && buryRadar) {
                        List goalPos = radarPos[0];
                        dt('BURY RADAR AT $goalPos');
                        //4.Get position to place radar
                        bool isBadPos = posInsideList(goalPos, enemyDigs);
                        if (isBadPos) {
                            goalPos = getBestPos([x, y], luckyPos);
                            dt('goalPos : $goalPos');
                        }

                        if (x != goalPos[0] || y != goalPos[1]) {
                            //if not at bury spot
                            action = "MOVE ${goalPos[0]} ${goalPos[1]} GOTO RADARBURY SPOT";
                            //startGoal = goalPos;
                        } else {
                            //5.Bury Radar
                            action = "DIG ${x} $y BURY RADAR";
                            myDigs.add([x, y]);
                            radarPos.removeAt(0);
                            dt('radarPos : $radarPos');
                            getRadar = true;
                            buryRadar = false;
                            switchToMiner();
                        }
                    }
                } else {
                    //switch to miner
                    switchToMiner();
                }
            } else if (role == "MINER") {
                dt('miner');
                //1.get Closest ore pos
                if (item == 4) {
                    if (x != 0) {
                        //if not at headquater
                        dt('goTo headquater');
                        action = "MOVE 0 $bestY RETURN ORE";
                    } else {
                        action = "WAIT again ;)";
                    }
                } else {
                    dt('check if found ore');
                    if (oreList.isNotEmpty) {
                        if (getOre) {
                            List orePos =[];
                            if (item == 3) {
                                orePos = getClosestOre2();
                            }else{
                                orePos = getClosestOre();
                            }


                            //List orePos = getOreClosestToBase();
                            if (orePos.isNotEmpty) {
                                if (x != (orePos[0] ) || y != orePos[1]) {
                                    //if not at ore
                                    if (x == 0) {
                                        if (round > 5 && item == -1 && trapCooldown == 0) {
                                            dt('miner load trap');
                                            action = "REQUEST TRAP RadarMINer";
                                            trapCooldown = 200;
                                        } else if (false && round > 100 && item == -1 && radarCooldown == 0) {
                                            dt('miner load radar');
                                            action = "REQUEST RADAR GET RADAR";
                                            radarCooldown = 99;
                                        } else {
                                            action = "MOVE ${orePos[0] } ${orePos[1]} GOTO ORE";
                                        }
                                    } else {
                                        action = "MOVE ${orePos[0] } ${orePos[1]} GOTO ORE";
                                    }
                                } else {
                                    //if at ore//3.Get Ore
                                    if (item == 3) {
                                        myActiveTraps.add([x, y]);
                                        enemyItems.add([x,y]);
                                    }
                                    dt('Get Ore robot:$id');
                                    action = "DIG ${x} $y DIG ORE";
                                    myDigs.add([x, y]);
                                    dt('takenDigsBe4 remove : $takenDigs');
                                    dt('takenDigs xy : ${[x, y]}');
                                    int index = getIndexOfPositionInList([x, y], takenDigs);
                                    dt('index: $index');
                                    if (index > -1) {
                                        takenDigs.removeAt(index);
                                    }
                                    focusedOre[id] = [];

                                    dt('takenDigsafter remove : $takenDigs');
                                    getOre = false;
                                    returnOre = true;
                                }
                            } else {
                                //if at ore
                                switchToMiner();
                                //action = "MOVE ${x+4} ${y} LUCKY START";
                            }
                        }
                        if (item == -1 && returnOre) {
                            //5.Bury Radar
                            dt('Ore Returned');
                            getOre = true;
                            returnOre = false;
                        }
                    } else {
                        //switch to miner
                        switchToMiner();
                    }
                    dt('item:$item ');
                }
            } else if (role == "SNIPER") {
                stderr.writeln("Im the Sniper, enemy Items ${enemyItems.length}");
                if (enemyItems.length > 0) {
                    if (x != (enemyItems[0][0]) || y != enemyItems[0][1]) {
                        stderr.writeln('move TO POSSIBLE RADAR FOR RADAR');

                        action = "MOVE ${enemyItems[0][0] } ${enemyItems[0][1]} MOVE TO POSS RADAR";
                    } else {
                        stderr.writeln('DIG FOR POSSIBLE RADAR');
                        action = "DIG ${x} $y DIG RADAR";
                        myDigs.add([x, y]);
                        enemyItems.removeAt(0);
                    }
                }
            }
            else if (role == "HUNTER") {
                dt('hunter');
                //1.get Closest ore pos
                //find enemyConcentration
                num shortestDistance = 9999;
                List nearestPoint = List();
                dt('myActiveTraps:$myActiveTraps');
                dt('dmgArea:$dmgArea');
                for (List trap in myActiveTraps) {
                    List distanceSet = getNewDistanceInlineIfCloser(
                            [x, y],
                            //[0, pos[1]],
                            trap,
                            shortestDistance,
                            nearestPoint);
                    shortestDistance = distanceSet[0];
                    nearestPoint = distanceSet[1];
                } //check for early detonation

                if (enemyDeathCount.keys
                            .toList()
                            .length > myDeathCount.keys
                            .toList()
                            .length &&
                    enemyDeathCount.keys
                            .toList()
                            .length >= whishedEnemyDeath &&
                    shortestDistance <= 1) {
                    action = "DIG ${nearestPoint[0]} ${nearestPoint[1]} !!!!!";
                    // enemyConcentrationCount -= 1;
                    activateStriker = activateStrikerValue;
                } else {
                    dt('DMGAREA:$dmgArea');
                    if (hunterField.isNotEmpty) {
                        //
                        if (item != 3) {
                            action = "REQUEST TRAP REQUEST TRAP";
                        } else {
                            //buildTrap
                            List goodPos = List();
                            List concentratedPos = hunterField[0]; //[hunterField[0][0],enemyConcentration];
                            bool isActiveTrap = posInsideList(concentratedPos, myActiveTraps);
                            bool isEnemyDig = posInsideList(concentratedPos, enemyDigs);

                            if (isActiveTrap || isEnemyDig) {
                                goodPos = getBestPos(concentratedPos, luckyTrapPos);
                            } else {
                                goodPos = concentratedPos;
                            }
                            if (enemyRadarGuess.isNotEmpty) {
                                goodPos = enemyRadarGuess[0];
                            } else {
                                goodPos = hunterField[0];
                            }

                            if (x != goodPos[0] || y != goodPos[1]) {
                                //if not at ore
                                //dt('GoTo build');
                                action = "MOVE ${goodPos[0]} ${goodPos[1]} build";
                            } else {
                                //if at ore
                                if (enemyRadarGuess.isNotEmpty) {
                                    // goodPos = enemyRadarGuess[0];
                                    enemyRadarGuess.removeAt(0);
                                } else {
                                    //  goodPos = hunterField[0];
                                    hunterField.removeAt(0);
                                }
                                dt('Dig trap');
                                action = "DIG $x $y DIG build";
                                myActiveTraps.add([x, y]);
                                myDigs.add([x, y]);
                                strikePosition = [x, y];

                                dmgArea.add([x, y]);
                                dmgArea.add([x - 1, y]);
                                dmgArea.add([x + 1, y]);
                                dmgArea.add([x, y - 1]);
                                dmgArea.add([x, y + 1]);
                            }
                        }
                    } else {
                        //wait to detonate
                        if (enemyDeathCount.keys
                                    .toList()
                                    .length > myDeathCount.keys
                                    .toList()
                                    .length) {
                            action = "DIG ${strikePosition[0]} ${strikePosition[1]} DETONATION";
                            enemyConcentrationCount += 1;
                            activateStriker = activateStrikerValue;
                        } else {
                            action = "MOVE ${x} ${y} build moveToConcentration";
                        }
                        //if at ore

                    }
                }
            } else if (role == "STRIKER") {
                dt('striker');
                //1.get Closest ore pos
                //find enemyConcentration
                var enemyToExtinct = null;
                for (String enemyKey in enemyRobots.keys.toList()) {
                    Robot tmpRobot = enemyRobots[enemyKey];
                    if (tmpRobot.x != -1) {
                        enemyToExtinct = tmpRobot;
                        break;
                    }
                }
                if (enemyToExtinct == null) {
                    switchToMiner;
                } else {
                    if (item != 3) {
                        action = "REQUEST TRAP REQUEST TRAP To STRIKE";
                    } else {
                        //trap can be dropen if at position
                        if (strike) {
                            //hit

//wait to detonate
                            bool canBeExtinct = false;
                            for (String enemyDeathKey in enemyDeathCount.keys.toList()) {
                                if (enemyDeathKey == "${enemyToExtinct.id}") {
                                    canBeExtinct = true;
                                    break;
                                }
                            }
                            if (canBeExtinct) {
                                action = "DIG 1 ${y} DIG EXTINCTION";
                                enemyConcentrationCount += 1;
                            } else {
                                action = "WAIT WAIT TO TERMINATE";
                            }
                        } else {
                            if (y == enemyToExtinct.y && enemyToExtinct.y == lastEnemyPositions["${enemyToExtinct.id}"][1]) {
                                //at position x=0 and y = enemy && last enemy.y == enemynow.y
                                action = "DIG 1 ${y} Bury STRIKER";
                                strike = true;
                            } else {
                                //get Trap
                                action = "MOVE 0 ${enemyToExtinct.y} build moveToSTRIKE";
                            }
                        }
                    }
                }
            }
        }

        return action;
    }

    int getIndexOfPositionInList(pos, list) {
        int foundPosition = -1;

        for (int i = 0; i < list.length; i++) {
            List lPos = list[i];
            if (pos.isNotEmpty && lPos.isNotEmpty && pos[0] == lPos[0] && pos[1] == lPos[1]) {
                foundPosition = i;
                break;
            }
        }
        return foundPosition;
    }

    void addHunter() {
        if (role != "HUNTER") {
            hunterCounter += 1;
            role = "HUNTER";
        }
    }

    void removeHunter() {
        if (role == "HUNTER") {
            hunterCounter -= 1;
            role = "";
        }
    }

    void addScout() {
        if (role != "SCOUT") {
            scoutCounter += 1;
            dt("addScout");
            dt("scoutCounter:$scoutCounter ");
            role = "SCOUT";
            getRadar = true;
            buryRadar = false;
        }
    }

    void addSniper() {
        if (role != "Sniper") {
            sniperCounter += 1;
            dt("addSniper");
            dt("sniperCounter:$sniperCounter");
            role = "SNIPER";
        }
    }

    void removeScout() {
        if (role == "SCOUT") {
            scoutCounter -= 1;
            role = "";
        }
    }

    void switchToMiner() {
        removeHunter();
        removeScout();
        role = "MINER";
        getOre = true;
        returnOre = false;
    }

    void switchToScout() {
        removeHunter();
        addScout();
    }

    void switchToSniper() {
        addSniper();
    }
}

