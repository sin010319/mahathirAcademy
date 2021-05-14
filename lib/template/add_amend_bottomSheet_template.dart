import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mahathir_academy_app/constants.dart';

class AddAmendTemplate extends StatefulWidget {
  String identifier;
  List<Widget> content;
  String title1 = '';
  String title2 = '';
  bool isTransfer = false;

  AddAmendTemplate({this.identifier, this.content});
  AddAmendTemplate.fromTemplate(
      {this.identifier, this.content, this.title1, this.title2});
  AddAmendTemplate.transferTemplate(
      {this.identifier,
      this.content,
      this.isTransfer,
      this.title1,
      this.title2});
  AddAmendTemplate.editTemplate({this.identifier, this.content, this.title1});

  @override
  _AddAmendTemplateState createState() => _AddAmendTemplateState();
}

class _AddAmendTemplateState extends State<AddAmendTemplate> {
  bool isTransfer = false;

  @override
  void initState() {
    this.isTransfer = widget.isTransfer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title;
    List<Widget> pageSpecificContent = [];

    if (widget.identifier == 'Amend Coach Info' ||
        widget.identifier == 'Amend Student Info' ||
        widget.identifier == 'Amend Franchise' ||
        widget.identifier == 'Amend Class' ||
        widget.identifier == 'Amend Admin Info') {
      title = widget.identifier;
    } else {
      if (!isTransfer) {
        title = 'Add New ' + widget.identifier;
      } else {
        title = 'Transfer ' + widget.identifier;
      }
    }

    List<Widget> studentCoachInputContent = [
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          this.widget.title1,
          style: kTitleTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          this.widget.title2,
          style: kTitleTextStyle,
        ),
      )
    ];

    List<Widget> editStudentCoachInputContent = [
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          this.widget.title1,
          style: kTitleTextStyle,
        ),
      ),
    ];

    List<Widget> franchiseClassInputContent = [
      SizedBox(
        height: 20.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          this.widget.title1,
          style: kTitleTextStyle,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          this.widget.title2,
          style: kTitleTextStyle,
        ),
      )
    ];

    if (widget.identifier == 'Student' ||
        widget.identifier == 'Coach' ||
        widget.identifier == 'Facilitator') {
      pageSpecificContent = studentCoachInputContent;
    } else if (widget.identifier == 'Amend Coach Info' ||
        widget.identifier == 'Amend Student Info' ||
        widget.identifier == 'Amend Admin Info') {
      pageSpecificContent = editStudentCoachInputContent;
    } else if (widget.identifier == 'Class' ||
        widget.identifier == 'Amend Class') {
      pageSpecificContent = franchiseClassInputContent;
    } else if (widget.identifier == 'Admin') {
      pageSpecificContent = franchiseClassInputContent;
    } else {
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
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Color(0xFF8A1501),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ] +
              pageSpecificContent +
              widget.content,
        ),
      ),
    );
  }
}
