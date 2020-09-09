import 'dart:io';
import 'dart:math';

Entity me = null;
List map = new List();
List explorers = new List();
List enemies = new List();
Entity closestExplorer = null;
Entity closestEnemy = null;

List effects = [[2,4,"PLAN"],
[3,2,"LIGHT"]];
/**
 * Survive the wrath of Kutulu
 * Coded fearlessly by JohnnyYuge & nmahoude (ok we might have been a bit scared by the old god...but don't say anything)
 **/
void main() {
    List inputs;
    int width = int.parse(stdin.readLineSync());
    int height = int.parse(stdin.readLineSync());
    for (int i = 0; i < height; i++) {
        String line = stdin.readLineSync();
        map.add(line);
        stderr.writeln(line);
    }
    inputs = stdin.readLineSync().split(' ');
    int sanityLossLonely = int.parse(inputs[0]); // how much sanity you lose every turn when alone, always 3 until wood 1
    int sanityLossGroup = int.parse(inputs[1]); // how much sanity you lose every turn when near another player, always 1 until wood 1
    int wandererSpawnTime = int.parse(inputs[2]); // how many turns the wanderer take to spawn, always 3 until wood 1
    int wandererLifeTime = int.parse(inputs[3]); // how many turns the wanderer is on map after spawning, always 40 until wood 1
    int effectTime=0;
    // game loop
    while (true) {
        if(effectTime > 0){
            effectTime-=1;
        }
        int entityCount = int.parse(stdin.readLineSync()); // the first given entity corresponds to your explorer
        explorers = new List();
        enemies = new List();
        for (int i = 0; i < entityCount; i++) {

            inputs = stdin.readLineSync().split(' ');
            String entityType = inputs[0];
            int id = int.parse(inputs[1]);
            int x = int.parse(inputs[2]);
            int y = int.parse(inputs[3]);
            int param0 = int.parse(inputs[4]);
            int param1 = int.parse(inputs[5]);
            int param2 = int.parse(inputs[6]);
            stderr.writeln("$id");
            if(i==0 ){
                me = Entity(entityType,id,x,y,param0,param1,param2);
            }else{
                if(entityType == "EXPLORER" ){
                    explorers.add(new Entity(entityType,id,x,y,param0,param1,param2));
                }else if(entityType == "WANDERER" || entityType == "SLASHER"){
                    enemies.add(new Entity(entityType,id,x,y,param0,param1,param2));
                }
            }

        }
        closestExplorer = getClosest(me, explorers);
        closestEnemy = getClosest(me, enemies);
        stderr.writeln(me.toString());
        stderr.writeln(closestExplorer.toString());

        stderr.writeln(closestEnemy.toString());
        // Write an action using print()

        if(closestEnemy== null){
            print('WAIT'); // MOVE <x> <y> | WAIT

        }else{
            num enemyDistance = getDistance(me, closestEnemy);
            if(enemyDistance < 5){
                //find cell arround me with bigger distance
                if(effectTime==0 && me.param0 < 100){
                    if(effects[1][0] > 0){
                        effects[1][0] -=1;
                        effectTime=effects[1][1];
                        print(effects[1][2]);
                    }else{
                        if(effects[0][0] > 0){
                            effects[0][0] -=1;
                            effectTime=effects[0][1];
                            print(effects[0][2]);
                        }else{
                            print('MOVE ${getSaftySpot(me,closestEnemy,enemyDistance)}');
                        }
                    }
                }else{
                    print('MOVE ${getSaftySpot(me,closestEnemy,enemyDistance)}');
                }

            }else{//if enemy if more than 4 away
                if(closestExplorer!= null){//move to explorer
                    //TODO until distance <=2 cells
                    num explorerDistance = getDistance(me, closestExplorer);
                    if(explorerDistance<5){
                        if(explorerDistance>0){
                            print('MOVE ${closestExplorer.x} ${closestExplorer.y} gotoexplorer');
                        }else{
                            print('YELL');
                        }
                    }else{
                        print('WAIT'); // MOVE <x> <y> | WAIT
                    }
                }else{
                    print('WAIT'); // MOVE <x> <y> | WAIT
                }
            }
            // To debug: stderr.writeln('Debug messages...');
        }

    }
}

getSaftySpot(Entity me,Entity enemy, num enemyDistance){
    String position = "";
    num furthestDistance = 0;
    for(var i = me.x-1;i<=me.x+1;i++){
        for(var j = me.y-1;j<=me.y+1;j++){
            if(isWakable(i,j)){

                num distance = getDistanceForPoint(enemy,i,j);
                stderr.writeln("wakable Pos $i,$j $distance");
                if(distance> furthestDistance){

                    furthestDistance = distance;

                    position = "$i $j";
                }
            }
        }
    }
    return position;
}

String getFieldonMap(num x, num y){
    return map[y][x];
}

bool isWakable(num x,num y){
    bool value =false;
    if(getFieldonMap(x,y)=="."){
        value = true;
    }
    return value;
}

Entity getClosest(Entity me, List entities){
    Entity closestEntity = null;
    num closest = 99999;
    for(Entity entity in entities){
        num distance = getDistance(me, entity);
        if(distance < closest){
            closest = distance;
            closestEntity = entity;
        }
    }
    return closestEntity;
}

num getDistance(Entity me, Entity entity){
    num result = 0;
    result = (me.x-entity.x).abs()+(me.y-entity.y).abs();
    return result;
}

num getDistanceForPoint(Entity me, num x, num y){
    num result = 0;
    result = (me.x-x).abs()+(me.y-y).abs();
    return result;
}

class Entity{
    String type;
    num id;
    num x;
    num y;
    num param0; //Explorer: sanity
    //Spawning minion: time before spawn
    //Wanderer: time before being recalled
    num param1;
    num param2;
    Entity(this.type,this.id,this.x,this.y,this.param0,this.param1,this.param2);
    Entity.emptyEntity();

    String toString(){
        return "type:$type,id:$id,x:$x,y:$y,param0:$param0,param1:$param1,param2:$param2";
    }

}
