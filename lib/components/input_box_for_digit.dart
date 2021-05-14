import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahathir_academy_app/constants.dart';

class digitinputBox extends StatelessWidget {
  digitinputBox({this.icon, this.label, this.function});

  final IconData icon;
  final String label;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      child: TextFormField(
        enabled: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red[900], size: 20),
          hintText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
        onChanged: function,
        cursorColor: Colors.redAccent,
        obscureText: false,
      ),
    );
  }
}
