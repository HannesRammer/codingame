import 'dart:io';
import 'dart:math';

/**
 * Shoot enemies before they collect all the incriminating data!
 * The closer you are to an enemy, the more damage you do but don't get too close or you'll get killed.
 **/
void main() {
    List inputs;
    List datas;
    List enemys;
    // game loop
    while (true) {
        datas = [];
        enemys = [];
        inputs = stdin.readLineSync().split(' ');
        int x = int.parse(inputs[0]);
        int y = int.parse(inputs[1]);
        int dataCount = int.parse(stdin.readLineSync());
        for (int i = 0; i < dataCount; i++) {
            inputs = stdin.readLineSync().split(' ');
            int dataId = int.parse(inputs[0]);
            int dataX = int.parse(inputs[1]);
            int dataY = int.parse(inputs[2]);
            datas.add({"id":dataId, "x":dataX, "y":dataY, "closestEnemyDistance":-1, "myDistance":-1, "chanceToSave":-1});
            double distance = getDistance(dataX, dataY, x, y);
        }
        int enemyCount = int.parse(stdin.readLineSync());
        for (int i = 0; i < enemyCount; i++) {
            inputs = stdin.readLineSync().split(' ');
            int enemyId = int.parse(inputs[0]);
            int enemyX = int.parse(inputs[1]);
            int enemyY = int.parse(inputs[2]);
            int enemyLife = int.parse(inputs[3]);
            Map enemy = {"id":enemyId, "x":enemyX, "y":enemyY, "target":null, "life":enemyLife};
            if (enemyLife > 0) {
                enemys.add(enemy);
            }
        }
        List cenEnemys = centroid(enemys);

        num lowestChanceToSaveOver1 = 100000;
        num lowestAverage = 0;
        List cenData = centroid(datas);
        List universe = [(cenData[0] + cenEnemys[0]) / 2, (cenData[1] + cenEnemys[1]) * 2];
        stderr.writeln('center: ${cenData[0]} ${cenData[1]}');
        num tx = cenData[0];
        num ty = cenData[1];
        String text;
        List mostDangerousEnemy = [];
        int mostDangerousEnemyId = 0;
        for (int i = 0; i < datas.length; i++) {
            List enemyIdDistance = getClosestEnemy(datas[i]["x"], datas[i]["y"], enemys);
            int enemyId = enemyIdDistance[0];
            num enemyDistance = enemyIdDistance[1];
            num myDistance = getDistance(datas[i]["x"], datas[i]["y"], x, y);
            num enemySteps = (enemyDistance / 500);
            num mySteps = ((myDistance - 1000) / 1000);
            num chanceToSave = (enemySteps / mySteps).abs();
            datas[i]["chanceToSave"] = chanceToSave;
            lowestAverage += chanceToSave;
            if (chanceToSave < lowestChanceToSaveOver1) {
                //&& chanceToSave > 1.00) {
                lowestChanceToSaveOver1 = chanceToSave;
                mostDangerousEnemy = enemyIdDistance;
                mostDangerousEnemyId = enemyIdDistance[0];
                //tx = datas[i]["x"];
                //ty = datas[i]["y"];
                //text = "MOVE ${tx} ${ty}";
                //stderr.writeln("mostDangerousEnemy ${mostDangerousEnemy} ");
                text = "MOVE ${mostDangerousEnemy[2]} ${mostDangerousEnemy[3]}";
            }
            //stderr.writeln('id: ${datas[i]["id"]} - survive:${chanceToSave}');
        }
        lowestAverage = lowestAverage / datas.length;
        stderr.writeln('lctsAVERAGE: ${lowestAverage}');
        stderr.writeln('lcts: ${lowestChanceToSaveOver1}');
        //if (lowestChanceToSaveOver1 >= 1.0 && lowestChanceToSaveOver1 <= 100000) {
        List myEnemy = getClosestEnemy(x, y, enemys);
        //if all datas are save, hunt enemys
        stderr.writeln("mostDangerousEnemy: ${mostDangerousEnemyId} ");
        stderr.writeln("closest Enemy: ${myEnemy[0]} ");
/*
        if (datas.length <= 2 && !inRange(mostDangerousEnemy[1])) {
            text = "MOVE ${mostDangerousEnemy[2]} ${mostDangerousEnemy[3]}";
            stderr.writeln('move:$text');
        }else
        */
        text = huntClosestEnemy(x, y, myEnemy, mostDangerousEnemy, enemys, lowestAverage, cenData, cenEnemys, universe);

        //}
        // Write an action using print()
        // To debug: stderr.writeln('Debug messages...');
        stderr.writeln('text:$text');
        print(text); // MOVE x y or SHOOT id
    }
}


