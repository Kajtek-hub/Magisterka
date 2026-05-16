import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';
import 'dart:math';
import 'dart:async';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/api/test_service.dart';

class Stroop extends StatefulWidget{
  const Stroop(this.onStroop, {super.key});

  final void Function() onStroop;

  @override
  State<StatefulWidget> createState() {
    return _Stroop();
  }
}

class _Stroop extends State<Stroop>{

  List<String> namesList = ['RED','BLUE','YELLOW','GREEN','WHITE'];
  List<Color> colorsList = [Colors.red, Colors.blue, Colors.yellow, Colors.green, Colors.white]; 
  
  int rolledName = 0;
  int rolledColor = 0;
  int previousName = -1;
  int previousColor = -1;
  
  String? currentText;
  Color? currentColor;

  int answer = 0;
  int testTime = 60;
  
  int correct = 0;
  int incorrect = 0;

  void stimulusCreator() {

    do {

      rolledName = Random().nextInt(5);
      rolledColor = Random().nextInt(5);

    } while (rolledName == previousName || rolledColor == previousColor);

    previousName = rolledName;
    previousColor = rolledColor;

    currentText = namesList[rolledName];
    currentColor = colorsList[rolledColor];
  }

  void evaluate(){
    if(answer==rolledColor){
      correct++;
    }else{
      incorrect++;
    }
  }

  void timer(){
    Timer.periodic(const Duration(seconds: 1),(timer)async{
      if(testTime>0){
        setState(() {
          testTime--;
        });
      }else{
        timer.cancel();
        try{
        final userId = await SecureStorage.getUserId();
          if (userId != null) {
          await TestService.saveStroop(
            userId: userId,
            correct: correct,
            incorrect: incorrect,
          );
        }
        }catch (e){
          print("Saving Stroop error: $e");
        }
        if(mounted){
          Navigator.pushNamed(context, '/test-menu-screen');
        }
        
        //print(correct);
        //print(incorrect);
      }
    });
  }
Widget stroopButton(Color color, int buttonValue) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: GestureDetector(
      onTap: () {
        setState(() {
          answer = buttonValue;
          evaluate();
          stimulusCreator();
        });
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
  }
  
  @override
  void initState(){
    super.initState();
    stimulusCreator();
    timer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text('$currentText', style: TextStyle(fontSize: 80, color: currentColor),),
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                stroopButton(Colors.red, 0),
                stroopButton(Colors.blue, 1) 
              ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stroopButton(Colors.yellow, 2),
                  stroopButton(Colors.green, 3) 
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stroopButton(Colors.white, 4)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
