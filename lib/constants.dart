import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const kBottomContainerHeight = 80.0;
const kActiveCardColour = Color(0xFF1D1E33);
const kInactiveCardColour =
    Color(0xFF111328); // this is the color of the card when it is tapped
const kBottomContainerColour = Color(0xFFEB1555);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFFB11B01),
);

const kNumberTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kCoachStudentLabelTextStyle = TextStyle(
    fontSize: 25.0, fontWeight: FontWeight.bold, color: Color(0xFF8A1501));

const kExpTextStyle = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.redAccent);

const kMethodDropdownTextStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.black);

const kListItemsTextStyle = TextStyle(
  fontSize: 18.0,
);

const kTitleTextStyle = TextStyle(
    color: Color(0xFF8A1501), fontWeight: FontWeight.w700, fontSize: 23.0);

const kSubtitleTextStyle = TextStyle(
    color: Color(0xFF8A1501), fontWeight: FontWeight.w600, fontSize: 20.0);

const kTimestampSubtitleTextStyle = TextStyle(fontSize: 12.0);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Color(0xFF8A1501), width: 2.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kSendButtonTextStyle = TextStyle(
  color: Color(0xFF8A1501),
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kDropdownTitleTextStyle =
    TextStyle(fontSize: 16.0, color: Color(0xFF5E5E5E));

const kChipTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
);
