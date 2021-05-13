import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class AddCoachStudentBottomSheet extends StatefulWidget {
  String identifier;
  String title1;
  String title2;
  String franchiseId;
  String classId;

  AddCoachStudentBottomSheet(
      {this.identifier,
      this.franchiseId,
      this.classId,
      this.title1,
      this.title2});

  @override
  _AddCoachStudentBottomSheetState createState() =>
      _AddCoachStudentBottomSheetState();
}

class _AddCoachStudentBottomSheetState
    extends State<AddCoachStudentBottomSheet> {
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

  CollectionReference users;

  @override
  Widget build(BuildContext context) {
    franchiseId = widget.franchiseId;
    classId = widget.classId;
    franchiseName = widget.title1;
    franchiseLocation = widget.title2;
    identifier = widget.identifier;

    Future<void> getCollectionReference() {
      if (this.identifier.toLowerCase() == 'student') {
        this.users = _firestore.collection('students');
        this.emailIdentifier = '@student.com';
      } else if (this.identifier.toLowerCase() == 'coach' ||
          this.identifier.toLowerCase() == 'facilitator') {
        this.users = _firestore.collection('coaches');
        this.emailIdentifier = '@coach.com';
      }
    }

    String numberGenerator() {
      Random r = new Random();
      int low = 1000;
      int high = 9999;
      return (r.nextInt(high - low) + low).toString();
    }

    Future<void> generateUserName() async {
      String username = "";
      if (this.name != null) {
        List<String> nameParts = this.name.split(" ");
        if (nameParts.length > 1) {
          username = nameParts[1][0];
          if (nameParts[0].length >= 3) {
            username += nameParts[0].substring(0, 3);
          } else {
            username += nameParts[0];
            while (username.length < 5) {
              username += nameParts[0][nameParts.length - 1];
            }
          }
        } else {
          if (nameParts[0].length >= 4) {
            username = nameParts[0].substring(0, 4);
          } else {
            username += nameParts[0];
            while (username.length < 5) {
              username += nameParts[0][nameParts.length - 1];
            }
          }
        }
        username = username.toLowerCase();
        username += numberGenerator();
      } else {
        print('name is null');
      }
      this.username = username;
      this.email = username + this.emailIdentifier;
    }

    Future<void> createUser() async {
      await generateUserName();
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: this.email, password: this.password);
        this.docId = userCredential.user.uid;
        this.userId = userCredential.user.uid;
        this.userIdsInArr = [this.userId];
        print(this.password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }

    Future<void> addToStudents() async {
      String coachId = '';
      String facilitatorId = '';

      await _firestore
          .collection('classes')
          .where('classId', isEqualTo: this.classId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          coachId = doc['coachId'];
          facilitatorId = doc['facilitatorId'];
        });
      });

      return users
          .doc(this.docId)
          .set({
            'classId': this.classId,
            'coachId': coachId,
            'contactNum': this.contactNum,
            'exp': 0,
            'facilitatorId': facilitatorId,
            'franchiseId': this.franchiseId,
            'franchiseLocation': this.franchiseLocation,
            'studentId': this.userId,
            'studentName': this.name,
            'username': this.username
          })
          .then((value) => print("Student Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> addToCoaches() async {
      return users
          .doc(this.docId)
          .set({
            'classIds': [this.classId],
            'coachId': this.userId,
            'coachName': this.name,
            'contactNum': this.contactNum,
            'franchiseId': this.franchiseId,
            'franchiseName': this.franchiseName,
            'username': this.username
          })
          .then((value) => print("Coach/Facilitator Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> updateClasses() async {
      CollectionReference classes = _firestore.collection('classes');

      if (this.identifier.toLowerCase() == 'student') {
        return classes
            .doc(this.classId)
            .update({'studentIds': FieldValue.arrayUnion(this.userIdsInArr)})
            .then((value) => print("New student Added to a class"))
            .catchError((error) => print("Failed to update class: $error"));
      } else if (this.identifier.toLowerCase() == 'coach') {
        return classes
            .doc(this.classId)
            .update({'coachId': this.userId})
            .then((value) => print("Coach Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      } else if (this.identifier.toLowerCase() == 'facilitator') {
        return classes
            .doc(this.classId)
            .update({'facilitatorId': this.userId})
            .then((value) => print("Facilitator Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    }

    Future<void> updateStudents() async {
      WriteBatch batch = _firestore.batch();

      if (this.identifier.toLowerCase() == 'coach') {
        await _firestore
            .collection("students")
            .where('classId', isEqualTo: this.classId)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            batch.update(doc.reference, {"coachId": this.userId});
            print('can update coachId');
          });
        });
      } else if (this.identifier.toLowerCase() == 'facilitator') {
        await _firestore
            .collection("students")
            .where('classId', isEqualTo: this.classId)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            batch.update(doc.reference, {"facilitatorId": this.userId});
            print('can update facilitatorId');
          });
        });
      }
      return batch.commit();
    }

    Future<void> callFunc() async {
      await getCollectionReference();
      await createUser();
      if (this.identifier.toLowerCase() == 'student') {
        await addToStudents();
      } else if (this.identifier.toLowerCase() == 'coach' ||
          this.identifier.toLowerCase() == 'facilitator') {
        await addToCoaches();
        await updateStudents();
      }
      await updateClasses();
      String addedMessage =
          'You have successfully added a new ${this.identifier.toLowerCase()} to this class. Please close this page to view the newly updated class info';
      PopUpAlertClass.popUpAlert(addedMessage, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      inputBox(
          icon: Icons.person,
          label: 'Name',
          function: (newText) {
            // do smt}
            this.name = newText;
          }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: Icons.lock,
          label: 'Password',
          function: (newText) {
            // do smt}
            this.password = newText;
          }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: Icons.phone,
          label: 'Contact Number',
          function: (newText) {
            // do smt}
            this.contactNum = newText;
          }),
      SizedBox(
        height: 30.0,
      ),
      RoundButton(
          label: 'Add ${widget.identifier}',
          function: () async {
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
              if (this.name != null &&
                  this.password != null &&
                  this.contactNum != null) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                String message =
                    'Are you sure you want to add a new ${this.identifier} to the class?';
                PopUpDialogClass.popUpDialog(message, context, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  callFunc();
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
              } else {
                String message =
                    'Kindly fill up all the required field(s) before adding a new ${this.identifier.toLowerCase()} to the franchise.';
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
}
