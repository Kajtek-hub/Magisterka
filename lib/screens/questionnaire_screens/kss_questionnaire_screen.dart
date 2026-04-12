import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'package:magisterka/custom_widgets/custom_ListTile.dart';

class KssQuestionnaireScreen extends StatefulWidget {
  const KssQuestionnaireScreen(this.onKss, {super.key});

  final void Function() onKss;
  @override
  State<StatefulWidget> createState() {
    return _KssQuestionnaireScreen();
  }
}

class _KssQuestionnaireScreen extends State<KssQuestionnaireScreen> {
  //final List<Map<String, String>> kssOption = [
  //  {"value": "1", "label": "Niezwykle czujny/a"},
  //  {"value": "2", "label": ""},
  //  {"value": "3", "label": "Czujny/a"},
  //  {"value": "4", "label": ""},
  //  {"value": "5", "label": "Ani czujny/a, ani senny/a"},
  //  {"value": "6", "label": ""},
  //  {"value": "7", "label": "Senny/a, ale bez trudności opieram się senności"},
  //  {"value": "8", "label": ""},
  //  {"value": "9", "label": "Niezmiernie senny/a, walczę ze snem"},
  //];
final List<String> kssOption = [
  "1 Extremely alert",
  "2",
  "3 Alert",
  "4",
  "5 Neither alert nor sleepy",
  "6",
  "7 Sleepy, but I can easily resist sleepiness",
  "8",
  "9 Extremely sleepy, fighting sleep",
];
  int? _selectedValue; //Jak obejrze filmiki to poprawie
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme_Colors.background1, Theme_Colors.background2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40),
                Text(
                  'How sleepy are you?',
                  style: TextStyle(color: Colors.white,
                  fontSize: 32),
                ),
                SizedBox(height: 40),
                RadioGroup<int>(
                  groupValue: _selectedValue , 
                  onChanged: (int? value){
                    setState(() {
                      _selectedValue = value;
                      print(_selectedValue);
                    });
                }, 
                child: Column(
                  children: List.generate(kssOption.length, (index){
                    
                    return CustomListTile(tileTitle: kssOption[index], tileValue: index+1);
                  })
                  
                )),
                SizedBox(height: 20),
                CustomButton(
                  '/questionnaires-menu-screen',
                  'Questionnaires menu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
