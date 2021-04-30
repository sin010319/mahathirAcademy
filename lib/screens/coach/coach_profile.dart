import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/profile_menu.dart';
import 'package:mahathir_academy_app/components/profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahathir_academy_app/models/coach.dart';

import '../login_screen.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String coachName;
String franchiseName;
List<dynamic> listClassNames = [];
List<dynamic> classIds = [];
String documentId;

class CoachProfile extends StatefulWidget {
  static String id = "/coachProfile";
  Future coachInfo;

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> {
  String message = "You have successfully logged out.";

  @override
  void initState() {
    documentId = _auth.currentUser.uid;
    widget.coachInfo = callCoachFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: FutureBuilder(
          future: widget.coachInfo,
    builder: (context, snapshot) {
      if (snapshot.hasData){
        print(snapshot.data);
      return Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Name: ${snapshot.data.coachName}",
            icon: "assets/icons/userIcon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Franchise: ${snapshot.data.franchiseName}",
            icon: "assets/icons/school.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Class: ${snapshot.data.classNames}",
            icon: "assets/icons/class.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/logOut.svg",
            press: () {
              popUpDialog(context);
            },
          )
        ],
      );}
      else{
        print('error3');
        return Center(child: CircularProgressIndicator());
      }
    }),
        ));
  }

  popUpDialog(BuildContext context) {
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
                      Text('Are you sure you want to log out?'),
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
    double _width = MediaQuery
        .of(context)
        .size
        .width;

    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if (text == 'Yes') {
          logout();
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

  Future<Coach> getCoach() async {
    await _firestore.collection('coaches')
        .doc(documentId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      coachName = data['coachName'];
      franchiseName = data['franchiseName'];
      classIds = data['classIds'];
    });

    listClassNames = [];

    for (var eachClassId in classIds) {
      await _firestore.collection('classes')
          .where('classId', isEqualTo: eachClassId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print('hey');
          listClassNames.add(doc['className']);
        });
      });
    }
    Coach coach = Coach(coachName, classIds, franchiseName, listClassNames);
    return coach;
  }

  Future callCoachFunc() async {
    return await getCoach();
  }

  logout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

}


