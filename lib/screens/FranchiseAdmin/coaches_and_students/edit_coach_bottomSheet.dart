import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';

class EditCoachBottomSheet extends StatelessWidget {
  String identifier;

  EditCoachBottomSheet({this.identifier});

  @override
  Widget build(BuildContext context) {
    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Admin Name:  admin1',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      inputBox(
          icon: Icons.person,
          label: 'New Admin Name',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 10.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Admin Email:  admin1@gmail.com',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      inputBox(
          icon: Icons.email,
          label: 'New Admin Email',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 10.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Admin Contact Number:  01x-xxx xxxx',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      inputBox(
          icon: Icons.phone,
          label: 'New Admin Contact Number',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Apply Changes',
          function: () {
            // do smt
          }),
    ];

    return AddAmendTemplate(identifier: identifier, content: retContent);
  }
}
