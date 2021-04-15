import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/constants.dart';

class inputBox extends StatelessWidget {

  inputBox({this.icon, this.label, this.function});

  final IconData icon;
  final String label;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      child:TextField(
        onChanged: function,
        cursorColor: Colors.redAccent,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red[900], size: 20),
          hintText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
