import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/template/select_student_template.dart';
import 'coaches_and_students/multi_assign_student_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final targetClassId = 'INACTIVE';
String franchiseIdForTransfer;
String franchiseName;
String franchiseLocation;

class InactiveClassScreen extends StatefulWidget {
  static const String id = '/inactiveClassScreen';

  String franchiseId;

  InactiveClassScreen({this.franchiseId});

  @override
  _InactiveClassScreenState createState() => _InactiveClassScreenState();

  Future retrievedStudents;
}

class _InactiveClassScreenState extends State<InactiveClassScreen> {
  String franchiseId;

  @override
  void initState() {
    franchiseId = widget.franchiseId;
    widget.retrievedStudents = callStuFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectStudentTemplate(
        myFab: FloatingActionButton(
          onPressed: () {
            showModal(multiStudentBuildBottomSheet);
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
                'Inactive CLass\n${snapshot.data.length} Students',
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
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Center(
                                child: ListTile(
                              title: Text(snapshot.data[index].studentName,
                                  style: kListItemsTextStyle),
                              trailing: Wrap(
                                spacing: 8.sp,
                                children: [
                                  Container(
                                      child: Text(
                                          snapshot.data[index].exp.toString(),
                                          style: kExpTextStyle)),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SpecificStudentProfile(
                                              studentId: snapshot
                                                  .data[index].studentId,
                                            )));
                              },
                            )),
                          );
                        })
                  ],
                ),
              );
            }));
  }

  void showModal(Widget Function(BuildContext) bottomSheet) {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: bottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    print('modal closed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  Future<List<Student>> studentData() async {
    await _firestore
        .collection('franchises')
        .where('franchiseId', isEqualTo: franchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        franchiseIdForTransfer = doc['franchiseId'];
        franchiseName = doc['franchiseName'];
        franchiseLocation = doc['franchiseLocation'];
      });
    });

    List<Student> studentList = [];

    await _firestore
        .collection('students')
        .where('classIds', arrayContains: targetClassId)
        .where('franchiseId', isEqualTo: franchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String name = doc['studentName'];
        String studentId = doc['studentId'];
        int exp = doc['exp'];
        var student = Student(name, studentId, exp);
        studentList.add(student);
      });
    });

    return studentList;
  }

  callStuFunc() async {
    return await studentData();
  }
}

Widget multiStudentBuildBottomSheet(BuildContext context) {
  String identifier = 'Student';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: MultiAssignStudentBottomSheet(
        identifier: identifier,
        classId: targetClassId,
        franchiseId: franchiseIdForTransfer,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}
