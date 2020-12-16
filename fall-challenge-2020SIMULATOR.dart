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
  num worth;

  // This is the key named contructor
  Action.clone(Action action)
      : this(action.id, action.actionType, action.delta0, action.delta1, action.delta2, action.delta3, action.price, action.tomeIndex,
            action.taxCount, action.castable, action.repeatable);

  Action(this.id, this.actionType, this.delta0, this.delta1, this.delta2, this.delta3, this.price, this.tomeIndex, this.taxCount, this.castable,
      this.repeatable) {
    delta = [delta0, delta1, delta2, delta3];
    worth = getDeltaSum() + getStoneAmount();
    if (repeatable == 1) {
      worth = worth * 1.25;
    } else {
      worth = worth * 0.85;
    }
  }

  bool hasOnlyPositiv() {
    bool hasPos = true;
    for (int i = 0; i < 4; ++i) {
      if (delta[i] < 0) {
        hasPos = false;
      }
    }
    return hasPos;
  }

  /*num getDeltaSum(List delta) {
    num sum = 0;
    for (int i = 0; i < delta.length; ++i) {
      sum += delta[i] * (i + 1);
    }
    return sum;
  }
*/
  num getDeltaSum() {
    num sum = 0;
    sum = (0.95 * 1 * delta[0]) + (0.95 * 2 * delta[1]) + (0.95 * 3 * delta[2]) + (0.95 * 4 * delta[3]);
    return sum;
  }

  num getDeltaSumWithPotionAndInventory(Action potion, List inventory, String spaceholder) {
    num sum = 0;
    dxt("");
    dxt("${spaceholder}getDeltaSumWithPotionAndInventory");

    if (inventory[0] + delta[0] >= potion.delta[0]) {
      sum += (0.95 * 1 * delta[0]);
    }
    if (inventory[1] + delta[1] >= potion.delta[1]) {
      sum += (0.95 * 2 * delta[1]);
    }
    if (inventory[2] + delta[2] >= potion.delta[2]) {
      sum += (0.95 * 3 * delta[2]);
    }
    if (inventory[3] + delta[3] >= potion.delta[3]) {
      sum += (0.95 * 4 * delta[3]);
    }
    dxt("${spaceholder}       inv ${inventory}");
    dxt("${spaceholder}    potion ${potion.delta}");
    dxt("${spaceholder}this.delta ${delta} sum $sum");
    return sum;
  }

  num bringsInventoryAndPostionCloserBy(List missingIngredients, String spaceholder) {
    num sum = 0;
    dxt("");
    dxt("${spaceholder}bringsInventoryAndPostionCloserBy");
    for (int i = 0; i < 4; ++i) {
      if (missingIngredients[i] < 0 && delta[i] > 0) {
        int tSum = missingIngredients[i] + delta[i];
        if (tSum > 0) {
          sum += missingIngredients[i] * -1;
        } else {
          sum += delta[i];
        }
      }
    }

    dxt("${spaceholder}this.delta ${delta} sum $sum");
    return sum;
  }

  num getStoneAmount() {
    num sum = 0;
    for (int i = 0; i < delta.length; ++i) {
      sum += delta[i];
    }
    return sum;
  }

  bool isSafeToCastForPotion(Action potion, List inventory, String spaceholder) {
    //stderr.write("${spaceholder}isSafeToCastForPotion");
    bool safeToCast = true;

    List sDelta = delta;
    List pDelta = potion.delta;
    List iDelta = inventory;
//  dxt(" inventory ${inventory}");
//  dxt("+spell     ${delta}");
//  dxt("+potion    ${potion.delta}");
//  dxt("iDelta[i] + sDelta[i] < -1 * pDelta[i] ");

    for (int i = 0; i < 4; ++i) {
      if (sDelta[i] < 0) {
//      dxt("${iDelta[i]} + ${sDelta[i]} < ${-1 * pDelta[i]} ## ${(iDelta[i] + sDelta[i] < -1 * pDelta[i])}");
        if (iDelta[i] + sDelta[i] < -1 * pDelta[i]) {
//      if (iDelta[i] + sDelta[i] < 0) {
//        dxt("not safe to cast");
          safeToCast = false;
          break;
        } else {
//        dxt(" safe to cast");
        }
      }
    }
//  dxt("${spaceholder} END isSafeToCastWithCalculation");
    return safeToCast;
  }

  bool isSaveToCastWithoutDelta(List inventory, String spaceholder) {
    bool isSave = (isPayable(inventory, spaceholder) && willFitInventory(inventory, spaceholder) && (castable == 1));
    if (isSave) {
      //stderr.write("${spaceholder}isSaveToCastWithoutDelta");
    }
    return isSave;
  }

  bool isSaveToCast(int deltaId, List inventory, String spaceholder) {
    //stderr.write("${spaceholder}isSaveToCast");

    return (hasDelta(deltaId, spaceholder) && isSaveToCastWithoutDelta(inventory, spaceholder));
  }

  bool hasDelta(int deltaId, String spaceholder) {
    stderr.write("${spaceholder}hasDelta");

    return delta[deltaId] > 0;
  }

  bool isPayable(List inventory, String spaceholder) {
    bool canPay = false;
    bool canPay0 = false;
    bool canPay1 = false;
    bool canPay2 = false;
    bool canPay3 = false;
    if (delta[0] == 0) {
      canPay0 = true;
    } else {
      if (inventory[0] + delta[0] >= 0) {
        canPay0 = true;
      }
    }
    if (delta[1] == 0) {
      canPay1 = true;
    } else {
      if (inventory[1] + delta[1] >= 0) {
        canPay1 = true;
      }
    }
    if (delta[2] == 0) {
      canPay2 = true;
    } else {
      if (inventory[2] + delta[2] >= 0) {
        canPay2 = true;
      }
    }
    if (delta[3] == 0) {
      canPay3 = true;
    } else {
      if (inventory[3] + delta[3] >= 0) {
        canPay3 = true;
      }
    }
    if (canPay0 && canPay1 && canPay2 && canPay3) {
      canPay = true;
      // stderr.write("${spaceholder}isPayable");
    }
    return canPay;
  }

  bool willFitInventory(List inventory, String spaceholder) {
    num numberOfItemsInInv = getNumberOfItemsInInventory(inventory);
    num neededSpace = getStoneAmount();
    bool willFit = (10 - numberOfItemsInInv) >= neededSpace;
    // if (willFit) {
    //  stderr.write("${spaceholder}willFitInventory $willFit");
    // }
    return willFit;
  }

  List findMissingIngredients(List inventory, String spaceholder) {
    List missingIngredients = [0, 0, 0, 0];
    int missing0 = delta0 + inventory[0];
    int missing1 = delta1 + inventory[1];
    int missing2 = delta2 + inventory[2];
    int missing3 = delta3 + inventory[3];
    // if (missing0 < 0) {
    missingIngredients[0] = missing0;
    // }
    // if (missing1 < 0) {
    missingIngredients[1] = missing1;
    // }
    // if (missing2 < 0) {
    missingIngredients[2] = missing2;
    // }
    // if (missing3 < 0) {
    missingIngredients[3] = missing3;
    // }
    dxt("${spaceholder}findMissingIngredients ${missingIngredients}");
    return missingIngredients;
  }

  String to_s() {
    return "id $id, actionType $actionType,delta0 $delta0,delta1 $delta1,delta2 $delta2,delta3 $delta3,price "
        "$price,tomeIndex $tomeIndex,taxCount $taxCount,castable $castable,repeatable $repeatable, worth $worth, ";
  }
}

