import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:sizer/sizer.dart';

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
    } else if (widget.identifier.contains("Change Password")) {
      title = "Change Password";
    } else {
      if (!isTransfer) {
        title = 'Add New ' + widget.identifier;
      } else {
        title = 'Transfer ' + widget.identifier;
      }
    }

    List<Widget> commonInputContent = [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          this.widget.title1,
          style: kTitleTextStyle,
        ),
      ),
      SizedBox(
        height: 1.0.h,
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
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          this.widget.title1,
          style: kTitleTextStyle,
        ),
      ),
    ];

    if (widget.identifier == 'Student' ||
        widget.identifier == 'Coach' ||
        widget.identifier == 'Facilitator' ||
        widget.identifier == 'Amend Class' ||
        widget.identifier == 'Admin') {
      pageSpecificContent = commonInputContent;
    } else if (widget.identifier == 'Amend Coach Info' ||
        widget.identifier == 'Amend Student Info' ||
        widget.identifier == 'Amend Admin Info') {
      pageSpecificContent = editStudentCoachInputContent;
    } else {
      pageSpecificContent = [];
    }

    return Container(
      color: Colors.red,
      child: Container(
          padding: EdgeInsets.all(10.0.sp),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0.sp),
                  topRight: Radius.circular(20.0.sp))),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                    Text(
                      title, // task name
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23.0.sp,
                        color: Color(0xFF8A1501),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                  ] +
                  pageSpecificContent +
                  widget.content,
            ),
          )),
    );
  }
}
