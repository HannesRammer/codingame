import 'dart:io';
import 'dart:math';
import 'dart:convert';

List unseenFields = [];
List enemyPacs = [];
List pellets = [];
Map seenPellets = {};
Map visiblePosFromXY = {};
List placesVisited = [];
Pac myPac = null;
List myPacs = [];
List texts = [];
Map textsMap = {};
List excludedPellets = [];
var rng = new Random();

void printMap() {
  //.dtxt("seenPellets.length ${seenPellets.length} ");
  for (int y = 0; y < map.length; y++) {
    String row = map[y];
    List rowList = [];
    for (int x = 0; x < row.length; x++) {
      String field = row[x];
      //.dtxt("seenPellets[${x} ${seenPellets['${x} ${y}']} ");
      if (bigfoodList.indexOf("${x} ${y}") > -1) {
        rowList.add('B');
      } else if (unseenFields.indexOf("${x} ${y}") > -1) {
        rowList.add('?');
      } else if (seenPellets["${x} ${y}"] != null) {
        rowList.add('*');
      } else {
        rowList.add(field);
      }
    }
    String newRow = rowList.join("");
    dtxt(newRow);
  }
}

List getVisibleFieldsForPos(int x, int y) {
  List tmpList = [];
  //Left
  int counter = 0;
  String field = " ";
  while (field == " ") {
    counter++;
    int xLeft = x - counter;
    //.dtxt("xLeft ${xLeft}");
    if (xLeft > -1) {
      field = map[y][xLeft];
      if (field == " ") {
        tmpList.add([xLeft, y]);
      }
    } else {
      field = "x";
    }
  }

  //Right
  counter = 0;
  field = " ";
  while (field == " ") {
    counter++;
    int xRight = x + counter;
    if (xRight < width) {
      field = map[y][xRight];
      if (field == " ") {
        tmpList.add([xRight, y]);
      }
    } else {
      field = "x";
    }
  }
  //Up
  counter = 0;
  field = " ";
  while (field == " ") {
    counter++;
    int yUp = y - counter;
    if (yUp > -1) {
      field = map[yUp][x];
      if (field == " ") {
        tmpList.add([x, yUp]);
      }
    } else {
      field = "x";
    }
  }
  //Down
  counter = 0;
  field = " ";
  while (field == " ") {
    counter++;
    int yDown = y + counter;
    if (yDown < height) {
      field = map[yDown][x];
      if (field == " ") {
        tmpList.add([x, yDown]);
      }
    } else {
      field = "x";
    }
  }
  tmpList.add([x, y]);

  //.dtxt("tmpList x${x} y${y} ${tmpList}");
  //.dtxt(tmpList);
  return tmpList;
}

class Pac {
  int id;
  bool ignoreGoal = false;
  int x;
  int y;
  int abilityCooldown;
  int speedTurnsLeft;
  List goal = [];
  String type;
  String current;
  bool moved = false;
  int xStart = 0;
  int xEnd = 999;
  bool hasSwitched = false;

  Pac(this.id, this.x, this.y, this.speedTurnsLeft, this.abilityCooldown, this.type);

  Map<String, dynamic> toJson() => {
    'id': id,
    'x': x,
    'y': y,
    'xStart': xStart,
    'xEnd': xEnd,
  };
}

List remove_pellet_from_list(Pellet pellet, List list) {
  int index = getIndexOfPositionInList(pellet, list);

  if (index > -1) {
    list.removeAt(index);
    dtxt("remove_pellet_from_list at $index");
  }
  ;
  return list;
}

int getIndexOfPositionInList(Pellet pellet, List list) {
  int foundPosition = -1;

  for (int i = 0; i < list.length; i++) {
    Pellet listPellet = list[i];
    if (pellet != null && listPellet != null && pellet.x == listPellet.x && pellet.y == listPellet.y) {
      foundPosition = i;
      break;
    }
  }
  stderr.writeln("foundPosition $foundPosition");
  return foundPosition;
}

