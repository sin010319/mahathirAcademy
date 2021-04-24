import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
class AmendExpScreen extends StatelessWidget {

  static const String id = '/amend_exp';

  String identifier;

  AmendExpScreen({this.identifier});

  @override
  Widget build(BuildContext context) {

    List <Widget> retContent = [
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Name: Student1 ',
          style: kTitleTextStyle,
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current EXP:  230',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'New EXP: ',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      inputBox(icon: FontAwesomeIcons.award, label: 'New EXP', function: (newText){
        // do smt}
      }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(label: 'Apply Changes', function: (){
        // do smt
      }),
    ];

    return AddAmendTemplate(identifier: identifier, content: retContent);
  }
}