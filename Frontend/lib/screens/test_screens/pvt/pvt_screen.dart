import 'package:flutter/material.dart';
//import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'dart:math';
import 'dart:async';


class PvtScreen extends StatefulWidget{

  const PvtScreen(this.onPvt, {super.key});

  final void Function() onPvt;

  @override
  State<StatefulWidget> createState() {
    return _PvtScreen();
  }
}

class _PvtScreen extends State<PvtScreen>{

  int rollTimeDuration = 0;
  int pvtResult = 0;
  bool isPvtVisible = false;
  Timer? prepTimer;

  void prepCounter(){

    prepTimer?.cancel();

    rollTimeDuration = Random().nextInt(8000) + 2000;

    Timer.periodic(const Duration(milliseconds: 1),(timer){


      if(rollTimeDuration != 0){
        setState(() {
          rollTimeDuration--;
        });
      }
      else{
        timer.cancel();
        //print(rollTimeDuration);
        _startTimer();
        
      }
    });
  }



  Timer? _timer;
  void _startTimer(){
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer){
      //print('Timer started');
      
      setState(() {
        isPvtVisible = true;
        pvtResult++;
      });
    });
  }

  void _stopTimer(){
    if(_timer != null && rollTimeDuration == 0){
      _timer!.cancel();
      _timer = null;
      print(pvtResult);
      isPvtVisible = false;
    }
  }

  @override
  void initState(){
    super.initState();
    
    print(rollTimeDuration);
    prepCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme_Colors.background1,
            Theme_Colors.background2,
          ],
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight,
          ),
        
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              GestureDetector(
                onTap: () {

                  if (!isPvtVisible) {

                    print("FALSE START");
                    prepCounter();

                  } else {

                    _stopTimer();

                    Navigator.pushNamed(
                      context,
                      '/test-menu-screen',
                    );
                  }
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 15),

                  width: 250,
                  height: 250,

                  decoration: BoxDecoration(
                    color: isPvtVisible
                        ? Colors.red
                        : Colors.black,

                    borderRadius: BorderRadius.circular(16),
                  ),

                  alignment: Alignment.center,

                  child: Text(
                    pvtResult.toString(),
                    style: TextStyle(
                      color: isPvtVisible ?Colors.white :Colors.black,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              //W razie potrezby tymaczasowego użytku
              //SizedBox(height: 120,),
              //CustomButton('/test-menu-screen', 'Temporary usage'),
            ],
          ),
        ),
      ),
    );
  }
}

//To Do ochrona przed falstartem