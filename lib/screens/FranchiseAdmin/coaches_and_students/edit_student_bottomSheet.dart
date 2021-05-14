import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/input_box_for_digit.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/admin/hqViewFranchiseStudents.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific_hq.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class EditStudentBottomSheet extends StatefulWidget {
  static const String id = '/edit_student_info';

  String identifier;
  String studentId;
  String studentName;
  String contactNum;
  int exp;

  EditStudentBottomSheet(
      {this.identifier,
      this.studentId,
      this.studentName,
      this.exp,
      this.contactNum});

  @override
  _EditStudentBottomSheetState createState() => _EditStudentBottomSheetState();
}

class _EditStudentBottomSheetState extends State<EditStudentBottomSheet> {
  String newContactNum;

  int newExp;

  @override
  Widget build(BuildContext context) {
    CollectionReference students = _firestore.collection('students');

    Future<void> updateExp() async {
      return students
          .doc(widget.studentId)
          .update({
            'exp': this.newExp,
          })
          .then((value) => print("Exp Updated"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> callExpFunc() async {
      await updateExp();
    }

    Future<void> updateContactNum() async {
      return students
          .doc(widget.studentId)
          .update({
            'contactNum': this.newContactNum,
          })
          .then((value) => print("Contact Num Updated"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> callContactNumFunc() async {
      await updateContactNum();
    }

    Future<void> callFunc() async {
      if (newContactNum != null) {
        await callContactNumFunc();
      }
      if (newExp != null) {
        await callExpFunc();
      }
      SpecificStudentProfile.studentDone = true;
      SpecificStudentProfileHQ.studentDone = true;
      String message =
          'You have successfully updated the student info. Please close this page to view the newly updated student info.';
      PopUpAlertClass.popUpAlert(message, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current EXP:  ${widget.exp.toString()}',
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
      digitinputBox(
          icon: FontAwesomeIcons.award,
          label: 'New EXP',
          function: (newText) {
            // do smt}
            this.newExp = int.parse(newText);
          }),
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Contact No:  ${widget.contactNum}',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'New Contact No: ',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      digitinputBox(
          icon: FontAwesomeIcons.award,
          label: 'New Contact No',
          function: (newText) {
            // do smt}
            this.newContactNum = newText;
          }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Apply Changes',
          function: () {
            if (newContactNum == null && newExp == null) {
              String message =
                  'Kindly fill up at least one field above to make modification(s) to the student.';
              PopUpAlertClass.popUpAlert(message, context);
            } else {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              String message =
                  'Are you sure you want to make modification(s) to the student info?';
              PopUpDialogClass.popUpDialog(message, context, () {
                Navigator.of(context, rootNavigator: true).pop();
                callFunc();
              }, () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
          }),
    ];

    return AddAmendTemplate.editTemplate(
        identifier: widget.identifier,
        content: retContent,
        title1: 'Student Name: ${widget.studentName}');
  }
}
