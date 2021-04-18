import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';


class SelectClass extends StatefulWidget {

  static const String id = '/selectClass';
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  String textForDisplay;
  Function classFunction;

  SelectClass({this.textForDisplay, this.classFunction});

  @override
  _SelectClassState createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {

  @override
  Widget build(BuildContext context) {

    String classContentTitle = widget.textForDisplay;

    return SelectClassTemplate(
        myFab: null,
        textForDisplay: classContentTitle,
        classItemBuilder: (context, index) {
            return Card(
              child: Center(
                child: ListTile(
                  title: Text(widget.classes[index],
                    style: kListItemsTextStyle,),
                  onTap: widget.classFunction,
                ),
              ),
            );
          },
        );
  }
}


