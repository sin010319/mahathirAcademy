import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/coach/award_exp.dart';
import 'package:mahathir_academy_app/screens/coach/select_class.dart';
import 'package:mahathir_academy_app/screens/coach/select_class_general.dart';
import 'package:mahathir_academy_app/template/category_template.dart';

import '../student/student_profile.dart';
import 'view_students.dart';
import '../leaderboard.dart';
import '../announcement.dart';
import 'coach_profile.dart';

class CoachNavigation extends StatelessWidget {

  static const String id = '/coach';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFDB5D38), Color(0xFFDB5D38), Color(0xFFE78466), Colors.white])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Home'),
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
                                builder: (context) => SelectClassGeneral(
                                    textForDisplay: "Please select the class that you want to view the students: ",
                                    )),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectClass(
                              textForDisplay: "Please select the class that you want to view the student ranking: ",
                              classFunction: (){
                                Navigator.pushNamed(context, Category.id);
                              }),
                        ));
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
    );
  }
}
