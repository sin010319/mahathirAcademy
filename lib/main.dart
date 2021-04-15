import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/amend_exp.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/view_franchise_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/selectFranchiseForLeaderBoard.dart';
import 'package:mahathir_academy_app/screens/admin/HQAdmin_navigation.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/view_coaches_students.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'screens/admin/admin_login_screen.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'screens/coach/select_class.dart';
import 'package:mahathir_academy_app/screens/leaderboard.dart';
import 'package:mahathir_academy_app/screens/login_screen.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'screens/coach/view_students.dart';
import 'package:mahathir_academy_app/screens/announcement.dart';
import 'package:mahathir_academy_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/coach/award_exp.dart';
import 'package:mahathir_academy_app/screens/student/student_navigation.dart';
import 'screens/admin/franchiseAdmin_navigation.dart';
import 'screens/HQAdmin/franchise/view_franchise_screen.dart';
import 'screens/FranchiseAdmin/class/view_class_screen.dart';
import 'screens/student/student_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mahathir Academy of PUBLIC SPEAKING",
      theme: ThemeData(primaryColor: Color(0xFF8A1501)),
      initialRoute: 'splash_screen',
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        AdminLoginScreen.id: (context) => AdminLoginScreen(),
        ViewClassScreen.id: (context) => ViewClassScreen(),
        ViewAdminScreen.id: (context) => ViewAdminScreen(),
        ViewCoachStudent.id: (context) => ViewCoachStudent(),
        Leaderboard.id: (context) => Leaderboard(),
        franchiseAdminNavigation.id: (context) => franchiseAdminNavigation(),
        HQAdminNavigation.id: (context) => HQAdminNavigation(),
        ViewFranchiseScreen.id: (context) => ViewFranchiseScreen(),
        AmendExpScreen.id: (context) => AmendExpScreen(),
        CoachNavigation.id: (context) => CoachNavigation(),
        StudentNavigation.id: (context) => StudentNavigation(),
        StudentProfile.id: (context) => StudentProfile(),
        CoachProfile.id: (context) => CoachProfile(),
        ViewStudents.id: (context) => ViewStudents(),
        Announcement.id: (context) => Announcement(),
        AwardExp.id: (context) => AwardExp(),
        Category.id: (context) => Category(),
        SelectFranchiseForLeaderBoard.id: (context) => SelectFranchiseForLeaderBoard()
      },
    );
  }
}


