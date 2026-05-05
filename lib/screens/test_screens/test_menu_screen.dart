import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';

class TestMenuScreen extends StatelessWidget{
  
  const TestMenuScreen(this.onTestMenu, {super.key});
  
  final void Function() onTestMenu;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
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
              CustomButton('/pvt-instruction-screen', 'PVT'),
              SizedBox(height: 20,),
              CustomButton('/gonogo-instruction-screen', 'Go/No Go'),
              SizedBox(height: 20,),
              CustomButton('/twoback-screen', 'N-Back'),
              SizedBox(height: 20,),
              CustomButton('/menu-screen', 'Menu'),
            ],
          ),

        ),
      ),
    );
  }
}