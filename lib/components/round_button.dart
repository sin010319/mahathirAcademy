import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundButton extends StatelessWidget {
  RoundButton({this.label, this.function});

  final String label;
  final Function function;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return RaisedButton(
      elevation: 0,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0.sp)),
      onPressed: function,
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0.sp)),
          gradient: LinearGradient(
            colors: <Color>[Colors.red[900], Colors.yellow[900]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(label, style: TextStyle(fontSize: 12.sp)),
      ),
    );
  }
}
