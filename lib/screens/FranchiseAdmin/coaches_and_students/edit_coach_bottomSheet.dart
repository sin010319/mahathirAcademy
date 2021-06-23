import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box_for_digit.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile_specific.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class EditCoachBottomSheet extends StatefulWidget {
  static const String id = '/edit_coach_info';

  String identifier;
  String coachId;
  String coachName;
  String contactNum;

  EditCoachBottomSheet(
      {this.identifier, this.coachId, this.coachName, this.contactNum});

  @override
  _EditCoachBottomSheetState createState() => _EditCoachBottomSheetState();
}

class _EditCoachBottomSheetState extends State<EditCoachBottomSheet> {
  String newContactNum;

  @override
  Widget build(BuildContext context) {
    CollectionReference coaches = _firestore.collection('coaches');

    Future<void> updateContactNum() async {
      return coaches
          .doc(widget.coachId)
          .update({
            'contactNum': this.newContactNum,
          })
          .then((value) => print("Contact Num Updated"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> callFunc() async {
      await updateContactNum();
      String message =
          'You have successfully updated the coach info. Please close this page to view the newly updated coach info.';
      PopUpAlertClass.popUpAlert(message, context);
      SpecificCoachProfile.coachDone = true;
    }

    List<Widget> retContent = [
      SizedBox(
        height: 4.0.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Contact No:  ${widget.contactNum}',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'New Contact No: ',
          style: kListItemsTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
      ),
      DigitInputBox(
          icon: FontAwesomeIcons.award,
          label: 'New Contact No',
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
            if (newContactNum == null) {
              String message =
                  'Kindly fill up the field above to make modification to the coach.';
              PopUpAlertClass.popUpAlert(message, context);
            } else {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              String message =
                  'Are you sure you want to make modification to the coach info?';
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
        title1: 'Coach Name: ${widget.coachName}');
  }
}