int potionTierSize = 0;
int roundCounter = 0;
Action goalPotion;
bool debug = true;

int price = 0;
int simCounter = 0;
int brewSum = 0;

List<List<int>> spellsToLearn = [
  [-1, 0, 0, 0],
  [0, -1, 0, 0],
  [0, 0, -1, 0]
];

bool hasCastablePositiveSpells(List spells) {
  bool hasPositiveSpells = false;
  for (int i = 0; i < spells.length; ++i) {
    Action spell = spells[i];
    if (spell.castable == 1 && spell.hasOnlyPositiv()) {
      hasPositiveSpells = true;
      break;
    }
  }
  return hasPositiveSpells;
}

int numberOfAvailableSpells(List spells, String spaceholder) {
  int counter = 0;
  for (int i = 0; i < spells.length; ++i) {
    Action spell = spells[i];
    if (spell.castable == 1) {
      counter++;
    }
  }
  dxt("${spaceholder}numberOfAvailableSpells $counter");
  return counter;
}

bool spellIsDowngrade(Action spell) {
  bool isDowngrade = false;
  // if(spell.delta[0]>0 && ((spell.delta[1]>0))|| (spell.delta[1]>0)|| (spell.delta[1]>0)){
  if (((spell.delta[2] < 0) && (spell.delta[3] == 0))) {
    // if ((spell.delta[3] < 0) || ((spell.delta[2] < 0) && (spell.delta[3] == 0))) {
    isDowngrade = true;
  }
  return isDowngrade;
}

bool spellIsInWishlist(Action spell, String spaceholder) {
  bool isWishlist = false;
  dxt("${spaceholder}tomeSpell.delta ${spell.delta}");

  if (spell.delta[0] <= -2 || spell.delta[1] <= -2 || spell.delta[2] <= -2) {
    // if (((spell.delta[0] < 0) && (spell.delta[0] <= spellToLearn[0])) ||
    //     ((spell.delta[1] < 0) && (spell.delta[1] <= spellToLearn[1])) ||
    //     ((spell.delta[2] < 0) && (spell.delta[2] <= spellToLearn[2])) ||
    //     ((spell.delta[3] < 0) && (spell.delta[3] <= spellToLearn[3]))) {
    isWishlist = true;
  }
  dxt("${spaceholder}isWishlist $isWishlist");

  return isWishlist;
}

num getNumberOfItemsInInventory(List inventory) {
  //stderr.writeln("getNumberOfItemsInInventory ${inventory[0] + inventory[1] + inventory[2] + inventory[3]}");
  return (inventory[0] + inventory[1] + inventory[2] + inventory[3]);
}

int canSpellXTime(List inventory, Action spell, String spaceholder) {
  dxt("${spaceholder}canSpellXTime");

  int times = 1;
  if (spell.repeatable == 1) {
    Action doubleSpell = Action.clone(spell);

    List dDelta = doubleSpell.delta;
    for (int i = 0; i < dDelta.length; ++i) {
      doubleSpell.delta[i] *= 2;
    }
    if (invCanPayForXAction(inventory, doubleSpell) && doubleSpell.willFitInventory(inventory, spaceholder + "--")) {
      times = 2;
    }
  }

  return times;
}

void dxt(String text) {
  if (debug) {
    stderr.writeln(text);
  }
}

Action findMostExpensivePayableBrew(List actions, List inventory, String spaceholder) {
  dxt("${spaceholder}findMostExpensivePayableBrew");
  num currentPrice = -1;
  Action targetAction;
  dxt("${spaceholder}targetAction $targetAction");
  for (int i = 0; i < actions.length; ++i) {
    Action a = actions[i];
    if (a.price > price && a.price > currentPrice && a.isPayable(inventory, spaceholder + "--")) {
      dxt("${spaceholder}${a.to_s()}");
      currentPrice = a.price;
      targetAction = a;
    }
  }
  if (targetAction != null) {
    dxt("${spaceholder}findMostExpensivePayableBrew ${targetAction.to_s()}");
  }
  return targetAction;
}

bool rest = false;

