import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';

class SelectViewTemplateFixed extends StatefulWidget {
  FloatingActionButton fab;
  String appBarTitle;
  String imageIconLocation;
  String contentTitle;
  FutureBuilder myFutureBuilder;

  SelectViewTemplateFixed(
      {this.fab,
      this.appBarTitle,
      this.imageIconLocation,
      this.contentTitle,
      this.myFutureBuilder});

  static const String id = '/SelectViewTemplateFixed';

  @override
  _SelectViewTemplateFixedState createState() =>
      _SelectViewTemplateFixedState();
}

class _SelectViewTemplateFixedState extends State<SelectViewTemplateFixed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.fab,
        appBar: AppBar(title: Text(widget.appBarTitle)),
        backgroundColor: Color(0xFFDB5D38),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
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
                    Text(
                      widget.contentTitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0),
                    )
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
                              topRight: Radius.circular(20.0))),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        widget.myFutureBuilder
                      ]))))
            ]));
  }
}
