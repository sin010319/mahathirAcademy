import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/models/admin.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/view_coaches_students.dart';
import 'package:mahathir_academy_app/screens/leaderboard.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:mahathir_academy_app/template/select_view_template_fixed.dart';
import 'edit_admin_bottomSheet.dart';
import 'add_admin_bottomSheet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String franchiseId;

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
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  // setState(() {
                  //   showModalBottomSheet(
                  //       context: context,
                  //       // builder here needs a method to return widget
                  //       builder: addAdminBuildBottomSheet,
                  //       isScrollControlled:
                  //           true // enable the modal take up the full screen
                  //       );
                  // });
                  showModal();
                },
                label: 'Add Admin',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFFFF3700)),
            // FAB 2
            SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  setState(() {
                    showModalBottomSheet(
                        context: context,
                        // builder here needs a method to return widget
                        builder: editAdminBuildBottomSheet,
                        isScrollControlled:
                            true // enable the modal take up the full screen
                        );
                  });
                },
                label: 'Edit Admin Info',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFFFF3700)),
            SpeedDialChild(
                child: Icon(Icons.delete, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  setState(() {
                    deleteDialog(context, widget.franchiseAdmin);
                  });
                },
                label: 'Delete Admin',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
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
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: adminInfoItemLength,
                      itemBuilder: (context, index) {
                        String key = widget.adminInfo.keys.elementAt(index);
                        return Card(
                          child: Center(
                              child: ListTile(
                            title: Text(key),
                            subtitle: Text('${widget.adminInfo[key]}'),
                          )),
                        );
                      });
                })));
  }

  Future<void> AdminData() async {
    String franchiseName = widget.franchiseInfo.franchiseName;
    String franchiseLocation = widget.franchiseInfo.franchiseLocation;
    List<Admin> adminList = [];
    String adminEmail = "";
    String contactNum = "";
    String adminName = "";
    String username = "";

    await _firestore
        .collection('franchiseAdmins')
        .where('franchiseId', isEqualTo: franchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
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

  void showModal() {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: addAdminBuildBottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    print('modal closed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
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

  Widget editAdminBuildBottomSheet(BuildContext context) {
    String identifier = 'Amend Admin Info';

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
        child: EditAdminBottomSheet(identifier: identifier),
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
