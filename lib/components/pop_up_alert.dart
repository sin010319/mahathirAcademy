import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PopUpAlertClass extends StatelessWidget {
  PopUpAlertClass({this.message});

  final String message;

  static popUpAlert(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpAlertClass(message: message);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        content: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Icon(Icons.close)),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(message),
                SizedBox(
                  height: 2.0.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
