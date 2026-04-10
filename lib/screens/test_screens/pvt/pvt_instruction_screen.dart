import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';

class PvtInstructionScreen extends StatelessWidget{

  const PvtInstructionScreen(this.onPvtInstruction, {super.key});
  
  final void Function () onPvtInstruction;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[ 
            Theme_Colors.background1,
            Theme_Colors.background2,
            ],
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
          )
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('During the test, a visual stimulus (e.g., a counter or signal) will appear on the screen at random intervals. Your task is to tap the screen as quickly as possible immediately after the stimulus appears. After each response, your reaction time will be displayed, and the test will continue automatically.', style: TextStyle(color: Colors.white),),
              SizedBox(height: 20,),
              Text('Do not tap the screen before the stimulus appears, as this will be counted as an error. Try to stay focused throughout the entire test and avoid any interruptions such as notifications or background activity.', style: TextStyle(color: Colors.white),),
              SizedBox(height: 40),
              CustomButton('/pvt-screen', 'Understand'),
            ],
          ),
        ),
      ),
    );
  }
}