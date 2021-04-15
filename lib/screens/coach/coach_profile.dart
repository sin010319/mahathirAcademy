import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../login_screen.dart';


class CoachProfile extends StatelessWidget {
  static String id = "/coachProfile";
  final _auth = FirebaseAuth.instance;
  String message = "You have successfully logged out.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              ProfilePic(),
              SizedBox(height: 20),
              ProfileMenu(
                text: "Name: Coach1",
                icon: "assets/icons/userIcon.svg",
                press: () => {},
              ),
              ProfileMenu(
                text: "Franchise: Franchise1",
                icon: "assets/icons/school.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Class: Class1",
                icon: "assets/icons/class.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/logOut.svg",
                press: () {
                },
              )
            ],
          ),
        ));
  }
}


