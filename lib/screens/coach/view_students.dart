import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';
import 'package:mahathir_academy_app/template/select_student_template.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'dart:convert';

String identifier;
// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

class ViewStudents extends StatefulWidget {

  static const String id = '/viewStudents';
  List<String> students = ['Student1', 'Student2', 'Student3'];
  List<int> exp = [230, 40, 100];
  String contentTitle;

  ViewStudents({this.contentTitle});

  @override
  _ViewStudentsState createState() => _ViewStudentsState();

  Future retrievedStudents;
}

class _ViewStudentsState extends State<ViewStudents> {

  @override
  void initState() {
    widget.retrievedStudents = callStuFunc();
  }

  @override
  Widget build(BuildContext context) {

    return SelectStudentTemplate(
        studentContentTitle: widget.contentTitle,
      studentItemBuilder: (context, index) {
      return FutureBuilder(
          builder: (context, snapshot){
        if (snapshot.hasData) {
          return Card(
            child: Center(
              child: ListTile(
                title: Text(snapshot.data[index].studentName,
                    style: kListItemsTextStyle),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    Container(
                        child: Text(snapshot.data[index].exp.toString(),
                            style: kExpTextStyle)
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, StudentProfile.id);
                },
              ),
            ),
          );
        }
        else {
          print('has error');
          return Center(child: CircularProgressIndicator());
        }
      },
        future: widget.retrievedStudents);
      }
    );
  }

  Future<List<Student>> studentData() async {
    var selectedClassId;
    List<Student> studentList = [];

    await _firestore
        .collection('classes')
        .where('className', isEqualTo: widget.contentTitle)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        selectedClassId = doc['classId'];
      });
    });

    await _firestore
        .collection('students')
        .where('classId', isEqualTo: selectedClassId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
          String name = doc['studentName'];
          int exp = doc['exp'];
          print(name);
          print(exp);
          var student = Student(name, exp);
          print(studentList);
          studentList.add(student);
      });
    });
    print('studentList');
    print(studentList);
    return studentList;
  }

  callStuFunc() async{
    return await studentData();
  }

}