Action simulateBrew(List myInventory, List<Action> spells, List<Action> potions, String spaceholder) {
  stderr.writeln("${spaceholder}##########START SIMULATION##########");
  dxt("${spaceholder}myInventory ${myInventory}");
  dxt("${spaceholder}spells ${spells.length}");
  dxt("${spaceholder}potions ${potions.length}");

//  Action brew = findMostExpensivePayableBrew(potions, myInventory);
  Action targetPotion;
  int targetSimCounter = 15;
  List cloneSpells = [];
  for (int j = 0; j < spells.length; ++j) {
    cloneSpells.add(Action.clone(spells[j]));
  }
  List clonePotions = [];
  for (int j = 0; j < potions.length; ++j) {
//    clonePotions.add(Action.clone(potions[j]));
    clonePotions.add(potions[j]);
  }
  for (int i = 0; i < clonePotions.length; ++i) {
    Action brew = clonePotions[i];
    stderr.writeln("${spaceholder}startWhile brew PORTION ${brew.delta}");
    simCounter = 0;
    num average = -99999;
    List inventory = [...myInventory];
    dxt("${spaceholder}  myInventory           ${inventory}");
    bool canPay = brew.isPayable(inventory, spaceholder + "--");
    while (!canPay && simCounter < targetSimCounter) {
      //  while (!canPay) {
      dxt("${spaceholder}simCounter $simCounter");

      dxt("${spaceholder}####WHILE round $simCounter");
      dxt("${spaceholder}  myInventory           ${inventory}");
      dxt("${spaceholder}- potion                ${brew.delta}");
      List missingIngredients = brew.findMissingIngredients(inventory, spaceholder + "--");
      dxt("${spaceholder}- missingIngredients    ${missingIngredients}");

      Action spell;
      spell = findBestSpellForMissing(cloneSpells, inventory, brew, spaceholder + "--");
      //spell = findBestSpell(inventory, cloneSpells, missingIngredients, brew);

      if (spell != null) {
        List spellDeltas = spell.delta;
        dxt("${spaceholder}startWhile brew PORTION ${brew.delta}");
        dxt("${spaceholder} i b4 ${inventory}");
        inventory[0] = inventory[0] + spellDeltas[0];
        inventory[1] = inventory[1] + spellDeltas[1];
        inventory[2] = inventory[2] + spellDeltas[2];
        inventory[3] = inventory[3] + spellDeltas[3];
        dxt("${spaceholder}+spell ${spellDeltas}");
        dxt("${spaceholder} i Af ${inventory}");
        missingIngredients = brew.findMissingIngredients(inventory, "--");
        spell.castable = 0;
        simCounter++;
      } else {
        dxt("${spaceholder}#####REST#####");
        rest = true;
        for (int j = 0; j < cloneSpells.length; ++j) {
          cloneSpells[j].castable = 1;
        }
        simCounter++;
      }
      canPay = brew.isPayable(inventory, spaceholder + "--");
      dxt("${spaceholder}CAN PAY $canPay");
    }
    dxt("${spaceholder}simCounter $simCounter");
    // if (simCounter >= 0 && (brew.price / simCounter) > average) {
    if (simCounter >= 0 && simCounter < targetSimCounter) {
      // if (simCounter >= 0 && simCounter < targetSimCounter) {
      targetSimCounter = simCounter;
      average = brew.price / simCounter;
      targetPotion = brew;
      dxt("${spaceholder}UPDATE BREW ${brew.delta} simCounter $simCounter");
    }
  }
  if (targetPotion != null) {
    dxt("${spaceholder}${targetPotion.to_s()}##########END SIMULATION##########");
  }
  return targetPotion;
}

