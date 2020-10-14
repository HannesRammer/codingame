import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
Map<int, Position> checkpoints = {};

class Unit {
  int id;
  int x;
  int y;
  int vx;
  int vy;
  int angle;
  int nextCheckpointId;
  Position nextCheckpoint;
  Position calcCheckpoint;
  Position position;

  Unit(this.id, this.x, this.y, this.vx, this.vy, this.angle, this.nextCheckpointId, this.nextCheckpoint, this.calcCheckpoint, this.position);

  String toString() =>
          "Unit => Id: $id x: $x  y: $y  vx: $vx  vy: $vy  angle: $angle nextCheckpointId $nextCheckpointId  nextCheckpoint: $nextCheckpoint  nextCalcCheckpoint: $calcCheckpoint Position: $position";
}

class Position {
  int x;
  int y;

  Position(this.x, this.y);

  String toString() => '$x $y';

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + x;
    result = 37 * result + y;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Position) return false;
    return other.x == x && other.y == y;
  }

//  num distance(Position p) => (x - p.x).abs() + (y - p.y).abs();
  num distance(Position p) => sqrt((pow((x - p.x), 2) + pow((y - p.y), 2)));
}

List<Unit> myUnits = [];
List<Unit> opponentUnits = [];

void main() {
  List inputs;
  int laps = int.parse(stdin.readLineSync());
  int checkpointCount = int.parse(stdin.readLineSync());
  for (int i = 0; i < checkpointCount; i++) {
    inputs = stdin.readLineSync().split(' ');
    int checkpointX = int.parse(inputs[0]);
    int checkpointY = int.parse(inputs[1]);
    Position checkpointPos = Position(checkpointX, checkpointY);

    checkpoints[i] = checkpointPos;
  }
  int boost = 0;
  // game loop
  while (true) {
    myUnits.clear();
    opponentUnits.clear();
    // Read your Units
    for (int i = 0; i < 2; i++) {
      inputs = stdin.readLineSync().split(' ');
      int x = int.parse(inputs[0]); // x position of your pod
      int y = int.parse(inputs[1]); // y position of your pod
      int vx = int.parse(inputs[2]); // x speed of your pod
      int vy = int.parse(inputs[3]); // y speed of your pod
      int angle = int.parse(inputs[4]); // angle of your pod
      int nextCheckPointId = int.parse(inputs[5]); // next check point id of your pod
      Position position = Position(x, y);
      Position nextCheckpoint = checkpoints[nextCheckPointId]; // x position of the next check point
      int nextCheckpointX = nextCheckpoint.x; // x position of the next check point
      int nextCheckpointY = nextCheckpoint.y; // y position of the next check point

      Position calcCheckpoint = Position(nextCheckpointX - vx, nextCheckpointY - vy);
      myUnits.add(Unit(i, x, y, vx, vy, angle, nextCheckPointId, nextCheckpoint, calcCheckpoint, position));
    }
    // Read opponent Units
    for (int i = 0; i < 2; i++) {
      inputs = stdin.readLineSync().split(' ');
      int x2 = int.parse(inputs[0]); // x position of the opponent's pod
      int y2 = int.parse(inputs[1]); // y position of the opponent's pod
      int vx2 = int.parse(inputs[2]); // x speed of the opponent's pod
      int vy2 = int.parse(inputs[3]); // y speed of the opponent's pod
      int angle2 = int.parse(inputs[4]); // angle of the opponent's pod
      int nextCheckPointId2 = int.parse(inputs[5]); // next check point id of the opponent's pod
      Position position2 = Position(x2, y2);
      Position nextCheckpoint2 = checkpoints[nextCheckPointId2]; // x position of the next check point
      int nextCheckpointX2 = nextCheckpoint2.x; // x position of the next check point
      int nextCheckpointY2 = nextCheckpoint2.y;
      // y position of the next check point

      Position calcCheckpoint2 = Position(nextCheckpointX2 - vx2, nextCheckpointY2 - vy2);
      opponentUnits.add(Unit(i, x2, y2, vx2, vy2, angle2, nextCheckPointId2, nextCheckpoint2, calcCheckpoint2, position2));
    }

    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    // You have to output the target position
    // followed by the power (0 <= thrust <= 100)
    // i.e.: "x y thrust"
    int thrust = 100;
    for (var i = 0; i < myUnits.length; ++i) {
      Unit unit = myUnits[i];
      num nextCheckpointDist = unit.position.distance(unit.nextCheckpoint);
      stderr.writeln("nextCheckpointDist:${nextCheckpointDist} ");
      if (nextCheckpointDist <= 1500) {
        thrust = 100;
      } else {
        thrust = 100;
      }
      //if (unit.angle > 100 || unit.angle < -100) {
      //  thrust = 30;//thrust = 0;
      //}

      Position cC = unit.calcCheckpoint;
      bool shield = false;
      stderr.writeln("id:${unit.id} angle: ${unit.angle}");
      for (Unit opponent in opponentUnits) {
        if (opponent.position.distance(unit.position) <= 1000) {
          shield = true;
        }
      }
      Position closestOpponent = getClosestPos(unit.position, opponentUnits);
      if (false && i == 1) {
        print("${closestOpponent.x} ${closestOpponent.y} 100 closestOpponent 100");
      } else {
        if (shield && (unit.vx > 200 || unit.vy > 200)) {
          print("${cC.x} ${cC.y} SHIELD SHIELD");
        } else {
          if (boost == 0) {
            print("${cC.x} ${cC.y} BOOST BOOST");
            boost = 1;
          } else {
            print("${cC.x} ${cC.y} $thrust THRUST $thrust");
          }
        }
      }
    }
  }
}

Position getClosestPos(Position myPos, List<Unit> units) {
  num shortestDistance = -1;
  Position targetField = null;
  for (int i = 0; i < units.length; i++) {
    Unit u = units[i];
    Position pos = u.position;
    num distance = pos.distance(myPos);
    if ((distance < shortestDistance || shortestDistance == -1)) {
      shortestDistance = distance;
      targetField = pos;
    }
  }
  return targetField;
}