class Pellet {
  int x;
  int y;
  int value;

  Pellet(this.x, this.y, this.value);
}

List map = [];
List goals = [];
List ignoredFields = [];
Map lastPos = {};
List bigfood = [];
List bigfoodList = [];
int width = 0;
int height = 0;
int round = 0;

Pellet getDefaultPelletForPac(myPac) {
  if (myPac.id == 0) {
    return Pellet(5, 5, 0);
  }
  if (myPac.id == 1) {
    return Pellet(3, 10, 0);
  }
  if (myPac.id == 2) {
    return Pellet(15, 5, 0);
  }
  if (myPac.id == 3) {
    return Pellet(20, 6, 0);
  }
  if (myPac.id == 4) {
    return Pellet(25, 11, 0);
  }
}

void main() {
  List inputs;
  inputs = stdin.readLineSync().split(' ');
  width = int.parse(inputs[0]); // size of the grid
  height = int.parse(inputs[1]); // top left corner is (x=0, y=0)
  for (int i = 0; i < height; i++) {
    String row = stdin.readLineSync(); // one line of the grid: space " " is floor, pound "#" is wall
    for (int j = 0; j < row.length; j++) {
      if (row[j] == " ") {
        unseenFields.add("${j} ${i}");
        //.dtxt("add x${j} y${i} to unseen");
      }
    }
    map.add(row);
    //.dtxt(row);
  }

  // game loop
  excludedPellets = [];
  while (true) {
    inputs = stdin.readLineSync().split(' ');
    int myScore = int.parse(inputs[0]);
    int opponentScore = int.parse(inputs[1]);
    int visiblePacCount = int.parse(stdin.readLineSync()); // all your pacs and enemy pacs in sight
    myPac = null;
    //safe last positions of pacs
    storePosAsNextRoundsLastPos();

    enemyPacs = [];
    inputs = extractMyAndEnemyPacs(visiblePacCount, inputs);
    setXRangeForBot();
    //check if pac moved
    checkIfPacMoved();
    int visiblePelletCount = int.parse(stdin.readLineSync()); // all pellets in sight
    pellets = [];
    bigfood = [];
    dtxt("round ${round} visiblePelletCount ${visiblePelletCount} ");
    storeSeenBigAndPellets(visiblePelletCount, inputs);
    for (int i = 0; i < myPacs.length; i++) {
      List visibleFields = getVisibleFieldsForPos(myPacs[i].x, myPacs[i].y);
      for (int j = 0; j < visibleFields.length; j++) {
        List pos = visibleFields[j];
        if (pos != []) {
          unseenFields.remove("${pos[0]} ${pos[1]}");

          //.dtxt("remove from unseenFields ${pos[0]} ${pos[1]}");
          //.dtxt(" unseenFields.length ${unseenFields.length}");
          //TODO
          seenPellets.remove("${pos[0]} ${pos[1]}");
          for (int k = 0; k < pellets.length; k++) {
            Pellet pellet = pellets[k];
            if (pellet != null && pellet.x == pos[0] && pellet.y == pos[1]) {
              seenPellets["${pellet.x} ${pellet.y}"] = pellet;
              //.dtxt("pellet.x == pos[0] && pellet.y == pos[1] ${pellet.x == pos[0]} && ${pellet.y == pos[1]}");
              //.dtxt("test1 ${pellet.x} ${pellet.y}");
            }
          }
        }
      }
      seenPellets.remove("${myPacs[i].x} ${myPacs[i].y}");
    }
    List seen = seenPellets.values.toList();
    texts = [];
    textsMap = {};
    //dtxt('seenPellets ${seenPellets.length}');
    //dtxt('pellets ${pellets.length} ${pellets}');
    //dtxt('seen.length ${seen.length} ${seen}');
    //dtxt('unseenseen.length ${unseenFields.length} ${unseenFields}');
    goals = [];
    ignoredFields = [];
    for (int i = 0; i < myPacs.length; i++) {
      myPac = myPacs[i];
      if(myPac.goal.isNotEmpty && myPac.goal[0] == "${myPac.x} ${myPac.y}"){
        myPac.goal = [];
        dtxt('reset Goal for pac id:${myPac.id}');
      }
      String text;
      if (true || myPac.goal.isEmpty) {
        dtxt('--------EMPTY Goal for pac id:${myPac.id}');
        List visibleFields = getVisibleFieldsForPos(myPacs[i].x, myPacs[i].y);
        bool pacSeesPellet = false;
        for (int j = 0; j < visibleFields.length; j++) {
          pacSeesPellet = seenPellets[visibleFields[j]] != null;
          if (pacSeesPellet == true) {
            break;
          }
        }
        dtxt('##########START MOVE FOR MYPAC ID:${myPac.id}########');
        dtxt('startX:${myPac.xStart} endX:${myPac.xEnd}');
        //.dtxt('myPac ${myPac.id}');
        Pellet pellet = null;

        bool goToUnseen = false;
        List tmpField = null;
        List newList = unseenFields;
        if (pellet == null) {
          pellet = getPelletOrSeenPellet(pacSeesPellet, pellet, seen);
        }
        if (pellet == null) {
          //pellet = getClosestPellet2(myPac.x, myPac.y, unseenFields);
          tmpField = getClosestUnknownInRange(myPac.x, myPac.y, unseenFields, -1);
          //tmpField = getClosestUnknownInRange(myPac.x, myPac.y, unseenFields, myPac.id);
          //tmpField = getClosestUnknown(myPac.x, myPac.y, unseenFields);
          dtxt('tmpfield ${tmpField}');
          myPac.ignoreGoal = true;
          goToUnseen = true;
          //pellet = getClosestPellet(myPac.x, myPac.y, pellets);
          //.dtxt('seen.length ${seen.length}');
        }

        if (!goToUnseen) {
          dtxt('goToUnseen---------');

          if (pellet == null) {
            if (myPac.id == 0) {
              pellet = Pellet(5, 5, 0);
            }
            if (myPac.id == 1) {
              pellet = Pellet(3, 10, 0);
            }
            if (myPac.id == 2) {
              pellet = Pellet(15, 5, 0);
            }
            if (myPac.id == 3) {
              pellet = Pellet(20, 6, 0);
            }
            if (myPac.id == 4) {
              pellet = Pellet(25, 11, 0);
            }
          }
          text = 'MOVE ${myPac.id} ${pellet.x} ${pellet.y}';
          if (myPac.abilityCooldown == 0 && round > 100) {
            text = "SPEED ${myPac.id}";
            myPac.ignoreGoal = true;
            myPac.hasSwitched = false;
          }
          if (enemyPacs.length > 0) {
            dtxt('${enemyPacs.length} enemies exist ');
            Pac enemy = getClosestEnemyOfEnemy(myPac.x, myPac.y, enemyPacs, myPacs);
            dtxt('enemy ${enemy}');
            if (enemy != null) {
              text = switchForOrMoveToEnemy(enemy, text);
            }
            dtxt('text ${text}');
          }
          if (!myPac.ignoreGoal) {
            goals.add("${pellet.x} ${pellet.y}");
            int w = 2;
            for (int x = -1 * w; x <= w; x++) {
              for (int y = -1 * w; y <= w; y++) {
                ignoredFields.add("${pellet.x + x} ${pellet.y + y}");
              }
            }
          } else {
            dtxt('ignore goal');
          }
          dtxt('goals.length ${goals.length}');
        } else {
          text = unseenSeenOrPellets(tmpField, text, pellet, seen);
        }
      } else {
        dtxt('--------GOAL for pac id:${myPac.id}  ${myPac.goal[0]}');
        text = "MOVE ${myPac.id} ${myPac.goal[0]}";
      }
      texts.add(text); // MOVE <pacId> <x> <y>
      textsMap["${myPac.id}"] = text;
    }
    moveToIfBigFoodExistsForBot();
    round++;
    printMap();
    //.dtxt('texts ${texts}');

    print(texts.join("|")); // MOVE <pacId> <x> <y>
  }
}

