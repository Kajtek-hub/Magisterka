import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'package:google_fonts/google_fonts.dart';


class RegisterScreen extends StatefulWidget{
  const RegisterScreen(this.onRegister, {super.key});
  final void Function() onRegister;
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends State<RegisterScreen>{
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
                Text('Register', style: GoogleFonts.lato(
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
                    hintText: "Username",
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
                CustomButton('/menu-screen', "Register account"),
                SizedBox(height: 20),
                CustomButton('/login-screen', "Have an acoout? Login in")
              ],
            ),
          ),
        ),
      )
    );
  }
}

