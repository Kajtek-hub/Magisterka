import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget{
  
  const LoginScreen(this.onLog, {super.key});
  
  final void Function() onLog;

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen>{


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme_Colors.background1,
              Theme_Colors.background2
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
        child: Center(
          child: Container(
            width: 350,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,       
                  const Color.fromARGB(255, 216, 210, 210),         
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Login', style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme_Colors.primary
                  ),
              
                ),
                SizedBox(height: 30,),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Email adress",
                    hintStyle: TextStyle(color: Theme_Colors.primary)
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Theme_Colors.primary)
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                SizedBox(height: 30,),
                CustomButton('/menu-screen',"Login"),
                SizedBox(height: 20),
                CustomButton('/register-screen', "Create an account")
              ],
            ),
          ),
        ),
      )
    );
  }
}