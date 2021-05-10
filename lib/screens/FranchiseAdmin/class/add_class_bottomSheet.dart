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

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class AddClassBottomSheet extends StatefulWidget {
  String identifier;
  String franchiseId;
  String franchiseAdminId;

  AddClassBottomSheet(
      {this.identifier, this.franchiseId, this.franchiseAdminId});

  @override
  _AddClassBottomSheetState createState() => _AddClassBottomSheetState();
}

class _AddClassBottomSheetState extends State<AddClassBottomSheet> {
  dynamic className;
  dynamic classId;
  String classIdinStr;
  dynamic docId;

  @override
  Widget build(BuildContext context) {
    CollectionReference franchiseAdmins =
        _firestore.collection('franchiseAdmins');

    CollectionReference classes = _firestore.collection('classes');

    Future<void> updateClassIds() async {
      final QuerySnapshot qSnap = await _firestore.collection('classes').get();
      final int docLength = qSnap.docs.length;
      this.classId = ['000${docLength}'];
      this.docId = '000${docLength}';
      this.classIdinStr = this.docId;

      return franchiseAdmins
          .doc(widget.franchiseAdminId)
          .update({'classIds': FieldValue.arrayUnion(this.classId)})
          .then((value) => print("New Class Added to franchise"))
          .catchError((error) => print("Failed to update class: $error"));
    }

    Future<void> addNewClass() async {
      return classes
          .doc(this.docId)
          .set({
            'classId': this.classIdinStr,
            'className': this.className,
            'coachId': "", // 42
            'facilitatorId': "",
            'facilitatorId': "",
            'studentIds': []
          })
          .then((value) => print("New Class Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> callFunc() async {
      await updateClassIds();
      await addNewClass();
      String classAddedMessage =
          'You have successfully added a new class. Please close this page to view the newly updated student EXP.';
      PopUpAlertClass.popUpAlert(classAddedMessage, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: FontAwesomeIcons.school,
          label: 'Class Name',
          function: (newText) {
            // do smt}
            this.className = newText;
          }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Add ${widget.identifier}',
          function: () {
            // do smt
            // do smt
            if (this.className != null) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              String message =
                  'Are you sure you want to add the following class?';
              PopUpDialogClass.popUpDialog(message, context, () {
                Navigator.of(context, rootNavigator: true).pop();
                callFunc();
              }, () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            } else {
              String message =
                  'Kindly fill up all the required field(s) before adding a new class.';
              PopUpAlertClass.popUpAlert(message, context);
            }
          }),
    ];

    return AddAmendTemplate.fromTemplate(
      identifier: widget.identifier,
      content: retContent,
      title1: 'New Class',
      title2: "",
    );
  }
}
