import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';
import 'package:mahathir_academy_app/template/select_franchise_template.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';
import 'package:mahathir_academy_app/template/select_student_template.dart';

class ViewFranchiseStudents extends StatefulWidget {

  FloatingActionButton fab;
  Function function;
  Function myItemBuilder;

  static const String id = '/ViewFranchiseStudents';
  List<String> students = ['Student1', 'Student2', 'Student3'];
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  @override
  _ViewFranchiseStudentsState createState() => _ViewFranchiseStudentsState();
}

class _ViewFranchiseStudentsState extends State<ViewFranchiseStudents> {

  @override
  Widget build(BuildContext context) {
    return SelectStudentTemplate(
        studentContentTitle: 'Franchise1 \n${widget.students.length} Students',
        studentItemBuilder: (context, index) {
          return Card(
            child: Center(
                child: ListTile(
                    title: Text(
                        widget.students[index]),
                    trailing: Text(
                      widget.classes[index],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, StudentProfile.id);
                    }
                )
            ),
          );
        }
    );
  }
}



