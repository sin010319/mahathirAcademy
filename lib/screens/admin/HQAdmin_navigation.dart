import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/view_franchise_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/select_franchise_for_leaderboard.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/select_franchise_to_view_all_students.dart';
import 'package:mahathir_academy_app/screens/announcement/hqadminAnnouncement.dart';
import 'package:mahathir_academy_app/screens/change_password_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String hqAdminId;

class HQAdminNavigation extends StatefulWidget {
  static const String id = '/HQadmin';

  @override
  _HQAdminNavigationState createState() => _HQAdminNavigationState();
}

class _HQAdminNavigationState extends State<HQAdminNavigation> {
  @override
  void initState() {
    hqAdminId = _auth.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.white,
              Color(0xFFDB5D38),
              Color(0xFFDB5D38),
              Color(0xFFE78466),
              Colors.white
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
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
                      child: Text('Home',
                          style: TextStyle(
                            fontSize: 13.5.sp,
                          )),
                    )
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.key),
                  onPressed: () {
                    showModal();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.logout), // The "-" icon
                  onPressed: () {
                    String message = 'Are you sure you want to log out?';
                    PopUpDialogClass.popUpDialog(message, context, () {
                      logout(context);
                    }, () {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  },
                ),
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(
                  top: 8.0.h, bottom: 8.0.h, right: 2.0.w, left: 2.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // make the items in each row to stretch itself to fit as much space in the screen
                children: <Widget>[
                  Expanded(
                      child: Row(children: <Widget>[
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          Navigator.pushNamed(
                              context, SelectFranchiseForLeaderBoard.id);
                        },
                        colour: Colors.white,
                        cardChild: IconContent(
                          icon: FontAwesomeIcons.trophy,
                          label: 'STUDENT RANKING',
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          Navigator.pushNamed(
                              context, SelectFranchiseToViewAllStudents.id);
                        },
                        colour: Colors.white,
                        cardChild: IconContent(
                          icon: FontAwesomeIcons.users,
                          label: 'VIEW FRANCHISE STUDENTS',
                        ),
                      ),
                    ),
                  ])),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ReusableCard(
                            onPress: () {
                              Navigator.pushNamed(
                                  context, ViewFranchiseScreen.id);
                            },
                            colour: Colors.white,
                            cardChild: IconContent(
                              icon: FontAwesomeIcons.tools,
                              label: 'HQ ADMIN PRIVILEGE',
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            onPress: () {
                              Navigator.pushNamed(
                                  context, HQAdminAnnouncement.id);
                            },
                            // USE TERNARY OPERATOR HERE
                            // CHANGE THE COLOR OF CARD WHEN SWITCHING BETWEEN TAPPING
                            colour: Colors.white,
                            cardChild: IconContent(
                              icon: FontAwesomeIcons.scroll,
                              label: 'ANNOUNCEMENT',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  void showModal() {
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: changePasswordBottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    print('modal closed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }
}

Widget changePasswordBottomSheet(BuildContext context) {
  String identifier = 'Change Password hqAdmin';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: ChangePasswordBottomSheet(
        identifier: identifier,
        userId: hqAdminId,
      ),
    ),
  );
}