Action simulateAllBrew(List myInventory, List<Action> spells, List<Action> potions, String spaceholder) {
  List potionCombinations3 = [
    [1, 2, 3],
    [1, 3, 2],
    [3, 1, 2],
    [3, 2, 1],
    [2, 3, 1],
    [2, 1, 3],
    [1, 2, 4],
    [1, 4, 2],
    [4, 1, 2],
    [4, 2, 1],
    [2, 4, 1],
    [2, 1, 4],
    [1, 2, 5],
    [1, 5, 2],
    [5, 1, 2],
    [5, 2, 1],
    [2, 5, 1],
    [2, 1, 5],
    [1, 3, 4],
    [1, 4, 3],
    [4, 1, 3],
    [4, 3, 1],
    [3, 4, 1],
    [3, 1, 4],
    [1, 3, 5],
    [1, 5, 3],
    [5, 1, 3],
    [5, 3, 1],
    [3, 5, 1],
    [3, 1, 5],
    [1, 4, 5],
    [1, 5, 4],
    [5, 1, 4],
    [5, 4, 1],
    [4, 5, 1],
    [4, 1, 5],
    [2, 3, 4],
    [2, 4, 3],
    [4, 2, 3],
    [4, 3, 2],
    [3, 4, 2],
    [3, 2, 4],
    [2, 3, 5],
    [2, 5, 3],
    [5, 2, 3],
    [5, 3, 2],
    [3, 5, 2],
    [3, 2, 5],
    [2, 4, 5],
    [2, 5, 4],
    [5, 2, 4],
    [5, 4, 2],
    [4, 5, 2],
    [4, 2, 5],
    [3, 4, 5],
    [3, 5, 4],
    [5, 3, 4],
    [5, 4, 3],
    [4, 5, 3],
    [4, 3, 5]
  ];

  List potionCombinations5 = [
    [1, 2, 3, 4, 5],
    [2, 1, 3, 4, 5],
    [3, 1, 2, 4, 5],
    [1, 3, 2, 4, 5],
    [2, 3, 1, 4, 5],
    [3, 2, 1, 4, 5],
    [3, 2, 4, 1, 5],
    [2, 3, 4, 1, 5],
    [4, 3, 2, 1, 5],
    [3, 4, 2, 1, 5],
    [2, 4, 3, 1, 5],
    [4, 2, 3, 1, 5],
    [4, 1, 3, 2, 5],
    [1, 4, 3, 2, 5],
    [3, 4, 1, 2, 5],
    [4, 3, 1, 2, 5],
    [1, 3, 4, 2, 5],
    [3, 1, 4, 2, 5],
    [2, 1, 4, 3, 5],
    [1, 2, 4, 3, 5],
    [4, 2, 1, 3, 5],
    [2, 4, 1, 3, 5],
    [1, 4, 2, 3, 5],
    [4, 1, 2, 3, 5],
    [5, 1, 2, 3, 4],
    [1, 5, 2, 3, 4],
    [2, 5, 1, 3, 4],
    [5, 2, 1, 3, 4],
    [1, 2, 5, 3, 4],
    [2, 1, 5, 3, 4],
    [2, 1, 3, 5, 4],
    [1, 2, 3, 5, 4],
    [3, 2, 1, 5, 4],
    [2, 3, 1, 5, 4],
    [1, 3, 2, 5, 4],
    [3, 1, 2, 5, 4],
    [3, 5, 2, 1, 4],
    [5, 3, 2, 1, 4],
    [2, 3, 5, 1, 4],
    [3, 2, 5, 1, 4],
    [5, 2, 3, 1, 4],
    [2, 5, 3, 1, 4],
    [1, 5, 3, 2, 4],
    [5, 1, 3, 2, 4],
    [3, 1, 5, 2, 4],
    [1, 3, 5, 2, 4],
    [5, 3, 1, 2, 4],
    [3, 5, 1, 2, 4],
    [4, 5, 1, 2, 3],
    [5, 4, 1, 2, 3],
    [1, 4, 5, 2, 3],
    [4, 1, 5, 2, 3],
    [5, 1, 4, 2, 3],
    [1, 5, 4, 2, 3],
    [1, 5, 2, 4, 3],
    [5, 1, 2, 4, 3],
    [2, 1, 5, 4, 3],
    [1, 2, 5, 4, 3],
    [5, 2, 1, 4, 3],
    [2, 5, 1, 4, 3],
    [2, 4, 1, 5, 3],
    [4, 2, 1, 5, 3],
    [1, 2, 4, 5, 3],
    [2, 1, 4, 5, 3],
    [4, 1, 2, 5, 3],
    [1, 4, 2, 5, 3],
    [5, 4, 2, 1, 3],
    [4, 5, 2, 1, 3],
    [2, 5, 4, 1, 3],
    [5, 2, 4, 1, 3],
    [4, 2, 5, 1, 3],
    [2, 4, 5, 1, 3],
    [3, 4, 5, 1, 2],
    [4, 3, 5, 1, 2],
    [5, 3, 4, 1, 2],
    [3, 5, 4, 1, 2],
    [4, 5, 3, 1, 2],
    [5, 4, 3, 1, 2],
    [5, 4, 1, 3, 2],
    [4, 5, 1, 3, 2],
    [1, 5, 4, 3, 2],
    [5, 1, 4, 3, 2],
    [4, 1, 5, 3, 2],
    [1, 4, 5, 3, 2],
    [1, 3, 5, 4, 2],
    [3, 1, 5, 4, 2],
    [5, 1, 3, 4, 2],
    [1, 5, 3, 4, 2],
    [3, 5, 1, 4, 2],
    [5, 3, 1, 4, 2],
    [4, 3, 1, 5, 2],
    [3, 4, 1, 5, 2],
    [1, 4, 3, 5, 2],
    [4, 1, 3, 5, 2],
    [3, 1, 4, 5, 2],
    [1, 3, 4, 5, 2],
    [2, 3, 4, 5, 1],
    [3, 2, 4, 5, 1],
    [4, 2, 3, 5, 1],
    [2, 4, 3, 5, 1],
    [3, 4, 2, 5, 1],
    [4, 3, 2, 5, 1],
    [4, 3, 5, 2, 1],
    [3, 4, 5, 2, 1],
    [5, 4, 3, 2, 1],
    [4, 5, 3, 2, 1],
    [3, 5, 4, 2, 1],
    [5, 3, 4, 2, 1],
    [5, 2, 4, 3, 1],
    [2, 5, 4, 3, 1],
    [4, 5, 2, 3, 1],
    [5, 4, 2, 3, 1],
    [2, 4, 5, 3, 1],
    [4, 2, 5, 3, 1],
    [3, 2, 5, 4, 1],
    [2, 3, 5, 4, 1],
    [5, 3, 2, 4, 1],
    [3, 5, 2, 4, 1],
    [2, 5, 3, 4, 1],
    [5, 2, 3, 4, 1]
  ];

  List potionCombinations2 = [
    [1, 2],
    [1, 3],
    [1, 4],
    [1, 5],
    [2, 1],
    [2, 3],
    [2, 4],
    [2, 5],
    [3, 1],
    [3, 2],
    [3, 4],
    [3, 5],
    [4, 1],
    [4, 2],
    [4, 3],
    [4, 5],
    [5, 1],
    [5, 2],
    [5, 3],
    [5, 4]
  ];
  stderr.writeln("${spaceholder}##########START BIG SIMULATION##########");
  dxt("${spaceholder}myInventory ${myInventory}");
  dxt("${spaceholder}spells ${spells.length}");
  dxt("${spaceholder}potions ${potions.length}");

//  Action brew = findMostExpensivePayableBrew(potions, myInventory);
  Action targetPotion;
  int targetSimCounter = 999999;
  num average = -999999;
  List cloneSpells = [];
  for (int j = 0; j < spells.length; ++j) {
    cloneSpells.add(Action.clone(spells[j]));
  }

  //List potionCombinations = new List.from(potionCombinations2)..addAll(potionCombinations3)..addAll(potionCombinations5);
  List potionCombinations = potionCombinations5;
  for (int j = 0; j < potionCombinations.length; ++j) {
//    clonePotions.add(Action.clone(potions[j]));
    simCounter = 0;
    List inventory = [...myInventory];
    List potionOrder = potionCombinations[j];
    brewSum = 0;
    for (int k = 0; k < potionOrder.length; ++k) {
      stderr.writeln("${spaceholder}simCounterInBetween $simCounter");

      int potionPosition = potionOrder[k];
      Action brew = potions[potionPosition - 1];
      brewSum += brew.price;
      dxt("${spaceholder}startWhile brew PORTION ${brew.delta}");
      dxt("${spaceholder}  myInventory        ${inventory}");
      bool canPay = brew.isPayable(inventory, spaceholder + "--");
      while (!canPay && simCounter < 50) {
//      while (!canPay) {
//       while (!canPay && brew.price > price && simCounter < 15) {
        dxt("${spaceholder}simCounter $simCounter");

        stderr.writeln("${spaceholder}####WHILE round $simCounter");
        stderr.writeln("${spaceholder}  myInventory        ${inventory}");
        stderr.writeln("${spaceholder}- potion             ${brew.delta}");
        List missingIngredients = brew.findMissingIngredients(inventory, "--");
        stderr.writeln("${spaceholder}- missingIngredients ${missingIngredients}");

        Action spell;
        spell = findBestSpellForMissing(cloneSpells, inventory, brew, spaceholder + "--");

        //spell = findBestSpell(inventory, cloneSpells, missingIngredients, brew);

        if (spell != null) {
          List spellDeltas = spell.delta;
          stderr.writeln("${spaceholder} i b4 ${inventory}");
          inventory[0] = inventory[0] + spellDeltas[0];
          inventory[1] = inventory[1] + spellDeltas[1];
          inventory[2] = inventory[2] + spellDeltas[2];
          inventory[3] = inventory[3] + spellDeltas[3];
          stderr.writeln("${spaceholder}+spell ${spellDeltas}");
          stderr.writeln("${spaceholder} i Af ${inventory}");
          missingIngredients = brew.findMissingIngredients(inventory, "--");
          stderr.writeln("${spaceholder}- missingIngredients ${missingIngredients}");

          spell.castable = 0;
          simCounter++;
        } else {
          stderr.writeln("${spaceholder}#####REST#####");
          rest = true;
          for (int m = 0; m < cloneSpells.length; ++m) {
            cloneSpells[m].castable = 1;
          }
          simCounter++;
        }
        canPay = brew.isPayable(inventory, spaceholder + "--");
        stderr.writeln("${spaceholder}CAN PAY $canPay");
      }
    }

    dxt("${spaceholder}ENDsimCounter $simCounter");
    // if (simCounter >= 0 && (brewSum / simCounter) > average) {
    if (simCounter >= 0 && simCounter < targetSimCounter) {
      average = (brewSum / simCounter);
      targetSimCounter = simCounter;
      targetPotion = potions[potionOrder[0] - 1];
      dxt("");
      stderr.writeln("${spaceholder}UPDATE BREW ${targetPotion.delta} simCounter $simCounter");
      dxt("${spaceholder}UPDATE BREW ${targetPotion.delta} average $average");
    }
  }

  if (targetPotion != null) {
    stderr.writeln("${spaceholder}${targetPotion.to_s()}##########END SIMULATION##########");
  }
  return targetPotion;
}

