import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/template/franchiseCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:sizer/sizer.dart';

final _auth = FirebaseAuth.instance;
String targetAdminId;
String targetFranchiseId;

class FranchiseBasedCategory extends StatefulWidget {
  static const String id = '/franchiseBasedCategory';

  List<String> classes = [
    '🔴  Elite',
    '🟠  Diamond',
    '🟡  Ruby',
    '🟢  Platinum',
    '🔵  Gold',
    '⚪  Silver',
    '🟤  Bronze',
    '🏆 Overall'
  ];

  @override
  _FranchiseBasedCategoryState createState() => _FranchiseBasedCategoryState();
}

class _FranchiseBasedCategoryState extends State<FranchiseBasedCategory> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    targetAdminId = _auth.currentUser.uid;
    getFranchiseAdmin();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Row(
            children: [
              Image.asset("assets/images/brand_logo.png",
                  fit: BoxFit.contain, height: 5.5.h),
              SizedBox(
                width: 1.5.w,
              ),
              Flexible(
                child: Text('Select Speaker Category',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                    )),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFDB5D38),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // wrap the icon in a circle avatar
                CircleAvatar(
                  radius: 25.0.sp,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.list,
                    size: 30.0.sp,
                    color: Color(0xFF8A1501),
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Text(
                  'Please select which class speaker you want to view: ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5.sp),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              // container must have a child to get shown up on screen
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.sp),
                      topRight: Radius.circular(20.0.sp))),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.classes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: ListTile(
                        title: Text(
                          widget.classes[index],
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 4000, maxMark: 100000)));
                              break;
                            case 1:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 3000, maxMark: 4000)));
                              break;
                            case 2:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 2000, maxMark: 3000)));
                              break;
                            case 3:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 1500, maxMark: 2000)));
                              break;
                            case 4:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 1000, maxMark: 1500)));
                              break;
                            case 5:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 500, maxMark: 1000)));
                              break;
                            case 6:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 0, maxMark: 500)));
                              break;
                            case 7:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          franchiseCategory(
                                              minMark: 0, maxMark: 100000)));
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

  Future<Franchise> getFranchiseAdmin() async {
    await _firestore
        .collection('franchiseAdmins')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      targetFranchiseId = data['franchiseId'];
      print(targetFranchiseId);
    });
  }
}
