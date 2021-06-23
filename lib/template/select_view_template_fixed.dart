import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            child: Row(
              children: [
                Image.asset("assets/images/brand_logo.png",
                    fit: BoxFit.contain, height: 5.5.h),
                SizedBox(
                  width: 1.5.w,
                ),
                Flexible(
                  child: Text(widget.appBarTitle,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                      )),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xFFDB5D38),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // wrap the icon in a circle avatar
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(widget.imageIconLocation),
                      radius: 25.0.sp,
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Text(
                      widget.contentTitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5.sp),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      // container must have a child to get shown up on screen
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0.sp),
                              topRight: Radius.circular(20.0.sp))),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        SizedBox(
                          height: 1.0.h,
                        ),
                        widget.myFutureBuilder
                      ]))))
            ]));
  }
}
