import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';

class KssQuestionnaireScreen extends StatefulWidget {
  const KssQuestionnaireScreen(this.onKss, {super.key});

  final void Function() onKss;
  @override
  State<StatefulWidget> createState() {
    return _KssQuestionnaireScreen();
  }
}

class _KssQuestionnaireScreen extends State<KssQuestionnaireScreen> {
  final List<Map<String, String>> kssOption = [
    {"value": "1", "label": "Niezwykle czujny/a"},
    {"value": "2", "label": ""},
    {"value": "3", "label": "Czujny/a"},
    {"value": "4", "label": ""},
    {"value": "5", "label": "Ani czujny/a, ani senny/a"},
    {"value": "6", "label": ""},
    {"value": "7", "label": "Senny/a, ale bez trudności opieram się senności"},
    {"value": "8", "label": ""},
    {"value": "9", "label": "Niezmiernie senny/a, walczę ze snem"},
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
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 40),
                RadioGroup<int>(
                  //value: _selectedValue,
                  onChanged: (int? val) {
                    setState(() {
                      _selectedValue = val;
                    });
                  },
                  child: Column(
                    children: [
                      ...kssOption.map((option) {
                        final int value = int.parse(option["value"]!,); //Do poprawy wykrzyknik
                        final String label = option["label"]!;

                        return RadioListTile<int>(
                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12,
                          ),
                          value: value,
                          fillColor: WidgetStateProperty.all(Colors.white),
                          title: Text(label.isNotEmpty ? "$value - $label" : "$value",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
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
