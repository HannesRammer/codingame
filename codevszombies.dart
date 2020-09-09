import 'dart:io';
import 'dart:math';

/**
 * Save humans, destroy zombies!
 **/
void main() {
    List inputs;
    List humans;
    List zombies;
// game loop
    while (true) {
        humans = [];
        zombies = [];
        inputs = stdin.readLineSync().split(' ');
        int x = int.parse(inputs[0]);
        int y = int.parse(inputs[1]);
        int humanCount = int.parse(stdin.readLineSync());
        for (int i = 0; i < humanCount; i++) {
            inputs = stdin.readLineSync().split(' ');
            int humanId = int.parse(inputs[0]);
            int humanX = int.parse(inputs[1]);
            int humanY = int.parse(inputs[2]);

            humans.add({"id":humanId, "x":humanX, "y":humanY, "closestZombieDistance":-1, "myDistance":-1, "chanceToSave":-1});
            double distance = getDistance(humanX, humanY, x, y);
        }
        int zombieCount = int.parse(stdin.readLineSync());
        for (int i = 0; i < zombieCount; i++) {
            inputs = stdin.readLineSync().split(' ');
            int zombieId = int.parse(inputs[0]);
            int zombieX = int.parse(inputs[1]);
            int zombieY = int.parse(inputs[2]);
            int zombieXNext = int.parse(inputs[3]);
            int zombieYNext = int.parse(inputs[4]);
            Map zombie = {"id":zombieId, "x":zombieX, "y":zombieY, "target":null};
            zombies.add(zombie);
            //List ztarget = getHumanTargetForZombie(humans, zombie);
            //List itarget = getHumanTargetForZombie(humans, zombie);
            //zombie["target"]=ztarget;
        }
        num lowestChanceToSaveOver1= 100000;
        num tx=humans[0]["x"];
        num ty=humans[0]["y"];
        for (int i = 0; i < humans.length; i++) {
            List zombieIdDistance = getClosestZombie(humans[i]["x"], humans[i]["y"], zombies);
            int zombieId = zombieIdDistance[0];
            num zombieDistance = zombieIdDistance[1];
            num myDistance = getDistance(humans[i]["x"], humans[i]["y"], x, y);
            num zombieSteps = (zombieDistance / 400);
            num mySteps = ((myDistance - 1000) / 1000);
            num chanceToSave = (zombieSteps / mySteps).abs();
            humans[i]["chanceToSave"] = chanceToSave;
            if(chanceToSave < lowestChanceToSaveOver1 && chanceToSave > 1.00){
                lowestChanceToSaveOver1 = chanceToSave;
                tx=humans[i]["x"];
                ty=humans[i]["y"];
            }
            stderr.writeln('id: ${humans[i]["id"]} - survive:${chanceToSave}');
        }
        stderr.writeln('lcts: ${lowestChanceToSaveOver1}');
        if (lowestChanceToSaveOver1 > 2.10 && lowestChanceToSaveOver1 < 100000) {
            List myZombie = getClosestZombie(x, y, zombies);
            //if all humans are save, hunt zombies
            tx = myZombie[2];
            ty = myZombie[3];
        }
// Write an action using print()
// To debug: stderr.writeln('Debug messages...');
//while(humans.length>0){
        print('${tx} ${ty}'); // Your destination coordinates
//}

    }
}

getHumanTargetForZombie(List humans, Map zombie) {
    var shortestDistance = -1;
    int targetId = -1;
    for (int i = 0; i < humans.length; i++) {
        Map human = humans[i];
        var distance = getDistance(zombie["x"], zombie["y"], human["x"], human["y"]);
        if (shortestDistance == -1 || distance < shortestDistance) {
            shortestDistance = distance;
            targetId = human["id"];
        }
    }
    return [targetId, shortestDistance];
}


List getClosestZombie(int humanX, int humanY, List zombies) {
    var shortestDistance = -1;
    int targetId = -1;
    int x,y;
    for (int i = 0; i < zombies.length; i++) {
        Map zombie = zombies[i];
        double distance = getDistance(zombie["x"], zombie["y"], humanX, humanY);
        if (shortestDistance == -1 || distance < shortestDistance) {
            shortestDistance = distance;
            targetId = zombie["id"];
            x= zombie["x"];
            y= zombie["y"];
        }
    }
    return [targetId, shortestDistance,x,y];
}

double getDistance(int xA, int yA, int xB, int yB) {
    return sqrt((pow((xA - xB), 2) + pow((yA - yB), 2)));
}
