import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';

class SelectViewTemplate extends StatefulWidget {

  FloatingActionButton fab;
  String appBarTitle;
  String imageIconLocation;
  FutureBuilder contentTitleBuilder;
  FutureBuilder myFutureBuilder;

  SelectViewTemplate({this.fab, this.appBarTitle, this.imageIconLocation, this.contentTitleBuilder, this.myFutureBuilder});

  static const String id = '/SelectViewTemplate';

  @override
  _SelectViewTemplateState createState() => _SelectViewTemplateState();
}

class _SelectViewTemplateState extends State<SelectViewTemplate> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.fab,
        appBar: AppBar(title: Text(widget.appBarTitle)),
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
                    backgroundImage: AssetImage(widget.imageIconLocation),
                    radius: 30.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  widget.contentTitleBuilder
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
                      child: ListView(
                          children: [
                            SizedBox(height: 10.0,),
                            widget.myFutureBuilder
                          ]
                      )
                  )
              )
            ]
        )
    );
  }
}

