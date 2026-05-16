import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';

class StroopInstructionScreen extends StatelessWidget{

  const StroopInstructionScreen(this.onStroopInstruction, {super.key});

  final void Function() onStroopInstruction;

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
          end: AlignmentGeometry.bottomRight)
          
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('In the Stroop test, you will see words that describe colors, but they will be displayed in different colors. Your task is to identify the color in which the word is actually displayed, not the meaning of the word. Select the correct color as quickly as possible and try to ignore the content of the word. What counts is accuracy and reaction time.', style: TextStyle(color: Colors.white),),
              SizedBox(height: 40,),
              CustomButton('/stroop-screen', 'I understand')
            ],
          ),
        ),
      ),
    );
  }
}