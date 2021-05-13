import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/template/select_franchise_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/template/select_franchise_template_fixed.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;

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
    Future<void> removeFranchises(String franchiseIdForDelete) async {
      CollectionReference franchises =
          FirebaseFirestore.instance.collection('franchises');

      return franchises
          .doc(franchiseIdForDelete)
          .delete()
          .then((value) => print("Franchise Removed"))
          .catchError((error) => print("Failed to remove franchise: $error"));
    }

    Future<void> removeData(String franchiseIdForDelete) async {
      CollectionReference franchiseAdmins =
          FirebaseFirestore.instance.collection('franchiseAdmins');
      CollectionReference students =
          FirebaseFirestore.instance.collection('students');
      CollectionReference classes =
          FirebaseFirestore.instance.collection('classes');
      CollectionReference coaches =
          FirebaseFirestore.instance.collection('coaches');

      dynamic classIdsForDelete = [];

      await franchiseAdmins
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
    }

    Future<void> callDeleteFunc(String franchiseIdForDelete) async {
      await removeFranchises(franchiseIdForDelete);
      await removeData(franchiseIdForDelete);
      String franchiseDeletedMsg =
          'You have successfully removed a franchise. Please close this page to view the newly updated franchises.';
      await PopUpAlertClass.popUpAlert(franchiseDeletedMsg, context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    }

    return SelectCoachTemplate(
        franchiseFab: FloatingActionButton(
          onPressed: () {
            showModal();
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
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Center(
                            child: ListTile(
                                title: Text(snapshot.data[index].franchiseName),
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
                                            builder:
                                                editFranchiseBuildBottomSheet,
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
                                        String message =
                                            'Are you sure you want to remove ${snapshot.data[index].franchiseName}? Note that when you remove this franchise, all the classes, students and coaches who are still under this franchise will be removed';
                                        PopUpDialogClass.popUpDialog(
                                            message, context, () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          callDeleteFunc(
                                              snapshot.data[index].franchiseId);
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
                                        builder: (context) => ViewAdminScreen(
                                          franchiseInfo: snapshot.data[index],
                                        ),
                                      ));
                                })),
                      );
                    }),
              );
            }));
  }

  void showModal() {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: addFranchiseBuildBottomSheet,
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
      child: EditFranchiseBottomSheet(identifier: identifier),
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
