import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/admin/viewFranchiseStudents.dart';
import 'package:mahathir_academy_app/template/select_franchise_template.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';

class SelectFranchiseToViewAllStudents extends StatefulWidget {

  FloatingActionButton fab;
  Function function;
  Function myItemBuilder;

  static const String id = '/SelectFranchiseToViewAllStudents';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _SelectFranchiseToViewAllStudentsState createState() => _SelectFranchiseToViewAllStudentsState();
}

class _SelectFranchiseToViewAllStudentsState extends State<SelectFranchiseToViewAllStudents> {

  @override
  Widget build(BuildContext context) {
    return SelectFranchiseTemplate(
        franchiseFab: null,
        contentTitle: 'Please select the franchise that you want to view the students:',
        franchiseItemBuilder: (context, index) {
          return Card(
            child: Center(
                child: ListTile(
                    title: Text(
                        widget.franchises[index]),
                    onTap: () {
                      Navigator.pushNamed(context, ViewFranchiseStudents.id);
                                }),
                          )
          );
                    }
                );
        }
}



