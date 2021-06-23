import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/customised_pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/add_coach.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/edit_coach_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/transfer_coach_students_bottomSheet.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String coachName;
String franchiseName;
List<dynamic> listClassNames = [];
List<dynamic> classIds = [];
String documentId;
String username;
String contactNum;
String coachId;
String franchiseId;
String franchiseLocation;
int globalCheckEdit = 0;

class SpecificCoachProfile extends StatefulWidget {
  static String id = "/coachProfileSpecific";
  Future coachInfo;
  String coachId;
  static bool coachDone = false;

  SpecificCoachProfile({this.coachId});

  @override
  _SpecificCoachProfileState createState() => _SpecificCoachProfileState();
}

class _SpecificCoachProfileState extends State<SpecificCoachProfile> {
  String message = "You have successfully logged out.";

  @override
  void initState() {
    documentId = widget.coachId;
    widget.coachInfo = callCoachFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            child: Row(
              children: [
                Image.asset("assets/images/brand_logo.png",
                    fit: BoxFit.contain, height: 5.5.h),
                SizedBox(
                  width: 1.5.w,
                ),
                Flexible(
                    child: Text('Coach Profile',
                        style: TextStyle(
                          fontSize: 13.5.sp,
                        )))
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                String message =
                    'Please select an option below to do your modification to the coach.';
                String btn1Text = 'Transfer Franchise';
                String btn2Text = 'Edit Coach Info';
                CustomizedPopUpDialogClass.popUpDialog(
                    message, context, btn1Text, btn2Text, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  showModal(coachBuildBottomSheet, 1);
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  showModal(editCoachBottomSheet, 2);
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                String message =
                    'Are you sure you wish to delete this coach info from the franchise completely?';
                PopUpDialogClass.popUpDialog(message, context, () {
                  callDeleteFunc(coachId);
                  Navigator.of(context, rootNavigator: true).pop();
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: FutureBuilder(
              future: widget.coachInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return Column(
                    children: [
                      ProfilePic(),
                      SizedBox(height: 2.h),
                      ProfileMenu(
                        text: "Name: ${snapshot.data.coachName}",
                        icon: "assets/icons/userIcon.svg",
                        press: () => {},
                      ),
                      ProfileMenu(
                        text: "Username: ${snapshot.data.username}",
                        icon: "assets/icons/username.svg",
                        press: () => {},
                      ),
                      ProfileMenu(
                        text: "Franchise: ${snapshot.data.franchiseName}",
                        icon: "assets/icons/school.svg",
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "Class: ${snapshot.data.classNames}",
                        icon: "assets/icons/class.svg",
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "Contact No: ${snapshot.data.contactNum}",
                        icon: "assets/icons/contactNum.svg",
                        press: () {},
                      ),
                    ],
                  );
                } else {
                  print('error3');
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }

  Future<Coach> getCoach() async {
    await _firestore.collection('coaches').doc(documentId).get().then((value) {
      Map<String, dynamic> data = value.data();
      coachName = data['coachName'];
      franchiseName = data['franchiseName'];
      classIds = data['classIds'];
      username = data['username'];
      contactNum = data['contactNum'];
      coachId = data['coachId'];
      franchiseId = data['franchiseId'];
      franchiseId = data['franchiseId'];
    });

    await _firestore
        .collection('franchises')
        .doc(franchiseId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      franchiseLocation = data['franchiseLocation'];
    });

    listClassNames = [];

    for (var eachClassId in classIds) {
      await _firestore
          .collection('classes')
          .where('classId', isEqualTo: eachClassId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print('hey');
          listClassNames.add(doc['className']);
        });
      });
    }
    Coach coach = Coach.completeInfo(coachName, username, classIds,
        franchiseName, listClassNames, contactNum);
    return coach;
  }

  Future callCoachFunc() async {
    return await getCoach();
  }

  Future<void> removeCoachData(String coachIdForDelete) async {
    CollectionReference coaches =
        FirebaseFirestore.instance.collection('coaches');
    CollectionReference classes =
        FirebaseFirestore.instance.collection('classes');

    await classes
        .where('coachId', isEqualTo: coachIdForDelete)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({"coachId": ""});
      });
    });

    await classes
        .where('facilitatorId', isEqualTo: coachIdForDelete)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({"facilitatorId": ""});
      });
    });

    return coaches
        .doc(coachIdForDelete)
        .delete()
        .then((value) => print("Coach Removed"))
        .catchError((error) => print("Failed to remove coach: $error"));
  }

  Future<void> callDeleteFunc(String coachIdForDelete) async {
    await removeCoachData(coachIdForDelete);
    String coachDeletedMsg = 'You have now successfully removed a coach';
    await PopUpAlertClass.popUpAlert(coachDeletedMsg, context);
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
    SpecificCoachProfile.coachDone = true;
    Future.delayed(Duration(milliseconds: 3000), () async {
      await Navigator.pop(context);
      navigateToPreviousPage();
    });
  }

  void navigateToPreviousPage() {
    try {
      Route route = MaterialPageRoute(builder: (context) => AddCoachScreen());
      Navigator.pushReplacement(context, route).then(onGoBack);
    } catch (exception) {
      print(exception);
    }
  }

  FutureOr onGoBack(dynamic value) {
    try {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } catch (exception) {
      print(exception);
    }
  }

  void showModal(Widget Function(BuildContext) bottomSheet, int checkEdit) {
    if (checkEdit == 1) {
      globalCheckEdit = 1;
    } else if (checkEdit == 2) {
      globalCheckEdit = 2;
    }
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: bottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    print('modal closed');
    if (globalCheckEdit == 1 && SpecificCoachProfile.coachDone) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (globalCheckEdit == 2 && SpecificCoachProfile.coachDone) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    }
    SpecificCoachProfile.coachDone = false;
  }
}

Widget coachBuildBottomSheet(BuildContext context) {
  String identifier = 'Coach';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: TransferCoachStudentBottomSheet(
        identifier: identifier,
        franchiseId: franchiseId,
        userId: coachId,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}

Widget editCoachBottomSheet(BuildContext context) {
  String identifier = 'Amend Coach Info';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: EditCoachBottomSheet(
        identifier: identifier,
        coachId: coachId,
        coachName: coachName,
        contactNum: contactNum,
      ),
    ),
  );
}
