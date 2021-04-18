import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';


class SelectClassTemplate extends StatefulWidget {

  static const String id = '/selectClassTemplate';
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  FloatingActionButton myFab;
  String textForDisplay;
  Function classItemBuilder;

  SelectClassTemplate({this.myFab, this.textForDisplay, this.classItemBuilder});

  @override
  _SelectClassTemplateState createState() => _SelectClassTemplateState();
}

class _SelectClassTemplateState extends State<SelectClassTemplate> {

  @override
  Widget build(BuildContext context) {

    String classAppBarTitle = 'Select Class';
    String classImageIconLocation = 'assets/icons/classroom.png';
    int classItemLength = widget.classes.length;
    String classContentTitle = widget.textForDisplay;

    return SelectViewTemplate(
      fab: widget.myFab,
      appBarTitle: classAppBarTitle,
      imageIconLocation: classImageIconLocation,
      contentTitle: classContentTitle,
      itemLength: classItemLength,
      myItemBuilder: widget.classItemBuilder,
      );
  }
}


