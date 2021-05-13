import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/models/class.dart';
import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/models/facilitator.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile_specific.dart';
import 'package:mahathir_academy_app/screens/student/student_profile_specific.dart';
import 'amend_exp.dart';
import '../../student/student_profile.dart';
import 'assign_coach_add_students_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        animatedIconTheme: IconThemeData(size: 22, color: Colors.white),
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
              label: 'Add Coach',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
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
              label: 'Add Facilitator',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFFFF3700)),
          // FAB 3
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.peopleArrows, color: Colors.white),
              backgroundColor: Color(0xFFC61F00),
              onTap: () {
                setState(() {
                  // do smt
                });
              },
              label: 'Upgrade Facilitator',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFFFF3700)),
          // FAB 3
          SpeedDialChild(
              child: Icon(Icons.person_add_alt_1, color: Colors.white),
              backgroundColor: Color(0xFFC61F00),
              onTap: () {
                setState(() {
                  showModal(studentBuildBottomSheet);
                });
              },
              label: 'Add Student',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFFFF3700)),
        ],
      ),
      appBar: AppBar(title: Text('View Coach and Students')),
      backgroundColor: Color(0xFFDB5D38),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // wrap the icon in a circle avatar
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage("assets/icons/presentation.png"),
                    radius: 30.0,
                  ),
                  SizedBox(
                    height: 10.0,
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
                              fontSize: 18.0),
                        );
                      }),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // container must have a child to get shown up on screen
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: SingleChildScrollView(
                child: returnFutureBuilder(),
              ),
            ))
          ]),
    );
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
            height: 20,
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
                    if (coachName != "") {
                      deleteDialog(context, coachName);
                    }
                  },
                ),
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
                                  spacing: 8,
                                  children: [
                                    Container(
                                        child: Text(student.exp.toString(),
                                            style: kExpTextStyle)),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.edit,
                                        color: Color(0xFF8A1501),
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            // builder here needs a method to return widget
                                            builder: amendExpBuildBottomSheet,
                                            isScrollControlled:
                                                true // enable the modal take up the full screen
                                            );
                                      },
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.delete,
                                        color: Color(0xFF8A1501),
                                      ),
                                      onTap: () {
                                        deleteDialog(
                                            context, student.studentName);
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
        print('hey');
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
}

dynamic returnFaciSection(
    bool hasFaci, BuildContext context, AsyncSnapshot snapshot) {
  Widget sizedBox2 = SizedBox(
    height: 15.0,
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
      height: 15.0,
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
                deleteDialog(
                    context, snapshot.data.facilitator.facilitatorName);
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

deleteDialog(BuildContext context, String itemRemoved) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Icon(Icons.close)),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Are you sure you want to remove $itemRemoved?',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        button('Yes', context),
                        button('No', context),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

Widget button(String text, BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;

  return RaisedButton(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    onPressed: () {
      if (text == 'Yes') {
        // do something
      } else if (text == 'No') {
        Navigator.of(context, rootNavigator: true).pop();
      }
    },
    textColor: Colors.white,
    padding: EdgeInsets.all(0.0),
    child: Container(
      alignment: Alignment.center,
      width: _width / 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: <Color>[Colors.orange[200], Colors.pinkAccent],
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Text(text, style: TextStyle(fontSize: 15)),
    ),
  );
}

Widget coachBuildBottomSheet(BuildContext context) {
  String identifier = 'Coach';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddCoachStudentBottomSheet(
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
      child: AddCoachStudentBottomSheet(
        identifier: identifier,
        classId: globalClassId,
        franchiseId: franchiseId,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}

Widget studentBuildBottomSheet(BuildContext context) {
  String identifier = 'Student';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddCoachStudentBottomSheet(
        identifier: identifier,
        classId: globalClassId,
        franchiseId: franchiseId,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}

Widget amendExpBuildBottomSheet(BuildContext context) {
  String identifier = 'Amend EXP';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AmendExpScreen(identifier: identifier),
    ),
  );
}
