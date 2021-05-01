import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/models/student.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String studentName;
int exp;
String franchiseLocation;
String classId;
String className;
String documentId;
String rank;

class StudentProfile extends StatefulWidget {
  static String id = "/studentProfile";
  Future studentInfo;

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {

  @override
  void initState() {
    documentId = _auth.currentUser.uid;
    widget.studentInfo = callStudentFunc();
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
              text: "Franchise Location: ${snapshot.data.franchiseLocation}",
              icon: "assets/icons/school.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Class: ${snapshot.data.className}",
              icon: "assets/icons/class.svg",
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
      }
      else {
        print('error3');
        return Center(child: CircularProgressIndicator());
      }
    }),
        ));
  }

  Future<Student> getStudent() async {
    await _firestore.collection('students')
        .doc(documentId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      studentName = data['studentName'];
      exp = data['exp'];
      franchiseLocation = data['franchiseLocation'];
      classId = data['classId'];
    });

    await _firestore.collection('classes')
        .where('classId', isEqualTo: classId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        className = doc['className'];
      });
    });

    rank = decideRank(exp);

    Student student = Student.fromStudent(studentName, exp, franchiseLocation, className, rank);
    return student;
  }

  Future callStudentFunc() async {
    return await getStudent();
  }

  String decideRank(int exp) {
    String retRank = "";
    if (exp >= 0 && exp < 500){
      retRank = "Bronze Speaker";
    }
    else if (exp >= 500 && exp < 1000){
      retRank = "Silver Speaker";
    }
    else if (exp >= 1000 && exp < 1500){
      retRank = "Gold Speaker";
    }
    else if (exp >= 1500 && exp < 2000){
      retRank = "Platinum Speaker";
    }
    else if (exp >= 2000 && exp < 3000){
      retRank = "Ruby Speaker";
    }
    else if (exp >= 3000 && exp < 4000){
      retRank = "Diamond Speaker";
    }
    else if (exp >= 4000){
      retRank = "Elite Speaker";
    }
    return retRank;
  }

}
