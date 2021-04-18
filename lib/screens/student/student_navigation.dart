import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/template/category_template.dart';

import 'student_profile.dart';
import '../coach/view_students.dart';
import '../leaderboard.dart';
import '../announcement.dart';

class StudentNavigation extends StatelessWidget {

  static const String id = '/student';

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
          body: Container(
            margin: EdgeInsets.only(top: 80.0, bottom: 80.0, right: 25.0, left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // make the items in each row to stretch itself to fit as much space in the screen
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      Navigator.pushNamed(context, Category.id);
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
                            Navigator.pushNamed(context, StudentProfile.id);
                          },
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
          )

      ),
    );
  }
}
