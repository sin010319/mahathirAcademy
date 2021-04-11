import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahathir_academy_app/screens/select_class.dart';
import 'package:mahathir_academy_app/screens/leaderboard.dart';
import 'package:mahathir_academy_app/screens/login_screen.dart';
import 'package:mahathir_academy_app/screens/coach/coach.dart';
import 'package:mahathir_academy_app/screens/student_profile.dart';
import 'package:mahathir_academy_app/screens/view_exp.dart';
import 'package:mahathir_academy_app/screens/announcement.dart';
import 'package:mahathir_academy_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mahathir_academy_app/screens/award_exp.dart';
import 'package:mahathir_academy_app/screens/student/student.dart';

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
        SelectClass.id: (context) => SelectClass(),
        Leaderboard.id: (context) => Leaderboard(),
        Coach.id: (context) => Coach(),
        Student.id: (context) => Student(),
        StudentProfile.id: (context) => StudentProfile(),
        ViewExp.id: (context) => ViewExp(),
        Announcement.id: (context) => Announcement(),
        AwardExp.id: (context) => AwardExp()
      },
    );
  }
}


