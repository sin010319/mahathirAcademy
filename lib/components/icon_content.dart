import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:sizer/sizer.dart';

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 45.0.sp,
          color: Color(0xFF8A1501),
        ),
        SizedBox(
          height: 2.0.h,
        ),
        Text(
          label,
          style: kLabelTextStyle,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
