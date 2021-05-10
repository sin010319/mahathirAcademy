import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';

class AddCoachStudentBottomSheet extends StatelessWidget {
  String identifier;
  String title1;
  String title2;
  String franchiseId;
  String classId;

  AddCoachStudentBottomSheet(
      {this.identifier,
      this.franchiseId,
      this.classId,
      this.title1,
      this.title2});

  @override
  Widget build(BuildContext context) {
    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      inputBox(
          icon: Icons.email,
          label: 'Email',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: Icons.lock,
          label: 'Password',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: Icons.person,
          label: 'Name',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: Icons.calendar_today,
          label: 'Birth Date',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Add $identifier',
          function: () {
            // do smt
          }),
    ];

    return AddAmendTemplate.fromTemplate(
      identifier: identifier,
      content: retContent,
      title1: this.title1,
      title2: this.title2,
    );
  }
}
