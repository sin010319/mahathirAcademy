import 'package:flutter/material.dart';

class Guideline extends StatelessWidget {
  static const String id = '/guideline';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guidelines"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              child: Image.asset('assets/images/guidelineMark.png'),
            ),
          ],
        ),
      ),
    );
  }
}
