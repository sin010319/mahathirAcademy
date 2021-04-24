import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
class AddAdminBottomSheet extends StatelessWidget {

  String identifier;

  AddAdminBottomSheet({this.identifier});

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
      inputBox(icon: Icons.phone, label: 'Contact Number', function: (newText){
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