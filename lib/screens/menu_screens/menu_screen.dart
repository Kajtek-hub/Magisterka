import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';

class MenuScreen extends StatelessWidget{

  const MenuScreen(this.onMenu,{super.key});

  final void Function() onMenu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[
            Theme_Colors.background1,
            Theme_Colors.background2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
          )
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton('/test-menu-screen', 'Tests'),
              SizedBox(height: 20,),
              CustomButton('/questionnaires-menu-screen', 'Questionnaire'),
              SizedBox(height: 20,),
              CustomButton('/login-screen', 'Log out')
            ],
          ),
        ),
      ),
    );
    
  }
} 