///////////

bool invCanPayForXAction(List inventory, Action action) {
  bool canPay = false;
  bool canPay0 = false;
  bool canPay1 = false;
  bool canPay2 = false;
  bool canPay3 = false;
  //stderr.writeln("{action.to_s() ${action.delta}");

  if (action.delta[0] == 0) {
    canPay0 = true;
  } else {
    if (inventory[0] + action.delta[0] >= 0) {
      canPay0 = true;
    }
  }
  if (action.delta[1] == 0) {
    canPay1 = true;
  } else {
    if (inventory[1] + action.delta[1] >= 0) {
      canPay1 = true;
    }
  }
  if (action.delta[2] == 0) {
    canPay2 = true;
  } else {
    if (inventory[2] + action.delta[2] >= 0) {
      canPay2 = true;
    }
  }
  if (action.delta[3] == 0) {
    canPay3 = true;
  } else {
    if (inventory[3] + action.delta[3] >= 0) {
      canPay3 = true;
    }
  }
  if (canPay0 && canPay1 && canPay2 && canPay3) {
    canPay = true;
  }
//    if (canPay) {
  //dxt("inventory $inventory");
  //dxt("action ${action.delta}");
//        dxt("action ${action.to_s()}");
  //dxt("canPay $canPay");
//    }
  return canPay;
}

//check if a spell will not remove potion specific tier

