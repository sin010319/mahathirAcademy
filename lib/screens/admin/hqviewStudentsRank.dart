import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'package:mahathir_academy_app/template/select_student_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;
String targetFranchiseId;
int noOfStudents;
List<String> studentNames = [];
String title = "";

class HQViewStudentsRank extends StatefulWidget {
  int minMark;
  int maxMark;
  String franchiseId;
  String franchiseName;

  static const String id = '/HQViewStudentRank';
  HQViewStudentsRank(
      {this.franchiseId, this.franchiseName, this.minMark, this.maxMark});

  @override
  _HQViewStudentsRankState createState() => _HQViewStudentsRankState();

  Future retrievedStudents;
}

class _HQViewStudentsRankState extends State<HQViewStudentsRank> {
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
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Center(
                              child: ListTile(
                                  title: Text(snapshot.data[index].studentName),
                                  trailing: Text(
                                    snapshot.data[index].exp.toString(),
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
                                  })),
                        );
                      }),
                ]),
              );
            }));
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
    String studentRank;
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

    for (int i = 0; i < studentIds.length; i++) {
      await _firestore
          .collection('students')
          .where('studentId', isEqualTo: studentIds[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          studentExp = doc['exp'];
          rank = decideRank(studentExp);
          if (doc['franchiseId'] == targetFranchiseId &&
              (doc['exp'] >= widget.minMark && doc['exp'] < widget.maxMark)) {
            Student newStudent =
                Student(studentNames[i], studentIds[i], studentExp);
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
    if (exp >= 0 && exp < 500) {
      retRank = "Bronze Speaker";
    } else if (exp >= 500 && exp < 1000) {
      retRank = "Silver Speaker";
    } else if (exp >= 1000 && exp < 1500) {
      retRank = "Gold Speaker";
    } else if (exp >= 1500 && exp < 2000) {
      retRank = "Platinum Speaker";
    } else if (exp >= 2000 && exp < 3000) {
      retRank = "Ruby Speaker";
    } else if (exp >= 3000 && exp < 4000) {
      retRank = "Diamond Speaker";
    } else if (exp >= 4000) {
      retRank = "Elite Speaker";
    }
    return retRank;
  }

  Future callStuFunc() async {
    return await studentData();
  }
}
