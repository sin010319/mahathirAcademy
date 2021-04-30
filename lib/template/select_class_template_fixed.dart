import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:mahathir_academy_app/template/select_view_template_fixed.dart';


class SelectClassTemplateFixed extends StatefulWidget {

  static const String id = '/selectClassTemplateFixed';
  List<String> classes = ['Class1', 'Class2'];

  FloatingActionButton myFab;
  String textForDisplay;
  FutureBuilder classItemBuilder;

  SelectClassTemplateFixed({this.myFab, this.textForDisplay, this.classItemBuilder});

  @override
  _SelectClassTemplateFixedState createState() => _SelectClassTemplateFixedState();
}

class _SelectClassTemplateFixedState extends State<SelectClassTemplateFixed> {

  @override
  Widget build(BuildContext context) {

    String classAppBarTitle = 'Select Class';
    String classImageIconLocation = 'assets/icons/classroom.png';
    String classContentTitle = widget.textForDisplay;

    return SelectViewTemplateFixed(
      fab: widget.myFab,
      appBarTitle: classAppBarTitle,
      imageIconLocation: classImageIconLocation,
      contentTitle: classContentTitle,
      myFutureBuilder: widget.classItemBuilder,
      );
  }
}


