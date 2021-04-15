import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/add_amend_bottomSheet.dart';

class AddClassBottomSheet extends StatelessWidget {

  String identifier;

  AddClassBottomSheet({this.identifier});

  @override
  Widget build(BuildContext context) {

    List <Widget> retContent = [
      SizedBox(
        height: 20.0,
      ),
      inputBox(icon: FontAwesomeIcons.school, label: 'Class Name', function: (newText){
        // do smt}
      }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(label: 'Add $identifier', function: (){
        // do smt
      }),
    ];

    return AddAmendScreen(identifier: identifier, content: retContent);
  }
}