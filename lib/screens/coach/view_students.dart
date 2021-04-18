import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';
import 'package:mahathir_academy_app/template/select_student_template.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';

String identifier;

class ViewStudents extends StatefulWidget {

  static const String id = '/viewStudents';
  List<String> students = ['Student1', 'Student2', 'Student3'];
  List<int> exp = [230, 40, 100];

  @override
  _ViewStudentsState createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {

  @override
  Widget build(BuildContext context) {

    return SelectStudentTemplate(
        studentContentTitle: 'Franchise1 \nClass1',
      studentItemBuilder: (context, index) {
        return Card(
          child: Center(
            child: ListTile(
              title: Text(widget.students[index],
                  style: kListItemsTextStyle),
              trailing: Wrap(
                spacing: 8,
                children: [
                  Container(
                      child: Text(widget.exp[index].toString(),
                          style: kExpTextStyle)
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, StudentProfile.id);
              },
            ),
          ),
        );
      }
    );
  }
}



