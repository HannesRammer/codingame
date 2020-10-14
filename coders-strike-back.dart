import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
List lastPosition = [0,0];
int thrust=0;
List vXY = [0,0];
void main() {
    List inputs;
    var boost = 0;
    // game loop
    while (true) {

        inputs = stdin.readLineSync().split(' ');
        int x = int.parse(inputs[0]);
        int y = int.parse(inputs[1]);
        vXY = [x-lastPosition[0], y-lastPosition[1]];
        stderr.writeln("vXY $vXY");
        lastPosition = [x,y];
        int nextCheckpointX = int.parse(inputs[2]); // x position of the next check point
        int nextCheckpointY = int.parse(inputs[3]); // y position of the next check point
        int nextCheckpointDist = int.parse(inputs[4]); // distance to the next checkpoint
        int nextCheckpointAngle = int.parse(inputs[5]); // angle between your pod orientation and the direction of the next checkpoint
        inputs = stdin.readLineSync().split(' ');
        int opponentX = int.parse(inputs[0]);
        int opponentY = int.parse(inputs[1]);

        nextCheckpointX = nextCheckpointX - vXY[0];
        nextCheckpointY = nextCheckpointY - vXY[1];
        // Write an action using print()
        // To debug: stderr.writeln('Debug messages...');
        int t = (nextCheckpointDist/10).toInt();


        stderr.writeln('nextCheckpointAngle:${nextCheckpointAngle}');
        stderr.writeln('nextCheckpointDist:${nextCheckpointDist}');
        if (nextCheckpointDist <= 1000){

            thrust = 50;


        }else{
            thrust=100;
        }
        if(nextCheckpointAngle >100 || nextCheckpointAngle <-100){
            thrust=0;//(thrust/10).toInt();
        }


        // You have to output the target position
        // followed by the power (0 <= thrust <= 100)
        // i.e.: "x y thrust"
        if(nextCheckpointDist > 6000 && nextCheckpointAngle <4 && nextCheckpointAngle >-4){
            print("${nextCheckpointX} ${nextCheckpointY} BOOST 100");

        }else{
            if(boost==0){
                print("${nextCheckpointX} ${nextCheckpointY} BOOST BOOSTTWO");
                boost=1;
            }else{
                /*if(nextCheckpointAngle > -50 && nextCheckpointAngle < 50){
                    thrust = (100 - (((nextCheckpointAngle).abs()).abs()).toInt());

                }else{
                    thrust = 70;
                }
                if(nextCheckpointAngle > -10 && nextCheckpointAngle < 10){
                    thrust = (100 - ((nextCheckpointAngle).abs()).abs()*1);

                }*/
                //print("${nextCheckpointX} ${nextCheckpointY} $thrust THRUST $thrust");
                print("${nextCheckpointX} ${nextCheckpointY} 100 THRUST $thrust");
            }
        }

    }
}

double getDistance(int xA, int yA, int xB, int yB) {
    return sqrt((pow((xA - xB), 2) + pow((yA - yB), 2)));
}
