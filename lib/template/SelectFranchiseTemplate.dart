import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';

class SelectFranchiseTemplate extends StatefulWidget {

  FloatingActionButton fab;
  Function myItemBuilder;

  SelectFranchiseTemplate({this.fab, this.myItemBuilder});

  static const String id = '/selectFranchiseTemplate';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _SelectFranchiseTemplateState createState() => _SelectFranchiseTemplateState();
}

class _SelectFranchiseTemplateState extends State<SelectFranchiseTemplate> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.fab,
        appBar: AppBar(
            title: Text('Franchises')),
        backgroundColor: Color(0xFFDB5D38),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // wrap the icon in a circle avatar
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/icons/franchise.png"),
                    radius: 30.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${widget.franchises.length} Franchises: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0
                    ),
                  ),
                ],
              ),
            ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // container must have a child to get shown up on screen
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)
                          )
                      ),
                      child: Column(
                          children: [
                            SizedBox(height: 10.0,),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.franchises.length,
                                itemBuilder: widget.myItemBuilder
                            )
                          ]
                      )
                  )
              )
            ]
        )
    );
  }
}



