import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';

class QuestionnairesMenuScreen extends StatelessWidget{
  
  const QuestionnairesMenuScreen(this.onQuestionnaaireMenu, {super.key});

  final void Function() onQuestionnaaireMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[
            Theme_Colors.background1,
            Theme_Colors.background2,
          ],
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            CustomButton('/kss-questionnaire-screen', 'KSS'),
            SizedBox(height: 20),
            CustomButton('/menu-screen', 'Menu'),
            ],
          ),
        ),
      ),
    );
  }
}