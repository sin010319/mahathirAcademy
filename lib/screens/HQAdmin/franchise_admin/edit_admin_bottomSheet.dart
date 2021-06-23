import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/input_box_for_digit.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class EditAdminBottomSheet extends StatefulWidget {
  String identifier;
  String adminId;
  String adminName;
  String adminEmail;
  String contactNum;
  String franchiseId;

  EditAdminBottomSheet(
      {this.identifier,
      this.franchiseId,
      this.adminId,
      this.adminName,
      this.adminEmail,
      this.contactNum});

  @override
  _EditAdminBottomSheetState createState() => _EditAdminBottomSheetState();
}

class _EditAdminBottomSheetState extends State<EditAdminBottomSheet> {
  String newAdminEmail;
  String newContactNum;

  @override
  Widget build(BuildContext context) {
    CollectionReference franchiseAdmins =
        _firestore.collection('franchiseAdmins');

    Future<void> updateAdminEmail() async {
      return franchiseAdmins
          .doc(widget.adminId)
          .update({
            'adminEmail': this.newAdminEmail,
          })
          .then((value) => print("Admin Email Updated"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> callEmailFunc() async {
      await updateAdminEmail();
    }

    Future<void> updateContactNum() async {
      return franchiseAdmins
          .doc(widget.adminId)
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
      if (newAdminEmail != null) {
        await callEmailFunc();
      }
      String message =
          'You have successfully updated the admin info. Please close this page to view the newly updated admin info.';
      PopUpAlertClass.popUpAlert(message, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 4.0.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Admin Email:  ${widget.adminEmail}',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
      ),
      InputBox(
          icon: Icons.email,
          label: 'New Admin Email',
          function: (newText) {
            // do smt}
            this.newAdminEmail = newText;
          }),
      SizedBox(
        height: 3.0.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Admin Contact Number:  ${widget.contactNum}',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
      ),
      DigitInputBox(
          icon: Icons.phone,
          label: 'New Admin Contact Number',
          function: (newText) {
            // do smt}
            this.newContactNum = newText;
          }),
      SizedBox(
        height: 4.0.h,
      ),
      RoundButton(
          label: 'Apply Changes',
          function: () {
            if (newContactNum == null && newAdminEmail == null) {
              String message =
                  'Kindly fill up at least one field above to make modification(s) to the admin.';
              PopUpAlertClass.popUpAlert(message, context);
            } else {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              String message =
                  'Are you sure you want to make modification(s) to the admin info?';
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
        title1: 'Admin Name: ${widget.adminName}');
  }
}
