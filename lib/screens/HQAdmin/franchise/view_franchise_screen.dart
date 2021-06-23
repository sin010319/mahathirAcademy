import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/template/select_franchise_template_fixed.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;
String selectedFranchiseId;
String selectedFranchiseLocation;
String selectedFranchiseName;

class ViewFranchiseScreen extends StatefulWidget {
  static const String id = '/addFranchise';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _ViewFranchiseScreenState createState() => _ViewFranchiseScreenState();

  Future retrievedFranchises;
}

class _ViewFranchiseScreenState extends State<ViewFranchiseScreen> {
  @override
  void initState() {
    targetAdminId = _auth.currentUser.uid;
    widget.retrievedFranchises = callFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference franchiseAdmins =
        FirebaseFirestore.instance.collection('franchiseAdmins');
    CollectionReference franchises =
        FirebaseFirestore.instance.collection('franchises');
    CollectionReference students =
        FirebaseFirestore.instance.collection('students');
    CollectionReference classes =
        FirebaseFirestore.instance.collection('classes');
    CollectionReference coaches =
        FirebaseFirestore.instance.collection('coaches');

    Future<void> removeFranchise(String franchiseIdForDelete) async {
      return franchises
          .doc(franchiseIdForDelete)
          .delete()
          .then((value) => print("Franchise Removed"))
          .catchError((error) => print("Failed to remove franchise: $error"));
    }

    Future<void> removeData(String franchiseIdForDelete) async {
      List<dynamic> studentIds = [];

      dynamic classIdsForDelete = [];

      await franchises
          .where('franchiseId', isEqualTo: franchiseIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          classIdsForDelete = doc['classIds'];
        });
      });

      for (dynamic classId in classIdsForDelete) {
        await classes
            .where('classId', isEqualTo: classId)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
      }

      await franchiseAdmins
          .where('franchiseId', isEqualTo: franchiseIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      await students
          .where('franchiseId', isEqualTo: franchiseIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          studentIds.add(doc['studentId']);
          doc.reference.delete();
        });
      });

      await coaches
          .where('franchiseId', isEqualTo: franchiseIdForDelete)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      for (var studentId in studentIds) {
        await classes
            .where('classId', isEqualTo: 'INACTIVE')
            .where('studentIds', arrayContains: studentId)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              "studentIds": FieldValue.arrayRemove([studentId])
            });
          });
        });
      }
    }

    Future<void> callDeleteFunc(String franchiseIdForDelete) async {
      await removeData(franchiseIdForDelete);
      await removeFranchise(franchiseIdForDelete);
      String franchiseDeletedMsg = 'You have successfully removed a franchise.';
      await PopUpAlertClass.popUpAlert(franchiseDeletedMsg, context);
      Future.delayed(Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      });
    }

    return SelectFranchiseTemplateFixed(
        franchiseFab: FloatingActionButton(
          onPressed: () {
            showModal(addFranchiseBuildBottomSheet);
          },
          backgroundColor: Color(0xFF8A1501),
          child: Icon(Icons.add),
        ),
        franchiseContentTitle:
            'Please select a franchise to view or modify admin info:',
        franchiseItemBuilder: FutureBuilder(
            future: widget.retrievedFranchises,
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
                                    title: Text(
                                        snapshot.data[index].franchiseName),
                                    trailing: Wrap(
                                      spacing: 8.sp,
                                      children: [
                                        GestureDetector(
                                          child: Icon(
                                            Icons.edit,
                                            color: Color(0xFF8A1501),
                                          ),
                                          onTap: () {
                                            selectedFranchiseId = snapshot
                                                .data[index].franchiseId;
                                            selectedFranchiseLocation = snapshot
                                                .data[index].franchiseLocation;
                                            selectedFranchiseName = snapshot
                                                .data[index].franchiseName;
                                            showModal(
                                                editFranchiseBuildBottomSheet);
                                          },
                                        ),
                                        GestureDetector(
                                          child: Icon(
                                            Icons.delete,
                                            color: Color(0xFF8A1501),
                                          ),
                                          onTap: () {
                                            String message =
                                                'Are you sure you want to remove ${snapshot.data[index].franchiseName}? Note that when you remove this franchise, all the classes, students and coaches who are still under this franchise will be removed.';
                                            PopUpDialogClass.popUpDialog(
                                                message, context, () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              callDeleteFunc(snapshot
                                                  .data[index].franchiseId);
                                            }, () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAdminScreen(
                                              franchiseInfo:
                                                  snapshot.data[index],
                                            ),
                                          ));
                                    })),
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

  Future<List<Franchise>> franchiseData() async {
    String franchiseId;
    String franchiseName;
    String franchiseLocation;
    List<Franchise> franchisesList = [];

    await _firestore
        .collection('franchises')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        franchiseName = doc["franchiseName"];
        franchiseId = doc["franchiseId"];
        franchiseLocation = doc["franchiseLocation"];
        Franchise newFranchise =
            Franchise(franchiseName, franchiseLocation, franchiseId);
        franchisesList.add(newFranchise);
      });
    });

    return franchisesList;
  }

  Future callFunc() async {
    return await franchiseData();
  }
}

Widget editFranchiseBuildBottomSheet(BuildContext context) {
  String identifier = 'Amend Franchise';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: EditFranchiseBottomSheet(
        identifier: identifier,
        franchiseName: selectedFranchiseName,
        franchiseLocation: selectedFranchiseLocation,
        franchiseId: selectedFranchiseId,
      ),
    ),
  );
}

Widget addFranchiseBuildBottomSheet(BuildContext context) {
  String identifier = 'Franchise';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddFranchiseBottomSheet(identifier: identifier),
    ),
  );
}
