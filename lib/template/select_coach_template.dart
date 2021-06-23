import 'package:flutter/material.dart';
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
