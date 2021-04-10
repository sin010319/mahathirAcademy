import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../student_profile.dart';
import '../view_exp.dart';
import '../select_class.dart';
import '../leaderboard.dart';
import '../announcement.dart';

class Student extends StatelessWidget {

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // make the items in each row to stretch itself to fit as much space in the screen
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ReusableCard(
                        onPress: () {
                          Navigator.pushNamed(context, StudentProfile.id);
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
                  ],
                ),
              ),
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    Navigator.pushNamed(context, Leaderboard.id);
                  },
                  colour: Colors.white,
                  cardChild: IconContent(
                    icon: FontAwesomeIcons.trophy,
                    label: 'LEADERBOARD',
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
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
