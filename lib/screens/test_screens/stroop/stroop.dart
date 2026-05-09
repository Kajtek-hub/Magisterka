import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';

class Stroop extends StatefulWidget{
  const Stroop({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Stroop();
}
}

class _Stroop extends State<Stroop>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: 
          [
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
              Container(

              ),
              SizedBox(height: 80,),
              Row(
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
