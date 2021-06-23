import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/input_box.dart';
import 'package:mahathir_academy_app/components/input_box_for_digit.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

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

    CollectionReference coaches = _firestore.collection('coaches');

    CollectionReference students = _firestore.collection('students');

    Future<String> generateUserName() async {
      String username = "";
      if (this.adminName != null) {
        List<String> nameParts = this.adminName.split(" ");
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
        print('adminName is null');
      }
      this.username = username;
      this.email = username + '@admin.com';
      return username;
    }

    Future<void> createAdmin() async {
      await generateUserName();

      FirebaseApp app = await Firebase.initializeApp(
          name: 'admin', options: Firebase.app().options);

      try {
        UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(
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
      await app.delete();
    }

    Future<void> addtoFranchisesAdmin() async {
      return franchiseAdmins
          .doc(this.docId)
          .set({
            'adminEmail': this.adminEmail,
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

    Future<void> updateData() async {
      WriteBatch batch = _firestore.batch();

      await coaches
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference, {"franchiseAdminName": adminName});
          print('can update franchiseName');
        });
      });

      await students
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference, {"franchiseAdminName": adminName});
          print('can update franchiseName');
        });
      });

      await franchises
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference,
              {"franchiseAdminId": adminId, "franchiseAdminName": adminName});
          print('can update franchise');
        });
      });

      return batch.commit();
    }

    Future<void> callFunc() async {
      await createAdmin();
      await addtoFranchisesAdmin();
      await updateData();
      String adminAddedMessage =
          'You have successfully added a new franchise admin. Please close this page to view the newly updated admin info';
      PopUpAlertClass.popUpAlert(adminAddedMessage, context);
    }

    List<Widget> retContent = [
      SizedBox(
        height: 4.0.h,
      ),
      InputBox(
          icon: Icons.person,
          label: 'Name',
          function: (newText) {
            // do smt}
            this.adminName = newText;
          }),
      SizedBox(
        height: 3.0.h,
      ),
      InputBox(
          icon: Icons.email,
          label: 'Email',
          function: (newText) {
            // do smt}
            this.adminEmail = newText;
          }),
      SizedBox(
        height: 3.0.h,
      ),
      InputBox(
          icon: Icons.lock,
          label: 'Password',
          function: (newText) {
            // do smt}
            this.password = newText;
          }),
      SizedBox(
        height: 3.0.h,
      ),
      DigitInputBox(
          icon: Icons.phone,
          label: 'Contact Number',
          function: (newText) {
            // do smt}
            this.contactNum = newText;
          }),
      SizedBox(
        height: 4.0.h,
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
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                String message =
                    'Are you sure you want to add the following admin to the franchise?';
                PopUpDialogClass.popUpDialog(message, context, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  callFunc();
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
              } else {
                String message =
                    'Kindly fill up all the required field(s) before adding a new admin to the franchise.';
                PopUpAlertClass.popUpAlert(message, context);
              }
            } else {
              String message =
                  'Each franchise is limited to only 1 franchise admin. You may delete the current franchise admin to add a new one or choose to edit the current admin info.';
              PopUpAlertClass.popUpAlert(message, context);
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
}
