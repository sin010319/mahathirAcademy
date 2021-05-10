import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/models/class.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/view_coaches_students.dart';
import 'package:mahathir_academy_app/screens/leaderboard.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'edit_class_bottomSheet.dart';
import 'add_class_bottomSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;
String franchiseId;

class ViewClassScreen extends StatefulWidget {
  static const String id = '/addClass';
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  @override
  _ViewClassScreenState createState() => _ViewClassScreenState();

  Future retrievedClassNames;
}

class _ViewClassScreenState extends State<ViewClassScreen> {
  @override
  void initState() {
    targetAdminId = _auth.currentUser.uid;
    widget.retrievedClassNames = callFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectClassTemplate(
        myFab: FloatingActionButton(
          onPressed: () {
            showModal();
          },
          backgroundColor: Color(0xFF8A1501),
          child: Icon(Icons.add),
        ),
        classContentTitle: FutureBuilder(
            future: widget.retrievedClassNames,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError) {
                print('error3');
                return Container();
              }
              return Text(
                '${snapshot.data.length} classes',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0),
              );
            }),
        classItemBuilder: FutureBuilder(
            future: widget.retrievedClassNames,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError) {
                print('error3');
                return Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Center(
                            child: ListTile(
                                title: Text(snapshot.data[index].className),
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        Icons.edit,
                                        color: Color(0xFF8A1501),
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            // builder here needs a method to return widget
                                            builder: editClassBuildBottomSheet,
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
                                        deleteDialog(context,
                                            snapshot.data[index].className);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewCoachStudent(
                                            classId:
                                                snapshot.data[index].classId),
                                      ));
                                })),
                      );
                    }),
              );
            }));
  }

  Future<List<Class>> classData() async {
    String className;
    List<Class> classList = [];
    List<dynamic> classIds = [];

    await _firestore
        .collection('franchiseAdmins')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      classIds = data['classIds'];
      franchiseId = data['franchiseId'];
    });

    for (int i = 0; i < classIds.length; i++) {
      await _firestore
          .collection('classes')
          .where('classId', isEqualTo: classIds[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          className = doc['className'];
          Class newClass = Class(className, classIds[i]);
          classList.add(newClass);
        });
      });
    }
    return classList;
  }

  void showModal() {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: addClassBuildBottomSheet,
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

Widget editClassBuildBottomSheet(BuildContext context) {
  String identifier = 'Amend Class';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: EditClassBottomSheet(identifier: identifier),
    ),
  );
}

Widget addClassBuildBottomSheet(BuildContext context) {
  String identifier = 'Class';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddClassBottomSheet(
        identifier: identifier,
        franchiseId: franchiseId,
        franchiseAdminId: targetAdminId,
      ),
    ),
  );
}
