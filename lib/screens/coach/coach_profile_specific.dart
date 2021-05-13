import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahathir_academy_app/models/coach.dart';

import '../login_screen.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String coachName;
String franchiseName;
List<dynamic> listClassNames = [];
List<dynamic> classIds = [];
String documentId;
String username;

class SpecificCoachProfile extends StatefulWidget {
  static String id = "/coachProfileSpecific";
  Future coachInfo;
  String coachId;

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
          title: Text("Profile"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: FutureBuilder(
              future: widget.coachInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);

                  return Column(
                    children: [
                      ProfilePic(),
                      SizedBox(height: 20),
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
    Coach coach = Coach.completeInfo(
        coachName, username, classIds, franchiseName, listClassNames);
    return coach;
  }

  Future callCoachFunc() async {
    return await getCoach();
  }
}
