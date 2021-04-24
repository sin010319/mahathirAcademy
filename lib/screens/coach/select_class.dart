import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:mahathir_academy_app/screens/coach/view_students.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

// FIXED COACH ID
String targetCoachId = "001";

class SelectClass extends StatefulWidget {

  static const String id = '/selectClass';
  // List<String> classes = ['Class1', 'Class2', 'Class3'];

  String textForDisplay;
  Function classFunction;

  SelectClass({this.textForDisplay, this.classFunction});

  @override
  _SelectClassState createState() => _SelectClassState();

  Future retrievedClassNames;
}

class _SelectClassState extends State<SelectClass> {

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
                return Card(
                  child: Center(
                    child: ListTile(
                      title: FutureBuilder(
                    builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data[index], style: kListItemsTextStyle);
                }
                  else{
                    print('has error');
                    return Center(child: CircularProgressIndicator());
                }
                  },
                        future: widget.retrievedClassNames),
                      onTap: widget.classFunction
                    ),
                  ),
                );
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
        for (String eachId in doc["classIds"]) {
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
