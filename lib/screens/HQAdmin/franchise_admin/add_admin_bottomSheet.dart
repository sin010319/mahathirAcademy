import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class AddAdminBottomSheet extends StatefulWidget {
  String identifier;
  Franchise franchiseInfo;

  AddAdminBottomSheet({this.identifier, this.franchiseInfo});

  @override
  _AddAdminBottomSheetState createState() => _AddAdminBottomSheetState();
}

class _AddAdminBottomSheetState extends State<AddAdminBottomSheet> {
  String franchiseId;

  String franchiseName;

  String franchiseLocation;

  String adminEmail;

  String contactNum;

  String adminName;

  String adminId;

  String password;

  String email;

  String username;

  String docId;

  @override
  Widget build(BuildContext context) {
    this.franchiseId = widget.franchiseInfo.franchiseId;
    this.franchiseName = widget.franchiseInfo.franchiseName;
    this.franchiseLocation = widget.franchiseInfo.franchiseLocation;

    String numberGenerator() {
      Random r = new Random();
      int low = 1000;
      int high = 9999;
      return (r.nextInt(high - low) + low).toString();
    }

    CollectionReference franchiseAdmins =
        _firestore.collection('franchiseAdmins');

    CollectionReference franchises = _firestore.collection('franchises');

    Future<String> generateUserName() async {
      String username = "";
      if (this.adminName != null) {
        List<String> nameParts = this.adminName.split(" ");
        if (nameParts.length > 1) {
          username = nameParts[1][0];
          if (nameParts[0].length > 3) {
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
        username += numberGenerator();
      } else {
        print('adminName is null');
      }
      this.username = username;
      this.email = username + '@admin.com';
      return username;
    }

    Future<void> createAdmin() async {
      await generateUserName();
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: this.email, password: this.password);
        this.docId = userCredential.user.uid;
        this.adminId = userCredential.user.uid;
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

    Future<void> addtoFranchisesAdmin() async {
      return franchiseAdmins
          .doc(this.docId)
          .set({
            'adminEmail': this.adminEmail,
            'classIds': [],
            'contactNum': this.contactNum,
            'franchiseAdminId': this.adminId,
            'franchiseAdminName': this.adminName,
            'franchiseId': this.franchiseId,
            'franchiseLocation': this.franchiseLocation,
            'franchiseName': this.franchiseName,
            'username': this.username
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> updateFranchise() async {
      return franchises
          .doc(this.franchiseId)
          .update({'franchiseAdminId': this.adminId})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
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
            this.adminName = newText;
          }),
      SizedBox(
        height: 20.0,
      ),
      inputBox(
          icon: Icons.email,
          label: 'Email',
          function: (newText) {
            // do smt}
            this.adminEmail = newText;
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
            bool currentAdminExist = false;
            String currentFranchiseAdminId;
            await _firestore
                .collection('franchises')
                .doc(this.franchiseId)
                .get()
                .then((value) {
              Map<String, dynamic> data = value.data();
              currentFranchiseAdminId = data['franchiseAdminId'];
            });
            if (currentFranchiseAdminId == "") {
              if (this.adminEmail != null &&
                  this.adminName != null &&
                  this.password != null &&
                  this.contactNum != null) {
                await createAdmin();
                await addtoFranchisesAdmin();
                await updateFranchise();
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                print('error');
              }
            } else {
              String message =
                  'Each franchise is limited to only 1 franchise admin. You may delete the current franchise admin to add a new one or choose to edit the current admin info.';
              popUpAlert(message, context);
            }
          }),
    ];

    return AddAmendTemplate.fromTemplate(
      identifier: widget.identifier,
      content: retContent,
      title1: this.franchiseName,
      title2: this.franchiseLocation,
    );
  }

  popUpAlert(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Icon(Icons.close)),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(message),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
