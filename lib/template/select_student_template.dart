import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';

String identifier;

class SelectStudentTemplate extends StatefulWidget {

  Function studentItemBuilder;
  String studentContentTitle;

  SelectStudentTemplate({this.studentContentTitle, this.studentItemBuilder});

  static const String id = '/selectStudentTemplate';
  String coach = 'Coach1';
  List<String> students = ['Student1', 'Student2', 'Student3'];
  List<int> exp = [230, 40, 100];

  @override
  _SelectStudentTemplateState createState() => _SelectStudentTemplateState();
}

class _SelectStudentTemplateState extends State<SelectStudentTemplate> {
  @override
  Widget build(BuildContext context) {

    String studentAppBarTitle = 'View Students';
    String studentImageIconLocation = 'assets/icons/students.png';
    int studentItemLength = widget.students.length;

    return SelectViewTemplate(
      fab: null,
      appBarTitle: studentAppBarTitle,
      imageIconLocation: studentImageIconLocation,
      contentTitle: widget.studentContentTitle,
      itemLength: studentItemLength,
      myItemBuilder: widget.studentItemBuilder
      );
  }
}

