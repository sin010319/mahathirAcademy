import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';

class StudentProfile extends StatelessWidget {
  static String id = "/studentProfile";

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
                text: "Name: Student1",
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
                text: "Experience Points: 550",
                icon: "assets/icons/experiencePoint.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Rank: Silver Speaker",
                icon: "assets/icons/ranking.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/logOut.svg",
                press: () {},
              )
            ],
          ),
        ));
  }
}
