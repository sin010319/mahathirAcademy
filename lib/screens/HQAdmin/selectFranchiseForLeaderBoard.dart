import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/template/SelectFranchiseTemplate.dart';
import 'package:mahathir_academy_app/template/category_template.dart';
import 'package:mahathir_academy_app/template/select_class_template.dart';

class SelectFranchiseForLeaderBoard extends StatefulWidget {

  FloatingActionButton fab;
  Function function;
  Function myItemBuilder;

  static const String id = '/selectFranchiseForLeaderBoard';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _SelectFranchiseForLeaderBoardState createState() => _SelectFranchiseForLeaderBoardState();
}

class _SelectFranchiseForLeaderBoardState extends State<SelectFranchiseForLeaderBoard> {

  @override
  Widget build(BuildContext context) {
    return SelectFranchiseTemplate(
        fab: null,
        myItemBuilder: (context, index) {
          return Card(
            child: Center(
                child: ListTile(
                    title: Text(
                        widget.franchises[index]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectClassTemplate(
                                textForDisplay: "Please select the class that you want to view the leaderboard: ",
                                function: (){
                                  Navigator.pushNamed(context, Category.id);
                                }),
                          ));
                    }
                )
            ),
          );
        }
    );
  }
}



