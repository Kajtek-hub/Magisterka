import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';
import 'dart:math';
import 'dart:async';


class GonoGo extends StatefulWidget{

  const GonoGo (this.onGoNoGo,{super.key});

  final void Function() onGoNoGo;

  @override
  State<StatefulWidget> createState() {
    return _Gonogo();
  }
}

class _Gonogo extends State<GonoGo>{

  List<int> testColorList = [];
  Color currentColor = Colors.black.withValues(alpha: 1.0);
  
  int rollTimeDuration = 0;
  bool brakeOrTest = false;
  int colorlistIter = 0;

  //int result = 0;
  int hits = 0;
  int misses = 0;
  int falseAlarms = 0;
  int correctRejections = 0;

  bool trialEvaluated = false;
  bool hasResponded = false;
  bool isMatch = false;  
  int stimulusValue = 0;

  void createTestVector(int goLength, int noGoLength){
    List<int> goList = List.filled(goLength, 1);
    List<int> noGoList = List.filled(noGoLength, 0);
    var fullTestList = goList + noGoList;
    fullTestList.shuffle();
    for(var i = 3; i<fullTestList.length; i++){
      if(fullTestList[i]==1 && fullTestList[i-1]==1 && fullTestList[i-2]==1 && fullTestList[i-3]==1){
        fullTestList[i] = 0;
      }else if(fullTestList[i]==0 && fullTestList[i-1]==0 && fullTestList[i-2]==0 && fullTestList[i-3]==0){
        fullTestList[i] = 1;
      } //Mogę zmienić potem na swapa żeby nie zaburzać proporcji 
    }
    testColorList = fullTestList;
    print('$testColorList');
  }

  void colorSwap() {
    if (testColorList[colorlistIter] == 1) {
      currentColor = Colors.green;
    } else {
      currentColor = Colors.red;
      //result++;
    }

  }
  
  void startTrial(){
    hasResponded = false;
    trialEvaluated = false;
    isMatch = (colorlistIter<testColorList.length && testColorList[colorlistIter] == 1);
  }

  void indexChecker(){
    if (!brakeOrTest) return;
    if (hasResponded) return;
    if (trialEvaluated) return;

    hasResponded = true;
    if(isMatch){
      hits++;
      
    }else{
      falseAlarms++;
    }
    
  }

  void evaluateTrial() {

    if (trialEvaluated) return;

    if (isMatch) {

      // GO trial
      if (!hasResponded) {
        misses++;
      }

    } else {

      // NOGO trial
      if (!hasResponded) {
        correctRejections++;
      }

    }
    trialEvaluated = true;
    colorlistIter++;
  }

  void timer(){
    Timer.periodic(const Duration(milliseconds: 100), (timer){

      if(colorlistIter != testColorList.length){

        setState(() {
        if(rollTimeDuration == 0 && brakeOrTest == false){
            rollTimeDuration = Random().nextInt(3)+3;
            currentColor = Colors.black.withValues(alpha: 1.0); 
            startTrial();           
            }

        else if(rollTimeDuration != 0 && brakeOrTest == false){
            rollTimeDuration--;
            if(rollTimeDuration == 0){
              brakeOrTest = true;
            }}

        else if(rollTimeDuration ==0 && brakeOrTest == true){
            rollTimeDuration = Random().nextInt(2)+5;
            colorSwap();            
          }
        
        else if(rollTimeDuration !=0 && brakeOrTest == true){
            rollTimeDuration--;
            if(rollTimeDuration == 0){
              evaluateTrial();
              brakeOrTest = false;
             
          }}
        });

      }
      else{
        timer.cancel();
        Navigator.pushNamed(context, '/test-menu-screen');
        //print(result);
        print('Hits : $hits ');
        print('Misses : $misses');
        print('False Alarms : $falseAlarms');
        print('correctRejections : $correctRejections');
        return;
      }
    });
  }


  @override
  void initState(){
    super.initState();
    int rollGoSamples = Random().nextInt(7) + 42;
    int rollNoGoSamples = 60 - rollGoSamples;
    print('$rollGoSamples');
    createTestVector(rollGoSamples, rollNoGoSamples);
    timer();
  }

  @override
  Widget build(BuildContext context) {
    return(Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: 
          [
            Theme_Colors.background1,
            Theme_Colors.background2
          ],
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight)
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

                AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: currentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),),
              SizedBox(height: 80,),
              ElevatedButton(onPressed: (){
                print("Hit Index: $colorlistIter");
                indexChecker();
                //if(currentColor == Colors.green){
                  //result++;
                //}else{
                  //result--;
                //}
              }, child: Text('Press me'))
            ],
          ),
        ),
      ),
    ));
  }
}

// To do: poprawić system zliczania