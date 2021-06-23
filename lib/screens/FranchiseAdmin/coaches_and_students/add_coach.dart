import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile_specific.dart';
import 'package:mahathir_academy_app/template/select_coach_template.dart';
import 'add_coach_bottomSheet.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;
String franchiseId;
String franchiseLocation;
String franchiseName;
String franchiseAdminName;

class AddCoachScreen extends StatefulWidget {
  static const String id = '/addCoach';

  @override
  _AddCoachScreenState createState() => _AddCoachScreenState();

  Future retrievedCoaches;
}

class _AddCoachScreenState extends State<AddCoachScreen> {
  @override
  void initState() {
    targetAdminId = _auth.currentUser.uid;
    widget.retrievedCoaches = callFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectCoachTemplate(
        myFab: FloatingActionButton(
          onPressed: () {
            showModal();
          },
          backgroundColor: Color(0xFF8A1501),
          child: Icon(Icons.add),
        ),
        coachContentTitleBuilder: FutureBuilder(
            future: widget.retrievedCoaches,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError) {
                print('error3');
                return Container();
              }
              return Text(
                '${snapshot.data[0]} \n${snapshot.data[1].length} coaches',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5.sp),
              );
            }),
        myFutureBuilder: FutureBuilder(
            future: widget.retrievedCoaches,
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
                      itemCount: snapshot.data[1].length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Center(
                              child: ListTile(
                                  title:
                                      Text(snapshot.data[1][index].coachName),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SpecificCoachProfile(
                                            coachId:
                                                snapshot.data[1][index].coachId,
                                          ),
                                        ));
                                  })),
                        );
                      }),
                ]),
              );
            }));
  }

  void showModal() {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: coachBuildBottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    print('modal closed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  Future<List<dynamic>> coachData() async {
    String coachId;
    String coachName;
    List<Coach> coachList = [];

    await _firestore
        .collection('franchiseAdmins')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      franchiseAdminName = data['franchiseAdminName'];
      franchiseId = data['franchiseId'];
      franchiseLocation = data['franchiseLocation'];
      franchiseName = data['franchiseName'];
    });

    await _firestore
        .collection('coaches')
        .where('franchiseId', isEqualTo: franchiseId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        coachName = doc["coachName"];
        coachId = doc["coachId"];
        Coach newCoach = Coach.viewCoach(coachName, coachId, franchiseName);
        coachList.add(newCoach);
      });
    });

    return [franchiseName, coachList];
  }

  Future callFunc() async {
    return await coachData();
  }
}

Widget coachBuildBottomSheet(BuildContext context) {
  String identifier = 'Coach';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddCoachBottomSheet(
        identifier: identifier,
        franchiseId: franchiseId,
        franchiseAdminName: franchiseAdminName,
        title1: franchiseName,
        title2: franchiseLocation,
      ),
    ),
  );
}
