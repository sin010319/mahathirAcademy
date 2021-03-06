import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/models/student.dart';

import '../change_password_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String studentName = '';
String username = '';
int exp;
String contactNum = '';
String franchiseLocation = '';
String classId = '';
String className = '';
String studentId = '';
String rank = '';
List<dynamic> classIds = [];
List<dynamic> listClassNames = [];

class StudentProfile extends StatefulWidget {
  static String id = "/studentProfile";
  Future studentInfo;

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  void initState() {
    studentId = _auth.currentUser.uid;
    widget.studentInfo = callStudentFunc();
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
                    child: Text('My Profile',
                        style: TextStyle(
                          fontSize: 13.5.sp,
                        )),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.key),
                onPressed: () {
                  showModal();
                },
              ),
            ]),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: FutureBuilder(
              future: widget.studentInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return Column(
                    children: [
                      ProfilePic(),
                      SizedBox(height: 2.h),
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
    await _firestore.collection('students').doc(studentId).get().then((value) {
      Map<String, dynamic> data = value.data();
      studentName = data['studentName'];
      username = data['username'];
      contactNum = data['contactNum'];
      exp = data['exp'];
      franchiseLocation = data['franchiseLocation'];
      classIds = data['classIds'];
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

  void showModal() {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: changePasswordBottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    print('modal closed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }
}

Widget changePasswordBottomSheet(BuildContext context) {
  String identifier = 'Change Password student';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: ChangePasswordBottomSheet(
        identifier: identifier,
        userId: studentId,
      ),
    ),
  );
}
