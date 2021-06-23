import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/models/class.dart';
import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/models/facilitator.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile_specific.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'assign_coach_students_bottomSheet.dart';
import 'multi_assign_student_bottom_sheet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
List<String> studentNames = [];
String targetClassId;
bool hasFaci = true;

String coachId = '';
String coachName = '';
String facilitatorId = '';
String facilitatorName = '';
String studentId = '';
String studentName;
String studentExp;
int studentListLength = 0;
String globalClassId = '';

String franchiseId;
String franchiseName;
String franchiseLocation;

String identifier;

class ViewCoachStudent extends StatefulWidget {
  static const String id = '/viewCoachStudent';

  String classId = '';

  ViewCoachStudent({this.classId});

  @override
  _ViewCoachStudentState createState() => _ViewCoachStudentState();

  Future retrievedClassData;
}

class _ViewCoachStudentState extends State<ViewCoachStudent> {
  @override
  void initState() {
    coachId = '';
    coachName = '';
    facilitatorId = '';
    facilitatorName = '';
    studentId = '';
    studentName;
    studentExp;
    studentListLength = 0;
    globalClassId = '';

    targetClassId = widget.classId;
    widget.retrievedClassData = callFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,
        animatedIconTheme: IconThemeData(size: 18.sp, color: Colors.white),
        backgroundColor: Color(0xFF8A1501),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          // FAB 1
          SpeedDialChild(
              child: Icon(Icons.person_add_alt, color: Colors.white),
              backgroundColor: Color(0xFFC61F00),
              onTap: () {
                setState(() {
                  showModal(coachBuildBottomSheet);
                });
              },
              label: 'Assign Coach',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 11.0.sp),
              labelBackgroundColor: Color(0xFFFF3700)),
          // FAB 3
          SpeedDialChild(
              child: Icon(Icons.person_add_alt, color: Colors.white),
              backgroundColor: Color(0xFFC61F00),
              onTap: () {
                setState(() {
                  showModal(facilitatorBuildBottomSheet);
                });
              },
              label: 'Assign Facilitator',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 11.0.sp),
              labelBackgroundColor: Color(0xFFFF3700)),
          // FAB 3
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.peopleArrows, color: Colors.white),
              backgroundColor: Color(0xFFC61F00),
              onTap: () {
                setState(() {
                  // do smt
                  if (facilitatorName == '') {
                    String message =
                        'There is no facilitator available in the class to be upgraded.';
                    PopUpAlertClass.popUpAlert(message, context);
                  } else if (facilitatorName != '' && coachName != '') {
                    String message =
                        'There is a coach currently existing in this class. Kindly remove this coach if you wish to upgrade the facilitator to coach.';
                    PopUpAlertClass.popUpAlert(message, context);
                  } else if (facilitatorName != '' && coachName == '') {
                    String message =
                        'Are you sure you want to upgrade current facilitator to the coach for this class?';
                    PopUpDialogClass.popUpDialog(message, context, () {
                      Navigator.of(context, rootNavigator: true).pop();
                      callUpgradeFaci(facilitatorId);
                    }, () {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  }
                });
              },
              label: 'Upgrade Facilitator',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 11.0.sp),
              labelBackgroundColor: Color(0xFFFF3700)),
          // FAB 3
          SpeedDialChild(
              child: Icon(Icons.person_add_alt_1, color: Colors.white),
              backgroundColor: Color(0xFFC61F00),
              onTap: () {
                setState(() {
                  showModal(multiStudentBuildBottomSheet);
                });
              },
              label: 'Assign Student',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 11.0.sp),
              labelBackgroundColor: Color(0xFFFF3700)),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Row(
            children: [
              Image.asset("assets/images/brand_logo.png",
                  fit: BoxFit.contain, height: 5.5.h),
              SizedBox(
                width: 1.5.w,
              ),
              Flexible(
                child: Text('View Coaches & Students',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                    )),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFDB5D38),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // wrap the icon in a circle avatar
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage("assets/icons/presentation.png"),
                    radius: 25.0.sp,
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  FutureBuilder(
                      future: widget.retrievedClassData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done ||
                            snapshot.hasError) {
                          print('error3');
                          return Container();
                        }
                        return Text(
                          snapshot.data.className,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5.sp),
                        );
                      }),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              // container must have a child to get shown up on screen
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.sp),
                      topRight: Radius.circular(20.0.sp))),
              child: SingleChildScrollView(
                child: returnFutureBuilder(),
              ),
            ))
          ]),
    );
  }

  Future<void> removeData(String userIdForDelete, String identifier) async {
    CollectionReference classes =
        FirebaseFirestore.instance.collection('classes');
    CollectionReference coaches = _firestore.collection('coaches');
    CollectionReference students = _firestore.collection('students');

    if (identifier == 'coach') {
      await classes
          .where('classId', isEqualTo: targetClassId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({"coachId": ""});
        });
      });

      await coaches
          .where('coachId', isEqualTo: userIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "classIds": FieldValue.arrayRemove([targetClassId])
          });
        });
      });
    } else if (identifier == 'facilitator') {
      await classes
          .where('classId', isEqualTo: targetClassId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({"facilitatorId": ""});
        });
      });

      await coaches
          .where('coachId', isEqualTo: userIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "classIds": FieldValue.arrayRemove([targetClassId])
          });
        });
      });
    } else if (identifier == 'student') {
      await classes
          .where('classId', isEqualTo: targetClassId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "studentIds": FieldValue.arrayRemove([userIdForDelete])
          });
        });
      });

      await students
          .where('studentId', isEqualTo: userIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "classIds": FieldValue.arrayRemove([targetClassId])
          });
        });
      });

      List<dynamic> classIds = [];

      await _firestore
          .collection('students')
          .doc(userIdForDelete)
          .get()
          .then((value) {
        Map<String, dynamic> data = value.data();
        classIds = data['classIds'];
      });

      if (classIds.length == 0) {
        await students
            .where('studentId', isEqualTo: userIdForDelete)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              "classIds": FieldValue.arrayUnion(['INACTIVE'])
            });
          });
        });
      }

      await classes
          .where('classId', isEqualTo: 'INACTIVE')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "studentIds": FieldValue.arrayUnion([userIdForDelete])
          });
        });
      });
    }
  }

  Future<void> callDeleteFunc(String userIdForDelete, String identifier) async {
    await removeData(userIdForDelete, identifier);
    String userDeletedMsg =
        'You have successfully removed a $identifier from the class.';
    await PopUpAlertClass.popUpAlert(userDeletedMsg, context);
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });
  }

  Future<void> upgradeFaci(String faciIdForUpdate) async {
    await _firestore
        .collection('classes')
        .where('classId', isEqualTo: targetClassId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({"facilitatorId": "", "coachId": faciIdForUpdate});
      });
    });
  }

  Future<void> callUpgradeFaci(String faciIdForUpdate) async {
    await upgradeFaci(faciIdForUpdate);
    String upgradeFacidMsg =
        'You have successfully updated a facilitator to a coach for this class.';
    await PopUpAlertClass.popUpAlert(upgradeFacidMsg, context);
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });
  }

  FutureBuilder<dynamic> returnFutureBuilder() {
    return FutureBuilder(
      future: widget.retrievedClassData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.hasError) {
          print('error3');
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.coach != null) {
          coachName = snapshot.data.coach.coachName;
          coachId = snapshot.data.coach.coachId;
        }
        if (snapshot.data.studentList != null) {
          studentListLength = snapshot.data.studentList.length;
        }
        return Column(children: [
          SizedBox(
            height: 2.0.h,
          ),
          Text('Coach', style: kCoachStudentLabelTextStyle),
          Container(
              child: Card(
            child: Center(
              child: ListTile(
                title: Text(coachName, style: kListItemsTextStyle),
                trailing: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Color(0xFF8A1501),
                    ),
                    onTap: () {
                      if (coachName != '') {
                        String message =
                            'Are you sure you want to remove ${snapshot.data.coach.coachName} from this class?';
                        PopUpDialogClass.popUpDialog(message, context, () {
                          Navigator.of(context, rootNavigator: true).pop();
                          callDeleteFunc(snapshot.data.coach.coachId, 'coach');
                        }, () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      }
                    }),
                onTap: () {
                  if (coachId != '') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SpecificCoachProfile(
                                  coachId: coachId,
                                )));
                  }
                },
              ),
            ),
          )),
          Column(children: returnFaciSection(hasFaci, context, snapshot)),
          studentListLength == 0
              ? Container()
              : Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: studentListLength,
                      itemBuilder: (context, index) {
                        Student student;
                        if (studentListLength > 0) {
                          student = snapshot.data.studentList[index];
                        }
                        if (student != null) {
                          return Card(
                            child: Center(
                              child: ListTile(
                                title: Text(student.studentName,
                                    style: kListItemsTextStyle),
                                trailing: Wrap(
                                  spacing: 8.sp,
                                  children: [
                                    Container(
                                        child: Text(student.exp.toString(),
                                            style: kExpTextStyle)),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.delete,
                                        color: Color(0xFF8A1501),
                                      ),
                                      onTap: () {
                                        String message =
                                            'Are you sure you want to remove ${student.studentName} from this class?';
                                        PopUpDialogClass.popUpDialog(
                                            message, context, () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          callDeleteFunc(
                                              student.studentId, 'student');
                                        }, () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        });
                                      },
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SpecificStudentProfile(
                                                studentId: student.studentId,
                                              )));
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
        ]);
      },
    );
  }

  Future<Class> classData() async {
    String studentName;
    String coachId;
    String facilitatorId;
    List<dynamic> studentIds = [];
    String coachName;
    String facilitatorName;
    Coach coach;
    Facilitator facilitator;
    List<Student> studentList = [];
    String className;
    int exp;

    await _firestore
        .collection('franchiseAdmins')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      franchiseId = data['franchiseId'];
      franchiseName = data['franchiseName'];
      franchiseLocation = data['franchiseLocation'];
    });

    await _firestore
        .collection('classes')
        .where('classId', isEqualTo: targetClassId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        className = doc['className'];
        coachId = doc['coachId'];
        globalClassId = doc['classId'];
        try {
          facilitatorId = doc['facilitatorId'];
          hasFaci = true;
        } catch (Exception) {
          hasFaci = false;
        }
        studentIds = doc['studentIds'];
      });
    });

    await _firestore
        .collection('coaches')
        .where('coachId', isEqualTo: coachId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        coachName = doc['coachName'];
        coach = Coach.fromCoach(coachName, coachId);
      });
    });

    await _firestore
        .collection('coaches')
        .where('coachId', isEqualTo: facilitatorId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        facilitatorName = doc['coachName'];
        facilitator =
            Facilitator.fromFacilitator(facilitatorName, facilitatorId);
      });
    });

    for (int i = 0; i < studentIds.length; i++) {
      await _firestore
          .collection('students')
          .where('studentId', isEqualTo: studentIds[i])
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          studentName = doc['studentName'];
          exp = doc['exp'];
          Student newStudent = Student(studentName, studentIds[i], exp);
          studentList.add(newStudent);
          print('hey');
        });
      });
    }
    Class newClass =
        Class.main(className, targetClassId, coach, facilitator, studentList);
    return newClass;
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

  Future callFunc() async {
    return await classData();
  }

  dynamic returnFaciSection(
      bool hasFaci, BuildContext context, AsyncSnapshot snapshot) {
    Widget sizedBox2 = SizedBox(
      height: 1.5.h,
    );
    if (snapshot.data.facilitator != null) {
      facilitatorName = snapshot.data.facilitator.facilitatorName;
      facilitatorId = snapshot.data.facilitator.facilitatorId;
    }
    int studentListLength = 0;
    if (snapshot.data.studentList != null) {
      studentListLength = snapshot.data.studentList.length;
    }

    Widget studentText = Text('${studentListLength} Student(s)',
        style: kCoachStudentLabelTextStyle);

    if (hasFaci) {
      Widget sizedBox1 = SizedBox(
        height: 1.5.h,
      );
      Widget text = Text('Facilitator', style: kCoachStudentLabelTextStyle);
      Widget container = Container(
          child: Card(
        child: Center(
          child: ListTile(
            title: Text(facilitatorName, style: kListItemsTextStyle),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Color(0xFF8A1501),
              ),
              onTap: () {
                if (facilitatorName != '') {
                  String message =
                      'Are you sure you want to remove $facilitatorName from this class?';
                  PopUpDialogClass.popUpDialog(message, context, () {
                    Navigator.of(context, rootNavigator: true).pop();
                    callDeleteFunc(facilitatorId, 'facilitator');
                  }, () {
                    Navigator.of(context, rootNavigator: true).pop();
                  });
                }
              },
            ),
            onTap: () {
              if (facilitatorId != '') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SpecificCoachProfile(
                              coachId: snapshot.data.facilitator.facilitatorId,
                            )));
              }
            },
          ),
        ),
      ));
      return [sizedBox1, text, container, sizedBox2, studentText];
    } else {
      return [sizedBox2, studentText];
    }
  }
}

Widget coachBuildBottomSheet(BuildContext context) {
  String identifier = 'Coach';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AssignCoachStudentBottomSheet(
        identifier: identifier,
        classId: globalClassId,
        franchiseId: franchiseId,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}

Widget facilitatorBuildBottomSheet(BuildContext context) {
  String identifier = 'Facilitator';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AssignCoachStudentBottomSheet(
        identifier: identifier,
        classId: globalClassId,
        franchiseId: franchiseId,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
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
        classId: globalClassId,
        franchiseId: franchiseId,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}
