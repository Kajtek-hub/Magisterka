import 'package:flutter/material.dart';
//import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'package:magisterka/custom_widgets/my_painter.dart';
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

  void prepCounter(){
    Timer.periodic(const Duration(milliseconds: 1),(timer){
      if(rollTimeDuration != 0){
        setState(() {
          rollTimeDuration--;
        });
      }
      else{
        timer.cancel();
        print(rollTimeDuration);
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
    }
  }

  @override
  void initState(){
    super.initState();
    rollTimeDuration = Random().nextInt(8000) + 2000;
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
              CustomPaint(
                    size: const Size(250, 250), 
                    painter: MyPainter(),
                    child: ElevatedButton(onPressed: (){
                      _stopTimer();
                      Navigator.pushNamed(context, '/kss-questionnaire-screen');

                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPvtVisible == false? Colors.black : Colors.red,
                      foregroundColor: isPvtVisible == false? Colors.black : Colors.white
                    ),
                    child: Text(pvtResult.toString()),
                    ),
              ),
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