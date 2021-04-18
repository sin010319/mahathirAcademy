import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'file:///D:/Documents/iCube%20Tech%20Consulting%20Project%202.0/git_mahathir_academy/lib/template/add_amend_bottomSheet_template.dart';

class AddCoachStudentBottomSheet extends StatelessWidget {

  String identifier;

  AddCoachStudentBottomSheet({this.identifier});

  @override
  Widget build(BuildContext context) {

    List <Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      inputBox(icon: Icons.email, label: 'Email', function: (newText){
        // do smt}
      }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(icon: Icons.lock, label: 'Password', function: (newText){
        // do smt}
      }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(icon: Icons.person, label: 'Name', function: (newText){
        // do smt}
      }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(icon: Icons.calendar_today, label: 'Birth Date', function: (newText){
        // do smt}
      }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(label: 'Add $identifier', function: (){
        // do smt
      }),
    ];

    return AddAmendTemplate(identifier: identifier, content: retContent);
  }
}