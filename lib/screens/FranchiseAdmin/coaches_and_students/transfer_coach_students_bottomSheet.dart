import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile_specific.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class TransferCoachStudentBottomSheet extends StatefulWidget {
  String identifier;
  String title1;
  String title2;
  String franchiseId;
  String userId;

  TransferCoachStudentBottomSheet(
      {this.identifier,
      this.franchiseId,
      this.userId,
      this.title1,
      this.title2});

  @override
  _TransferCoachStudentBottomSheetState createState() =>
      _TransferCoachStudentBottomSheetState();
}

class _TransferCoachStudentBottomSheetState
    extends State<TransferCoachStudentBottomSheet> {
  String identifier;
  String contactNum;

  String emailIdentifier;

  String password;
  String email;
  String username;

  String name;
  String userId;
  dynamic userIdsInArr;
  String docId;
  String franchiseLocation;
  String franchiseName;

  Stream<QuerySnapshot> retrievedFranchises;
  dynamic selectedFranchiseId;

  CollectionReference users;

  List<dynamic> franchisesCollected = [];

  String currentFranchiseId = '';

  @override
  void initState() {
    identifier = widget.identifier;
    userId = widget.userId;
    currentFranchiseId = widget.franchiseId;
    franchiseName = widget.title1;
    franchiseLocation = widget.title2;
    // callCheckFunc();

    retrievedFranchises = _firestore.collection('franchises').get().asStream();
    print(retrievedFranchises);

    super.initState();
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
          'Transfer Franchise',
          style: kSubtitleTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: StreamBuilder<QuerySnapshot>(
            stream: retrievedFranchises,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError) {
                print('error3');
                return DropdownButton<dynamic>(
                  items: [],
                );
              } else {
                franchisesCollected = [];

                List<DropdownMenuItem<dynamic>> dropdownItems = [];
                final items = snapshot.data.docs;

                for (var item in items) {
                  var franchiseLocation = item.data()['franchiseLocation'];
                  var franchiseName = item.data()['franchiseName'];
                  var franchiseId = item.data()['franchiseId'];
                  if (currentFranchiseId != franchiseId) {
                    var newItem = DropdownMenuItem(
                      // dropdown menu item has a child of text widget
                      child: Text(franchiseLocation),
                      value:
                          franchiseId, // pass in the currency value when onChanged() is triggered
                    );
                    // add the item created to a list
                    dropdownItems.add(newItem);
                    Franchise newFranchise = Franchise(
                        franchiseName, franchiseLocation, franchiseId);
                    franchisesCollected.add(newFranchise);
                  }
                }

                // create and return a new dropdown list for user selection
                // specify data type of items in dropdown list which is String in this case
                return DropdownButton<dynamic>(
                  hint:
                      Text('Select a new franchise for the ${this.identifier}'),
                  value: selectedFranchiseId,
                  // start out with the default value
                  // items expect a list of DropdownMenuItem widget
                  items: dropdownItems,
                  // onChanged will get triggered when the user selects a new item from that dropdown
                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectedFranchiseId = newValue;
                    });
                  },
                );
              }
            }),
      ),
      SizedBox(
        height: 4.0.h,
      ),
      RoundButton(
          label: 'Transfer Franchise',
          function: () async {
            if (selectedFranchiseId != null) {
              String message =
                  'Are you sure you want to transfer this ${this.identifier} to another franchise?';
              PopUpDialogClass.popUpDialog(message, context, () {
                Navigator.of(context, rootNavigator: true).pop();
                callFunc();
              }, () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true).pop();
              });
            } else {
              String message =
                  'Kindly choose an item from the dropdown list before transferring this ${this.identifier.toLowerCase()} to another franchise.';
              PopUpAlertClass.popUpAlert(message, context);
            }
          }),
    ];

    return AddAmendTemplate.transferTemplate(
      identifier: widget.identifier,
      content: retContent,
      isTransfer: true,
      title1: this.widget.title1,
      title2: this.widget.title2,
    );
  }

  Future<void> callFunc() async {
    if (this.identifier.toLowerCase() == 'student') {
      await addToStudents();
      SpecificStudentProfile.studentDone = true;
    } else if (this.identifier.toLowerCase() == 'coach') {
      await addToCoaches();
      SpecificCoachProfile.coachDone = true;
    }
    await updateClasses();
    String addedMessage =
        'You have successfully added a new ${this.identifier.toLowerCase()} to this class. Please close this page to view the newly updated info.';
    PopUpAlertClass.popUpAlert(addedMessage, context);
  }

  Future<void> addToStudents() async {
    CollectionReference users = _firestore.collection('students');
    String newFranchiseId = selectedFranchiseId;
    String newFranchiseAdminName;
    String newFranchiseLocation;

    await _firestore
        .collection('franchiseAdmins')
        .where('franchiseId', isEqualTo: newFranchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        newFranchiseAdminName = doc['franchiseAdminName'];
        newFranchiseLocation = doc['franchiseLocation'];
      });
    });

    return users
        .doc(userId)
        .update({
          'classIds': ['INACTIVE'],
          'franchiseAdminName': newFranchiseAdminName,
          'franchiseId': newFranchiseId,
          'franchiseLocation': newFranchiseLocation
        })
        .then((value) => print("Student Added"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> addToCoaches() async {
    CollectionReference users = _firestore.collection('coaches');
    String newFranchiseId = selectedFranchiseId;
    String newFranchiseAdminName;
    String newFranchiseName;

    await _firestore
        .collection('franchiseAdmins')
        .where('franchiseId', isEqualTo: newFranchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        newFranchiseAdminName = doc['franchiseAdminName'];
        newFranchiseName = doc['franchiseName'];
      });
    });

    return users
        .doc(userId)
        .update({
          'classIds': [],
          'franchiseAdminName': newFranchiseAdminName,
          'franchiseId': newFranchiseId,
          'franchiseName': newFranchiseName
        })
        .then((value) => print("Coach added"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateClasses() async {
    CollectionReference classes = _firestore.collection('classes');
    List<dynamic> classIds = [];

    if (this.identifier.toLowerCase() == 'student') {
      await classes
          .where('studentIds', arrayContains: userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "studentIds": FieldValue.arrayRemove([userId])
          });
        });
      });

      return classes
          .doc('INACTIVE')
          .update({
            'studentIds': FieldValue.arrayUnion([userId])
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (this.identifier.toLowerCase() == 'coach') {
      await classes
          .where('coachId', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({"coachId": ""});
        });
      });

      await classes
          .where('facilitatorId', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({"facilitatorId": ""});
        });
      });
    }
  }
}
