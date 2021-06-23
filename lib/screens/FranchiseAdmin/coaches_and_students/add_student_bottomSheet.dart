import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/input_box_for_digit.dart';
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
String franchiseAdminName = '';

class AddStudentBottomSheet extends StatefulWidget {
  String identifier;
  String title1;
  String title2;
  String franchiseId;
  String franchiseAdminName;

  AddStudentBottomSheet(
      {this.identifier,
      this.franchiseId,
      this.franchiseAdminName,
      this.title1,
      this.title2});

  @override
  _AddStudentBottomSheetState createState() => _AddStudentBottomSheetState();
}

class _AddStudentBottomSheetState extends State<AddStudentBottomSheet> {
  String franchiseId;
  String identifier;
  String contactNum;
  String franchiseAdminName;

  String emailIdentifier;

  String password;
  String email;
  String username;

  String name;
  String studentId;
  String docId;
  String franchiseLocation;
  String franchiseName;

  @override
  Widget build(BuildContext context) {
    this.emailIdentifier = '@student.com';
    CollectionReference students = _firestore.collection('students');
    franchiseId = widget.franchiseId;
    franchiseName = widget.title1;
    franchiseLocation = widget.title2;
    identifier = widget.identifier;
    franchiseAdminName = widget.franchiseAdminName;

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
            while (username.length < 4) {
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

      FirebaseApp app = await Firebase.initializeApp(
          name: 'student', options: Firebase.app().options);

      try {
        UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(
                email: this.email, password: this.password);

        this.docId = userCredential.user.uid;
        this.studentId = userCredential.user.uid;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
      await app.delete();
    }

    Future<void> addToStudents() async {
      return students
          .doc(this.docId)
          .set({
            'classIds': ['INACTIVE'],
            'studentId': this.studentId,
            'studentName': this.name,
            'contactNum': this.contactNum,
            'franchiseId': this.franchiseId,
            'franchiseLocation': this.franchiseLocation,
            'franchiseAdminName': this.franchiseAdminName,
            'username': this.username,
            'exp': 0,
            'timestamp': new DateTime.now()
          })
          .then((value) => print("Student Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> updateInactiveClass() async {
      CollectionReference classes = _firestore.collection('classes');
      return classes
          .doc('INACTIVE')
          .update({
            'studentIds': FieldValue.arrayUnion([this.studentId])
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    Future<void> callFunc() async {
      await createUser();
      await addToStudents();
      await updateInactiveClass();
      String addedMessage =
          'You have successfully added a new ${this.identifier.toLowerCase()} to this class. Please close this page to view the newly updated students list.';
      PopUpAlertClass.popUpAlert(addedMessage, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 30.0,
      ),
      InputBox(
          icon: Icons.person,
          label: 'Name',
          function: (newText) {
            // do smt}
            this.name = newText;
          }),
      SizedBox(
        height: 20.0,
      ),
      InputBox(
          icon: Icons.lock,
          label: 'Password',
          function: (newText) {
            // do smt}
            this.password = newText;
          }),
      SizedBox(
        height: 20.0,
      ),
      DigitInputBox(
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
            if (this.name != null &&
                this.password != null &&
                this.contactNum != null) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              if (this.password.length < 6) {
                String message =
                    "Please provide a password with at least 6 characters.";
                PopUpAlertClass.popUpAlert(message, context);
              } else {
                String message =
                    'Are you sure you want to add a new ${this.identifier} to the ${this.franchiseName}?';
                PopUpDialogClass.popUpDialog(message, context, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  callFunc();
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
              }
            } else {
              String message =
                  'Kindly fill up all the required field(s) before adding a new ${this.identifier.toLowerCase()} to the franchise.';
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
