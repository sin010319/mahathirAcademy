import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/template/select_view_template_fixed.dart';

String identifier;

class SelectStudentTemplateFixed extends StatefulWidget {
  String studentContentTitle;
  FutureBuilder myFutureBuilder;

  SelectStudentTemplateFixed({this.studentContentTitle, this.myFutureBuilder});

  static const String id = '/selectStudentTemplateFixed';

  @override
  _SelectStudentTemplateFixedState createState() =>
      _SelectStudentTemplateFixedState();
}

class _SelectStudentTemplateFixedState
    extends State<SelectStudentTemplateFixed> {
  @override
  Widget build(BuildContext context) {
    String studentAppBarTitle = 'View Students';
    String studentImageIconLocation = 'assets/icons/students.png';

    return SelectViewTemplateFixed(
      fab: null,
      appBarTitle: studentAppBarTitle,
      imageIconLocation: studentImageIconLocation,
      contentTitle: widget.studentContentTitle,
      myFutureBuilder: widget.myFutureBuilder,
    );
  }
}
