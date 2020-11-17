import 'dart:io';
import 'dart:math';

class Action {
  int id;
  String actionType;
  List delta;

  int delta0;
  int delta1;
  int delta2;
  int delta3;
  int price;
  int tomeIndex;
  int taxCount;
  int castable;
  int repeatable;

  Action(this.id, this.actionType, this.delta0, this.delta1, this.delta2, this.delta3, this.price, this.tomeIndex, this.taxCount, this.castable, this.repeatable);

  String to_s() {
    return "id $id, actionType $actionType,delta0 $delta0,delta1 $delta1,delta2 $delta2,delta3 $delta3,price $price,tomeIndex $tomeIndex,taxCount $taxCount,castable $castable,repeatable $repeatable";
  }
}

List myInventory = [];
List enemyInventory = [];
List missingIngredients = [0, 0, 0, 0];

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
  List inputs;
  List actions = [];
  List portions = [];
  List spells = [];
  List opSpells = [];

  // game loop
  while (true) {
    actions = [];
    portions = [];
    spells = [];
    opSpells = [];
    myInventory = [];
    enemyInventory = [];
    missingIngredients = [0, 0, 0, 0];

    int actionCount = int.parse(stdin.readLineSync()); // the number of spells and recipes in play
    for (int i = 0; i < actionCount; i++) {
      inputs = stdin.readLineSync().split(' ');
      int actionId = int.parse(inputs[0]); // the unique ID of this spell or recipe
      String actionType = inputs[1]; // in the first league: BREW; later: CAST, OPPONENT_CAST, LEARN, BREW
      int delta0 = int.parse(inputs[2]); // tier-0 ingredient change
      int delta1 = int.parse(inputs[3]); // tier-1 ingredient change
      int delta2 = int.parse(inputs[4]); // tier-2 ingredient change
      int delta3 = int.parse(inputs[5]); // tier-3 ingredient change
      int price = int.parse(inputs[6]); // the price in rupees if this is a potion
      int tomeIndex = int.parse(inputs[
                                7]); // in the first two leagues: always 0; later: the index in the tome if this is a tome spell, equal to the read-ahead tax; For brews, this is the value of the current urgency bonus
      int taxCount = int.parse(inputs[
                               8]); // in the first two leagues: always 0; later: the amount of taxed tier-0 ingredients you gain from learning this spell; For brews, this is how many times you can still gain an urgency bonus
      int castable = int.parse(inputs[9]); // in the first league: always 0; later: 1 if this is a castable player spell
      int repeatable = int.parse(inputs[10]); // for the first two leagues: always 0; later: 1 if this is a repeatable player spell
      Action a = new Action(actionId, actionType, delta0, delta1, delta2, delta3, price, tomeIndex, taxCount, castable, repeatable);
      if (actionType == "BREW") {
        portions.add(a);
      } else if (actionType == "CAST") {
        spells.add(a);
      } else if (actionType == "OPPONENT_CAST") {
        opSpells.add(a);
      } else {
        actions.add(a);
      }
    }
    for (int i = 0; i < 2; i++) {
      inputs = stdin.readLineSync().split(' ');
      int inv0 = int.parse(inputs[0]); // tier-0 ingredients in inventory
      int inv1 = int.parse(inputs[1]);
      int inv2 = int.parse(inputs[2]);
      int inv3 = int.parse(inputs[3]);
      int score = int.parse(inputs[4]); // amount of rupees
      if (i == 0) {
        myInventory = [inv0, inv1, inv2, inv3, score];
      } else {
        enemyInventory = [inv0, inv1, inv2, inv3, score];
      }
    }
    Action brew = findMostExpensivePayableBrew(portions);
    stderr.writeln("brew $brew");
    if (brew == null) {
      Action portion = findCheapestUnpayableBrew(portions);
      findMissingIngredients(myInventory, portion);
      String spell = findSpell(myInventory, spells);
      print(spell);
    } else {
      print('BREW ${brew.id}');
    }
    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    // in the first league: BREW <id> | WAIT; later: BREW <id> | CAST <id> [<times>] | LEARN <id> | REST | WAIT
  }
}

void findMissingIngredients(List inventory, Action portion) {
  stderr.writeln("-----------findMissingIngredients");

  int missing0 = portion.delta0 + inventory[0];
  int missing1 = portion.delta1 + inventory[1];
  int missing2 = portion.delta2 + inventory[2];
  int missing3 = portion.delta3 + inventory[3];
  if (missing0 < 0) {
    missingIngredients[0] = -missingIngredients[0] + missing0;
  }
  if (missing1 < 0) {
    missingIngredients[1] = -missingIngredients[1] + missing1;
  }
  if (missing2 < 0) {
    missingIngredients[2] = -missingIngredients[2] + missing2;
  }
  if (missing3 < 0) {
    missingIngredients[3] = -missingIngredients[3] + missing3;
  }
  stderr.writeln("missingIngredients $missingIngredients");
}