Action findSpell(List myInventory, List spells, List missingIngredients, String spaceholder) {
  //TODO
  dxt("${spaceholder}findSpell");
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
    //dxt("tier3IsMissing");
    if (hasTier2) {
      //dxt("hasTier2");
      if (spells[3].castable == 1) {
        //dxt("targetSpell = spells[3]");
        targetSpell = spells[3];
      } else {
        //dxt("checkTier2");
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
    //dxt("checkTier2");
    if (tier2IsMissing) {
      //dxt("tier2IsMissing");
      if (hasTier1) {
        //dxt("hasTier1");

        if (spells[2].castable == 1) {
          //dxt("targetSpell = spells[2]");

          targetSpell = spells[2];
        } else {
          //dxt("recharge");
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
    //dxt("checkTier1");

    if (tier1IsMissing) {
      //dxt("tier1IsMissing");

      if (hasTier0) {
        //dxt("hasTier0");

        if (spells[1].castable == 1) {
          //dxt("targetSpell = spells[1]");

          targetSpell = spells[1];
        } else {
          //dxt("recharge");
          recharge = true;
        }
      } else {
        createTier0 = true;
      }
    } else {
      createTier0 = true;
    }
  }

  if (createTier0) {
    if (spells[0].castable == 1) {
      targetSpell = spells[0];
    } else {
      recharge = true;
    }
  }
  if (recharge) {
    targetSpell = null;
    //dxt("RECHARGE");
  } else {
    //dxt("spell ${targetSpell.to_s()}");
  }

//    }else{
//      recharge +=1;
//    }
//  }

  return targetSpell;
}

int brewOrderCounter = 0;

////////////////////////////////////////////

findFillerSpell(List inventory, List spells, List missingIngredients, Action potion, int deltaId, String spaceholder) {
  dxt("${spaceholder}findFillerSpell");
  Action targetSpell;
  // for (int i = deltaId; i >= 0; --i) {
  for (int i = 0; i < deltaId; ++i) {
    dxt("${spaceholder}DELTA $i is missing");
    Action tmpDeltaSpell = findFillSpellForDelta(spells, i, inventory, potion, spaceholder + "--");
    if (tmpDeltaSpell != null) {
      dxt("${spaceholder}FOUND DELTA SPELL, BREAK DELTA AT $i forSpell ${tmpDeltaSpell.id}");
      targetSpell = tmpDeltaSpell;
      break;
    }
  }

  return targetSpell;
}

Action findBestSpell(List inventory, List spells, List missingIngredients, Action potion, String spaceholder) {
  stderr.writeln("${spaceholder}-----findBestSpell");
  Action targetSpell;
  // for (int i = 0; i < 4; ++i) {
  for (int i = 3; i >= 1; i--) {
    bool deltaIsMissing = missingIngredients[i] < 0;
    if (deltaIsMissing) {
      dxt("${spaceholder}DELTA $i is missing");
      Action tmpDeltaSpell = findBestSpellForDelta(spells, i, inventory, potion, spaceholder + "--");
      if (tmpDeltaSpell != null) {
        dxt("${spaceholder}FOUND DELTA SPELL, BREAK DELTA AT $i forSpell ${tmpDeltaSpell.id}");
        targetSpell = tmpDeltaSpell;
        break;
      }
    }
  }
  if (targetSpell == null) {
    stderr.writeln("${spaceholder}findBestSpellForDelta looking for DELTA 0");
    targetSpell = findBestSpellForDelta(spells, 0, inventory, potion, spaceholder + "--");
  }
  if (targetSpell == null) {
    // stderr.writeln("${spaceholder}findSpell  for DELTA 0");
    //   targetSpell = findSpell(inventory, spells, missingIngredients, spaceholder + "--");
  } else {
    dxt("${spaceholder}targetSpell ${targetSpell.delta}");
  }

  return targetSpell;
}

Action findBestSpellForDelta(List spells, int deltaId, List inventory, Action potion, String spaceholder) {
  dxt("${spaceholder}findBestSpellForDelta $deltaId");
  Action targetSpell;
  for (int i = 0; i < spells.length; ++i) {
    Action spell = spells[i];

    // if(rest){
    //   dxt("cloneSpells[i].castable ${spells[i].castable}");
    //
    // }

    bool safeToCastSpell;
    if (potion == null) {
      safeToCastSpell = spell.isSaveToCast(deltaId, inventory, spaceholder + "--");
    } else {
      safeToCastSpell =
          spell.isSaveToCast(deltaId, inventory, spaceholder + "--") && spell.isSafeToCastForPotion(potion, inventory, spaceholder + "--");
      // safeToCastSpell = spell.isSaveToCast(deltaId, inventory);
    }

    if (safeToCastSpell && (targetSpell == null || spell.worth > targetSpell.worth)) {
      dxt("${spaceholder}targetSpell  ${spell.delta} ${spell.worth}");

      targetSpell = spell;
    }
  }
  if (targetSpell != null) {
    dxt("${spaceholder}final targetSpell ${targetSpell.to_s()}");
  }
  return targetSpell;
}

Action findFillSpellForDelta(List spells, int deltaId, List inventory, Action potion, String spaceholder) {
  dxt("${spaceholder}findFillSpellForDelta $deltaId");
  Action targetSpell;
  for (int i = 0; i < spells.length; ++i) {
    Action spell = spells[i];

    // if(rest){
    //   dxt("cloneSpells[i].castable ${spells[i].castable}");
    //
    // }

    bool safeToCastSpell;
    if (potion == null) {
      safeToCastSpell = spell.isSaveToCast(deltaId, inventory, spaceholder + "--");
    } else {
      safeToCastSpell =
          spell.isSaveToCast(deltaId, inventory, spaceholder + "--") && spell.isSafeToCastForPotion(potion, inventory, spaceholder + "--");
      // safeToCastSpell = spell.isSaveToCast(deltaId, inventory);
    }

    // dxt("safeToCastSpell  ${safeToCastSpell}");

    if (safeToCastSpell && (targetSpell == null || spell.getStoneAmount() > targetSpell.getStoneAmount())) {
      dxt("${spaceholder}targetSpell  ${spell.delta} ${spell.worth}");

      targetSpell = spell;
    }
  }
  if (targetSpell != null) {
    dxt("${spaceholder}final targetSpell ${targetSpell.to_s()}");
  }
  return targetSpell;
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
bool toggleOn = true;
bool castBecausePotionWasBrewed = false;

void main() {
  List inputs;

  List myInventory = [];
  List enemyInventory = [];

  List actions = [];
  List<Action> potions = [];
  List spells = [];
  List tomeSpells = [];
  List opSpells = [];
  List missingIngredients = [0, 0, 0, 0];
  Action potion;
  roundCounter = 0;
  String spaceholder = "--";
  // game loop
  while (true) {
    actions = [];
    potions = [];
    spells = [];
    tomeSpells = [];
    opSpells = [];
    myInventory = [];
    enemyInventory = [];
    missingIngredients = [0, 0, 0, 0];

    bool goalStillExists = false;
    // String readLine1 = stdin.readLineSync(); // the number of spells and recipes in play
    // stderr.writeln("the number of spells and recipes in play $readLine1");
    // int actionCount = int.parse(readLine1); // the number of spells and recipes in play
    List<String> inputActions = [
      "66 BREW -2 -1 0 -1 12 3 4 0 0",
      "50 BREW -2 0 0 -2 11 1 4 0 0",
      "52 BREW -3 0 0 -2 11 0 0 0 0",
      "69 BREW -2 -2 -2 0 13 0 0 0 0",
      "71 BREW -2 0 -2 -2 17 0 0 0 0",
      "19 LEARN 0 2 -1 0 0 0 0 0 1",
      "32 LEARN 1 1 3 -2 0 1 0 0 1",
      "35 LEARN 0 0 -3 3 0 2 0 0 1",
      "3 LEARN 0 0 1 0 0 3 0 0 0",
      "1 LEARN 3 -1 0 0 0 4 0 0 1",
      "22 LEARN 0 2 -2 1 0 5 0 0 1",
      "78 CAST 2 0 0 0 0 -1 -1 1 0",
      "79 CAST -1 1 0 0 0 -1 -1 1 0",
      "80 CAST 0 -1 1 0 0 -1 -1 1 0",
      "81 CAST 0 0 -1 1 0 -1 -1 1 0",
      "86 CAST 0 2 0 0 0 -1 -1 1 0",
      "88 CAST 2 3 -2 0 0 -1 -1 1 1",
      "90 CAST 2 2 0 -1 0 -1 -1 1 1",
      "92 CAST -4 0 1 1 0 -1 -1 1 1",
      "94 CAST 2 1 0 0 0 -1 -1 1 0",
      "96 CAST 1 0 1 0 0 -1 -1 1 0",
      "98 CAST 1 1 0 0 0 -1 -1 1 0",
      "100 CAST 1 -3 1 1 0 -1 -1 1 1",
      "102 CAST -3 1 1 0 0 -1 -1 1 1",
      "82 OPPONENT_CAST 2 0 0 0 0 -1 -1 0 0",
      "83 OPPONENT_CAST -1 1 0 0 0 -1 -1 1 0",
      "84 OPPONENT_CAST 0 -1 1 0 0 -1 -1 1 0",
      "85 OPPONENT_CAST 0 0 -1 1 0 -1 -1 1 0",
      "87 OPPONENT_CAST 0 2 0 0 0 -1 -1 1 0",
      "89 OPPONENT_CAST 2 3 -2 0 0 -1 -1 1 1",
      "91 OPPONENT_CAST 2 2 0 -1 0 -1 -1 1 1",
      "93 OPPONENT_CAST -4 0 1 1 0 -1 -1 1 1",
      "95 OPPONENT_CAST 3 0 1 -1 0 -1 -1 1 1",
      "97 OPPONENT_CAST 1 0 1 0 0 -1 -1 1 0",
      "99 OPPONENT_CAST 1 1 0 0 0 -1 -1 1 0",
      "101 OPPONENT_CAST 1 -3 1 1 0 -1 -1 1 1"
    ];
    for (int i = 0; i < inputActions.length; i++) {
      // for (int i = 0; i < actionCount; i++) {
      //   String readLine2 = stdin.readLineSync();
      String readLine2 = inputActions[i];
      dxt("${spaceholder}$readLine2");
      inputs = readLine2.split(' ');
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

//      dxt("a.actionType ${a.actionType}");
      if (actionType == "BREW") {
        potions.add(a);
        if (goalPotion != null && a.id == goalPotion.id) {
          goalStillExists = true;
        }
      } else if (actionType == "LEARN") {
        tomeSpells.add(a);
      } else if (actionType == "CAST") {
        spells.add(a);
      } else if (actionType == "OPPONENT_CAST") {
        opSpells.add(a);
      } else {
        actions.add(a);
      }
    }
    if (!goalStillExists) {
      goalPotion = null;
    }
    List<String> inputStrings = ["6 0 0 0 0", "10 0 0 0 0"];
    for (int i = 0; i < inputStrings.length; i++) {
      // for (int i = 0; i < 2; i++) {
      //   String readLine3 = stdin.readLineSync();
      String readLine3 = inputStrings[i];
      dxt("${spaceholder}inputString INVENTORY: $readLine3");
      inputs = readLine3.split(' ');

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
    String text;
    Action brew = findMostExpensivePayableBrew(potions, myInventory, spaceholder + "--");
    // Action brew;
    if (brew != null) {
      text = "BREW ${brew.id}";
    } else {
      stderr.writeln("${spaceholder}*******START GAME*******");
      // if (shouldLearnSpell(tomeSpells, spells, opSpells, myInventory)) {

      if (tomeSpells.length > 1 && spells.length <= opSpells.length ||
          ((tomeSpells[1].hasOnlyPositiv() /*||  spellIsInWishlist(tomeSpells[1])*/) && myInventory[0] > 0) ||
          ((tomeSpells[2].hasOnlyPositiv() /*||  spellIsInWishlist(tomeSpells[2]) */) && myInventory[0] > 1) ||
          spellIsInWishlist(tomeSpells.first, spaceholder + "--")) {
        // if (spells.length <= opSpells.length ||

        // if (tomeSpells[1].hasOnlyPositiv() || spellIsInWishlist(tomeSpells.first)) {
        if ((tomeSpells[1].hasOnlyPositiv() /*||  spellIsInWishlist(tomeSpells[1])*/) && myInventory[0] > 0) {
          text = "LEARN ${tomeSpells[1].id}";
        } else if (tomeSpells[2].hasOnlyPositiv() /*|| spellIsInWishlist(tomeSpells[2])*/ && myInventory[0] > 1) {
          text = "LEARN ${tomeSpells[2].id}";
          // } else if (tomeSpells[3].hasOnlyPositiv() && myInventory[0] > 2) {
          //   text = "LEARN ${tomeSpells[3].id}";
        } else
        // if (tomeSpells[4].hasOnlyPositiv() && myInventory[0] > 3) {
        //   text = "LEARN ${tomeSpells[4].id}";
        // }else
        {
          text = "LEARN ${tomeSpells.first.id}";
        }
        stderr.writeln("${spaceholder}onlyPos || WishSpell || FKIRST");
        // }
        toggleOn = !toggleOn;
      } else {
        Action spell;
        if (false && getNumberOfItemsInInventory(myInventory) < 3) {
          // if (true && getNumberOfItemsInInventory(myInventory) < 3) {
          spell = findFillerSpell(myInventory, spells, missingIngredients, potion, 3, spaceholder + "--");
          //spell = findSpellWithoutPotion(myInventory, spells, opSpells, tomeSpells);

          if (spell != null) {
            text = "CAST ${spell.id} ${canSpellXTime(myInventory, spell, spaceholder + "--")}";
          }
        } else {
          if (text == null) {
            stderr.writeln("${spaceholder}findSpellForPotionÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ");
            text = findSpellForPotion(potions, myInventory, spells, opSpells, tomeSpells, spaceholder + "--");

            // if (text == null) {
            //   dxt("findSpellWithoutPotionÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖ");
            //   spell = findSpellWithoutPotion(myInventory, spells, opSpells, tomeSpells);
            // }
            dxt("${spaceholder}spell ${text}");
            if (spell != null) {
              text = "CAST ${spell.id} ${canSpellXTime(myInventory, spell, spaceholder + "--")}";
            }
            // Action brew = findMostExpensivePayableBrew(potions, myInventory);
            // if (brew == null) {
            //   Action spell = findSpellWithoutPotion(myInventory, spells, opSpells, tomeSpells);
            //
            //   if (spell == null) {
            //     text = "REST";
            //     dxt("RESTRESET");
            //   } else {
            //     text = "CAST ${spell.id} ${canSpellXTime(myInventory, spell)}";
            //     dxt("spell ${spell.to_s()}");
            //   }
            // } else {
            //   text = "BREW ${brew.id}";
            // }
            toggleOn = !toggleOn;
          }
        }
      }

      // if (tomeSpells.length > 1 && spells.length <= 15 && toggleOn) {
      if (text == null ||
          (numberOfAvailableSpells(spells, spaceholder + "--") < (opSpells.length / 2) && roundCounter > 10) ||
          (getNumberOfItemsInInventory(myInventory) < 4 && !hasCastablePositiveSpells(spells))) {
        // if (text == null || castBecausePotionWasBrewed || numberOfAvailableSpells(spells) < 6 && roundCounter > 10) {
        text = "REST";
        stderr.writeln("${spaceholder}RESTRESET");
        castBecausePotionWasBrewed = false;
      }
    }
    if (text.contains("BREW")) {
      castBecausePotionWasBrewed = true;
    }
    print(text);
  }
}

Action findMostExpensiveBrew(List actions, String spaceholder) {
  dxt("${spaceholder}findMostExpensiveBrew");

  num currentPrice = -1;
  Action targetAction;
  dxt("${spaceholder}targetAction $targetAction");
  for (int i = 0; i < actions.length; ++i) {
    Action a = actions[i];
    if (a.price > price && a.price > currentPrice) {
//    if (invCanPayForAction(inventory, a)) {
      dxt("${spaceholder}${a.to_s()}");
      //if (!ignoredWrecks.contains(u.id) && (fullestWater == -1 || water > fullestWater)) {
      currentPrice = a.price;
      targetAction = a;
    }
  }
  if (targetAction != null) {
    dxt("${spaceholder}findMostExpensiveBrew ${targetAction.to_s()}");
  }
  return targetAction;
}

String findSpellForPotion(List potions, List myInventory, List spells, List opSpells, List tomeSpells, String spaceholder) {
  roundCounter++;
  Action spell;

  // Action potion = findMostExpensiveBrew(potions);
  Action potion = simulateBrew([...myInventory], [...spells], [...potions], spaceholder + "--");
  // Action potion = simulateAllBrew([...myInventory], [...spells], [...potions], spaceholder + "--");
  // }
  String text;
  if (potion != null) {
    dxt("${spaceholder}  myInventory        ${myInventory}");
    dxt("${spaceholder}- potion             ${potion.to_s()}");
    List missingIngredients = potion.findMissingIngredients(myInventory, spaceholder + "--");
    dxt("${spaceholder}  missingIngredients ${missingIngredients}");
    if (missingIngredients[0] >= 0 && missingIngredients[1] >= 0 && missingIngredients[2] >= 0 && missingIngredients[3] >= 0) {
      text = "BREW ${potion.id}";
      potion = null;
    } else {
      spell = findBestSpellForMissing(spells, myInventory, potion, spaceholder + "--");

      //spell = findBestSpell(myInventory, spells, missingIngredients, potion);
      if (spell != null) {
        dxt("${spaceholder} REAL spell ${spell.delta}");
        text = "CAST ${spell.id} ${canSpellXTime(myInventory, spell, spaceholder + "--")}";
        text = "CAST ${spell.id} 1";
      }
    }
  }
  return text;
}

// Action findSpellWithoutPotion(List inventory, List spells, List opSpells, List tomeSpells, String spaceholder) {
//   roundCounter++;
//   dxt("${spaceholder}  myInventory        ${inventory}");
//   List missingIngredients = [inventory[0] - 1, inventory[1] - 2, inventory[2] - 1, inventory[3] - 1];
//   Action spell = findBestSpell(inventory, spells, missingIngredients, null, spaceholder + "--");
//   return spell;
// }

List getPossibleSpellsForInventory(List spells, List inventory, Action potion, String spaceholder) {
  dxt("${spaceholder}getPossibleSpellsForInventory");
  List targetList = [];
  for (int i = 0; i < spells.length; ++i) {
    Action spell = spells[i];
    dxt("${spaceholder}exist spell ${spell.delta}");
    // if (spell.isSaveToCastWithoutDelta(inventory, spaceholder + "--") && spell.isSafeToCastForPotion(spell, inventory, spaceholder + "--")) {
      if(spell.isSaveToCastWithoutDelta(inventory, spaceholder + "--") ){
      // dxt("${spaceholder}     spell ${spell.delta} ${spell.getDeltaSumWithPotionAndInventory(potion, inventory, spaceholder+"--")}");
      dxt("");
      dxt("${spaceholder}valid spell ${spell.delta}");
      targetList.add(spell);
    }
  }
  return targetList;
}

Action findBestSpellForMissing(List spells, List inventory, Action potion, String spaceholder) {
  dxt("${spaceholder}findBestSpellForMissing from ${spells.length}spells");
  Action targetSpell;

  List possibleSpells = getPossibleSpellsForInventory(spells, inventory, potion, spaceholder + "--");
  if (possibleSpells.length > 0) {
    targetSpell = findBestSpellToGetCloser(possibleSpells, potion, inventory, spaceholder + "--");
  }

  return targetSpell;
}

Action findBestSpellToGetCloser(List spells, Action potion, List inventory, String spaceholder) {
  dxt("${spaceholder}findBestSpellToGetCloser");
  Action targetSpell;
  num targetMissingSum = -9999;
  num targetSpellSum = -9999;

  for (int i = 0; i < spells.length; ++i) {
    Action spell = spells[i];
    List missingIngredients = potion.findMissingIngredients(inventory, spaceholder + "--");

    num tmpSpellSum = spell.bringsInventoryAndPostionCloserBy(missingIngredients, spaceholder + "--");
    num tmpMissingSum = getDeltaSum(missingIngredients);
    if (tmpMissingSum > targetMissingSum || tmpMissingSum == targetMissingSum && tmpSpellSum > targetSpellSum) {
      dxt("${spaceholder}updateTargetSpell-----${spell.delta} tmpSpellSum $tmpSpellSum");
      targetSpell = spell;
      targetSpellSum = tmpSpellSum;
      targetMissingSum = tmpMissingSum;
    }
  }
  if (targetSpellSum == 0) {
    //GET HIGHEST MISSING TIER or backupSpell
    List missingIngredients = potion.findMissingIngredients(inventory, spaceholder + "--");
    targetSpell = findBestSpell(inventory, spells, missingIngredients, potion, spaceholder);
  }
  if (targetSpellSum == 0) {
    //BACKUP ONLY AFTER NOTHING WAS FOUND
    for (int i = 0; i < spells.length; ++i) {
      Action spell = spells[i];
      List missingIngredients = potion.findMissingIngredients(inventory, spaceholder + "--");
      num tmpSpellSum = spell.getDeltaSumWithPotionAndInventory(potion, inventory, spaceholder + "--");
      num tmpMissingSum = getDeltaSum(missingIngredients);
      if (tmpMissingSum > targetMissingSum || tmpMissingSum == targetMissingSum && tmpSpellSum > targetSpellSum) {
        dxt("${spaceholder}updateTargetSpell-----${spell.delta} tmpSpellSum $tmpSpellSum");
        targetSpell = spell;
        targetSpellSum = tmpSpellSum;
        targetMissingSum = tmpMissingSum;
      }
    }
  }
  return targetSpell;
}

num getDeltaSum(List delta) {
  num sum = 0;
  sum = (0.95 * 1 * delta[0]) + (0.95 * 2 * delta[1]) + (0.95 * 3 * delta[2]) + (0.95 * 4 * delta[3]);
  return sum;
}
