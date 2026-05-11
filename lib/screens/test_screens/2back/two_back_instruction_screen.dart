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
              Text('In the 2-back test, numbers appear on the screen one after another. Your task is to respond when the current number matches the one displayed two steps earlier. If you notice a match, press the “Press Me” button. Try to respond quickly and only when you’re sure.', style: TextStyle(color: Colors.white),),
              SizedBox(height: 40,),
              CustomButton('/twoback-screen', 'I understand')
            ],
          ),
        ),
      ),
    );
  }
}