import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';

class TwoBackInstructionScreen extends StatelessWidget{
  
  const TwoBackInstructionScreen(this.onTwoBackInstruction, {super.key});
  final void Function() onTwoBackInstruction;
  
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
          end: AlignmentGeometry.bottomRight),

        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('In this test, colored squares will appear on the screen. When you see a green square, tap the screen as quickly as possible. When a red square appears, do not react. Try to respond quickly and accurately, avoiding mistakes. The squares will appear at random intervals, so stay focused throughout the test. Tap “I understand” to begin.', style: TextStyle(color: Colors.white),),
              SizedBox(height: 40,),
              CustomButton('/gonogo-screen', 'I understand')
            ],
          ),
        ),
      ),
    );
  }
}