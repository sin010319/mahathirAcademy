import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/screens/coach/select_class_view_students.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/coach/award_exp.dart';
import 'package:mahathir_academy_app/screens/coach/select_class.dart';
import 'package:mahathir_academy_app/screens/coach/select_class_general.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/template/coachesCategory.dart';
import '../student/student_profile.dart';
import 'view_students.dart';
import '../leaderboard.dart';
import '../announcement/announcement.dart';
import 'coach_profile.dart';

class CoachNavigation extends StatelessWidget {

  static const String id = '/coach';

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFDB5D38), Color(0xFFDB5D38), Color(0xFFE78466), Colors.white])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Home'),
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  // First button - decrement
                  IconButton(
                    icon: Icon(Icons.logout), // The "-" icon
                    onPressed: (){popUpDialog(context);}, // The `_decrementCounter` function
                  ),
                ]
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // make the items in each row to stretch itself to fit as much space in the screen
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ReusableCard(
                          onPress: () {
                            Navigator.pushNamed(context, CoachProfile.id);
                          },
                          // USE TERNARY OPERATOR HERE
                          // CHANGE THE COLOR OF CARD WHEN SWITCHING BETWEEN TAPPING
                          colour: Colors.white,
                          cardChild: IconContent(
                            icon: FontAwesomeIcons.idCard,
                            label: 'MY PROFILE',
                          ),
                        ),
                      ),
                      Expanded(
                        child: ReusableCard(
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectClassViewStudents(
                                      textForDisplay: "Please select the class that you want to view the students: ",),
                                )
                            );
                          },
                          // USE TERNARY OPERATOR HERE
                          // CHANGE THE COLOR OF CARD WHEN SWITCHING BETWEEN TAPPING
                          colour: Colors.white,
                          cardChild: IconContent(
                            icon: FontAwesomeIcons.eye,
                            label: 'VIEW MY STUDENTS',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      Navigator.pushNamed(
                          context, coachesCategory.id);
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectClassGeneral(
                                    textForDisplay: "Please select the class you want to award EXP or acknowledgment to: "),
                                ));
                          },
                          // USE TERNARY OPERATOR HERE
                          // CHANGE THE COLOR OF CARD WHEN SWITCHING BETWEEN TAPPING
                          colour: Colors.white,
                          cardChild: IconContent(
                            icon: FontAwesomeIcons.award,
                            label: 'AWARD EXP\nand\nACKNOWLEDGEMENT',
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
            )

        ),
      ),
    );
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
          logout(context);
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

  logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }
}
