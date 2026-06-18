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

  int result = 0;


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
  }

  void colorSwap() {
    if (testColorList[colorlistIter] == 1) {
      currentColor = Colors.green;
    } else {
      currentColor = Colors.red;
      result++;
    }

    colorlistIter++;
  }

  void timer(){
    Timer.periodic(const Duration(milliseconds: 100), (timer){

      if(colorlistIter != testColorList.length){

        setState(() {
        if(rollTimeDuration == 0 && brakeOrTest == false){
            rollTimeDuration = Random().nextInt(3)+3;
            currentColor = Colors.black.withValues(alpha: 1.0);            
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
              brakeOrTest = false;
          }}
        });

      }
      else{
        timer.cancel();
        Navigator.pushNamed(context, '/test-menu-screen');
        print(result);
        return;
      }
    });
  }


  @override
  void initState(){
    super.initState();
    int rollGoSamples = Random().nextInt(7) + 42;
    int rollNoGoSamples = 60 - rollGoSamples;
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
                if(currentColor == Colors.green){
                  result++;
                }else{
                  result--;
                }
              }, child: Text('Press me'))
            ],
          ),
        ),
      ),
    ));
  }
}

// To do: poprawić system zliczania