import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class EditClassBottomSheet extends StatefulWidget {
  String identifier;
  String className;
  String classId;
  String franchiseName;
  String franchiseLocation;

  EditClassBottomSheet(
      {this.identifier,
      this.className,
      this.classId,
      this.franchiseName,
      this.franchiseLocation});

  @override
  _EditClassBottomSheetState createState() => _EditClassBottomSheetState();
}

class _EditClassBottomSheetState extends State<EditClassBottomSheet> {
  String newClassName;

  CollectionReference classes = _firestore.collection('classes');

  Future<void> updateClassName() async {
    return classes
        .doc(widget.classId)
        .update({
          'className': this.newClassName,
        })
        .then((value) => print("Class Name Updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> callFunc() async {
    await updateClassName();
    String message =
        'You have successfully updated the class name. Please close this page to view the newly updated classes.';
    PopUpAlertClass.popUpAlert(message, context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> retContent = [
      SizedBox(
        height: 4.0.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Class Name:  ${widget.className}',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
      ),
      InputBox(
          icon: FontAwesomeIcons.university,
          label: 'New Class Name',
          function: (newText) {
            // do smt}
            this.newClassName = newText;
          }),
      SizedBox(
        height: 4.0.h,
      ),
      RoundButton(
          label: 'Apply Changes',
          function: () {
            // do smt
            if (newClassName == null) {
              String message =
                  'Kindly fill up the field above to make modification to the class.';
              PopUpAlertClass.popUpAlert(message, context);
            } else {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              String message =
                  'Are you sure you want to make modification to the class name?';
              PopUpDialogClass.popUpDialog(message, context, () {
                Navigator.of(context, rootNavigator: true).pop();
                callFunc();
              }, () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
          }),
    ];

    return AddAmendTemplate.fromTemplate(
        identifier: widget.identifier,
        content: retContent,
        title1: widget.franchiseName,
        title2: widget.franchiseLocation);
  }
}
