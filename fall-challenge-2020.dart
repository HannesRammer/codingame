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
  int worth;
  num rupeePerRound;

  // This is the key named contructor
  Action.clone(Action action)
          : this(action.id, action.actionType, action.delta0, action.delta1, action.delta2, action.delta3, action.price, action.tomeIndex, action.taxCount, action.castable, action.repeatable);

  Action(this.id, this.actionType, this.delta0, this.delta1, this.delta2, this.delta3, this.price, this.tomeIndex, this.taxCount, this.castable, this.repeatable) {
    delta = [delta0, delta1, delta2, delta3];
    worth = getSpellValue(delta);
  }

  String to_s() {
    return "id $id, actionType $actionType,delta0 $delta0,delta1 $delta1,delta2 $delta2,delta3 $delta3,price "
            "$price,tomeIndex $tomeIndex,taxCount $taxCount,castable $castable,repeatable $repeatable, worth $worth";
  }
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
int potionTierSize = 0;

void main() {
  List inputs;

  List myInventory = [];
  List enemyInventory = [];

  List actions = [];
  List potions = [];
  List spells = [];
  List tomeSpells = [];
  List opSpells = [];
  List missingIngredients = [0, 0, 0, 0];

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
//      dxt("a.actionType ${a.actionType}");
      if (actionType == "BREW") {
        potions.add(a);
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
    Action brew;
    Action potion;
    brew = findMostExpensivePayableBrew(potions, myInventory);
    //start game
    dxt("*******START GAME*******");

    if (brew != null) {
      dxt("BREW ID ${brew.id}***");
    }

//    if (spells.length < opSpells.length + 5) {
//    if (spells.length < opSpells.length + 5 && spells.length < 16) {
    if (spells.length < 16) {
      print("LEARN ${tomeSpells.first.id}");
    } else {
      potion = findUnpayableBrew(potions, myInventory);
//      potion = simulateBrew([...myInventory], [...spells], [...potions], [...missingIngredients]);
      String text;
      if (brew == null) {
        potionTierSize = spellSumWithoutTier(potion.delta, -1);

        stderr.writeln("  myInventory        ${myInventory}");
        stderr.writeln("- potion             ${potion}");
        missingIngredients = findMissingIngredients(myInventory, potion, missingIngredients);
        stderr.writeln("  missingIngredients ${missingIngredients}");
        if (missingIngredients[0] == 0 && missingIngredients[1] == 0 && missingIngredients[2] == 0 && missingIngredients[3] == 0) {
          text = "BREW ${potion.id}";
        } else {
          Action spell = findSpell(myInventory, spells, missingIngredients);
          if (spell == null) {
            text = "REST";
            dxt("RESTRESET");
          } else {
            stderr.writeln("spell ${spell.to_s()}");

//            if (isSingleSpell(spell) && spell.repeatable == 1 && (myInventorySumFunction(myInventory) + (myInventorySumFunction(spell.delta) * 2)) <= 10) {
//              text = "CAST ${spell.id} 2";
//            } else {
            text = "CAST ${spell.id}";
//            }
            dxt("spell ${spell.to_s()}");
          }
        }
      } else {
        potionTierSize = spellSumWithoutTier(brew.delta, -1);
        text = 'BREW ${brew.id}';
      }
      print(text);
    }
  }
}

bool debug = true;

bool isSingleSpell(Action spell) {
  int minus = 0;
  int plus = 0;
  bool isSingle = false;
  List delta = spell.delta;
  for (int i = 0; i < delta.length; ++i) {
    int d = delta[i];
    if (d < 0) {
      minus += d;
    }
    if (d > 0) {
      plus += d;
    }
  }
  if (minus == 0 && plus == 1) {
    isSingle = true;
  }

  return isSingle;
}

int getSpellValue(List delta) {
  int minus = 0;
  int plus = 0;
  for (int i = 0; i < delta.length; ++i) {
    int d = delta[i];
    if (d < 0) {
      minus += d * (i + 1);
    }
    if (d > 0) {
      plus += d * (i + 1);
    }
  }
  return (minus + plus);
}

