import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';
import 'dart:math';
import 'dart:async';


class TwoBackScreen extends StatefulWidget{
  
  const TwoBackScreen (this.onTwoBack, {super.key});
  final void Function() onTwoBack;

  @override
  State<StatefulWidget> createState() {
    return _TwoBackScreen();
  }
}

class _TwoBackScreen extends State<TwoBackScreen>{

  List <int> fullTestListNBack = List.filled(60, 0);
  List <int> indexOfPairs = [];
  bool isCorrect = false;
  int rollTimeDuration = 0;
  bool isDiaplayed = false;
  int currentNumber = 0;
  int hits = 0;
  int misses = 0;
  int falseAlarms = 0;
  int tempSwitcher = 0;

  void testPreparation(){
    int numberOfPairs = Random().nextInt(6) + 12;
    Set <int> all = {};
    while(all.length< numberOfPairs){
      all.add(Random().nextInt(57)+2);
    }
    indexOfPairs = all.toList();
    indexOfPairs.sort();
    print("MATCH COUNT: $numberOfPairs");
    print("MATCH INDEXES: $indexOfPairs");

    int tempIndexList = 0;

    for(var i =0; i<fullTestListNBack.length;i++){
      if(tempIndexList < indexOfPairs.length){
        if(i == indexOfPairs[tempIndexList]){
          fullTestListNBack[i] = fullTestListNBack[i-2];
          tempIndexList++;
          
        }else{
        fullTestListNBack[i] = Random().nextInt(6)+1;
        
      }
      }
      else{
        fullTestListNBack[i] = Random().nextInt(6)+1;
        
      }
    }
    print("MATCH COUNT: $fullTestListNBack");
  }

  void indexChecker() {
    bool isMatch = false;

    if (tempSwitcher < indexOfPairs.length &&
        currentNumber == indexOfPairs[tempSwitcher]) {
      isMatch = true;
    }

    if (isMatch) {
      hits++;
      tempSwitcher++;
    } else {
      falseAlarms++;
    }
  }

  void timer(){
    Timer.periodic(const Duration(milliseconds: 500), (timer){
      if(currentNumber < 60){
        setState(() {
          if((rollTimeDuration == 0) && (isDiaplayed == false)){
            isCorrect = false;
            rollTimeDuration = Random().nextInt(4)+1;
          }
          else if((rollTimeDuration != 0) && (isDiaplayed == false)){
            rollTimeDuration--;
            if(rollTimeDuration == 0){
              isDiaplayed = true;
            }
          }
          else if((rollTimeDuration == 0) && (isDiaplayed == true)){
            rollTimeDuration = Random().nextInt(1)+1;
            
          }
          else if((rollTimeDuration != 0) && (isDiaplayed == true)){
            rollTimeDuration--;
            if(rollTimeDuration == 0){
              isDiaplayed = false;
              currentNumber++;
            }
          }
        });
      }else{
        timer.cancel();
        Navigator.pushNamed(context, '/test-menu-screen');
        //print(result);
      }
    });
  }

  @override
  void initState(){
    super.initState();
    testPreparation();
    timer();
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme_Colors.background1,
            Theme_Colors.background2
          ],
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight
          )
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isDiaplayed 
              ?Container(width: 80 ,height: 100, color: Colors.transparent, alignment: Alignment.center, child: Text(fullTestListNBack[currentNumber].toString(), style: TextStyle(fontSize: 80, color: Colors.white),))
              :Container(width: 80 ,height: 100, color: Colors.transparent,),
              SizedBox(height: 80,),
              ElevatedButton(onPressed: (){indexChecker();}, child:  Text('Press Me'))
            ],
          ),
        ),
      ),
    );
  }
}