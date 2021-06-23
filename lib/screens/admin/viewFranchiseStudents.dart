import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/add_student_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'package:mahathir_academy_app/template/select_student_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;
String franchiseId;
String franchiseName;
String franchiseLocation;
String franchiseAdminName;

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
        myFab: FloatingActionButton(
          onPressed: () {
            showModal();
          },
          backgroundColor: Color(0xFF8A1501),
          child: Icon(Icons.add),
        ),
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
                    fontSize: 13.5.sp),
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
              return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: <Widget>[
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data[1].length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Center(
                                child: ListTile(
                                    title: Text(
                                        snapshot.data[1][index].studentName),
                                    trailing: Text(
                                      snapshot.data[1][index].exp.toString(),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SpecificStudentProfile(
                                                    studentId: snapshot
                                                        .data[1][index]
                                                        .studentId,
                                                  )));
                                    })),
                          );
                        }),
                  ]));
            }));
  }

  void showModal() {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: studentBuildBottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    print('modal closed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  Future<List<dynamic>> studentData() async {
    String studentName;
    int exp;
    String studentId;
    List<Student> studentList = [];

    await _firestore
        .collection('franchiseAdmins')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      franchiseId = data['franchiseId'];
      franchiseName = data['franchiseName'];
      franchiseLocation = data['franchiseLocation'];
      franchiseAdminName = data['franchiseAdminName'];
    });

    await _firestore
        .collection('students')
        .where('franchiseId', isEqualTo: franchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        studentName = doc['studentName'];
        studentId = doc['studentId'];
        exp = doc['exp'];
        Student newStudent = Student(studentName, studentId, exp);
        studentList.add(newStudent);
      });
    });
    return [franchiseName, studentList];
  }

  Future callStuFunc() async {
    return await studentData();
  }
}

Widget studentBuildBottomSheet(BuildContext context) {
  String identifier = 'Student';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddStudentBottomSheet(
        identifier: identifier,
        franchiseId: franchiseId,
        franchiseAdminName: franchiseAdminName,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}
