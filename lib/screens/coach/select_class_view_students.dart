import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/screens/coach/award_exp.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:mahathir_academy_app/screens/coach/view_students.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/template/select_class_template_fixed.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
List<dynamic> listClassNames;
String targetCoachId;

class SelectClassViewStudents extends StatefulWidget {
  static const String id = '/selectClassViewStudents';
  // List<String> classes = ['Class1', 'Class2', 'Class3'];

  String textForDisplay;
  String selectedClass;

  SelectClassViewStudents({this.textForDisplay});

  @override
  _SelectClassViewStudentsState createState() =>
      _SelectClassViewStudentsState();

  Future retrievedClassNames;
}

class _SelectClassViewStudentsState extends State<SelectClassViewStudents> {
  bool showSpinner = false; // to figure out when should our spinner spins

  @override
  void initState() {
    targetCoachId = _auth.currentUser.uid;
    widget.retrievedClassNames = callFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String classContentTitle = widget.textForDisplay;
    return SelectClassTemplateFixed(
        myFab: null,
        textForDisplay: classContentTitle,
        classItemBuilder: FutureBuilder(
            future: widget.retrievedClassNames,
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
                              title: Text(snapshot.data[index],
                                  style: kListItemsTextStyle),
                              onTap: () {
                                print('contentTitle');
                                print(snapshot.data[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewStudents(
                                          contentTitle: snapshot.data[index]),
                                    ));
                              },
                            )),
                          );
                        })
                  ],
                ),
              );
            }));
  }

  Future<List<String>> classData() async {
    List<String> classIds = [];
    List<String> listClassNames = [];

    await _firestore
        .collection('coaches')
        .where('coachId', isEqualTo: targetCoachId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        for (String eachId in doc['classIds']) {
          classIds.add(eachId);
        }
      });
    });

    for (var eachClassId in classIds) {
      await _firestore
          .collection('classes')
          .where('classId', isEqualTo: eachClassId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          listClassNames.add(doc['className']);
        });
      });
    }
    print(listClassNames);
    return listClassNames;
  }

  callFunc() async {
    return await classData();
  }
}
