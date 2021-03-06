import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/screens/admin/hqViewFranchiseStudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/template/select_franchise_template_fixed.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;

class SelectFranchiseToViewAllStudents extends StatefulWidget {
  static const String id = '/SelectFranchiseToViewAllStudents';

  @override
  _SelectFranchiseToViewAllStudentsState createState() =>
      _SelectFranchiseToViewAllStudentsState();

  Future retrievedFranchises;
}

class _SelectFranchiseToViewAllStudentsState
    extends State<SelectFranchiseToViewAllStudents> {
  @override
  void initState() {
    targetAdminId = _auth.currentUser.uid;
    widget.retrievedFranchises = callFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectFranchiseTemplateFixed(
        franchiseFab: null,
        franchiseContentTitle:
            'Please select the franchise that you want to view the students:',
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
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HQViewFranchiseStudents(
                                                    franchiseId: snapshot
                                                        .data[index]
                                                        .franchiseId,
                                                    franchiseName: snapshot
                                                        .data[index]
                                                        .franchiseName,
                                                  )));
                                    })),
                          );
                        })
                  ],
                ),
              );
            }));
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
