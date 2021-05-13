import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/screens/leaderboard.dart';
import 'level_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'coachesCategory.dart';
//🥇
//🥈
//🥉
final _auth = FirebaseAuth.instance;
String targetAdminId;
String targetFranchiseId;

class CoachFranchiseCategory extends StatefulWidget {


  static const String id = '/coachFranchiseCategory';

  List<String> classes = ['🔴 Elite', '🟠 Diamond', '🟡 Ruby', '🟢 Platinum', '🟣 Gold', '🔵 Silver', '🟤 Bronze', '🏆 Overall'];

  @override
  _CoachFranchiseCategoryState createState() => _CoachFranchiseCategoryState();
}

class _CoachFranchiseCategoryState extends State<CoachFranchiseCategory> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    targetAdminId = _auth.currentUser.uid;
    getCoach();
    print(targetAdminId);
    print(targetFranchiseId);

    return Scaffold(
      appBar: AppBar(
          title: Text('Select Class Speaker Category')),
      backgroundColor: Color(0xFFDB5D38),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // wrap the icon in a circle avatar
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.list,
                  size: 30.0,
                  color: Color(0xFF8A1501),),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Please select which class speaker you want to view: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0
                ),
              ),
            ],
          ),
        ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // container must have a child to get shown up on screen
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                  )
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.classes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: ListTile(
                        title: Text(
                          widget.classes[index],
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap:() {
                          switch (index){
                            case 0:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 4000,maxMark: 100000)));
                              break;
                            case 1:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 3000,maxMark: 4000)));
                              break;
                            case 2:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 2000,maxMark: 3000)));
                              break;
                            case 3:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 1500,maxMark: 2000)));
                              break;
                            case 4:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 1000,maxMark: 1500)));
                              break;
                            case 5:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 500,maxMark: 1000)));
                              break;
                            case 6:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 0,maxMark: 500)));
                              break;
                            case 7:
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => coachesCategory(minMark: 0,maxMark: 100000)));
                              break;
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Coach> getCoach() async {
    await _firestore.collection('coaches')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      targetFranchiseId = data['franchiseId'];
      print("hahahhah");
      print(targetFranchiseId);
    });
  }



}