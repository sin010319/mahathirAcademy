import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/customised_pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog_delete.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/models/AuthService.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/edit_student_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/transfer_coach_students_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/admin/viewFranchiseStudents.dart';
import 'package:cloud_functions/cloud_functions.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String studentName = '';
String username = '';
int exp;
String contactNum = '';
String franchiseLocation = '';
String franchiseName = '';
String franchiseId = '';
String classId = '';
String className = '';
String documentId = '';
String rank = '';
String studentId = '';
List<dynamic> classIds = [];
List<dynamic> listClassNames = [];
int globalCheckEdit = 0;

class SpecificStudentProfile extends StatefulWidget {
  static String id = "/studentProfileSpecific";
  static bool studentDone = false;
  Future studentInfo;
  String studentId;

  SpecificStudentProfile({this.studentId});

  @override
  _SpecificStudentProfileState createState() => _SpecificStudentProfileState();
}

class _SpecificStudentProfileState extends State<SpecificStudentProfile> {
  @override
  void initState() {
    documentId = widget.studentId;
    widget.studentInfo = callStudentFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                String message =
                    'Please select an option below to do your modification to the student.';
                String btn1Text = 'Transfer Franchise';
                String btn2Text = 'Edit Student Info';
                CustomizedPopUpDialogClass.popUpDialog(
                    message, context, btn1Text, btn2Text, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  showModal(studentBuildBottomSheet, 1);
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                  showModal(editStudentBuildBottomSheet, 2);
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
                    'Are you sure you wish to delete this student info from the franchise completely?';
                PopUpDialogClass.popUpDialog(message, context, () {
                  callDeleteFunc(studentId);
                  Navigator.of(context, rootNavigator: true).pop();
                }, () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: FutureBuilder(
              future: widget.studentInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return Column(
                    children: [
                      ProfilePic(),
                      SizedBox(height: 20),
                      ProfileMenu(
                        text: "Name: ${snapshot.data.studentName}",
                        icon: "assets/icons/userIcon.svg",
                        press: () => {},
                      ),
                      ProfileMenu(
                        text: "Username: ${snapshot.data.username}",
                        icon: "assets/icons/username.svg",
                        press: () => {},
                      ),
                      ProfileMenu(
                        text:
                            "Franchise Location: ${snapshot.data.franchiseLocation}",
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
                      ProfileMenu(
                        text: "Experience Points: ${snapshot.data.exp}",
                        icon: "assets/icons/experiencePoint.svg",
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "Rank: ${snapshot.data.rank}",
                        icon: "assets/icons/ranking.svg",
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

  Future<Student> getStudent() async {
    await _firestore.collection('students').doc(documentId).get().then((value) {
      Map<String, dynamic> data = value.data();
      studentName = data['studentName'];
      username = data['username'];
      contactNum = data['contactNum'];
      exp = data['exp'];
      franchiseLocation = data['franchiseLocation'];
      classIds = data['classIds'];
      studentId = data['studentId'];
      franchiseId = data['franchiseId'];
    });

    await _firestore
        .collection('franchises')
        .doc(franchiseId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      franchiseName = data['franchiseName'];
    });

    listClassNames = [];

    for (var eachClassId in classIds) {
      await _firestore
          .collection('classes')
          .where('classId', isEqualTo: eachClassId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          listClassNames.add(doc['className']);
        });
      });
    }

    rank = decideRank(exp);

    Student student = Student.completeStudentInfo(studentName, username, exp,
        franchiseLocation, listClassNames, rank, contactNum);
    return student;
  }

  Future callStudentFunc() async {
    return await getStudent();
  }

  String decideRank(int exp) {
    String retRank = "";
    if (exp >= 0 && exp < 500) {
      retRank = "Bronze Speaker";
    } else if (exp >= 500 && exp < 1000) {
      retRank = "Silver Speaker";
    } else if (exp >= 1000 && exp < 1500) {
      retRank = "Gold Speaker";
    } else if (exp >= 1500 && exp < 2000) {
      retRank = "Platinum Speaker";
    } else if (exp >= 2000 && exp < 3000) {
      retRank = "Ruby Speaker";
    } else if (exp >= 3000 && exp < 4000) {
      retRank = "Diamond Speaker";
    } else if (exp >= 4000) {
      retRank = "Elite Speaker";
    }
    return retRank;
  }

  Future<void> removeStudentData(String studentIdForDelete) async {
    CollectionReference students =
        FirebaseFirestore.instance.collection('students');
    CollectionReference classes =
        FirebaseFirestore.instance.collection('classes');

    await classes
        .where('studentIds', arrayContains: studentIdForDelete)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          "studentIds": FieldValue.arrayRemove([studentIdForDelete])
        });
      });
    });

    return students
        .doc(studentIdForDelete)
        .delete()
        .then((value) => print("Student Removed"))
        .catchError((error) => print("Failed to remove student: $error"));
  }

  // Future<void> callDeleteAccountFunc(String studentIdForDelete) async {
  //   String email = username + emailIdentifier;
  //   String password = passwordToDelete;
  //   print(email);
  //   print(password);
  //   dynamic result = await AuthService().deleteUser(email, password);
  //   if (result != null && result == true) {
  //     callDeleteAccountFunc(studentIdForDelete);
  //   } else {
  //     String message =
  //         'Please input correct user password for account deletion.';
  //     PopUpAlertClass.popUpAlert(message, context);
  //   }
  // }

  Future<void> callDeleteFunc(String studentIdForDelete) async {
    await removeStudentData(studentIdForDelete);
    String studentDeletedMsg = 'You have now successfully removed a student.';
    await PopUpAlertClass.popUpAlert(studentDeletedMsg, context);
    SpecificStudentProfile.studentDone = true;
    Future.delayed(Duration(milliseconds: 3000), () async {
      await Navigator.pop(context);
      navigateToPreviousPage();
    });
  }

  void navigateToPreviousPage() {
    try {
      Route route =
          MaterialPageRoute(builder: (context) => ViewFranchiseStudents());
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
    if (globalCheckEdit == 1 && SpecificStudentProfile.studentDone) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (globalCheckEdit == 2 && SpecificStudentProfile.studentDone) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    }
    SpecificStudentProfile.studentDone = false;
  }
}

Widget editStudentBuildBottomSheet(BuildContext context) {
  String identifier = 'Amend Student Info';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: EditStudentBottomSheet(
          identifier: identifier,
          studentId: studentId,
          studentName: studentName,
          exp: exp,
          contactNum: contactNum),
    ),
  );
}

Widget studentBuildBottomSheet(BuildContext context) {
  String identifier = 'Student';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: TransferCoachStudentBottomSheet(
        identifier: identifier,
        franchiseId: franchiseId,
        userId: studentId,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}