Action findMostExpensivePayableBrew(List actions) {
  stderr.writeln("-----------findMostExpensivePayableBrew");

  num currentPrice = -1;
  Action targetAction;
  stderr.writeln("targetAction $targetAction");
  for (int i = 0; i < actions.length; i++) {
    Action a = actions[i];

    if (a.price > currentPrice && invCanPayForBrew(myInventory, a)) {
      stderr.writeln("${a.to_s()}");

      //if (!ignoredWrecks.contains(u.id) && (fullestWater == -1 || water > fullestWater)) {
      currentPrice = a.price;
      targetAction = a;
    }
  }
  stderr.writeln("targetAction $targetAction");
  return targetAction;
}

Action findCheapestUnpayableBrew(List actions) {
  stderr.writeln("-----------findCheapestUnpayableBrew");
  num currentPrice = 9999;
  Action targetPortion;
  for (int i = 0; i < actions.length; i++) {
    Action a = actions[i];

    if (a.price < currentPrice && !invCanPayForBrew(myInventory, a)) {
      //if (!ignoredWrecks.contains(u.id) && (fullestWater == -1 || water > fullestWater)) {
      currentPrice = a.price;
      targetPortion = a;
    }
  }

  return targetPortion;
}

String findSpell(List myInventory, List spells) {
  //TODO
  stderr.writeln("-----------findSpell");
  Action targetSpell;
  bool recharge = false;
//  for (int i = 0; i < spells.length; i++) {
//    Action a = spells[i];

//    bool isCastable = a.castable == 1;
//    if (isCastable) {
  bool tier3IsMissing = missingIngredients[3] < 0;
  bool hasTier2 = myInventory[2] > 0;
  bool checkTier2 = false;
  bool tier2IsMissing = false;
  if (tier3IsMissing) {
    stderr.writeln("tier3IsMissing");
    if (hasTier2) {
      stderr.writeln("hasTier2");
      if (spells[3].castable == 1) {
        stderr.writeln("targetSpell = spells[3]");
        targetSpell = spells[3];
      } else {
        stderr.writeln("checkTier2");
        recharge = true;
        checkTier2 = true;
      }
    } else {
      checkTier2 = true;
      tier2IsMissing = true;
    }
  } else {
    checkTier2 = true;
  }

  tier2IsMissing = tier2IsMissing || missingIngredients[2] < 0;
  bool hasTier1 = myInventory[1] > 0;
  bool checkTier1 = false;
  bool tier1IsMissing = false;
  if (checkTier2) {
    stderr.writeln("checkTier2");
    if (tier2IsMissing) {
      stderr.writeln("tier2IsMissing");
      if (hasTier1) {
        stderr.writeln("hasTier1");

        if (spells[2].castable == 1) {
          stderr.writeln("targetSpell = spells[2]");

          targetSpell = spells[2];
          recharge = false;
        } else {
          stderr.writeln("recharge");
          recharge = true;
        }
      } else {
        checkTier1 = true;
        tier1IsMissing = true;
      }
    } else {
      checkTier1 = true;
    }
  }

  tier1IsMissing = tier1IsMissing || missingIngredients[1] < 0;
  bool hasTier0 = myInventory[0] > 0;
  bool createTier0 = false;
  if (checkTier1) {
    stderr.writeln("checkTier1");

    if (tier1IsMissing) {
      stderr.writeln("tier1IsMissing");

      if (hasTier0) {
        stderr.writeln("hasTier0");

        if (spells[1].castable == 1) {
          stderr.writeln("targetSpell = spells[1]");

          targetSpell = spells[1];
          recharge = false;
        } else {
          stderr.writeln("recharge");
          recharge = true;
        }
      } else {
        createTier0 = true;
      }
    } else {
      createTier0 = true;
    }
  }

  if (createTier0 ) {
    if (spells[0].castable == 1) {
      targetSpell = spells[0];
      recharge = false;
    } else {
      recharge = true;
    }
  }
  String text = "";
  if (recharge) {
    text = "REST";
  } else {
    text = "CAST ${targetSpell.id}";
    stderr.writeln("spell ${targetSpell.to_s()}");
  }

//    }else{
//      recharge +=1;
//    }
//  }

//  return targetSpell;
  return "$text";
}

bool invCanPayForBrew(List inventory, Action action) {
  stderr.writeln("-----------invCanPayForBrew");
  bool canPay = false;
  bool canPay0 = false;
  bool canPay1 = false;
  bool canPay2 = false;
  bool canPay3 = false;

  if (action.delta0 == 0) {
    canPay0 = true;
  } else {
    if (inventory[0] + action.delta0 >= 0) {
      // plus negative number
      canPay0 = true;
    }
  }

  if (action.delta1 == 0) {
    canPay1 = true;
  } else {
    if (inventory[1] + action.delta1 >= 0) {
      // plus negative number
      canPay1 = true;
    }
  }

  if (action.delta2 == 0) {
    canPay2 = true;
  } else {
    if (inventory[2] + action.delta2 >= 0) {
      // plus negative number
      canPay2 = true;
    }
  }

  if (action.delta3 == 0) {
    canPay3 = true;
  } else {
    if (inventory[3] + action.delta3 >= 0) {
      // plus negative number
      canPay3 = true;
    }
  }
  if (canPay0 && canPay1 && canPay2 && canPay3) {
    canPay = true;
  }
  return canPay;
}