Pellet getPelletOrSeenPellet(bool pacSeesPellet, Pellet pellet, List seen) {
  if (pacSeesPellet) {
//    pellet = getClosestPellet(myPac.x, myPac.y, pellets);
    pellet = getClosestPelletForPosInRangeOf(myPac.x, myPac.y, pellets, myPac.id);
    if (pellet != null) {
      dtxt('seeing pellet at ${pellet.x} ${pellet.y}');
    }
  } else {
//    pellet = getClosestPellet(myPac.x, myPac.y, seen);
    pellet = getClosestPelletForPosInRangeOf(myPac.x, myPac.y, seen, myPac.id);
    if (pellet != null) {
      dtxt('seen at ${pellet.x} ${pellet.y}');
    }
  }
  return pellet;
}

String switchForOrMoveToEnemy(Pac enemy, String text) {
  dtxt("switchForOrMoveToEnemy--------");

  String enemyType = enemy.type;
  String myType = myPac.type;
  num distance = getDistance(enemy.x, enemy.y, myPac.x, myPac.y);
  if (distance <= 2) {
    if (myPac.abilityCooldown == 0) {
      if (enemyType == "ROCK" && myType != "PAPER") {
        text = "SWITCH ${myPac.id} PAPER";
        myPac.ignoreGoal = true;
        myPac.hasSwitched = true;
      } else if (enemyType == "SCISSORS" && myType != "ROCK") {
        text = "SWITCH ${myPac.id} ROCK";
        myPac.ignoreGoal = true;
        myPac.hasSwitched = true;
      } else if (enemyType == "PAPER" && myType != "SCISSORS") {
        text = "SWITCH ${myPac.id} SCISSORS";
        myPac.ignoreGoal = true;
        myPac.hasSwitched = true;
      }
    }

    if (enemyType == "ROCK" && myType == "PAPER") {
      text = "MOVE ${myPac.id} ${enemy.x} ${enemy.y}";
      dtxt('moveto mypac ${myPac.id} to enemy ${enemy.x} ${enemy.y}');
      myPac.ignoreGoal = true;
    } else if (enemyType == "SCISSORS" && myType == "ROCK") {
      text = "MOVE ${myPac.id} ${enemy.x} ${enemy.y}";
      dtxt('moveto mypac ${myPac.id} to enemy ${enemy.x} ${enemy.y}');
      myPac.ignoreGoal = true;
    } else if (enemyType == "PAPER" && myType == "SCISSORS") {
      text = "MOVE ${myPac.id} ${enemy.x} ${enemy.y}";
      dtxt('moveto mypac ${myPac.id} to enemy ${enemy.x} ${enemy.y}');
      myPac.ignoreGoal = true;
    }
  }
  return text;
}

