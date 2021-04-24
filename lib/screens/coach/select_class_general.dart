import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/award_exp.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:mahathir_academy_app/screens/coach/view_students.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

// FIXED COACH ID
String targetCoachId = "001";

class SelectClassGeneral extends StatefulWidget {

  static const String id = '/selectClassGeneral';
  // List<String> classes = ['Class1', 'Class2', 'Class3'];

  String textForDisplay;
  String selectedClass;

  SelectClassGeneral({this.textForDisplay});

  @override
  _SelectClassGeneralState createState() => _SelectClassGeneralState();

  Future retrievedClassNames;
}

class _SelectClassGeneralState extends State<SelectClassGeneral> {

  bool showSpinner = false; // to figure out when should our spinner spins

  @override
  void initState() {
    widget.retrievedClassNames = callFunc();
  }

  @override
  Widget build(BuildContext context) {
    String classContentTitle = widget.textForDisplay;
    return SelectClassTemplate(
      myFab: null,
      textForDisplay: classContentTitle,
      classItemBuilder: (context, index) {
        return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  child: Center(
                    child: ListTile(
                        title: Text(snapshot.data[index], style: kListItemsTextStyle),
                        onTap: (){
                          print('contentTitle');
                          print(snapshot.data[index]);
                      Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => AwardExp(
                    contentTitle: snapshot.data[index]
                    ),
                    ));
                    },
                  ),
                ),
              );
              }
              else{
                print('error1');
                return Center(child: CircularProgressIndicator());
              }
            },
            future: widget.retrievedClassNames);
      },
    );
  }

  Future<List<String>> classData() async {
    List <String> classIds = [];
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
      await _firestore.collection('classes')
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

  callFunc() async{
    return await classData();
  }

}
