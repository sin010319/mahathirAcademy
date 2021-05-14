import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/models/class.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/InactiveClassScreen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/view_coaches_students.dart';
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
String franchiseName;
String franchiseLocation;
String selectedClassId = '';
String selectedClassName = '';

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
    CollectionReference franchises =
        FirebaseFirestore.instance.collection('franchises');
    CollectionReference students =
        FirebaseFirestore.instance.collection('students');
    CollectionReference classes =
        FirebaseFirestore.instance.collection('classes');
    CollectionReference coaches =
        FirebaseFirestore.instance.collection('coaches');

    Future<void> removeClass(String classIdForDelete) async {
      return classes
          .doc(classIdForDelete)
          .delete()
          .then((value) => print("Class Removed"))
          .catchError((error) => print("Failed to remove franchise: $error"));
    }

    Future<void> removeData(String classIdForDelete) async {
      await franchises
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "classIds": FieldValue.arrayRemove([classIdForDelete])
          });
        });
      });

      List<dynamic> targetStudentIds = [];

      await students
          .where('classIds', arrayContains: classIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          targetStudentIds.add(doc['studentId']);
          doc.reference.update({
            "classIds": FieldValue.arrayRemove([classIdForDelete])
          });
        });
      });

      await coaches
          .where('classIds', arrayContains: classIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "classIds": FieldValue.arrayRemove([classIdForDelete])
          });
        });
      });

      for (var studentId in targetStudentIds) {
        List<dynamic> classIds = [];

        await _firestore
            .collection('students')
            .doc(studentId)
            .get()
            .then((value) {
          Map<String, dynamic> data = value.data();
          classIds = data['classIds'];
        });

        if (classIds.length == 0) {
          await students
              .where('studentId', isEqualTo: studentId)
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
              "studentIds": FieldValue.arrayUnion([studentId])
            });
          });
        });
      }
    }

    Future<void> callDeleteFunc(String classIdForDelete) async {
      await removeData(classIdForDelete);
      await removeClass(classIdForDelete);
      String franchiseDeletedMsg = 'You have successfully removed a class.';
      await PopUpAlertClass.popUpAlert(franchiseDeletedMsg, context);
      Future.delayed(Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      });
    }

    return SelectClassTemplate(
        myFab: FloatingActionButton(
          onPressed: () {
            showModal(addClassBuildBottomSheet);
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
                                  title: Text(snapshot.data[index].className),
                                  trailing: Wrap(
                                      spacing: 8,
                                      children: snapshot
                                                  .data[index].className !=
                                              'INACTIVE'
                                          ? [
                                              GestureDetector(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Color(0xFF8A1501),
                                                ),
                                                onTap: () {
                                                  selectedClassId = snapshot
                                                      .data[index].classId;
                                                  selectedClassName = snapshot
                                                      .data[index].className;

                                                  showModal(
                                                      editClassBuildBottomSheet);
                                                },
                                              ),
                                              GestureDetector(
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Color(0xFF8A1501),
                                                ),
                                                onTap: () {
                                                  String message =
                                                      'Are you sure you want to remove ${snapshot.data[index].className}?';
                                                  PopUpDialogClass.popUpDialog(
                                                      message, context, () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                    callDeleteFunc(snapshot
                                                        .data[index].classId);
                                                  }, () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  });
                                                },
                                              ),
                                            ]
                                          : []),
                                  onTap: () {
                                    if (snapshot.data[index].classId !=
                                        'INACTIVE') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewCoachStudent(
                                                    classId: snapshot
                                                        .data[index].classId),
                                          ));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                InactiveClassScreen(
                                                    franchiseId: franchiseId),
                                          ));
                                    }
                                  })),
                        );
                      }),
                ]),
              );
            }));
  }

  Future<List<Class>> classData() async {
    String className;
    List<Class> classList = [];
    List<dynamic> classIds = [];
    String classId;

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
        .collection('franchises')
        .doc(franchiseId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      classIds = data['classIds'];
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

    await _firestore
        .collection('classes')
        .where('classId', isEqualTo: 'INACTIVE')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        className = doc['className'];
        classId = doc['classId'];
        Class newClass = Class(className, classId);
        classList.add(newClass);
      });
    });

    return classList;
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

Widget editClassBuildBottomSheet(BuildContext context) {
  String identifier = 'Amend Class';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: EditClassBottomSheet(
        identifier: identifier,
        className: selectedClassName,
        classId: selectedClassId,
        franchiseLocation: franchiseLocation,
        franchiseName: franchiseName,
      ),
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
