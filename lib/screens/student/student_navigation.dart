import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/announcement/studentAnnouncement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/template/studentCategory.dart';

import 'student_profile.dart';
import 'package:sizer/sizer.dart';

class StudentNavigation extends StatelessWidget {
  static const String id = '/student';

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
                    child: ReusableCard(
                      onPress: () {
                        Navigator.pushNamed(context, StudentCategory.id);
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
                              Navigator.pushNamed(
                                  context, StudentAnnouncement.id);
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
