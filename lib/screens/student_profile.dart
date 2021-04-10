import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {

  static const String id = '/student_profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('My Profile'),
      )
    );
  }
}

