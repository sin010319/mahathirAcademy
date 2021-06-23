import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/template/select_view_template_fixed.dart';
import 'edit_admin_bottomSheet.dart';
import 'add_admin_bottomSheet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String franchiseId;
String adminEmail = "";
String contactNum = "";
String adminName = "";
String username = "";
String adminId = "";

class ViewAdminScreen extends StatefulWidget {
  static const String id = '/addAdmin';
  String franchiseName = 'Franchise 1';
  String franchiseLocation = 'Location1';
  String franchiseAdmin = 'admin1';
  Map<String, String> adminInfo = {
    'Name': '',
    'Username': '',
    'Email': '',
    'Contact Number': ''
  };

  Franchise franchiseInfo;

  ViewAdminScreen({this.franchiseInfo});

  @override
  _ViewAdminScreenState createState() => _ViewAdminScreenState();

  Future retrievedFranchiseAdmin;
}

class _ViewAdminScreenState extends State<ViewAdminScreen> {
  @override
  void initState() {
    adminEmail = "";
    contactNum = "";
    adminName = "";
    username = "";
    adminId = "";
    franchiseId = widget.franchiseInfo.franchiseId;
    widget.retrievedFranchiseAdmin = callFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String adminAppBarTitle = 'Franchise Admin';
    String adminImageIconLocation = 'assets/icons/admin.png';
    String adminContentTitle =
        '${widget.franchiseInfo.franchiseName} \n${widget.franchiseInfo.franchiseLocation}';
    int adminInfoItemLength = widget.adminInfo.length;

    CollectionReference franchiseAdmins =
        FirebaseFirestore.instance.collection('franchiseAdmins');
    CollectionReference franchises = _firestore.collection('franchises');
    CollectionReference coaches = _firestore.collection('coaches');
    CollectionReference students = _firestore.collection('students');

    Future<void> removeFranchiseAdmin(String adminIdForDelete) async {
      return franchiseAdmins
          .doc(adminIdForDelete)
          .delete()
          .then((value) => print("Franchise Admin Removed"))
          .catchError((error) => print("Failed to remove franchise: $error"));
    }

    Future<void> updateData(String adminIdForDelete) async {
      WriteBatch batch = _firestore.batch();

      await coaches
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference, {"franchiseAdminName": ""});
          print('can update franchiseAdminName for coach');
        });
      });

      await students
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference, {"franchiseAdminName": ""});
          print('can update franchiseAdminName for student');
        });
      });

      await franchises
          .where('franchiseId', isEqualTo: franchiseId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          batch.update(doc.reference,
              {"franchiseAdminName": "", "franchiseAdminId": ""});
          print('can update franchiseAdminName for franchise');
        });
      });

      return batch.commit();
    }

    Future<void> callDeleteFunc(String adminIdForDelete) async {
      await removeFranchiseAdmin(adminIdForDelete);
      await updateData(adminIdForDelete);
      String franchiseDeletedMsg =
          'You have successfully removed a franchise admin.';
      await PopUpAlertClass.popUpAlert(franchiseDeletedMsg, context);
      Future.delayed(Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      });
    }

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
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  if (adminName == "") {
                    showModal(addAdminBuildBottomSheet);
                  } else {
                    String message =
                        'Each franchise is limited to only 1 franchise admin. You may delete the current franchise admin to add a new one or choose to edit the current admin info.';
                    PopUpAlertClass.popUpAlert(message, context);
                  }
                },
                label: 'Add Admin',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 11.0.sp),
                labelBackgroundColor: Color(0xFFFF3700)),
            // FAB 2
            SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  if (adminName != "") {
                    showModal(editAdminBuildBottomSheet);
                  } else {
                    String message =
                        'There is no available admin for modification for this franchise.';
                    PopUpAlertClass.popUpAlert(message, context);
                  }
                },
                label: 'Edit Admin Info',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 11.0.sp),
                labelBackgroundColor: Color(0xFFFF3700)),
            SpeedDialChild(
                child: Icon(Icons.delete, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  if (adminName != "") {
                    String message =
                        'Are you sure you want to completely delete the admin info completely from the franchise?';
                    PopUpDialogClass.popUpDialog(message, context, () {
                      Navigator.of(context, rootNavigator: true).pop();
                      callDeleteFunc(adminId);
                    }, () {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  } else {
                    String message =
                        'There is no available admin to be removed for this franchise.';
                    PopUpAlertClass.popUpAlert(message, context);
                  }
                },
                label: 'Delete Admin',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 11.0.sp),
                labelBackgroundColor: Color(0xFFFF3700)),
          ],
        ),
        body: SelectViewTemplateFixed(
            appBarTitle: adminAppBarTitle,
            imageIconLocation: adminImageIconLocation,
            contentTitle: adminContentTitle,
            myFutureBuilder: FutureBuilder(
                future: widget.retrievedFranchiseAdmin,
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
                            itemCount: adminInfoItemLength,
                            itemBuilder: (context, index) {
                              String key =
                                  widget.adminInfo.keys.elementAt(index);
                              return Card(
                                child: Center(
                                    child: ListTile(
                                  title: Text(key),
                                  subtitle: Text('${widget.adminInfo[key]}'),
                                )),
                              );
                            })
                      ],
                    ),
                  );
                })));
  }

  Future<void> AdminData() async {
    await _firestore
        .collection('franchiseAdmins')
        .where('franchiseId', isEqualTo: franchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        adminId = doc['franchiseAdminId'];
        adminEmail = doc['adminEmail'];
        username = doc['username'];
        contactNum = doc['contactNum'];
        adminName = doc['franchiseAdminName'];
      });

      widget.adminInfo['Name'] = adminName;
      widget.adminInfo['Email'] = adminEmail;
      widget.adminInfo['Contact Number'] = contactNum;
      widget.adminInfo['Username'] = username;
    });
  }

  Future callFunc() async {
    return await AdminData();
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

  Widget editAdminBuildBottomSheet(BuildContext context) {
    String identifier = 'Amend Admin Info';

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
        child: EditAdminBottomSheet(
            identifier: identifier,
            franchiseId: franchiseId,
            adminId: adminId,
            adminName: adminName,
            adminEmail: adminEmail,
            contactNum: contactNum),
      ),
    );
  }

  Widget addAdminBuildBottomSheet(BuildContext context) {
    String identifier = 'Admin';

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
        child: AddAdminBottomSheet(
            identifier: identifier, franchiseInfo: widget.franchiseInfo),
      ),
    );
  }
}
