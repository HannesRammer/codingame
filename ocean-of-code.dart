import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
List map = [];
List water = [];
List safeWater = [];
List possibleEnemyStart = [];
List possibleEnemyEnd = [];
List enemyPath = [];
List visited = [];
String surfaced = "";
List sektors = [
  [
    [0, 0],
    [4, 4]
  ],
  [
    [5, 0],
    [9, 4]
  ],
  [
    [10, 0],
    [14, 4]
  ],
  [
    [0, 5],
    [4, 9]
  ],
  [
    [5, 5],
    [9, 9]
  ],
  [
    [10, 5],
    [14, 9]
  ],
  [
    [0, 10],
    [4, 14]
  ],
  [
    [5, 10],
    [9, 14]
  ],
  [
    [10, 10],
    [14, 14]
  ],
];

bool isPosInsideSektor(List pos, int sektorId) {
  bool isInside = false;
  List sektor = sektors[sektorId - 1];
  int xMin = sektor[0][0];
  int xMax = sektor[1][0];

  int yMin = sektor[0][1];
  int yMax = sektor[1][1];
  if (pos[0] >= xMin && pos[0] <= xMax && pos[1] >= yMin && pos[1] <= yMax) {
    isInside = true;
  }
  return isInside;
}

void main() {
  List inputs;
  inputs = stdin.readLineSync().split(' ');
  int width = int.parse(inputs[0]);
  int height = int.parse(inputs[1]);
  int myId = int.parse(inputs[2]);
  for (int i = 0; i < height; i++) {
    String line = stdin.readLineSync();
    for (int j = 0; j < line.length; j++) {
      if (line[j] == ".") {
        water.add("${j} ${i}");
//                possibleEnemyStart.add("$j $i");
        //possibleEnemyEnd.add("$j $i");
        //.dtxt("add x${j} y${i} to unseen");
      }
    }
    dxt(line);
    map.add(line);
  }
  possibleEnemyEnd = [];
  // Write an action using print()
  // To debug: stderr.writeln('Debug messages...');
  removeSingleWayFromWater();
  print(safeWater[0]);

  // game loop
  while (true) {
    surfaced = "";
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
    String direction = "";
    dxt('Opponent orders  ${opponentOrders}');
    dxt('torpedoCooldown  ${torpedoCooldown}');
    dxt('sonarCooldown  ${sonarCooldown}');
    List oponnentMoves = opponentOrders.split("|");
    for (var i = 0; i < oponnentMoves.length; ++i) {
      var opponentOrder = oponnentMoves[i];
      if (opponentOrder.contains("MOVE ")) {
        enemyPath.add(opponentOrder.split("MOVE ")[1]);
        dxt('Opponent path ${enemyPath}');
        calcPossibleEnemyPos();
      } else if (opponentOrder.contains("SURFACE ")) {
        surfaced = opponentOrder.split("SURFACE ")[1];
//            possibleEnemyStart = [...water];
        //possibleEnemyEnd = [];
        removeNonSektorPositions(int.parse(surfaced));
      } else if (opponentOrder.contains("TORPEDO ")) {
        //reduce possible enemy positions by torpedo range
        String torpedo = opponentOrder.split("TORPEDO ")[1];

        removeNonTorpedoRangePositions(torpedo);
      } else if (opponentOrder.contains("SILENCE")) {
        //reduce possible enemy positions by torpedo range
//                enemyPath = [];
//    possibleEnemyStart = [...water];
//                possibleEnemyEnd = [];
        addPossibleSilencePositions();
      }
    }

    bool attack = false;
    bool moveTo = false;
    if ((possibleEnemyEnd.length >= 1 && possibleEnemyEnd.length < 4) && torpedoCooldown == 0) {
      List<String> posList = possibleEnemyEnd[0].split(" ");
      int posX = int.parse(posList[0]);
      int posY = int.parse(posList[1]);
      bool inRange = isInRangeOf(posX, posY, x, y);
      if (inRange) {
        attack = true;
      } else {
        moveTo = true;
      }
    }
    List pos = [];
    if (moveTo) {
      pos = getClosestPos(x, y, possibleEnemyEnd);
    } else {
      //pos = getClosestPosWithFuture(x, y, water);
      pos = getClosestPos(x, y, water);
      List tmpVisits=[];
      List pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9;
      if(pos != null){
        tmpVisits = ["${pos[0]} ${pos[1]}"];
        List pos1 = checkFuturePos(pos[0],pos[1], water, tmpVisits);
        bool hasFuture1 = false;
        bool hasFuture2 = false;
        bool hasFuture3 = false;
        bool hasFuture4 = false;
        bool hasFuture5 = false;
        bool hasFuture6 = false;
        bool hasFuture7 = false;
        bool hasFuture8 = false;
        bool hasFuture9 = false;
        if(pos1 != null){
          hasFuture1 = true;
          tmpVisits.add(["${pos1[0]} ${pos1[1]}"]);
          pos2 = checkFuturePos(pos1[0], pos1[1], water, tmpVisits);
          if(pos2 != null){
            hasFuture2 = true;
            tmpVisits.add(["${pos2[0]} ${pos2[1]}"]);
            pos3 = checkFuturePos(pos2[0], pos2[1], water, tmpVisits);
            if(pos3 != null){
              hasFuture3 = true;
              tmpVisits.add(["${pos3[0]} ${pos3[1]}"]);
              pos4 = checkFuturePos(pos3[0], pos3[1], water, tmpVisits);
              if(pos4 != null){
                hasFuture4 = true;
                tmpVisits.add(["${pos4[0]} ${pos4[1]}"]);
                pos5 = checkFuturePos(pos4[0], pos4[1], water, tmpVisits);
                if(pos5 != null){
                  hasFuture5 = true;
                  tmpVisits.add(["${pos5[0]} ${pos5[1]}"]);
                  pos6 = checkFuturePos(pos5[0], pos5[1], water, tmpVisits);
                  if(pos6 != null){
                    hasFuture6 = true;
                    tmpVisits.add(["${pos6[0]} ${pos6[1]}"]);
                    pos7 = checkFuturePos(pos6[0], pos6[1], water, tmpVisits);
                    if(pos7 != null){
                      hasFuture7 = true;
                      tmpVisits.add(["${pos7[0]} ${pos7[1]}"]);
                      pos8 = checkFuturePos(pos7[0], pos7[1], water, tmpVisits);
                      if(pos8 != null){
                        hasFuture8 = true;
                        tmpVisits.add(["${pos8[0]} ${pos8[1]}"]);
                        pos9 = checkFuturePos(pos8[0], pos8[1], water, tmpVisits);
                        if(pos9 != null){
                          hasFuture9 = true;
                        }else{
                          hasFuture9 = false;
                        }
                      }else{
                        hasFuture8 = false;
                      }
                    }else{
                      hasFuture7 = false;
                    }
                  }else{
                    hasFuture6 = false;
                  }
                }else{
                  hasFuture5 = false;
                }
              }else{
                hasFuture4 = false;
              }
            }else{
              hasFuture3 = false;
            }
          }else{
            hasFuture2 = false;
          }
        }else{
          hasFuture1 = false;
        }

        if(!hasFuture1){
          stderr.writeln("has no future1");
          visited.add("${pos[0]} ${pos[1]}");
        }else{
          stderr.writeln("has future1");
          if(!hasFuture2){
            stderr.writeln("has no future2");
            visited.add("${pos[0]} ${pos[1]}");
            visited.add("${pos1[0]} ${pos1[1]}");
          }else{
            stderr.writeln("has future2");
            if(!hasFuture3){
              stderr.writeln("has no future3");
              visited.add("${pos1[0]} ${pos1[1]}");
              visited.add("${pos2[0]} ${pos2[1]}");
              visited.add("${pos3[0]} ${pos3[1]}");
            }else{
              stderr.writeln("has future3");
              if(!hasFuture4){
                stderr.writeln("has no future4");
                visited.add("${pos1[0]} ${pos1[1]}");
                visited.add("${pos2[0]} ${pos2[1]}");
                visited.add("${pos3[0]} ${pos3[1]}");
                visited.add("${pos4[0]} ${pos4[1]}");

              }else{
                stderr.writeln("has future4");
                if(!hasFuture5){
                  stderr.writeln("has no future5");
                  visited.add("${pos1[0]} ${pos1[1]}");
                  visited.add("${pos2[0]} ${pos2[1]}");
                  visited.add("${pos3[0]} ${pos3[1]}");
                  visited.add("${pos4[0]} ${pos4[1]}");
                  visited.add("${pos5[0]} ${pos5[1]}");
                }else{
                  stderr.writeln("has future5");
                  if(!hasFuture6){
                    stderr.writeln("has no future6");
                    visited.add("${pos1[0]} ${pos1[1]}");
                    visited.add("${pos2[0]} ${pos2[1]}");
                    visited.add("${pos3[0]} ${pos3[1]}");
                    visited.add("${pos4[0]} ${pos4[1]}");
                    visited.add("${pos5[0]} ${pos5[1]}");
                    visited.add("${pos6[0]} ${pos6[1]}");
                  }else{
                    stderr.writeln("has future6");
                    if(!hasFuture7){
                      stderr.writeln("has no future7");
                      visited.add("${pos1[0]} ${pos1[1]}");
                      visited.add("${pos2[0]} ${pos2[1]}");
                      visited.add("${pos3[0]} ${pos3[1]}");
                      visited.add("${pos4[0]} ${pos4[1]}");
                      visited.add("${pos5[0]} ${pos5[1]}");
                      visited.add("${pos6[0]} ${pos6[1]}");
                      visited.add("${pos7[0]} ${pos7[1]}");
                    }else{
                      stderr.writeln("has future7");
                      if(!hasFuture8){
                        stderr.writeln("has no future8");
                        visited.add("${pos1[0]} ${pos1[1]}");
                        visited.add("${pos2[0]} ${pos2[1]}");
                        visited.add("${pos3[0]} ${pos3[1]}");
                        visited.add("${pos4[0]} ${pos4[1]}");
                        visited.add("${pos5[0]} ${pos5[1]}");
                        visited.add("${pos6[0]} ${pos6[1]}");
                        visited.add("${pos7[0]} ${pos7[1]}");
                        visited.add("${pos8[0]} ${pos8[1]}");
                      }else{
                        stderr.writeln("has future8");
                        if(!hasFuture9){
                          stderr.writeln("has no future9");
                          visited.add("${pos1[0]} ${pos1[1]}");
                          visited.add("${pos2[0]} ${pos2[1]}");
                          visited.add("${pos3[0]} ${pos3[1]}");
                          visited.add("${pos4[0]} ${pos4[1]}");
                          visited.add("${pos5[0]} ${pos5[1]}");
                          visited.add("${pos6[0]} ${pos6[1]}");
                          visited.add("${pos7[0]} ${pos7[1]}");
                          visited.add("${pos8[0]} ${pos8[1]}");
                          visited.add("${pos9[0]} ${pos9[1]}");

                        }else{
                          stderr.writeln("has future9");
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        pos = getClosestPos(x, y, water);

      }
      dxt("closestPoint $pos $pos1 $pos2 $pos3");
      // dxt("closestPoint $pos $pos1");
    }

    printMap();
    dxt("${pos}#####################################");
    if (attack) {
      dxt("attack-------");
      print("TORPEDO ${possibleEnemyEnd[0]}");
    } else {
      dxt("NOattack-------");
      if (pos != null) {
        if (pos[0] > x) {
          direction = "E";
        }
        if (pos[0] < x) {
          direction = "W";
        }
        if (pos[1] < y) {
          direction = "N";
        }
        if (pos[1] > y) {
          direction = "S";
        }
        String word = "";
        if (torpedoCooldown > 0) {
          word = "TORPEDO";
        } else if (silenceCooldown > 0) {
          word = "SILENCE";
        } else if (sonarCooldown > 0) {
          word = "SONAR";
        }
        if (silenceCooldown == 0) {
          print('SILENCE ${direction} 1');
        } else {
          print('MOVE ${direction} $word');
        }
      } else if (moveTo) {
        dxt("moveTo-------");
        List<String> posList = possibleEnemyEnd[0].split(" ");
        dxt("posList $posList-------");
        int posX = int.parse(posList[0]);
        int posY = int.parse(posList[1]);
        if (posX > x && safeWater.contains("${x + 1} $y") && !visited.contains("${x + 1} $y")) {
          direction = "E";
        }
        if (posX < x && safeWater.contains("${x - 1} $y") && !visited.contains("${x - 1} $y")) {
          direction = "W";
        }
        if (posY < y && safeWater.contains("$x ${y - 1}") && !visited.contains("$x ${y - 1}")) {
          direction = "N";
        }
        if (posY > y && safeWater.contains("$x ${y + 1}") && !visited.contains("$x ${y + 1}")) {
          direction = "S";
        }
        dxt("direction $direction-------");
        if (direction == "") {
          dxt("exclude visited-------");
          if (safeWater.contains("${x + 1} $y") && !visited.contains("${x + 1} $y")) {
            direction = "E";
          }
          if (safeWater.contains("$x ${y - 1}") && !visited.contains("$x ${y - 1}")) {
            direction = "N";
          }
          if (safeWater.contains("${x - 1} $y") && !visited.contains("${x - 1} $y")) {
            direction = "W";
          }
          if (safeWater.contains("$x ${y + 1}") && !visited.contains("$x ${y + 1}")) {
            direction = "S";
          }
        }
        String word = "";
        if (torpedoCooldown > 0) {
          word = "TORPEDO";
        } else if (silenceCooldown > 0) {
          word = "SILENCE";
        } else if (sonarCooldown > 0) {
          word = "SONAR";
        }
        if (direction == "") {
          visited = [];
          print('SURFACE');
        } else {
          if (silenceCooldown == 0) {
            print('SILENCE ${direction} 1');
          } else {
            print('MOVE ${direction} $word');
          }
        }
      } else {
        visited = [];
        print('SURFACE');
      }
    }
  }
}

void printMap() {
  dxt("printMap ");
  for (int y = 0; y < map.length; y++) {
    String row = map[y];
    List rowList = [];
    for (int x = 0; x < row.length; x++) {
      String field = row[x];
      if (water.contains("${x} ${y}")) {
        field = "W";
        //rowList.add('[${x} ${y}]');
      }
      //.dtxt("seenPellets[${x} ${seenPellets['${x} ${y}']} ");
      //if (possibleEnemyStart.indexOf("${x} ${y}") > -1) {
      if (possibleEnemyEnd.indexOf("${x} ${y}") > -1) {
        field = "E";
        //rowList.add('E');
        //rowList.add('[${x} ${y}]');
      } else {
        field = field;
      }
      rowList.add(field);
    }
    String newRow = rowList.join("");
    dxt(newRow);
  }
}

void removeNonSektorPositions(int sektorId) {
  dxt("removeNonSektorPositions----Sektor $sektorId");
  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
  for (var i = 0; i < water.length; ++i) {
    String w = water[i];
    if (possibleEnemyEnd.contains(water[i])) {
      num sx = num.parse(w.split(" ")[0]);
      num sy = num.parse(w.split(" ")[1]);

      bool isInsideSektor = isPosInsideSektor([sx, sy], sektorId);

      if (!isInsideSektor) {
        possibleEnemyEnd.remove("${sx} ${sy}");
      }
    }
  }
  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
}

void removeNonTorpedoRangePositions(String torpedo) {
  dxt("removeNonTorpedoRangePositions----Sektor $torpedo");
  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
  for (var i = 0; i < water.length; ++i) {
    String w = water[i];
    if (possibleEnemyEnd.contains(water[i])) {
      List tList = torpedo.split(" ");
      int torpedoX = int.parse(tList[0]);
      int torpedoY = int.parse(tList[1]);
      num sx = num.parse(w.split(" ")[0]);
      num sy = num.parse(w.split(" ")[1]);

      bool isInRangeOfTorpedo = isInRangeOf(sx, sy, torpedoX, torpedoY);

      if (!isInRangeOfTorpedo) {
        possibleEnemyEnd.remove("${sx} ${sy}");
      }
    }
  }
  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
}

void addPossibleSilencePositions() {
  dxt("addPossibleSilencePositions----");
  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
  List tmpPositions = [];
  for (var i = 0; i < possibleEnemyEnd.length; ++i) {
    String w = possibleEnemyEnd[i];
    num ex = num.parse(w.split(" ")[0]);
    num ey = num.parse(w.split(" ")[1]);

    for (var j = -1; j <= 1; ++j) {
      String xPos = "${ex + j} $ey";
      if (water.contains(xPos) && !tmpPositions.contains(xPos)) {
        tmpPositions.add(xPos);
      }
      String yPos = "$ex ${ey + j}";
      if (water.contains(yPos) && !tmpPositions.contains(yPos)) {
        tmpPositions.add(yPos);
      }
    }
  }
  possibleEnemyEnd = tmpPositions;
  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
}

void removeSingleWayFromWater() {
  dxt("removeSingleWayFromWater");
  safeWater = [];
  for (var i = 0; i < water.length; ++i) {
    var w = water[i];
    num x = num.parse(w.split(" ")[0]);
    num y = num.parse(w.split(" ")[1]);
//if(x>2 && x<13 && y <13 && y>2){

    bool wl = water.contains("${x - 1} $y");
    bool wr = water.contains("${x + 1} $y");
    bool wt = water.contains("$x ${y - 1}");
    bool wb = water.contains("$x ${y + 1}");
    //if ((wl || wr) && (wb || wt)) {
    safeWater.add(w);
    //}
//}
  }
}

void calcPossibleEnemyPos() {
  dxt("calcPossibleEnemyPos------");
  dxt("water.length ${water.length}");
  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
  if (enemyPath.isNotEmpty) {
    List tempEnemyPos = [];
    List tmpList = [];
    if (possibleEnemyEnd.isEmpty) {
      tmpList = water;
    } else {
      tmpList = possibleEnemyEnd;
    }

    for (var i = 0; i < tmpList.length; ++i) {
      String w = tmpList[i];
      num sx = num.parse(w.split(" ")[0]);
      num sy = num.parse(w.split(" ")[1]);

      bool exists = possiblePathWithStart(sx, sy);
      if (!exists) {
//                possibleEnemyStart.remove("${sx} ${sy}");
      } else {
        List pos = possibleEnemyPosForStart(sx, sy);
        tempEnemyPos.add("${pos[0]} ${pos[1]}");
//                    possibleEnemyEnd.add("${pos[0]} ${pos[1]}");
      }
    }

//    }else{

//    }
    if (enemyPath.isNotEmpty) {
      enemyPath.removeAt(0);
    }
    possibleEnemyEnd = tempEnemyPos;
  } else {}
  //if (surfaced.length > 0) {//remove non sektor fields
  //    removeNonSektorPositions(int.parse(surfaced));
  //}

  dxt("possibleEnemyEnd.length ${possibleEnemyEnd.length}");
}

bool isInRangeOf(int ex, int ey, int x, int y) {
  //dxt("isInRangeOf ex $ex ey $ey x $x y $y");
  List horizontal = [1, 3, 5, 7, 9, 7, 5, 3, 1];
  List vertical = [4, 3, 2, 1, 0, -1, -2, -3, -4];
  bool inRange = false;
  if ((ex >= x - 4 && ex <= x + 4 && ey == y) || (ey >= y - 4 && ey <= y + 4 && ex == x)) {
    //cross
    //dxt("cross");
    inRange = true;
  }
  if ((ex >= x - 3 && ex <= x + 3 && ey >= y - 1 && ey <= y + 1) || (ey >= y - 3 && ey <= y + 3 && ex >= x - 1 && ex <= x + 1)) {
    //recktangle
    //dxt("rectangle ");
    inRange = true;
  }
  if (ex >= x - 2 && ex <= x + 2 && ey >= y - 2 && ey <= y + 2) {
    //square
    //dxt("square ");
    inRange = true;
  }
  return inRange;
}

bool possiblePathWithStart(num sx, num sy) {
  //dxt("possiblePathWithStart-x-$sx-y$sy----");
  bool pathExists = true;
  num cx = sx;
  num cy = sy;
  //dxt("enemyPath.length ${enemyPath.length}");
  for (var i = 0; i < enemyPath.length; ++i) {
    String path = enemyPath[i];
    if (path == "N") {
      cy = cy - 1;
    }
    if (path == "S") {
      cy = cy + 1;
    }
    if (path == "E") {
      cx = cx + 1;
    }
    if (path == "W") {
      cx = cx - 1;
    }
    if (cx < 0 || cy < 0 || cx > 14 || cy > 14) {
      pathExists = false;
    }

    if (water.contains("${cx} ${cy}")) {
      pathExists = true;
    } else {
      pathExists = false;
      break;
    }
    if (sy == 0 || sy == 8) {
      //dxt("pathExists $pathExists sx $sx sy $sy cx $cx cy $cy");
    }
  }

  return pathExists;
}

List possibleEnemyPosForStart(num sx, num sy) {
  //dxt("possiblePathWithStart-x-$sx-y$sy----");
  bool pathExists = true;
  List targetPos = [];
  num cx = sx;
  num cy = sy;
  //dxt("enemyPath.length ${enemyPath.length}");
  for (var i = 0; i < enemyPath.length; ++i) {
    String path = enemyPath[i];
    if (path == "N") {
      cy = cy - 1;
    }
    if (path == "S") {
      cy = cy + 1;
    }
    if (path == "E") {
      cx = cx + 1;
    }
    if (path == "W") {
      cx = cx - 1;
    }
    if (water.contains("${cx} ${cy}")) {
      pathExists = true;
    } else {
      pathExists = false;
      targetPos = [];
      break;
    }
    if (sy == 0 || sy == 8) {
      //dxt("pathExists $pathExists sx $sx sy $sy cx $cx cy $cy");
    }
  }
  if (pathExists) {
    targetPos = [cx, cy];
  }
  //dxt("targetPos $targetPos ");
  return targetPos;
}

bool debug = true;

dxt(String text) {
  if (debug) {
    stderr.writeln(text);
  }
}

List getClosestPos(int myX, int myY, List positions) {
  num shortestDistance = -1;
  List targetField = null;
  for (int i = 0; i < positions.length; i++) {
    List pos = positions[i].split(" ");
    int tx = int.parse(pos[0]);
    int ty = int.parse(pos[1]);
    num distance = getDistance(tx, ty, myX, myY);
    //dxt('distance ${distance == 1}, i:${ i}');
    if (visited.indexOf("${tx} ${ty}") == -1 && distance == 1 && shortestDistance != 1) {
      dxt('distance ${distance}');
      shortestDistance = distance;
      targetField = [tx, ty]; //tmpField;
      dxt('tx ${tx} ty ${ty}');
    }
  }
  return targetField;
}

List getClosestPosWithFuture(int myX, int myY, List positions) {
  num shortestDistance = -1;
  List targetField = [];
  for (int i = 0; i < positions.length; i++) {
    List pos = positions[i].split(" ");
    List tmpVisits = [];
    int tx = int.parse(pos[0]);
    int ty = int.parse(pos[1]);
    tmpVisits.add("${tx} ${ty}");
    List pos1 = checkFuturePos(int.parse(pos[0]), int.parse(pos[1]), water, tmpVisits);
//    dxt("pos1 $pos1");
//    if (pos1 != null) {
//      tmpVisits.add("${pos1[0]} ${pos1[1]}");

    List pos2 = checkFuturePos(pos1[0], pos1[1], water, tmpVisits);

//      dxt("pos2 $pos2");
//      if (pos2 != null) {
//        tmpVisits.add("${pos2[0]} ${pos2[1]}");
    List pos3 = checkFuturePos(pos2[0], pos2[1], water, tmpVisits);
//        dxt("pos3 $pos3");
//        if (pos3 != null) {
    num distance = getDistance(tx, ty, myX, myY);
    //dxt('distance ${distance == 1}, i:${ i}');
    if (!visited.contains("${tx} ${ty}") && distance == 1 && shortestDistance != 1) {
      //dxt('distance ${distance}');
      shortestDistance = distance;
      targetField = [tx, ty]; //tmpField;
      //dxt('tx ${tx} ty ${ty}');
    }
//        }
//      }
//    }
  }
  return targetField;
}

List checkFuturePos(int myX, int myY, List positions, List excludes) {
  num shortestDistance = -1;
  List targetField=null;
  for (int i = 0; i < positions.length; i++) {
    List pos = positions[i].split(" ");
    int tx = int.parse(pos[0]);
    int ty = int.parse(pos[1]);

    //.dtxt('pellet ${targetPellet},${pellet.x},${myX},${myY}');
    //if(goals.indexOf("${pellet.x} ${pellet.y}") == -1 && ignoredFields.indexOf("${pellet.x} ${pellet.y}") == -1 ){
    // dxt('tx ${tx == myX} ty ${ty == myY}');
    num distance = getDistance(tx, ty, myX, myY);

    //dxt('distance ${distance == 1}, i:${ i}');
    if (!excludes.contains("${tx} ${ty}") && !visited.contains("${tx} ${ty}") && distance == 1 && shortestDistance != 1) {
      //dxt('distance ${distance}');
      shortestDistance = distance;
      targetField = [tx, ty]; //tmpField;
    }
    //}
  }
  return targetField;
}

num getDistance(int xA, int yA, int xB, int yB) {
  return sqrt((pow((xA - xB), 2) + pow((yA - yB), 2)));
}
