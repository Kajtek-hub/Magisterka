import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/theme.dart';

class CustomListTile extends StatefulWidget{
  
  const CustomListTile({super.key, required this.tileTitle, required this.tileValue});

  final String tileTitle;
  final int tileValue;


  @override
  State<StatefulWidget> createState() {
    return _CustomListTile();
  }
}

class _CustomListTile extends State<CustomListTile>{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.tileTitle, style: GoogleFonts.lato(
        color: Colors.white
      ) ,),
      leading: Radio(
        value:  widget.tileValue,
        fillColor: WidgetStateProperty.resolveWith((states){
          if(states.contains(WidgetState.selected)){
            return Colors.white;
          }
          else{
            return Colors.white;
          }
        }
        ),
      ),
    );
  }
}