import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InputBox extends StatelessWidget {
  InputBox({this.icon, this.label, this.function});

  final IconData icon;
  final String label;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0.sp),
      elevation: 10,
      child: TextField(
        onChanged: function,
        cursorColor: Colors.redAccent,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red[900], size: 14.sp),
          hintText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0.sp),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
