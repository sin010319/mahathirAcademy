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

class EditFranchiseBottomSheet extends StatefulWidget {
  String identifier;
  String franchiseName;
  String franchiseLocation;
  String franchiseId;

  EditFranchiseBottomSheet(
      {this.identifier,
      this.franchiseName,
      this.franchiseLocation,
      this.franchiseId});

  @override
  _EditFranchiseBottomSheetState createState() =>
      _EditFranchiseBottomSheetState();
}

class _EditFranchiseBottomSheetState extends State<EditFranchiseBottomSheet> {
  String newFranchiseName;

  String newFranchiseLocation;

  @override
  Widget build(BuildContext context) {
    CollectionReference franchiseAdmins =
        _firestore.collection('franchiseAdmins');
    CollectionReference franchises = _firestore.collection('franchises');
    CollectionReference coaches = _firestore.collection('coaches');
    CollectionReference students = _firestore.collection('students');

    Future<void> updateFranchiseName() async {
      WriteBatch batch = _firestore.batch();

      await coaches
          .where('franchiseId', isEqualTo: widget.franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference, {"franchiseName": newFranchiseName});
          print('can update franchiseName');
        });
      });

      await franchiseAdmins
          .where('franchiseId', isEqualTo: widget.franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference, {"franchiseName": newFranchiseName});
          print('can update franchiseName');
        });
      });

      await franchises
          .where('franchiseId', isEqualTo: widget.franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference, {"franchiseName": newFranchiseName});
          print('can update franchiseName');
        });
      });

      return batch.commit();
    }

    Future<void> callFranNameFunc() async {
      await updateFranchiseName();
    }

    Future<void> updateFranchiseLocation() async {
      WriteBatch batch = _firestore.batch();

      await franchiseAdmins
          .where('franchiseId', isEqualTo: widget.franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(
              doc.reference, {"franchiseLocation": newFranchiseLocation});
          print('can update franchiseLocation');
        });
      });

      await franchises
          .where('franchiseId', isEqualTo: widget.franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(
              doc.reference, {"franchiseLocation": newFranchiseLocation});
          print('can update franchiseLocation');
        });
      });

      await students
          .where('franchiseId', isEqualTo: widget.franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(
              doc.reference, {"franchiseLocation": newFranchiseLocation});
          print('can update franchiseLocation');
        });
      });

      return batch.commit();
    }

    Future<void> callFranLocFunc() async {
      await updateFranchiseLocation();
    }

    Future<void> callFunc() async {
      if (newFranchiseLocation != null) {
        await callFranLocFunc();
      }
      if (newFranchiseName != null) {
        await callFranNameFunc();
      }
      String message =
          'You have successfully updated the franchise info. Please close this page to view the newly updated franchise info.';
      PopUpAlertClass.popUpAlert(message, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Franchise Name:  ${widget.franchiseName}',
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
            this.newFranchiseName = newText;
          }),
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Franchise Location:  ${widget.franchiseLocation}',
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
            this.newFranchiseLocation = newText;
          }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Apply Changes',
          function: () {
            if (newFranchiseName == null && newFranchiseLocation == null) {
              String message =
                  'Kindly fill up at least one field above to make modification(s) to the franchise.';
              PopUpAlertClass.popUpAlert(message, context);
            } else {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              String message =
                  'Are you sure you want to make modification(s) to the franchise info?';
              PopUpDialogClass.popUpDialog(message, context, () {
                Navigator.of(context, rootNavigator: true).pop();
                callFunc();
              }, () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            }
          }),
    ];

    return AddAmendTemplate(identifier: widget.identifier, content: retContent);
  }
}
