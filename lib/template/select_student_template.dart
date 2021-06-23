import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';

String identifier;

class SelectStudentTemplate extends StatefulWidget {
  FutureBuilder studentContentTitleBuilder;
  FutureBuilder myFutureBuilder;
  FloatingActionButton myFab;

  SelectStudentTemplate(
      {this.myFab, this.studentContentTitleBuilder, this.myFutureBuilder});

  static const String id = '/selectStudentTemplate';

  @override
  _SelectStudentTemplateState createState() => _SelectStudentTemplateState();
}

class _SelectStudentTemplateState extends State<SelectStudentTemplate> {
  @override
  Widget build(BuildContext context) {
    String studentAppBarTitle = 'View Students';
    String studentImageIconLocation = 'assets/icons/students.png';

    return SelectViewTemplate(
      fab: widget.myFab,
      appBarTitle: studentAppBarTitle,
      imageIconLocation: studentImageIconLocation,
      contentTitleBuilder: widget.studentContentTitleBuilder,
      myFutureBuilder: widget.myFutureBuilder,
    );
  }
}