void dxt(String text) {
  if (debug) {
    stderr.writeln(text);
  }
}

List findMissingIngredients(List inventory, Action potion, List missingIngredients) {
  dxt("-----------findMissingIngredients");
  dxt("-----------missingIngredients $missingIngredients");
  dxt("-----------potion ${potion.to_s()}");

  int missing0 = potion.delta0 + inventory[0];
  int missing1 = potion.delta1 + inventory[1];
  int missing2 = potion.delta2 + inventory[2];
  int missing3 = potion.delta3 + inventory[3];
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
  dxt("missingIngredients $missingIngredients");
  return missingIngredients;
}

List updateMissingIngredients(List inventory, Action potion) {
  dxt("-----------updateMissingIngredients");
  List missingIngredients = [0, 0, 0, 0];
  int missing0 = potion.delta0 + inventory[0];
  int missing1 = potion.delta1 + inventory[1];
  int missing2 = potion.delta2 + inventory[2];
  int missing3 = potion.delta3 + inventory[3];
  if (missing0 < 0) {
    missingIngredients[0] = missing0;
  }
  if (missing1 < 0) {
    missingIngredients[1] = missing1;
  }
  if (missing2 < 0) {
    missingIngredients[2] = missing2;
  }
  if (missing3 < 0) {
    missingIngredients[3] = missing3;
  }
  dxt("updateMissingIngredients $missingIngredients");
  return missingIngredients;
}

//int price = 12;

Action findMostExpensivePayableBrew(List actions, List inventory) {
  dxt("-----------findMostExpensivePayableBrew");

  num currentPrice = -1;
  Action targetAction;
  dxt("targetAction $targetAction");
  for (int i = 0; i < actions.length; i++) {
    Action a = actions[i];

    if (a.price > currentPrice && invCanPayForBrew(inventory, a)) {
      dxt("${a.to_s()}");

      //if (!ignoredWrecks.contains(u.id) && (fullestWater == -1 || water > fullestWater)) {
      currentPrice = a.price;
      targetAction = a;
    }
  }
  if (targetAction != null) {
    dxt("findMostExpensivePayableBrew ${targetAction.to_s}");
  }

  return targetAction;
}

Action findCheapestUnpayableBrew(List actions, List inventory) {
  dxt("-----------findCheapestUnpayableBrew");
  num currentPrice = 9999;
  Action targetPortion;
  for (int i = 0; i < actions.length; i++) {
    Action a = actions[i];

    if (a.price < currentPrice && !invCanPayForBrew(inventory, a)) {
      //if (!ignoredWrecks.contains(u.id) && (fullestWater == -1 || water > fullestWater)) {
      currentPrice = a.price;
      targetPortion = a;
    }
  }

  return targetPortion;
}

Action findUnpayableBrew(List actions, List inventory) {
  dxt("-----------findUnpayableBrew");
  num currentPrice = -1;
  Action targetPortion;
  for (int i = 0; i < actions.length; i++) {
    Action a = actions[i];

    if (a.price > currentPrice && !invCanPayForBrew(inventory, a)) {
      //if (!ignoredWrecks.contains(u.id) && (fullestWater == -1 || water > fullestWater)) {
      currentPrice = a.price;
      targetPortion = a;
    }
  }

  return targetPortion;
}

