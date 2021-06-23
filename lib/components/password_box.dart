import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PasswordBox extends StatelessWidget {
  PasswordBox({this.hintText, this.function});

  final String hintText;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0.sp),
      elevation: 10,
      child: TextField(
        onChanged: function,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.redAccent,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.red[900], size: 14.sp),
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0.sp),
              borderSide: BorderSide(color: Colors.redAccent)),
        ),
      ),
    );
  }
}
