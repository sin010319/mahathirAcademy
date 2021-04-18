import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'file:///D:/Documents/iCube%20Tech%20Consulting%20Project%202.0/git_mahathir_academy/lib/template/add_amend_bottomSheet_template.dart';

class EditFranchiseBottomSheet extends StatelessWidget {
  String identifier;

  EditFranchiseBottomSheet({this.identifier});

  @override
  Widget build(BuildContext context) {
    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Franchise Name:  Franchise1',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'New Franchise Name: ',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      inputBox(
          icon: FontAwesomeIcons.university,
          label: 'New Franchise Name',
          function: (newText) {
            // do smt}
          }),
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Franchise Location:  Location',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'New Franchise Location: ',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      inputBox(
          icon: FontAwesomeIcons.university,
          label: 'New Franchise Location',
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
