import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class AddFranchiseBottomSheet extends StatelessWidget {
  String identifier;
  String franchiseId;
  String franchiseName;
  String franchiseLocation;
  String docId;

  AddFranchiseBottomSheet({this.identifier});

  @override
  Widget build(BuildContext context) {
    CollectionReference franchises = _firestore.collection('franchises');

    Future<void> addtoFranchises() async {
      final QuerySnapshot qSnap =
          await _firestore.collection('franchises').get();
      final int docLength = qSnap.docs.length;
      this.franchiseId = "00" + (docLength + 1).toString();
      this.docId = this.franchiseId;

      // Call the user's CollectionReference to add a new user
      return franchises
          .doc(this.docId)
          .set({
            'franchiseId': this.franchiseId, // John Doe
            'franchiseLocation': this.franchiseLocation, // Stokes and Sons
            'franchiseName': this.franchiseName, // 42
            'franchiseAdminId': ""
          })
          .then((value) => print("Franchise Added"))
          .catchError((error) => print("Failed to add user: $error"));
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
          label: 'Add $identifier',
          function: () async {
            // do smt
            if (this.franchiseName != null && this.franchiseLocation != null) {
              await addtoFranchises();
              Navigator.of(context, rootNavigator: true).pop();
            } else {
              print("error");
            }
          }),
    ];

    return AddAmendTemplate.fromTemplate(
        identifier: identifier,
        content: retContent,
        title1: 'New Franchise',
        title2: "");
  }
}
