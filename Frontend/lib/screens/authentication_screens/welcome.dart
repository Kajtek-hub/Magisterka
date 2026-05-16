import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
//import 'package:google_fonts/google_fonts.dart';


class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen(this.onAuthentication, {super.key});

  final void Function() onAuthentication; 

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme_Colors.background1,
              Theme_Colors.background2
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
        child: Center(
          child: CustomButton('/login-screen', "Let's start")
        ),
      )
    );
  }
}