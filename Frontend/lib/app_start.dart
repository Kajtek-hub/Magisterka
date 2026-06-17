import 'package:flutter/material.dart';
import 'package:magisterka/screens/authentication_screens/login_screen.dart';
import 'package:magisterka/screens/authentication_screens/register_screen.dart';
import 'package:magisterka/screens/authentication_screens/welcome.dart';
import 'package:magisterka/screens/bio_signals/SleepAnalysisScreen.dart';
import 'package:magisterka/screens/bio_signals/biosignal_chart_screen.dart';
import 'package:magisterka/screens/bio_signals/ble_recording_screen.dart';
import 'package:magisterka/screens/menu_screens/menu_screen.dart';
import 'package:magisterka/screens/questionnaire_screens/kss_questionnaire_screen.dart';
import 'package:magisterka/screens/questionnaire_screens/questionnaires_menu_screen.dart';
import 'package:magisterka/screens/result_screen/result_screen.dart';
import 'package:magisterka/screens/test_screens/2back/two_back_instruction_screen.dart';
import 'package:magisterka/screens/test_screens/2back/two_back_screen.dart';
import 'package:magisterka/screens/test_screens/gonogo/gonogo_screen.dart';
import 'package:magisterka/screens/test_screens/gonogo/gonogo_instruction_screen.dart';
import 'package:magisterka/screens/test_screens/pvt/pvt_instruction_screen.dart';
import 'package:magisterka/screens/test_screens/pvt/pvt_screen.dart';
import 'package:magisterka/screens/test_screens/stroop/stroop.dart';
import 'package:magisterka/screens/test_screens/stroop/stroop_instruction_screen.dart';
import 'package:magisterka/screens/test_screens/test_menu_screen.dart';
import 'package:magisterka/screens/bio_signals/SignalViewerScreen.dart';

class AppStart extends StatefulWidget{
    const AppStart({Key? key}) : super(key: key);

    @override
  State<StatefulWidget> createState() {
    return _AppStart();
  }
}

class _AppStart extends State<AppStart>{
  void function() {
    //return null; 
  }
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
         initialRoute: '/',
         routes: {
            '/': (context) =>  WelcomeScreen(function),
            '/login-screen': (context) => LoginScreen(function),
            '/register-screen': (context) => RegisterScreen(function),
            '/menu-screen': (context) => MenuScreen(function),
            '/test-menu-screen': (context) => TestMenuScreen(function),
            '/pvt-instruction-screen': (context) => PvtInstructionScreen(function),
            '/pvt-screen': (context) => PvtScreen(function),
            '/gonogo-instruction-screen': (context) => GonogoInstructionScreen(function),
            '/gonogo-screen': (context) => GonoGo(function),
            '/twoback-instruction-screen':(context) => TwoBackInstructionScreen(function),
            '/twoback-screen':(context) => TwoBackScreen(function),
            '/stroop-instruction-screen':(context) => StroopInstructionScreen(function),
            '/stroop-screen':(context) => Stroop(function),
            '/questionnaires-menu-screen': (context) => QuestionnairesMenuScreen(function),
            '/kss-questionnaire-screen': (context) => KssQuestionnaireScreen(function),
            '/result-screen': (context) => ResultScreen(function),
            '/ble-recording': (context) => const BleRecordingScreen(),
            '/biosignal-charts': (context) => const BioSignalChartScreen(),
            '/signal-viewer': (context) => const SignalViewerScreen(),
            '/sleep-analysis': (context) => const SleepAnalysisScreen(),
         },
    );
  }
}