import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/add_amend_bottomSheet.dart';

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

    return AddAmendScreen(identifier: identifier, content: retContent);
  }
}