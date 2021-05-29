import 'dart:math';

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

// for spinner
import 'package:modal_progress_hud/modal_progress_hud.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class AddFranchiseBottomSheet extends StatefulWidget {
  String identifier;

  AddFranchiseBottomSheet({this.identifier});

  @override
  _AddFranchiseBottomSheetState createState() =>
      _AddFranchiseBottomSheetState();
}

class _AddFranchiseBottomSheetState extends State<AddFranchiseBottomSheet> {
  String franchiseId;

  String franchiseName;

  String franchiseLocation;

  String docId;

  @override
  Widget build(BuildContext context) {
    CollectionReference franchises = _firestore.collection('franchises');
    bool showSpinner = false;

    Future<void> addToFranchises() async {
      List<int> franchiseIds = [];

      await _firestore
          .collection('franchises')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          franchiseIds.add(int.parse(doc.id));
        });
      });

      int largestFranchiseId = 0;
      if (franchiseIds.length > 0) {
        largestFranchiseId = franchiseIds.fold(franchiseIds[0], max);
      }
      this.franchiseId = '00${largestFranchiseId + 1}';
      this.docId = '00${largestFranchiseId + 1}';

      // Call the user's CollectionReference to add a new user
      return franchises
          .doc(this.docId)
          .set({
            'franchiseId': this.franchiseId, // John Doe
            'franchiseLocation': this.franchiseLocation, // Stokes and Sons
            'franchiseName': this.franchiseName, // 42
            'franchiseAdminId': "",
            'classIds': []
          })
          .then((value) => print("Franchise Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> callFunc() async {
      await addToFranchises();
      String franchiseAddedMessage =
          'You have successfully added a new franchise. Please close this page to view the newly updated franchises.';
      PopUpAlertClass.popUpAlert(franchiseAddedMessage, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: FontAwesomeIcons.university,
          label: 'Franchise Name',
          function: (newText) {
            // do smt}
            this.franchiseName = newText;
          }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: FontAwesomeIcons.locationArrow,
          label: 'Franchise Location',
          function: (newText) {
            // do smt}
            this.franchiseLocation = newText;
          }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Add ${widget.identifier}',
          function: () async {
            // do smt
            if (this.franchiseName != null && this.franchiseLocation != null) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              String message =
                  'Are you sure you want to add the following franchise?';
              PopUpDialogClass.popUpDialog(message, context, () {
                Navigator.of(context, rootNavigator: true).pop();
                callFunc();
              }, () {
                Navigator.of(context, rootNavigator: true).pop();
              });
            } else {
              String message =
                  'Kindly fill up all the required field(s) before adding a new franchise.';
              PopUpAlertClass.popUpAlert(message, context);
            }
          }),
    ];

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: AddAmendTemplate.fromTemplate(
          identifier: widget.identifier,
          content: retContent,
          title1: 'New Franchise',
          title2: ""),
    );
  }
}
