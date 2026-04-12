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

  DateTime?  _selectedDate;
  final _passwordController = TextEditingController();

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
                Row(children: [
                  //Expaned zabiera tyle miejsca ile się tylko da
                  Expanded(child: TextFormField(
                    decoration: InputDecoration(labelText: "First Name"),
                    validator: (value) => value == null || value.isEmpty? "This data is required" : null, //Walidator jak jest empty lub null to zwraca że pole wymagane
                      )
                    ),
                    SizedBox(width: 16,),
                    Expanded(child: TextFormField(
                      decoration: InputDecoration(labelText: "Last Name"),
                      validator: (value) => value == null || value.isEmpty? "This data is required" : null,
                    ))
                ],),
                SizedBox(height: 20,),
                Row(children: [
                  Expanded(child: TextFormField(
                    readOnly: true, //- Potem się może przydać
                    decoration: InputDecoration(labelText: 'Date of birth'),
                    onTap: () async // potem zobaczymy przy backendzie
                    {
                      final picked = await showDatePicker( //można dać await przed pickerem jak zrobimy asynchronicznie - picker jest asynchorniczny więc nawet trzeba
                      context: context, 
                      //initialDate: DateTime(2000), //W sumie to tylko przeszkadza ale zostawie na razie
                      firstDate: DateTime(1900), 
                      lastDate: DateTime.now());

                      if (picked != null){
                        setState(() {
                          _selectedDate = picked; //Ogólnie to musi być async bo się zmienne nie pokryją
                        });
                        //zapisz do state
                      }
                    },
                    validator: (value) => value == null || value.isEmpty? "This data is required" : null,

                  ),),
                  SizedBox(width: 16,),
                  Expanded(child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Sex'),
                    items: ["Male", "Female", "Others"].map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value){},
                    validator: (value) => value==null || value.isEmpty? "This data is required" : null,
                  ))
                ],
                
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email Adress'),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "This data is required";
                    }
                    if(!value.contains("@")){
                      return "Invalid email";
                    }
                  }
                  ),
                SizedBox(height: 20,),
                TextFormField(decoration: InputDecoration(labelText: "Password"),
                controller: _passwordController,
                obscureText: true,
                validator: (value){
                  if(value == null || value.length<6){
                    return "Password is too short";
                  }
                },
                ),
                SizedBox(height: 20,),
                TextFormField(decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value){
                  if(value != _passwordController.text){
                    return "Password do not match";
                  }
                },
                ),
                SizedBox(height: 20),
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

