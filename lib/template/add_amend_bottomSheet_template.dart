import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mahathir_academy_app/constants.dart';

class AddAmendTemplate extends StatelessWidget {

  String identifier;
  List<Widget> content;

  AddAmendTemplate({this.identifier, this.content});

  @override
  Widget build(BuildContext context) {

    String title;
    List<Widget> pageSpecificContent = [];

    if (identifier == 'Amend EXP' || identifier == 'Amend Franchise' || identifier == 'Amend Class' || identifier == 'Amend Admin Info'){
      title = identifier;
    }
    else{
      title = 'Add New ' + identifier;
    }

    List <Widget> studentCoachInputContent = [
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Franchise1 ',
          style: kTitleTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Class1 ',
          style: kTitleTextStyle,
        ),
      )
    ];

    List <Widget> franchiseClassInputContent = [
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Franchise1 ',
          style: kTitleTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Location ',
          style: kTitleTextStyle,
        ),
      )
    ];


    if (identifier == 'Student' || identifier == 'Amend EXP' || identifier == 'Coach' || identifier == 'Facilitator'){
      pageSpecificContent = studentCoachInputContent;
    }
    else if (identifier == 'Class' || identifier == 'Amend Class'){
      pageSpecificContent = franchiseClassInputContent;
    }
    else if (identifier == 'Admin' || identifier == 'Amend Admin Info'){
      pageSpecificContent = franchiseClassInputContent;
    }
    else{
      pageSpecificContent = [];
    }

    return Container(
      color: Colors.red,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          children: <Widget>[
            Text(
              title, // task name
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0, color: Color(0xFF8A1501), fontWeight: FontWeight.w800,),
            ),
            SizedBox(
              height: 10.0,
            ),]
          + pageSpecificContent
          + content,
        ),
      ),
    );
  }
}
