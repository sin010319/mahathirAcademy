import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/template/select_class_template_fixed.dart';
import 'package:firebase_auth/firebase_auth.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
List<dynamic> listClassNames;
String targetCoachId;

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
                                    onTap: widget.classFunction)),
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
        for (String eachId in doc["classIds"]) {
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
