import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/view_franchise_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/view_franchise_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/select_franchise_for_leaderboard.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/select_franchise_to_view_all_students.dart';
import 'package:mahathir_academy_app/template/select_franchise_template.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../student/student_profile.dart';
import '../coach/view_students.dart';
import '../leaderboard.dart';
import '../announcement.dart';

class HQAdminNavigation extends StatelessWidget {
  static const String id = '/HQadmin';

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
                title: Text('HQ Admin Dashboard'),
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  // First button - decrement
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
                ]),
            body: Container(
              margin: EdgeInsets.only(
                  top: 80.0, bottom: 80.0, right: 25.0, left: 25.0),
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
                              Navigator.pushNamed(context, Announcement.id);
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
}
