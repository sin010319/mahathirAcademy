import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      child: FlatButton(
        padding: EdgeInsets.all(2.8.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Color(0xFF8A1501),
              width: 6.w,
            ),
            SizedBox(width: 2.h),
            Expanded(child: Text(text, style: TextStyle(fontSize: 12.sp)))
          ],
        ),
      ),
    );
  }
}
