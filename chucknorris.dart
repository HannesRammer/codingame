// Read inputs from Standard Input

// Write outputs to Standard Output

import 'dart:io';

 main() async{
    String inputString = stdin.readLineSync();
    List<int> binarysInt = inputString.codeUnits;
    var binarys = binarysInt.map((int strInt) => strInt.toRadixString(2));
    //print(binarys);
    //print(inputString);
    String binaryString= "";
    await binarys.forEach((item){
        //print(item.length);
        if(item.length==6){
            binaryString+="0${item}";
        }else{
            binaryString+="${item}";
        }
    });
    String unaryString = binaryToUnary(binaryString);
    print(unaryString);
}

binaryToUnary(String sevenCharBinary) {
    String currentBin = "";
    String unaryString = "";
    int count = 0;
    for (int binaryPos = 0; binaryPos < sevenCharBinary.length; binaryPos++) {
        String currentBinChar = sevenCharBinary[binaryPos];
        bool doSwitch = false;
        if (binaryPos == 0) {
            //first char
            count++;
            unaryString += setStart(currentBinChar);
        } else {
            //second to last char
            String lastBinChar = sevenCharBinary[binaryPos - 1];

            if (lastBinChar == currentBinChar) {
                count++;
            } else {
                unaryString += setCount(count);
                unaryString += " ";
                count = 1;

                unaryString += setStart(currentBinChar);
            }
        }
    }
    unaryString += setCount(count);
    return unaryString;
}


String setStart(String currentBinChar) {
    String unaryString = "";
    if (currentBinChar == "0") {
        unaryString += "00 ";
    }
    if (currentBinChar == "1") {
        unaryString += "0 ";
    }
    return unaryString;
}

String setCount(int count) {
    String unaryString = "";
    for (var i = 0; i < count; i++) {
        unaryString += "0";
    }
    return unaryString;
}