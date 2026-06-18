import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';

class GonogoInstructionScreen extends StatelessWidget{

  const GonogoInstructionScreen (this.onGonogoInstruction, {super.key});

  final void Function() onGonogoInstruction;

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
              Text('', style: TextStyle(color: Colors.white),),
              SizedBox(height: 40,),
              CustomButton('/twoback-screen', 'I understand')
            ],
          ),
        ),
      ),
    );
  }
}