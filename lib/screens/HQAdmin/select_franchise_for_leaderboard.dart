import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/franchise.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/coach/select_class.dart';
import 'package:mahathir_academy_app/template/select_franchise_template.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/template/select_franchise_template_fixed.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String targetAdminId;

class SelectFranchiseForLeaderBoard extends StatefulWidget {

  FloatingActionButton fab;
  Function function;
  Function myItemBuilder;

  static const String id = '/selectFranchiseForLeaderBoard';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _SelectFranchiseForLeaderBoardState createState() => _SelectFranchiseForLeaderBoardState();

  Future retrievedFranchises;
}

class _SelectFranchiseForLeaderBoardState extends State<SelectFranchiseForLeaderBoard> {

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
        franchiseContentTitle: 'Please select the franchise that you want to view the student ranking:',
        franchiseItemBuilder: FutureBuilder(
            future: widget.retrievedFranchises,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
                print('error3');
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
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
                                        builder: (context) => SelectClass(
                                          textForDisplay: "'Please select the class that you want to view the student ranking:",
                                            classFunction: (){
                                            Navigator.pushNamed(context, Category.id);}
                                        )));
                              }
                          )
                      ),
                    );
                  });
            })
    );
  }

  Future<List<Franchise>> franchiseData() async {
    String franchiseId;
    String franchiseName;
    String franchiseLocation;
    List<Franchise> franchisesList = [];

    await _firestore.collection('franchiseAdmins')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        franchiseName = doc["franchiseName"];
        franchiseId = doc["franchiseId"];
        franchiseLocation= doc["franchiseLocation"];
        Franchise newFranchise = Franchise(franchiseName, franchiseLocation, franchiseId);
        franchisesList.add(newFranchise);
      });
    });

    return franchisesList;
  }

  Future callFunc() async {
    return await franchiseData();
  }

}