String unseenSeenOrPellets(List tmpField, String text, Pellet pellet, List seen) {
  dtxt("unseenSeenOrPellets--------");

//  tmpField = getClosestUnknown(myPac.x, myPac.y, unseenFields);
  tmpField = getClosestUnknownInRange(myPac.x, myPac.y, unseenFields, -1);
  if (tmpField != null ){
    text = 'MOVE ${myPac.id} ${tmpField[0]} ${tmpField[1]}';
  }else{
    pellet = getClosestPelletForPosInRangeOf(myPac.x, myPac.y, seen, -1);
    if (pellet == null) {
      pellet = getClosestPelletForPosInRangeOf(myPac.x, myPac.y, pellets, -1);
      //if (pellet == null) {
      // pellet = getDefaultPelletForPac(myPac);
      // }
    }
    text = 'MOVE ${myPac.id} ${pellet.x} ${pellet.y}';
  }
  return text;
}

void moveToIfBigFoodExistsForBot() {
  dtxt("moveToIfBigFoodExistsForBot--------");
  stderr.writeln("moveToIfBigFoodExistsForBot--------");
  if (bigfood.length > 0) {
    Pac bigPac = null;
    Pellet bigPellet = null;
    for (bigPellet in bigfood) {
      dtxt("big food found at ${bigPellet.x} ${bigPellet.y}");
      stderr.writeln("big food found at ${bigPellet.x} ${bigPellet.y}");

      bigPac = getClosestBotForPellet(bigPellet);
      if (bigPac != null) {
        stderr.writeln("bigPac != null ${bigPac}");
        Pellet new_pellet = getClosestPelletForPosInRangeOf(bigPac.x, bigPac.y, bigfood, bigPac.id);
        if (new_pellet != null) {
          for (int i = 0; i < texts.length; i++) {
            String text = texts[i];
            int id = int.parse(text.split(" ")[1]);
            if (bigPac.id == id) {
              texts[i] = "MOVE $id ${new_pellet.x} ${new_pellet.y}";
              bigfood = remove_pellet_from_list(new_pellet, bigfood);
              bigfoodList.remove("${new_pellet.x} ${new_pellet.y}");
              myPac.goal.add("${new_pellet.x} ${new_pellet.y}");
              dtxt("bigfood after $bigfood");
              stderr.writeln("bigfood after $bigfood");
            }
          }
          break;
        }
      }
    }
  }
}

