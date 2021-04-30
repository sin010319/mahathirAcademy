import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:mahathir_academy_app/template/select_view_template_fixed.dart';

String identifier;

class SelectStudentTemplateFixed extends StatefulWidget {

  // Function studentItemBuilder;
  String studentContentTitle;
  // int studentItemLength;
  FutureBuilder myFutureBuilder;

  SelectStudentTemplateFixed({this.studentContentTitle, this.myFutureBuilder});

  static const String id = '/selectStudentTemplateFixed';
  // String coach = 'Coach1';
  // List<String> students = ['Student1', 'Student2'];
  // List<int> exp = [230, 40, 100];

  @override
  _SelectStudentTemplateFixedState createState() => _SelectStudentTemplateFixedState();
}

class _SelectStudentTemplateFixedState extends State<SelectStudentTemplateFixed> {
  @override
  Widget build(BuildContext context) {

    String studentAppBarTitle = 'View Students';
    String studentImageIconLocation = 'assets/icons/students.png';
    // int studentItemLength = widget.students.length;

    return SelectViewTemplateFixed(
      fab: null,
      appBarTitle: studentAppBarTitle,
      imageIconLocation: studentImageIconLocation,
      contentTitle: widget.studentContentTitle,
      myFutureBuilder: widget.myFutureBuilder,
      );
  }
}

