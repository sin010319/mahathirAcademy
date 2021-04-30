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

class ViewFranchiseStudents extends StatefulWidget {
  FloatingActionButton fab;
  Function function;
  Function myItemBuilder;

  static const String id = '/ViewFranchiseStudents';
  List<String> students = ['Student1', 'Student2', 'Student3'];
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  @override
  _ViewFranchiseStudentsState createState() => _ViewFranchiseStudentsState();

  Future retrievedStudents;
}

class _ViewFranchiseStudentsState extends State<ViewFranchiseStudents> {
  @override
  void initState() {
    targetAdminId = _auth.currentUser.uid;
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
                print('error3');
                return Container();
              }
              return Text(
                '${snapshot.data[0]} \n${snapshot.data[1].length} students',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0),
              );
            }),
        myFutureBuilder: FutureBuilder(
            future: widget.retrievedStudents,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError) {
                print('error3');
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data[1].length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Center(
                          child: ListTile(
                              title: Text(snapshot.data[1][index].studentName),
                              trailing: Text(
                                snapshot.data[1][index].className,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SpecificStudentProfile(
                                          studentId: snapshot.data[1][index].studentId,
                                        )
                                    ));
                              })),
                    );
                  });
            }));
  }

  Future<List<dynamic>> studentData() async {
    String franchiseId;
    String studentName;
    String className;
    String classId;
    String studentId;
    List<String> studentIds = [];
    List<Student> studentList = [];
    List<String> classIds = [];
    List<String> studentNames = [];
    String franchiseName;

    await _firestore
        .collection('franchiseAdmins')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      franchiseId = data['franchiseId'];
      franchiseName = data['franchiseName'];
    });

    await _firestore
        .collection('students')
        .where('franchiseId', isEqualTo: franchiseId)
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

    for (int i = 0; i < classIds.length; i++) {
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
    return [franchiseName, studentList];
  }

  Future callStuFunc() async {
    return await studentData();
  }
}
