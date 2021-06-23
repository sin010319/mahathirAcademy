import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class MultiAssignStudentBottomSheet extends StatefulWidget {
  String identifier;
  String title1;
  String title2;
  String franchiseId;
  String classId;

  MultiAssignStudentBottomSheet(
      {this.identifier,
      this.franchiseId,
      this.classId,
      this.title1,
      this.title2});

  @override
  _MultiAssignStudentBottomSheetState createState() =>
      _MultiAssignStudentBottomSheetState();

// Future retrievedUsers;
}

class _MultiAssignStudentBottomSheetState
    extends State<MultiAssignStudentBottomSheet> {
  Stream<QuerySnapshot> retrievedUsers;
  List<dynamic> selectedUserId = [];

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
  List<dynamic> duplicateIds = [];

  List<dynamic> usersCollected = [];

  CollectionReference users;

  @override
  void initState() {
    identifier = widget.identifier;
    franchiseId = widget.franchiseId;
    classId = widget.classId;
    callCheckFunc();
    retrievedUsers = _firestore
        .collection('students')
        .where('franchiseId', isEqualTo: this.franchiseId)
        .get()
        .asStream();
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
        height: 4.0.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'New ${this.identifier}s: ',
          style: kSubtitleTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
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

                for (var item in items) {
                  var franchiseId = item.data()['franchiseId'];
                  var studentName = item.data()['studentName'];
                  var studentId = item.data()['studentId'];
                  if (!IdForCheck.contains(studentId) &&
                      franchiseId == this.franchiseId) {
                    Student newStudent =
                        Student.simpleStudent(studentName, studentId);
                    usersCollected.add(newStudent);
                  }
                }

                final _items = usersCollected
                    .map((student) => MultiSelectItem<String>(
                        student.studentId, student.studentName))
                    .toList();

                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: MultiSelectBottomSheetField(
                            initialChildSize: 0.7,
                            maxChildSize: 0.95,
                            buttonText: Text(
                                "Select multiple students from the franchise",
                                style: kDropdownTitleTextStyle),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('$franchiseName Students',
                                  style: kTitleTextStyle),
                            ),
                            items: _items,
                            onConfirm: (values) {
                              selectedUserId = values;
                              print(selectedUserId);
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              chipColor: Colors.red[900],
                              textStyle: kChipTitleTextStyle,
                              onTap: (value) {
                                setState(() {
                                  selectedUserId.remove(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
      SizedBox(height: 4.0.h),
      RoundButton(
          label: 'Add ${widget.identifier}',
          function: () async {
            print(usersCollected);
            if (usersCollected.length > 0) {
              if (selectedUserId.length > 0) {
                String message =
                    'Are you sure you want to add new ${this.identifier.toLowerCase()}(s) to this class?';
                PopUpDialogClass.popUpDialog(message, context, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  callFunc();
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
              } else {
                String message =
                    'Kindly choose at least 1 student from the dropdown list before adding new ${this.identifier.toLowerCase()}(s) to the class.';
                PopUpAlertClass.popUpAlert(message, context);
              }
            } else {
              String message =
                  'There is no ${this.identifier.toLowerCase()} available in the franchise to add to the class. Kindly register a new ${this.identifier.toLowerCase()} before adding to this class.';
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
    await addToStudents();
    await updateClasses();
    String addedMessage =
        'You have successfully added new ${this.identifier.toLowerCase()}(s) to this class. Please close this page to view the newly updated class info';
    PopUpAlertClass.popUpAlert(addedMessage, context);
  }

  Future<void> addToStudents() async {
    CollectionReference students = _firestore.collection('students');
    CollectionReference classes = _firestore.collection('classes');
    List<dynamic> classIds = [];

    for (String eachId in selectedUserId) {
      await students.doc(eachId).get().then((value) {
        Map<String, dynamic> data = value.data();
        classIds = data['classIds'];
      });

      // add a student to inactive
      if (this.classId == 'INACTIVE') {
        await students
            .where('studentId', isEqualTo: eachId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              "classIds": [this.classId]
            });
          });
        });
      }
      // add to normal class
      else {
        // if a student initially in inactive class and add to normal class
        if (classIds.contains('INACTIVE')) {
          await classes
              .where('classId', isEqualTo: 'INACTIVE')
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              doc.reference.update({
                "studentIds": FieldValue.arrayRemove([eachId])
              });
            });
          });

          await students
              .where('studentId', isEqualTo: eachId)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              doc.reference.update({
                "classIds": [this.classId]
              });
            });
          });
        }
        // add student to normal class
        else {
          await students
              .where('studentId', isEqualTo: eachId)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              doc.reference.update({
                'classIds': FieldValue.arrayUnion([this.classId])
              });
            });
          });
        }
      }
    }
  }

  Future<void> updateClasses() async {
    CollectionReference classes = _firestore.collection('classes');

    for (String eachId in selectedUserId) {
      if (this.classId == 'INACTIVE') {
        await _firestore
            .collection('classes')
            .where('studentIds', arrayContains: eachId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              "studentIds": FieldValue.arrayRemove([eachId])
            });
          });
        });
      }
    }
    return classes
        .doc(this.classId)
        .update({'studentIds': FieldValue.arrayUnion(selectedUserId)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
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
