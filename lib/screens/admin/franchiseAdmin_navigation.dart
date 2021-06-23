import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/reusable_card.dart';
import 'package:mahathir_academy_app/components/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/add_coach.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/admin/viewFranchiseStudents.dart';
import 'package:mahathir_academy_app/screens/announcement/franchiseAnnouncement.dart';
import 'package:mahathir_academy_app/template/franchiseBasedCategory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import '../change_password_bottom_sheet.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String franchiseAdminId;

class franchiseAdminNavigation extends StatefulWidget {
  static const String id = '/franchiseAdmin';

  @override
  _franchiseAdminNavigationState createState() =>
      _franchiseAdminNavigationState();
}

class _franchiseAdminNavigationState extends State<franchiseAdminNavigation> {
  @override
  void initState() {
    franchiseAdminId = _auth.currentUser.uid;
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
                          label: 'CREATE AND VIEW FRANCHISE COACHES',
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
                          label: 'CREATE AND VIEW FRANCHISE STUDENTS',
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
  String identifier = 'Change Password franchiseAdmin';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: ChangePasswordBottomSheet(
        identifier: identifier,
        userId: franchiseAdminId,
      ),
    ),
  );
}