Action findSpell(List inventory, List spells, List missingIngredients) {
  //TODO
  int inventorySum = myInventorySumFunction(inventory);
  dxt("-----------findSpell");
  Action targetSpell;
  bool recharge = false;
  //  for (int i = 0; i < spells.length; i++) {
  //    Action a = spells[i];
  //    bool isCastable = a.castable == 1;
  //    if (isCastable) {

  if (myInventorySumFunction(inventory) < 4) {
    Action fastSpell;
    int worth = -99999;
    Action worthySpell;
    for (var i = 0; i < 4; ++i) {
      fastSpell = findBestTierSpell(spells, i, inventory);
      if(fastSpell != null && fastSpell.worth > worth){
        worthySpell = fastSpell;
        worth = fastSpell.worth;
        stderr.writeln("worth ${worth}");
      }
    }

    if (worthySpell != null && worthySpell.castable == 1) {
      targetSpell = worthySpell;
    } else {
      recharge = true;
    }
  } else {
    bool tier3IsMissing = missingIngredients[3] < 0;
    bool hasTier2 = inventory[2] > 0;
    bool checkTier2 = false;
    bool tier2IsMissing = false;
    if (tier3IsMissing) {
      dxt("tier3IsMissing");
      Action tmpSpell = findBestTierSpell(spells, 3, inventory);
      var spell3 = spells[3];
      if (tmpSpell != null) {
        int spaceLeftInInventory = (10 - inventorySum);
        int neededInventorySpace = spellSumWithoutTier(tmpSpell.delta, -1);
        if (tmpSpell.castable == 1 && (spaceLeftInInventory >= neededInventorySpace)) {
          targetSpell = tmpSpell;
        } else {
          if (hasTier2) {
            dxt("hasTier2");
            if (spell3.castable == 1) {
              dxt("targetSpell = spells[3]");
              targetSpell = spell3;
            } else {
              dxt("checkTier2");
              recharge = true;
              checkTier2 = true;
            }
          } else {
            checkTier2 = true;
            tier2IsMissing = true;
          }
        }
      } else {
        if (hasTier2) {
          dxt("hasTier2");
          if (spell3.castable == 1) {
            dxt("targetSpell = spells[3]");
            targetSpell = spell3;
          } else {
            dxt("checkTier2");
            recharge = true;
            checkTier2 = true;
          }
        } else {
          checkTier2 = true;
          tier2IsMissing = true;
        }
      }
    } else {
      checkTier2 = true;
    }

    tier2IsMissing = tier2IsMissing || missingIngredients[2] < 0;
    bool hasTier1 = inventory[1] > 0;
    bool checkTier1 = false;
    bool tier1IsMissing = false;
    if (checkTier2) {
      dxt("checkTier2");
      if (tier2IsMissing) {
        dxt("tier2IsMissing");
        Action tmpSpell = findBestTierSpell(spells, 2, inventory);
        var spell2 = spells[2];
        if (tmpSpell != null) {
          int spaceLeftInInventory = (10 - inventorySum);
          int neededInventorySpace = spellSumWithoutTier(tmpSpell.delta, -1);
          if (tmpSpell.castable == 1 && (spaceLeftInInventory >= neededInventorySpace)) {
            targetSpell = tmpSpell;
          } else {
            if (hasTier1) {
              dxt("hasTier1");

              if (spell2.castable == 1) {
                dxt("targetSpell = spells[2]");

                targetSpell = spell2;
                recharge = false;
              } else {
                dxt("recharge");
                recharge = true;
              }
            } else {
              checkTier1 = true;
              tier1IsMissing = true;
            }
          }
        } else {
          if (hasTier1) {
            dxt("hasTier1");

            if (spell2.castable == 1) {
              dxt("targetSpell = spells[2]");

              targetSpell = spell2;
              recharge = false;
            } else {
              dxt("recharge");
              recharge = true;
            }
          } else {
            checkTier1 = true;
            tier1IsMissing = true;
          }
        }
      } else {
        checkTier1 = true;
      }
    }

    tier1IsMissing = tier1IsMissing || missingIngredients[1] < 0;
    bool hasTier0 = inventory[0] > 0;
    bool createTier0 = false;
    if (checkTier1) {
      dxt("checkTier1");

      if (tier1IsMissing) {
        dxt("tier1IsMissing");
        Action tmpSpell = findBestTierSpell(spells, 1, inventory);
        var spell1 = spells[1];
        if (tmpSpell != null) {
          int spaceLeftInInventory = (10 - inventorySum);
          int neededInventorySpace = spellSumWithoutTier(tmpSpell.delta, -1);
          if (tmpSpell.castable == 1 && (spaceLeftInInventory >= neededInventorySpace)) {
            targetSpell = tmpSpell;
          }
        } else {
          if (hasTier0) {
            dxt("hasTier0");
            if (spell1.castable == 1) {
              dxt("targetSpell = spells[1]");
              targetSpell = spell1;
              recharge = false;
            } else {
              dxt("recharge");
              recharge = true;
            }
          } else {
            if (spell1.castable == 1) {
              dxt("targetSpell = spells[1]");
              targetSpell = spell1;
              recharge = false;
            } else {
              dxt("recharge");
              recharge = true;
            }
          }
        }
      } else {
        createTier0 = true;
      }
    }

    if (createTier0) {
      Action tmpSpell = findBestTierSpell(spells, 0, inventory);
      int spaceLeftInInventory = (10 - inventorySum);
      if (spaceLeftInInventory >= 2) {
        var spell0 = spells[0];
        if (tmpSpell != null) {
          int neededInventorySpace = spellSumWithoutTier(tmpSpell.delta, -1);
          if (tmpSpell.castable == 1 && (spaceLeftInInventory >= neededInventorySpace)) {
            targetSpell = tmpSpell;
          } else {
            if (spell0.castable == 1) {
              targetSpell = spell0;
              recharge = false;
            } else {
              recharge = true;
            }
          }
        } else {
          if (spell0.castable == 1) {
            targetSpell = spell0;
            recharge = false;
          } else {
            recharge = true;
          }
        }
      } else {
        recharge = true;
      }
    }
  }

  if (recharge || castable1and2and3Spells(spells, inventorySum) || castable1or2or3Spells(spells, inventorySum)) {
    targetSpell = null;
  }

  if (targetSpell != null) {
    dxt("found spell.delta !!!!!!!!!!!!!!");
    dxt("targetSpell ${targetSpell.delta}");
  }

  return targetSpell;
}

