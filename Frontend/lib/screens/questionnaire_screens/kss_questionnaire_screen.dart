import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';
import 'package:magisterka/custom_widgets/custom_ListTile.dart';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/api/test_service.dart';

class KssQuestionnaireScreen extends StatefulWidget {
  const KssQuestionnaireScreen(this.onKss, {super.key});

  final void Function() onKss;

  @override
  State<StatefulWidget> createState() {
    return _KssQuestionnaireScreen();
  }
}

class _KssQuestionnaireScreen extends State<KssQuestionnaireScreen> {
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

  int? _selectedValue;

  Future<void> _saveAndNavigate() async {
    if (_selectedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a sleepiness level")),
      );
      return;
    }

    try {
      final userId = await SecureStorage.getUserId();
      if (userId != null) {
        await TestService.saveKSS(
          userId: userId,
          sleepinessLevel: _selectedValue!,
        );
      }
    } catch (e) {
      print("Saving KSS error: $e");
    }

    if (mounted) {
      Navigator.pushNamed(context, '/questionnaires-menu-screen');
    }
  }

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
                const SizedBox(height: 40),
                const Text(
                  'How sleepy are you?',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                const SizedBox(height: 40),
                RadioGroup<int>(
                  groupValue: _selectedValue,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  child: Column(
                    children: List.generate(kssOption.length, (index) {
                      return CustomListTile(
                        tileTitle: kssOption[index],
                        tileValue: index + 1,
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: _saveAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme_Colors.buttonBackgroundColor,
                    foregroundColor: Theme_Colors.foreBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Questionnaires menu"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}