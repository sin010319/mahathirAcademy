import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/models/coach.dart';

import '../change_password_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String coachName;
String franchiseName;
List<dynamic> listClassNames = [];
List<dynamic> classIds = [];
String coachId;
String username;
String contactNum;

class CoachProfile extends StatefulWidget {
  static String id = "/coachProfile";
  Future coachInfo;

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> {
  @override
  void initState() {
    coachId = _auth.currentUser.uid;
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
    await _firestore.collection('coaches').doc(coachId).get().then((value) {
      Map<String, dynamic> data = value.data();
      coachName = data['coachName'];
      classIds = data['classIds'];
      username = data['username'];
      contactNum = data['contactNum'];
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

    Coach coach = Coach.completeInfo(coachName, username, classIds,
        franchiseName, listClassNames, contactNum);
    return coach;
  }

  Future callCoachFunc() async {
    return await getCoach();
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
  String identifier = 'Change Password coach';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: ChangePasswordBottomSheet(
        identifier: identifier,
        userId: coachId,
      ),
    ),
  );
}
