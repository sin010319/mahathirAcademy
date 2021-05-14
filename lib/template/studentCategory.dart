import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'package:mahathir_academy_app/template/select_franchise_template.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/template/select_student_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetStudentId;
String targetFranchiseId;
String targetFranchiseName;
int noOfStudents;
List <String> studentNames = [];
String title ="";
String studentRank = "";
int targetStudentExp;

class StudentCategory extends StatefulWidget {
  static const String id = '/studentCategory';

  String franchiseId;
  String franchiseName;

  StudentCategory({this.franchiseId, this.franchiseName});

  @override
  _StudentCategoryState createState() => _StudentCategoryState();

  Future retrievedStudents;
}

class _StudentCategoryState extends State<StudentCategory> {

  @override
  void initState() {
    targetStudentId = _auth.currentUser.uid;
    widget.retrievedStudents = callStuFunc();
    print(targetStudentId);
    getStudent();
    print(targetFranchiseName);
    print(targetFranchiseId);
    print("????");
    print(studentRank);
    print("yesssorrr");
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SelectStudentTemplate(
        studentContentTitleBuilder: FutureBuilder(
            future: widget.retrievedStudents,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError) {
                return Container();
              }
              return Text(
                '${targetFranchiseName} \n${snapshot.data.length} students in your current Rank: \n${studentRank}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0),
              );
            }),
        myFutureBuilder: FutureBuilder(
            future: widget.retrievedStudents,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
                print('error3');
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: Center(
                          child: ListTile(
                              title: Text(
                                  snapshot.data[index].studentName),
                              trailing: Text(
                                snapshot.data[index].exp.toString(),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SpecificStudentProfile(
                                          studentId: snapshot.data[index].studentId,
                                        )
                                    ));
                              }
                          )
                      ),
                    );
                  });
            })
    );}

  Future<Student> getStudent() async {
    await _firestore.collection('students')
        .doc(targetStudentId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      targetFranchiseName = data['franchiseLocation'];
      targetFranchiseId = data['franchiseId'];
      targetStudentExp = data['exp'];
      studentRank = decideRank(targetStudentExp);
      print(studentRank);


    });
  }

  Future<List<Student>> studentData() async {
    String studentName;
    String className;
    String classId;
    String studentId;
    List<Student> studentList = [];
    List<dynamic> classIds = [];
    List<String> studentIds = [];
    studentNames = [];
    int studentExp;
    List<int> studentExps = [];
    String rank;




    await _firestore
        .collection('students')
        .where('franchiseId', isEqualTo: targetFranchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        studentName = doc['studentName'];
        studentNames.add(studentName);
        studentId = doc['studentId'];
        studentIds.add(studentId);
        classIds = doc['classIds'];
      });
    });

    for (int i = 0; i < studentIds.length; i++){
      await _firestore
          .collection('students')
          .where('studentId', isEqualTo: studentIds[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          studentExp = doc['exp'];
          rank = decideRank(studentExp);
          print(rank);
          if (rank == studentRank) {
            Student newStudent = Student(studentNames[i], studentIds[i], studentExp);
            print(newStudent.exp);
            studentList.add(newStudent);
          }

        });
      });
    }

    studentList.sort((b, a) => a.exp.compareTo(b.exp));





    return studentList;
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



  Future callStuFunc() async {
    return await studentData();
  }

}



