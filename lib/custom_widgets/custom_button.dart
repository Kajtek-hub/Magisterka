import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';

class CustomButton extends StatelessWidget{
  
  const CustomButton(this.routeButton, this.textButton, {super.key});
  
  final String textButton;
  final String routeButton;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){Navigator.pushNamed(context, routeButton);}, 
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme_Colors.buttonBackgroundColor,
      foregroundColor: Theme_Colors.foreBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      )
    ),
    child: Text(textButton));
  }
}