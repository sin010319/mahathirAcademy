import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/add_coach.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/view_franchise_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/admin/viewFranchiseStudents.dart';
import 'package:mahathir_academy_app/screens/announcement/franchiseAnnouncement.dart';
import 'package:mahathir_academy_app/screens/coach/select_class.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'package:mahathir_academy_app/template/coachFranchiseCategory.dart';
import 'package:mahathir_academy_app/template/franchiseBasedCategory.dart';
import 'package:mahathir_academy_app/template/franchiseCategory.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../student/student_profile.dart';
import '../coach/view_students.dart';
import '../leaderboard.dart';
import '../announcement/announcement.dart';

class franchiseAdminNavigation extends StatelessWidget {
  static const String id = '/franchiseAdmin';

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
                  title: Text('Franchise Admin Dashboard'),
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
              body: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // make the items in each row to stretch itself to fit as much space in the screen
                children: <Widget>[
                  Expanded(
                      child: Row(children: <Widget>[
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          Navigator.pushNamed(context, AddCoachScreen.id);
                        },
                        colour: Colors.white,
                        cardChild: IconContent(
                          icon: FontAwesomeIcons.chalkboardTeacher,
                          label: 'VIEW FRANCHISE COACHES',
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          Navigator.pushNamed(
                              context, ViewFranchiseStudents.id);
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
                    child: ReusableCard(
                      onPress: () {
                        Navigator.pushNamed(context, FranchiseBasedCategory.id);
                      },
                      colour: Colors.white,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.trophy,
                        label: 'STUDENT RANKING',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ReusableCard(
                            onPress: () {
                              Navigator.pushNamed(context, ViewClassScreen.id);
                            },
                            colour: Colors.white,
                            cardChild: IconContent(
                              icon: FontAwesomeIcons.tools,
                              label: 'FRANCHISE ADMIN PRIVILEGE',
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            onPress: () {
                              Navigator.pushNamed(
                                  context, FranchiseAnnouncement.id);
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
            )));
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }
}
