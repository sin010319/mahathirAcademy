import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';

class SelectClassTemplate extends StatefulWidget {
  static const String id = '/selectClassTemplate';
  List<String> classes = ['Class1', 'Class2'];

  FloatingActionButton myFab;
  FutureBuilder classContentTitle;
  FutureBuilder classItemBuilder;

  SelectClassTemplate(
      {this.myFab, this.classContentTitle, this.classItemBuilder});

  @override
  _SelectClassTemplateState createState() => _SelectClassTemplateState();
}

class _SelectClassTemplateState extends State<SelectClassTemplate> {
  @override
  Widget build(BuildContext context) {
    String classAppBarTitle = 'Select Class';
    String classImageIconLocation = 'assets/icons/classroom.png';

    return SelectViewTemplate(
      fab: widget.myFab,
      appBarTitle: classAppBarTitle,
      imageIconLocation: classImageIconLocation,
      contentTitleBuilder: widget.classContentTitle,
      myFutureBuilder: widget.classItemBuilder,
    );
  }
}
