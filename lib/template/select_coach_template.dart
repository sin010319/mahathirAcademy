import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';

String identifier;

class SelectCoachTemplate extends StatefulWidget {
  FutureBuilder coachContentTitleBuilder;
  FutureBuilder myFutureBuilder;
  FloatingActionButton myFab;

  SelectCoachTemplate(
      {this.myFab, this.coachContentTitleBuilder, this.myFutureBuilder});

  static const String id = '/selectCoachTemplate';

  @override
  _SelectCoachTemplateState createState() => _SelectCoachTemplateState();
}

class _SelectCoachTemplateState extends State<SelectCoachTemplate> {
  @override
  Widget build(BuildContext context) {
    String coachAppBarTitle = 'View Coaches';
    String coachImageIconLocation = 'assets/icons/coach.png';

    return SelectViewTemplate(
      fab: widget.myFab,
      appBarTitle: coachAppBarTitle,
      imageIconLocation: coachImageIconLocation,
      contentTitleBuilder: widget.coachContentTitleBuilder,
      myFutureBuilder: widget.myFutureBuilder,
    );
  }
}
