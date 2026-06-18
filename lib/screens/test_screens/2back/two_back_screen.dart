import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';

class TwoBackScreen extends StatefulWidget{
  
  const TwoBackScreen (this.onTwoBack, {super.key});
  final void Function() onTwoBack;

  @override
  State<StatefulWidget> createState() {
    return _TwoBackScreen();
  }
}

class _TwoBackScreen extends State<TwoBackScreen>{




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
          end: AlignmentGeometry.bottomRight
          )
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

            ],
          ),
        ),
      ),
    );
  }
}