void storeSeenBigAndPellets(int visiblePelletCount, List inputs) {
  dtxt("storeSeenBigAndPellets---------");
  for (int i = 0; i < visiblePelletCount; i++) {
    inputs = stdin.readLineSync().split(' ');
    int x = int.parse(inputs[0]);
    int y = int.parse(inputs[1]);
    int value = int.parse(inputs[2]); // amount of points this pellet is worth
    Pellet pellet = Pellet(x, y, value);
    if (value > 1) {
      bigfood.add(pellet);
      bigfoodList.add("${pellet.x} ${pellet.y}");
    }
    if (seenPellets["${x} ${y}"] == null) {
      //.dtxt('xy ${pellet.x} ${pellet.y}');
      seenPellets["${x} ${y}"] = pellet;
      //.dtxt('length ${seenPellets.length}');
    }
    pellets.add(pellet);
  }
}

void checkIfPacMoved() {
  dtxt("checkIfPacMoved---------");
  for (int i = 0; i < myPacs.length; i++) {
    if (lastPos[myPacs[i].id] == "${myPacs[i].x} ${myPacs[i].y}") {
      myPacs[i].moved = false;
    } else {
      myPacs[i].moved = true;
    }
    //.dtxt("myPacs[i].moved ${myPacs[i].moved}");
  }
}

extractMyAndEnemyPacs(int visiblePacCount, List inputs) {
  dtxt("extractMyAndEnemyPacs---------");
  List tmpPacs = myPacs;
  myPacs = [];
  printBots(tmpPacs);
  for (int i = 0; i < visiblePacCount; i++) {
    inputs = stdin.readLineSync().split(' ');
    int pacId = int.parse(inputs[0]); // pac number (unique within a team)
    int mine = int.parse(inputs[1]); // true if this pac is yours
    int x = int.parse(inputs[2]); // position in the grid
    int y = int.parse(inputs[3]); // position in the grid
    String typeId = inputs[4]; // unused in wood leagues
    int speedTurnsLeft = int.parse(inputs[5]); // unused in wood leagues
    int abilityCooldown = int.parse(inputs[6]); // unused in wood leagues
    if (mine == 1) {
      dtxt('mine ${mine} pacId $pacId x ${x} y ${y} ');

      dtxt(' abilityCooldown ${abilityCooldown} speedTurnsLeft ${speedTurnsLeft} visiblePacCount $visiblePacCount');
    }
//.dtxt('speedTurnsLeft ${speedTurnsLeft}');
    //.dtxt('abilityCooldown ${abilityCooldown}');

    if (mine == 1) {
      Pac tmpPac = null;
      for (Pac pac in tmpPacs) {
        if (pac.id == pacId) {
          tmpPac = pac;
          break;
        }
      }
      if (tmpPac == null) {
        myPacs.add(Pac(pacId, x, y, speedTurnsLeft, abilityCooldown, typeId));
      } else {
        tmpPac.x = x;
        tmpPac.y = y;
        tmpPac.type = typeId;
        tmpPac.speedTurnsLeft = speedTurnsLeft;
        tmpPac.abilityCooldown = abilityCooldown;
        myPacs.add(tmpPac);
      }
    } else {
      enemyPacs.add(Pac(pacId, x, y, speedTurnsLeft, abilityCooldown, typeId));
      dtxt('enemyPacs.length ${enemyPacs.length} id${pacId}');
    }
    printBots(myPacs);
  }
//  return inputs;
}

