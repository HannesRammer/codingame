import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
/*List map = ["#######",
"#.....#",
"#.###.#",
"#.#.#.#",
"#.#...#",
"#######"
];*/
List path = [];
List map =[];
void main() {
    List inputs;
    inputs = stdin.readLineSync().split(' ');
    //inputs = ["4", "1"];
    int starty = int.parse(inputs[0]);
    int startx = int.parse(inputs[1]);
    stderr.writeln('start : ${starty} ${startx}');
    inputs = stdin.readLineSync().split(' ');
    //inputs = ["3", "3"];
    int endy = int.parse(inputs[0]);
    int endx = int.parse(inputs[1]);
    stderr.writeln('end : ${endy} ${endx}');
    inputs = stdin.readLineSync().split(' ');
    //inputs = ["6", "7"];
    int h = int.parse(inputs[0]);
    int w = int.parse(inputs[1]);

// Think of the first index as "distance from the top row"
// Think of the second index as "distance from the left-most column"

// This is how we would represent the grid with obstacles above
    //stderr.writeln('gris:${grid}');
    // Create a hxw grid
// Represent the grid as a 2-dimensional array
    List grid = [];


    for (int i = 0; i < h; i++) {
        List row = [];
        for (int j = 0; j < w; j++) {
            if (starty == i && startx == j) {
                row.add('Start');
            } else if (endy == i && endx == j) {
                row.add('Goal');
            } else {
                row.add('floor');
            }
        }

        grid.add(row);
        //stderr.writeln('Row:${row}');
    }

    stderr.writeln('grid:${grid}');

    String floor = ".";
    String shortWall = "+";
    String vSlope = "|";
    String hSlope = "-";
    String highWall = "#";
    String bridge = "X";
    for (int i = 0; i < h; i++) {
        String line = stdin.readLineSync();
        //String line = map[i];
        map.add(line);
        for (int j = 0; j < w; j++) {
            //stderr.writeln('lj:${line[j]}');
            if (line[j] == highWall) {
                grid[i][j] = "highWall";
            } else if (line[j] == shortWall) {
                grid[i][j] = "shortWall";
            } else if (line[j] == vSlope) {
                grid[i][j] = "vSlope";
            } else if (line[j] == hSlope) {
                grid[i][j] = "hSlope";
            } else if (line[j] == bridge) {
                //stderr.writeln('contains:${obstacle.contains(line[j])}');
                grid[i][j] = "bridge";
            }
        }
        stderr.writeln('line:${line}');
    }
    //stderr.writeln('gridafter:${grid}');
    //stderr.writeln('${map}');

    print(findShortestPath(starty, startx, grid).length);
    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

}

List findShortestPath(int startY, int startX, grid) {
    var distanceFromTop = startY;
    var distanceFromLeft = startX;

// Each "location" will store its coordinates
// and the shortest path required to arrive there
    Map location = {
        "distanceFromTop": distanceFromTop,
        "distanceFromLeft": distanceFromLeft,
        "path": [],
        "status": 'Start',
        "ground": "floor"
    };

// Initialize the queue with the start location already inside
    List queue = [location];

    Map newLocation = {};
    // Loop through the grid searching for the goal
    while (queue.length > 0) {
        // Take the first location off the queue
        Map currentLocation = queue.removeAt(0);

        var directions = ["North", "East", "South", "West"];
        for (String dir in directions) {
            // Explore North
            //stderr.writeln('currentpathb4:${currentLocation["path"]}');
            //stderr.writeln('newpathb4:${newLocation["path"]}');
            newLocation = exploreInDirection(currentLocation, dir, grid);
            //stderr.writeln('currentpathAFTER:${currentLocation["path"]}');
            //stderr.writeln('newpathAFTER:${newLocation["path"]}');
            if (newLocation["status"] == 'Goal') {
                return newLocation["path"];
            } else if (newLocation["status"] == 'Valid') {
                queue.add(newLocation);
                stderr.writeln('path:${newLocation["path"]}');
            }
        }
    }

    // No valid path found
    return [];
}

// This function will check a location's status
// (a location is "valid" if it is on the grid, is not an "obstacle",
// and has not yet been visited by our algorithm)
// Returns "Valid", "Invalid", "Blocked", or "Goal"
String locationStatus(currentLocation, direction, goalLocation, grid) {
    int gridSize = grid.length;
    int dft = goalLocation["distanceFromTop"];
    int dfl = goalLocation["distanceFromLeft"];

    goalLocation["ground"]=grid[dft][dfl];
    if (goalLocation["distanceFromLeft"] < 0 || goalLocation["distanceFromLeft"] >= gridSize || goalLocation["distanceFromTop"] < 0 || goalLocation["distanceFromTop"] >= gridSize) {
// location is not on the grid--return false
        return 'Invalid';
    } else if (grid[dft][dfl] == 'Goal') {
        return 'Goal';
    } else if (grid[dft][dfl] == 'highWall' || grid[dft][dfl] == 'Visited') {
        // location is either an obstacle or has been visited
        return 'Blocked';
    } else if (grid[dft][dfl] == 'vSlope') {
        // location is either an obstacle or has been visited
        if (direction == "North" || direction == "South") {
            return 'Valid';
        } else {
            return 'Blocked';
        }
    } else if (grid[dft][dfl] == 'hSlope') {
        // location is either an obstacle or has been visited
        if (direction == "East" || direction == "West") {
            return 'Valid';
        } else {
            return 'Blocked';
        }
    } else if (grid[dft][dfl] == 'shortWall') {
        // location is either an obstacle or has been visited
        if (currentLocation["ground"] == "vSlope" || currentLocation["ground"] == "hSlope" || currentLocation["ground"] == "shortWall") {
            return 'Valid';
        } else {
            return 'Blocked';
        }
    } else if (grid[dft][dfl] == 'bridge') {
        // location is either an obstacle or has been visited
        return 'Blocked';
    } else if (grid[dft][dfl] == 'floor') {
        if (currentLocation["ground"] == "floor") {
            return 'Valid';
        } else if (currentLocation["ground"] == "vSlope") {
            if (direction == "North" || direction == "South") {
                return 'Valid';
            } else {
                return 'Blocked';
            }
        } else if (currentLocation["ground"] == "hSlope") {
            if (direction == "East" || direction == "West") {
                return 'Valid';
            } else {
                return 'Blocked';
            }
        } else if (currentLocation["ground"] == "bridge") {
            return 'Valid';
        }
    } else {
        //if visited
        return 'Blocked';
    }
}


// Explores the grid from the given location in the given
// direction
Map exploreInDirection(Map currentLocation, String direction, grid) {
    List newPath = new List.from(currentLocation["path"]);
    newPath.add(direction);


    int dft = currentLocation["distanceFromTop"];
    int dfl = currentLocation["distanceFromLeft"];

    if (direction == 'North') {
        dft -= 1;
    }
    else if (direction == 'East') {
        dfl += 1;
    }
    else if (direction == 'South') {
        dft += 1;
    }
    else if (direction == 'West') {
        dfl -= 1;
    }

    Map newLocation = {
        "distanceFromTop": dft,
        "distanceFromLeft": dfl,
        "path": newPath,
        "status": 'Unknown',
        "ground": 'Unknown'
    };
    //newLocation["ground"] = locationGround(newLocation, grid);
    newLocation["status"] = locationStatus(currentLocation, direction, newLocation, grid);

// If this new location is valid, mark it as 'Visited'
    if (newLocation["status"] == 'Valid') {
        grid[newLocation["distanceFromTop"]][newLocation["distanceFromLeft"]] = 'Visited';
    }
    return newLocation;
}
