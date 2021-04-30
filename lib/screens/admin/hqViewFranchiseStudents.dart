import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/student.dart';
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
String targetAdminId;
String targetFranchiseId;
int noOfStudents;
List <String> studentNames = [];
String title ="";

class HQViewFranchiseStudents extends StatefulWidget {

  String franchiseId;
  String franchiseName;

  HQViewFranchiseStudents({this.franchiseId, this.franchiseName});

  @override
  _HQViewFranchiseStudentsState createState() => _HQViewFranchiseStudentsState();

  Future retrievedStudents;
}

class _HQViewFranchiseStudentsState extends State<HQViewFranchiseStudents> {

  @override
  void initState() {
    targetAdminId = _auth.currentUser.uid;
    targetFranchiseId = widget.franchiseId;
    widget.retrievedStudents = callStuFunc();
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
                '${widget.franchiseName} \n${snapshot.data.length} Students',
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
                    return Card(
                      child: Center(
                          child: ListTile(
                              title: Text(
                                  snapshot.data[index].studentName),
                              trailing: Text(
                                snapshot.data[index].className,
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

  Future<List<Student>> studentData() async {
    String studentName;
    String className;
    String classId;
    String studentId;
    List<Student> studentList = [];
    List<dynamic> classIds = [];
    List<String> studentIds = [];
    studentNames = [];


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
        classId = doc['classId'];
        classIds.add(classId);
      });
    });

    for (int i = 0; i < classIds.length; i++){
      await _firestore
          .collection('classes')
          .where('classId', isEqualTo: classIds[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          className = doc['className'];
          Student newStudent = Student.viewStudent(studentNames[i], studentIds[i], className);
          studentList.add(newStudent);
        });
      });
    }

    return studentList;
  }

  Future callStuFunc() async {
    return await studentData();
  }
}