huntClosestEnemy(int x, int y, List enemy, List mDE, List enemys, lowestAverage, cenData, cenEnemys, universe) {
    //stderr.writeln('-------------hunt closest enemy START-------------');
    var eid = enemy[0];
    var distance = enemy[1];
    var ex = enemy[2];
    var ey = enemy[3];
    var life = enemy[4];
    //stderr.writeln('life:$life');
    String text;
    //stderr.writeln('distance:$distance');
    if (inRange(enemy[1], lowestAverage)) {
        //   if (isTwoShot(distance, life)) {
        //stderr.writeln("SHOOT ${eid}");
        //text = "SHOOT ${mostDangerousEnemy[0]}";

        text = "SHOOT ${eid}";
    } else {
        if (toClose(distance)) {
            text = moveAway(x, y, ex, ey, enemys);
        } else {
            //text = "MOVE ${tx} ${ty}";//center of datapoints
            text = "MOVE ${ex} ${ey}"; //closestEnemy points
            //text = "MOVE ${universe[0]} ${universe[1]}"; //closestEnemy points
            //text = huntMostDangerous(x, y, mDE);
        }
    }
    if (toClose(distance)) {
        text = moveAway(x, y, ex, ey, enemys);
    }
    //stderr.writeln('-------------hunt closest enemy END-------------');
    return text;
}

String moveAway(x, y, tx, ty, enemies) {
    var direction = "";

    var nx = x;
    var ny = y;

    List possibleDirections = ["up", "down", "left", "right"];

    for (int i = 0; i < enemies.length; i++) {
        Map enemy = enemies[i];
        int ex = enemy["x"];
        int ey = enemy["y"];
        double distance = getDistance(x, y, ex, ey);
        if (distance < 2500) {
            if (x + 100 > ex) {
                if ((x - 1000) <= (ex + 500)) {
                    possibleDirections.remove("left");
                }
            }
            if (x - 100 < ex) {
                if ((x + 1000) >= (ex - 500)) {
                    possibleDirections.remove("right");
                }
            }
            if (y < ey) {
                if ((y + 500) >= (ey - 500)) {
                    possibleDirections.remove("down");
                }
            } else {
                if ((y - 500) <= (ey + 500)) {
                    possibleDirections.remove("up");
                }
            }

            if ((x - tx).abs() < (y - ty).abs()) {
                if (ty < y) {
                    if (y + 1000 <= 9000) {
                        ny = y + 1000;
                        //dir ="down";
                    } else {
                        ny = y;
                    }
                } else if (y < ty) {
                    if (y - 1000 >= 0) {
                        ny = y - 1000;
                        //dir ="up";
                    } else {
                        ny = y;
                    }
                }
            } else {
                if (tx < x) {
                    if (x + 1000 <= 16000) {
                        nx = x + 1000;
                    } else {
                        nx = x;
                    }
                } else if (x < tx) {
                    if (x - 1000 >= 0) {
                        nx = x - 1000;
                    } else {
                        nx = x;
                    }
                }
            }
        }
    }


    stderr.writeln('possibleDirections: ${possibleDirections}');
    stderr.writeln('moveAWAY');
    return "MOVE ${nx} ${ny}";
}

bool toClose(var distance) {
    stderr.writeln('distance:$distance');
    return distance < 2500.0;
}


bool inRange(double distance, lowestAverage) {
    int currentDamage = (125000 / pow(distance, 1.2)).toInt();
    stderr.writeln('currentDamage:$currentDamage');
    if (lowestAverage >= 150) {
        return distance <= 5000.0;
    } else if (lowestAverage < 150 && lowestAverage >= 4) {
        return distance <= 5000.0;
    } else if (lowestAverage < 4 && lowestAverage > 2) {
        return distance <= 5000.0;
    } else if (lowestAverage < 0.01) {
        return distance <= 5000.0;
    } else {
        return distance <= 7000.0;
    }
    return distance <= 10000.0;
}

bool inDefense(double distance) {
    return distance < 2000.0;
}

getDataTargetForEnemy(List datas, Map enemy) {
    var shortestDistance = -1;
    int targetId = -1;
    for (int i = 0; i < datas.length; i++) {
        Map data = datas[i];
        var distance = getDistance(enemy["x"], enemy["y"], data["x"], data["y"]);
        if (shortestDistance == -1 || distance < shortestDistance) {
            shortestDistance = distance;
            targetId = data["id"];
        }
    }
    return [targetId, shortestDistance];
}


List getClosestEnemy(int dataX, int dataY, List enemys) {
    var shortestDistance = -1;
    int targetId = -1;
    int x, y;
    var life;
    for (int i = 0; i < enemys.length; i++) {
        Map enemy = enemys[i];
        var distance = getDistance(enemy["x"], enemy["y"], dataX, dataY);
        if (shortestDistance == -1 || distance < shortestDistance) {
            shortestDistance = distance;
            targetId = enemy["id"];
            x = enemy["x"];
            y = enemy["y"];
            life = enemy["life"];
        }
    }
    return [targetId, shortestDistance, x, y, life];
}

double getDistance(int xA, int yA, int xB, int yB) {
    return sqrt((pow((xA - xB), 2) + pow((yA - yB), 2)));
}

List centroid(List points) {
    List centroid = [0, 0];
    if (points.length == 1) {
        centroid[0] += points[0]["x"];
        centroid[1] += points[0]["y"];
    } else {
        for (int i = 0; i < points.length; i += 2) {
            centroid[0] += points[i]["x"];
            centroid[1] += points[i]["y"];
        }
        num totalPoints = points.length;
        centroid[0] = (centroid[0] / totalPoints).toInt();
        centroid[1] = (centroid[1] / totalPoints).toInt();
    }
    return centroid;
}