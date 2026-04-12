  import 'package:flutter/material.dart';
  class MyPainter extends CustomPainter {
  void squareWithOpacity(){
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 250,
      height: 250,
    ); 

    Paint paint = Paint()
      ..color = Colors.black.withOpacity(1.0)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}