bool castable1and2and3Spells(List spells, int inventorySum) {
  return inventorySum > 8 && (spells[1].castable == 0 && spells[2].castable == 0 && spells[3].castable == 0);
}

bool castable1or2or3Spells(List spells, int inventorySum) {
//  return  inventorySum > 5 && (spells[1].castable == 0 || spells[2].castable == 0 || spells[3].castable == 0 );
  return inventorySum > 6 && ((spells[1].castable == 0 && spells[2].castable == 0) || (spells[1].castable == 0 && spells[3].castable == 0) || (spells[2].castable == 0 && spells[3].castable == 0));
}

bool invCanPayForBrew(List inventory, Action action) {
  dxt("-----------invCanPayForBrew");
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

Action findBestTierSpell(List spells, int tier, List inventory) {
  dxt("-----------findBestTierSpell");
  num bonus = 0;
  num tierAmount = 0;
  Action targetSpell;
  num myInventorySum = myInventorySumFunction(inventory);

  for (int i = 0; i < spells.length; i++) {
    Action s = spells[i];
    bool spellTierWillFitInventory = (10 - myInventorySum) >= spellSumWithoutTier(s.delta, -1);
    //dxt("spellTierWillFitInventory $spellTierWillFitInventory");

    if (spellTierWillFitInventory) {
//    if (spellSumWithoutTier(s.delta, -1) <= 0) {
      num tmpTierAmount = s.delta[tier];
      if (tmpTierAmount > 0) {
        //possibleSpell
        if (invCanPayForBrew(inventory, s)) {
          num tmpBonus = spellSumWithoutTier(s.delta, tier);
          //dxt("${tmpTierAmount + tmpBonus + myInventorySum}");
          if (tmpTierAmount > tierAmount) {
            //possibleSpell
            targetSpell = s;
            tierAmount = tmpTierAmount;
            bonus = tmpBonus;
            dxt("biggerTierAmount $tierAmount ");
          } else if (tmpTierAmount == tierAmount) {
            //check if bonus is bigger
            if (tmpBonus > bonus) {
              targetSpell = s;
              tierAmount = s.delta[tier];
              bonus = tmpBonus;
              dxt("sameTierAmount $tierAmount bigger bonus $bonus");
            }
          }
        }
      }
    }
    if (targetSpell != null) {
      //dxt("targetSpell ${targetSpell.to_s()}");
    }
  }

  return targetSpell;
}

num spellSumWithoutTier(List delta, int tier) {
  num sum = 0;
  for (int i = 0; i < delta.length; ++i) {
    if (tier != i) {
      sum += delta[i];
    }
  }
  return sum;
}

num myInventorySumFunction(List inventory) {
  //stderr.writeln("${inventory[0] + inventory[1] + inventory[2] + inventory[3]}");
  return (inventory[0] + inventory[1] + inventory[2] + inventory[3]);
}

Action simulateBrew(List myInventory, List<Action> spells, List<Action> potions, List missingIngredients) {
  dxt("##########START SIMULATION##########");
  dxt("myInventory ${myInventory}");
  dxt("spells ${spells.length}");
  dxt("potions ${potions.length}");
  dxt("missingIngredients ${missingIngredients}");
//  Action brew = findMostExpensivePayableBrew(potions, myInventory);
  Action targetPotion;
  num tmpRupeePerRound = -9999;
  num currentRupeePerRound = -1;
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
    bool canPay = false;
    int roundCounter = 0;
    myInventory = [3, 0, 0, 0, 0];
    missingIngredients = [0, 0, 0, 0];
    targetPotion = brew;
    dxt("startWhile brew PORTION PROTION");
    dxt("${brew.delta}");
    bool stillBetterRupee = currentRupeePerRound >= tmpRupeePerRound;

    while (!canPay && stillBetterRupee && brew.price > 10) {
      roundCounter++;
      dxt("missingIngredients BE4 finding spell!!!!!!!!!!!!!!");
      dxt(" i b4 ${myInventory}");
      dxt("-b    ${brew}");
      dxt("-------------");

//      missingIngredients = findMissingIngredients(myInventory, brew, missingIngredients);
      missingIngredients = updateMissingIngredients(myInventory, brew);
      dxt(" m    ${missingIngredients}");

      dxt("missingIngredients AFTER finding spell!!!!!!!!!!!!!!");
      dxt("${missingIngredients}");

      Action spell = findSpell(myInventory, cloneSpells, missingIngredients);

      if (spell != null) {
        List spellDeltas = spell.delta;
        dxt(" i b4 ${myInventory}");

        myInventory[0] = myInventory[0] + spellDeltas[0];
        myInventory[1] = myInventory[1] + spellDeltas[1];
        myInventory[2] = myInventory[2] + spellDeltas[2];
        myInventory[3] = myInventory[3] + spellDeltas[3];
        dxt("myInventory ${myInventory} after adding spellDeltad!!!!!!!!!!!!!!");
        dxt("${myInventory}");

        missingIngredients = updateMissingIngredients(myInventory, brew);
//        missingIngredients = findMissingIngredients(myInventory, brew, missingIngredients);
        dxt("+s    ${spellDeltas}");
        dxt("missingIngredients ${missingIngredients} after adding spellDeltad!!!!!!!!!!!!!!");
        dxt("---------------------");
        dxt(" i AF ${myInventory}");

        spell.castable = 0;
      } else {
        //rest

        for (int j = 0; j < cloneSpells.length; ++j) {
          Action spell = cloneSpells[j];
          spell.castable = 1;
          dxt("SET SPELL CASTABLE = 1  !!!!!!!!!!!!!!");
          dxt("${spell.castable}");
        }
      }
      if (roundCounter > 0) {
        currentRupeePerRound = brew.price / roundCounter;
      } else {
        currentRupeePerRound = -999999;
      }

      canPay = invCanPayForBrew(myInventory, brew);
    }
    if (!stillBetterRupee) {
      dxt("NO BETTER RUPEE ANYMORE ");
    } else {}
    dxt("######");
    if (roundCounter > 0) {
      dxt("brew ${brew.to_s()} roundCounter $roundCounter");
      dxt("brew.price/ roundCounter ${brew.price}/ ${roundCounter} ");
      dxt("rupeePerRound ${brew.price / roundCounter} ");
    }
    if (brew != null && currentRupeePerRound > tmpRupeePerRound) {
      tmpRupeePerRound = currentRupeePerRound;
      targetPotion = brew;
    }
  }
  dxt("${targetPotion.id}##########END SIMULATION##########");
  return targetPotion;
}