void storePosAsNextRoundsLastPos() {
  dtxt("storePosAsNextRoundsLastPos---------");
  for (int i = 0; i < myPacs.length; i++) {
    lastPos[myPacs[i].id] = "${myPacs[i].x} ${myPacs[i].y}";
  }
}

bool debug = false;

void dtxt(String text) {
  if (debug) stderr.writeln(text);
}

Pac getPacWithId(int id, List pacs) {
  //dtxt("getPacWithId---------");
  Pac pac;
  for (int i = 0; i < pacs.length; i++) {
    if (pacs[i].id == id) {
      pac = pacs[i];
      break;
    }
  }
  return pac;
}

List getClosestUnknown(int myX, int myY, List tmpFields) {
  dtxt("getClosestUnknown-----------");
  num shortestDistance = -1;
  List targetField;
  for (int i = 0; i < tmpFields.length; i++) {
    List fieldPos = tmpFields[i].split(" ");
    int tx = int.parse(fieldPos[0]);
    int ty = int.parse(fieldPos[1]);
    num distance = getDistance(tx, ty, myX, myY);
    if (shortestDistance == -1 || distance < shortestDistance) {
      shortestDistance = distance;
      targetField = [tx, ty]; //tmpField;
    }
  }
  return targetField;
}

List getClosestUnknownInRange(int myX, int myY, List tmpFields, int botId) {
  dtxt("getClosestUnknownInRange--------");
  num shortestDistance = -1;
  List targetField;
  for (int i = 0; i < tmpFields.length; i++) {
    List fieldPos = tmpFields[i].split(" ");
    int tx = int.parse(fieldPos[0]);
    int ty = int.parse(fieldPos[1]);
    Pac bot = getPacWithId(botId, myPacs);
    if (tx != null && bot != null && tx >= bot.xStart && tx <= bot.xEnd) {
      num distance = getDistance(tx, ty, myX, myY);
      if (shortestDistance == -1 || distance < shortestDistance) {
        shortestDistance = distance;
        targetField = [tx, ty]; //tmpField;
      }
    }
  }
  return targetField;
}

Pellet getClosestPelletForPosInRangeOf(int myX, int myY, List tmpPellets, int botId) {
  dtxt("getClosestPelletInRange-------------");
  num shortestDistance = -1;
  Pellet targetPellet = null;
  for (int i = 0; i < tmpPellets.length; i++) {
    Pellet pellet = tmpPellets[i];
    if (botId == -1) {
      if (goals.indexOf("${pellet.x} ${pellet.y}") == -1 && ignoredFields.indexOf("${pellet.x} ${pellet.y}") == -1) {
        num distance = getDistance(pellet.x, pellet.y, myX, myY);
        if (shortestDistance == -1 || distance < shortestDistance) {
          shortestDistance = distance;
          targetPellet = pellet;
        }
      }
    } else {
      Pac bot = getPacWithId(botId, myPacs);
      if (pellet != null && bot.xEnd != null && bot.xStart != null && pellet.x >= bot.xStart && pellet.x < bot.xEnd) {
        if (goals.indexOf("${pellet.x} ${pellet.y}") == -1 && ignoredFields.indexOf("${pellet.x} ${pellet.y}") == -1) {
          num distance = getDistance(pellet.x, pellet.y, myX, myY);
          if (shortestDistance == -1 || distance < shortestDistance) {
            shortestDistance = distance;
            targetPellet = pellet;
          }
        }
      }
    }
  }
  return targetPellet;
}

