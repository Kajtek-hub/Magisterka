import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'package:magisterka/custom_widgets/my_painter.dart';

class PvtScreen extends StatefulWidget{

  const PvtScreen(this.onPvt, {super.key});

  final void Function() onPvt;

  @override
  State<StatefulWidget> createState() {
    return _PvtScreen();
  }
}

class _PvtScreen extends State<PvtScreen>{
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
          end: AlignmentGeometry.bottomRight,
          ),
        
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                    size: const Size(0, 0), 
                    painter: MyPainter(),
              ),
              SizedBox(height: 120,),
              CustomButton('/test-menu-screen', 'Temporary usage'),
            ],
          ),
        ),
      ),
    );
  }
}