import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/models/facilitator.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/class_dropdown_menu.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/view_coaches_students.dart';
import 'package:mahathir_academy_app/screens/announcement/franchiseAnnouncement.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class AssignCoachStudentBottomSheet extends StatefulWidget {
  String identifier;
  String title1;
  String title2;
  String franchiseId;
  String classId;
  // String selectedUserId;

  AssignCoachStudentBottomSheet(
      {this.identifier,
      this.franchiseId,
      this.classId,
      this.title1,
      this.title2});

  @override
  _AssignCoachStudentBottomSheetState createState() =>
      _AssignCoachStudentBottomSheetState();

  // Future retrievedUsers;
}

class _AssignCoachStudentBottomSheetState
    extends State<AssignCoachStudentBottomSheet> {
  Stream<QuerySnapshot> retrievedUsers;
  dynamic selectedUserId;

  String franchiseId;
  String classId;
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

  List<dynamic> IdForCheck = [];

  List<dynamic> usersCollected = [];

  CollectionReference users;

  @override
  void initState() {
    identifier = widget.identifier;
    franchiseId = widget.franchiseId;
    classId = widget.classId;
    callCheckFunc();

    if (this.identifier.toLowerCase() == 'student') {
      retrievedUsers = _firestore
          .collection('students')
          .where('franchiseId', isEqualTo: this.franchiseId)
          .get()
          .asStream();
    } else if (this.identifier.toLowerCase() == 'coach' ||
        this.identifier.toLowerCase() == 'facilitator') {
      retrievedUsers = _firestore
          .collection('coaches')
          .where('franchiseId', isEqualTo: this.franchiseId)
          .get()
          .asStream();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    franchiseId = widget.franchiseId;
    classId = widget.classId;
    franchiseName = widget.title1;
    franchiseLocation = widget.title2;
    identifier = widget.identifier;
    // widget.selectedUserId = null;

    List<Franchise> franchiseList;

    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'New ${this.identifier}: ',
          style: kSubtitleTextStyle,
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: StreamBuilder<QuerySnapshot>(
            stream: retrievedUsers,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError) {
                print('error3');
                return DropdownButton<dynamic>(
                  items: [],
                );
              } else {
                usersCollected = [];

                List<DropdownMenuItem<dynamic>> dropdownItems = [];
                final items = snapshot.data.docs;

                if (this.identifier.toLowerCase() == 'student') {
                  // extract a list of DropdownMenuItems from the currenciesList

                  for (var item in items) {
                    var franchiseId = item.data()['franchiseId'];
                    var studentName = item.data()['studentName'];
                    var studentId = item.data()['studentId'];
                    if (!IdForCheck.contains(studentId) &&
                        franchiseId == this.franchiseId) {
                      var newItem = DropdownMenuItem(
                        // dropdown menu item has a child of text widget
                        child: Text(studentName),
                        value:
                            studentId, // pass in the currency value when onChanged() is triggered
                      );
                      // add the item created to a list
                      dropdownItems.add(newItem);
                      Student newStudent =
                          Student.simpleStudent(studentName, studentId);
                      usersCollected.add(newStudent);
                    }
                  }
                } else if (this.identifier.toLowerCase() == 'coach') {
                  for (var item in items) {
                    var coachName = item.data()['coachName'];
                    var coachId = item.data()['coachId'];

                    var newItem = DropdownMenuItem(
                      // dropdown menu item has a child of text widget
                      child: Text(coachName),
                      value:
                          coachId, // pass in the currency value when onChanged() is triggered
                    );
                    // add the item created to a list
                    dropdownItems.add(newItem);
                    Coach newCoach = Coach.fromCoach(coachName, coachId);
                    usersCollected.add(newCoach);
                  }
                } else if (this.identifier.toLowerCase() == 'facilitator') {
                  for (var item in items) {
                    var facilitatorName = item.data()['coachName'];
                    var facilitatorId = item.data()['coachId'];

                    var newItem = DropdownMenuItem(
                      // dropdown menu item has a child of text widget
                      child: Text(facilitatorName),
                      value:
                          facilitatorId, // pass in the currency value when onChanged() is triggered
                    );
                    // add the item created to a list
                    dropdownItems.add(newItem);
                    Facilitator newFacilitator = Facilitator.fromFacilitator(
                        facilitatorName, facilitatorId);
                    usersCollected.add(newFacilitator);
                  }
                }
                // create and return a new dropdown list for user selection
                // specify data type of items in dropdown list which is String in this case

                return DropdownButton<dynamic>(
                  hint: Text('Select a ${this.identifier} from the franchise'),
                  value: selectedUserId,
                  // start out with the default value
                  // items expect a list of DropdownMenuItem widget
                  items: dropdownItems,
                  // onChanged will get triggered when the user selects a new item from that dropdown
                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectedUserId = newValue;
                    });
                    print(newValue);
                    print(selectedUserId);
                  },
                );
              }
            }),
      ),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Add ${widget.identifier}',
          function: () async {
            print(usersCollected);
            String currentCoachId;
            String currentFacilitatorId;
            await _firestore
                .collection('classes')
                .doc(this.classId)
                .get()
                .then((value) {
              Map<String, dynamic> data = value.data();
              currentCoachId = data['coachId'];
              currentFacilitatorId = data['facilitatorId'];
            });
            if ((this.identifier.toLowerCase() == 'coach' &&
                    currentCoachId == "") ||
                (this.identifier.toLowerCase() == 'facilitator' &&
                    currentFacilitatorId == "") ||
                (this.identifier.toLowerCase() == 'student')) {
              if (usersCollected.length > 0) {
                if (selectedUserId != null) {
                  String message =
                      'Are you sure you want to add a new ${this.identifier} to this class?';
                  PopUpDialogClass.popUpDialog(message, context, () {
                    Navigator.of(context, rootNavigator: true).pop();
                    callFunc();
                  }, () {
                    Navigator.of(context, rootNavigator: true).pop();
                  });
                } else {
                  String message =
                      'Kindly choose an item from the dropdown list before adding a new ${this.identifier.toLowerCase()} to the franchise.';
                  PopUpAlertClass.popUpAlert(message, context);
                }
              } else {
                String message =
                    'There is no ${this.identifier.toLowerCase()} available in the franchise to add to the class. Kindly register a new ${this.identifier.toLowerCase()} before adding to this class.';
                PopUpAlertClass.popUpAlert(message, context);
              }
            } else {
              String message =
                  'Each class is limited to only 1 ${this.identifier.toLowerCase()}. You may delete the current ${this.identifier.toLowerCase()} to add a new one or choose to edit the current ${this.identifier.toLowerCase()} info.';
              PopUpAlertClass.popUpAlert(message, context);
            }
          }),
    ];

    return AddAmendTemplate.fromTemplate(
      identifier: widget.identifier,
      content: retContent,
      title1: this.widget.title1,
      title2: this.widget.title2,
    );
  }

  Future<void> callFunc() async {
    if (this.identifier.toLowerCase() == 'student') {
      await addToStudents();
    } else if (this.identifier.toLowerCase() == 'coach' ||
        this.identifier.toLowerCase() == 'facilitator') {
      await addToCoaches();
    }
    await updateClasses();
    String addedMessage =
        'You have successfully added a new ${this.identifier.toLowerCase()} to this class. Please close this page to view the newly updated class info';
    PopUpAlertClass.popUpAlert(addedMessage, context);
  }

  Future<void> addToStudents() async {
    CollectionReference users = _firestore.collection('students');
    List<dynamic> classIds = [];

    await _firestore
        .collection('students')
        .doc(selectedUserId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      classIds = data['classIds'];
    });

    // add a student to inactive
    if (this.classId == 'INACTIVE') {
      return users
          .doc(selectedUserId)
          .update({
            'classIds': [this.classId]
          })
          .then((value) => print("Student Added"))
          .catchError((error) => print("Failed to update user: $error"));
    }
    // add to normal class
    else {
      // if a student initially in inactive class and add to normal class
      if (classIds.contains('INACTIVE')) {
        await _firestore
            .collection('classes')
            .where('classId', isEqualTo: 'INACTIVE')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              "studentIds": FieldValue.arrayRemove([selectedUserId])
            });
          });
        });

        return users
            .doc(selectedUserId)
            .update({
              'classIds': [this.classId]
            })
            .then((value) => print("Student Added"))
            .catchError((error) => print("Failed to update user: $error"));
      }
      // add student to normal class
      else {
        return users
            .doc(selectedUserId)
            .update({
              'classIds': FieldValue.arrayUnion([this.classId])
            })
            .then((value) => print("Student Added"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    }
  }

  Future<void> addToCoaches() async {
    CollectionReference users = _firestore.collection('coaches');

    return users
        .doc(selectedUserId)
        .update({
          'classIds': FieldValue.arrayUnion([this.classId])
        })
        .then((value) => print("Coach added"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateClasses() async {
    CollectionReference classes = _firestore.collection('classes');
    List<dynamic> classIds = [];

    if (this.identifier.toLowerCase() == 'student') {
      if (this.classId == 'INACTIVE') {
        await _firestore
            .collection('classes')
            .where('studentIds', arrayContains: selectedUserId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              "studentIds": FieldValue.arrayRemove([selectedUserId])
            });
          });
        });
      }
      return classes
          .doc(this.classId)
          .update({
            'studentIds': FieldValue.arrayUnion([selectedUserId])
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (this.identifier.toLowerCase() == 'coach') {
      return classes
          .doc(this.classId)
          .update({'coachId': selectedUserId})
          .then((value) => print("Coach Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (this.identifier.toLowerCase() == 'facilitator') {
      return classes
          .doc(this.classId)
          .update({'facilitatorId': selectedUserId})
          .then((value) => print("Facilitator Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future callCheckFunc() async {
    await checkIfExists();
  }

  Future<void> checkIfExists() async {
    if (this.identifier.toLowerCase() == 'student') {
      await _firestore
          .collection('students')
          .where('franchiseId', isEqualTo: this.franchiseId)
          .where('classIds', arrayContains: classId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          IdForCheck.add(doc['studentId']);
        });
      });
    }
  }
}