Pac getClosestBotForPellet(Pellet pellet) {
  dtxt("getClosestBotForPellet---------");
  stderr.writeln("getClosestBotForPellet---------");
  num shortestDistance = -1;
  Pac targetPac = null;
  for (int i = 0; i < myPacs.length; i++) {
    Pac myPac = myPacs[i];
    stderr.writeln('shortestDistance ${shortestDistance}');
    num distance = getDistance(pellet.x, pellet.y, myPac.x, myPac.y);
    stderr.writeln('distance ${distance}, i:${i}');
    if (shortestDistance == -1 || distance < shortestDistance) {
      shortestDistance = distance;
      targetPac = myPac;
    }
  }
  return targetPac;
}

Pac getClosestPacForPosition(int myX, int myY, List tmpPacs) {
  dtxt("getClosestPacForPosition----------");
  num shortestDistance = -1;
  Pac targetEnemy = null;
  for (int i = 0; i < tmpPacs.length; i++) {
    Pac enemy = tmpPacs[i];
    num distance = getDistance(enemy.x, enemy.y, myX, myY);
    dtxt('myxy ${myX}:${myY} distance ${distance}');
    if ((shortestDistance == -1 || distance < shortestDistance)) {
      shortestDistance = distance;
      targetEnemy = enemy;
    }
  }
  return targetEnemy;
}

Pac getClosestEnemyOfEnemy(int myX, int myY, List tmpEnemies, List tmpMyPacs) {
  dtxt("getClosestEnemyOfEnemy");
  Pac targetEnemy = null;
  Pac closestEnemyPac = getClosestPacForPosition(myX, myY, tmpEnemies);
  dtxt('closestEnemyPac ${closestEnemyPac}');
  if (closestEnemyPac != null) {
    dtxt('closestEnemyPac x ${closestEnemyPac.x},${closestEnemyPac.y}');
    Pac closestEnemyPacForOponent = getClosestPacForPosition(closestEnemyPac.x, closestEnemyPac.y, tmpMyPacs);
    if (closestEnemyPacForOponent != null) {
      dtxt('closestEnemyPacForOponent x ${closestEnemyPacForOponent.x},${closestEnemyPacForOponent.y}');
      if (closestEnemyPacForOponent.x == myX && closestEnemyPacForOponent.y == myY) {
        targetEnemy = closestEnemyPac;
      }
    }
  }
  return targetEnemy;
}

num getDistance(int xA, int yA, int xB, int yB) {
  return sqrt((pow((xA - xB), 2) + pow((yA - yB), 2)));
}

void setXRangeForBot() {
  List newList = myPacs;
  dtxt('mypacs');
  printBots(myPacs);
  newList.sort((a, b) => a.x.compareTo(b.x));
  dtxt('newList');
  printBots(newList);
  int stdRange = (width ~/ myPacs.length);
  int startX = 0;
  int endX = stdRange;
  int length = newList.length;
  for (var i = 0; i < length - 1; ++i) {
    newList[i].xStart = startX;
    newList[i].xEnd = endX;
    startX += stdRange + 1;
    endX += stdRange + 1;
    dtxt('set 1range for bot ${newList[i].id} ${newList[i].xStart},${newList[i].xEnd}');
  }
  myPacs[length - 1].xStart = startX;
  myPacs[length - 1].xEnd = width;
  dtxt('set range for bot ${newList[length - 1].id} ${newList[length - 1].xStart},${newList[length - 1].xEnd}');
}

void printBots(List bots) {
  for (var i = 0; i < bots.length; ++i) {
    var bot = bots[i];
    dtxt('${bot.toJson()}');
  }
}
